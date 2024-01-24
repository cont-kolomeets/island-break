/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import flash.display.DisplayObject;
	import mainPack.GameSettings;
	import nslib.controls.ButtonBar;
	import nslib.controls.ButtonBarButtonBase;
	import nslib.controls.events.ButtonBarEvent;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.LayoutConstants;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import supportControls.toolTips.InGameHintToolTip;
	import weapons.base.supportClasses.WeaponPreferenceDescriptor;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponSettingsPanelPreferenceMenu extends NSSprite
	{
		private static const AIR_OBJECT_INDEX:int = 3;
		
		private var currentDescriptor:WeaponPreferenceDescriptor = null;
		
		private var pathSelectionBar:ButtonBar = new ButtonBar();
		
		///////////
		
		public function WeaponSettingsPanelPreferenceMenu()
		{
			super();
			
			construct();
		}
		
		////////////
		
		private function construct():void
		{
			pathSelectionBar.buttonClass = WeaponSettingsPanelPreferenceMenuButton;
			pathSelectionBar.verticalGap = 2;
			pathSelectionBar.layout = LayoutConstants.VERTICAL;
			constructProvider();
			
			addChild(pathSelectionBar);
		}
		
		private function constructProvider():void
		{
			var allObject:Object = {label: "All", headerToolTip: "Multipath attack", bodyToolTip: "Unit attacks all enemies (selected by default)."};
			var path1Object:Object = {label: "Path 1", headerToolTip: "Single path attack", bodyToolTip: "Unit has priority for enemies moving along the 1st (red) path.", color: 0xFF9595};
			var path2Object:Object = {label: "Path 2", headerToolTip: "Single path attack", bodyToolTip: "Unit has priority for enemies moving along the 2nd (blue) path.", color: 0x9191FF};
			var airObject:Object = {label: "Air", headerToolTip: "Aircraft attack", bodyToolTip: "Unit focuses most of his attention on flying enemies.", color: 0x91FFF4};
			
			pathSelectionBar.dataProvider = [allObject, path1Object, path2Object, airObject];
		}
		
		private function updateToolTipsForButtonBar():void
		{
			for each (var button:ButtonBarButtonBase in pathSelectionBar.buttons)
			{
				if (GameSettings.enableTooltips)
					ToolTipService.setToolTip(button, new ToolTipInfo(button, new ToolTipSimpleContentDescriptor(button.dataProviderObject.headerToolTip, [button.dataProviderObject.bodyToolTip]), ToolTipInfo.POSITION_LEFT, true), InGameHintToolTip);
				else
					ToolTipService.removeAllTooltipsForComponent(button);
			}
		}
		
		public function updateForDescriptor(preferenceDescriptor:WeaponPreferenceDescriptor, canHitAircrafts:Boolean = false, currentLevelHasAircrafts:Boolean = false):void
		{
			currentDescriptor = preferenceDescriptor;
			
			DisplayObject(pathSelectionBar.buttons[AIR_OBJECT_INDEX]).visible = canHitAircrafts && currentLevelHasAircrafts;
			pathSelectionBar.paddingTop = (canHitAircrafts && currentLevelHasAircrafts) ? -17 : 0;
			
			pathSelectionBar.selectedIndex = (currentDescriptor.selectionTypePreference == WeaponPreferenceDescriptor.SELECTION_TYPE_AIR) ? AIR_OBJECT_INDEX : (currentDescriptor.preferredPathIndex + 1);
			
			updateToolTipsForButtonBar();
		}
		
		public function show():void
		{
			pathSelectionBar.addEventListener(ButtonBarEvent.INDEX_CHANGED, pathSelectionBar_indexChangedHandler);
		}
		
		public function hide():void
		{
			pathSelectionBar.removeEventListener(ButtonBarEvent.INDEX_CHANGED, pathSelectionBar_indexChangedHandler);
		}
		
		//////////
		
		private function pathSelectionBar_indexChangedHandler(event:ButtonBarEvent):void
		{
			if (event.newIndex == AIR_OBJECT_INDEX)
			{
				currentDescriptor.preferredPathIndex = -1;
				currentDescriptor.selectionTypePreference = WeaponPreferenceDescriptor.SELECTION_TYPE_AIR;
			}
			else
			{
				currentDescriptor.selectionTypePreference = WeaponPreferenceDescriptor.SELECTION_TYPE_ANY;
				currentDescriptor.preferredPathIndex = event.newIndex - 1;
			}
		}
	
	}

}