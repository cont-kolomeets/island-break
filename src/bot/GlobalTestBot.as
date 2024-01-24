/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package bot
{
	import bot.events.StatEvent;
	import bot.ui.BotGlobalTestControlPanel;
	import controllers.StatisticsController;
	import flash.events.Event;
	import infoObjects.gameInfo.GameInfo;
	import nslib.controls.events.ButtonEvent;
	import nslib.core.Globals;
	import panels.settings.LabeledSliderContainer;
	import panels.statistics.StatInfo;
	import panels.statistics.StatisticsPanel;
	import supportControls.CheckBox;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class GlobalTestBot
	{
		private static var globalControlPanel:BotGlobalTestControlPanel = new BotGlobalTestControlPanel();
		
		private static var statisticsPanel:StatisticsPanel = new StatisticsPanel();
		
		/////////////////////
		
		public static function openGlobalTextMenu():void
		{
			Globals.stage.addChild(globalControlPanel);
			
			globalControlPanel.speedSlider.labelFunction = function(value:Number):String
			{
				return "" + int(1 + value * SingleLevelBot.MAX_SPEED_MODE_ACCELERATION);
			}
			
			//SingleLevelBot.speedModeAcceleration = 1;
			globalControlPanel.speedSlider.sliderValue = 0; // DeltaTime.globalDeltaTimeCounter.timeMultiplier;// SingleLevelBot.INITIAL_SPEED_MODE_ACCELERATION / SingleLevelBot.MAX_SPEED_MODE_ACCELERATION;
			
			globalControlPanel.useSuperSpeedButton.selected = false;
			globalControlPanel.useSuperSpeedButton.addEventListener(CheckBox.STATE_CHANGED, useSuperSpeedButton_stateChangedHandler);
			
			globalControlPanel.startButton.addEventListener(ButtonEvent.BUTTON_CLICK, startHandler);
			globalControlPanel.stopButton.addEventListener(ButtonEvent.BUTTON_CLICK, stopHandler);
			globalControlPanel.closeButton.addEventListener(ButtonEvent.BUTTON_CLICK, closeHandler);
			globalControlPanel.addEventListener(StatEvent.SHOW_STAT, showStatHandler);
			globalControlPanel.speedSlider.addEventListener(LabeledSliderContainer.PARAMETERS_CHANGED, speedChangedHandler);
		}
		
		private static function useSuperSpeedButton_stateChangedHandler(event:Event):void
		{
			if (globalControlPanel.useSuperSpeedButton.selected)
				GameBot.accelerateGame(SingleLevelBot.SUPER_SPEED_MODE_ACCELERATION);
			else
				globalControlPanel.speedSlider.sliderValue = globalControlPanel.speedSlider.sliderValue;
		}
		
		private static function closeHandler(event:ButtonEvent):void
		{
			if (Globals.stage.contains(globalControlPanel))
				Globals.stage.removeChild(globalControlPanel);
			
			globalControlPanel.closeButton.removeEventListener(ButtonEvent.BUTTON_CLICK, closeHandler);
		}
		
		private static function updateSlider():void
		{
		
		}
		
		////////////////
		
		private static var levelStatInfos:Object = {};
		
		private static var levelIndices:Array = null;
		
		private static var isStopRequested:Boolean = false;
		
		private static function startHandler(event:ButtonEvent):void
		{
			levelStatInfos.length = 0;
			isStopRequested = false;
			
			globalControlPanel.reset();
			levelIndices = globalControlPanel.getSelectedLevels();
			
			GameBot.setGameInfoForTest();
			addMissinStars();
			
			GameBot.showGameStage();
			GameBot.supressUI = true;
			
			testNextLevel();
		}
		
		private static function addMissinStars():void
		{
			if (levelIndices.length == 0)
				return;
			
			var firstIndex:int = levelIndices[0];
			
			var gameInfo:GameInfo = GameBot.getCurrentGameInfo();
			gameInfo.totalStarsEarned = firstIndex * 3;
		}
		
		private static function testNextLevel():void
		{
			if (isStopRequested || levelIndices.length == 0)
			{
				globalControlPanel.useSuperSpeedButton.selected = false;
				globalControlPanel.speedSlider.sliderValue = 0;
				GameBot.supressUI = false;
				return;
			}
			
			DevelopmentCenterUpgrader.updateCurrentDevInfo();
			
			var index:int = levelIndices.shift();
			
			GameBot.setCurrentLevelIndex(index);
			SingleLevelBot.startBotForCurrentLevel(false, onStopFunction);
		}
		
		private static function onStopFunction():void
		{
			var statInfo:StatInfo = StatisticsController.getStatInfoForLatestLevel();
			levelStatInfos[statInfo.levelIndex] = statInfo;
			globalControlPanel.applyStatInfo(statInfo);
			
			if (statInfo.levelPassedSuccessfully)
				testNextLevel();
		}
		
		private static function showStatHandler(event:StatEvent):void
		{
			statisticsPanel.show();
			
			if (event.levelIndex != -1)
				statisticsPanel.applyStatInfo(levelStatInfos[event.levelIndex]);
			
			Globals.stage.addChild(statisticsPanel);
			
			statisticsPanel.addEventListener(StatisticsPanel.CLOSE_CLICKED, statisticsPanel_closeHandler);
		}
		
		private static function statisticsPanel_closeHandler(event:Event):void
		{
			statisticsPanel.removeEventListener(StatisticsPanel.CLOSE_CLICKED, statisticsPanel_closeHandler);
			
			if (Globals.stage.contains(statisticsPanel))
				Globals.stage.removeChild(statisticsPanel);
		}
		
		private static function stopHandler(event:ButtonEvent):void
		{
			isStopRequested = true;
		}
		
		private static function speedChangedHandler(event:Event):void
		{
			var newValue:int = 1 + int(globalControlPanel.speedSlider.sliderValue * SingleLevelBot.MAX_SPEED_MODE_ACCELERATION);
			//SingleLevelBot.speedModeAcceleration = newValue;
			GameBot.accelerateGame(newValue);
		}
	}

}