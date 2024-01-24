/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package mainPack
{
	import bot.GameBot;
	import config.NavigateConfig;
	import constants.GamePlayConstants;
	import controllers.AchievementsController;
	import controllers.GameInfoController;
	import controllers.MapController;
	import controllers.PreloadController;
	import controllers.ScoreController;
	import controllers.SoundController;
	import controllers.StatisticsController;
	import controllers.WaveController;
	import controllers.WaveGenerator;
	import islandBreak.controllers.WeaponController;
	import controllers.WeaponStoreController;
	import events.AchievementEvent;
	import events.BonusAttackMenuEvent;
	import events.ClearSlotEvent;
	import events.NewsEvent;
	import events.PanelEvent;
	import events.SelectEvent;
	import events.SpeedControlEvent;
	import events.WaveEvent;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import infoObjects.gameInfo.DevelopmentInfo;
	import infoObjects.gameInfo.GameInfo;
	import infoObjects.panelInfos.GameControlPanelInfo;
	import infoObjects.panelInfos.LevelsMapPanelInfo;
	import infoObjects.panelInfos.SlotsPanelInfo;
	import infoObjects.WeaponInfo;
	import nslib.AIPack.grid.GridArray;
	import nslib.animation.DeltaTime;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.events.ButtonEvent;
	import nslib.core.Globals;
	import nslib.utils.imageUtils.PNGEncoder;
	import panels.encyclopedia.EncyclopediaPanel;
	import panels.inGame.GameControlPanel;
	import panels.inGame.GameOverPanel;
	import panels.inGame.VictoryPanel;
	import panels.inGame.WeaponSettingsPanel;
	import panels.starting.LevelInfoPanel;
	import supportClasses.LogParameters;
	import supportClasses.resources.LogMessages;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.TipResources;
	import supportControls.BonusTextGenerator;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	import weapons.base.IWeapon;
	import weapons.objects.Bridge;
	import weapons.objects.Teleport;
	import weapons.objects.TrafficLight;
	
	/**
	 * GameController is the main controller for the game logic.
	 */
	public class GameController
	{
		
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------------
		// Controllers
		//------------------------------------------
		
		/**
		 * Controls units.
		 */
		private var itemController:GameControllerItemManager = new GameControllerItemManager();
		
		/**
		 * Controls progress bars
		 */
		private var progressBarController:GameControllerProgressBarManager = new GameControllerProgressBarManager();
		
		/**
		 * Performs operations with the map: loading, working with trajectories, checking paths.
		 */
		private var mapController:MapController;
		
		/**
		 * Used to generate new waves on time.
		 */
		private var waveController:WaveController = new WaveController();
		
		/**
		 * Used to work with the game score: add bonuses, spend scores.
		 */
		private var scoreController:ScoreController = new ScoreController();
		
		/**
		 * Provides information about the current game.
		 */
		private var gameInfoController:GameInfoController = new GameInfoController();
		
		/**
		 * Controls most of the weapon actions: shooting, moving, destroying, special abilities.
		 * Also works with bridges, teleports.
		 */
		private var weaponController:WeaponController;
		
		/**
		 * Generates new items for sale with information about their availability.
		 */
		private var weaponStoreController:WeaponStoreController = new WeaponStoreController();
		
		/**
		 * Preloads some heavy objects like sequences of images.
		 */
		private var preloadController:PreloadController = new PreloadController();
		
		/**
		 * Navigates between all screens in the game.
		 */
		private var navigator:PanelNavigator;
		
		//private var levelBuilder:LevelBuilder = new LevelBuilder();
		
		//------------------------------------------
		// Parameters
		//------------------------------------------
		
		/**
		 * Number of lives in the current level.
		 */
		private var lives:int = GamePlayConstants.INITIAL_NUMBER_OF_LIVES;
		
		//------------------------------------------
		// gameIsRunning
		//------------------------------------------
		
		private var _gameIsRunning:Boolean = false;
		
		/**
		 * true if the game has started and not paused.
		 * Start means waves started to come. There is some period of time before waves are called,
		 * during which a user can do some initial building and think about the necessary strategy.
		 */
		public function get gameIsRunning():Boolean
		{
			return _gameIsRunning;
		}
		
		//------------------------------------------
		// currentLevel
		//------------------------------------------
		
		private var _currentLevel:int = 0;
		
		/**
		 * Currently selected level.
		 */
		public function get currentLevel():int
		{
			return _currentLevel;
		}
		
		//------------------------------------------
		// currentLevelMode
		//------------------------------------------
		
		private var _currentLevelMode:String = ModeSettings.MODE_NORMAL;
		
		/**
		 * Currently selected level mode.
		 */
		public function get currentLevelMode():String
		{
			return _currentLevelMode;
		}
		
		//------------------------------------------
		// Flags
		//------------------------------------------
		
		/**
		 * this flag becomes true, when all waves are launched but there are some enemies still left
		 * and they are on their way to the end of the path.
		 */
		private var pendingLevelCompleted:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function GameController(navigator:PanelNavigator)
		{
			this.navigator = navigator;
			registerPanels();
			
			scoreController.reset(currentLevel, ModeSettings.MODE_NORMAL);
			
			// building links
			weaponController = new WeaponController(navigator.gameStage);
			mapController = new MapController(navigator.gameStage);
			mapController.weaponController = weaponController;
			weaponStoreController.scoreController = scoreController;
			
			itemController.gameController = this;
			itemController.mapController = mapController;
			itemController.weaponController = weaponController;
			itemController.scoreController = scoreController;
			itemController.weaponStoreController = weaponStoreController;
			itemController.gameInfoController = gameInfoController;
			itemController.navigator = navigator;
			itemController.progressBarController = progressBarController;
			
			progressBarController.gameController = this;
			progressBarController.mapController = mapController;
			progressBarController.navigator = navigator;
			progressBarController.scoreController = scoreController;
			progressBarController.waveController = waveController;
			
			//levelBuilder.gameController = this;
			//levelBuilder.resetLevel = resetLevel;
			//levelBuilder.mapController = mapController;
			
			//////////
			
			// when a new achievement was reached we need to save this information
			gameInfoController.addEventListener(AchievementEvent.ACHIEVEMENT_REACHED, gameInfoController_achievementReachedHandler);
			
			configureBot();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: start for the first time
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Call this method in the very beginning of the game.
		 */
		public function start():void
		{
			SoundController.instance.playMusicTrack(SoundResources.MUSIC_INTRO);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: working with panels
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Registers all handlers to the panels in the game that somehow influence the game logic.
		 * Like pausing/resuming, saving, loading.
		 * Also allows panels to request new updates for their content by dispatching PanelEvent.REQUEST_INFOS event.
		 */
		private function registerPanels():void
		{
			// selecting a saved game or starting a new one
			navigator.slotsPanel.addEventListener(PanelEvent.REQUEST_INFOS, slotsPanel_requestInfosHandler);
			navigator.slotsPanel.addEventListener(SelectEvent.SELECTED, slotsPanel_selectedHandler);
			navigator.slotsPanel.addEventListener(ClearSlotEvent.CLEAR_SLOT, slotsPanel_clearSlotHandler);
			
			// filling map with available levels
			navigator.levelsMapPanel.addEventListener(PanelEvent.REQUEST_INFOS, levelsMapPanel_requestInfosHandler);
			
			// filling with the current development status
			navigator.devCenterPanel.addEventListener(PanelEvent.REQUEST_INFOS, devCenterPanel_requestInfosHandler);
			
			// filling with the current achievements
			navigator.achievementsPanel.addEventListener(PanelEvent.REQUEST_INFOS, achievementsPanel_requestInfosHandler);
			
			// this panel needs the current game state to correctly visualize weapon units, for which a user can read information
			navigator.encyclopediaPanel.addEventListener(PanelEvent.REQUEST_INFOS, encyclopediaPanel_requestInfosHandler);
			
			// selecting a level
			navigator.levelInfoPanel.addEventListener(PanelEvent.REQUEST_INFOS, levelInfoPanel_requestInfosHandler);
			navigator.levelInfoPanel.addEventListener(LevelInfoPanel.TO_BATTLE_CLIKCED, levelInfoPanel_toBattleHandler);
			
			// some user interactions during the level
			navigator.gameControlPanel.addEventListener(GameControlPanel.START_CLICKED, gameControlPanel_startClickedHandler);
			navigator.gameControlPanel.addEventListener(GameControlPanel.PAUSE_CLICKED, gameControlPanel_pauseClickedHandler);
			navigator.gameControlPanel.addEventListener(GameControlPanel.RESTART_CLICKED, gameControlPanel_restartClickedHandler);
			navigator.gameControlPanel.addEventListener(GameControlPanel.TO_LEVELS_MAP_MENU_CLICKED, gameControlPanel_toLevelsMapMenuClickedHandler);
			navigator.gameControlPanel.addEventListener(GameControlPanel.SHOW_ENCYCLOPEDIA_IN_GAME, gameControlPanel_showEncyclopediaInGameHandler);
			navigator.gameControlPanel.addEventListener(SpeedControlEvent.GAME_SPEED_CHANGED, gameControlPanel_gameSpeedChangedHandler);
			navigator.gameControlPanel.addEventListener(NewsEvent.NEW_ENEMY_OPENED, gameControlPanel_newEnemyOpenedHandler);
			
			// when a user calls air support: a new plane is launched
			navigator.gameControlPanel.addEventListener(BonusAttackMenuEvent.LAUNCH_AIRCRAFT, gameControlPanel_launchAircraftHandler);
			
			// when a user clicks the weapon menu and selects an option
			navigator.weaponSettingsPanel.addEventListener(WeaponSettingsPanel.REPAIR_CLICK, weaponSettingsPanel_repairClickHandler);
			navigator.weaponSettingsPanel.addEventListener(WeaponSettingsPanel.SELL_CLICK, weaponSettingsPanel_sellClickHandler);
			navigator.weaponSettingsPanel.addEventListener(WeaponSettingsPanel.UPGRADE_CLICK, weaponSettingsPanel_upgradeClickHandler);
			
			////////////
			
			//Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			
			// when the app gets out of focus and deactivates
			Globals.topLevelApplication.addEventListener(Event.DEACTIVATE, app_deactivateHandler);
			
			// for button sounds
			Globals.topLevelApplication.addEventListener(ButtonEvent.BUTTON_MOUSE_OVER, stage_buttonMouseOverHandler, true);
			Globals.topLevelApplication.addEventListener(ButtonEvent.BUTTON_CLICK, stage_buttonClickHandler, true);
			
			////////////
			
			// when a user decides to retry a level he has just won
			navigator.victoryPanel.addEventListener(VictoryPanel.RESTART_CLICKED, victoryPanel_restartClickHanlder);
			// when a user decides to continue the game
			navigator.victoryPanel.addEventListener(VictoryPanel.CONTINUE_CLICKED, victoryPanel_continueClickHanlder);
			// when a user decides to retry a level he has just lost 
			navigator.gameOverPanel.addEventListener(GameOverPanel.RESTART_CLICKED, gameOverPanel_restartClickHanlder);
			// when a user decides to quit to the menu after losing a level
			navigator.gameOverPanel.addEventListener(GameOverPanel.TO_MENU_CLICKED, gameOverPanel_toMenuClickHanlder);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handlers for panels
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------
		//  slotsPanel
		//--------------------------------
		
		private function slotsPanel_requestInfosHandler(event:PanelEvent):void
		{
			// show avaialble stols and saved games in them
			navigator.slotsPanel.applyPanelInfo(new SlotsPanelInfo(gameInfoController.loadSavedGames()));
		}
		
		private function slotsPanel_selectedHandler(event:SelectEvent):void
		{
			// applying the selected slot
			GameTracker.api.customMsg(TrackingMessages.SLOT_SELECTED + ":" + event.selectedIndex);
			
			gameInfoController.setCurrentSlot(event.selectedIndex);
			gameInfoController.applyGameInfo(event.selectedItem as GameInfo);
			
			TipResources.updateTipsCollectionForGameInfo(gameInfoController.gameInfo);
			DifficultyConfig.assingCurrentBonusInfo(gameInfoController.gameInfo.bonusInfo);
		}
		
		private function slotsPanel_clearSlotHandler(event:ClearSlotEvent):void
		{
			// clearing a slot
			gameInfoController.clearGameAtSlot(event.slotIndex);
		}
		
		//--------------------------------
		//  levelsMapPanel
		//--------------------------------
		
		private function levelsMapPanel_requestInfosHandler(event:PanelEvent):void
		{
			// need to check this before calling levelsMapPanel.applyPanelInfo
			// check for notifications
			// need to notify a user that he can change all upgrades (undo, reconfigure)
			if (gameInfoController.gameInfo.helpInfo.userMadeFirstDevelopmet && !gameInfoController.gameInfo.helpInfo.userNotifiedThatHeCanReconfigureDevelopments)
			{
				navigator.gameControlPanel.notifyShowUserCanConfigureDevelopments();
				gameInfoController.gameInfo.helpInfo.userNotifiedThatHeCanReconfigureDevelopments = true;
			}
			
			// updating the map content
			navigator.levelsMapPanel.applyPanelInfo(new LevelsMapPanelInfo(gameInfoController.gameInfo));
			
			if (gameInfoController.gameInfo.numLevelsPassed == GamePlayConstants.NUMBER_OF_LEVELS && !gameInfoController.gameInfo.helpInfo.userCongratulatedAfterFinishingGame)
			{
				gameInfoController.gameInfo.helpInfo.userCongratulatedAfterFinishingGame = true;
				navigator.showGameFinishedCongratulationsScreen();
			}
			
			// need to save the current game here
			gameInfoController.saveCurrentGame();
			
			// switch to the right track
			if (SoundController.instance.currentTrackName != SoundResources.MUSIC_INTRO)
				SoundController.instance.playMusicTrack(SoundResources.MUSIC_INTRO);
		}
		
		//--------------------------------
		//  devCenterPanel
		//--------------------------------
		
		private function devCenterPanel_requestInfosHandler(event:PanelEvent):void
		{
			// update the development center data
			navigator.devCenterPanel.applyPanelInfo(gameInfoController.gameInfo);
		}
		
		//--------------------------------
		//  achievementsPanel
		//--------------------------------
		
		private function achievementsPanel_requestInfosHandler(event:PanelEvent):void
		{
			// update the achievements panel
			navigator.achievementsPanel.applyPanelInfo(gameInfoController.gameInfo);
		}
		
		//--------------------------------
		//  encyclopediaPanel
		//--------------------------------
		
		private function encyclopediaPanel_requestInfosHandler(event:PanelEvent):void
		{
			// update the encyclopedia panel
			navigator.encyclopediaPanel.applyPanelInfo(gameInfoController.gameInfo);
		}
		
		//--------------------------------
		//  levelInfoPanel
		//--------------------------------
		
		private function levelInfoPanel_requestInfosHandler(event:PanelEvent):void
		{
			// update the information for the selected level
			navigator.levelInfoPanel.applyPanelInfo(navigator.levelsMapPanel.selectedLevel);
			
			// no reason to show a warning for the 1st level
			if (navigator.levelsMapPanel.selectedLevel.index != 0 && gameInfoController.gameInfo.helpInfo.userCollectedEnoughStarsForTheFirstTimeAndAleadyNotified && !gameInfoController.gameInfo.helpInfo.userMadeFirstDevelopmet)
				navigator.levelInfoPanel.recommendToMakeDevelopments();
		}
		
		/**
		 *  This method is called when a user pressed the "Play" button to start a level.
		 */
		private function levelInfoPanel_toBattleHandler(event:Event):void
		{
			// need only the index of the selected level
			_currentLevel = navigator.levelsMapPanel.selectedLevel.index;
			
			// define the current mode
			_currentLevelMode = navigator.levelInfoPanel.getCurrentLevelMode();
			// restart the game with for the selected level
			resetLevel();
		}
		
		//--------------------------------
		//  gameControlPanel
		//--------------------------------
		
		/**
		 * When a user pressed a button to start the game.
		 * Start means that waves will start coming.
		 */
		private function gameControlPanel_startClickedHandler(event:Event):void
		{
			// if the game is being resumed just start the timer again
			if (globalTimeIsPaused())
				resumeGame();
			else
				// otherwise start a game
				startGame();
		}
		
		private function gameControlPanel_pauseClickedHandler(event:Event):void
		{
			pauseGame();
		}
		
		private function gameControlPanel_restartClickedHandler(event:Event):void
		{
			GameTracker.api.endLevel(); // gameInfoController.gameInfo);
			GameTracker.api.writeCurrentGameStatus(gameInfoController.gameInfo);
			
			// reset everything for the selected level
			resetLevel();
		}
		
		private function gameControlPanel_toLevelsMapMenuClickedHandler(event:Event):void
		{
			GameTracker.api.endLevel(); // gameInfoController.gameInfo);
			GameTracker.api.writeCurrentGameStatus(gameInfoController.gameInfo);
			
			// if for some reason the time was stopped
			// we need to resume it to let all the animation run
			resumeGame();
			navigator.navigateToLevelsMapPanel();
			resetLevel(false);
		}
		
		private function gameControlPanel_showEncyclopediaInGameHandler(event:Event):void
		{
			pauseGame();
			navigator.showEncyclopediaInGame();
			// need to resume the game after "Back" is clicked
			navigator.encyclopediaPanel.addEventListener(EncyclopediaPanel.BACK_CLICKED, encyclopediaPanel_backClickedHandler);
		}
		
		private function encyclopediaPanel_backClickedHandler(event:Event):void
		{
			navigator.encyclopediaPanel.removeEventListener(EncyclopediaPanel.BACK_CLICKED, encyclopediaPanel_backClickedHandler);
			// if the encyclopeida panel was called during the game
			// we need to resume the game
			resumeGame();
		}
		
		///////// new enemy
		
		/**
		 * When a user opens the info box to read about the new enemy.
		 */
		private function gameControlPanel_newEnemyOpenedHandler(event:NewsEvent):void
		{
			gameInfoController.gameInfo.helpInfo.notifyNewEnemyShown(event.enemyInfo);
		}
		
		///////// speeding up the game
		
		private function gameControlPanel_gameSpeedChangedHandler(event:SpeedControlEvent):void
		{
			if (event.newSpeed > 1)
			{
				DeltaTime.globalDeltaTimeCounter.timeMultiplier = event.newSpeed;
				
				if (StatisticsController.allowStatiscits)
					StatisticsController.logMessage(new LogParameters(LogMessages.LEVEL_ACCELERATION_ON));
				
				GameTracker.api.customMsg(TrackingMessages.LEVEL_ACCELERATION_ON + ":" + event.newSpeed);
			}
			else
				backToNormalSpeed();
		}
		
		private function backToNormalSpeed():void
		{
			if (GameBot.supressUI)
				return;
			
			DeltaTime.globalDeltaTimeCounter.timeMultiplier = 1;
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.LEVEL_ACCELERATION_OFF));
			
			GameTracker.api.customMsg(TrackingMessages.LEVEL_ACCELERATION_OFF);
		}
		
		/**
		 * When a user calls air support.
		 */
		private function gameControlPanel_launchAircraftHandler(event:BonusAttackMenuEvent):void
		{
			itemController.launchUserAircraft(event.x, event.y, event.level);
		}
		
		//------------------------------------------------
		//  stage keyboard handing for dev purposes only
		//------------------------------------------------
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			// keys for developing purposes
			
			if (event.keyCode == Keyboard.S)
			{
				// take a snapshot
				var bm:BitmapData = new BitmapData(navigator.stage.stageWidth, navigator.stage.stageHeight, true, 0x00000000);
				var fileRef:FileReference = new FileReference();
				//bm.draw(navigator.stage, new Rectangle(0, 0, bm.width, bm.height), new Point(0, 0))
				bm.draw(navigator.stage);
				fileRef.save(PNGEncoder.encode(bm));
			}
			
			if (event.keyCode == Keyboard.B && navigator.getCurrentStep().name == NavigateConfig.STEP_SHOW_GAME_STAGE)
			{
				//if (levelBuilder.isBuilding)
				//	levelBuilder.removeInteraction();
				
				GameBot.startBotForCurrentLevel();
			}
		
		/* 	if (event.keyCode == Keyboard.D)
		   WeaponController.putDevastatingExplosion(MouseUtil.getCursorCoordinates().x, MouseUtil.getCursorCoordinates().y, 10);
		
		   if (event.keyCode == Keyboard.D)
		   levelBuilder.startBuilding();
		
		   if (event.keyCode == Keyboard.G)
		   GameBot.openGlobalTextMenu();
		
		   if (event.keyCode == Keyboard.T && navigator.getCurrentStep().name == NavigateConfig.STEP_SHOW_GAME_STAGE)
		   {
		   if (levelBuilder.isBuilding)
		   levelBuilder.removeInteraction();
		
		   GameBot.startTrackingBotForCurrentLevel();
		 }*/
		}
		
		//------------------------------------------------
		//  app deactivation
		//------------------------------------------------
		
		private function app_deactivateHandler(event:Event):void
		{
			if (gameIsRunning && !globalTimeIsPaused() && GameSettings.enableAutopause)
				pauseGame(true, true);
		}
		
		//------------------------------------------------
		//  button sounds
		//------------------------------------------------
		
		private function stage_buttonMouseOverHandler(event:Event):void
		{
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_HOVER);
		}
		
		private function stage_buttonClickHandler(event:Event):void
		{
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_TAP);
		}
		
		//------------------------------------------------
		//  pause / resume game
		//------------------------------------------------
		
		private function pauseGame(showPauseScreen:Boolean = false, isAutoPaused:Boolean = false):void
		{
			// stop the global timer and all animation depending on it will stop as well
			if (!globalTimeIsPaused())
				DeltaTime.globalDeltaTimeCounter.stop();
			
			navigator.gameControlPanel.notifyGamePaused(showPauseScreen, isAutoPaused);
			
			itemController.forbidUserInteraction();
			
			StatisticsController.pause();
			
			GameTracker.api.customMsg(TrackingMessages.LEVEL_PAUSED);
		}
		
		public function globalTimeIsPaused():Boolean
		{
			return !DeltaTime.globalDeltaTimeCounter.isRunning;
		}
		
		private function resumeGame():void
		{
			DeltaTime.globalDeltaTimeCounter.start();
			
			itemController.allowUserInteraction();
			
			// tricky part: resume game means resuming time.
			// if the game hasn't started yet, we should not notify the UI about resuming the game
			if (gameIsRunning)
				navigator.gameControlPanel.notifyGameResumed();
			
			StatisticsController.resume();
			
			GameTracker.api.customMsg(TrackingMessages.LEVEL_RESUMED);
		}
		
		//------------------------------------------------
		//  weaponSettingsPanel
		//------------------------------------------------
		
		private function weaponSettingsPanel_repairClickHandler(event:Event):void
		{
			itemController.repairItem(navigator.weaponSettingsPanel.selectedItem);
		}
		
		private function weaponSettingsPanel_sellClickHandler(event:Event):void
		{
			itemController.sellItem(navigator.weaponSettingsPanel.selectedItem);
		}
		
		private function weaponSettingsPanel_upgradeClickHandler(event:Event):void
		{
			itemController.upgradeItem(navigator.weaponSettingsPanel.selectedItem);
		}
		
		//------------------------------------------------
		//  victoryPanel
		//------------------------------------------------
		
		private function victoryPanel_restartClickHanlder(event:Event):void
		{
			GameTracker.api.endLevel(); // gameInfoController.gameInfo);
			GameTracker.api.writeCurrentGameStatus(gameInfoController.gameInfo);
			
			resetLevel();
		}
		
		private function victoryPanel_continueClickHanlder(event:Event):void
		{
			_currentLevel++;
			resetLevel(false);
			
			if (StatisticsController.allowStatiscits)
				navigator.showStatistics();
		}
		
		//------------------------------------------------
		//  gameOverPanel
		//------------------------------------------------
		
		private function gameOverPanel_restartClickHanlder(event:Event):void
		{
			resetLevel();
		}
		
		private function gameOverPanel_toMenuClickHanlder(event:Event):void
		{
			resetLevel(false);
			
			if (StatisticsController.allowStatiscits)
				navigator.showStatistics();
		}
		
		//------------------------------------------------
		//  gameInfoController
		//------------------------------------------------
		
		private function gameInfoController_achievementReachedHandler(event:AchievementEvent):void
		{
			navigator.showAchievementPanel(event.achievementInfo);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Main operations for game
		//
		//--------------------------------------------------------------------------
		
		/**
		 * This method resets everything and reconfigures all managers for the selected level.
		 * @param	buildNewGame If true, new content for the game stage will be created.
		 */
		private function resetLevel(buildNewGame:Boolean = true):void
		{
			// need to resume time in case it was stopped for some reason
			if (globalTimeIsPaused())
				DeltaTime.globalDeltaTimeCounter.start();
			
			// just in case we need to prevent accelerated animation anywhere else besides the gamestage
			backToNormalSpeed();
			
			_gameIsRunning = false;
			
			itemController.removeAllItems();
			
			// reseting the number of lives
			// should be the same as the number of waves in a level
			lives = ModeSettings.getNumberOfLivesForLevel(currentLevel, currentLevelMode);
			
			// reseting some UI
			navigator.notifyLevelWasReset();
			navigator.gameControlPanel.notifyLevelWasReset();
			
			// reseting controllers
			weaponStoreController.reset(getModeBasedDevInfo());
			waveController.reset();
			waveController.setCurrentConfigurations(currentLevel, currentLevelMode);
			scoreController.reset(currentLevel, currentLevelMode);
			weaponController.reset();
			
			pendingLevelCompleted = false;
			
			//////////
			
			var customMapDescription:Array = null;
			
			/*if (levelBuilder.isBuilding)
			   {
			   customMapDescription = levelBuilder.getCurrentDescription();
			   buildNewGame = true;
			 }*/
			
			//////////
			
			if (buildNewGame)
			{
				buildGame(customMapDescription);
				updateParameters();
			}
		}
		
		private function getModeBasedDevInfo():DevelopmentInfo
		{
			return currentLevelMode == ModeSettings.MODE_NORMAL ? gameInfoController.gameInfo.developmentInfo : ModeSettings.getDevelopmentInfoForLevel(currentLevel, currentLevelMode)
		}
		
		/**
		 * Completely rebuilds the content of the game stage.
		 * @param	customMapDescription If specified a custom map will be applied for the selected level.
		 */
		private function buildGame(customMapDescription:Array = null):void
		{
			GameTracker.api.beginLevel(currentLevel); // , gameInfoController.gameInfo);
			GameTracker.api.writeCurrentGameStatus(gameInfoController.gameInfo);
			
			// preloads objects to accelerate the gameplay
			preloadController.startPreloadingForLevel(currentLevel);
			
			// map and trajectory
			mapController.loadMapForLevel(currentLevel, customMapDescription);
			
			navigator.gameStage.rebuild();
			navigator.gameStage.setPermanentBitmapData(mapController.generateBitmapData());
			
			navigator.gameControlPanel.updateForDevInfo(getModeBasedDevInfo(), currentLevelMode);
			
			// teleports
			registerTeleports();
			
			// bridges
			registerBridges();
			
			// traffic lights
			registerTrafficLights();
			
			mapController.generateTrajectories();
			mapController.visualizeTrajectories();
			mapController.clearValidation();
			
			// check for birds
			if (mapController.currentMap.birdsFlightProgram)
				navigator.gameStage.dispatchBirds(mapController.currentMap.birdsFlightProgram);
			
			// add animated parts to the map
			mapController.currentMap.placeAnimatedPartsGround(navigator.gameStage.childrenLayer);
			mapController.currentMap.placeAnimatedPartsSky(navigator.gameStage.aircraftLayer);
			
			// filling menu with items for sale
			itemController.fillMissingItemsInMenu();
			
			progressBarController.showInitialProgressBars();
			
			// if a user is playing a hard mode that means he needs no instructions
			if (!GameBot.isPlaying && currentLevelMode == ModeSettings.MODE_NORMAL)
				checkForGuideTips();
			
			SoundController.instance.playMusicTrack(SoundResources.MUSIC_BEFORE_BATTLE);
			
			itemController.allowUserInteraction();
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.startStatistics(currentLevel);
		}
		
		private function checkForGuideTips():void
		{
			var tipIndex:int = TipResources.getIntroTipIndexForLevel(currentLevel, gameInfoController.gameInfo);
			
			if (tipIndex != -1)
			{
				AnimationEngine.globalAnimator.executeFunction(navigator.gameControlPanel.showLevelIntroTip, [tipIndex], AnimationEngine.globalAnimator.currentTime + 500);
				
				// we need to wait for a user to read tips in the very begining of a level
				// and only then show tooltips in the game stage
				navigator.gameControlPanel.addEventListener(GameControlPanel.START_CLICKED, gameControlPanel_userFinishedReadingIntoTipsHandler);
			}
			else
				tryShowNewPowerInformation();
		}
		
		private function gameControlPanel_userFinishedReadingIntoTipsHandler(event:Event):void
		{
			navigator.gameControlPanel.removeEventListener(GameControlPanel.START_CLICKED, gameControlPanel_userFinishedReadingIntoTipsHandler);
			
			if (currentLevel == 0)
				navigator.gameControlPanel.notifyShowGuideToolTipsForFirstLevel();
			
			tryShowNewPowerInformation();
		}
		
		private function tryShowNewPowerInformation():void
		{
			if (!gameInfoController.gameInfo.helpInfo.toolTipUserNotifiedAboutNewPowerBombSupport && gameInfoController.gameInfo.developmentInfo.bombSupportLevel > -1)
				navigator.gameControlPanel.tryCheckForTooltipsForBombSupport();
			if (!gameInfoController.gameInfo.helpInfo.toolTipUserNotifiedAboutNewPowerAirSupport && gameInfoController.gameInfo.developmentInfo.airSupportLevel > -1)
				navigator.gameControlPanel.tryCheckForTooltipsForAirSupport();
			
			if (gameInfoController.gameInfo.developmentInfo.bombSupportLevel > -1)
				gameInfoController.gameInfo.helpInfo.toolTipUserNotifiedAboutNewPowerBombSupport = true;
			
			if (gameInfoController.gameInfo.developmentInfo.airSupportLevel > -1)
				gameInfoController.gameInfo.helpInfo.toolTipUserNotifiedAboutNewPowerAirSupport = true;
		}
		
		private function startGame():void
		{
			if (globalTimeIsPaused())
				DeltaTime.globalDeltaTimeCounter.start();
			
			itemController.allowUserInteraction();
			
			navigator.gameControlPanel.notifyGameStarted();
			
			if (mapController.trajectories.length > 0)
			{
				_gameIsRunning = true;
				waveController.addEventListener(WaveEvent.DEPLOY_ENEMY, waveController_deployEnemyHandler);
				waveController.addEventListener(WaveEvent.WAVE_STARTED, waveController_waveStartedHandler);
				waveController.addEventListener(WaveEvent.WAVE_COMPLETED, waveController_waveCompletedHandler);
				waveController.addEventListener(WaveEvent.LEVEL_COMPLETED, waveController_levelCompletedHandler);
				
				createNextWave(false);
				
				SoundController.instance.playSound(SoundResources.SOUND_NEW_WAVE_STARTED, 0.5);
			}
			
			progressBarController.removeAllProgressBars();
			
			updateParameters(true);
			
			AchievementsController.notifyNewLevelStarted(currentLevel);
			
			SoundController.instance.playMusicTrack(SoundResources.MUSIC_IN_BATTLE);
		}
		
		private function createNextWave(showIndicator:Boolean = true):void
		{
			waveController.createNextWave();
			
			var needShowGuideToolTip:Boolean = (currentLevel == 0 && waveController.getCurrentWaveCount() == 0);
			
			// placing progress bars for the next wave
			if (showIndicator)
				progressBarController.showProgressBars(needShowGuideToolTip);
		}
		
		private function stopGame():void
		{
			itemController.forbidUserInteraction();
			
			GameTracker.api.endLevel(); // gameInfoController.gameInfo);
			GameTracker.api.writeCurrentGameStatus(gameInfoController.gameInfo);
			
			_gameIsRunning = false;
			waveController.stopNow();
			waveController.removeEventListener(WaveEvent.DEPLOY_ENEMY, waveController_deployEnemyHandler);
			waveController.removeEventListener(WaveEvent.WAVE_STARTED, waveController_waveStartedHandler);
			waveController.removeEventListener(WaveEvent.WAVE_COMPLETED, waveController_waveCompletedHandler);
			waveController.removeEventListener(WaveEvent.LEVEL_COMPLETED, waveController_levelCompletedHandler);
			
			itemController.notifyGameStopped();
			
			if (GameBot.isPlaying)
			{
				GameBot.stopBotForCurrentLevel();
				GameBot.stopTrackingBotForCurrentLevel();
			}
		
			//if (levelBuilder.isBuilding)
			//	levelBuilder.stopBuilding();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private notifications
		//
		//--------------------------------------------------------------------------
		
		private function notifyLevelCompleted():void
		{
			// just in case we need to prevent accelerated animation anywhere else besides the gamestage
			backToNormalSpeed();
			
			itemController.showBoss(showLevelCompletedNotifications);
		}
		
		private function showLevelCompletedNotifications():void
		{
			backToNormalSpeed();
			
			var numStarsEarned:int = gameInfoController.notifyLevelCompleted(currentLevel, lives, currentLevelMode);
			
			if (!GameBot.supressUI)
			{
				navigator.showVictoryPanel(numStarsEarned, currentLevelMode);
				navigator.gameControlPanel.toInitialState();
				SoundController.instance.playMusicTrack(SoundResources.MUSIC_LEVEL_COMPLETED);
			}
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.LEVEL_COMPLETED));
			
			GameTracker.api.customMsg(TrackingMessages.LEVEL_COMPLETED);
			
			if (currentLevelMode == ModeSettings.MODE_NORMAL)
				AchievementsController.notifyLevelCompleted(currentLevel, lives, GamePlayConstants.INITIAL_NUMBER_OF_LIVES);
			else if (currentLevelMode == ModeSettings.MODE_HARD)
				AchievementsController.notifyLevelCompletedInHardMode(currentLevel);
			else if (currentLevelMode == ModeSettings.MODE_UNREAL)
				AchievementsController.notifyLevelCompletedInUnrealMode(currentLevel);
			
			pendingLevelCompleted = false;
			stopGame();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public notifications
		//
		//--------------------------------------------------------------------------
		
		public function notifyNeedStartGame():void
		{
			startGame();
		}
		
		public function notifyEnemyWeaponBrokeThrough(item:IWeapon):void
		{
			if (gameIsRunning)
				SoundController.instance.playSound(SoundResources.SOUND_ENEMY_BROKE_THROUHG);
			
			AchievementsController.notifyEnemyUnitPassed(item);
			
			if (--lives <= 0)
			{
				lives = 0;
				pendingLevelCompleted = false;
				
				if (gameIsRunning)
					notifyLevelFailed();
				
				updateParameters(false);
				return;
			}
			
			updateParameters(false);
			checkForCompletedLevelAfterRemovingEnemy();
		}
		
		private function notifyLevelFailed():void
		{
			backToNormalSpeed();
			
			if (!GameBot.supressUI)
			{
				navigator.showGameOverPanel();
				SoundController.instance.playMusicTrack(SoundResources.MUSIC_MISSION_FAILED);
			}
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.LEVEL_FAILED));
			
			GameTracker.api.customMsg(TrackingMessages.LEVEL_FAILED);
			
			stopGame();
		}
		
		public function notifyEnemyDestroyed(enemy:IWeapon):void
		{
			var earnedScores:int = scoreController.addScoresForDestroyedEnemy(enemy);
			
			if (earnedScores > 0)
			{
				updateParameters();
				
				BonusTextGenerator.addTextAt(earnedScores, enemy.x, enemy.y, navigator.gameStage);
			}
			
			AchievementsController.notifyEnemyUnitDestroyed(enemy);
			
			checkForCompletedLevelAfterRemovingEnemy();
		}
		
		private function checkForCompletedLevelAfterRemovingEnemy():void
		{
			AnimationEngine.globalAnimator.executeOnNextFrame(checkForCompletedLevelAfterRemovingEnemyOnNextFrame);
		}
		
		private function checkForCompletedLevelAfterRemovingEnemyOnNextFrame():void
		{
			// if there is no enemies left then need to complete the level
			if (pendingLevelCompleted && weaponController.enemies.length == 0 && gameIsRunning)
				notifyLevelCompleted();
		}
		
		public function notifyNeedUpdateParameters(updateWeaponsBar:Boolean = true):void
		{
			updateParameters(updateWeaponsBar);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with teleports
		//
		//--------------------------------------------------------------------------
		
		private function registerTeleports():void
		{
			// transporting teleports
			var teleports:Array = mapController.currentMap.generateTeleports();
			
			for each (var teleport:Teleport in teleports)
			{
				navigator.gameStage.childrenLayer.addChild(teleport);
				weaponController.registerTeleport(teleport);
			}
			
			// enemy enter teleports
			var enterTeleports:Array = mapController.currentMap.getEnemyEnterTeleports();
			
			// just add them to the map
			for each (var enterTeleport:Teleport in enterTeleports)
				navigator.gameStage.childrenLayer.addChild(enterTeleport);
			
			// enemy exit teleports
			var exitTeleports:Array = mapController.currentMap.getEnemyExitTeleports();
			
			// just add them to the map
			for each (var exitTeleport:Teleport in exitTeleports)
				navigator.gameStage.childrenLayer.addChild(exitTeleport);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with bridges
		//
		//--------------------------------------------------------------------------
		
		private function registerBridges():void
		{
			var bridges:Array = mapController.currentMap.generateBridges();
			
			for each (var bridge:Bridge in bridges)
			{
				navigator.gameStage.addBridge(bridge);
				weaponController.registerBridge(bridge);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with traffic light
		//
		//--------------------------------------------------------------------------
		
		private function registerTrafficLights():void
		{
			var trafficLights:Array = mapController.currentMap.generateTrafficLights();
			
			for each (var trafficLight:TrafficLight in trafficLights)
			{
				navigator.gameStage.childrenLayer.addChild(trafficLight);
				mapController.registerTrafficLight(trafficLight);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with waves
		//
		//--------------------------------------------------------------------------
		
		private function waveController_deployEnemyHandler(event:WaveEvent):void
		{
			createEnemy(event.pathIndex);
		}
		
		private function waveController_waveStartedHandler(event:WaveEvent):void
		{
			// need to toggle trajectories before the next wave is deployed
			if (waveController.getCurrentWaveCount() != 0)
				mapController.toggleAllTrafficLights();
			
			var newEnemiesInfos:Array = waveController.getNewEnemyInfosForCurrentWave();
			
			for each (var info:WeaponInfo in newEnemiesInfos)
			{
				if (!info)
					throw new Error("Null retunred for new enemy! Should not happen!");
				
				if (!gameInfoController.gameInfo.helpInfo.newEnemyWasShown(info))
					navigator.gameControlPanel.notifyAboutNewEnemy(info);
			}
			
			// when a new wave starts there might be a tip for a user.
			if (waveController.currentWaveHasTip())
				navigator.gameControlPanel.notifyNeedShowTipIcon(waveController.getTipIndexForCurrentWave());
			
			updateParameters(false);
			
			if (waveController.currentWaveIsLast())
				SoundController.instance.playSound(SoundResources.SOUND_FINAL_WAVE_STARTED, 1, 1000);
			else
				SoundController.instance.playSound(SoundResources.SOUND_WEAPON_ACTIVATION_03, 0.5);
			
			if (StatisticsController.allowStatiscits)
			{
				var param:LogParameters = new LogParameters(LogMessages.WAVE_STARTED);
				param.waveCount = waveController.getCurrentWaveCount();
				param.numPaths = mapController.currentMap.numberOfPaths;
				StatisticsController.logMessage(param);
			}
		}
		
		private function waveController_waveCompletedHandler(event:WaveEvent):void
		{
			createNextWave();
		}
		
		private function waveController_levelCompletedHandler(event:WaveEvent):void
		{
			if (weaponController.enemies.length == 0)
				// if all enemies are killed, we need to complete the level
				notifyLevelCompleted();
			else
				// otherwise need to indicate that all waves are launched
				pendingLevelCompleted = true;
		}
		
		private function createEnemy(pathIndex:int):void
		{
			var enemy:IWeapon = waveController.getNextUnitForPathAt(mapController.currentMap, pathIndex);
			
			itemController.addEnemyToStage(enemy);
		}
		
		////////////////////////////
		
		// for optimization purposes we use one instance of parameters
		
		private var gameControlPanelInfo:GameControlPanelInfo = new GameControlPanelInfo(0, 0, 0, 0);
		
		private function updateParameters(updateWeaponsBar:Boolean = true):void
		{
			// configure gameControlPanelInfo
			gameControlPanelInfo.scores = scoreController.scores;
			gameControlPanelInfo.totalWaves = WaveGenerator.getNumberOfWavesForLevel(currentLevel, currentLevelMode);
			gameControlPanelInfo.currentWave = waveController.getCurrentWaveCount();
			gameControlPanelInfo.lives = lives;
			
			navigator.gameControlPanel.applyPanelInfo(gameControlPanelInfo);
			
			if (updateWeaponsBar)
				navigator.gameControlPanel.applyStoreInfos(weaponStoreController.generateStoreInfos(), gameIsRunning, currentLevelMode);
			
			// update weapon settings panel if necessary
			if (navigator.weaponSettingsPanel.isShown)
				navigator.updateWeaponSettingsPanel(itemController.generateWeaponSettingsPanelInfoForItem(navigator.weaponSettingsPanel.selectedItem));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: game bot
		//
		//--------------------------------------------------------------------------
		
		private function configureBot():void
		{
			GameBot.resetLevel = resetLevel;
			GameBot.startGame = startGame;
			
			GameBot.getCurrentGrid = function():GridArray
			{
				return mapController.currentMap.grid;
			}
			
			GameBot.getCurrentTrajectories = function():Array
			{
				return mapController.trajectories;
			}
			
			GameBot.getCurrentDevelopmentInfo = function():DevelopmentInfo
			{
				return gameInfoController.gameInfo.developmentInfo;
			}
			
			GameBot.accelerateGame = function(factor:int):void
			{
				DeltaTime.globalDeltaTimeCounter.timeMultiplier = factor;
			}
			
			GameBot.getCurrentLevelIndex = function():int
			{
				return currentLevel;
			}
			
			GameBot.setCurrentLevelIndex = function(index:int):void
			{
				_currentLevel = index;
			}
			
			GameBot.setGameInfoForTest = function():void
			{
				gameInfoController.setCurrentSlot(1);
				gameInfoController.applyGameInfo(null);
			}
			
			GameBot.showGameStage = function():void
			{
				navigator.navigateToGameStage();
			}
			
			GameBot.getCurrentGameInfo = function():GameInfo
			{
				return gameInfoController.gameInfo;
			}
			
			GameBot.getNumLivesTotal = function():int
			{
				return WaveGenerator.getNumberOfWavesForLevel(currentLevel, currentLevelMode);
			}
			
			GameBot.getNumLivesLeft = function():int
			{
				return lives;
			}
			
			GameBot.pauseGame = pauseGame;
			
			GameBot.resumeGame = resumeGame;
		}
	}

}