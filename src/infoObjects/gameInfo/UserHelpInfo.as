/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.gameInfo
{
	import infoObjects.WeaponInfo;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UserHelpInfo
	{
		public static function toObject(helpInfo:UserHelpInfo):Object
		{
			var obj:Object = {};
			
			obj.userCollectedEnoughStarsForTheFirstTimeAndAleadyNotified = helpInfo.userCollectedEnoughStarsForTheFirstTimeAndAleadyNotified;
			obj.userMadeFirstDevelopmet = helpInfo.userMadeFirstDevelopmet;
			obj.userNotifiedThatHeCanReconfigureDevelopments = helpInfo.userNotifiedThatHeCanReconfigureDevelopments;
			obj.userNotifiedHowToUseAirSupport = helpInfo.userNotifiedHowToUseAirSupport;
			obj.userNotifiedHowToUseBombSupport = helpInfo.userNotifiedHowToUseBombSupport;
			obj.userNotifiedHowToUseElectricTower = helpInfo.userNotifiedHowToUseElectricTower;
			obj.userNotifiedHowToUseRepairCenter = helpInfo.userNotifiedHowToUseRepairCenter;
			obj.userNotifiedAboutUpgradeIndicator = helpInfo.userNotifiedAboutUpgradeIndicator;
			obj.userCongratulatedAfterFinishingGame = helpInfo.userCongratulatedAfterFinishingGame;
			
			obj.toolTipUserNotifiedAboutNewPowerAirSupport = helpInfo.toolTipUserNotifiedAboutNewPowerAirSupport;
			obj.toolTipUserNotifiedAboutNewPowerBombSupport = helpInfo.toolTipUserNotifiedAboutNewPowerBombSupport;
			
			obj.newEneimesShownHash = helpInfo.newEneimesShownHash;
			obj.newEneimesAppearedOnStageHash = helpInfo.newEneimesAppearedOnStageHash;
			
			return obj;
		}
		
		public static function fromObject(obj:Object):UserHelpInfo
		{
			var helpInfo:UserHelpInfo = new UserHelpInfo();
			
			helpInfo.userCollectedEnoughStarsForTheFirstTimeAndAleadyNotified = obj.userCollectedEnoughStarsForTheFirstTimeAndAleadyNotified;
			helpInfo.userMadeFirstDevelopmet = obj.userMadeFirstDevelopmet;
			helpInfo.userNotifiedThatHeCanReconfigureDevelopments = obj.userNotifiedThatHeCanReconfigureDevelopments;
			helpInfo.userNotifiedHowToUseAirSupport = obj.userNotifiedHowToUseAirSupport;
			helpInfo.userNotifiedHowToUseBombSupport = obj.userNotifiedHowToUseBombSupport;
			helpInfo.userNotifiedHowToUseElectricTower = obj.userNotifiedHowToUseElectricTower;
			helpInfo.userNotifiedHowToUseRepairCenter = obj.userNotifiedHowToUseRepairCenter;
			helpInfo.userNotifiedAboutUpgradeIndicator = obj.userNotifiedAboutUpgradeIndicator;
			helpInfo.userCongratulatedAfterFinishingGame = obj.userCongratulatedAfterFinishingGame;
			
			helpInfo.toolTipUserNotifiedAboutNewPowerAirSupport = obj.toolTipUserNotifiedAboutNewPowerAirSupport;
			helpInfo.toolTipUserNotifiedAboutNewPowerBombSupport = obj.toolTipUserNotifiedAboutNewPowerBombSupport;
			
			helpInfo.newEneimesShownHash = obj.newEneimesShownHash ? obj.newEneimesShownHash : {};
			helpInfo.newEneimesAppearedOnStageHash = obj.newEneimesAppearedOnStageHash ? obj.newEneimesAppearedOnStageHash : {};
			
			return helpInfo;
		}
		
		///////////////
		
		public var userCollectedEnoughStarsForTheFirstTimeAndAleadyNotified:Boolean = false;
		
		public var userMadeFirstDevelopmet:Boolean = false;
		
		public var userNotifiedThatHeCanReconfigureDevelopments:Boolean = false;
		
		public var userNotifiedHowToUseAirSupport:Boolean = false;
		
		public var userNotifiedHowToUseBombSupport:Boolean = false;
		
		public var userNotifiedHowToUseElectricTower:Boolean = false;
		
		public var userNotifiedHowToUseRepairCenter:Boolean = false;
		
		public var userNotifiedAboutUpgradeIndicator:Boolean = false;
		
		public var userCongratulatedAfterFinishingGame:Boolean = false;
		
		/// for tooltips
		public var toolTipUserNotifiedAboutNewPowerAirSupport:Boolean = false;
		public var toolTipUserNotifiedAboutNewPowerBombSupport:Boolean = false;
		
		/// enemies
		
		private var newEneimesShownHash:Object = {};
		
		public function notifyNewEnemyShown(weaponInfo:WeaponInfo):void
		{
			newEneimesShownHash[weaponInfo.weaponId + weaponInfo.level] = true;
		}
		
		public function newEnemyWasShown(weaponInfo:WeaponInfo):Boolean
		{
			return Boolean(newEneimesShownHash[weaponInfo.weaponId + weaponInfo.level] == true);
		}
		
		private var newEneimesAppearedOnStageHash:Object = {};
		
		public function notifyEnemyAppearedOnStage(weaponInfo:WeaponInfo):void
		{
			newEneimesAppearedOnStageHash[weaponInfo.weaponId + weaponInfo.level] = true;
		}
		
		public function enemyAlreadyAppearedOnStage(weaponInfo:WeaponInfo):Boolean
		{
			return Boolean(newEneimesAppearedOnStageHash[weaponInfo.weaponId + weaponInfo.level] == true);
		}
	
	}

}