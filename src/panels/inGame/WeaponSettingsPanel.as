/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import infoObjects.panelInfos.WeaponSettingsPanelInfo;
	import mainPack.GameSettings;
	import nslib.animation.engines.AnimationEngine;
	import nslib.animation.events.AnimationEvent;
	import nslib.controls.Button;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import panels.PanelBase;
	import supportClasses.ControlConfigurator;
	import supportControls.toolTips.InGameHintToolTip;
	import supportControls.toolTips.WeaponInfoToolTip;
	import supportControls.toolTips.WeaponInfoToolTipContentDescriptor;
	import weapons.base.Weapon;
	import weapons.repairCenter.RepairCenter;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class WeaponSettingsPanel extends PanelBase
	{
		public static const REPAIR_CLICK:String = "repairClick";
		
		public static const SELL_CLICK:String = "sellClick";
		
		public static const UPGRADE_CLICK:String = "upgradeClick";
		
		public static const CLOSE_CLICK:String = "closeClick";
		
		//////////////////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/close button.png")]
		private static var closeButtonImage:Class;
		
		//////////////////////////////
		
		private var btnUpgrade:WeaponSettingsPanelButton = new WeaponSettingsPanelButton(WeaponSettingsPanelButton.TYPE_UPGRADE);
		private var btnRepair:WeaponSettingsPanelButton = new WeaponSettingsPanelButton(WeaponSettingsPanelButton.TYPE_REPAIR);
		private var btnSell:WeaponSettingsPanelButton = new WeaponSettingsPanelButton(WeaponSettingsPanelButton.TYPE_SELL);
		private var btnClose:Button = new Button();
		private var preferenceMenu:WeaponSettingsPanelPreferenceMenu = new WeaponSettingsPanelPreferenceMenu();
		
		private var ae:AnimationEngine = new AnimationEngine();
		
		private var gameStage:GameStage = null;
		
		/////////////////////////////
		
		public function WeaponSettingsPanel(gameStage:GameStage)
		{
			super();
			
			this.gameStage = gameStage;
			
			addButtons();
		}
		
		/////////////////////////////
		
		public function get selectedItem():*
		{
			return panelInfo ? WeaponSettingsPanelInfo(panelInfo).selectedItem : null;
		}
		
		/////////////////////////////
		
		private function addButtons():void
		{
			addChild(btnUpgrade);
			addChild(btnRepair);
			addChild(btnSell);
			
			ControlConfigurator.configureButton(btnClose, closeButtonImage);
			addChild(btnClose);
			addChild(preferenceMenu);
		}
		
		/////////////////////////////
		
		private var oldPanelInfo:WeaponSettingsPanelInfo = null;
		
		override public function applyPanelInfo(panelInfo:*):void
		{
			oldPanelInfo = this.panelInfo;
			
			super.applyPanelInfo(panelInfo);
			
			var info:WeaponSettingsPanelInfo = panelInfo as WeaponSettingsPanelInfo;
			configureRepairButton(info);
			configureSellButton(info);
			configureUpgradeButton(info);
			configurePreferenceMenu(info);
		}
		
		////////////
		
		private function configureRepairButton(info:WeaponSettingsPanelInfo):void
		{
			var selectedItemChanged:Boolean = Boolean(!oldPanelInfo || oldPanelInfo.selectedItem != info.selectedItem);
			var newPriceValue:String = (info.priceToRepair > 0) ? ("-" + info.priceToRepair) : ("N/A");
			var newEnabledValue:Boolean = (info.totalScores >= info.priceToRepair) && (info.priceToRepair > 0);
			
			if (selectedItemChanged || newPriceValue != btnRepair.price || newEnabledValue != btnRepair.enabled)
			{
				btnRepair.price = newPriceValue;
				btnRepair.enabled = newEnabledValue;
				updateToolTipForRepairButton(info);
			}
		}
		
		private function updateToolTipForRepairButton(info:WeaponSettingsPanelInfo):void
		{
			ToolTipService.removeAllTooltipsForComponent(btnRepair);
			ToolTipService.removeAllTooltipsForComponent(btnRepair.button);
			
			if (GameSettings.enableTooltips)
			{
				if (info.selectedItem is Weapon)
				{
					var enoughMoneyForRepair:Boolean = info.totalScores >= info.priceToRepair;
					
					if (!enoughMoneyForRepair)
						ToolTipService.setToolTip(btnRepair, new ToolTipInfo(btnRepair.button, new ToolTipSimpleContentDescriptor("Locked!", ["Not enough money."])), InGameHintToolTip);
					else if (btnRepair.enabled)
						ToolTipService.setToolTip(btnRepair.button, new ToolTipInfo(btnRepair.button, new ToolTipSimpleContentDescriptor("Repair!", ["Repair this unit for " + btnRepair.price + "$."]), ToolTipInfo.POSITION_LEFT), InGameHintToolTip);
					else
						ToolTipService.setToolTip(btnRepair, new ToolTipInfo(btnRepair.button, new ToolTipSimpleContentDescriptor("Intact!", ["This unit needs no repair."]), ToolTipInfo.POSITION_LEFT), InGameHintToolTip);
				}
			}
		}
		
		////////////
		
		private function configureSellButton(info:WeaponSettingsPanelInfo):void
		{
			var selectedItemChanged:Boolean = Boolean(!oldPanelInfo || oldPanelInfo.selectedItem != info.selectedItem);
			var newPriceValue:String = "+" + info.priceToSell;
			
			if (selectedItemChanged || newPriceValue != btnSell.price)
			{
				btnSell.price = newPriceValue;
				updateToolTipForSellButton();
			}
		}
		
		private function updateToolTipForSellButton():void
		{
			ToolTipService.removeAllTooltipsForComponent(btnSell);
			ToolTipService.removeAllTooltipsForComponent(btnSell.button);
			
			if (GameSettings.enableTooltips)
				ToolTipService.setToolTip(btnSell.button, new ToolTipInfo(btnSell.button, new ToolTipSimpleContentDescriptor("Sell!", ["Sell this unit and get " + btnSell.price + "$ back."]), ToolTipInfo.POSITION_RIGHT), InGameHintToolTip);
		}
		
		////////////
		
		private function configureUpgradeButton(info:WeaponSettingsPanelInfo):void
		{
			var selectedItemChanged:Boolean = Boolean(!oldPanelInfo || oldPanelInfo.selectedItem != info.selectedItem);
			var newPriceValue:String = null;
			var newEnabledValue:Boolean = false;
			
			// button upgrade
			if (info.selectedItem is Weapon)
			{
				var weapon:Weapon = info.selectedItem as Weapon;
				
				var upgradeAllowedByDevelopmentCenter:Boolean = info.developmentInfo.levelIsDevelopedForWeapon(weapon.nextInfo);
				
				newPriceValue = (upgradeAllowedByDevelopmentCenter && (info.priceToUpgrade > 0)) ? ("-" + info.priceToUpgrade) : ("N/A");
				newEnabledValue = upgradeAllowedByDevelopmentCenter && (info.totalScores >= info.priceToUpgrade) && (info.priceToUpgrade > 0);
				
				if (selectedItemChanged || btnUpgrade.price != newPriceValue || btnUpgrade.enabled != newEnabledValue)
				{
					btnUpgrade.price = newPriceValue;
					btnUpgrade.enabled = newEnabledValue;
					
					// show the current radius
					gameStage.showHitRadiusForWeapon(Weapon(info.selectedItem));
					
					updateToolTipForUpgradeButton(info);
				}
			}
			else
			{
				newPriceValue = "N/A";
				newEnabledValue = false;
				
				if (selectedItemChanged || btnUpgrade.price != newPriceValue || btnUpgrade.enabled != newEnabledValue)
				{
					btnUpgrade.enabled = newEnabledValue;
					btnUpgrade.price = newPriceValue;
					updateToolTipForUpgradeButton(info);
				}
				
			}
		}
		
		private function updateToolTipForUpgradeButton(info:WeaponSettingsPanelInfo):void
		{
			ToolTipService.removeAllTooltipsForComponent(btnUpgrade);
			ToolTipService.removeAllTooltipsForComponent(btnUpgrade.button);
			
			if (GameSettings.enableTooltips)
			{
				if (info.selectedItem is Weapon)
				{
					var weapon:Weapon = info.selectedItem as Weapon;
					var upgradeAllowedByDevelopmentCenter:Boolean = info.developmentInfo.levelIsDevelopedForWeapon(weapon.nextInfo);
					
					if (!weapon.nextInfo)
						ToolTipService.setToolTip(btnUpgrade, new ToolTipInfo(btnUpgrade.button, new ToolTipSimpleContentDescriptor("Fully upgraded!", ["This unit is fully upgraded."])), InGameHintToolTip);
					else if (!upgradeAllowedByDevelopmentCenter)
						ToolTipService.setToolTip(btnUpgrade, new ToolTipInfo(btnUpgrade.button, new ToolTipSimpleContentDescriptor("Locked!", [info.developmentInfo.lockedForMode ? "Upgrade locked for this mode." : "Earn stars and unlock new towers in the 'Development Center'."])), InGameHintToolTip);
					else
						ToolTipService.setToolTip(btnUpgrade, new ToolTipInfo(btnUpgrade.button, new WeaponInfoToolTipContentDescriptor(weapon.nextInfo, true)), WeaponInfoToolTip);
				}
			}
		}
		
		private function configurePreferenceMenu(info:WeaponSettingsPanelInfo):void
		{
			var selectedItemChanged:Boolean = Boolean(!oldPanelInfo || oldPanelInfo.selectedItem != info.selectedItem);
			
			// button upgrade
			if (info.selectedItem is Weapon)
			{
				var weapon:Weapon = info.selectedItem as Weapon;
				
				if (selectedItemChanged)
				{
					// show preferences, only if there are more than 1 path and the item is not RepairCenter
					var needShowPreferenceMenu:Boolean = preferenceMenuShouldBeShown(info);
					preferenceMenu.visible = needShowPreferenceMenu;
					
					if (needShowPreferenceMenu)
						preferenceMenu.updateForDescriptor(weapon.preferenceDescriptor, weapon.currentInfo.canHitAircrafts, info.currentLevelHasAircrafts);
					
					updateToolTipForUpgradeButton(info);
				}
			}
			else if (selectedItemChanged)
				preferenceMenu.visible = false;
		}
		
		////////////////
		
		override public function show():void
		{
			super.show();
			
			preferenceMenu.show();
			playAnimation();
			
			btnRepair.addEventListener(MouseEvent.CLICK, btnRepair_clickHandler);
			btnSell.addEventListener(MouseEvent.CLICK, btnSell_clickHandler);
			btnUpgrade.addEventListener(MouseEvent.CLICK, btnUpgrade_clickHandler);
			btnUpgrade.addEventListener(MouseEvent.MOUSE_OVER, btnUpgrade_mouseOverHandler);
			btnUpgrade.addEventListener(MouseEvent.MOUSE_OUT, btnUpgrade_mouseOutHandler);
			
			btnClose.addEventListener(ButtonEvent.BUTTON_CLICK, btnClose_clickHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			
			preferenceMenu.hide();
			
			clearCurrentState();
			
			btnRepair.removeEventListener(MouseEvent.CLICK, btnRepair_clickHandler);
			btnSell.removeEventListener(MouseEvent.CLICK, btnSell_clickHandler);
			btnUpgrade.removeEventListener(MouseEvent.CLICK, btnUpgrade_clickHandler);
			btnUpgrade.removeEventListener(MouseEvent.MOUSE_OVER, btnUpgrade_mouseOverHandler);
			btnUpgrade.removeEventListener(MouseEvent.MOUSE_OUT, btnUpgrade_mouseOutHandler);
			
			btnClose.removeEventListener(ButtonEvent.BUTTON_CLICK, btnClose_clickHandler);
			
			panelInfo = null;
		}
		
		public function clearCurrentState():void
		{
			// just in case clear the show hit radius if for some reason mouse out event wasn't triggered
			gameStage.hideHitRadiusForCurrentWeapon();
			
			ToolTipService.removeAllTooltipsForComponent(btnUpgrade);
			ToolTipService.removeAllTooltipsForComponent(btnSell);
			ToolTipService.removeAllTooltipsForComponent(btnRepair);
			
			ToolTipService.removeAllTooltipsForComponent(btnUpgrade.button);
			ToolTipService.removeAllTooltipsForComponent(btnSell.button);
			ToolTipService.removeAllTooltipsForComponent(btnRepair.button);
		}
		
		///////////////////////////////
		
		private function btnUpgrade_mouseOverHandler(event:MouseEvent):void
		{
			if (!btnUpgrade.enabled)
				return;
			
			var info:WeaponSettingsPanelInfo = panelInfo as WeaponSettingsPanelInfo;
			
			// need to show the hit radius
			// but only if upgrade is available
			if (info.selectedItem is Weapon && Weapon(info.selectedItem).nextInfo)
			{
				// clear the previous one shown
				gameStage.hideHitRadiusForCurrentWeapon();
				gameStage.showHitRadiusForWeaponNextLevel(Weapon(info.selectedItem));
			}
		}
		
		private function btnUpgrade_mouseOutHandler(event:MouseEvent):void
		{
			if (!btnUpgrade.enabled)
				return;
			
			gameStage.hideHitRadiusForCurrentWeapon();
			gameStage.showHitRadiusForWeapon(Weapon(WeaponSettingsPanelInfo(panelInfo).selectedItem));
		}
		
		private function btnRepair_clickHandler(event:MouseEvent):void
		{
			if (btnRepair.enabled)
				dispatchEvent(new Event(REPAIR_CLICK));
		}
		
		private function btnSell_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(SELL_CLICK));
		}
		
		private function btnUpgrade_clickHandler(event:MouseEvent):void
		{
			if (btnUpgrade.enabled)
				dispatchEvent(new Event(UPGRADE_CLICK));
		}
		
		private function btnClose_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(CLOSE_CLICK));
		}
		
		///////////////////////////////////
		
		private var animationIsBusy:Boolean = false;
		
		private function playAnimation():void
		{
			if (animationIsBusy)
				return;
			
			animationIsBusy = true;
			ae.reset();
			
			// temporarely disabling mouse interaction
			btnUpgrade.mouseEnabled = false;
			btnRepair.mouseEnabled = false;
			btnSell.mouseEnabled = false;
			preferenceMenu.mouseEnabled = false;
			
			btnUpgrade.mouseChildren = false;
			btnRepair.mouseChildren = false;
			btnSell.mouseChildren = false;
			preferenceMenu.mouseChildren = false;
			
			var scaleSpeed:Number = 200;
			var moveSpeed:Number = 100;
			
			ae.scaleObjects([btnUpgrade, btnRepair, btnSell, btnClose, preferenceMenu], 0.2, 0.2, 1, 1, scaleSpeed);
			ae.moveObjects(btnUpgrade, 0, 0, 0, -27, moveSpeed);
			ae.moveObjects(btnRepair, 0, 0, -32, 32, moveSpeed);
			ae.moveObjects(btnSell, 0, 0, 32, 32, moveSpeed);
			ae.moveObjects(btnClose, 0, 0, 25, -35, moveSpeed);
			ae.moveObjects(preferenceMenu, 0, 0, -100, -35, moveSpeed);
			
			ae.addEventListener(AnimationEvent.ANIMATION_COMPLETED, ae_animationCompletedHanlder);
			ae.finishAnimationAt(300);
		}
		
		private function ae_animationCompletedHanlder(event:AnimationEvent):void
		{
			ae.removeEventListener(AnimationEvent.ANIMATION_COMPLETED, ae_animationCompletedHanlder);
			animationIsBusy = false;
			
			btnUpgrade.mouseEnabled = true;
			btnUpgrade.mouseChildren = true;
			
			btnRepair.mouseEnabled = true;
			btnRepair.mouseChildren = true;
			
			btnSell.mouseEnabled = true;
			btnSell.mouseChildren = true;
			
			preferenceMenu.mouseEnabled = true;
			preferenceMenu.mouseChildren = true;
		}
		
		/////////
		
		private function preferenceMenuShouldBeShown(info:WeaponSettingsPanelInfo):Boolean
		{
			return Boolean((info.selectedItem is Weapon) && !(info.selectedItem is RepairCenter) && (info.numPaths > 1));
		}
		
		public function calcRequiredLeftPaddingForInfo(info:WeaponSettingsPanelInfo):int
		{
			return preferenceMenuShouldBeShown(info) ? 100 : 0;
		}
	
	}

}