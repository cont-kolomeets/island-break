/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package
{
	import constants.GamePlayConstants;
	import controllers.WaveGenerator;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import mainPack.DifficultyConfig;
	import mainPack.GameController;
	import mainPack.GameSettings;
	import mainPack.PanelNavigator;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.core.Globals;
	import nslib.core.NSFramework;
	import nslib.designer.Designer;
	import nslib.utils.GlobalTraceField;
	import supportClasses.resources.AchievementResources;
	import supportClasses.resources.StoryResources;
	import supportClasses.resources.TipResources;
	import supportClasses.resources.WeaponResources;
	import tracker.GameTracker;
	
	/**
	 * Main class of the app. Created after preloading is finished.
	 */
	[Frame(factoryClass="SimplePreloader")]
	
	public class Main extends NSSprite
	{
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Navigator to navigate between different game screens.
		 */
		private var navigator:PanelNavigator;
		
		/**
		 * Main controller responsible for the game logic.
		 */
		private var controller:GameController;
		
		//private var globalTraceField:GlobalTraceField = new GlobalTraceField();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------------
		// Initialization
		//------------------------------------------
		
		/**
		 * Initializes all core components of the app. 
		 * @param	e
		 */
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// initialize the framework
			NSFramework.initialize(this);
			Globals.toolTipLayer = new NSSprite();
			ToolTipService.toolTipLayer = Globals.toolTipLayer;
			
			// initialize configs
			GameSettings.intialize();
			WeaponResources.initialize();
			AchievementResources.initialize();
			TipResources.initialize();
			StoryResources.initialize();
			WaveGenerator.initialize();
			DifficultyConfig.configureForDifficulty(DifficultyConfig.DIFFICULTY_NORMAL);
			
			GameSettings.stage = stage;
			
			// construct the game itself
			construct();
			
			// construct things used in development
			//constructAdditionalThings();
			
			new GameTracker();
			GameTracker.api.beginGame();
			
			addChild(new Designer());
		}
		
		private function construct():void
		{
			navigator = new PanelNavigator();
			controller = new GameController(navigator);
			addChild(navigator);
			
			addChild(Globals.toolTipLayer);
		}
		
		/*private function constructAdditionalThings():void
		   {
		   GlobalTrace.field = globalTraceField;
		   GlobalTrace.mainApp = this;
		
		   var cursorMonitor:MouseCursorPositionMonitor = new MouseCursorPositionMonitor();
		   cursorMonitor.y = stage.stageHeight - 20;
		   cursorMonitor.color = 0xDDDDDD;
		   //addChild(cursorMonitor);
		
		   var fpsMonitor:FPSMonitor = new FPSMonitor();
		   fpsMonitor.y = stage.stageHeight - 40;
		   fpsMonitor.showFPS = true;
		   //addChild(fpsMonitor);
		
		   globalTraceField.x = 50;// stage.stageWidth - 400;
		   globalTraceField.y = 0; //stage.stageHeight - 300;
		   addChild(globalTraceField);
		
		   //GlobalTrace.monitorProperty(ObjectsPoolUtil, "profile");
		 }*/
		
		 /**
		 * Call this method after preloading to start the game.
		 */
		public function start():void
		{
			// start the game
			navigator.startInitialStep();
			controller.start();
		}
	}

}