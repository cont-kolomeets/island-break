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
	public class TextFieldEvent extends Event
	{
		public static const ENTERED_EDITING_MODE:String = "enteredEditingMode";
		public static const LEFT_EDITING_MODE:String = "leftEditingMode";		
		
		public function TextFieldEvent(type:String) 
		{
			super(type);
		}
		
	}

}