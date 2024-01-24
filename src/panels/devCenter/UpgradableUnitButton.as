/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.devCenter
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	import infoObjects.WeaponInfo;
	import mainPack.GameSettings;
	import nslib.controls.Button;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.core.Globals;
	import nslib.effects.fireWorks.FireWork;
	import panels.devCenter.events.UpgradeEvent;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.WeaponResources;
	import supportControls.toolTips.WeaponInfoToolTip;
	import supportControls.toolTips.WeaponInfoToolTipContentDescriptor;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UpgradableUnitButton extends NSSprite
	{
		public static const STATE_LOCKED:String = "locked";
		
		// unlocked but not enough money to buy
		public static const STATE_UNLOCKED:String = "unlocked";
		
		public static const STATE_ENABLED_FOR_UPGRADE:String = "enabledForUpgrade";
		
		public static const STATE_UPGRADED:String = "upgraded";
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/node gray.png")]
		private static var grayNodeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/node red.png")]
		private static var redNodeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/node green.png")]
		private static var greenNodeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/node yellow.png")]
		private static var yellowNodeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/node violet.png")]
		private static var violetNodeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/node blue.png")]
		private static var blueNodeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/node orange.png")]
		private static var orangeNodeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/node magenta.png")]
		private static var magentaNodeImage:Class;
		
		////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/lock.png")]
		private static var lockImage:Class;
		
		//////////
		
		private var priceLabel:UpgradableUnitButtonStarPlate = new UpgradableUnitButtonStarPlate();
		
		private var buttonContainer:NSSprite = new NSSprite();
		
		private var mainButton:Button = new Button();
		
		private var currentWeaponInfo:WeaponInfo = null;
		
		//////////
		
		public function UpgradableUnitButton()
		{
			construct();
			refresh();
		}
		
		/////////
		
		private var _currentState:String = STATE_LOCKED;
		
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			if (_currentState != value)
			{
				_currentState = value;
				refresh();
			}
		}
		
		///
		
		public function get currentPrice():int
		{
			return currentWeaponInfo ? currentWeaponInfo.developmentPrice : 0;
		}
		
		/////////
		
		private function construct():void
		{
			mouseEnabled = true;
			buttonContainer.mouseEnabled = true;
			
			ControlConfigurator.configureButton(mainButton, grayNodeImage, yellowNodeImage, grayNodeImage, grayNodeImage);
			
			mainButton.addEventListener(ButtonEvent.BUTTON_CLICK, mainButton_clickHandler, false, 0, true);
		}
		
		private var firework:FireWork = null;
		
		private function mainButton_clickHandler(event:ButtonEvent):void
		{
			// allow click only when enabled for upgrade
			if (currentWeaponInfo && (currentState == STATE_ENABLED_FOR_UPGRADE))
			{
				dispatchEvent(new UpgradeEvent(UpgradeEvent.UPGRADED, currentPrice, currentWeaponInfo.weaponId));
				
				// do not show firework if one is already running
				if (firework)
					return;
				
				firework = new FireWork();
				firework.workingLayer = Globals.topLevelApplication;
				firework.addEventListener(Event.COMPLETE, firework_completeHandler);
				
				var point:Point = this.localToGlobal(new Point(0, 0));
				firework.putFireWorkAt(point.x, point.y, pickCorrectConnectLineColorForWeapon());
			}
		}
		
		private function firework_completeHandler(event:Event):void
		{
			// release object
			firework.removeEventListener(Event.COMPLETE, firework_completeHandler);
			firework = null;
		}
		
		/////////
		
		public function buildButtonForWeaponInfo(weaponInfo:WeaponInfo):void
		{
			currentWeaponInfo = weaponInfo;
			priceLabel.numberOfStars = currentWeaponInfo.developmentPrice;
			refresh();
		}
		
		/////////
		
		private var disabledNode:Bitmap = new grayNodeImage() as Bitmap;
		
		private var lock:Bitmap = new lockImage() as Bitmap;
		
		// refreshes after the state is changed
		private function refresh():void
		{
			removeAllChildren();
			
			if (currentState == STATE_LOCKED)
				drawLockedState();
			else if (currentState == STATE_UNLOCKED)
				drawUnlockedState();
			else if (currentState == STATE_ENABLED_FOR_UPGRADE)
				drawEnabledState();
			else if (currentState == STATE_UPGRADED)
				drawUpgradedState();
		}
		
		private function drawLockedState():void
		{
			drawDisabledState(false);
			
			// drawing lock
			lock.x = -lock.width / 2;
			lock.y = -lock.height / 2;
			addChild(lock);
		}
		
		private function drawUnlockedState():void
		{
			drawDisabledState(true);
		}
		
		private function drawDisabledState(showToolTip:Boolean = false):void
		{
			mainButton.enabled = false;
			mainButton.image = grayNodeImage;
			
			mainButton.refresh(true);
			
			buttonContainer.addChild(mainButton);
			buttonContainer.x = -buttonContainer.width / 2;
			buttonContainer.y = -buttonContainer.height / 2;
			addChild(buttonContainer);
			
			// adding weapon image
			if (currentWeaponInfo && currentWeaponInfo.iconSmallForDisabledState)
			{
				var weaponIcon:Bitmap = new currentWeaponInfo.iconSmallForDisabledState() as Bitmap;
				weaponIcon.x = -weaponIcon.width / 2;
				weaponIcon.y = -weaponIcon.height / 2;
				addChild(weaponIcon);
			}
			
			// adding price label
			priceLabel.currentState = UpgradableUnitButtonStarPlate.STATE_DISABLED;
			priceLabel.x = 20;
			priceLabel.y = -priceLabel.height / 2;
			addChild(priceLabel);
			
			if (showToolTip)
			{
				if (currentWeaponInfo)
					addToolTip();
			}
			else
				removeToolTip();
		}
		
		private function drawEnabledState():void
		{
			mainButton.enabled = true;
			mainButton.image = grayNodeImage;
			mainButton.imageDown = grayNodeImage;
			
			mainButton.refresh(true);
			
			buttonContainer.addChild(mainButton);
			buttonContainer.x = -buttonContainer.width / 2;
			buttonContainer.y = -buttonContainer.height / 2;
			addChild(buttonContainer);
			
			// adding weapon image
			if (currentWeaponInfo && currentWeaponInfo.iconSmall)
			{
				var weaponIcon:Bitmap = new currentWeaponInfo.iconSmall() as Bitmap;
				weaponIcon.x = -weaponIcon.width / 2;
				weaponIcon.y = -weaponIcon.height / 2;
				addChild(weaponIcon);
				
				addToolTip();
			}
			
			// adding price label
			priceLabel.currentState = UpgradableUnitButtonStarPlate.STATE_ENABLED_FOR_UPGRADE;
			priceLabel.x = 20;
			priceLabel.y = -priceLabel.height / 2;
			addChild(priceLabel);
		}
		
		private function drawUpgradedState():void
		{
			mainButton.enabled = true;
			mainButton.image = pickCorrectNodeForWeapon();
			mainButton.imageDown = yellowNodeImage;
			
			mainButton.refresh(true);
			
			buttonContainer.addChild(mainButton);
			buttonContainer.x = -buttonContainer.width / 2;
			buttonContainer.y = -buttonContainer.height / 2;
			addChild(buttonContainer);
			
			// adding weapon image
			if (currentWeaponInfo && currentWeaponInfo.iconSmall)
			{
				var weaponIcon:Bitmap = new currentWeaponInfo.iconSmall() as Bitmap;
				weaponIcon.x = -weaponIcon.width / 2;
				weaponIcon.y = -weaponIcon.height / 2;
				addChild(weaponIcon);
				
				addToolTip();
				
				var line:Shape = new Shape();
				line.graphics.lineStyle(1, 0xAAAAAA, 0.5);
				line.graphics.beginFill(pickCorrectConnectLineColorForWeapon(), 0.8);
				line.graphics.drawRect(-2, 35, 4, 30);
				
				addChild(line);
			}
		}
		
		/////////
		
		private function pickCorrectNodeForWeapon():Class
		{
			if (!currentWeaponInfo)
				return grayNodeImage;
			
			switch (currentWeaponInfo.weaponId)
			{
				case WeaponResources.USER_CANNON: 
					return greenNodeImage;
				
				case WeaponResources.USER_MACHINE_GUN: 
					return orangeNodeImage;
				
				case WeaponResources.USER_ELECTRIC_TOWER: 
					return blueNodeImage;
				
				case WeaponResources.USER_BOMB_SUPPORT: 
					return redNodeImage;
				
				case WeaponResources.USER_AIR_SUPPORT: 
					return violetNodeImage;
				
				case WeaponResources.USER_REPAIR_CENTER: 
					return magentaNodeImage;
			}
			
			return grayNodeImage;
		}
		
		private function pickCorrectConnectLineColorForWeapon():int
		{
			if (!currentWeaponInfo)
				return 0;
			
			switch (currentWeaponInfo.weaponId)
			{
				case WeaponResources.USER_CANNON: 
					return 0x97F709;
				
				case WeaponResources.USER_MACHINE_GUN: 
					return 0xF9AA06;
				
				case WeaponResources.USER_ELECTRIC_TOWER: 
					return 0x4A92FD;
				
				case WeaponResources.USER_BOMB_SUPPORT: 
					return 0xFF0F0F;
				
				case WeaponResources.USER_AIR_SUPPORT: 
					return 0xAD27E7;
				
				case WeaponResources.USER_REPAIR_CENTER: 
					return 0xF31BD2;
			}
			
			return 0;
		}
		
		/////////////
		
		private function addToolTip():void
		{
			if (!GameSettings.enableTooltips)
				return;
			
			ToolTipService.removeAllTooltipsForComponent(buttonContainer);
			ToolTipService.setToolTip(buttonContainer, new ToolTipInfo(buttonContainer, new WeaponInfoToolTipContentDescriptor(currentWeaponInfo, false)), WeaponInfoToolTip);
		}
		
		private function removeToolTip():void
		{
			ToolTipService.removeAllTooltipsForComponent(buttonContainer);
		}
	
	}

}