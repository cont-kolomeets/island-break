/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.animation.engines
{
	import flash.events.EventDispatcher;
	import nslib.animation.EasingFunction;
	import nslib.animation.events.EffectEvent;
	import nslib.core.IReusable;
	import nslib.utils.ArrayUtil;
	
	public class PropertyAnimator extends EventDispatcher implements IEffectEngine, IReusable
	{
		// name of an animation action (moving, rotating, scaling etc.)
		public var actionName:String = null;
		
		public var id:String = null;
		
		// duration of animation
		public var duration:Number = NaN;
		
		// array of properites to change
		public var properties:Array = null;
		
		// array of values from
		public var valuesFrom:Array = null;
		
		// array of values t0
		public var valuesTo:Array = null;
		
		// array of values by
		public var valuesBy:Array = null;
		
		/**
		 * The function defining how property is deviated from a linear behavior.
		 * The function should look like the following:
		 * public function property_function(progress:Number, easingEffectFactor:Number):Number
		 * progress - value of the progress varying from 0 to 1.
		 * For smooth performance the function must result in 1 when the progress is 0 or 1.
		 * The default value is EasingFunction.linear.
		 */
		public var easingFunction:Function = EasingFunction.linear;
		/**
		 * Defines the amplitude or strength at with
		 * the easing function will be applied.
		 * The default value is 1.
		 */
		public var easingEffectFactor:Number = 1;
		
		/**
		 * The function defining the property offset.
		 * The function should look like the following:
		 * public function property_function(progress:Number, easingEffectFactor:Number):Number
		 * progress - value of the progress varying from 0 to 1.
		 * For smooth performance the function must result in 0 when the progress is 0 or 1.
		 * The default value is EasingFunction.noOffset.
		 */
		public var offsetFunction:Function = EasingFunction.noOffset;
		
		/**
		 * Defines the amplitude or strength at with
		 * the offset function will be applied.
		 * The default value is 1.
		 */
		public var offsetFactor:Number = 1;
		
		// array of delta values
		private var deltaValues:Array = [];
		
		private var linearValues:Array = [];
		
		// array of values past after the animation started (e.g. how much x value changed so far)
		private var valuesPast:Array = [];
		
		// time left till the animation is over
		private var timeLeft:Number = 0;
		
		// timer
		//private var dt:DeltaTime = null;
		
		// flags
		
		private var isRunning:Boolean = false;
		
		////////////////////////
		
		public function PropertyAnimator()
		{
		}
		
		/////////////////////////
		
		public function set target(obj:Object):void
		{
			if (_targets)
			{
				_targets.length = 0;
				_targets.push(obj);
			}
			else
				_targets = [obj];
		}
		
		///////
		
		private var _targets:Array = null;
		
		public function get targets():Array
		{
			return _targets;
		}
		
		public function set targets(objs:Array):void
		{
			_targets = objs;
		}
		
		///////////////////////////
		
		public function get poolID():String
		{
			return null;
		}
		
		public function set poolID(value:String):void
		{
		}
		
		//////////////////////////
		
		public function prepareForPooling():void
		{
			if (isRunning)
				throw new Error("Attempt to pool running PropertyAnimator!");
			
			internalDispose();
		}
		
		public function prepareForReuse():void
		{
			if (isRunning)
				throw new Error("Attempt to reuse running PropertyAnimator!");
			
			internalDispose();
		}
		
		private function internalDispose():void
		{
			actionName = null;
			id = null;
			duration = NaN;
			properties = null;
			valuesFrom = null;
			valuesTo = null;
			valuesBy = null;
			easingFunction = EasingFunction.linear;
			easingEffectFactor = 1;
			offsetFunction = EasingFunction.noOffset;
			offsetFactor = 1;
			deltaValues.length = 0;
			linearValues.length = 0;
			valuesPast.length = 0;
			timeLeft = 0;
			
			if (_targets)
				_targets.length = 0;
		}
		
		///////
		
		public function hasTarget(obj:Object):Boolean
		{
			return _targets.lastIndexOf(obj) != -1;
		}
		
		public function removeTarget(obj:Object, stopIfNoTargetsLeft:Boolean = true):void
		{
			_targets = ArrayUtil.removeItem(_targets, obj);
			
			if (_targets.length == 0 && stopIfNoTargetsLeft)
				stop();
		}
		
		/////////////////////////////
		
		public function play():void
		{
			if (properties.length == 0 || !_targets || _targets.length == 0)
				throw new Error("Attempt to play PropertyAnimator with no targets or properties specified!");
			
			if (isRunning)
				throw new Error("Attempt to restart running PropertyAnimator!");
			
			isRunning = true;
			
			timeLeft = duration;
			
			var propertyId:String = null;
			
			// going through all properties
			for (var i:int = 0; i < properties.length; i++)
			{
				valuesPast[i] = 0;
				linearValues[i] = [];
				
				propertyId = String(properties[i]);
				
				// going throug all targets
				for (var j:int = 0; j < _targets.length; j++)
				{
					// take a target
					var obj:Object = _targets[j];
					
					if (isNaN(valuesBy[i]))
					{
						// setting the from value if available
						obj[propertyId] = (!isNaN(valuesFrom[i])) ? valuesFrom[i] : obj[propertyId];
					}
					else
					{
						// setting the from value
						valuesFrom[i] = obj[propertyId];
						// calculating the to value.
						valuesTo[i] = obj[propertyId] + valuesBy[i];
					}
					
					// memorizing initial values
					linearValues[i][j] = obj[propertyId];
				}
			}
		}
		
		public function iterate(lastDeltaTime:Number):void
		{
			if (!isRunning)
				throw new Error("Attempt to update properties on next frame for non-running PropertyAnimator!");
			
			updateDeltas(lastDeltaTime);
			moveByDelta(lastDeltaTime);
		}
		
		// calculates deltas to change properties by
		private function updateDeltas(lastDeltaTime:Number):void
		{
			for (var i:int = 0; i < properties.length; i++)
			{
				// delta values are the same for all targets
				deltaValues[i] = ((valuesTo[i] - valuesFrom[i]) - valuesPast[i]) * lastDeltaTime / timeLeft;
			}
		}
		
		// changes properites by calculated deltas
		private function moveByDelta(lastDeltaTime:Number):void
		{
			if (!_targets)
			{
				stop();
				return;
			}
			
			// reducing the time left
			timeLeft -= lastDeltaTime;
			
			for (var i:int = 0; i < properties.length; i++)
			{
				// increasing the values past
				valuesPast[i] += deltaValues[i];
				
				for (var k:int = 0; k < _targets.length; k++)
				{
					var obj:Object = _targets[k];
					
					if (!isNaN(valuesFrom[i]) && !isNaN(valuesTo[i]))
					{
						// setting the values
						linearValues[i][k] += deltaValues[i];
						// applying the easing function
						var localProgress:Number = 1 - timeLeft / duration;
						obj[String(properties[i])] = linearValues[i][k] * easingFunction(localProgress, easingEffectFactor) + offsetFunction(localProgress, offsetFactor);
					}
				}
			}
			
			if (timeLeft <= 0)
			{
				for each (var obj1:Object in _targets)
					for (var j:int = 0; j < properties.length; j++)
					{
						if (isNaN(valuesBy[j]) && !isNaN(valuesTo[j]))
							obj1[properties[j]] = valuesTo[j];
					}
				stop();
			}
		}
		
		public function stop():void
		{
			if (isRunning)
			{
				isRunning = false;
				dispatchEvent(new EffectEvent(EffectEvent.EFFECT_ENDED));
			}
		}
	}

}