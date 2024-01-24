/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import constants.GamePlayConstants;
	import events.BonusAttackMenuEvent;
	import events.NewsEvent;
	import events.PauseEvent;
	import events.SpeedControlEvent;
	import flash.events.Event;
	import infoObjects.gameInfo.DevelopmentInfo;
	import infoObjects.panelInfos.GameControlPanelInfo;
	import infoObjects.WeaponInfo;
	import nslib.utils.MouseUtil;
	import panels.news.NewsNotificationPanel;
	import panels.PanelBase;
	import panels.settings.SettingsPanel;
	import supportClasses.resources.TipResources;
	import weapons.base.IGroundWeapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameControlPanel extends PanelBase
	{
		public static const START_CLICKED:String = "startClicked";
		
		public static const PAUSE_CLICKED:String = "resumeClicked";
		
		public static const RESTART_CLICKED:String = "restartClicked";
		
		public static const TO_LEVELS_MAP_MENU_CLICKED:String = "toLevelsMapMenuClicked";
		
		// dispatched when the panel was reset to the initial state
		public static const RESET_TO_INITIAL_STATE:String = "resetToInitialState";
		
		public static const SHOW_ENCYCLOPEDIA_IN_GAME:String = "showEncyclopediaInGame";
		
		/////////////////////
		
		private var gameStatusPanel:GameStatusPanel = new GameStatusPanel();
		
		private var gameWeaponsBar:GameWeaponsBar = new GameWeaponsBar();
		
		private var additionalSettingsBar:GameAdditionalSettingsBar = new GameAdditionalSettingsBar();
		
		private var newsNotificationPanel:NewsNotificationPanel = new NewsNotificationPanel();
		
		private var settingsPanel:SettingsPanel = new SettingsPanel();
		
		/////////////////////
		
		public function GameControlPanel()
		{
			construct();
		}
		
		/////////////////////
		
		private function construct():void
		{
			addPanels();
		}
		
		override public function applyPanelInfo(panelInfo:*):void
		{
			super.applyPanelInfo(panelInfo);
			
			var info:GameControlPanelInfo = GameControlPanelInfo(panelInfo);
			
			gameStatusPanel.lives = info.lives;
			gameStatusPanel.money = info.scores;
			gameStatusPanel.currentWave = info.currentWave;
			gameStatusPanel.totalWaves = info.totalWaves;
		}
		
		///////////////////
		
		// returns true if the cursor is currently over one of the control panels
		public function mouseIsOverControlPanel():Boolean
		{
			return MouseUtil.isMouseOver(gameStatusPanel) || MouseUtil.isMouseOver(gameWeaponsBar) || MouseUtil.isMouseOver(additionalSettingsBar);
		}
		
		public function bonusAttackIsBeingUsed():Boolean
		{
			return gameWeaponsBar.bonusAttackMenu.panelIsBeingUsed;
		}
		
		//------------------------------------------------------------------------------
		//
		// Adding panels
		//
		//------------------------------------------------------------------------------
		
		private function addPanels():void
		{
			gameStatusPanel.x = 0;
			gameStatusPanel.y = 0;
			addChild(gameStatusPanel);
			
			////////////
			
			additionalSettingsBar.x = GamePlayConstants.STAGE_WIDTH - 159;
			additionalSettingsBar.y = 0;
			addChild(additionalSettingsBar);
			
			////////////
			gameWeaponsBar.x = 0;
			gameWeaponsBar.y = GamePlayConstants.STAGE_HEIGHT - 63;
			addChild(gameWeaponsBar);
			
			newsNotificationPanel.x = 35;
			newsNotificationPanel.y = 95;
			addChild(newsNotificationPanel);
			
			showNormalMessage("Place towers on the map and start the game.");
		}
		
		//------------------------------------------------------------------------------
		//
		// Some other methods
		//
		//------------------------------------------------------------------------------
		
		public function toInitialState():void
		{
			newsNotificationPanel.toInitialState();
			gameWeaponsBar.toInitialState();
			additionalSettingsBar.toInitialState();
			dispatchEvent(new Event(RESET_TO_INITIAL_STATE));
		}
		
		// update controls for the current development info
		// some items will be hidded based on the current development status
		public function updateForDevInfo(devInfo:DevelopmentInfo, currentLevelMode:String):void
		{
			gameWeaponsBar.updateForDevInfo(devInfo, currentLevelMode);
		}
		
		// call this function when you want this control to behave as if
		// a user has clicked "Start" button to either start or resume the game.
		public function imitateStartButtonClickedByUser():void
		{
			dispatchEvent(new PauseEvent(PauseEvent.PAUSE_SCREEN_REMOVE_REQUESTED));
			dispatchEvent(new Event(START_CLICKED));
		}
		
		public function notifyLevelWasReset():void
		{
			showWarningMessage(null);
			gameWeaponsBar.notifyLevelWasReset();
		}
		
		// notifies the panel that some other 'start' button was pushed.
		// so the UI here should be changed corresponently.
		// notifies the pannel so it can start some animation on the controls.
		public function notifyGameStarted():void
		{
			gameWeaponsBar.notifyGameStarted();
		}
		
		public function notifyGameResumed():void
		{
			gameWeaponsBar.notifyGameResumed();
		}
		
		public function notifyGamePaused(showPauseScreen:Boolean = false, isAutoPaused:Boolean = false):void
		{
			if (showPauseScreen)
				dispatchEvent(new PauseEvent(PauseEvent.PAUSE_SCREEN_ADD_REQUESTED, isAutoPaused));
			
			gameWeaponsBar.notifyGamePaused();
		}
		
		public function notifyShowGuideToolTipsForFirstLevel():void
		{
			newsNotificationPanel.notifyShowGuideToolTipsForFirstLevel();
			gameWeaponsBar.notifyShowGuideToolTipsForFirstLevel();
		}
		
		public function tryCheckForTooltipsForAirSupport():void
		{
			gameWeaponsBar.tryCheckForTooltipsForAirSupport();
		}
		
		public function tryCheckForTooltipsForBombSupport():void
		{
			gameWeaponsBar.tryCheckForTooltipsForBombSupport();
		}
		
		public function notifyShowUserCanConfigureDevelopments():void
		{
			newsNotificationPanel.showTipAtIndex(TipResources.USER_CAN_UNDO_CHANGES_TIP_INDEX);
		}
		
		// shows information about the currently selected or hovered weapon unit.
		public function applyWeaponInfo(info:WeaponInfo):void
		{
			gameWeaponsBar.applyWeaponInfo(info);
		}
		
		// shows message in the info bar.
		public function showNormalMessage(message:String):void
		{
			gameWeaponsBar.showNormalMessage(message);
		}
		
		// shows warning message in the info bar.
		public function showWarningMessage(message:String, keepShown:Boolean = true):void
		{
			gameWeaponsBar.showWarningMessage(message, keepShown);
		}
		
		// configures prices and affordabilities for items.
		public function applyStoreInfos(infos:Array, gameIsRunning:Boolean, currentLevelMode:String):void
		{
			gameWeaponsBar.applyStoreInfos(infos, gameIsRunning, currentLevelMode);
		}
		
		public function placeItemToMenu(item:IGroundWeapon, useAnimation:Boolean = false):void
		{
			gameWeaponsBar.placeItemToMenu(item, useAnimation);
		}
		
		public function interactionWithMenuIsAllowed():Boolean
		{
			return gameWeaponsBar.interactionWithMenuIsAllowed();
		}
		
		public function notifyItemIsTaken(item:IGroundWeapon):void
		{
			gameWeaponsBar.notifyItemIsTaken(item);
		}
		
		// Shows an icon which a user can click and get more information about an enemy.
		// Stacks them if more than one enemy is waiting to be read about.
		public function notifyAboutNewEnemy(enemyInfo:WeaponInfo):void
		{
			newsNotificationPanel.notifyAboutNewEnemy(enemyInfo);
		}
		
		// Shows a tip in the beginning of a level to give a user some instructions
		public function showLevelIntroTip(tipIndex:int):void
		{
			newsNotificationPanel.showTipAtIndex(tipIndex);
		}
		
		// Shows an icon which a user can click and get a game tip.
		public function notifyNeedShowTipIcon(tipIndex:int):void
		{
			newsNotificationPanel.notifyNeedShowTip(tipIndex);
		}
		
		/// calling support from outside
		
		public function tryCallBombAttack():Boolean
		{
			return gameWeaponsBar.tryCallBombAttack();
		}
		
		public function tryCallAirSupport():Boolean
		{
			return gameWeaponsBar.tryCallAirSupport();
		}
		
		public function supportIsBeingUsed():Boolean
		{
			return gameWeaponsBar.supportIsBeingUsed();
		}
		
		//------------------------------------------------------------------------------
		//
		// Overriden methods
		//
		//------------------------------------------------------------------------------
		
		override public function show():void
		{
			super.show();
			addListenersToButtons();
			
			gameWeaponsBar.show();
		}
		
		override public function hide():void
		{
			super.hide();
			removeListenersFromButtons();
			
			gameWeaponsBar.hide();
		}
		
		//------------------------------------------------------------------------------
		//
		// Adding/Removing handlers 
		//
		//------------------------------------------------------------------------------
		
		private function addListenersToButtons():void
		{
			gameWeaponsBar.addEventListener(GameWeaponsBar.GAME_STARTED_CLICKED, gameWeaponsBar_gameStartedClickedHandler);
			gameWeaponsBar.addEventListener(GameWeaponsBar.GAME_PAUSED_CLICKED, gameWeaponsBar_gamePausedClickedHandler);
			gameWeaponsBar.addEventListener(BonusAttackMenuEvent.LAUNCH_AIRCRAFT, gameWeaponsBar_launchAircraftHandler);
			
			newsNotificationPanel.addEventListener(NewsNotificationPanel.PAUSE_GAME_FOR_READING, newsNotificationPanel_pauseGameForReadingHandler);
			newsNotificationPanel.addEventListener(NewsEvent.NEW_ENEMY_OPENED, newsNotificationPanel_newEnemyOpenedHandler);
			newsNotificationPanel.addEventListener(NewsNotificationPanel.RESUME_GAME_AFTER_READING, newsNotificationPanel_resumeGameAfterReadingHandler);
			
			additionalSettingsBar.addEventListener(GameAdditionalSettingsBar.GAME_SETTINGS_CLICKED, additionalSettingsBar_gameSettingsClickedHandler);
			additionalSettingsBar.addEventListener(GameAdditionalSettingsBar.ENCYCLOPEDIA_CLICKED, additionalSettingsBar_encyclopediaClickedHandler);
			additionalSettingsBar.addEventListener(SpeedControlEvent.GAME_SPEED_CHANGED, additionalSettingsBar_speedChangedHandler);
		}
		
		private function removeListenersFromButtons():void
		{
			gameWeaponsBar.removeEventListener(GameWeaponsBar.GAME_STARTED_CLICKED, gameWeaponsBar_gameStartedClickedHandler);
			gameWeaponsBar.removeEventListener(GameWeaponsBar.GAME_PAUSED_CLICKED, gameWeaponsBar_gamePausedClickedHandler);
			gameWeaponsBar.removeEventListener(BonusAttackMenuEvent.LAUNCH_AIRCRAFT, gameWeaponsBar_launchAircraftHandler);
			
			newsNotificationPanel.removeEventListener(NewsNotificationPanel.PAUSE_GAME_FOR_READING, newsNotificationPanel_pauseGameForReadingHandler);
			newsNotificationPanel.removeEventListener(NewsEvent.NEW_ENEMY_OPENED, newsNotificationPanel_newEnemyOpenedHandler);
			newsNotificationPanel.removeEventListener(NewsNotificationPanel.RESUME_GAME_AFTER_READING, newsNotificationPanel_resumeGameAfterReadingHandler);
			
			additionalSettingsBar.removeEventListener(GameAdditionalSettingsBar.GAME_SETTINGS_CLICKED, additionalSettingsBar_gameSettingsClickedHandler);
			additionalSettingsBar.removeEventListener(GameAdditionalSettingsBar.ENCYCLOPEDIA_CLICKED, additionalSettingsBar_encyclopediaClickedHandler);
			additionalSettingsBar.removeEventListener(SpeedControlEvent.GAME_SPEED_CHANGED, additionalSettingsBar_speedChangedHandler);
		}
		
		//------------------------------------------------------------------------------
		//
		// Handlers
		//
		//------------------------------------------------------------------------------
		
		private function gameWeaponsBar_gameStartedClickedHandler(event:Event):void
		{
			dispatchEvent(new PauseEvent(PauseEvent.PAUSE_SCREEN_REMOVE_REQUESTED));
			dispatchEvent(new Event(START_CLICKED));
		}
		
		private function gameWeaponsBar_gamePausedClickedHandler(event:Event):void
		{
			dispatchEvent(new PauseEvent(PauseEvent.PAUSE_SCREEN_ADD_REQUESTED));
			dispatchEvent(new Event(PAUSE_CLICKED));
		}
		
		private function gameWeaponsBar_launchAircraftHandler(event:BonusAttackMenuEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function newsNotificationPanel_pauseGameForReadingHandler(event:Event):void
		{
			dispatchEvent(new Event(PAUSE_CLICKED));
		}
		
		private function newsNotificationPanel_newEnemyOpenedHandler(event:NewsEvent):void
		{
			dispatchEvent(event);
		}
		
		private function newsNotificationPanel_resumeGameAfterReadingHandler(event:Event):void
		{
			dispatchEvent(new Event(START_CLICKED));
		}
		
		/////////////////
		
		// adding the settings panel
		private function additionalSettingsBar_gameSettingsClickedHandler(event:Event):void
		{
			dispatchEvent(new Event(PAUSE_CLICKED));
			settingsPanel.show();
			settingsPanel.addEventListener(SettingsPanel.RESUME_CLICKED, settingsPanel_resumeClicked);
			settingsPanel.addEventListener(SettingsPanel.TO_MENU_CLICKED, settingsPanel_toMenuClicked);
			settingsPanel.addEventListener(SettingsPanel.RESTART_CLICKED, settingsPanel_restartClicked);
		}
		
		private function additionalSettingsBar_encyclopediaClickedHandler(event:Event):void
		{
			dispatchEvent(new Event(SHOW_ENCYCLOPEDIA_IN_GAME));
		}
		
		private function additionalSettingsBar_speedChangedHandler(event:SpeedControlEvent):void
		{
			dispatchEvent(event);
		}
		
		///////////////
		
		private function settingsPanel_resumeClicked(event:Event):void
		{
			removeListenersFromSettingsPanel();
			dispatchEvent(new Event(START_CLICKED));
		}
		
		private function settingsPanel_toMenuClicked(event:Event):void
		{
			removeListenersFromSettingsPanel();
			dispatchEvent(new Event(TO_LEVELS_MAP_MENU_CLICKED));
		}
		
		private function settingsPanel_restartClicked(event:Event):void
		{
			removeListenersFromSettingsPanel();
			dispatchEvent(new Event(RESTART_CLICKED));
		}
		
		private function removeListenersFromSettingsPanel():void
		{
			settingsPanel.removeEventListener(SettingsPanel.RESUME_CLICKED, settingsPanel_resumeClicked);
			settingsPanel.removeEventListener(SettingsPanel.TO_MENU_CLICKED, settingsPanel_toMenuClicked);
			settingsPanel.removeEventListener(SettingsPanel.RESTART_CLICKED, settingsPanel_restartClicked);
		}
	}

}