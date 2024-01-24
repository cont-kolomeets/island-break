/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import infoObjects.gameInfo.DevelopmentInfo;
	import infoObjects.WeaponStoreInfo;
	import nslib.utils.ArrayList;
	import nslib.utils.NameUtil;
	import weapons.repairCenter.RepairCenter;
	import weapons.user.UserCannon;
	import weapons.user.UserElectricTower;
	import weapons.user.UserMachineGunTower;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponStoreController
	{
		public var scoreController:ScoreController;
		
		private var missingItems:ArrayList = new ArrayList();
		
		private var itemsForSale:ArrayList = new ArrayList();
		
		/////////////////////////
		
		public function WeaponStoreController()
		{
			prepareInfos();
		}
		
		////////////////////////
		
		private var infos:Array = [];
		
		private function prepareInfos():void
		{
			for (var i:int = 0; i < 5; i++)
				infos.push(new WeaponStoreInfo(null, "", false));
		}
		
		/// for optimization purposes, we use the same instances of info objects over and over
		private var storeInfosResult:Array = [];
		
		public function generateStoreInfos():Array
		{
			storeInfosResult.length = 0;
			var len:int = itemsForSale.length;
			
			for (var i:int = 0; i < len; i++)
			{
				// take and configure info
				var info:WeaponStoreInfo = infos[i];
				var item:* = itemsForSale.getItemAt(i);
				
				if (!item)
					continue;
				
				info.item = item;
				info.price = String(scoreController.getBuyPriceForItem(item, false));
				info.affordable = scoreController.isAffordable(item);
				
				storeInfosResult.push(info);
			}
			
			return storeInfosResult;
		}
		
		public function reset(devInfo:DevelopmentInfo):void
		{
			missingItems.removeAll();
			
			// adding items depending on the current development status
			//missingItems.addItem(NameUtil.getTruncatedClassName(Obstacle));
			
			if (devInfo.cannonLevel > -1)
				missingItems.addItem(NameUtil.getTruncatedClassName(UserCannon));
			
			if (devInfo.machineGunLevel > -1)
				missingItems.addItem(NameUtil.getTruncatedClassName(UserMachineGunTower));
			
			if (devInfo.shockGunLevel > -1)
				missingItems.addItem(NameUtil.getTruncatedClassName(UserElectricTower));
			
			if (devInfo.repairCenterLevel > -1)
				missingItems.addItem(NameUtil.getTruncatedClassName(RepairCenter));
			
			itemsForSale.removeAll();
		}
		
		public function createMissingItemsForSale():Array
		{
			var newItems:Array = [];
			
			for each (var item:*in missingItems.source)
			{
				var className:String = NameUtil.getTruncatedClassName(item);
				
				//if (className == "Obstacle")
				//	newItems.push(new Obstacle());
				if (className == "UserCannon")
					newItems.push(new UserCannon());
				else if (className == "UserMachineGunTower")
					newItems.push(new UserMachineGunTower());
				else if (className == "UserElectricTower")
					newItems.push(new UserElectricTower());
				else if (className == "RepairCenter")
					newItems.push(new RepairCenter());
			}
			
			missingItems.removeAll();
			
			itemsForSale.addFromArray(newItems);
			
			var sortedArray:Array = [];
			
			for each (var itemToSort:*in itemsForSale.source)
				//if (itemToSort is Obstacle)
				//	sortedArray[0] = itemToSort;
				if (itemToSort is UserCannon)
					sortedArray[0] = itemToSort;
				else if (itemToSort is UserMachineGunTower)
					sortedArray[1] = itemToSort;
				else if (itemToSort is UserElectricTower)
					sortedArray[2] = itemToSort;
				else if (itemToSort is RepairCenter)
					sortedArray[3] = itemToSort;
			
			itemsForSale.source = sortedArray;
			
			return newItems;
		}
		
		public function notifyAboutTakenItem(item:*):void
		{
			missingItems.addItem(NameUtil.getTruncatedClassName(item));
			itemsForSale.removeItem(item);
		}
	}

}