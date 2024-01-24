/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.gameInfo
{
	import supportClasses.resources.AchievementImageResources;
	import supportClasses.resources.AchievementResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * AchievementInfo contains information about an achievement.
	 */
	public class AchievementInfo
	{
		// something that happens only once (like killing the boss at the level 3)
		public static const TYPE_ONE_TIME:String = "oneTime";
		
		public static const TYPE_ACCUMULATIVE:String = "accumulative";
		
		public static function toObject(achievementInfo:AchievementInfo):Object
		{
			var obj:Object = new Object();
			
			obj.name = achievementInfo.name;
			obj.achieved = achievementInfo.achieved;
			obj.type = achievementInfo.type;
			obj.goalValue = achievementInfo.goalValue;
			obj.currentValue = achievementInfo.currentValue;
			obj.inSeveralMissions = achievementInfo.inSeveralMissions;
			obj.collectedMissions = achievementInfo.collectedMissions;
			
			return obj;
		}
		
		public static function fromObject(obj:Object):AchievementInfo
		{
			var achievementInfo:AchievementInfo = new AchievementInfo();
			
			achievementInfo.name = String(obj.name);
			achievementInfo.achieved = Boolean(obj.achieved);
			achievementInfo.type = String(obj.type);
			achievementInfo.goalValue = int(obj.goalValue);
			achievementInfo.currentValue = int(obj.currentValue);
			achievementInfo.inSeveralMissions = Boolean(obj.inSeveralMissions);
			achievementInfo.collectedMissions = obj.collectedMissions as Array;
			
			return achievementInfo;
		}
		
		////////////
		
		public var name:String = null;
		public var achieved:Boolean = false;
		public var type:String = null;
		
		// for accumulative type
		public var goalValue:int = 0;
		public var currentValue:int = 0;
		public var inSeveralMissions:Boolean = false;
		public var collectedMissions:Array = null;
		
		public function AchievementInfo()
		{
		}
		
		////////////
		
		public function get iconEnabled():Class
		{
			return AchievementImageResources.getIconEnabledByName(name);
		}
		
		public function get iconDisabled():Class
		{
			return AchievementImageResources.getIconDisabledByName(name);
		}
		
		public function get description():String
		{
			return AchievementResources.getDescriptionForName(name);
		}
	}

}