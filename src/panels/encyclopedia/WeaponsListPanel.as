/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import events.SelectEvent;
	import infoObjects.WeaponInfo;
	import panels.PanelBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponsListPanel extends PanelBase
	{
		protected var unitDescriptionPanel:UnitDescriptionPanel = new UnitDescriptionPanel();
		
		protected var unitsLists:Array = [];
		
		/////////////
		
		public function WeaponsListPanel()
		{
			construct();
		}
		
		/////////////
		
		private function construct():void
		{
			unitDescriptionPanel.x = 430;
			unitDescriptionPanel.y = 170;
			addChild(unitDescriptionPanel);
		}
		
		protected function registerUnitsList(list:UnitsList):void
		{
			unitsLists.push(list);
		}
		
		/////////////
		
		override public function show():void
		{
			super.show();
			
			// showing an empty photo frame
			unitDescriptionPanel.showDescriptionForWeapon(null);
			
			for each (var list:UnitsList in unitsLists)
				list.addEventListener(SelectEvent.SELECTED, unitsList_itemSelectedHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			
			for each (var list:UnitsList in unitsLists)
				list.removeEventListener(SelectEvent.SELECTED, unitsList_itemSelectedHandler);
		}
		
		private function unitsList_itemSelectedHandler(event:SelectEvent):void
		{
			var selectedInfo:WeaponInfo = event.selectedItem as WeaponInfo;
			unitDescriptionPanel.showDescriptionForWeapon(selectedInfo);
			unselectOtherLists(event.currentTarget as UnitsList);
		}
		
		private function unselectOtherLists(selectedList:UnitsList):void
		{
			for each (var list:UnitsList in unitsLists)
				if (list != selectedList)
					list.setUpAllButtons();
		}
	
	}

}