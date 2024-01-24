/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import constants.ScoresConstants;
	import events.ScoreEvent;
	import flash.events.EventDispatcher;
	import infoObjects.WeaponInfo;
	import mainPack.DifficultyConfig;
	import mainPack.ModeSettings;
	import supportClasses.LogParameters;
	import supportClasses.resources.LogMessages;
	import supportClasses.resources.WeaponResources;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ScoreController extends EventDispatcher
	{
		private var currentLevelIndex:int = 0;
		
		private var currentLevelMode:String = null;
		
		////////////////
		
		public function ScoreController()
		{
			reset(0, ModeSettings.MODE_NORMAL);
		}
		
		////////////////
		
		private var _scores:int = 0;
		
		public function get scores():int
		{
			return _scores;
		}
		
		public function set scores(value:int):void
		{
			if (_scores != value)
			{
				var prevValue:int = _scores;
				
				_scores = value;
				
				dispatchEvent(new ScoreEvent(ScoreEvent.SCORES_CHANGED, value, value > prevValue));
				
				if (StatisticsController.allowStatiscits)
				{
					var param:LogParameters = new LogParameters(LogMessages.MONEY_CHANGED);
					param.moneyAvailableNewValue = value;
					StatisticsController.logMessage(param);
				}
			}
		}
		
		////////////////
		
		public function reset(gameLevel:int, levelMode:String):void
		{
			currentLevelIndex = gameLevel;
			currentLevelMode = levelMode;
			
			resetScoresToDefault();
		}
		
		private function resetScoresToDefault():void
		{
			if (currentLevelMode != ModeSettings.MODE_NORMAL)
				scores = ModeSettings.getScoresForLevel(currentLevelIndex, currentLevelMode);
			
			switch (currentLevelIndex)
			{
				case 0: 
					scores = ScoresConstants.LEVEL_0_SCORES;
					break;
				case 1: 
					scores = ScoresConstants.LEVEL_1_SCORES;
					break;
				case 2: 
					scores = ScoresConstants.LEVEL_2_SCORES;
					break;
				case 3: 
					scores = ScoresConstants.LEVEL_3_SCORES;
					break;
				case 4: 
					scores = ScoresConstants.LEVEL_4_SCORES;
					break;
				case 5: 
					scores = ScoresConstants.LEVEL_5_SCORES;
					break;
				case 6: 
					scores = ScoresConstants.LEVEL_6_SCORES;
					break;
				case 7: 
					scores = ScoresConstants.LEVEL_7_SCORES;
					break;
				case 8: 
					scores = ScoresConstants.LEVEL_8_SCORES;
					break;
				case 9: 
					scores = ScoresConstants.LEVEL_9_SCORES;
					break;
			}
			
			if (DifficultyConfig.currentBonusInfo)
				scores *= DifficultyConfig.currentBonusInfo.totalMoneyCoefficient;
		}
		
		// cutting scores
		
		public function cutScoresForBuying(item:*):void
		{
			scores -= WeaponInfo(item.currentInfo).buyPrice;
		}
		
		public function isAffordable(item:*):Boolean
		{
			return (scores >= WeaponInfo(item.currentInfo).buyPrice);
		}
		
		public function addScoresAfterSellingItem(item:*):void
		{
			var addedScores:int = getSellPriceForItem(item);
			
			scores += addedScores;
			
			AchievementsController.notifyMoneyEarned(addedScores);
		}
		
		// adding scores
		
		public function addScoresForDestroyedEnemy(enemy:IWeapon):int
		{
			var addedScores:int = ModeSettings.earningMonyAllowedForLevel(currentLevelIndex, currentLevelMode) ? enemy.currentInfo.destroyBonus * DifficultyConfig.currentBonusInfo.addMoneyForDestroyingEnemyCoefficient : 0;
			
			scores += addedScores;
			
			AchievementsController.notifyMoneyEarned(addedScores);
			
			return addedScores;
		}
		
		public function addScoresForImpatience(elapsedProgress:Number):int
		{
			var addedScores:int = ModeSettings.earningMonyAllowedForLevel(currentLevelIndex, currentLevelMode) ? (ScoresConstants.FULL_PROGRESS_BONUS * (1 - elapsedProgress)) : 0;
			
			scores += addedScores;
			
			AchievementsController.notifyMoneyEarned(addedScores);
			
			return addedScores;
		}
		
		// info methods
		
		public function getBuyPriceForItem(item:*, takeAffordabilityIntoConsideration:Boolean = true):int
		{
			var p:int = WeaponInfo(item.currentInfo).buyPrice;
			
			return (((p <= scores) || !takeAffordabilityIntoConsideration) ? p : 0);
		}
		
		public function getRepairPriceForItem(item:*, takeAffordabilityIntoConsideration:Boolean = true):int
		{
			var p:int = (item is Weapon) ? Math.round(Weapon(item).currentInfo.totalRepairPrice * Weapon(item).getDamagePercentage() * DifficultyConfig.currentBonusInfo.repairCostCoefficient) : 0;
			
			return (((p <= scores) || !takeAffordabilityIntoConsideration) ? p : 0);
		}
		
		public function getSellPriceForItem(item:*):int
		{
			return DifficultyConfig.currentBonusInfo.moneyReturnedWhenSoldCoefficient == 1 ? WeaponInfo(item.currentInfo).sellPrice : calcTotalPrice(WeaponInfo(item.currentInfo)) * DifficultyConfig.currentBonusInfo.moneyReturnedWhenSoldCoefficient;
		}
		
		public function getUpgradePriceForItem(item:*, takeAffordabilityIntoConsideration:Boolean = true):int
		{
			var p:int = ((item is Weapon) && Weapon(item).isUpgradable()) ? smartRound(Weapon(item).currentInfo.upgradePrice * DifficultyConfig.currentBonusInfo.upgradeCostCoefficient) : 0;
			
			return (((p <= scores) || !takeAffordabilityIntoConsideration) ? p : 0);
		}
		
		private function calcTotalPrice(info:WeaponInfo):int
		{
			var result:int = 0;
			for (var i:int = 0; i <= info.level; i++)
				result = WeaponResources.getWeaponInfoByIDAndLevel(info.weaponId, i).buyPrice;
			
			return result;
		}
		
		private function smartRound(value:Number):int
		{
			return Math.round(value / 10) * 10;
		}
	
	}

}