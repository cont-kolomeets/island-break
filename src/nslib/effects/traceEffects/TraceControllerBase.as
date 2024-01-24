package nslib.effects.traceEffects
{
	import bot.GameBot;
	import flash.display.BitmapData;
	import flash.events.Event;
	import nslib.animation.engines.AnimationEngine;
	import nslib.animation.events.AnimationEvent;
	import nslib.effects.events.TracableObjectEvent;
	import nslib.utils.ArrayList;
	import nslib.utils.NSMath;
	import nslib.utils.ObjectsPoolUtil;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class TraceControllerBase
	{
		protected var tracableObjects:ArrayList = new ArrayList();
		
		protected var tracableObjectsToApplyAfterBlurring:ArrayList = new ArrayList();
		
		protected var permanentSpotHash:Object = {};
		
		protected var tracableObjectsToRemove:Array = [];
		
		///////////////////
		
		public function TraceControllerBase()
		{
		}
		
		//////////////////
		
		public function reset():void
		{
			tracableObjects.removeAll();
			tracableObjectsToApplyAfterBlurring.removeAll();
			permanentSpotHash = {};
		}
		
		///////////
		
		public function animateTracableObjectProperty(object:*, params:Object, propertyName:String, fromValue:Number, toValue:Number, duration:Number):void
		{
			var to:TracableObject = null;
			
			if (object is Class)
				to = ObjectsPoolUtil.takeObject(Class(object), params);
			else if (object is TracableObject)
				to = object;
			else
				return;
			
			to.createBitmapData();
			
			AnimationEngine.globalAnimator.animateProperty(to, propertyName, fromValue, toValue, NaN, duration);
			to.addEventListener(AnimationEvent.ANIMATION_ROUTINE_COMPLETED_FOR_THIS_OBJECT, to_animationCompletedHandler);
			
			if (to.applyBeforeBlurring)
				tracableObjects.addItem(to);
			else
				tracableObjectsToApplyAfterBlurring.addItem(to);
		}
		
		public function launchTracableObject(tracableObject:*, params:Object, goalX:Number, goalY:Number, flyDuration:Number, afterTraceObject:* = null, afterTraceObjectParams:Object = null):TracableObject
		{
			var to:TracableObject = null;
			
			if (tracableObject is Class)
				to = ObjectsPoolUtil.takeObject(Class(tracableObject), params);
			else if (tracableObject is TracableObject)
				to = tracableObject;
			else
				return null;
			
			to.createBitmapData();
			
			////////////////
			
			var afterTrace:TracableObject = null;
			
			if (afterTraceObject is Class)
				afterTrace = ObjectsPoolUtil.takeObject(Class(afterTraceObject), afterTraceObjectParams);
			else if (afterTraceObject is TracableObject)
				afterTrace = afterTraceObject;
			
			afterTrace.createBitmapData();
			
			///////////////
			
			AnimationEngine.globalAnimator.moveObjects(to, to.x, to.y, goalX, goalY, NSMath.sqrt((to.x - goalX) * (to.x - goalX) + (to.y - goalY) * (to.y - goalY)) * flyDuration);
			to.addEventListener(AnimationEvent.ANIMATION_ROUTINE_COMPLETED_FOR_THIS_OBJECT, to_animationCompletedHandler);
			
			if (to.applyBeforeBlurring)
				tracableObjects.addItem(to);
			else
				tracableObjectsToApplyAfterBlurring.addItem(to);
			
			if (afterTrace)
				permanentSpotHash[to.uniqueKey] = [to, afterTrace];
			
			return to;
		}
		
		/////////////////////////
		
		public function stopTracingForLaunchedObject(to:TracableObject):void
		{
			if (GameBot.supressUI)
				return;
			
			to.removeEventListener(AnimationEvent.ANIMATION_ROUTINE_COMPLETED_FOR_THIS_OBJECT, to_animationCompletedHandler);
			to.addEventListener(TracableObjectEvent.READY_TO_BE_REMOVED, to_readyToBeRemovedHandler);
			AnimationEngine.globalAnimator.stopAnimationForObject(to);
			to.stop();
		}
		
		private function to_animationCompletedHandler(event:AnimationEvent):void
		{
			stopTracingForLaunchedObject(event.currentTarget as TracableObject);
		}
		
		private function to_readyToBeRemovedHandler(event:Event):void
		{
			var to:TracableObject = event.currentTarget as TracableObject;
			
			removeTracableObject(to, true);
		}
		
		private function removeTracableObject(to:TracableObject, leavePermanentSpot:Boolean):void
		{
			to.removeEventListener(TracableObjectEvent.READY_TO_BE_REMOVED, to_readyToBeRemovedHandler);
			
			if (tracableObjects.locked || tracableObjectsToApplyAfterBlurring.locked)
				tracableObjectsToRemove.push(to);
			else
			{
				tracableObjects.removeItem(to);
				tracableObjectsToApplyAfterBlurring.removeItem(to);
				ObjectsPoolUtil.returnObject(to);
			}
			
			if (leavePermanentSpot && permanentSpotHash[to.uniqueKey])
			{
				var afterTrace:TracableObject = (permanentSpotHash[to.uniqueKey] as Array)[1];
				afterTrace.x = to.x;
				afterTrace.y = to.y;
				putPermanentImage(afterTrace);
				delete permanentSpotHash[to.uniqueKey];
			}
		}
		
		//////////////////////////////////////
		
		public function putImageForFadingAt(x:int, y:int, bitmapData:BitmapData):void
		{
		}
		
		/////////////////////////////////////
		
		public function putPermanentImage(spotObject:*, params:Object = null):void
		{
		}
		
		/////////////////////////////////////
		
		public function putPermanentBitmapDataAt(bitmapData:BitmapData, x:Number, y:Number):void
		{
		}
	
	}

}