/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TracableObjectEvent extends Event
	{
		public static const READY_TO_BE_REMOVED:String = "readyToBeRemoved";
		
		public function TracableObjectEvent(type:String)
		{
			super(type);
		}
	
	}

}