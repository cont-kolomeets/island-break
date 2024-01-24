/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package map
{
	import flash.geom.Point;
	import supportClasses.mapObjects.Bird;
	import supportClasses.mapObjects.BirdFlightProgram;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapLevel4 extends Map
	{
		[Embed(source="F:/Island Defence/media/images/levels/level 04.jpg")]
		public static var levelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/ground pads/base for weapon yellow.png")]
		public static var baseForWeaponImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/barricade.png")]
		private static var obstacleImage:Class;
		
		//////////////////////////////
		
		//////////////////////////////
		
		public function MapLevel4()
		{
			levelImageClass = levelImage;
			weaponPadClass = baseForWeaponImage;
			defaultObstacleClass = obstacleImage;
			numberOfPaths = 2;
			constructMap();
			
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
			description = MapLibrary.getMap04();
		}
		
		private var point1:Point = new Point();
		private var point2:Point = new Point();
		
		override public function getWaveIndicatorPointForPathAt(pathIndex:int):Point
		{
			point1.x = enemyEntranceLocations[0].x - 120;
			point1.y = enemyEntranceLocations[0].y;
			
			point2.x = enemyEntranceLocations[1].x;
			point2.y = enemyEntranceLocations[1].y - 130;
			
			if (pathIndex == 0)
				return point1;
			
			return point2;
		}

	}

}