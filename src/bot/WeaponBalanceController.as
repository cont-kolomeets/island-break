/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package bot
{
	import infoObjects.gameInfo.DevelopmentInfo;
	import nslib.utils.ArrayList;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	import weapons.repairCenter.RepairCenter;
	import weapons.user.UserCannon;
	import weapons.user.UserElectricTower;
	import weapons.user.UserMachineGunTower;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class WeaponBalanceController
	{
		public var placedItems:ArrayList = new ArrayList();
		
		public var numCannons:int = 0;
		
		public var numMachineGuns:int = 0;
		
		public var numElectricTowers:int = 0;
		
		public var numRepairCenters:int = 0;
		
		/////////////
		
		public function WeaponBalanceController()
		{
		
		}
		
		/////////////
		
		public function reset():void
		{
			placedItems.removeAll();
			updateWeaponNumbers();
		}
		
		public function notifyItemPlaced(item:Weapon):void
		{
			placedItems.addItem(item);
			updateWeaponNumbers();
		}
		
		public function notifyItemRemoved(item:Weapon):void
		{
			placedItems.removeItem(item);
			updateWeaponNumbers();
		}
		
		////////////////
		
		private var cannon:Weapon = null;
		private var machineGun:Weapon = null;
		private var electricTower:Weapon = null;
		private var repairCenter:Weapon = null;
		
		public function recommendNextItemToPlace(affordableItems:Array):Weapon
		{
			// case 1 : cannons + machine guns - cannons 70%, machine guns 30%
			// case 2 : cannons + machine guns + electric towers - cannons 60%, machine guns 20%, electric towers 20%
			// case 3 : cannons + machine guns + repair center - cannons 65%, machine guns 30%, repair center 5%
			// case 4 : cannons + machine guns + electric towers + repair center - cannons 55%, machine guns 20%, electric towers 20%, repair center 5%
			
			// case 5: starting from the 6th level: need more electric towers
			// cannons + machine guns + electric towers + repair center - cannons 40%, machine guns 20%, electric towers 35%, repair center 5%
			
			cannon = null;
			machineGun = null;
			electricTower = null;
			repairCenter = null;
			
			for each (var item:*in affordableItems)
				if (item is UserCannon)
					cannon = item;
				else if (item is UserMachineGunTower)
					machineGun = item;
				else if (item is UserElectricTower)
					electricTower = item;
				else if (item is RepairCenter)
					repairCenter = item;
			
			var caseIndex:int = getCaseIndex();
			
			// decide for a case
			if (caseIndex == 1)
				return processCase1();
			else if (caseIndex == 2)
				return processCase2();
			else if (caseIndex == 3)
				return processCase3();
			else if (caseIndex == 4)
				return processCase4();
			else if (caseIndex == 5)
				return processCase5();
			
			return null;
		}
		
		private function processCase1():Weapon
		{
			// place cannons first
			if (numCannons == 0)
				return cannon;
			
			var ratio:Number = numMachineGuns / (numCannons + numMachineGuns);
			
			if (ratio < 0.3)
				return machineGun;
			
			return cannon;
		}
		
		private function processCase2():Weapon
		{
			var totalAmount:int = numCannons + numMachineGuns + numElectricTowers;
			
			// place cannons first
			if (numCannons == 0)
				return cannon;
			
			var ratio:Number = numMachineGuns / totalAmount;
			
			if (ratio < 0.2)
				return machineGun;
			
			ratio = numElectricTowers / totalAmount;
			
			var requeredPathIndex:int = checkIfSomePathLackesPowerAttack();
			if (ratio < 0.2 || requeredPathIndex != -1)
			{
				if (electricTower && requeredPathIndex != -1)
					electricTower.preferenceDescriptor.preferredPathIndex = requeredPathIndex;
				return electricTower;
			}
			
			// place cannons in other cases
			return cannon;
		}
		
		private function processCase3():Weapon
		{
			var totalAmount:int = numCannons + numMachineGuns + numRepairCenters;
			
			// place cannons first
			if (numCannons == 0)
				return cannon;
			
			var ratio:Number = numMachineGuns / totalAmount;
			
			if (ratio < 0.3)
				return machineGun;
			
			ratio = numRepairCenters / totalAmount;
			
			if (totalAmount > 6 && ratio < 0.05)
				return repairCenter;
			
			// place cannons in other cases
			return cannon;
		}
		
		private function processCase4():Weapon
		{
			var totalAmount:int = numCannons + numMachineGuns + numElectricTowers + numRepairCenters;
			
			// place cannons first
			if (numCannons == 0)
				return cannon;
			
			var ratio:Number = numMachineGuns / totalAmount;
			
			if (ratio < 0.2)
				return machineGun;
			
			ratio = numElectricTowers / totalAmount;
			
			var requeredPathIndex:int = checkIfSomePathLackesPowerAttack();
			if (ratio < 0.2 || requeredPathIndex != -1)
			{
				if (electricTower && requeredPathIndex != -1)
					electricTower.preferenceDescriptor.preferredPathIndex = requeredPathIndex;
				return electricTower;
			}
			
			ratio = numRepairCenters / totalAmount;
			
			if (totalAmount > 6 && ratio < 0.05)
				return repairCenter;
			
			// place cannons in other cases
			return cannon;
		}
		
		private function processCase5():Weapon
		{
			var totalAmount:int = numCannons + numMachineGuns + numElectricTowers + numRepairCenters;
			
			// place cannons first
			if (numCannons == 0)
				return cannon;
			
			var ratio:Number = numMachineGuns / totalAmount;
			
			if (ratio < 0.2)
				return machineGun;
			
			ratio = numElectricTowers / totalAmount;
			
			var requeredPathIndex:int = checkIfSomePathLackesPowerAttack();
			if (ratio < 0.35 || requeredPathIndex != -1)
			{
				if (electricTower && requeredPathIndex != -1)
					electricTower.preferenceDescriptor.preferredPathIndex = requeredPathIndex;
				return electricTower;
			}
			
			ratio = numRepairCenters / totalAmount;
			
			if (totalAmount > 6 && ratio < 0.05)
				return repairCenter;
			
			// place cannons in other cases
			return cannon;
		}
		
		private function getCaseIndex():int
		{
			var devInfo:DevelopmentInfo = GameBot.getCurrentDevelopmentInfo();
			var caseIndex:int = -1;
			
			if (GameBot.getCurrentLevelIndex() >= 5)
				return 5;
			
			if (devInfo.shockGunLevel == -1 && devInfo.repairCenterLevel == -1)
				caseIndex = 1;
			else if (devInfo.shockGunLevel > -1 && devInfo.repairCenterLevel == -1)
				caseIndex = 2;
			else if (devInfo.shockGunLevel == -1 && devInfo.repairCenterLevel > -1)
				caseIndex = 3;
			else if (devInfo.shockGunLevel > -1 && devInfo.repairCenterLevel > -1)
				caseIndex = 4;
			
			return caseIndex;
		}
		
		private function checkIfSomePathLackesPowerAttack():int
		{
			var pathIndex:int = 0;
			
			var trajectroies:Array = GameBot.getCurrentTrajectories();
			
			if (trajectroies.length == 1)
				return -1;
			
			// check for electic tower
			// each trajectory has to have at least 1 electric tower
			var electricTowers:Array = [];
			
			for each (var item:IWeapon in placedItems.source)
				if (item is UserElectricTower)
					electricTowers.push(item);
			
			if (electricTowers.length == 1)
				return Weapon(electricTowers[0]).preferenceDescriptor.preferredPathIndex == 0 ? 1 : 0;
			
			return -1;
		}
		
		private function updateWeaponNumbers():void
		{
			numCannons = 0;
			numMachineGuns = 0;
			numElectricTowers = 0;
			numRepairCenters = 0;
			
			for each (var item:Weapon in placedItems.source)
				if (item is UserCannon)
					numCannons++;
				else if (item is UserMachineGunTower)
					numMachineGuns++;
				else if (item is UserElectricTower)
					numElectricTowers++;
				else if (item is RepairCenter)
					numRepairCenters++;
		}
	
	}

}