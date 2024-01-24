/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources
{
	import flash.display.Bitmap;
	import infoObjects.gameInfo.DevelopmentInfo;
	import infoObjects.gameInfo.GameInfo;
	import infoObjects.TipInfo;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TipResources
	{
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/main objective.png")]
		private static var mainObjectiveImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/basic towers.png")]
		private static var basicTowersImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/weapon menu.png")]
		private static var weaponMenuImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/handling enemies.png")]
		private static var handlingEnemiesImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/relevant enemy.png")]
		private static var relevantEnemyImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/hot keys.png")]
		private static var hotKeysImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/bomb support developed.png")]
		private static var bombSupportDevelopedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/air support developed.png")]
		private static var airSupportDevelopedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/electric tower developed.png")]
		private static var electricTowerDevelopedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/repair center developed.png")]
		private static var repairCenterDevelopedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/path priority.png")]
		private static var pathPriorityImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/hostile aircraft priority.png")]
		private static var hostileAircraftsImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/can undo changes.png")]
		private static var canUndoChangesImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/upgrade indicator.png")]
		private static var upgradeIndicatorImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/fuel indicator.png")]
		private static var fuelIndicatorImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/direction switch.png")]
		private static var directionSwitchImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips/advanced targeting.png")]
		private static var advancedTargetingImage:Class;
		
		//////////////////////
		
		public static const USER_CAN_UNDO_CHANGES_TIP_INDEX:int = 6;
		
		private static var tipInfos:Array = [];
		
		private static var imagesInitial:Array = null;
		
		private static var imagesCollected:Array = null;
		
		// index to add additional tooltip to
		private static var additionalToolTipIndex:int = -1;
		
		public static function initialize():void
		{
			tipInfos.push(new TipInfo(0, [mainObjectiveImage, basicTowersImage, weaponMenuImage], "INSTRUCTIONS")); // starting tips
			tipInfos.push(new TipInfo(1, [handlingEnemiesImage], "GAME HINT")); // enemies handling
			tipInfos.push(new TipInfo(2, [relevantEnemyImage], "GAME HINT")); // relevant enemy
			tipInfos.push(new TipInfo(3, [hotKeysImage], "GAME HINT")); // hot keys
			tipInfos.push(new TipInfo(4, [pathPriorityImage], "GAME HINT"));
			tipInfos.push(new TipInfo(5, [hostileAircraftsImage], "GAME HINT"));
			tipInfos.push(new TipInfo(6, [canUndoChangesImage], "GAME HINT"));
			tipInfos.push(new TipInfo(7, [upgradeIndicatorImage], "GAME HINT"));
			tipInfos.push(new TipInfo(8, [fuelIndicatorImage], "GAME HINT"));
			tipInfos.push(new TipInfo(9, [directionSwitchImage], "GAME HINT"));
			tipInfos.push(new TipInfo(10, [advancedTargetingImage], "GAME HINT"));
			
			additionalToolTipIndex = tipInfos.length;
			
			// all images for encyclopedia/tips panel
			imagesInitial = [mainObjectiveImage, basicTowersImage, weaponMenuImage, handlingEnemiesImage, relevantEnemyImage, advancedTargetingImage, hotKeysImage, pathPriorityImage, hostileAircraftsImage, canUndoChangesImage, fuelIndicatorImage, directionSwitchImage];
			imagesCollected = imagesInitial.slice();
		}
		
		public static function getTipInfoAt(tipIndex:int):TipInfo
		{
			return tipInfos[tipIndex];
		}
		
		public static function getNumTips():int
		{
			return tipInfos.length;
		}
		
		public static function getTipImageAt(imageIndex:int):Class
		{
			return imagesCollected[imageIndex];
		}
		
		public static function getNumImages():int
		{
			return imagesCollected.length;
		}
		
		public static function getIntroTipIndexForLevel(levelIndex:int, gameInfo:GameInfo):int
		{
			var levelTipIndex:int = -1;
			
			switch (levelIndex)
			{
				case 0: 
					levelTipIndex = 0;
					break;
				case 2: 
					levelTipIndex = 4;
					break;
				case 3: 
					levelTipIndex = 5;
					break;
				case 9: 
					levelTipIndex = 9;
					break;
			}
			
			var developmentInfo:DevelopmentInfo = gameInfo.developmentInfo;
			var bombSupportWaiting:Boolean = !gameInfo.helpInfo.userNotifiedHowToUseBombSupport && developmentInfo.checkIfBombSupportIsWaitingForUserNotification(true);
			var airSupportWaiting:Boolean = !gameInfo.helpInfo.userNotifiedHowToUseAirSupport && developmentInfo.checkIfAirSupportIsWaitingForUserNotification(true);
			var electricTowerWaiting:Boolean = !gameInfo.helpInfo.userNotifiedHowToUseElectricTower && developmentInfo.checkIfElectricTowerIsWaitingForUserNotification(true);
			var repairCenterWaiting:Boolean = !gameInfo.helpInfo.userNotifiedHowToUseRepairCenter && developmentInfo.checkIfRepairCenterIsWaitingForUserNotification(true);
			var notifyAboutUpgradeIndicator:Boolean = !gameInfo.helpInfo.userNotifiedAboutUpgradeIndicator && developmentInfo.userNowCanUpgradeTowers;
			
			if (bombSupportWaiting || airSupportWaiting || electricTowerWaiting || repairCenterWaiting || notifyAboutUpgradeIndicator)
			{
				// creating additional tooltip
				// cut the array firts
				if (tipInfos.length > additionalToolTipIndex)
					tipInfos.length = additionalToolTipIndex;
				
				var imagesArray:Array = [];
				
				if (bombSupportWaiting)
				{
					gameInfo.helpInfo.userNotifiedHowToUseBombSupport = true;
					imagesArray.push(bombSupportDevelopedImage);
				}
				if (airSupportWaiting)
				{
					gameInfo.helpInfo.userNotifiedHowToUseAirSupport = true;
					imagesArray.push(airSupportDevelopedImage);
				}
				if (electricTowerWaiting)
				{
					gameInfo.helpInfo.userNotifiedHowToUseElectricTower = true;
					imagesArray.push(electricTowerDevelopedImage);
				}
				if (repairCenterWaiting)
				{
					gameInfo.helpInfo.userNotifiedHowToUseRepairCenter = true;
					imagesArray.push(repairCenterDevelopedImage);
				}
				if (notifyAboutUpgradeIndicator)
				{
					gameInfo.helpInfo.userNotifiedAboutUpgradeIndicator = true;
					imagesArray.push(upgradeIndicatorImage);
				}
				
				var additionalTip:TipInfo = new TipInfo(additionalToolTipIndex, null, null);
				
				if (levelTipIndex == -1)
				{
					additionalTip.images = imagesArray;
					additionalTip.type = "NEW POWER";
				}
				else
				{
					// combine with the level tip
					var levelTip:TipInfo = tipInfos[levelTipIndex];
					
					for (var i:int = levelTip.images.length - 1; i >= 0; i--)
						imagesArray.unshift(levelTip.images[i]);
					
					additionalTip.images = imagesArray;
					additionalTip.type = levelTip.type;
				}
				
				tipInfos.push(additionalTip);
				
				// update the total collection for the encyclopedia
				updateTipsCollectionForGameInfo(gameInfo);
				
				return additionalToolTipIndex;
			}
			
			return levelTipIndex;
		}
		
		public static function updateTipsCollectionForGameInfo(gameInfo:GameInfo):void
		{
			imagesCollected = imagesInitial.slice();
			
			if (gameInfo.helpInfo.userNotifiedHowToUseBombSupport)
				imagesCollected.push(bombSupportDevelopedImage);
			
			if (gameInfo.helpInfo.userNotifiedHowToUseAirSupport)
				imagesCollected.push(airSupportDevelopedImage);
			
			if (gameInfo.helpInfo.userNotifiedHowToUseElectricTower)
				imagesCollected.push(electricTowerDevelopedImage);
			
			if (gameInfo.helpInfo.userNotifiedHowToUseRepairCenter)
				imagesCollected.push(repairCenterDevelopedImage);
			
			if (gameInfo.helpInfo.userNotifiedAboutUpgradeIndicator)
				imagesCollected.push(upgradeIndicatorImage);
		}
	}

}