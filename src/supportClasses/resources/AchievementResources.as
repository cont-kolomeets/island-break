/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources
{
	import infoObjects.gameInfo.AchievementInfo;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AchievementResources
	{
		
		public static const NAME_KING_OF_SKYES:String = "King of Skies";
		public static const NAME_TELEPORTER:String = "Teleporter";
		public static const NAME_SUCCESSFUL:String = "Successful";
		public static const NAME_BOMBER:String = "Bomber";
		public static const NAME_BUILDER:String = "Builder";
		public static const NAME_CONSTRUCTOR:String = "Constructor";
		public static const NAME_DESTRUCTOR:String = "Destructor";
		public static const NAME_OBLITERATOR:String = "Obliterator";
		public static const NAME_HI_TECH:String = "Hi-tech";
		public static const NAME_UNBEATABLE:String = "Unbeatable";
		public static const NAME_DEFENDER:String = "Defender";
		public static const NAME_IRON_SHIELD:String = "Iron Shield";
		public static const NAME_VICTORIOUS:String = "Victorious";
		public static const NAME_UNSTOPPABLE:String = "Unstoppable";
		public static const NAME_TRIUMPHAL:String = "Triumphal";
		public static const NAME_IMPATIENT:String = "Impatient";
		public static const NAME_BUSINESSMAN:String = "Businessman";
		public static const NAME_MAGNAT:String = "Magnate";
		public static const NAME_PERFECTIONIST:String = "Perfectionist";
		public static const NAME_ICE:String = "Ice";
		public static const NAME_BOSS:String = "I'm the Boss";
		
		//------------------------------------------
		// config
		//------------------------------------------
		
		//<achievement id = "1" name = "Teleporter"
		//	description = "Teleport 100 enemies" type = "accumulative"
		//	goalValue = "100" />
		
		private static const config:XML =
			
			<achievements>
				<achievement id = "0" name = "Unbeatable"
					description = "Earn 3 stars in one mission" type = "oneTime"
					goalValue = "" />
				<achievement id = "1" name = "Defender"
					description = "Let no enemies pass in 3 missions" type = "accumulative"
					goalValue = "3" inSeveralMissions = "true" />
				<achievement id = "2" name = "Iron Shield"
					description = "Let no enemies pass during 5 missions" type = "accumulative"
					goalValue = "5" inSeveralMissions = "true"  />
				<achievement id = "3" name = "Victorious"
					description = "Complete 1 mission" type = "oneTime"
					goalValue = ""  />
				<achievement id = "4" name = "Unstoppable"
					description = "Complete 3 missions" type = "oneTime"
					goalValue = "3"  />
				<achievement id = "5" name = "Triumphal"
					description = "Complete 10 missions" type = "oneTime"
					goalValue = "10" />
				<achievement id = "6" name = "Impatient"
					description = "Call 3 waves early in a row" type = "oneTime"
					goalValue = ""/>
				<achievement id = "7" name = "King of Skies"
					description = "Call air support 50 times" type = "accumulative"
					goalValue = "50" />
				<achievement id = "8" name = "Successful"
					description = "Earn 15 stars total" type = "oneTime"
					goalValue = "15" />
				<achievement id = "9" name = "Bomber"
					description = "Drop 120 bombs" type = "accumulative"
					goalValue = "120" />
				<achievement id = "10" name = "Builder"
					description = "Build 50 towers" type = "accumulative"
					goalValue = "50" />
				<achievement id = "11" name = "Constructor"
					description = "Build 200 towers" type = "accumulative"
					goalValue = "200" />
				<achievement id = "12" name = "Destructor"
					description = "Destroy 300 enemy units" type = "accumulative"
					goalValue = "300" />
				<achievement id = "13" name = "Obliterator"
					description = "Destroy 1000 enemy units" type = "accumulative"
					goalValue = "1000" />
				<achievement id = "14" name = "Hi-tech"
					description = "Upgrade all your weapons to maximum" type = "oneTime"
					goalValue = "" />
				<achievement id = "15" name = "Businessman"
					description = "Earn 10000$ total" type = "accumulative"
					goalValue = "10000" />
				<achievement id = "16" name = "Magnate"
					description = "Earn 50000$ total" type = "accumulative"
					goalValue = "50000" />
				<achievement id = "17" name = "Perfectionist"
					description = "Improve on already passed level" type = "oneTime"
					goalValue = "" />
				<achievement id = "18" name = "Ice"
					description = "Get frozen 50 times" type = "accumulative"
					goalValue = "50" />
				<achievement id = "19" name = "I'm the Boss"
					description = "Beat the boss" type = "oneTime"
					goalValue="" />	
			</achievements>;
		
		
		//------------------------------------------
		// collection data
		//------------------------------------------
		
		// these will be used internally
		private static var achievementsHash:Object = null;
		
		// this method should be called on application start.
		// it parses the config xml and fills the weaponInfos array
		// with weapon infos.
		public static function initialize():void
		{
			achievementsHash = {};
			var achievementsList:XMLList = config.achievement;
			
			for each (var ach:XML in achievementsList)
			{
				var info:Object = new Object();
				info.name = ach.@name;
				info.description = ach.@description;
				achievementsHash[info.name] = info;
			}
		}
		
		// returns array of AchievementInfo objects for initial use.
		public static function getEmptyAchievements():Array
		{
			var achievementInfos:Array = [];
			var achievementsList:XMLList = config.achievement;
			
			for each (var ach:XML in achievementsList)
			{
				var info:AchievementInfo = new AchievementInfo();
				info.name = ach.@name;
				info.type = (String(ach.@type) == "accumulative") ? AchievementInfo.TYPE_ACCUMULATIVE : AchievementInfo.TYPE_ONE_TIME;
				info.goalValue = int(ach.@goalValue);
				info.currentValue = 0;
				info.inSeveralMissions = Boolean(String(ach.@inSeveralMissions) == "true");
				info.achieved = false;
				achievementInfos.push(info);
			}
			
			return achievementInfos;
		}
		
		public static function getDescriptionForName(name:String):String
		{
			return String(achievementsHash[name].description);
		}
	}

}