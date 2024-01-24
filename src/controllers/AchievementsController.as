/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import events.AchievementEvent;
	import flash.events.EventDispatcher;
	import infoObjects.gameInfo.AchievementInfo;
	import infoObjects.gameInfo.LevelInfo;
	import nslib.AIPack.pathFollowing.TrajectoryFollower;
	import supportClasses.LogParameters;
	import supportClasses.resources.AchievementResources;
	import supportClasses.resources.LogMessages;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * AchievementsController provides static properites to chage during the game.
	 * If a user reaches an achievement an event is dispatched.
	 */
	public class AchievementsController extends EventDispatcher
	{
		public static var instance:AchievementsController = new AchievementsController();
		
		////////////////// Static methods to notify from any part of the app
		
		private static var numWavesCalledEarlyInARow:int = 0;
		
		private static var enemyPassedInOneMission:int = 0;
		
		public static function notifyNewLevelStarted(levelIndex:int):void
		{
			numWavesCalledEarlyInARow = 0;
			enemyPassedInOneMission = 0;
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.LEVEL_STARTED));
		}
		
		public static function notifyWaveCalledEarly():void
		{
			if (++numWavesCalledEarlyInARow == 3)
				instance.notifyAchievementCompleted(AchievementResources.NAME_IMPATIENT);
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.WAVE_CALLED_EARLIER));
			
			GameTracker.api.customMsg(TrackingMessages.WAVE_CALLED_EARLIER);
		}
		
		public static function notifyWaveStartedWithoutCallingEarly():void
		{
			// reset counter
			numWavesCalledEarlyInARow = 0;
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.WAVE_STARTED_ITSELF));
			
			GameTracker.api.customMsg(TrackingMessages.WAVE_STARTED_ITSELF);
		}
		
		public static function notifyLevelCompleted(levelIndex:int, numLivesLeft:int, numLivesTotal:int):void
		{
			// checks for victorious
			if (levelIndex == 0)
				instance.notifyAchievementCompleted(AchievementResources.NAME_VICTORIOUS);
			
			// checks for unstoppable
			if (levelIndex == 2)
				instance.notifyAchievementCompleted(AchievementResources.NAME_UNSTOPPABLE);
			
			// checks for triumphal
			if (levelIndex == 9)
				instance.notifyAchievementCompleted(AchievementResources.NAME_TRIUMPHAL);
			
			// checks for successful
			if (instance.gameInfoController.gameInfo.totalStarsEarned == 15)
				instance.notifyAchievementCompleted(AchievementResources.NAME_SUCCESSFUL);
			
			// checks for unbeatable
			if (LevelInfo(instance.gameInfoController.gameInfo.levelInfos[levelIndex]).starsEarned == 3)
				instance.notifyAchievementCompleted(AchievementResources.NAME_UNBEATABLE);
			
			// checks for defender
			// checks for iron shield
			if (enemyPassedInOneMission == 0)
			{
				instance.checkGoalValueForInfoByName(AchievementResources.NAME_DEFENDER, 1, levelIndex);
				instance.checkGoalValueForInfoByName(AchievementResources.NAME_IRON_SHIELD, 1, levelIndex);
			}
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.LEVEL_COMPLETED));
		}
		
		public static function notifyLevelCompletedInHardMode(levelIndex:int):void
		{
			// TODO
		}
		
		public static function notifyLevelCompletedInUnrealMode(levelIndex:int):void
		{
			// TODO
		}
		
		public static function notifyLevelImproved():void
		{
			instance.notifyAchievementCompleted(AchievementResources.NAME_PERFECTIONIST);
		}
		
		public static function notifyEnemyUnitPassed(item:IWeapon):void
		{
			enemyPassedInOneMission++;
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.ENEMY_PASSED));
			
			GameTracker.api.customMsg(TrackingMessages.ENEMY_PASSED + ":" + item.currentInfo.weaponId + " " + item.currentInfo.level + "," + item.x + "," + item.y);
		}
		
		public static function notifyEnemyUnitDestroyed(item:IWeapon):void
		{
			// checks for destructor
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_DESTRUCTOR, 1);
			
			// checks for obliterator
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_OBLITERATOR, 1);
			
			if (StatisticsController.allowStatiscits)
			{
				var param:LogParameters = new LogParameters(LogMessages.ENEMY_DESTROYED);
				if (item is TrajectoryFollower)
					param.pathPercentagePassed = TrajectoryFollower(item).getPassedPercentage();
				
				StatisticsController.logMessage(param);
			}
			
			GameTracker.api.customMsg(TrackingMessages.ENEMY_DESTROYED + ":" + item.currentInfo.weaponId + " " + item.currentInfo.level + "," + item.x + "," + item.y + ((item is TrajectoryFollower) ? ("," + TrajectoryFollower(item).getPassedPercentage().toFixed(2)) : ""));
		}
		
		public static function notifyBombDropped(x:Number, y:Number):void
		{
			// checks for bommer
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_BOMBER, 1);
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.BOMB_DROPPED));
			
			GameTracker.api.customMsg(TrackingMessages.BOMB_DROPPED + ":" + x + "," + y);
		}
		
		public static function notifyAirSupportCalled(x:Number, y:Number):void
		{
			// checks for king of skyes
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_KING_OF_SKYES, 1);
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.AIR_SUPPORT_CALLED));
			
			GameTracker.api.customMsg(TrackingMessages.AIR_SUPPORT_CALLED + ":" + x + "," + y);
		}
		
		public static function notifyTowerPlaced(item:Weapon):void
		{
			// checks for constructor
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_BUILDER, 1);
			
			// checks for constructor
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_CONSTRUCTOR, 1);
		}
		
		public static function notifyUserWeaponUpgradedInDevCenter():void
		{
			// checks if the upgrade is at maximum (hi-tech)
			
			if (instance.gameInfoController.gameInfo.developmentInfo.allWeaponsDeveloded())
				instance.notifyAchievementCompleted(AchievementResources.NAME_HI_TECH);
		}
		
		/////////////////
		
		public static function notifyUserUnitFrozen():void
		{
			// checks for teleported
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_ICE, 1);
		}
		
		public static function notifyEmemyUnitTeleported():void
		{
			// checks for teleported
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_TELEPORTER, 1);
		}
		
		public static function notifyMoneyEarned(amount:int):void
		{
			// checks for businessman
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_BUSINESSMAN, amount);
			
			// checks for magnat
			instance.checkGoalValueForInfoByName(AchievementResources.NAME_MAGNAT, amount);
		}
		
		public static function notifyBossDestroyed():void
		{
			instance.notifyAchievementCompleted(AchievementResources.NAME_BOSS);
		}
		
		//////////////////
		
		public var gameInfoController:GameInfoController = null;
		
		///////////////
		
		public function AchievementsController()
		{
			instance = this;
		}
		
		///////////////
		
		private function getInfoByName(name:String):AchievementInfo
		{
			var infos:Array = gameInfoController.gameInfo.achievementInfos;
			
			for each (var info:AchievementInfo in infos)
				if (info.name == name)
					return info;
			
			return null;
		}
		
		private function notifyAchievementCompleted(name:String):void
		{
			var info:AchievementInfo = getInfoByName(name);
			
			if (!info.achieved)
			{
				info.achieved = true;
				dispatchEvent(new AchievementEvent(AchievementEvent.ACHIEVEMENT_REACHED, info));
			}
		}
		
		private function checkGoalValueForInfoByName(name:String, addValue:int, levelIndex:int = -1):void
		{
			var info:AchievementInfo = getInfoByName(name);
			
			if (!info.achieved)
			{
				// check for unique indices of missions
				if (info.inSeveralMissions)
				{
					if (levelIndex == -1)
						throw new Error("Level Index cannot be -1 for mission's index dependent achievements");
					
					if (!info.collectedMissions)
						info.collectedMissions = [levelIndex];
					else
					{
						for each (var index:int in info.collectedMissions)
							if (index == levelIndex)
								return;
						
						info.collectedMissions.push(levelIndex);
					}
				}
				
				info.currentValue += addValue;
				
				if (info.currentValue >= info.goalValue)
				{
					info.achieved = true;
					dispatchEvent(new AchievementEvent(AchievementEvent.ACHIEVEMENT_REACHED, info));
				}
			}
		}
	}

}