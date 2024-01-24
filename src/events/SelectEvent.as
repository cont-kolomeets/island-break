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
	public class SelectEvent extends Event 
	{
		public static const SELECTED:String = "selected";
		
		public var selectedIndex:int = -1;
		
		public var selectedItem:* = null;
		
		public function SelectEvent(type:String, selectedIndex:int, selectedItem:* = null) 
		{ 
			super(type);
			
			this.selectedIndex = selectedIndex;
			this.selectedItem = selectedItem;
		}
	}
	
}