/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package map
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import nslib.AIPack.grid.Location;
	import nslib.sequencers.ImageSequencer;
	import supportClasses.mapObjects.Bird;
	import supportClasses.mapObjects.BirdFlightProgram;
	import weapons.objects.OneWayTeleport;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapLevel9 extends Map
	{
		[Embed(source="F:/Island Defence/media/images/levels/level 09.jpg")]
		public static var levelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/ground pads/base for weapon yellow.png")]
		public static var baseForWeaponImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/barricade.png")]
		private static var obstacleImage:Class;
		
		// camping fire
		
		[Embed(source="F:/Island Defence/media/images/common images/camping fire/camping fire f01.png")]
		public static var campingFireF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/camping fire/camping fire f02.png")]
		public static var campingFireF02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/camping fire/camping fire f03.png")]
		public static var campingFireF03Image:Class;
		
		//////////////////////////////
		
		//////////////////////////////
		
		public function MapLevel9()
		{
			levelImageClass = levelImage;
			weaponPadClass = baseForWeaponImage;
			defaultObstacleClass = obstacleImage;
			numberOfPaths = 2;
			enemyUnitsDisappearToPortal = true;
			constructMap();
			generateEnemyExitTeleports();
			
			// configure birds
			birdsFlightProgram = new BirdFlightProgram();

			birdsFlightProgram.startingPoint = new Point(0, 275);
			birdsFlightProgram.anchorPoints = [new Point(0, 275), new Point(0, 0), new Point(0, 275), new Point(250, 450)];
			birdsFlightProgram.travelRadii = [20, 5, 20, 20];
			birdsFlightProgram.locationDeviationPixels = 25;
			birdsFlightProgram.radiusDeviationPercentage = 50;
			birdsFlightProgram.changeInterval = 10000;
			birdsFlightProgram.birdTypes = [Bird.BIRD_TYPE_SMALL_BLACK, Bird.BIRD_TYPE_SMALL_BLACK];
		}
		
		//////////////////////////////
		
		override protected function createDescription():void
		{
			description = MapLibrary.getMap09();
		}
		
		private var campingFireSequencer:ImageSequencer = new ImageSequencer();
		
		override public function placeAnimatedPartsGround(workingLayer:DisplayObjectContainer):void 
		{
			campingFireSequencer.addEventListener(Event.REMOVED_FROM_STAGE, campingFireSequencer_removedFromStageHandler);
			
			campingFireSequencer.frameRate = 7;
			campingFireSequencer.playInLoop = true;
			campingFireSequencer.addImages([campingFireF01Image, campingFireF02Image, campingFireF03Image]);
			
			campingFireSequencer.start();
			
			campingFireSequencer.x = 578;
			campingFireSequencer.y = 114;
			
			workingLayer.addChild(campingFireSequencer);
		}
		
		private function campingFireSequencer_removedFromStageHandler(event:Event):void
		{
			campingFireSequencer.stop();
			campingFireSequencer.removeEventListener(Event.REMOVED_FROM_STAGE, campingFireSequencer_removedFromStageHandler);
		}
		
		private function generateEnemyExitTeleports():void
		{
			var teleport1:OneWayTeleport = new OneWayTeleport(OneWayTeleport.COLOR_PINK);
			var location1:Location = grid.getElement(enemyExitLocations[0].x, enemyExitLocations[0].y);
			teleport1.x = location1.x;
			teleport1.y = location1.y;
			
			enemyExitTeleports.push(teleport1);
			
			var teleport2:OneWayTeleport = new OneWayTeleport(OneWayTeleport.COLOR_VIOLET);
			var location2:Location = grid.getElement(enemyExitLocations[1].x, enemyExitLocations[1].y);
			teleport2.x = location2.x;
			teleport2.y = location2.y;
			
			enemyExitTeleports.push(teleport2);
		}
	}

}