/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package bot
{
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class GameBot
	{
		// global flag defining whether using bot is allowed in the game
		//public static var allowBot:Boolean = true;
		
		public static var supressUI:Boolean = false;
		
		////////////////////
		
		// game controll
		public static var getCurrentLevelIndex:Function = null; // int
		public static var setCurrentLevelIndex:Function = null; // void
		public static var resetLevel:Function = null; // void
		public static var startGame:Function = null; // void
		public static var startWaveEarly:Function = null; // void
		public static var pauseGame:Function = null; // void
		public static var resumeGame:Function = null; // void
		public static var accelerateGame:Function = null; // void
		public static var setGameInfoForTest:Function = null; // void
		public static var showGameStage:Function = null; // void
		public static var getCurrentGameInfo:Function = null; // GameInfo
		public static var getNumLivesTotal:Function = null; // int
		public static var getNumLivesLeft:Function = null; // int
		
		// accessing map
		public static var getCurrentGrid:Function = null; // GridArray
		public static var getCurrentTrajectories:Function = null; // Array of ArrayList
		
		// building towers
		public static var getAffordableTowers:Function = null; // Array of Weapon
		public static var getCurrentDevelopmentInfo:Function = null; // DevelopmentInfo
		public static var takeItemFromTheMenu:Function = null; // void
		public static var placeTowerAt:Function = null;
		
		// operations with towers
		public static var canUpgradeTower:Function = null; // Boolean
		public static var upgradeTower:Function = null;
		public static var repairTower:Function = null;
		public static var sellTower:Function = null;
		
		// operations with units
		public static var getEnemyUnits:Function = null; // Array of IWeapon
		
		// support
		public static var canDropBomb:Function = null;
		public static var dropBombAt:Function = null;
		public static var dispatchAirSupportAt:Function = null;

		public static var getEnemies:Function = null; // Array of IWeapon
		public static var setActiveEnemy:Function = null; // void
		
		///////////////////
		
		/// single level
		
		public static function get isPlaying():Boolean
		{
			return SingleLevelBot.isPlaying || TrackingBot.isPlaying;
		}
		
		public static function startBotForCurrentLevel():void
		{
			SingleLevelBot.startBotForCurrentLevel();
		}
		
		public static function stopBotForCurrentLevel():void
		{
			SingleLevelBot.stopBotForCurrentLevel();
		}
		
		public static function startTrackingBotForCurrentLevel():void
		{
			TrackingBot.startBotForCurrentLevel();
		}
		
		public static function stopTrackingBotForCurrentLevel():void
		{
			TrackingBot.stopBotForCurrentLevel();
		}
		
		public static function notifyUserWeaponRemoved(item:Weapon):void
		{
			SingleLevelBot.notifyUserWeaponRemoved(item);
		}
		
		/// global testing
		
		public static function openGlobalTextMenu():void
		{
			GlobalTestBot.openGlobalTextMenu();
		}
	}

}