/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import infoObjects.gameInfo.GameInfo;
	import nslib.controls.CustomTextField;
	import nslib.utils.FontDescriptor;
	import panels.encyclopedia.supportClasses.WeaponSelector;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyWeaponsListPanel extends WeaponsListPanel
	{
		//////// lists
		
		private var lightAndFastWeaponList:UnitsList = new UnitsList();
		private var armoredWeaponList:UnitsList = new UnitsList();
		private var specialWeaponList:UnitsList = new UnitsList();
		private var aircraftWeaponList:UnitsList = new UnitsList();
		
		/////////////
		
		public function EnemyWeaponsListPanel()
		{
			super();
			construct();
		}
		
		/////////////
		
		private function construct():void
		{
			// adding lists
			
			lightAndFastWeaponList.getInfosFunction = WeaponSelector.getEnemyLightAndFastWeaponInfos;
			armoredWeaponList.getInfosFunction = WeaponSelector.getEnemyArmoredWeaponInfos;
			specialWeaponList.getInfosFunction = WeaponSelector.getEnemySpecialWeaponInfos;
			aircraftWeaponList.getInfosFunction = WeaponSelector.getEnemyAircraftWeaponInfos;
			
			registerUnitsList(lightAndFastWeaponList);
			registerUnitsList(armoredWeaponList);
			registerUnitsList(specialWeaponList);
			registerUnitsList(aircraftWeaponList);
			
			var listsFontDescriptor:FontDescriptor = new FontDescriptor(20, 0xFFFFFF, FontResources.BOMBARD);
			
			constructList(lightAndFastWeaponList, "Light & Fast", listsFontDescriptor, 70, 65, 100, 130);
			constructList(armoredWeaponList, "Armored", listsFontDescriptor, 70, 170, 100, 232);
			constructList(specialWeaponList, "Special Abilities", listsFontDescriptor, 70, 340, 100, 405);
			constructList(aircraftWeaponList, "Aircrafts", listsFontDescriptor, 70, 440, 100, 500);
		}
		
		private function constructList(list:UnitsList, listName:String, fontDescriptor:FontDescriptor, labelX:Number, labelY:Number, listX:Number, listY:Number):void
		{
			var label:CustomTextField = new CustomTextField(listName, fontDescriptor);
			
			label.x = labelX;
			label.y = labelY;
			
			list.x = listX;
			list.y = listY;
			
			addChild(label);
			addChild(list);
		}
		
		override public function applyPanelInfo(panelInfo:*):void
		{
			super.applyPanelInfo(panelInfo);
			
			for each (var list:UnitsList in unitsLists)
				list.showItemsForEnemyWeaponInfos(GameInfo(panelInfo));
		}
	}

}