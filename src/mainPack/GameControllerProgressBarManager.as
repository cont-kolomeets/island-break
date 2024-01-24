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
	import constants.WaveConstants;
	import controllers.AchievementsController;
	import controllers.MapController;
	import controllers.ScoreController;
	import controllers.WaveController;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.events.ProgressBarEvent;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.core.Globals;
	import nslib.utils.FontDescriptor;
	import nslib.utils.MouseUtil;
	import supportClasses.ISettingsObserver;
	import supportClasses.resources.FontResources;
	import supportControls.BonusTextGenerator;
	import supportControls.progressBars.RoundProgressBar;
	import supportControls.toolTips.HintToolTip;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameControllerProgressBarManager implements ISettingsObserver
	{
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		public var navigator:PanelNavigator = null;
		
		public var gameController:GameController = null;
		
		public var mapController:MapController = null;
		
		public var waveController:WaveController = null;
		
		public var scoreController:ScoreController = null;
		
		private var progressBars:Array = [];
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function GameControllerProgressBarManager()
		{
			GameSettings.registerObserver(this);
			
			Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			
			configureBot();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: creating a progress bar
		//
		//--------------------------------------------------------------------------
		
		private function createProgressBarForPathAt(pathIndex:int, isInitial:Boolean):RoundProgressBar
		{
			var progressBar:RoundProgressBar = new RoundProgressBar();
			progressBar.x = mapController.currentMap.getWaveIndicatorPointForPathAt(pathIndex).x;
			progressBar.y = mapController.currentMap.getWaveIndicatorPointForPathAt(pathIndex).y;
			progressBar.arrowAngle = mapController.currentMap.getWaveIndicatorRotationForPathAt(pathIndex);
			
			progressBar.pathIndex = pathIndex;
			progressBar.isInitial = isInitial;
			progressBar.applyWaveInfo(waveController.getCurrentWaveInfoForPathAt(pathIndex));
			
			if (isInitial)
				progressBar.addEventListener(MouseEvent.CLICK, initialProgressBar_clickHandler);
			else
			{
				progressBar.addEventListener(MouseEvent.CLICK, progressBar_clickHandler);
				progressBar.addEventListener(ProgressBarEvent.PROGRESS_COMPLETE, progressBar_progressCompletedHandler);
			}
			
			if (isInitial)
				progressBar.start(WaveConstants.INITIAL_DELAY_FOR_PROGRESS_BAR);
			else
				progressBar.start(waveController.getCurrentBeforeWaveDelay());
			
			AnimationEngine.globalAnimator.animateConstantBubbling([progressBar], 300, 0, 0.3);
			
			return progressBar;
		}
		
		public function notifySettingsChanged(propertyName:String):void
		{
			if (propertyName == "enableTooltips")
				for each (var progressBar:RoundProgressBar in progressBars)
					if (GameSettings.enableTooltips)
						progressBar.applyWaveInfo(waveController.getCurrentWaveInfoForPathAt(progressBar.pathIndex));
					else
						progressBar.removeWaveTooltip();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: working with initial progress bars
		//
		//--------------------------------------------------------------------------
		
		// creates progress bars pointing to the entries
		// by clicking on them a user can start the game
		public function showInitialProgressBars():void
		{
			removeAllProgressBars();
			
			for (var i:int = 0; i < mapController.currentMap.numberOfPaths; i++)
			{
				var progressBar:RoundProgressBar = createProgressBarForPathAt(i, true);
				navigator.gameStage.menuLayer.addChild(progressBar);
				progressBars.push(progressBar);
			}
		}
		
		private function initialProgressBar_clickHandler(event:MouseEvent):void
		{
			removeAllProgressBars();
			gameController.notifyNeedStartGame();
			
			AchievementsController.notifyWaveStartedWithoutCallingEarly();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: working with in game progress bars
		//
		//--------------------------------------------------------------------------
		
		private var dummyGuideContainer:NSSprite = null;
		
		public function showProgressBars(showGuideToolTip:Boolean = false):void
		{
			removeAllProgressBars();
			
			for (var i:int = 0; i < mapController.currentMap.numberOfPaths; i++)
			{
				var progressBar:RoundProgressBar = createProgressBarForPathAt(i, false);
				
				if (showGuideToolTip && i == 0)
				{
					if (!dummyGuideContainer)
						dummyGuideContainer = new NSSprite();
					
					dummyGuideContainer.x = progressBar.x;
					dummyGuideContainer.y = progressBar.y + progressBar.height / 2;
					navigator.gameStage.menuLayer.addChild(dummyGuideContainer);
					
					progressBar.addEventListener(MouseEvent.CLICK, guideProgressBarClickHandler);
					// since a progress bar has its own wave tooltip we need to create a dummy container right behind the progress bar
					var tooltip:* = ToolTipService.setTooltipWaitingForClick(dummyGuideContainer, new ToolTipInfo(dummyGuideContainer, new ToolTipSimpleContentDescriptor("NEXT WAVE INCOMING!", ["Click to call early!"], null, new FontDescriptor(14, 0x2722FF, FontResources.KOMTXTB)), ToolTipInfo.POSITION_BOTTOM), HintToolTip, navigator.gameStage.menuLayer);
					AnimationEngine.globalAnimator.animateConstantWaving([tooltip], 300, AnimationEngine.globalAnimator.currentTime, 0.02);
				}
				
				navigator.gameStage.menuLayer.addChild(progressBar);
				progressBars.push(progressBar);
			}
		}
		
		private function guideProgressBarClickHandler(event:MouseEvent):void
		{
			clearDummyContainer();
		}
		
		private function progressBar_clickHandler(event:MouseEvent):void
		{
			tryCallWaveEarlier();
		}
		
		private function tryCallWaveEarlier(keyboardUsed:Boolean = false):void
		{
			var progressBar:RoundProgressBar = progressBars[0] as RoundProgressBar;
			
			if (!progressBar || progressBar.progress == 0)
				return;
			
			if (progressBar.isInitial)
			{
				removeAllProgressBars();
				gameController.notifyNeedStartGame();
				return;
			}
			
			var earnedScores:int = scoreController.addScoresForImpatience(progressBar.progress);
			
			if (earnedScores > 0)
			{
				var point:Point = null;
				
				if (keyboardUsed)
					point = new Point(progressBar.x, progressBar.y);
				else
					point = new Point(MouseUtil.getCursorCoordinates().x, MouseUtil.getCursorCoordinates().y);
				
				BonusTextGenerator.addTextAt(earnedScores, point.x, point.y, navigator.gameStage);
			}
			
			waveController.startWaveImmediately();
			gameController.notifyNeedUpdateParameters();
			
			// check for last wave		
			if (waveController.currentWaveIsLast())
				navigator.gameStage.showFinalWaveNotification();
			
			// after one progress bar has been clicked, we need to remove the rest of them
			removeAllProgressBars();
			
			AchievementsController.notifyWaveCalledEarly();
		}
		
		// calling early using keyboard
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE && navigator.getCurrentStep() && navigator.getCurrentStep().name == NavigateConfig.STEP_SHOW_GAME_STAGE && !gameController.globalTimeIsPaused())
			{
				if (progressBars[0] is RoundProgressBar && RoundProgressBar(progressBars[0]).isInitial)
				{
					removeAllProgressBars();
					gameController.notifyNeedStartGame();
				}
				else
					tryCallWaveEarlier(true);
			}
		}
		
		private function progressBar_progressCompletedHandler(event:ProgressBarEvent):void
		{
			// check for last wave		
			if (waveController.currentWaveIsLast())
				navigator.gameStage.showFinalWaveNotification();
			
			// after one progress bar has finished, we need to remove the rest of them
			removeAllProgressBars();
			
			AchievementsController.notifyWaveStartedWithoutCallingEarly();
		}
		
		public function removeAllProgressBars():void
		{
			for each (var progressBar:RoundProgressBar in progressBars)
			{
				progressBar.reset();
				//stop bubbling of the progress bar
				AnimationEngine.globalAnimator.stopAnimationForObject(progressBar);
				progressBar.removeEventListener(MouseEvent.CLICK, initialProgressBar_clickHandler);
				progressBar.removeEventListener(MouseEvent.CLICK, progressBar_clickHandler);
				progressBar.removeEventListener(ProgressBarEvent.PROGRESS_COMPLETE, progressBar_progressCompletedHandler);
				
				if (navigator.gameStage.menuLayer.contains(progressBar))
					navigator.gameStage.menuLayer.removeChild(progressBar);
				
				// stop and remove all possible guide tooltips
				if (dummyGuideContainer)
					clearDummyContainer();
			}
			
			progressBars.length = 0;
		}
		
		private function clearDummyContainer():void
		{
			dummyGuideContainer.removeEventListener(MouseEvent.CLICK, guideProgressBarClickHandler);
			
			var tooltip:* = ToolTipService.getToolTipAssignedForComponent(dummyGuideContainer);
			ToolTipService.removeAllTooltipsForComponent(dummyGuideContainer);
			
			if (tooltip)
				AnimationEngine.globalAnimator.stopAnimationForObject(tooltip);
			
			if (navigator.gameStage.menuLayer.contains(dummyGuideContainer))
				navigator.gameStage.menuLayer.removeChild(dummyGuideContainer);
		}
		
		private var intercationOffset:Number = 20;
		
		public function mouseIsOverProgressBar():Boolean
		{
			if (progressBars.length == 0)
				return false;
			
			for (var i:int = 0; i < mapController.currentMap.numberOfPaths; i++)
			{
				var x:Number = mapController.currentMap.getWaveIndicatorPointForPathAt(i).x;
				var y:Number = mapController.currentMap.getWaveIndicatorPointForPathAt(i).y;
				
				if (Math.abs(MouseUtil.getCursorCoordinates().x - x) <= intercationOffset && Math.abs(MouseUtil.getCursorCoordinates().y - y) <= intercationOffset)
					return true;
			}
			
			return false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: game bot
		//
		//--------------------------------------------------------------------------
		
		private function configureBot():void
		{
			GameBot.startWaveEarly = function():void
			{
				if (progressBars[0] is RoundProgressBar && RoundProgressBar(progressBars[0]).isInitial)
				{
					removeAllProgressBars();
					gameController.notifyNeedStartGame();
				}
				else
					tryCallWaveEarlier(true);
			}
		}
	
	}

}