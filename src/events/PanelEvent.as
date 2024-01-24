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
	public class PanelEvent extends Event
	{
		// dispatched when a panel is shown.
		public static const SHOW:String = "show";
		
		// dispatched when a panel is being removed from the screen.
		public static const READY_TO_BE_REMOVED:String = "readyToBeRemoved";
		
		// dispatched when a panel requests panel infos to update its content.
		public static const REQUEST_INFOS:String = "requestInfos";
		
		public function PanelEvent(type:String) 
		{
			super(type);
		}
		
	}

}