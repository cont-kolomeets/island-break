/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package events 
{
	import flash.events.Event;
	import infoObjects.WeaponInfo;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class NewsEvent extends Event 
	{
		public static const NEW_ENEMY_OPENED:String = "newEnemyOpened";
		
		public var enemyInfo:WeaponInfo = null;
		
		public function NewsEvent(type:String, enemyInfo:WeaponInfo = null) 
		{
			super(type);
			
			this.enemyInfo = enemyInfo;
		}
		
		override public function clone():Event 
		{
			return new NewsEvent(type, enemyInfo);
		}
		
	}

}