/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.timers.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AdvancedTimerEvent extends Event 
	{
		public static const REPETITION_COMPLETED:String = "repetitionCompleted";
		
		public static const TIMER_COMPLETED:String = "timerCompleted";
		
		public function AdvancedTimerEvent(type:String) 
		{
			super(type);
		}
		
	}

}