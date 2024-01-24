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
	public class NSControlEvent extends Event 
	{
		public static const PROPERTIES_INVALIDATED:String = "propertiesInvalidated";
		
		public function NSControlEvent(type:String) 
		{
			super(type);
		}
		
	}

}