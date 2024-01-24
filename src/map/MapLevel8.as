/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package map
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import supportClasses.mapObjects.Bird;
	import supportClasses.mapObjects.BirdFlightProgram;
	import supportClasses.mapObjects.Snow;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapLevel8 extends Map
	{
		[Embed(source="F:/Island Defence/media/images/levels/level 08.jpg")]
		public static var levelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/ground pads/base for weapon yellow.png")]
		public static var baseForWeaponImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/barricade.png")]
		private static var obstacleImage:Class;
		
		//////////////////////////////
		
		//////////////////////////////
		
		public function MapLevel8()
		{
			levelImageClass = levelImage;
			weaponPadClass = baseForWeaponImage;
			defaultObstacleClass = obstacleImage;
			numberOfPaths = 2;
			constructMap();
			
			// configure birds
			birdsFlightProgram = new BirdFlightProgram();

			birdsFlightProgram.startingPoint = new Point(800, 300);
			birdsFlightProgram.anchorPoints = [new Point(627, 80), new Point(600, 460), new Point(627, 80), new Point(670, 450)];
			birdsFlightProgram.travelRadii = [20, 5, 20, 20];
			birdsFlightProgram.locationDeviationPixels = 25;
			birdsFlightProgram.radiusDeviationPercentage = 50;
			birdsFlightProgram.changeInterval = 10000;
			birdsFlightProgram.travelSpeed = 3;
			birdsFlightProgram.birdTypes = [Bird.BIRD_TYPE_HUGE_WHITE];
		}
		
		//////////////////////////////
		
		override protected function createDescription():void
		{
			description = MapLibrary.getMap08();
		}
		
		private var snow:Snow = new Snow();
		
		override public function placeAnimatedPartsSky(workingLayer:DisplayObjectContainer):void
		{
			workingLayer.addChild(snow);
		}
		
		private var point1:Point = new Point();
		private var point2:Point = new Point();
		
		override public function getWaveIndicatorPointForPathAt(pathIndex:int):Point
		{
			point1.x = enemyEntranceLocations[0].x;
			point1.y = enemyEntranceLocations[0].y + 180;
			
			point2.x = enemyEntranceLocations[1].x;
			point2.y = enemyEntranceLocations[1].y + 180;
			
			if (pathIndex == 0)
				return point1;
			
			return point2;
		}
	}

}