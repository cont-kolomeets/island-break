/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import constants.GamePlayConstants;
	import constants.WeaponContants;
	import events.PauseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import nslib.controls.NSSprite;
	import nslib.core.Globals;
	import nslib.effects.traceEffects.ITracableContainer;
	import nslib.utils.FontDescriptor;
	import panels.common.MessageNotifier;
	import panels.PanelBase;
	import supportClasses.mapObjects.BirdFlightProgram;
	import supportClasses.mapObjects.BirdsGenerator;
	import supportClasses.resources.FontResources;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	import weapons.objects.Bridge;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class GameStage extends PanelBase implements ITracableContainer
	{
		//////////////////
		
		public static const INDEX_OF_HIGHEST_PERMANENT_BITMAP:int = 1;
		
		// layer to put children
		public var childrenLayer:NSSprite = new NSSprite();
		
		// layer to put aircrafts
		public var aircraftLayer:NSSprite = new NSSprite();
		
		// layer to put menus
		public var menuLayer:NSSprite = new NSSprite();
		
		//////////////////
		
		// panel that holds lots of contorls
		public var gameControlPanel:GameControlPanel = new GameControlPanel();
		
		// used to draw a validation indicator 
		public var background:Shape = new Shape();
		
		// used to draw lines for advanced targeting
		public var advancedTargetingLayer:Shape = new Shape();
		
		// layer to show hit radius of weapons on.
		private var hitRadiusVisualizer:WeaponHitRadiusVisualizer = new WeaponHitRadiusVisualizer();
		
		// layer to draw enemy path
		public var trajectoryLayer:Bitmap = new Bitmap();
		
		// used to draw traceable object
		private var traceBitmap:Bitmap;
		
		// used to draw map, burn bits, and other stuff that stays on the map
		private var permanentBitmap:Bitmap;
		
		// semi-transparent screen to show when the game is paused
		private var pauseScreen:PauseScreen = new PauseScreen();
		
		private var birdsGenerator:BirdsGenerator = new BirdsGenerator();
		
		private var advancedTargetingVisualizer:AdvancedTargetingVisualizer = new AdvancedTargetingVisualizer();
		
		///////////////////////////////////////////////////////////////////////
		
		public function GameStage()
		{
			constructStage();
		}
		
		/////////////////////
		
		private var _traceBitmapData:BitmapData;
		
		public function get traceBitmapData():BitmapData
		{
			return _traceBitmapData;
		}
		
		public function set traceBitmapData(value:BitmapData):void
		{
			_traceBitmapData = value;
		}
		
		//////////////
		
		private var _traceRect:Rectangle;
		
		public function get traceRect():Rectangle
		{
			return _traceRect;
		}
		
		public function set traceRect(value:Rectangle):void
		{
			_traceRect = value;
		}
		
		//////////////
		
		private var _traceColorTransform:ColorTransform = new ColorTransform();
		
		public function get traceColorTransform():ColorTransform
		{
			return _traceColorTransform;
		}
		
		public function set traceColorTransform(value:ColorTransform):void
		{
			_traceColorTransform = value;
		}
		
		/////////////
		
		private var _permanentBitmapDataColorTransform:ColorTransform = new ColorTransform();
		
		public function get permanentBitmapDataColorTransform():ColorTransform
		{
			return _permanentBitmapDataColorTransform;
		}
		
		public function set permanentBitmapDataColorTransform(value:ColorTransform):void
		{
			_permanentBitmapDataColorTransform = value;
		}
		
		//////////////
		
		private var _permanentBitmapData:BitmapData;
		
		public function get permanentBitmapData():BitmapData
		{
			return _permanentBitmapData;
		}
		
		public function set permanentBitmapData(value:BitmapData):void
		{
			_permanentBitmapData = value;
		}
		
		//////////////////////////////////////////////////////////////////////////
		
		private function constructStage():void
		{
			mouseEnabled = true;
			// to prevent all tooltips for hidden components
			// and make it clickable
			pauseScreen.mouseEnabled = true;
			
			removeAllChildren();
			
			childrenLayer.removeAllChildren();
			aircraftLayer.removeAllChildren();
			menuLayer.removeAllChildren();
			
			addChild(childrenLayer);
			addChild(aircraftLayer);
			addChild(menuLayer);
			addChild(advancedTargetingLayer);
			
			advancedTargetingVisualizer.gameStage = this;
			advancedTargetingVisualizer.workingLayer = advancedTargetingLayer;
			
			childrenLayer.addChild(background);
			childrenLayer.addChild(hitRadiusVisualizer);
			childrenLayer.addChild(trajectoryLayer);
			addTraceBitmapData();
			
			hitRadiusVisualizer.mouseChildren = false;
			hitRadiusVisualizer.mouseEnabled = false;
			
			gameControlPanel.toInitialState();
			menuLayer.addChild(gameControlPanel);
			
			birdsGenerator.workingLayer = aircraftLayer;
			birdsGenerator.stopProgram();
			
			//addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/////////////////////////////////////////////
		// Adding bitmap data
		//////////////////////////////////////////////
		
		private function addTraceBitmapData():void
		{
			traceBitmapData = new BitmapData(GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT, true, 0x00000000);
			traceRect = traceBitmapData.rect;
			
			traceBitmap = new Bitmap(traceBitmapData);
			childrenLayer.addChild(traceBitmap);
			
			traceColorTransform.alphaMultiplier = WeaponContants.DEFAULT_TRACE_FADE_MULTIPLIER;
			permanentBitmapDataColorTransform.alphaMultiplier = WeaponContants.DEFAULT_GROUND_MARKS_FADE_MULTIPLIER;
		}
		
		// rebuilds the game stage
		public function rebuild():void
		{
			constructStage();
		}
		
		// sets permanent bitmapdata to be used to draw permanent things
		public function setPermanentBitmapData(bitmapData:BitmapData):void
		{
			permanentBitmapData = new BitmapData(GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT, true, 0x00000000);
			permanentBitmap = new Bitmap(permanentBitmapData);
			childrenLayer.addChildAt(permanentBitmap, 0);
			
			var backgroundBitmapData:BitmapData = bitmapData;
			var backgroundBitmap:Bitmap = new Bitmap(backgroundBitmapData);
			childrenLayer.addChildAt(backgroundBitmap, 0);
		}
		
		// bridges are very specific objects.
		// they need to be added under trajectory layer but over the permanent bitmap layer
		public function addBridge(bridge:Bridge):void
		{
			childrenLayer.addChildAt(bridge, INDEX_OF_HIGHEST_PERMANENT_BITMAP + 1);
		}
		
		// A weapon should be placed right above the trajectory layer.
		public function getIndexToPlaceWeaponOverBridge():int
		{
			if (childrenLayer.contains(trajectoryLayer))
				return childrenLayer.getChildIndex(trajectoryLayer) + 1;
				
			return -1;
		}
		
		///////////
		
		public function dispatchBirds(program:BirdFlightProgram):void
		{
			birdsGenerator.dispatchBridsWithProgram(program);
		}
		
		///////////
		
		override public function show():void
		{
			super.show();
			
			gameControlPanel.addEventListener(PauseEvent.PAUSE_SCREEN_REMOVE_REQUESTED, gameControlPanel_startClickedHandler);
			gameControlPanel.addEventListener(PauseEvent.PAUSE_SCREEN_ADD_REQUESTED, gameControlPanel_pauseClickedHandler);
			gameControlPanel.addEventListener(GameControlPanel.RESET_TO_INITIAL_STATE, gameControlPanel_resetToInitialStateHandler);
			
			gameControlPanel.show();
		}
		
		override public function hide():void
		{
			super.hide();
			gameControlPanel.removeEventListener(PauseEvent.PAUSE_SCREEN_REMOVE_REQUESTED, gameControlPanel_startClickedHandler);
			gameControlPanel.removeEventListener(PauseEvent.PAUSE_SCREEN_ADD_REQUESTED, gameControlPanel_pauseClickedHandler);
			gameControlPanel.removeEventListener(GameControlPanel.RESET_TO_INITIAL_STATE, gameControlPanel_resetToInitialStateHandler);
			
			gameControlPanel.hide();
		}
		
		//------------------------------------------------------------------------------
		//
		// Working with pause screen
		//
		//------------------------------------------------------------------------------
		
		private function gameControlPanel_startClickedHandler(event:PauseEvent):void
		{
			hidePauseScreen();
		}
		
		private function gameControlPanel_pauseClickedHandler(event:PauseEvent):void
		{
			showPauseScreen(event.showAutoPauseNotification);
		}
		
		private function gameControlPanel_resetToInitialStateHandler(event:Event):void
		{
			hidePauseScreen();
		}
		
		//////////////////////////////
		
		private function hidePauseScreen():void
		{
			if (Globals.topLevelApplication.contains(pauseScreen))
				Globals.topLevelApplication.removeChild(pauseScreen);
			
			pauseScreen.removeEventListener(MouseEvent.CLICK, pauseScreen_clickHandler);
		}
		
		private function showPauseScreen(showAutopauseNotification:Boolean = false):void
		{
			if (!Globals.topLevelApplication.contains(pauseScreen))
				Globals.topLevelApplication.addChild(pauseScreen);
				
			pauseScreen.showAutopauseNotification(showAutopauseNotification);
			
			pauseScreen.addEventListener(MouseEvent.CLICK, pauseScreen_clickHandler);
		}
		
		private function pauseScreen_clickHandler(event:MouseEvent):void
		{
			// resume the game
			gameControlPanel.imitateStartButtonClickedByUser();
			gameControlPanel.notifyGameResumed();
		}
		
		//------------------------------------------------------------------------------
		//
		// Working with radius
		//
		//------------------------------------------------------------------------------
		
		public function getWeaponWhichHitRadiusIsShowing():Weapon
		{
			return hitRadiusVisualizer.getWeaponWhichHitRadiusIsShowing();
		}
		
		public function showHitRadiusForWeapon(weapon:Weapon):void
		{
			hitRadiusVisualizer.showHitRadiusForWeapon(weapon);
		}
		
		public function updateHitRadiusPositionForWeapon(weapon:Weapon):void
		{
			hitRadiusVisualizer.updateHitRadiusPositionForWeapon(weapon);
		}
		
		public function hideHitRadiusForCurrentWeapon():void
		{
			hitRadiusVisualizer.hideHitRadiusForCurrentWeapon();
		}
		
		public function showHitRadiusForWeaponNextLevel(weapon:Weapon):void
		{
			hitRadiusVisualizer.showHitRadiusForWeaponNextLevel(weapon);
		}
		
		//------------------------------------------------------------------------------
		//
		// Advanced targeting
		//
		//------------------------------------------------------------------------------
		
		private var isCancelMesageShown:Boolean = false;
		
		public function startSelectionForAdvancedTargeting():void
		{
			advancedTargetingVisualizer.startSelection();
			
			addEventListener(MouseEvent.MOUSE_MOVE, checkIfNeedShowSelectionCancelMessage);
			
			advancedTargetingVisualizer.addEventListener(AdvancedTargetingVisualizer.SELECTION_FINISHED, advancedTargetingVisualizer_selectionFinishedHandler);
		}
		
		private function checkIfNeedShowSelectionCancelMessage(event:MouseEvent):void
		{
			if (advancedTargetingVisualizer.isSelecting && !isCancelMesageShown)
			{
				isCancelMesageShown = true;
				gameControlPanel.showWarningMessage("Press ESC to cancel");
			}
		}
		
		private function advancedTargetingVisualizer_selectionFinishedHandler(event:Event):void
		{
			removeEventListener(MouseEvent.MOUSE_MOVE, checkIfNeedShowSelectionCancelMessage);
			advancedTargetingVisualizer.removeEventListener(AdvancedTargetingVisualizer.SELECTION_FINISHED, advancedTargetingVisualizer_selectionFinishedHandler);
			
			isCancelMesageShown = false;
			gameControlPanel.showWarningMessage(null);
		}
		
		public function getLastTargetedEnemy():IWeapon
		{
			return advancedTargetingVisualizer.getLastTargetedEnemy();
		}
		
		public function isSelectingUsingAdvancedTargeting():Boolean
		{
			return advancedTargetingVisualizer.isSelecting;
		}
		
		public function notifyEnemyIsHovered(value:Boolean):void
		{
			advancedTargetingVisualizer.notifyEnemyIsHovered(value);
		}
		
		public function clearSelection():void
		{
			advancedTargetingVisualizer.clearSelection();
		}
		
		//------------------------------------------------------------------------------
		//
		// Working with notifications
		//
		//------------------------------------------------------------------------------
		
		private var messageNotifier:MessageNotifier = new MessageNotifier();
		
		public function showFinalWaveNotification():void
		{
			messageNotifier.workingLayer = menuLayer;
			messageNotifier.showScreenNotification("Final Wave!", new FontDescriptor(50, 0xAC0ED3, FontResources.YARDSALE));
		}
		
		public function showBossIsComingNotification():void
		{
			messageNotifier.workingLayer = menuLayer;
			messageNotifier.showScreenNotification("Boss!!!", new FontDescriptor(50, 0xDA3D07, FontResources.YARDSALE));
		}
		
		//////////////////////////////////////////////////
		
		private function test():void
		{
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			//WeaponController.launchCannonBall(event.stageX, event.stageY, event.stageX + 100, event.stageY - 100);
		}
	}

}