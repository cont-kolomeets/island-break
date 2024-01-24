/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.gameInfo
{
	import infoObjects.WeaponInfo;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * DevelopmentInfo contains information about the current development status.
	 * By default all levels are set to -1, which means that they are locked.
	 */
	public class DevelopmentInfo
	{
		public static function toObject(devInfo:DevelopmentInfo):Object
		{
			var obj:Object = new Object();
			
			obj.cannonLevel = devInfo.cannonLevel;
			obj.machineGunLevel = devInfo.machineGunLevel;
			obj.shockGunLevel = devInfo.shockGunLevel;
			obj.bombSupportLevel = devInfo.bombSupportLevel;
			obj.airSupportLevel = devInfo.airSupportLevel;
			obj.repairCenterLevel = devInfo.repairCenterLevel;
			obj.bombSupportWaitingForUserNotificationFlag = devInfo.bombSupportWaitingForUserNotificationFlag;
			obj.airSupportWaitingForUserNotificationFlag = devInfo.airSupportWaitingForUserNotificationFlag;
			obj.electricTowerWaitingForUserNotificationFlag = devInfo.electricTowerWaitingForUserNotificationFlag;
			obj.repairCenterWaitingForUserNotificationFlag = devInfo.repairCenterWaitingForUserNotificationFlag;
			
			obj.userNowCanUpgradeTowers = devInfo.userNowCanUpgradeTowers;
			
			obj.priceForLastUpdate = devInfo.priceForLastUpdate;
			
			return obj;
		}
		
		public static function fromObject(obj:Object):DevelopmentInfo
		{
			var devInfo:DevelopmentInfo = new DevelopmentInfo();
			
			devInfo.cannonLevel = int(obj.cannonLevel);
			devInfo.machineGunLevel = int(obj.machineGunLevel);
			devInfo.shockGunLevel = int(obj.shockGunLevel);
			devInfo.bombSupportLevel = int(obj.bombSupportLevel);
			devInfo.airSupportLevel = int(obj.airSupportLevel);
			devInfo.repairCenterLevel = int(obj.repairCenterLevel);
			devInfo.bombSupportWaitingForUserNotificationFlag = obj.bombSupportWaitingForUserNotificationFlag;
			devInfo.airSupportWaitingForUserNotificationFlag = obj.airSupportWaitingForUserNotificationFlag;
			devInfo.electricTowerWaitingForUserNotificationFlag = obj.electricTowerWaitingForUserNotificationFlag;
			devInfo.repairCenterWaitingForUserNotificationFlag = obj.repairCenterWaitingForUserNotificationFlag;
			
			devInfo.userNowCanUpgradeTowers = obj.userNowCanUpgradeTowers;
			
			devInfo.priceForLastUpdate = obj.priceForLastUpdate;
			
			return devInfo;
		}
		
		public var cannonLevel:int = -1;
		public var machineGunLevel:int = -1;
		public var shockGunLevel:int = -1;
		public var bombSupportLevel:int = -1;
		public var airSupportLevel:int = -1;
		public var repairCenterLevel:int = -1;
		
		// must be set manually
		public var priceForLastUpdate:int = 0;
		
		// not serialized
		public var lockedForMode:Boolean = false;
		
		///////////////////
		
		public function DevelopmentInfo()
		{
		}
		
		///////////////////
		
		public function copy():DevelopmentInfo
		{
			return fromObject(toObject(this));
		}
		
		public function levelIsDevelopedForWeapon(weaponInfo:WeaponInfo):Boolean
		{
			if (!weaponInfo)
				return false;
			
			switch (weaponInfo.weaponId)
			{
				case WeaponResources.USER_CANNON: 
					return Boolean(weaponInfo.level <= cannonLevel);
				
				case WeaponResources.USER_MACHINE_GUN: 
					return Boolean(weaponInfo.level <= machineGunLevel);
				
				case WeaponResources.USER_ELECTRIC_TOWER: 
					return Boolean(weaponInfo.level <= shockGunLevel);
				
				case WeaponResources.USER_BOMB_SUPPORT: 
					return Boolean(weaponInfo.level <= bombSupportLevel);
				
				case WeaponResources.USER_AIR_SUPPORT: 
					return Boolean(weaponInfo.level <= airSupportLevel);
				
				case WeaponResources.USER_REPAIR_CENTER: 
					return Boolean(weaponInfo.level <= repairCenterLevel);
			}
			
			return false;
		}
		
		public function setLevelUpForWeapon(weaponId:String):void
		{
			switch (weaponId)
			{
				case WeaponResources.USER_CANNON: 
					cannonLevel++;
					
					if (cannonLevel > 0)
						userNowCanUpgradeTowers = true;
					break;
				
				case WeaponResources.USER_MACHINE_GUN: 
					machineGunLevel++;
					
					if (machineGunLevel > 0)
						userNowCanUpgradeTowers = true;
					break;
				
				case WeaponResources.USER_ELECTRIC_TOWER: 
					electricTowerWaitingForUserNotificationFlag = electricTowerWaitingForUserNotificationFlag || Boolean(shockGunLevel == -1);
					shockGunLevel++;
					
					if (shockGunLevel > 0)
						userNowCanUpgradeTowers = true;
					break;
				
				case WeaponResources.USER_BOMB_SUPPORT: 
					bombSupportWaitingForUserNotificationFlag = bombSupportWaitingForUserNotificationFlag || Boolean(bombSupportLevel == -1);
					bombSupportLevel++;
					break;
				
				case WeaponResources.USER_AIR_SUPPORT: 
					airSupportWaitingForUserNotificationFlag = airSupportWaitingForUserNotificationFlag || Boolean(airSupportLevel == -1);
					airSupportLevel++;
					break;
				
				case WeaponResources.USER_REPAIR_CENTER: 
					repairCenterWaitingForUserNotificationFlag = repairCenterWaitingForUserNotificationFlag || Boolean(repairCenterLevel == -1);
					repairCenterLevel++;
					
					if (repairCenterLevel > 0)
						userNowCanUpgradeTowers = true;
					break;
			}
		}
		
		///////////////////// user actions flags
		
		public var userNowCanUpgradeTowers:Boolean = false;
		
		private var bombSupportWaitingForUserNotificationFlag:Boolean = false;
		
		// returns true if bomb support has been developed for the first time, but a user needs to be notified about how to use it.
		public function checkIfBombSupportIsWaitingForUserNotification(resetAfterReading:Boolean = true):Boolean
		{
			var result:Boolean = bombSupportWaitingForUserNotificationFlag;
			
			if (resetAfterReading)
				bombSupportWaitingForUserNotificationFlag = false;
			
			return result;
		}
		
		private var airSupportWaitingForUserNotificationFlag:Boolean = false;
		
		// returns true if air support has been developed for the first time, but a user needs to be notified about how to use it.
		public function checkIfAirSupportIsWaitingForUserNotification(resetAfterReading:Boolean = true):Boolean
		{
			var result:Boolean = airSupportWaitingForUserNotificationFlag;
			
			if (resetAfterReading)
				airSupportWaitingForUserNotificationFlag = false;
			
			return result;
		}
		
		private var electricTowerWaitingForUserNotificationFlag:Boolean = false;
		
		// returns true if electric tower has been developed for the first time, but a user needs to be notified about how to use it.
		public function checkIfElectricTowerIsWaitingForUserNotification(resetAfterReading:Boolean = true):Boolean
		{
			var result:Boolean = electricTowerWaitingForUserNotificationFlag;
			
			if (resetAfterReading)
				electricTowerWaitingForUserNotificationFlag = false;
			
			return result;
		}
		
		private var repairCenterWaitingForUserNotificationFlag:Boolean = false;
		
		// returns true if repair center has been developed for the first time, but a user needs to be notified about how to use it.
		public function checkIfRepairCenterIsWaitingForUserNotification(resetAfterReading:Boolean = true):Boolean
		{
			var result:Boolean = repairCenterWaitingForUserNotificationFlag;
			
			if (resetAfterReading)
				repairCenterWaitingForUserNotificationFlag = false;
			
			return result;
		}
		
		/////////////////////
		
		public function allWeaponsDeveloded():Boolean
		{
			if (WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_CANNON, 0).maxUpgradeLevel > cannonLevel)
				return false;
			if (WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_MACHINE_GUN, 0).maxUpgradeLevel > machineGunLevel)
				return false;
			if (WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_ELECTRIC_TOWER, 0).maxUpgradeLevel > shockGunLevel)
				return false;
			if (WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_BOMB_SUPPORT, 0).maxUpgradeLevel > bombSupportLevel)
				return false;
			if (WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_AIR_SUPPORT, 0).maxUpgradeLevel > airSupportLevel)
				return false;
			if (WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_REPAIR_CENTER, 0).maxUpgradeLevel > repairCenterLevel)
				return false;
			
			return true;
		}
		
		public function getMinPriceNeededForNextDevelopment():int
		{
			if (allWeaponsDeveloded())
				return -1;
			
			var finalPrice:int = int.MAX_VALUE;
			var price:int = -1;
			
			for each (var id:String in getWeaponIDs())
			{
				price = getNextPriceForWeaponId(id);
				
				if (price != -1)
					finalPrice = Math.min(finalPrice, price);
			}
			
			return finalPrice == int.MAX_VALUE ? -1 : finalPrice;
		}
		
		public function getMinPriceToMakeFirstDevelopment():int
		{
			// bombs are the cheapest to develop
			var info:WeaponInfo = WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_BOMB_SUPPORT, 0);
			
			return info ? info.developmentPrice : -1;
		}
		
		public function getNextPriceForWeaponId(weaponId:String):int
		{
			var level:int = -1;
			
			switch (weaponId)
			{
				case WeaponResources.USER_CANNON: 
					level = cannonLevel + 1;
					break;
				case WeaponResources.USER_MACHINE_GUN: 
					level = machineGunLevel + 1;
					break;
				case WeaponResources.USER_ELECTRIC_TOWER: 
					level = shockGunLevel + 1;
					break;
				case WeaponResources.USER_AIR_SUPPORT: 
					level = airSupportLevel + 1;
					break;
				case WeaponResources.USER_BOMB_SUPPORT: 
					level = bombSupportLevel + 1;
					break;
				case WeaponResources.USER_REPAIR_CENTER: 
					level = repairCenterLevel + 1;
					break;
			}
			
			var info:WeaponInfo = WeaponResources.getWeaponInfoByIDAndLevel(weaponId, level);
			
			return info ? info.developmentPrice : -1;
		}
		
		private function getWeaponIDs():Array
		{
			return [WeaponResources.USER_CANNON, WeaponResources.USER_MACHINE_GUN, WeaponResources.USER_ELECTRIC_TOWER, WeaponResources.USER_BOMB_SUPPORT, WeaponResources.USER_AIR_SUPPORT, WeaponResources.USER_REPAIR_CENTER];
		}
		
		// returns a value from 0 to 1.
		public function getOverallDevelopmentProgress():Number
		{
			return (6 + cannonLevel + machineGunLevel + shockGunLevel + bombSupportLevel + airSupportLevel + repairCenterLevel) / 18;
		}
	}

}