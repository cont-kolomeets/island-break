/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package bot.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class StatEvent extends Event 
	{
		public static const SHOW_STAT:String = "showStat";
		
		public var levelIndex:int = -1;
		
		public function StatEvent(type:String, levelIndex:int) 
		{
			super(type);
			
			this.levelIndex = levelIndex;
		}
		
		override public function clone():flash.events.Event 
		{
			return new StatEvent(type, levelIndex);
		}
		
	}

}