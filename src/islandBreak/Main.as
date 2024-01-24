package islandBreak
{
	import flash.events.Event;
	import islandBreak.mainPack.DifficultyConfig;
	import islandBreak.mainPack.GameController;
	import islandBreak.mainPack.PanelNavigator;
	import nslib.controls.FPSMonitor;
	import nslib.controls.MouseCursorPositionMonitor;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.core.Globals;
	import nslib.core.NSFramework;
	import nslib.utils.GlobalTrace;
	import nslib.utils.GlobalTraceField;
	import nslib.utils.ObjectsPoolUtil;
	import supportClasses.resources.WeaponResources;
	
	//import islandBreak.mainPack.GameSettings;
	
	/**
	 * Main class of the app. Created after preloading is finished.
	 */
	//[Frame(factoryClass = "Preloader")]
	
	public class Main extends NSSprite
	{
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Main controller responsible for the game logic.
		 */
		private var controller:GameController;
		
		private var navigator:PanelNavigator = new PanelNavigator();
		
		private var globalTraceField:GlobalTraceField = new GlobalTraceField();
		
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
		 */
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// initialize the framework
			NSFramework.initialize(this);
			Globals.toolTipLayer = new NSSprite();
			ToolTipService.toolTipLayer = Globals.toolTipLayer;
			
			// initialize configs
			//GameSettings.intialize();
			WeaponResources.initialize();
			DifficultyConfig.configureForDifficulty(DifficultyConfig.DIFFICULTY_NORMAL);
			
			//GameSettings.stage = stage;
			
			// construct the game itself
			construct();
			
			// construct things used in development
			constructAdditionalThings();
		
			//addChild(new Designer());
		}
		
		private function construct():void
		{
			navigator = new PanelNavigator();
			controller = new GameController(navigator);
			addChild(navigator);
			
			controller.start();
			
			addChild(Globals.toolTipLayer);
		}
		
		private function constructAdditionalThings():void
		{
			GlobalTrace.field = globalTraceField;
			GlobalTrace.mainApp = this;
			
			var cursorMonitor:MouseCursorPositionMonitor = new MouseCursorPositionMonitor();
			cursorMonitor.relativeObject = navigator.gameStage.groundItemLayer;
			cursorMonitor.y = stage.stageHeight - 20;
			cursorMonitor.color = 0xDDDDDD;
			addChild(cursorMonitor);
			
			var fpsMonitor:FPSMonitor = new FPSMonitor();
			fpsMonitor.y = stage.stageHeight - 40;
			fpsMonitor.showFPS = true;
			//addChild(fpsMonitor);
			
			globalTraceField.x = 50; // stage.stageWidth - 400;
			globalTraceField.y = 0; //stage.stageHeight - 300;
			//addChild(globalTraceField);

			//GlobalTrace.monitorProperty(ObjectsPoolUtil, "profile");
		}
		
		/**
		 * Call this method after preloading to start the game.
		 */
		public function start():void
		{
			// start the game
			//navigator.startInitialStep();
			controller.start();
		}
	
	}

}