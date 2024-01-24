/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.devCenter
{
	import infoObjects.gameInfo.GameInfo;
	import nslib.controls.NSSprite;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ColumnContainer extends NSSprite
	{
		////////////
		
		private var cannonColumn:UpgradableUnitButtonsColumn = new UpgradableUnitButtonsColumn("Cannon");
		
		private var machineGunColumn:UpgradableUnitButtonsColumn = new UpgradableUnitButtonsColumn("Machine Gun");
		
		private var shockGunColumn:UpgradableUnitButtonsColumn = new UpgradableUnitButtonsColumn("Shock Gun");
		
		private var airSupportColumn:UpgradableUnitButtonsColumn = new UpgradableUnitButtonsColumn("Air Support");
		
		private var bombSupportColumn:UpgradableUnitButtonsColumn = new UpgradableUnitButtonsColumn("Bombs");
		
		private var repairCenterColumn:UpgradableUnitButtonsColumn = new UpgradableUnitButtonsColumn("Repair Center");
		
		////
		
		private var gap:Number = 10;
		
		private var columnWidth:Number = 90;
		
		////////////
		
		public function ColumnContainer()
		{
			construct();
		}
		
		////////////
		
		private function construct():void
		{
			cannonColumn.buildColumnForWeaponID(WeaponResources.USER_CANNON);
			machineGunColumn.buildColumnForWeaponID(WeaponResources.USER_MACHINE_GUN);
			shockGunColumn.buildColumnForWeaponID(WeaponResources.USER_ELECTRIC_TOWER);
			airSupportColumn.buildColumnForWeaponID(WeaponResources.USER_AIR_SUPPORT);
			bombSupportColumn.buildColumnForWeaponID(WeaponResources.USER_BOMB_SUPPORT);
			repairCenterColumn.buildColumnForWeaponID(WeaponResources.USER_REPAIR_CENTER);
			
			cannonColumn.x = columnWidth * 0 + gap * 0;
			machineGunColumn.x = columnWidth * 1 + gap * 1;
			shockGunColumn.x = columnWidth * 2 + gap * 2;
			bombSupportColumn.x = columnWidth * 3 + gap * 3;
			airSupportColumn.x = columnWidth * 4 + gap * 4;
			repairCenterColumn.x = columnWidth * 5 + gap * 5;
			
			addChild(cannonColumn);
			addChild(machineGunColumn);
			addChild(shockGunColumn);
			addChild(airSupportColumn);
			addChild(bombSupportColumn);
			addChild(repairCenterColumn);
		}
		
		/////////////
		
		public function applyState(gameInfo:GameInfo):void
		{
			cannonColumn.upgradeLevel = gameInfo.developmentInfo.cannonLevel;
			cannonColumn.starsAvailable = gameInfo.starsAvailable;
			cannonColumn.refresh();
			
			machineGunColumn.upgradeLevel = gameInfo.developmentInfo.machineGunLevel;
			machineGunColumn.starsAvailable = gameInfo.starsAvailable;
			machineGunColumn.refresh();
			
			shockGunColumn.upgradeLevel = gameInfo.developmentInfo.shockGunLevel;
			shockGunColumn.starsAvailable = gameInfo.starsAvailable;
			shockGunColumn.refresh();
			
			airSupportColumn.upgradeLevel = gameInfo.developmentInfo.airSupportLevel;
			airSupportColumn.starsAvailable = gameInfo.starsAvailable;
			airSupportColumn.refresh();
			
			bombSupportColumn.upgradeLevel = gameInfo.developmentInfo.bombSupportLevel;
			bombSupportColumn.starsAvailable = gameInfo.starsAvailable;
			bombSupportColumn.refresh();
			
			repairCenterColumn.upgradeLevel = gameInfo.developmentInfo.repairCenterLevel;
			repairCenterColumn.starsAvailable = gameInfo.starsAvailable;
			repairCenterColumn.refresh();
		}
	
	}

}