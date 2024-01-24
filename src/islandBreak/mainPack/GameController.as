package islandBreak.mainPack
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import islandBreak.constants.GamePlayConstants;
	import islandBreak.controllers.ItemDynamicPlacer;
	import islandBreak.controllers.WeaponController;
	import islandBreak.supportClasses.MapDesigner;
	import islandBreak.supportClasses.resources.EnemyWeaponLocationConfig;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.core.Globals;
	import weapons.enemy.EnemyPlane;
	import weapons.manualWeapons.ManualPlane;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class GameController
	{
		private var navigator:PanelNavigator = null;
		
		private var weaponController:WeaponController = null;
		
		private var itemsController:ItemController = new ItemController();
		
		////////
		
		private var currentMission:int = 0;
		
		private var plane:ManualPlane = new ManualPlane(1);
		
		private var screenX:Number = 0;
		
		private var screenY:Number = 0;
		
		///////////////
		
		public function GameController(navigator:PanelNavigator)
		{
			this.navigator = navigator;
			
			weaponController = new WeaponController(navigator.gameStage);
			itemsController.navigator = navigator;
			itemsController.weaponController = weaponController;
		}
		
		////////////////
		
		public function start():void
		{
			intitialize();
		}
		
		private function intitialize():void
		{
			plane.x = GamePlayConstants.STAGE_WIDTH / 2;
			plane.y = GamePlayConstants.STAGE_HEIGHT / 2;
			
			addListeners();
			resetGame();
		}
		
		private function addListeners():void
		{
			DeltaTime.globalDeltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeAquiredHandler);
			Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			
			var designer:MapDesigner = new MapDesigner();
			designer.gameStage = navigator.gameStage;
			//designer.startDesigningMap();
		}
		
		private function resetGame():void
		{
			screenX = 0;
			screenY = 0;
			plane.bodyAngle = 0;
			
			weaponController.reset();
			itemsController.removeAllItems();
			
			navigator.gameStage.reset();
						
						
						
			itemsController.addHelper();
			itemsController.addHelper();
			
			navigator.gameStage.aircraftUserLayer.addChild(plane);
			itemsController.addItemsForMission(currentMission);
			
			weaponController.registerEnemy(plane);
			plane.activate();
		}
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.LEFT)
				plane.bodyAngle -= 0.1;
			
			if (event.keyCode == Keyboard.RIGHT)
				plane.bodyAngle += 0.1;
			
			if (event.keyCode == Keyboard.UP)
				plane.motionSpeed += 0.3;
			
			if (event.keyCode == Keyboard.DOWN)
				plane.motionSpeed -= 0.3;
		}
		
		private function deltaTimeAquiredHandler(event:DeltaTimeEvent):void
		{
			screenX -= event.lastDeltaTime / GamePlayConstants.STANDARD_INTERVAL * plane.motionSpeed * Math.cos(plane.bodyAngle);
			screenY -= event.lastDeltaTime / GamePlayConstants.STANDARD_INTERVAL * plane.motionSpeed * Math.sin(plane.bodyAngle);
			
			navigator.gameStage.moveScreenTo(screenX, screenY, plane.bodyAngle);
		}
	
	}

}