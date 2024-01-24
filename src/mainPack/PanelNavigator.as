/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package mainPack
{
	import config.NavigateConfig;
	import controllers.StatisticsController;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import infoObjects.gameInfo.AchievementInfo;
	import infoObjects.panelInfos.VictoryPanelInfo;
	import infoObjects.panelInfos.WeaponSettingsPanelInfo;
	import nslib.controls.NSSprite;
	import nslib.core.Globals;
	import panels.achievementsCenter.AchievementPopUpPanel;
	import panels.achievementsCenter.AchievementsCenterPanel;
	import panels.devCenter.DevelopmentCenterPanel;
	import panels.encyclopedia.EncyclopediaPanel;
	import panels.gameFinished.GameFinishedScreen;
	import panels.inGame.GameControlPanel;
	import panels.inGame.GameOverPanel;
	import panels.inGame.GameStage;
	import panels.inGame.VictoryPanel;
	import panels.inGame.WeaponSettingsPanel;
	import panels.PanelBase;
	import panels.starting.CreditsPanel;
	import panels.starting.IntroPanel;
	import panels.starting.LevelInfoPanel;
	import panels.starting.LevelsMapPanel;
	import panels.starting.SlotsPanel;
	import panels.statistics.StatisticsPanel;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PanelNavigator extends NSSprite
	{
		// Has the face image, a title, and a "Start Button"
		public var introPanel:IntroPanel = new IntroPanel();
		
		// Has a frame with 3 slots to save your game.
		// Blocks the background.
		public var slotsPanel:SlotsPanel = new SlotsPanel();
		
		public var creditsPanel:CreditsPanel = new CreditsPanel();
		
		// Has button back, 3 buttons for dev center, encyclopedia, achievements.
		//Also has button for levels.
		public var levelsMapPanel:LevelsMapPanel = new LevelsMapPanel();
		
		public var levelInfoPanel:LevelInfoPanel = new LevelInfoPanel();
		
		public var devCenterPanel:DevelopmentCenterPanel = new DevelopmentCenterPanel();
		
		public var achievementsPanel:AchievementsCenterPanel = new AchievementsCenterPanel();
		
		public var encyclopediaPanel:EncyclopediaPanel = new EncyclopediaPanel();
		
		// will hold weapon units and progress bars
		public var gameStage:GameStage = new GameStage();
		
		// these panels will be shown by calling corresponding methods directly
		
		public var weaponSettingsPanel:WeaponSettingsPanel;
		
		public var victoryPanel:VictoryPanel = new VictoryPanel();
		
		public var gameOverPanel:GameOverPanel = new GameOverPanel();
		
		// panel to notify about new achievements
		private var achievementPopUpPanel:AchievementPopUpPanel = new AchievementPopUpPanel();
		
		//////////////////////////////////////
		
		private var panelsHash:Object = {};
		
		private var stepsHash:Object = {};
		
		/////////////////////////
		
		public function PanelNavigator()
		{
			// building links
			weaponSettingsPanel = new WeaponSettingsPanel(gameStage);
			
			registerPanels();
			parseConfig();
		}
		
		/////////////////////////////////////
		
		public function get gameControlPanel():GameControlPanel
		{
			return gameStage.gameControlPanel;
		}
		
		//////////////////////////////////////
		
		private function registerPanels():void
		{
			registerPanel(introPanel, "introPanel");
			registerPanel(slotsPanel, "slotsPanel");
			registerPanel(creditsPanel, "creditsPanel");
			registerPanel(levelsMapPanel, "levelsMapPanel");
			registerPanel(levelInfoPanel, "levelInfoPanel");
			registerPanel(gameStage, "gameStage");
			registerPanel(weaponSettingsPanel, "weaponSettingsPanel");
			registerPanel(victoryPanel, "victoryPanel");
			registerPanel(gameOverPanel, "gameOverPanel");
			registerPanel(devCenterPanel, "devCenterPanel");
			registerPanel(achievementsPanel, "achievementsPanel");
			registerPanel(encyclopediaPanel, "encyclopediaPanel");
		}
		
		private function registerPanel(panel:PanelBase, panelID:String):void
		{
			panel.panelID = panelID;
			panelsHash[panelID] = panel;
		}
		
		private function parseConfig():void
		{
			var steps:XMLList = NavigateConfig.navigationConfig.step;
			
			for each (var step:XML in steps)
			{
				var stepInfo:StepInfo = new StepInfo();
				stepInfo.id = String(step.@id);
				stepInfo.name = String(step.@name);
				
				if (step.actions != undefined)
				{
					var actions:XMLList = step.actions.action;
					
					if (actions)
						for each (var action:XML in actions)
						{
							var actionInfo:ActionInfo = new ActionInfo();
							actionInfo.panelID = action.@panelID;
							actionInfo.effect = action.@effect;
							if (action.@addHandlers != undefined)
								actionInfo.addHandlers = String(action.@addHandlers).split(";");
							
							if (!stepInfo.actions)
								stepInfo.actions = [];
							
							stepInfo.actions.push(actionInfo);
						}
				}
				
				if (step.events != undefined)
				{
					var events:XMLList = step.events.event;
					
					if (events)
						for each (var event:XML in events)
						{
							var eventInfo:EventInfo = new EventInfo();
							eventInfo.type = event.@type;
							eventInfo.toStep = event.@toStep;
							
							if (!stepInfo.events)
								stepInfo.events = [];
							
							stepInfo.events.push(eventInfo);
						}
				}
				
				stepsHash[stepInfo.name] = stepInfo;
			}
		}
		
		private var currentStep:StepInfo = null;
		
		public function getCurrentStep():StepInfo
		{
			return currentStep;
		}
		
		public function startInitialStep():void
		{
			navigateToStepByName("initial");
		}
		
		private function navigateToStepByName(stepName:String):void
		{
			var stepInfo:StepInfo = stepsHash[stepName];
			if (stepInfo)
				navigateToStep(stepInfo);
		}
		
		private function navigateToStep(stepInfo:StepInfo):void
		{
			currentStep = stepInfo;
			
			// collecting panelIDs of panel to be shown
			// so we do not hide them in vain
			var panelsToShowHash:Object = {};
			var action:ActionInfo = null;
			
			if (stepInfo.actions)
				for each (action in stepInfo.actions)
					if (action.effect == "show")
						panelsToShowHash[action.panelID] = action.panelID;
			
			// collection panels to remove
			var panelsToRemove:Array = [];
			var panel:PanelBase = null;
			
			for (var i:int = 0; i < numChildren; i++)
			{
				panel = getChildAt(i) as PanelBase;
				if (panel)
				{
					// we need to remove listeners anyway
					panel.removeAllNavigationListeners();
					
					if (panelsToShowHash[panel.panelID] == undefined)
						panelsToRemove.push(panel);
				}
				
			}
			
			// removing panels
			for each (panel in panelsToRemove)
			{
				panel.removeAllNavigationListeners();
				panel.hide();
				removeChild(panel);
			}
			
			if (stepInfo.actions)
				for each (action in stepInfo.actions)
				{
					panel = panelsHash[action.panelID];
					
					if (action.effect == "show")
					{
						// do not need to add and show a panel if it's already displayed.
						if (!contains(panel))
						{
							addChild(panel);
							panel.show();
						}
						
						if (action.addHandlers)
							for each (var handlerType:String in action.addHandlers)
								panel.addEventListener(handlerType, universalHandler);
					}
				}
		}
		
		private function universalHandler(event:Event):void
		{
			if (currentStep.events)
				for each (var eventInfo:EventInfo in currentStep.events)
					if (event.type == eventInfo.type)
						navigateToStepByName(eventInfo.toStep);
		}
		
		//////////////////////////////
		
		private var menuWaitTimer:Timer = new Timer(100, 1);
		
		public function updateWeaponSettingsPanel(panelInfo:*):void
		{
			// update only currently shown settings panel
			if (!weaponSettingsPanel.isShown)
				return;
			
			weaponSettingsPanel.applyPanelInfo(panelInfo);
		}
		
		public function showWeaponSettingsPanel(panelInfo:*):void
		{
			// need to clear the previous state first
			if (weaponSettingsPanel.isShown)
				hideWeaponSettingsPanel();
			
			weaponSettingsPanel.applyPanelInfo(panelInfo);
			
			// prevent from showing a panel too left
			weaponSettingsPanel.x = Math.max(weaponSettingsPanel.calcRequiredLeftPaddingForInfo(WeaponSettingsPanelInfo(panelInfo)), WeaponSettingsPanelInfo(panelInfo).x);
			weaponSettingsPanel.y = WeaponSettingsPanelInfo(panelInfo).y - 10;
			
			addChild(weaponSettingsPanel);
			weaponSettingsPanel.show();
			
			// need to wait for a while not to hide the menu immediately
			menuWaitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, menuWaitTimer_timerCompletedHandler);
			
			menuWaitTimer.reset();
			menuWaitTimer.start();
		}
		
		private function menuWaitTimer_timerCompletedHandler(event:TimerEvent):void
		{
			menuWaitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, menuWaitTimer_timerCompletedHandler);
			
			// adding handlers to remove the menu on user's click
			gameStage.addEventListener(MouseEvent.CLICK, hideWeaponSettingsPanel);
			weaponSettingsPanel.addEventListener(MouseEvent.CLICK, hideWeaponSettingsPanel);
		}
		
		public function hideWeaponSettingsPanel(event:Event = null):void
		{
			menuWaitTimer.reset();
			
			gameStage.removeEventListener(MouseEvent.CLICK, hideWeaponSettingsPanel);
			weaponSettingsPanel.removeEventListener(MouseEvent.CLICK, hideWeaponSettingsPanel);
			
			if (!weaponSettingsPanel.isShown)
				return;
			
			weaponSettingsPanel.hide();
			
			if (contains(weaponSettingsPanel))
				removeChild(weaponSettingsPanel);
		}
		
		public function notifyLevelWasReset():void
		{
			hideWeaponSettingsPanel();
		}
		
		////////////////////////////////////////////
		
		public function showVictoryPanel(numberOfStars:int, levelMode:String):void
		{
			// since we are here, a user has completed a level
			if (levelsMapPanel.selectedLevelIsLastPassed())
				levelsMapPanel.notifyNeedShowNewLevelAnimation();
			
			if (levelsMapPanel.needShowFirstUpdatesAvailableToolTip())
				levelsMapPanel.notifyNeedShowFirstUpdatesAvailableToolTip();
			
			// need to holds achievemnts notification
			achievementPopUpPanel.notifyHoldPopUps();
			
			showVictoryPanelAfterDelay(numberOfStars, levelMode);
		}
		
		private function showVictoryPanelAfterDelay(numberOfStars:int, levelMode:String):void
		{
			// hide settings panel if some was shown
			hideWeaponSettingsPanel();
			
			addChild(victoryPanel);
			
			victoryPanel.addEventListener(VictoryPanel.CONTINUE_CLICKED, victoryPanel_continueClickedHandler);
			victoryPanel.addEventListener(VictoryPanel.RESTART_CLICKED, removeVictoryPanel);
			
			victoryPanel.show();
			victoryPanel.applyPanelInfo(new VictoryPanelInfo(numberOfStars, levelMode));
		}
		
		private function victoryPanel_continueClickedHandler(event:Event):void
		{
			navigateToLevelsMapPanel();
			removeVictoryPanel();
		}
		
		private function removeVictoryPanel(event:Event = null):void
		{
			victoryPanel.removeEventListener(VictoryPanel.CONTINUE_CLICKED, victoryPanel_continueClickedHandler);
			victoryPanel.removeEventListener(VictoryPanel.RESTART_CLICKED, removeVictoryPanel);
			
			if (victoryPanel.isShown)
				victoryPanel.hide();
			
			if (contains(victoryPanel))
				removeChild(victoryPanel);
			
			// need to release achievemnts notification
			achievementPopUpPanel.notifyReleasePopUps();
		}
		
		///////////////////////////
		
		public function showGameOverPanel():void
		{
			// need to holds achievemnts notification
			achievementPopUpPanel.notifyHoldPopUps();
			
			//AnimationEngine.globalAnimator.executeFunction(showGameOverPanelAfterDelay, null, AnimationEngine.globalAnimator.currentTime + 300);
			showGameOverPanelAfterDelay();
		}
		
		private function showGameOverPanelAfterDelay():void
		{
			// hide settings panel if some was shown
			hideWeaponSettingsPanel();
			
			addChild(gameOverPanel);
			
			gameOverPanel.addEventListener(GameOverPanel.RESTART_CLICKED, removeGameOverPanel);
			gameOverPanel.addEventListener(GameOverPanel.TO_MENU_CLICKED, gameOverPanel_toMenuClickedHandler);
			
			gameOverPanel.show();
		}
		
		private function gameOverPanel_toMenuClickedHandler(event:Event):void
		{
			removeGameOverPanel();
			navigateToLevelsMapPanel();
		}
		
		private function removeGameOverPanel(event:Event = null):void
		{
			gameOverPanel.removeEventListener(GameOverPanel.RESTART_CLICKED, removeGameOverPanel);
			gameOverPanel.removeEventListener(GameOverPanel.TO_MENU_CLICKED, gameOverPanel_toMenuClickedHandler);
			
			if (gameOverPanel.isShown)
				gameOverPanel.hide();
			
			if (contains(gameOverPanel))
				removeChild(gameOverPanel);
			
			// need to release achievemnts notification
			achievementPopUpPanel.notifyReleasePopUps();
		}
		
		////////////////////////////
		
		public function navigateToLevelsMapPanel(showGameSavedNotification:Boolean = true):void
		{
			navigateToStepByName(NavigateConfig.STEP_SHOW_LEVELS_MAP_PANEL);
			
			if (showGameSavedNotification)
				tryShowGameSavedNotification();
		}
		
		////////////////////////////
		
		public function showAchievementPanel(info:AchievementInfo):void
		{
			startWorkingWithAchievementsPanel();
			achievementPopUpPanel.showPanelForInfo(info);
		}
		
		private function tryShowGameSavedNotification():void
		{
			startWorkingWithAchievementsPanel();
			achievementPopUpPanel.showGameSavedNotification();
		}
		
		private function startWorkingWithAchievementsPanel():void
		{
			achievementPopUpPanel.addEventListener(AchievementPopUpPanel.NOTIFICATION_STARTED, achievementPopUpPanel_notificationStartedHandler);
			achievementPopUpPanel.addEventListener(AchievementPopUpPanel.NOTIFICATION_COMPLETED, achievementPopUpPanel_notificationCompletedHandler);
		}
		
		private function achievementPopUpPanel_notificationStartedHandler(event:Event):void
		{
			// adding this notification panel on top
			addChild(achievementPopUpPanel);
		}
		
		private function achievementPopUpPanel_notificationCompletedHandler(event:Event):void
		{
			removeAchievementPopUpPanel();
		}
		
		private function removeAchievementPopUpPanel():void
		{
			achievementPopUpPanel.removeEventListener(AchievementPopUpPanel.NOTIFICATION_STARTED, achievementPopUpPanel_notificationStartedHandler);
			achievementPopUpPanel.removeEventListener(AchievementPopUpPanel.NOTIFICATION_COMPLETED, achievementPopUpPanel_notificationCompletedHandler);
			
			if (contains(achievementPopUpPanel))
				removeChild(achievementPopUpPanel);
		}
		
		////////////////////////////
		
		public function showEncyclopediaInGame():void
		{
			addChild(encyclopediaPanel);
			encyclopediaPanel.show();
			encyclopediaPanel.addEventListener(EncyclopediaPanel.BACK_CLICKED, encyclopediaPanel_backClickedHandler);
		}
		
		private function encyclopediaPanel_backClickedHandler(event:Event):void
		{
			encyclopediaPanel.removeEventListener(EncyclopediaPanel.BACK_CLICKED, encyclopediaPanel_backClickedHandler);
			encyclopediaPanel.hide();
			removeChild(encyclopediaPanel);
		}
		
		///////////////////////////
		
		private var statisticsPanel:StatisticsPanel = null;
		
		public function showStatistics():void
		{
			if (!StatisticsController.allowStatiscits)
				throw new Error("Attempt to show a statistics panel while statistics for the game is not allowed!");
			
			if (!statisticsPanel)
				statisticsPanel = new StatisticsPanel();
			
			statisticsPanel.addEventListener(StatisticsPanel.CLOSE_CLICKED, statisticsPanel_closeClickedHandler);
			Globals.topLevelApplication.addChild(statisticsPanel);
			statisticsPanel.show();
		}
		
		private function statisticsPanel_closeClickedHandler(event:Event):void
		{
			statisticsPanel.removeEventListener(StatisticsPanel.CLOSE_CLICKED, statisticsPanel_closeClickedHandler);
			statisticsPanel.hide();
			Globals.topLevelApplication.removeChild(statisticsPanel);
		}
		
		/////////// for developing purposes
		
		public function navigateToGameStage():void
		{
			navigateToStepByName(NavigateConfig.STEP_SHOW_GAME_STAGE);
		}
		
		//////////
		
		private var gameFinishedScreen:GameFinishedScreen = null;
		
		public function showGameFinishedCongratulationsScreen():void
		{
			if (!gameFinishedScreen)
				gameFinishedScreen = new GameFinishedScreen();
			
			gameFinishedScreen.congratulateUser();
		}
	}

}

class StepInfo
{
	public var id:String = null;
	
	public var name:String = null;
	
	public var events:Array = null;
	
	public var actions:Array = null;
}

class ActionInfo
{
	public var panelID:String = null;
	
	public var effect:String = null;
	
	public var addHandlers:Array = null;
}

class EventInfo
{
	public var type:String = null;
	
	public var toStep:String = null;
}