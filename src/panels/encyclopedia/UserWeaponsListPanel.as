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
	public class UserWeaponsListPanel extends WeaponsListPanel
	{
		//////// lists
		
		private var groundWeaponList:UnitsList = new UnitsList();
		private var airWeaponList:UnitsList = new UnitsList();
		private var repairCenterList:UnitsList = new UnitsList();
		
		/////////////
		
		public function UserWeaponsListPanel()
		{
			super();
			construct();
		}
		
		/////////////
		
		private function construct():void
		{
			// adding lists
			
			groundWeaponList.getInfosFunction = WeaponSelector.getUserGroundWeaponInfos;
			airWeaponList.getInfosFunction = WeaponSelector.getUserAirWeaponInfos;
			airWeaponList.itemsInRow = 3;
			repairCenterList.getInfosFunction = WeaponSelector.getUserRepairCenterInfos;
			
			registerUnitsList(groundWeaponList);
			registerUnitsList(airWeaponList);
			registerUnitsList(repairCenterList);
			
			var listsFontDescriptor:FontDescriptor = new FontDescriptor(20, 0xFFFFFF, FontResources.BOMBARD);
			
			constructList(groundWeaponList, "Ground-Based Units", listsFontDescriptor, 70, 65, 100, 135);
			constructList(airWeaponList, "Air Support", listsFontDescriptor, 70, 245, 100, 315);
			constructList(repairCenterList, "Repair Centers", listsFontDescriptor, 70, 422, 100, 490);
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
				list.showItemsForUserWeaponInfos(GameInfo(panelInfo).developmentInfo);
		}
	
	}

}