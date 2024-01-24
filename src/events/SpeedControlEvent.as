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
	 * @author Kolomeets Alexander
	 */
	public class SpeedControlEvent extends Event
	{
		public static const GAME_SPEED_CHANGED:String = "gameSpeedChanged";
		
		public var newSpeed:int = 0;
		
		public function SpeedControlEvent(type:String, newSpeed:int)
		{
			super(type);
			
			this.newSpeed = newSpeed;
		}
		
		override public function clone():Event 
		{
			return new SpeedControlEvent(type, newSpeed);
		}
	
	}

}