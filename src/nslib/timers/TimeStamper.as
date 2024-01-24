/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.timers
{
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class TimeStamper
	{
		private var initialTime:int = 0;
		
		private var pauseTimeAccumulated:int = 0;
		
		private var lastPauseTime:int = 0;
		
		public function TimeStamper()
		{
		
		}
		
		public function start():void
		{
			initialTime = getTimer();
			pauseTimeAccumulated = 0;
		}
		
		public function getTimeStamp(inSeconds:Boolean = true):int
		{
			var value:int = getTimer() - initialTime - pauseTimeAccumulated;
			return inSeconds ? (value / 1000) : value;
		}
		
		public function pause():void
		{
			lastPauseTime = getTimer();
		}
		
		public function resume():void
		{
			pauseTimeAccumulated += getTimer() - lastPauseTime;
		}
	
	}

}