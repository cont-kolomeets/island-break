/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import infoObjects.WeaponInfo;
	import nslib.controls.NSSprite;
	import nslib.controls.ToggleButton;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UnitButton extends NSSprite
	{
		public static const SHOW_INFO:String = "showInfo";
		
		public static const STATE_LOCKED:String = "locked";
		
		// unlocked but not enough money to buy
		public static const STATE_UNLOCKED:String = "unlocked";
		
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
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/node white.png")]
		private static var whiteNodeImage:Class;
		
		////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/lock.png")]
		private static var lockImage:Class;
		
		//////////
		
		private var mainButton:ToggleButton = new ToggleButton();
		
		//////////
		
		public function UnitButton()
		{
			construct();
			refresh();
		}
		
		/////////
		
		private var _currentWeaponInfo:WeaponInfo = null;
		
		public function get currentWeaponInfo():WeaponInfo
		{
			return _currentWeaponInfo;
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
		
		/////////
		
		private function construct():void
		{
			ControlConfigurator.configureButton(mainButton.upButton, null);
			ControlConfigurator.configureButton(mainButton.downButton, null);
			
			mainButton.useManualToggle = false;
			mainButton.addEventListener(MouseEvent.CLICK, mainButton_clickHandler, false, 0, true);
		}
		
		private function mainButton_clickHandler(event:MouseEvent):void
		{
			if (mainButton.isUpState)
			{
				mainButton.setDown();
				
				// allow click only when enabled
				if (currentWeaponInfo && (currentState == STATE_UNLOCKED))
					dispatchEvent(new Event(SHOW_INFO));
			}
		}
		
		/////////
		
		public function buildButtonForWeaponInfo(weaponInfo:WeaponInfo):void
		{
			_currentWeaponInfo = weaponInfo;
			refresh();
		}
		
		public function setUp():void
		{
			mainButton.setUp();
		}
		
		public function setDown():void
		{
			mainButton.setDown();
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
		}
		
		private function drawLockedState():void
		{
			drawDisabledState();
			
			// drawing lock
			lock.x = -lock.width / 2;
			lock.y = -lock.height / 2;
			addChild(lock);
		}
		
		private function drawDisabledState():void
		{
			mainButton.setUp();
			mainButton.mouseEnabled = false;
			mainButton.mouseChildren = false;
			mainButton.upButton.imageDisabled = grayNodeImage;
			mainButton.upButton.enabled = false;
			
			mainButton.upButton.refresh(true);
			
			mainButton.x = -mainButton.width / 2;
			mainButton.y = -mainButton.height / 2;
			addChild(mainButton);
			
			// adding weapon image
			if (currentWeaponInfo && currentWeaponInfo.iconSmallForDisabledState)
			{
				var weaponIcon:Bitmap = new currentWeaponInfo.iconSmallForDisabledState() as Bitmap;
				weaponIcon.x = -weaponIcon.width / 2;
				weaponIcon.y = -weaponIcon.height / 2;
				addChild(weaponIcon);
			}
		}
		
		private function drawUnlockedState():void
		{
			mainButton.setUp();
			mainButton.mouseEnabled = true;
			mainButton.mouseChildren = true;
			mainButton.upButton.image = pickCorrectNodeForWeapon();
			mainButton.upButton.imageOver = whiteNodeImage;
			mainButton.upButton.imageDown = grayNodeImage;
			mainButton.upButton.enabled = true;
			
			mainButton.downButton.imageDisabled = yellowNodeImage;
			mainButton.downButton.enabled = false;
			
			mainButton.upButton.refresh(true);
			
			mainButton.x = -mainButton.width / 2;
			mainButton.y = -mainButton.height / 2;
			addChild(mainButton);
			
			// adding weapon image
			if (currentWeaponInfo && currentWeaponInfo.iconSmall)
			{
				var weaponIcon:Bitmap = new currentWeaponInfo.iconSmall() as Bitmap;
				weaponIcon.x = -weaponIcon.width / 2;
				weaponIcon.y = -weaponIcon.height / 2;
				addChild(weaponIcon);
			}
		}
		
		/////////
		
		private function pickCorrectNodeForWeapon():Class
		{
			if (!currentWeaponInfo)
				return grayNodeImage;
			
			switch (currentWeaponInfo.weaponId)
			{
				// for user weapon
				
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
				
				// for enemy weapons
				
				// fast
				case WeaponResources.ENEMY_MOBILE_VEHICLE: 
					return greenNodeImage;
				
				// armored
				case WeaponResources.ENEMY_TANK: 
					return blueNodeImage;
				
				case WeaponResources.ENEMY_BOMBER_TANK: 
					return blueNodeImage;
				
				case WeaponResources.ENEMY_WALKING_ROBOT: 
					return blueNodeImage;
				
				case WeaponResources.ENEMY_FACTORY_TANK: 
					return blueNodeImage;
				
				// special
				case WeaponResources.ENEMY_ENERGY_BALL: 
					return orangeNodeImage;
				
				case WeaponResources.ENEMY_INVISIBLE_TANK: 
					return orangeNodeImage;
				
				case WeaponResources.ENEMY_REPAIR_TANK: 
					return orangeNodeImage;
				
				// aircraft
				case WeaponResources.ENEMY_PLANE: 
					return violetNodeImage;
				
				case WeaponResources.ENEMY_HELICOPTER: 
					return violetNodeImage;
			}
			
			return grayNodeImage;
		}
	
	}

}