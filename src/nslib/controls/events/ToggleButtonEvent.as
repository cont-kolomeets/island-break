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
	 * @author Kolomeets Alexander
	 */
	public class ToggleButtonEvent extends Event
	{
		// dispatched every time the state is changed
		public static const STATE_CHANGED:String = "stateChanged";
		
		// dispatched only if the state has changed due to a user's interaction
		public static const STATE_CHANGED_USER_INTERACTION:String = "stateChangedUserInteraction";
		
		public function ToggleButtonEvent(type:String)
		{
			super(type);
		}
	
	}

}