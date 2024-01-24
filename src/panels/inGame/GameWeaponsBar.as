/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import events.BonusAttackMenuEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import infoObjects.gameInfo.DevelopmentInfo;
	import infoObjects.WeaponInfo;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.controls.ToggleButton;
	import nslib.core.Globals;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportClasses.ToolTipSequencer;
	import supportControls.toolTips.HintToolTip;
	import weapons.base.IGroundWeapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameWeaponsBar extends NSSprite
	{
		public static const GAME_STARTED_CLICKED:String = "gameStartedClicked";
		
		public static const GAME_PAUSED_CLICKED:String = "gamePausedClicked";
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/menu base.png")]
		private static var menuBaseImage:Class;
		
		/////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button start normal.png")]
		private static var buttonStartNomalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button start over.png")]
		private static var buttonStartOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button start down.png")]
		private static var buttonStartDownImage:Class;
		
		/////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button pause normal.png")]
		private static var buttonPauseNomalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button pause over.png")]
		private static var buttonPauseOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button pause down.png")]
		private static var buttonPauseDownImage:Class;
		
		////////
		
		// menu to show support to use
		public var bonusAttackMenu:BonusAttackMenu = new BonusAttackMenu();
		
		private var startGameButton:ToggleButton = new ToggleButton();
		
		// bar to show information about a unit selected or hovered
		private var weaponInfoBar:WeaponInfoBar = new WeaponInfoBar();
		
		private var weaponContainer:GameWeaponsBarWeaponsContainer = new GameWeaponsBarWeaponsContainer();
		
		private var toolTipSequencer:ToolTipSequencer = new ToolTipSequencer();
		
		///////
		
		private var allowObstacles:Boolean = false;
		
		////////
		
		public function GameWeaponsBar()
		{
			construct();
		}
		
		private function construct():void
		{
			addChild(new menuBaseImage() as Bitmap);
			
			ControlConfigurator.configureButton(startGameButton.upButton, buttonStartNomalImage, buttonStartOverImage, buttonStartDownImage);
			ControlConfigurator.configureButton(startGameButton.downButton, buttonPauseNomalImage, buttonPauseOverImage, buttonPauseDownImage);
			
			startGameButton.x = 2;
			startGameButton.y = 2;
			startGameButton.useManualToggle = false;
			
			startGameButton.upButton.addEventListener(ButtonEvent.BUTTON_CLICK, startGameButton_upStateClickedHandler, false, 0, true);
			startGameButton.downButton.addEventListener(ButtonEvent.BUTTON_CLICK, startGameButton_downStateClickedHandler, false, 0, true);
			
			addChild(startGameButton);
			
			weaponInfoBar.x = 70;
			weaponInfoBar.y = 35;
			weaponInfoBar.height = 22;
			addChild(weaponInfoBar);
			
			weaponContainer.x = 480;
			weaponContainer.allowObstacles = allowObstacles;
			addChild(weaponContainer);
			
			// bonus attack menu
			bonusAttackMenu.x = allowObstacles ? 362 : 404;
			bonusAttackMenu.y = 3;
			addChild(bonusAttackMenu);
			
			bonusAttackMenu.addEventListener(BonusAttackMenuEvent.LAUNCH_AIRCRAFT, bonusAttackMenu_launchAircraftHanlder);
			
			bonusAttackMenu.weaponInfoBar = weaponInfoBar;
		}
		
		///////////////////
		
		public function applyWeaponInfo(info:WeaponInfo):void
		{
			weaponInfoBar.applyWeaponInfo(info);
		}
		
		// shows message in the info bar.
		public function showNormalMessage(message:String):void
		{
			weaponInfoBar.showNormalMessage(message);
		}
		
		// shows warning message in the info bar.
		public function showWarningMessage(message:String, keepShown:Boolean = true):void
		{
			weaponInfoBar.showWarningMessage(message, keepShown);
		}
		
		/// calling support from outside
		
		public function tryCallBombAttack():Boolean
		{
			return bonusAttackMenu.tryCallBombAttack();
		}
		
		public function tryCallAirSupport():Boolean
		{
			return bonusAttackMenu.tryCallAirSupport();
		}
		
		public function supportIsBeingUsed():Boolean
		{
			return bonusAttackMenu.supportIsBeingUsed();
		}
		
		///////////////////
		
		public function applyStoreInfos(storeInfos:Array, gameIsRunning:Boolean, currentLevelMode:String):void
		{
			weaponContainer.applyStoreInfos(storeInfos, gameIsRunning, currentLevelMode);
		}
		
		// places an item for sale to the correct position.
		public function placeItemToMenu(item:IGroundWeapon, useFlyingAnimation:Boolean = false, useBubbleAnimation:Boolean = false):void
		{
			weaponContainer.placeItemToMenu(item, useFlyingAnimation, useBubbleAnimation);
		}
		
		public function interactionWithMenuIsAllowed():Boolean
		{
			return weaponContainer.interactionWithMenuIsAllowed();
		}
		
		public function notifyItemIsTaken(item:IGroundWeapon):void
		{
			weaponContainer.notifyItemIsTaken(item);
		}
		
		////////////////////
		
		// update controls for the current game info
		public function updateForDevInfo(devInfo:DevelopmentInfo, currentLevelMode:String):void
		{
			// some items will be hidded based on the current development status
			bonusAttackMenu.updateButtons(devInfo, currentLevelMode);
		}
		
		// resets controls to initial state.
		public function toInitialState():void
		{
			startGameButton.setUp();
		}
		
		// notifies the pannel so it can start some animation on the controls.
		public function notifyGameStarted():void
		{
			bonusAttackMenu.notifyGameStarted();
			startGameButton.setDown();
			
			toolTipSequencer.clearSequence();
		}
		
		public function notifyLevelWasReset():void
		{
			toolTipSequencer.clearSequence();
			weaponContainer.notifyLevelWasReset();
		}
		
		public function notifyGameResumed():void
		{
			startGameButton.setDown();
		}
		
		public function notifyGamePaused():void
		{
			startGameButton.setUp();
		}
		
		////////////////
		
		private var isShown:Boolean = false;
		
		public function show():void
		{
			isShown = true;
			
			if (notifyShowGuideToolTipsForFirstLevelFlag)
				showGuideToolTipsForFirstLevel();
			
			notifyShowGuideToolTipsForFirstLevelFlag = false;
		}
		
		public function hide():void
		{
			isShown = false;
		}
		
		private var notifyShowGuideToolTipsForFirstLevelFlag:Boolean = false;
		
		public function notifyShowGuideToolTipsForFirstLevel():void
		{
			// if is shown
			if (isShown)
				showGuideToolTipsForFirstLevel();
			else
				notifyShowGuideToolTipsForFirstLevelFlag = true;
		}
		
		public function showGuideToolTipsForFirstLevel():void
		{
			// first show tooltip "Drag a tower to battlefield!"
			// then "Try different types of towers!"
			// then "Start battle!"
			
			toolTipSequencer.clearSequence();
			toolTipSequencer.registerStep(this, new Rectangle(520, 495, 170, 40), new ToolTipInfo(this, new ToolTipSimpleContentDescriptor("FIRST STEP", ["DRAG A TOWER TO THE BATTLEFIELD!"], null, new FontDescriptor(14, 0xF13030, FontResources.KOMTXTB)), ToolTipInfo.POSITION_TOP, false, 540, -85, 555, 0), HintToolTip, this.parent);
			toolTipSequencer.registerStep(this, new Rectangle(520, 495, 170, 40), new ToolTipInfo(this, new ToolTipSimpleContentDescriptor("BUY MORE TOWERS!", [ "USE DIFFERENT TYPES!"], null, new FontDescriptor(14, 0x0114FE, FontResources.KOMTXTB)), ToolTipInfo.POSITION_TOP, false, 550, -95, 560, 0), HintToolTip, this.parent);
			toolTipSequencer.registerStep(startGameButton, startGameButton.getRect(Globals.topLevelApplication), new ToolTipInfo(startGameButton, new ToolTipSimpleContentDescriptor(null, ["START BATTLE!"], null, null, new FontDescriptor(14, 0xD12125, FontResources.KOMTXTB))), HintToolTip, this.parent);
		}
		
		public function tryCheckForTooltipsForAirSupport():void
		{
			bonusAttackMenu.tryCheckForTooltipsForAirSupport();
		}
		
		public function tryCheckForTooltipsForBombSupport():void
		{
			bonusAttackMenu.tryCheckForTooltipsForBombSupport();
		}
		
		/////////////////////
		
		private function startGameButton_upStateClickedHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(GAME_STARTED_CLICKED));
		}
		
		private function startGameButton_downStateClickedHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(GAME_PAUSED_CLICKED));
		}
		
		private function bonusAttackMenu_launchAircraftHanlder(event:BonusAttackMenuEvent):void
		{
			dispatchEvent(event.clone());
		}
	}

}