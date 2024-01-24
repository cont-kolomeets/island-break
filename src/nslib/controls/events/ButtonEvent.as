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
	 * @author Alex
	 */
	public class ButtonEvent extends Event
	{
		public static const BUTTON_CLICK:String = "buttonClick";
		
		public static const BUTTON_MOUSE_OVER:String = "buttonMouseOver";
		
		public function ButtonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			super(type, bubbles, cancelable);
		}
	
	}

}