/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.animation
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	import nslib.animation.events.DeltaTimeEvent;
	
	[Event(name="deltaTimeAquired", type="nslib.animation.events.DeltaTimeEvent")]
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class DeltaTime extends EventDispatcher
	{
		public static var globalDeltaTimeCounter:DeltaTime;
		
		private static var dtIdCount:int = 0;
		
		public var dtId:int = 0;
		
		//////////////////////////////////////
		
		public var isRunning:Boolean = false;
		
		// defines how many times the game time runs faster from the real time.
		// The default value is 1, which means the game time runs as fast as the real time does. 
		public var timeMultiplier:Number = 1;
		
		private var objectInDisplay:DisplayObject
		
		private var t:Number = 0;
		
		private var justStarted:Boolean = true;
		
		///////////////////////////////////////////////
		
		public function DeltaTime(objectInDisplay:DisplayObject)
		{
			dtId = dtIdCount++;
			
			this.objectInDisplay = objectInDisplay;
			
			objectInDisplay.addEventListener(Event.ENTER_FRAME, frameListener);
			isRunning = true;
		}
		
		//////////////
				
		private var _dT:Number = 10;
				
		public function get dT():Number 
		{
			return (timeMultiplier == 1) ? _dT : Math.min(20, _dT);
		}
		
		///////////////////////////////////////////////
		
		public function stop():void
		{
			objectInDisplay.removeEventListener(Event.ENTER_FRAME, frameListener);
			isRunning = false;
		}
		
		public function start():void
		{
			justStarted = true;
			isRunning = true;
			objectInDisplay.addEventListener(Event.ENTER_FRAME, frameListener);
		}
		
		private function frameListener(event:Event):void
		{
			var t1:Number = getTimer();
			_dT = t1 - t;
			t = t1;
			
			if (justStarted)
			{
				justStarted = false;
				_dT = 10;
			}
			
			for (var i:int = 0; i < timeMultiplier; i++)
				dispatchEvent(new DeltaTimeEvent(DeltaTimeEvent.DELTA_TIME_AQUIRED, dT));
		}
	
	}

}