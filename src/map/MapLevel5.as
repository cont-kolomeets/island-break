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
	public class MapLevel5 extends Map
	{
		[Embed(source="F:/Island Defence/media/images/levels/level 05.jpg")]
		public static var levelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/ground pads/base for weapon yellow.png")]
		public static var baseForWeaponImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/barricade.png")]
		private static var obstacleImage:Class;
		
		//////////////////////////////
		
		//////////////////////////////
		
		public function MapLevel5()
		{
			levelImageClass = levelImage;
			weaponPadClass = baseForWeaponImage;
			defaultObstacleClass = obstacleImage;
			numberOfPaths = 2;
			constructMap();
			
			// configure birds
			birdsFlightProgram = new BirdFlightProgram();
			
			birdsFlightProgram.startingPoint = new Point(-100, 275);
			birdsFlightProgram.anchorPoints = [new Point(-100, 275), new Point(-100, 0), new Point(-100, 275), new Point(250, 450)];
			birdsFlightProgram.travelRadii = [20, 5, 20, 20];
			birdsFlightProgram.locationDeviationPixels = 25;
			birdsFlightProgram.radiusDeviationPercentage = 50;
			birdsFlightProgram.changeInterval = 10000;
			birdsFlightProgram.birdTypes = [Bird.BIRD_TYPE_SMALL_MAGENTA, Bird.BIRD_TYPE_SMALL_MAGENTA, Bird.BIRD_TYPE_TINY_CYAN, Bird.BIRD_TYPE_TINY_CYAN, Bird.BIRD_TYPE_TINY_CYAN, Bird.BIRD_TYPE_SMALL_YELLOW, Bird.BIRD_TYPE_SMALL_GREEN, Bird.BIRD_TYPE_SMALL_GREEN];
		}
		
		//////////////////////////////
		
		override protected function createDescription():void
		{
			description = MapLibrary.getMap05();
		}
	}

}