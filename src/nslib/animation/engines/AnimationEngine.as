/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.animation.engines
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import nslib.animation.DeltaTime;
	import nslib.animation.EasingFunction;
	import nslib.animation.events.AnimationEvent;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.animation.events.EffectEvent;
	import nslib.animation.LineDrawer;
	import nslib.controls.NSSprite;
	import nslib.core.Globals;
	import nslib.utils.ArrayList;
	import nslib.utils.ObjectsPoolUtil;
	
	//--------------------------------------------------------------------------
	//
	//  Events
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Dispatched when the whole animation chane specified in AnimationEngine has finished.
	 */
	[Event(name="animationCompleted",type="com.esri.loc.ui.dataMapping.components.dataDriller.events.AnimationEvent")]
	
	/**
	 * AnimationEngine class provides methods to animate components. The workflow is based on a timeline.
	 * You should assign actions to certain points of time (staringTime). All actions are stored in a stack and wait for a specifed time point.
	 * Timeline starts as soons as AnimationEngine class object is created.
	 * You may reset the timeline and clear the stack by calling the reset() function. To assign a finishing time point call finishAnimationAt(startingTime:Number) function.
	 * This function will make AnimationEngine object dispatch AnimationEvent.ANIMATION_COMPLETED.
	 */
	public class AnimationEngine extends EventDispatcher
	{
		// Global instance of the animation engine. Do not call the reset() method of this object.
		public static var globalAnimator:AnimationEngine;
		
		public static function generateIndependentInstance(container:NSSprite = null):AnimationEngine
		{
			var deltaTime:DeltaTime = new DeltaTime(container ? container : Globals.stage);
			var ae:AnimationEngine = new AnimationEngine();
			ae.customDeltaTimeCounter = deltaTime;
			
			return ae;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constants: Animation flags
		//
		//--------------------------------------------------------------------------
		
		private const DRAW_LINE:String = "drawLine";
		
		private const ADD_TO_PARENT:String = "addToParent";
		
		private const REMOVE_FROM_PARENT:String = "removeFromParent";
		
		private const MOUSE_ENABLE:String = "mouseEnable";
		
		private const MOUSE_DISABLE:String = "mouseDisable";
		
		private const EXECUTE_FUNCTION:String = "executeFunction";
		
		private const ANIMATE_PROPERTY:String = "animatePropety";
		
		private const ANIMATION_CHAIN_COMPLETE:String = "animationChaneComplete";
		
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		private var deltaTimeCounter:DeltaTime = DeltaTime.globalDeltaTimeCounter;
		
		private var propertyAnimator:PropertyAnimator;
		
		private var lineDrawer:LineDrawer;
		
		private var animationStack:ArrayList = new ArrayList();
		
		private var bundle:AnimationBundle;
		
		private var playingEffectsStack:ArrayList = new ArrayList();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates an instance of AnimationEngine class.
		 *
		 */
		public function AnimationEngine()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters and Setters
		//
		//--------------------------------------------------------------------------
		
		private var _currentTime:Number = 0;
		
		public function get currentTime():Number
		{
			return _currentTime;
		}
		
		//////////
		
		private var customDeltaTimeCounterIsAssigned:Boolean = false;
		
		// by default all animator are dependent on one global delta time counter,
		// which allows global control over the animation process (speed, start, pause, etc.),
		// but you can set your own one to have an indipendent animator
		public function set customDeltaTimeCounter(value:DeltaTime):void
		{
			// clear the existing one
			if (deltaTimeCounter)
				deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTime_eventHandler);
			
			deltaTimeCounter = value;
			customDeltaTimeCounterIsAssigned = true;
			reset();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * resets timeline and clears the animation stack. Timeline starts immediately from the 0 time point.
		 *
		 */
		public function reset():void
		{
			if (!deltaTimeCounter)
				return;
			
			deltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTime_eventHandler);
			
			_currentTime = 0;
			animationStack.removeAll();
			
			for each (var obj:*in playingEffectsStack.source)
			{
				EventDispatcher(obj).removeEventListener(EffectEvent.EFFECT_ENDED, effectEndHandler);
				obj.stop();
				ObjectsPoolUtil.returnObject(obj);
			}
			
			playingEffectsStack.removeAll();
		}
		
		private function deltaTime_eventHandler(event:DeltaTimeEvent):void
		{
			_currentTime += deltaTimeCounter.dT;
			checkStack();
			iteratePropertyAnimators(deltaTimeCounter.dT);
		}
		
		private var bundlesToRemove:Array = [];
		private var bundlesToAdd:Array = [];
		
		private function checkStack():void
		{
			var wasLocked:Boolean = animationStack.locked;
			animationStack.locked = true;
			
			for each (var bundle:AnimationBundle in animationStack.source)
			{
				if (_currentTime < bundle.startingTime)
					continue;
				
				if ((bundle.obj is LineDrawer) && (bundle.effectName == DRAW_LINE))
				{
					LineDrawer(bundle.obj).play();
				}
				
				if ((bundle.obj is DisplayObject) && (bundle.effectName == ADD_TO_PARENT))
				{
					bundle.parent.addChild(bundle.obj as DisplayObject);
				}
				
				if ((bundle.obj is DisplayObject) && (bundle.effectName == REMOVE_FROM_PARENT))
				{
					if (bundle.parent.contains(bundle.obj as DisplayObject))
						bundle.parent.removeChild(bundle.obj as DisplayObject);
				}
				
				if ((bundle.obj is InteractiveObject) && (bundle.effectName == MOUSE_ENABLE))
				{
					InteractiveObject(bundle.obj).mouseEnabled = true;
				}
				
				if ((bundle.obj is InteractiveObject) && (bundle.effectName == MOUSE_DISABLE))
				{
					InteractiveObject(bundle.obj).mouseEnabled = false;
				}
				
				if ((bundle.obj == null) && (bundle.effectName == EXECUTE_FUNCTION))
				{
					if (bundle.functionToExecute != null)
					{
						if (bundle.parameters && bundle.parameters.length > 0)
							bundle.functionToExecute.apply(null, bundle.parameters);
						else
							bundle.functionToExecute();
					}
				}
				
				if ((bundle.obj is PropertyAnimator) && (bundle.effectName == ANIMATE_PROPERTY))
				{
					if (PropertyAnimator(bundle.obj).targets && PropertyAnimator(bundle.obj).targets.length > 0)
					{
						playingEffectsStack.addItem(bundle.obj);
						PropertyAnimator(bundle.obj).addEventListener(EffectEvent.EFFECT_ENDED, effectEndHandler);
						PropertyAnimator(bundle.obj).play();
					}
				}
				
				if ((bundle.obj == null) && (bundle.effectName == ANIMATION_CHAIN_COMPLETE))
				{
					this.dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETED));
					deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTime_eventHandler);
				}
				
				bundlesToRemove.push(bundle);
			}
			
			animationStack.locked = wasLocked;
			
			if (bundlesToRemove.length > 0)
			{
				animationStack.removeItems(bundlesToRemove);
				bundlesToRemove.length = 0;
			}
			
			if (bundlesToAdd.length > 0)
			{
				animationStack.addFromArray(bundlesToAdd);
				bundlesToAdd.length = 0;
			}
		}
		
		private var endedEffectsArray:Array = [];
		
		private function iteratePropertyAnimators(lastDeltaTime:Number):void
		{
			var wasLocked:Boolean = playingEffectsStack.locked;
			playingEffectsStack.locked = true;
			
			for each (var effect:*in playingEffectsStack.source)
				if (effect is PropertyAnimator)
					PropertyAnimator(effect).iterate(lastDeltaTime);
			
			playingEffectsStack.locked = wasLocked;
			checkEndedEffects();
		}
		
		private function effectEndHandler(event:EffectEvent):void
		{
			EventDispatcher(event.currentTarget).removeEventListener(EffectEvent.EFFECT_ENDED, effectEndHandler);
			
			if (Object(event.currentTarget).hasOwnProperty("targets"))
			{
				for each (var obj:Object in event.currentTarget.targets)
					if (obj is EventDispatcher)
						obj.dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_ROUTINE_COMPLETED_FOR_THIS_OBJECT));
			}
			
			if (playingEffectsStack.locked)
			{
				endedEffectsArray.push(event.currentTarget);
				return;
			}
			
			playingEffectsStack.removeItem(event.currentTarget);
			ObjectsPoolUtil.returnObject(event.currentTarget);
		}
		
		private function checkEndedEffects():void
		{
			if (!playingEffectsStack.locked && endedEffectsArray.length > 0)
			{
				for each (var effect:*in endedEffectsArray)
				{
					playingEffectsStack.removeItem(effect);
					ObjectsPoolUtil.returnObject(effect);
				}
				
				endedEffectsArray.length = 0;
			}
		}
		
		public function getPlayingAnimatorsIDsForObject(obj:Object):Array
		{
			var result:Array = [];
			
			var wasLocked:Boolean = playingEffectsStack.locked;
			playingEffectsStack.locked = true;
			
			for each (var animator:PropertyAnimator in playingEffectsStack.source)
				if (animator.hasTarget(obj))
					result.push(animator.id);
			
			playingEffectsStack.locked = wasLocked;
			
			return result;
		}
		
		public function getPlannedAnimatorsIDsForObject(obj:Object):Array
		{
			var result:Array = [];
			
			var wasLocked:Boolean = animationStack.locked;
			animationStack.locked = true;
			
			for each (var bundle:AnimationBundle in animationStack.source)
				if ((bundle.obj is PropertyAnimator) && (bundle.effectName == ANIMATE_PROPERTY))
					result.push(bundle.obj.id);
			
			animationStack.locked = wasLocked;
			
			return result;
		}
		
		// stops any animation for the specified object immediately
		public function stopAnimationForObject(obj:Object, animationIDSExclusions:Array = null):void
		{
			// first of all remove playing animators
			var wasLocked:Boolean = playingEffectsStack.locked;
			playingEffectsStack.locked = true;
			
			var exclusionsHash:Object = null;
			
			if (animationIDSExclusions)
			{
				exclusionsHash = {};
				
				for each (var id:String in animationIDSExclusions)
					exclusionsHash[id] = true;
			}
			
			for each (var animator:PropertyAnimator in playingEffectsStack.source)
				if ((!exclusionsHash || exclusionsHash[animator.id] == undefined) && animator.hasTarget(obj))
					animator.removeTarget(obj);
			
			playingEffectsStack.locked = wasLocked;
			checkEndedEffects();
			
			// then remove planned animators
			wasLocked = animationStack.locked;
			animationStack.locked = true;
			
			for each (var bundle:AnimationBundle in animationStack.source)
				if ((bundle.obj is PropertyAnimator) && (bundle.effectName == ANIMATE_PROPERTY))
					if ((!exclusionsHash || exclusionsHash[bundle.obj.id] == undefined) && bundle.obj.hasTarget(obj))
					{
						bundle.obj.removeTarget(obj);
						
						if (bundle.obj.targets.length == 0)
							bundlesToRemove.push(bundle);
					}
			
			animationStack.locked = wasLocked;
		}
		
		public function stopExecutingFunctionByID(functionID:String):void
		{
			if (functionID == null)
				return;
			
			for each (var bundle:AnimationBundle in animationStack.source)
				if (bundle.functionID == functionID)
					bundlesToRemove.push(bundle);
			
			// if the animation stack is locked these bundles will be removed next time
			// the only way the animation stack can be locked now is that an execution of a function contaiing the calling of stopExecutingFunctionByID() was requested.
			if (!animationStack.locked)
			{
				for each (var bundleToRemove:AnimationBundle in bundlesToRemove)
					animationStack.removeItem(bundleToRemove);
				
				bundlesToRemove.length = 0;
			}
		}
		
		////////////////////
		
		public function addToParent(object:DisplayObject, parent:DisplayObjectContainer, startingTime:Number = NaN):void
		{
			if (isNaN(startingTime))
				startingTime = currentTime;
			
			bundle = new AnimationBundle(object, startingTime, ADD_TO_PARENT, null, parent);
			
			if (animationStack.locked)
				bundlesToAdd.push(bundle)
			else
				animationStack.addItem(bundle);
		}
		
		public function removeFromParent(object:DisplayObject, parent:DisplayObjectContainer, startingTime:Number = NaN):void
		{
			if (isNaN(startingTime))
				startingTime = currentTime;
			
			bundle = new AnimationBundle(object, startingTime, REMOVE_FROM_PARENT, null, parent);
			
			if (animationStack.locked)
				bundlesToAdd.push(bundle)
			else
				animationStack.addItem(bundle);
		}
		
		public function executeFunction(func:Function, parameters:Array = null, startingTime:Number = NaN, functionID:String = null):void
		{
			if (isNaN(startingTime))
				startingTime = currentTime;
			
			bundle = new AnimationBundle(null, startingTime, EXECUTE_FUNCTION, func, null, parameters, functionID);
			
			if (animationStack.locked)
				bundlesToAdd.push(bundle)
			else
				animationStack.addItem(bundle);
		}
		
		private var frameId:int = 0;
		private var frameHash:Object = {};
		private var hasNewRequests:Boolean = false;
		
		public function executeOnNextFrame(func:Function, parameters:Array = null):void
		{
			hasNewRequests = true;
			
			var funcKey:String = frameId + "func";
			var paramKey:String = frameId + "param";
			
			if (frameHash[funcKey] == undefined)
				frameHash[funcKey] = [];
			
			if (frameHash[paramKey] == undefined)
				frameHash[paramKey] = [];
			
			frameHash[funcKey].push(func);
			frameHash[paramKey].push(parameters);
			
			Globals.stage.addEventListener(Event.EXIT_FRAME, nextFrameHandler);
		}
		
		public function removeFunctionFromNextFrame(functionToRemove:Function):void
		{
			var funcKey:String = frameId + "func";
			var paramKey:String = frameId + "param";
			
			if (frameHash[funcKey])
			{
				var len:int = frameHash[funcKey].length;
				
				for (var i:int = 0; i < len; i++)
				{
					var func:Function = frameHash[funcKey][i];
					
					if (func == functionToRemove)
					{
						frameHash[funcKey][i] = undefined;
						frameHash[paramKey][i] = undefined;
						break;
					}
				}
			}
		}
		
		private function nextFrameHandler(event:Event):void
		{
			var funcKey:String = frameId + "func";
			var paramKey:String = frameId + "param";
			
			frameId++;
			
			hasNewRequests = false;
			
			var len:int = frameHash[funcKey].length;
			
			for (var i:int = 0; i < len; i++)
			{
				var func:Function = frameHash[funcKey][i];
				var params:Array = frameHash[paramKey][i];
				
				if (func == null)
					continue;
				
				if (params)
					func.apply(null, params);
				else
					func();
			}
			
			delete frameHash[funcKey];
			delete frameHash[paramKey];
			
			if (!hasNewRequests)
				Globals.stage.removeEventListener(Event.EXIT_FRAME, nextFrameHandler);
		}
		
		public function mouseEnable(object:InteractiveObject, startingTime:Number = NaN):void
		{
			if (isNaN(startingTime))
				startingTime = currentTime;
			
			bundle = new AnimationBundle(object, startingTime, MOUSE_ENABLE);
			
			if (animationStack.locked)
				bundlesToAdd.push(bundle)
			else
				animationStack.addItem(bundle);
		}
		
		/**
		 * Diables mouse interraction for a component.
		 * @param object UIComponent.
		 * @param startingTime Starting time point for this action in milliseconds.
		 *
		 */
		public function mouseDisable(object:InteractiveObject, startingTime:Number = NaN):void
		{
			if (isNaN(startingTime))
				startingTime = currentTime;
			
			bundle = new AnimationBundle(object, startingTime, MOUSE_DISABLE);
			
			if (animationStack.locked)
				bundlesToAdd.push(bundle)
			else
				animationStack.addItem(bundle);
		}
		
		/**
		 * Draws a line.
		 * @param parent IVisualElementContainer to draw line on.
		 * @param xFrom xFrom.
		 * @param yFrom yFrom.
		 * @param xTo xTo.
		 * @param yTo yTo.
		 * @param duration Duration in milliseconds.
		 * @param lineColor Color of the line.
		 * @param startingTime Starting time point for this action in milliseconds. If NaN the action starts immediately.
		 *
		 */
		public function drawLine(parent:DisplayObjectContainer, xFrom:Number, yFrom:Number, xTo:Number, yTo:Number, duration:Number = 100, lineColor:int = 0, startingTime:Number = NaN):void
		{
			lineDrawer = new LineDrawer();
			lineDrawer.lineColor = lineColor;
			parent.addChild(lineDrawer);
			lineDrawer.drawLine(xFrom, yFrom, xTo, yTo, duration);
			
			if (isNaN(startingTime) || startingTime == _currentTime)
				lineDrawer.play();
			else
			{
				bundle = new AnimationBundle(lineDrawer, startingTime, DRAW_LINE);
				
				if (animationStack.locked)
					bundlesToAdd.push(bundle)
				else
					animationStack.addItem(bundle);
			}
		}
		
		public function animateProperty(objects:*, property:String, valueFrom:Number = NaN, valueTo:Number = NaN, valueBy:Number = NaN, duration:Number = 100, startingTime:Number = NaN, easingFunction:Function = null, easingEffectFactor:Number = 1, offsetFunction:Function = null, offsetFactor:Number = 1, actionName:String = null):void
		{
			animateProperties(objects, getArrayForSingleProperty(property), [valueFrom], [valueTo], [valueBy], duration, startingTime, easingFunction, easingEffectFactor, offsetFunction, offsetFactor, actionName ? actionName : property);
		}
		
		public function animateProperties(objects:*, properties:Array, valuesFrom:Array, valuesTo:Array, valuesBy:Array, duration:Number = 100, startingTime:Number = NaN, easingFunction:Function = null, easingEffectFactor:Number = 1, offsetFunction:Function = null, offsetFactor:Number = 1, actionName:String = null, animationID:String = null):void
		{
			propertyAnimator = ObjectsPoolUtil.takeObject(PropertyAnimator, null, null);
			
			propertyAnimator.actionName = actionName ? actionName : ("Modifying " + properties.join(", "));
			
			propertyAnimator.id = animationID ? animationID : (propertyAnimator.actionName + "_" + Math.random().toFixed(5));
			
			// need to assign custom delta time counter if one was set
			//if (customDeltaTimeCounterIsAssigned)
			//	propertyAnimator.customDeltaTimeCounter = deltaTimeCounter;
			
			if (objects is Array)
			{
				if ((objects as Array).length == 1)
					propertyAnimator.target = (objects as Array)[0];
				else
					propertyAnimator.targets = objects as Array;
			}
			else
				propertyAnimator.target = objects;
			
			propertyAnimator.properties = properties;
			propertyAnimator.duration = duration;
			propertyAnimator.valuesFrom = valuesFrom;
			propertyAnimator.valuesTo = valuesTo;
			propertyAnimator.valuesBy = valuesBy;
			propertyAnimator.easingEffectFactor = easingEffectFactor;
			propertyAnimator.offsetFactor = offsetFactor;
			
			if (easingFunction != null)
				propertyAnimator.easingFunction = easingFunction;
			
			if (offsetFunction != null)
				propertyAnimator.offsetFunction = offsetFunction;
			
			if (isNaN(startingTime) || startingTime == _currentTime)
			{
				playingEffectsStack.addItem(propertyAnimator);
				propertyAnimator.addEventListener(EffectEvent.EFFECT_ENDED, effectEndHandler);
				propertyAnimator.play();
			}
			else
			{
				bundle = new AnimationBundle(propertyAnimator, startingTime, ANIMATE_PROPERTY);
				
				if (animationStack.locked)
					bundlesToAdd.push(bundle)
				else
					animationStack.addItem(bundle);
			}
		}
		
		public function moveObjects(objects:*, xFrom:Number = NaN, yFrom:Number = NaN, xTo:Number = NaN, yTo:Number = NaN, duration:Number = 100, startingTime:Number = NaN, easingFunction:Function = null):void
		{
			animateProperties(objects, XY_PROP_ARRAY, [xFrom, yFrom], [xTo, yTo], [NaN, NaN], duration, startingTime, easingFunction);
		}
		
		public function rotateObjects(objects:*, angleFrom:Number = NaN, angleTo:Number = NaN, angleBy:Number = NaN, duration:Number = 100, startingTime:Number = NaN, easingFunction:Function = null):void
		{
			animateProperties(objects, ROTATION_PROP_ARRAY, [angleFrom], [angleTo], [angleBy], duration, startingTime, easingFunction);
		}
		
		public function scaleObjects(objects:*, scaleXFrom:Number, scaleYFrom:Number, scaleXTo:Number, scaleYTo:Number, duration:Number = 100, startingTime:Number = NaN, easingFunction:Function = null):void
		{
			animateProperties(objects, SCALEXY_PROP_ARRAY, [scaleXFrom, scaleYFrom], [scaleXTo, scaleYTo], [NaN, NaN], duration, startingTime, easingFunction);
		}
		
		public function fadeIn(objects:*, duration:Number = 100, startingTime:Number = NaN, easingFunction:Function = null):void
		{
			animateProperties(objects, ALPHA_PROP_ARRAY, [0], [1], [NaN], duration, startingTime, easingFunction);
		}
		
		public function fadeOut(objects:*, duration:Number = 100, startingTime:Number = NaN, easingFunction:Function = null):void
		{
			animateProperties(objects, ALPHA_PROP_ARRAY, [1], [0], [NaN], duration, startingTime, easingFunction);
		}
		
		/**
		 * Animates cos-dependent modulation in size of an object.
		 */
		public function animateBubbling(objects:Array, duration:Number = 100, startingTime:Number = NaN, func:Function = null):void
		{
			for each (var obj:DisplayObject in objects)
				animateProperties([obj], SCALEXY_PROP_ARRAY, [obj.scaleX, obj.scaleY], [obj.scaleX, obj.scaleY], [NaN, NaN], duration, startingTime, (func != null) ? func : EasingFunction.cosSplash, 1, null, 1, "animateBubbling");
		}
		
		/**
		 * Animates changing of Y coordinate of an object.
		 */
		public function animateConstantWaving(objects:Array, period:Number = 1000, startingTime:Number = NaN, strength:Number = 1):void
		{
			// 0 value for Y is not acceptable
			// since we have to modulate it
			for each (var obj:DisplayObject in objects)
				animateProperties(obj, Y_PROP_ARRAY, [obj.y], [obj.y], [NaN], 3000 * period, startingTime, EasingFunction.sinWaveLongPositive, strength, null, 1, "animateConstantWaving");
		}
		
		/**
		 * Animates variation in the rotation angle of an object.
		 */
		public function animateConstantRocking(objects:Array, period:Number = 1000, startingTime:Number = NaN, strength:Number = 10):void
		{
			for each (var obj:DisplayObject in objects)
				animateProperties([obj], ROTATION_PROP_ARRAY, [obj.rotation + 10], [obj.rotation], [NaN], 3000 * period, startingTime, EasingFunction.cosWaveLongSimmetrical, strength, null, 1, "animateConstantRocking");
		}
		
		/**
		 * Animates increasing and decreasing in size of an object.
		 */
		public function animateConstantBubbling(objects:Array, period:Number = 1000, startingTime:Number = NaN, strength:Number = 0.5, animationID:String = null):void
		{
			for each (var obj:DisplayObject in objects)
				animateProperties([obj], SCALEXY_PROP_ARRAY, [obj.scaleX, obj.scaleY], [obj.scaleX, obj.scaleY], [NaN, NaN], 3000 * period, startingTime, EasingFunction.cosWaveLongPositive, strength, null, 1, "animateConstantBubbling", animationID);
		}
		
		public function animatePopping(objects:Array, initialScale:Number = 0.2, maxScale:Number = 1.5, duration:Number = 300, startingTime:Number = NaN):void
		{
			scaleObjects(objects, initialScale, initialScale, maxScale, maxScale, duration, startingTime);
			scaleObjects(objects, maxScale, maxScale, 1, 1, duration, (!isNaN(startingTime)) ? (startingTime + duration) : (currentTime + duration));
		}
		
		/**
		 * Specifies time point when the timeline should finish and AnimationEvent.ANIMATION_COMPLETED is dispatched.
		 * @param startingTime Starting time point for this action in milliseconds.
		 *
		 */
		public function finishAnimationAt(startingTime:Number):void
		{
			bundle = new AnimationBundle(null, startingTime, ANIMATION_CHAIN_COMPLETE);
			
			if (animationStack.locked)
				bundlesToAdd.push(bundle)
			else
				animationStack.addItem(bundle);
		}
		
		/// optimization
		
		private const ALPHA_PROP_ARRAY:Array = ["alpha"];
		
		private const X_PROP_ARRAY:Array = ["x"];
		
		private const Y_PROP_ARRAY:Array = ["y"];
		
		private const ROTATION_PROP_ARRAY:Array = ["rotation"];
		
		private const SCALEX_PROP_ARRAY:Array = ["scaleX"];
		
		private const SCALEY_PROP_ARRAY:Array = ["scaleY"];
		
		private const XY_PROP_ARRAY:Array = ["x", "y"];
		
		private const SCALEXY_PROP_ARRAY:Array = ["scaleX", "scaleY"];
		
		private function getArrayForSingleProperty(property:String):Array
		{
			switch (property)
			{
				case "alpha": 
					return ALPHA_PROP_ARRAY;
				case "x": 
					return X_PROP_ARRAY;
				case "y": 
					return Y_PROP_ARRAY;
				case "rotation": 
					return ROTATION_PROP_ARRAY;
				case "scaleX": 
					return SCALEX_PROP_ARRAY;
				case "scaleY": 
					return SCALEY_PROP_ARRAY;
			}
			
			return [property];
		}
	
	}

}
import flash.display.DisplayObjectContainer;

/**
 * AnimationBundle class is designed to hold some properties of an action.
 */
class AnimationBundle
{
	/**
	 * Object to be animated.
	 */
	public var obj:Object;
	
	public var parent:DisplayObjectContainer;
	
	/**
	 * Starting time point.
	 */
	public var startingTime:Number;
	
	/**
	 * Name of an effect.
	 */
	public var effectName:String;
	
	/**
	 * Function to execute.
	 */
	public var functionToExecute:Function;
	
	/**
	 * Parameters for the function.
	 */
	public var parameters:Array;
	
	/**
	 * Id of a function to execute.
	 */
	public var functionID:String = null;
	
	/**
	 * Constructor.
	 */
	public function AnimationBundle(obj:Object, staringTime:Number, effectName:String, functionToExecute:Function = null, parent:DisplayObjectContainer = null, parameters:Array = null, functionID:String = null):void
	{
		this.obj = obj;
		this.startingTime = staringTime;
		this.effectName = effectName;
		this.functionToExecute = functionToExecute;
		this.parameters = parameters;
		this.parent = parent;
		this.functionID = functionID;
	}
}
