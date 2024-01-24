/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ProgressBarEvent extends Event 
	{
		public static const PROGRESS_STARTED:String = "progressStarted";
		
		public static const PROGRESS_COMPLETE:String = "progressComplete";
		
		public function ProgressBarEvent(type:String) 
		{
			super(type);
		}
		
	}

}