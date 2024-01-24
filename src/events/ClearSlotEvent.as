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
	public class ClearSlotEvent extends Event 
	{
		public static const CLEAR_SLOT:String = "clearSlot";
		
		///////
		
		public var slotIndex:int = -1;
		
		///////
		
		public function ClearSlotEvent(type:String, slotIndex:int) 
		{
			super(type);
			this.slotIndex = slotIndex;
		}
		
		override public function clone():flash.events.Event 
		{
			return new ClearSlotEvent(type, slotIndex);
		}
	}

}