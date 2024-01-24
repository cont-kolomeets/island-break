/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PauseEvent extends Event
	{
		
		public static const PAUSE_SCREEN_ADD_REQUESTED:String = "pauseScreenAddRequested";
		
		public static const PAUSE_SCREEN_REMOVE_REQUESTED:String = "pauseScreenRemoveRequested";
		
		////////////////
		
		public var showAutoPauseNotification:Boolean = false;
		
		public function PauseEvent(type:String, showAutoPauseNotification:Boolean = false)
		{
			super(type);
			this.showAutoPauseNotification = showAutoPauseNotification;
		}
	
	}

}