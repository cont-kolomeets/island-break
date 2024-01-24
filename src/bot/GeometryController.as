/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package bot
{
	import constants.MapConstants;
	import flash.geom.Point;
	import infoObjects.gameInfo.DevelopmentInfo;
	import nslib.AIPack.grid.GridArray;
	import nslib.AIPack.grid.Location;
	import nslib.AIPack.grid.LocationConstants;
	import nslib.utils.ArrayList;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	import weapons.user.UserCannon;
	import weapons.user.UserElectricTower;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class GeometryController
	{
		public var balanceController:WeaponBalanceController = new WeaponBalanceController();
		
		private var usedTrajectoryCount:int = 0;
		
		private var numPlaceCount:int = 0;
		
		/////////
		
		public function GeometryController()
		{
		
		}
		
		/////////
		
		public function reset():void
		{
			usedTrajectoryCount = 0;
			numPlaceCount = 0;
		}
		
		public function notifyItemPlaced():void
		{
			numPlaceCount++;
		}
		
		public function isPendingUpgrade():Boolean
		{
			var devInfo:DevelopmentInfo = GameBot.getCurrentDevelopmentInfo();
			
			// if upgrade is impossible
			if (devInfo.cannonLevel < 1 && devInfo.machineGunLevel < 1 && devInfo.shockGunLevel < 1 && devInfo.repairCenterLevel < 1)
				return false;
			
			if (allItemsUpgraded())
				return false;
			
			var upgradeRepetition:int = GameBot.getCurrentLevelIndex() < 5 ? 2 : 1;
			
			return numPlaceCount >= upgradeRepetition;
		}
		
		private function allItemsUpgraded():Boolean
		{
			var devInfo:DevelopmentInfo = GameBot.getCurrentDevelopmentInfo();
			
			for each (var item:IWeapon in balanceController.placedItems.source)
				if (item is Weapon)
					if (Weapon(item).nextInfo && devInfo.levelIsDevelopedForWeapon(Weapon(item).nextInfo))
						return false;
			
			return true;
		}
		
		public function upgradeSomeUnitIfNecessary():Boolean
		{
			if (!isPendingUpgrade())
				return false;
			
			var item:IWeapon = null;
			
			var needUpgradeElectricTower:Boolean = false;
			
			if (GameBot.getCurrentLevelIndex() >= 5)
			{
				var numUpgradedElectricTowers:int = 0;
				var numUpgradedCannons:int = 0;
				
				var desiredElectricTowerUpgradeLevel:int = GameBot.getCurrentLevelIndex() >= 7 ? 2 : 1;
				
				for each (item in balanceController.placedItems.source)
					if (item is UserElectricTower && UserElectricTower(item).currentInfo.level > (desiredElectricTowerUpgradeLevel - 1))
						numUpgradedElectricTowers++;
					else if (item is UserCannon && UserCannon(item).currentInfo.level > 0)
						numUpgradedCannons++;
				
				if (numUpgradedElectricTowers < balanceController.numElectricTowers && numUpgradedElectricTowers < numUpgradedCannons)
					needUpgradeElectricTower = true;
			}
			
			for each (item in balanceController.placedItems.source)
				if (!needUpgradeElectricTower || item is UserElectricTower)
					if (item is Weapon && GameBot.canUpgradeTower(item as Weapon))
					{
						GameBot.upgradeTower(item as Weapon);
						numPlaceCount = 0;
						return true;
					}
			
			return false;
		}
		
		public function recommentPointToPlaceItemAt(item:Weapon, assignPathPreference:Boolean = true):Point
		{
			var trajectories:Array = GameBot.getCurrentTrajectories();
			
			if (usedTrajectoryCount >= trajectories.length)
				usedTrajectoryCount = 0;
			
			// if preference is already assigned, use it
			if (item.preferenceDescriptor.preferredPathIndex != -1)
				usedTrajectoryCount = item.preferenceDescriptor.preferredPathIndex;
			
			var trajectory:ArrayList = trajectories[usedTrajectoryCount];
			usedTrajectoryCount++;
			
			var middleIndex:int = trajectory.length / 2;
			var offsetCount:int = 0;
			var direction:int = 1;
			
			while (offsetCount < middleIndex)
			{
				var location:Location = findFreeLocationAround(trajectory, middleIndex + offsetCount * direction);
				
				if (location)
				{
					if (assignPathPreference && trajectories.length > 1)
						item.preferenceDescriptor.preferredPathIndex = usedTrajectoryCount - 1;
					
					return new Point(location.x, location.y);
				}
				else
				{
					if (direction == 1)
						direction = -1;
					else
					{
						// increase by one
						direction = 1;
						offsetCount++;
					}
				}
			}
			
			return null;
		}
		
		private function findFreeLocationAround(trajectory:ArrayList, checkIndex:int):Location
		{
			var grid:GridArray = GameBot.getCurrentGrid();
			var tLocation:Location = trajectory.getItemAt(checkIndex) as Location;
			
			if (!tLocation)
				return null;
			
			for (var i:int = -1; i <= 1; i++)
				for (var j:int = -1; j <= 1; j++)
				{
					if (i == 0 && j == 0)
						continue;
					
					var gridLocation:Location = grid.getElementAtIndex(tLocation.indexX + i, tLocation.indexY + j);
					
					if (locationIsFreeForWeapon(gridLocation))
						return gridLocation;
				}
			
			return null;
		}
		
		private function locationIsFreeForWeapon(location:Location):Boolean
		{
			return (location && location.id == LocationConstants.OBSTACLE && location.filter == MapConstants.LOCATION_ONLY_USER_WEAPON_FREE_FILTER);
		}
	
	}

}