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
	public class ButtonBarEvent extends Event 
	{
		public static const INDEX_CHANGED:String = "indexChanged";
		
		public var newIndex:int = 0;
		
		public function ButtonBarEvent(type:String, newIndex:int) 
		{
			super(type);
			
			this.newIndex = newIndex;
		}
		
	}

}