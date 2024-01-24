/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import constants.GamePlayConstants;
	import events.SelectEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import infoObjects.gameInfo.LevelInfo;
	import infoObjects.panelInfos.LevelsMapPanelInfo;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.CustomTextField;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.geometry.Graph;
	import nslib.utils.FontDescriptor;
	import panels.PanelBase;
	import panels.starting.SoundControlPanel;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * Has button back, 3 buttons for dev center, encyclopedia, achievements.
	 * Also has button for levels.
	 * Takes as info: LevelsMapPanelInfo.
	 */
	public class LevelsMapPanel extends PanelBase
	{
		// Naviagation events
		public static const BACK_SELECTED:String = "backSelected";
		
		public static const ENCYCLOPEDIA_SELECTED:String = "encyclopediaSelected";
		
		public static const DEV_CENTER_SELECTED:String = "devCenterSelected";
		
		public static const ACHIEVEMENTS_SELECTED:String = "achievementsSelected";
		
		/////////////////////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/map/map.jpg")]
		private static var mapImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/stars plate.png")]
		private static var starsPlateImage:Class;
		
		////////////////////////////////
		
		private const FLAG_TOOLTIP_FUNCTION_ID:String = "flagStickingFunction";
		
		public var selectedLevel:LevelInfo = null;
		
		private var starsPlateContainer:NSSprite = new NSSprite();
		
		private var levelsMapPanelToolBar:LevelsMapPanelToolBar = new LevelsMapPanelToolBar();
		
		private var soundController:SoundControlPanel = new SoundControlPanel();
		
		private var numberOfStarsLabel:CustomTextField;
		
		private var curve:Graph = new Graph();
		
		private var flagsLayer:NSSprite = new NSSprite();
		
		/// flags
		
		private var needShowNewLevelAnimationFlag:Boolean = false;
		
		private var needShowFirstUpdatesAvailableToolTipFlag:Boolean = false;
		
		////////////////////////////////
		
		public function LevelsMapPanel()
		{
			super();
			
			constructPanel();
		}
		
		////////////////////////////////
		
		private function constructPanel():void
		{
			var background:Bitmap = new mapImage() as Bitmap;
			addChild(background);
			
			addChild(curve);
			addChild(flagsLayer);
			
			// adding stars plate
			var starsPlate:Bitmap = new starsPlateImage() as Bitmap;
			starsPlateContainer.addChild(starsPlate);
			
			numberOfStarsLabel = new CustomTextField(" ", new FontDescriptor(20, 0xFFFFFF, FontResources.YARDSALE));
			numberOfStarsLabel.x = 20;
			numberOfStarsLabel.y = 15;
			starsPlateContainer.addChild(numberOfStarsLabel);
			
			starsPlateContainer.x = 505;
			starsPlateContainer.y = 23;
			
			addChild(starsPlateContainer);
			
			/////////
			
			soundController.x = 70;
			soundController.y = 6;
			
			addChild(soundController);
			
			levelsMapPanelToolBar.x = 0;
			levelsMapPanelToolBar.y = 410;
			addChild(levelsMapPanelToolBar);
		}
		
		private function updateNumberOfStarsLabel(stars:int):void
		{
			numberOfStarsLabel.text = "" + stars + "/" + GamePlayConstants.NUMBER_OF_LEVELS * 3;
		}
		
		override public function show():void
		{
			super.show();
			
			soundController.update();
			
			showStarsLabelAnimation();
			levelsMapPanelToolBar.showTooltips();
			levelsMapPanelToolBar.startAnimation();
			
			levelsMapPanelToolBar.devCenterButton.addEventListener(ButtonEvent.BUTTON_CLICK, devCenterButton_clickHandler);
			levelsMapPanelToolBar.upgradeAvailableButton.addEventListener(MouseEvent.CLICK, devCenterButton_clickHandler);
			levelsMapPanelToolBar.encyclopediaButton.addEventListener(ButtonEvent.BUTTON_CLICK, encyclopediaButton_clickHandler);
			levelsMapPanelToolBar.achievementsButton.addEventListener(ButtonEvent.BUTTON_CLICK, achievementsButton_clickHandler);
			levelsMapPanelToolBar.backButton.addEventListener(ButtonEvent.BUTTON_CLICK, backButton_clickHandler);
		}
		
		private function showStarsLabelAnimation():void
		{
			AnimationEngine.globalAnimator.animateProperty(starsPlateContainer, "alpha", 0, 1, NaN, 550, AnimationEngine.globalAnimator.currentTime);
			
			var offset:Number = 20;
			AnimationEngine.globalAnimator.moveObjects(starsPlateContainer, starsPlateContainer.x, starsPlateContainer.y - offset, starsPlateContainer.x, starsPlateContainer.y, 500, AnimationEngine.globalAnimator.currentTime);
		}
		
		override public function hide():void
		{
			super.hide();
			
			removeFlags();
			levelsMapPanelToolBar.hideToolTips();
			
			AnimationEngine.globalAnimator.stopExecutingFunctionByID(FLAG_TOOLTIP_FUNCTION_ID);
			
			levelsMapPanelToolBar.devCenterButton.removeEventListener(ButtonEvent.BUTTON_CLICK, devCenterButton_clickHandler);
			levelsMapPanelToolBar.upgradeAvailableButton.removeEventListener(MouseEvent.CLICK, devCenterButton_clickHandler);
			levelsMapPanelToolBar.encyclopediaButton.removeEventListener(ButtonEvent.BUTTON_CLICK, encyclopediaButton_clickHandler);
			levelsMapPanelToolBar.achievementsButton.removeEventListener(ButtonEvent.BUTTON_CLICK, achievementsButton_clickHandler);
			levelsMapPanelToolBar.backButton.removeEventListener(ButtonEvent.BUTTON_CLICK, backButton_clickHandler);
		}
		
		private function devCenterButton_clickHandler(event:Event):void
		{
			dispatchEvent(new Event(DEV_CENTER_SELECTED));
		}
		
		private function encyclopediaButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(ENCYCLOPEDIA_SELECTED));
		}
		
		private function achievementsButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(ACHIEVEMENTS_SELECTED));
		}
		
		private function backButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(BACK_SELECTED));
		}
		
		/////////////////////
		
		// animation will be shown on next update.
		public function notifyNeedShowNewLevelAnimation():void
		{
			needShowNewLevelAnimationFlag = true;
		}
		
		// tooltip will be shown on next update.
		public function notifyNeedShowFirstUpdatesAvailableToolTip():void
		{
			needShowFirstUpdatesAvailableToolTipFlag = true;
		}
		
		override public function applyPanelInfo(panelInfo:*):void
		{
			super.applyPanelInfo(panelInfo);
			
			updateNumberOfStarsLabel(LevelsMapPanelInfo(panelInfo).gameInfo.totalStarsEarned);
			
			// show "new updates available" nofification
			// show first updates available tooltip if necessary
			if (!LevelsMapPanelInfo(panelInfo).gameInfo.developmentInfo.allWeaponsDeveloded())
				if (LevelsMapPanelInfo(panelInfo).gameInfo.starsAvailable >= LevelsMapPanelInfo(panelInfo).gameInfo.developmentInfo.getMinPriceNeededForNextDevelopment())
				{
					levelsMapPanelToolBar.notifyNewUpgradesAvailable(needShowFirstUpdatesAvailableToolTipFlag, LevelsMapPanelInfo(panelInfo).gameInfo.starsAvailable);
					
					// update the game state
					if (needShowFirstUpdatesAvailableToolTipFlag)
						LevelsMapPanelInfo(panelInfo).gameInfo.helpInfo.userCollectedEnoughStarsForTheFirstTimeAndAleadyNotified = true;
				}
			
			// drawing curve	
			curve.clear();
			
			curve.lineStyle(5, 0xFDF48A, 0.8, true);
			curve.precision = 0.05;
			
			for (var i:int = 0; i <= (LevelsMapPanelInfo(panelInfo).gameInfo.numLevelsPassed - 2); i++)
				drawCurveFromLevel(i);
			
			// draw curve only if the last past level is not the last in the game
			if (LevelsMapPanelInfo(panelInfo).gameInfo.numLevelsPassed < LevelsMapPanelInfo(panelInfo).gameInfo.levelInfos.length)
				drawCurveFromLevel(LevelsMapPanelInfo(panelInfo).gameInfo.numLevelsPassed - 1, needShowNewLevelAnimationFlag);
			
			// showing flags
			showFlags();
			
			// reseting flags
			needShowNewLevelAnimationFlag = false;
			needShowFirstUpdatesAvailableToolTipFlag = false;
		}
		
		private function drawCurveFromLevel(staringLevelIndex:int, showAnimation:Boolean = false):void
		{
			if (staringLevelIndex < 0)
				return;
			
			var i:int = staringLevelIndex;
			curve.drawBezierCurve(flagsPositions[i].x, flagsPositions[i].y, flagsPositions[i].x + flagsPositions[i].c2x, flagsPositions[i].y + flagsPositions[i].c2y, flagsPositions[i + 1].x + flagsPositions[i + 1].c1x, flagsPositions[i + 1].y + flagsPositions[i + 1].c1y, flagsPositions[i + 1].x, flagsPositions[i + 1].y, showAnimation, 2000);
		}
		
		private function showFlags():void
		{
			flagSelectedFlag = false;
			removeFlags();
			
			for (var i:int = 0; i < LevelsMapPanelInfo(panelInfo).gameInfo.levelInfos.length; i++)
			{
				var levelInfo:LevelInfo = LevelsMapPanelInfo(panelInfo).gameInfo.levelInfos[i] as LevelInfo;
				
				if (levelInfo.available)
					addFlagAt(i, levelInfo);
			}
		}
		
		/////////////////////
		
		private const flagsPositions:Array = [{x: 170, y: 400, c1x: 0, c1y: 0, c2x: 50, c2y: 0}, // sandy beach
			{x: 284, y: 301, c1x: -70, c1y: 0, c2x: 50, c2y: 0}, // oak woods
			{x: 408, y: 311, c1x: -50, c1y: 0, c2x: 70, c2y: 0}, // dead swamps
			{x: 514, y: 219, c1x: 0, c1y: 50, c2x: 0, c2y: -50}, // blue lagoon
			{x: 476, y: 140, c1x: 40, c1y: 0, c2x: -50, c2y: 0}, // magic woods
			{x: 391, y: 188, c1x: 20, c1y: -20, c2x: -10, c2y: 20}, // rain woods
			{x: 356, y: 250, c1x: 30, c1y: 0, c2x: -30, c2y: 0}, // bottomless crack
			{x: 289, y: 172, c1x: 50, c1y: 0, c2x: -50, c2y: 0}, // peak
			{x: 201, y: 179, c1x: 50, c1y: -10, c2x: -30, c2y: 20}, // cannibals village
			{x: 180, y: 216, c1x: -20, c1y: -20, c2x: 0, c2y: 0} // enemy camp
			];
		
		private var flags:Array = [];
		
		private var flagSelectedFlag:Boolean = false;
		
		private function addFlagAt(index:int, levelInfo:LevelInfo):void
		{
			if (!levelInfo.available)
				return;
			
			var flag:MapFlag = new MapFlag();
			
			flag.x = flagsPositions[index].x;
			flag.y = flagsPositions[index].y;
			//flag.scaleX = 0.7;
			//flag.scaleY = 0.7;
			flagsLayer.addChild(flag);
			
			/////////////
			// if the user just started the game need to add a tooltip
			if (index == 0 && !levelInfo.passed)
			{
				flag.animateFlagSticking(800);
				AnimationEngine.globalAnimator.executeFunction(addToolTipToStartingFlag, [flag], AnimationEngine.globalAnimator.currentTime + 1500, FLAG_TOOLTIP_FUNCTION_ID);
			}
			// show animation for every next level
			else if (!levelInfo.passed && needShowNewLevelAnimationFlag)
			{
				flag.animateFlagSticking(2800);
			}
			
			flag.updateForLevelInfo(levelInfo);
			
			flag.id = "" + index;
			flag.addEventListener(MouseEvent.CLICK, flag_clickHandler);
			
			flags.push(flag);
		}
		
		private function addToolTipToStartingFlag(flag:MapFlag):void
		{
			// if the panel is already hidden by the time the tooltip is ready to be shown,
			// then there is no reason to show it.
			if (!isShown || flagSelectedFlag)
				return;
			
			flag.showStartingToolTip();
		}
		
		private function flag_clickHandler(event:MouseEvent):void
		{
			var selectedIndex:int = int(MapFlag(event.currentTarget).id);
			selectedLevel = LevelsMapPanelInfo(panelInfo).gameInfo.levelInfos[selectedIndex] as LevelInfo;
			dispatchEvent(new SelectEvent(SelectEvent.SELECTED, selectedIndex, selectedLevel));
			
			// need to indicate that a flag has been selected.
			flagSelectedFlag = true;
		}
		
		private function removeFlags():void
		{
			for each (var flag:MapFlag in flags)
			{
				if (flagsLayer.contains(flag))
					flagsLayer.removeChild(flag);
				
				flag.deactivate();
				flag.removeEventListener(MouseEvent.CLICK, flag_clickHandler);
			}
			
			flags.length = 0;
		}
		
		////////////////
		
		// returns true if a user has just passed the last opened level
		public function selectedLevelIsLastPassed():Boolean
		{
			return selectedLevel && panelInfo && (selectedLevel.index == (LevelsMapPanelInfo(panelInfo).gameInfo.numLevelsPassed - 1))
		}
		
		// returns true if a user has just passed the last opened level
		public function needShowFirstUpdatesAvailableToolTip():Boolean
		{
			if (!panelInfo || LevelsMapPanelInfo(panelInfo).gameInfo.helpInfo.userCollectedEnoughStarsForTheFirstTimeAndAleadyNotified)
				return false;
			
			// need to check if the amount of stars is enough
			var minAmountEnough:int = LevelsMapPanelInfo(panelInfo).gameInfo.developmentInfo.getMinPriceNeededForNextDevelopment();
			var currentAmountIsEnough:Boolean = LevelsMapPanelInfo(panelInfo).gameInfo.starsAvailable >= minAmountEnough;
			
			return currentAmountIsEnough;
		}
	}

}