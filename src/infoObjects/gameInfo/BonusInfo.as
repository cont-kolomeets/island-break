/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.gameInfo
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class BonusInfo
	{
		public static function fromObject(obj:Object):BonusInfo
		{
			var bonusInfo:BonusInfo = new BonusInfo();
			
			bonusInfo.bombSupportCoolDownCoefficient = obj.bombSupportCoolDownCoefficient;
			bonusInfo.airSupportCoolDownCoefficient = obj.airSupportCoolDownCoefficient;
			bonusInfo.airSupportWorkingTimeCoefficient = obj.airSupportWorkingTimeCoefficient;
			bonusInfo.totalMoneyCoefficient = obj.totalMoneyCoefficient;
			bonusInfo.addMoneyForDestroyingEnemyCoefficient = obj.addMoneyForDestroyingEnemyCoefficient;
			
			bonusInfo.moneyReturnedWhenSoldCoefficient = obj.moneyReturnedWhenSoldCoefficient;
			bonusInfo.upgradeCostCoefficient = obj.upgradeCostCoefficient;
			bonusInfo.repairCostCoefficient = obj.repairCostCoefficient;
			bonusInfo.repairRateCoefficient = obj.repairRateCoefficient;
			
			bonusInfo.dealingDoubleDamageProbabilityForMissiles = obj.dealingDoubleDamageProbabilityForMissiles;
			
			return bonusInfo;
		}
		
		public static function toObject(bonusInfo:BonusInfo):Object
		{
			var obj:Object = new Object();
			
			obj.bombSupportCoolDownCoefficient = bonusInfo.bombSupportCoolDownCoefficient;
			obj.airSupportCoolDownCoefficient = bonusInfo.airSupportCoolDownCoefficient;
			obj.airSupportWorkingTimeCoefficient = bonusInfo.airSupportWorkingTimeCoefficient;
			obj.totalMoneyCoefficient = bonusInfo.totalMoneyCoefficient;
			obj.addMoneyForDestroyingEnemyCoefficient = bonusInfo.addMoneyForDestroyingEnemyCoefficient;
			
			obj.moneyReturnedWhenSoldCoefficient = bonusInfo.moneyReturnedWhenSoldCoefficient;
			obj.upgradeCostCoefficient = bonusInfo.upgradeCostCoefficient;
			obj.repairCostCoefficient = bonusInfo.repairCostCoefficient;
			obj.repairRateCoefficient = bonusInfo.repairRateCoefficient;
			
			obj.dealingDoubleDamageProbabilityForMissiles = bonusInfo.dealingDoubleDamageProbabilityForMissiles;
			
			return obj;
		}
		
		/////////////////
		
		public var bombSupportCoolDownCoefficient:Number = 1;
		
		public var airSupportCoolDownCoefficient:Number = 1;
		
		public var airSupportWorkingTimeCoefficient:Number = 1;
		
		public var totalMoneyCoefficient:Number = 1;
		
		public var addMoneyForDestroyingEnemyCoefficient:Number = 1;
		
		public var moneyReturnedWhenSoldCoefficient:Number = 1;
		
		public var upgradeCostCoefficient:Number = 1;
		
		public var repairCostCoefficient:Number = 1;
		
		public var repairRateCoefficient:Number = 1;
		
		public var dealingDoubleDamageProbabilityForMissiles:Number = 0;
		
		//////////////////
		
		public function BonusInfo()
		{
		}
	
	}

}