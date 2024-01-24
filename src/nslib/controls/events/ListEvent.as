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
	public class ListEvent extends Event
	{
		public static const DRAG:String = "drag";
		public static const DROP:String = "drop";
		
		public function ListEvent(type:String) 
		{
			super(type);
		}
		
	}

}