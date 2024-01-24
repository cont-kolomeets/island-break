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
	public class LayoutEvent extends Event 
	{
		// dispatched when layout is invalidated.
		public static const LAYOUT_INVALIDATED:String = "layoutInvalidated";
		
		// dispatched when layout is updated.
		public static const LAYOUT_CHANGED:String = "layoutChanged";
		
		public function LayoutEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
	}
	
}