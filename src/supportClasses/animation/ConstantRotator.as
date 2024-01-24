/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.animation
{
	import constants.GamePlayConstants;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ConstantRotator
	{
		private var rotator:DisplayObject = null;
		
		private var rotationSpeed:Number = 1;
		
		private var clockwise:Boolean = true;
		
		/////////////
		
		public function ConstantRotator(rotator:DisplayObject, rotationSpeed:Number, clockwise:Boolean = true)
		{
			this.rotator = rotator;
			this.rotationSpeed = rotationSpeed;
			this.clockwise = clockwise;
			
			if (rotator.stage)
				startRotation();
			
			rotator.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			rotator.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
		}
		
		////////////
		
		private function addedToStageHandler(event:Event):void
		{
			startRotation();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			stopRotation();
		}
		
		public function startRotation():void
		{
			DeltaTime.globalDeltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTime_deltaTimeAquiredHandler);
		}
		
		public function stopRotation():void
		{
			DeltaTime.globalDeltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTime_deltaTimeAquiredHandler);
		}
		
		private function deltaTime_deltaTimeAquiredHandler(event:DeltaTimeEvent):void
		{
			var multiplier:int = clockwise ? 1 : -1;
			rotator.rotation += multiplier * rotationSpeed * event.lastDeltaTime / GamePlayConstants.STANDARD_INTERVAL;
		}
	}

}