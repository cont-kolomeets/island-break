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
	public class BonusAttackMenuEvent extends Event
	{
		public static const LAUNCH_AIRCRAFT:String = "launchAirCraft";
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public var level:int = 0;
				
		public function BonusAttackMenuEvent(type:String, x:Number, y:Number, level:int) 
		{
			super(type);
			
			this.x = x;
			this.y = y;
			this.level = level;
		}
		
		override public function clone():flash.events.Event 
		{
			return new BonusAttackMenuEvent(type, x, y, level);
		}
		
	}

}