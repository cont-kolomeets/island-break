/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.gameInfo
{
	import constants.GamePlayConstants;
	import flash.globalization.DateTimeFormatter;
	import supportClasses.resources.AchievementResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * GameInfo contains the current state of a game.
	 * Information containing here is enough to resume the game from any point (levelwise).
	 */
	public class GameInfo
	{
		/// convertions
		
		public static function toObject(gameInfo:GameInfo):Object
		{
			var obj:Object = new Object();
			
			// packing level infos
			var levelInfos:Array = [];
			
			for (var i:int = 0; i < gameInfo.levelInfos.length; i++)
				levelInfos.push(LevelInfo.toObject(LevelInfo(gameInfo.levelInfos[i])));
			
			obj.levelInfos = levelInfos;
			
			/////////
			
			// packing achievement infos
			var achievementInfos:Array = [];
			
			for (var j:int = 0; j < gameInfo.achievementInfos.length; j++)
				achievementInfos.push(AchievementInfo.toObject(AchievementInfo(gameInfo.achievementInfos[j])));
			
			obj.achievementInfos = achievementInfos;
			
			/////////
			
			var developmentInfosSerialized:Array = [];
			
			for each (var devInfo:DevelopmentInfo in gameInfo.developmentInfos)
				developmentInfosSerialized.push(DevelopmentInfo.toObject(devInfo));
			
			obj.developmentInfos = developmentInfosSerialized;
			
			/////////
			
			obj.starsSpent = gameInfo.starsSpent;
			obj.date = gameInfo.date.time;
			
			// serializing flags
			obj.helpInfo = UserHelpInfo.toObject(gameInfo.helpInfo);
			
			obj.bonusInfo = BonusInfo.toObject(gameInfo.bonusInfo);
			
			return obj;
		}
		
		public static function fromObject(obj:Object):GameInfo
		{
			var gameInfo:GameInfo = new GameInfo();
			
			// parsing level infos
			gameInfo.levelInfos = [];
			
			var levelInfos:Array = obj.levelInfos as Array;
			
			for (var i:int = 0; i < levelInfos.length; i++)
				gameInfo.levelInfos.push(LevelInfo.fromObject(levelInfos[i]));
			
			// parsing achievement infos
			gameInfo.achievementInfos = [];
			
			var achievementInfos:Array = obj.achievementInfos as Array;
			
			for (var j:int = 0; j < achievementInfos.length; j++)
				gameInfo.achievementInfos.push(AchievementInfo.fromObject(achievementInfos[j]));
			
			// parsing development infos
			var developmentInfosDeserialized:Array = [];
			
			for each (var devInfoObject:Object in obj.developmentInfos)
				developmentInfosDeserialized.push(DevelopmentInfo.fromObject(devInfoObject));
			
			gameInfo.developmentInfos = developmentInfosDeserialized;
			
			gameInfo.starsSpent = int(obj.starsSpent);
			gameInfo.updateDate(obj.date);
			
			gameInfo.refresh();
			
			// deserializing flags
			gameInfo.helpInfo = obj.helpInfo ? UserHelpInfo.fromObject(obj.helpInfo) : new UserHelpInfo();
			
			gameInfo.bonusInfo = obj.bonusInfo ? BonusInfo.fromObject(obj.bonusInfo) : new BonusInfo();
			
			return gameInfo;
		}
		
		private static const dateFormatter:DateTimeFormatter = new DateTimeFormatter("En");
		
		//------------------------------------------
		// Infos
		//------------------------------------------
		
		// array of LevelInfo objects. Each objects contains information about a level.
		public var levelInfos:Array = null;
		
		// array of AchievementInfo objects. Each object contains information about an achievement,
		// wich can be either earned or not.
		public var achievementInfos:Array = null;
		
		//------------------------------------------
		// Date
		//------------------------------------------
		
		// date when the game was last saved.
		public var date:Date = null;
		
		// formatted date.
		public var dateFormatted:String = null;
		
		//------------------------------------------
		// Levels info
		//------------------------------------------
		
		public var numLevelsPassed:int = 0;
		
		public var numHardLevelsPassed:int = 0;
		
		public var numUnrealLevelsPassed:int = 0;
		
		//------------------------------------------
		// Stars info
		//------------------------------------------
		
		// total amount of stars earned.
		public var totalStarsEarned:int = 0;
		
		// currently available stars
		public function get starsAvailable():int
		{
			return totalStarsEarned - starsSpent;
		}
		
		// number of stars spent during development
		public var starsSpent:int = 0;
		
		//------------------------------------------
		// User operations
		//------------------------------------------
		
		public var helpInfo:UserHelpInfo = new UserHelpInfo();
		
		//------------------------------------------
		// Bonuses
		//------------------------------------------
		
		public var bonusInfo:BonusInfo = new BonusInfo();
		
		//------------------------------------------
		// Constructor
		//------------------------------------------
		
		public function GameInfo(levelInfos:Array = null)
		{
			if (levelInfos && levelInfos.length > 0)
				this.levelInfos = levelInfos
			else
				this.levelInfos = getEmptyLevels();
			
			achievementInfos = AchievementResources.getEmptyAchievements();
			
			setInitialDevelopmentStatus();
			
			refresh();
			updateDate();
		}
		
		//------------------------------------------
		// working with development status
		//------------------------------------------
		
		// all history of upgrades
		private var developmentInfos:Array = null;
		
		public function get developmentInfo():DevelopmentInfo
		{
			return getLastStoredDevelopmentInfo();
		}
		
		public function get developmentInfoCopy():DevelopmentInfo
		{
			return getLastStoredDevelopmentInfoCopy();
		}
		
		private function setInitialDevelopmentStatus():void
		{
			// inialize history storage
			developmentInfos = [];
			
			var developmentInfo:DevelopmentInfo = new DevelopmentInfo();
			developmentInfo.cannonLevel = 0;
			developmentInfo.machineGunLevel = 0;
			
			developmentInfos.push(developmentInfo);
		}
		
		public function applyNewDevelopmentInfo(developmentInfo:DevelopmentInfo):void
		{
			developmentInfos.push(developmentInfo);
		}
		
		public function undoLastStoredDevelopmentInfo():DevelopmentInfo
		{
			return undoForDevStatusAllowed() ? developmentInfos.pop() : null;
		}
		
		public function undoForDevStatusAllowed():Boolean
		{
			return developmentInfos.length > 1;
		}
		
		private function getLastStoredDevelopmentInfo():DevelopmentInfo
		{
			return developmentInfos[developmentInfos.length - 1];
		}
		
		private function getLastStoredDevelopmentInfoCopy():DevelopmentInfo
		{
			return DevelopmentInfo.fromObject(DevelopmentInfo.toObject(getLastStoredDevelopmentInfo()));
		}
		
		public function copyDevelopmentHistoryFromGameInfo(gameInfo:GameInfo):void
		{
			// just copy
			this.developmentInfos = gameInfo.developmentInfos;
		}
		
		//------------------------------------------
		// working with levels
		//------------------------------------------
		
		private function getEmptyLevels():Array
		{
			var levels:Array = [];
			
			for (var i:int = 0; i < GamePlayConstants.NUMBER_OF_LEVELS; i++)
				levels.push(new LevelInfo(i, false, false, 0));
			
			LevelInfo(levels[0]).available = true;
			
			return levels;
		}
		
		// collects numLevelsPassed and totalStarsEarned values
		public function refresh():void
		{
			if (!levelInfos)
				return;
			
			numLevelsPassed = 0;
			numHardLevelsPassed = 0;
			numUnrealLevelsPassed = 0;
			totalStarsEarned = 0;
			
			for (var i:int = 0; i < levelInfos.length; i++)
				if (LevelInfo(levelInfos[i]).passed)
				{
					numLevelsPassed++;
					totalStarsEarned += LevelInfo(levelInfos[i]).starsEarned;
					
					if (LevelInfo(levelInfos[i]).hardModePassed)
						numHardLevelsPassed++;
					
					if (LevelInfo(levelInfos[i]).unrealModePassed)
						numUnrealLevelsPassed++;
				}
		}
		
		// sets the date to current
		public function updateDate(dateTime:Number = NaN):void
		{
			date = new Date();
			
			if (!isNaN(dateTime))
				date.time = dateTime;
			
			dateFormatter.setDateTimePattern("dd/MM/yyyy");
			dateFormatted = dateFormatter.format(date);
		}
		
		// returns a deep copy of this object.
		public function copy():GameInfo
		{
			return fromObject(toObject(this));
		}
		
		// generate status for tracking
		
		public function generateStatusForGame():String
		{
			var status:String = "GAME_STAT:" + this.numLevelsPassed + "," + this.totalStarsEarned;
			
			return status;
		}
		
		public function generateStatusForDevelopment():String
		{
			var status:String = "DEV_STAT:";
			
			var developmentInfo:DevelopmentInfo = getLastStoredDevelopmentInfo();
			
			status += "" + developmentInfo.cannonLevel;
			status += "," + developmentInfo.machineGunLevel;
			status += "," + developmentInfo.shockGunLevel;
			status += "," + developmentInfo.bombSupportLevel;
			status += "," + developmentInfo.airSupportLevel;
			status += "," + developmentInfo.repairCenterLevel;
			
			return status;
		}
		
		public function generateStatusForLevels():String
		{
			var status:String = "LEVELS_STAT:";
			
			var len:int = levelInfos.length;
			
			for (var i:int = 0; i < len; i++)
			{
				var info:LevelInfo = levelInfos[i];
				
				if (i > 0)
					status += ";";
				
				status += "" + info.starsEarned + "," + info.passed;
			}
			
			return status;
		}
	}

}