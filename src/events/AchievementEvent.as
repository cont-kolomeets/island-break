/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package events
{
	import flash.events.Event;
	import infoObjects.gameInfo.AchievementInfo;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AchievementEvent extends Event
	{
		public static const ACHIEVEMENT_REACHED:String = "achievementReached";
		
		public var achievementInfo:AchievementInfo;
		
		public function AchievementEvent(type:String, achievementInfo:AchievementInfo)
		{
			super(type);
			
			this.achievementInfo = achievementInfo;
		}
		
		override public function clone():flash.events.Event 
		{
			return new AchievementEvent(type, achievementInfo);
		}
	
	}

}