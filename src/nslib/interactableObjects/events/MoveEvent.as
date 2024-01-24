/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.interactableObjects.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MoveEvent extends Event 
	{
		public static const MOVED:String = "moved";
		
		public var newX:Number;
		
		public var newY:Number;
		
		public function MoveEvent(type:String, newX:Number = NaN, newY:Number = NaN) 
		{
			super(type);
			this.newX = newX;
			this.newY = newY;
		}
		
	}

}