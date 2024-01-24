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
	import supportClasses.mapObjects.RainAndThunder;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapLevel6 extends Map
	{
		[Embed(source="F:/Island Defence/media/images/levels/level 06.jpg")]
		public static var levelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/ground pads/base for weapon yellow.png")]
		public static var baseForWeaponImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/barricade.png")]
		private static var obstacleImage:Class;
		
		//////////////////////////////
		
		//////////////////////////////
		
		public function MapLevel6()
		{
			levelImageClass = levelImage;
			weaponPadClass = baseForWeaponImage;
			defaultObstacleClass = obstacleImage;
			gunRestAngle = Math.PI;
			numberOfPaths = 2;
			constructMap();
		}
		
		//////////////////////////////
		
		override protected function createDescription():void
		{
			description = MapLibrary.getMap06();
		}
		
		private var rainAndThunder:RainAndThunder = new RainAndThunder();
		
		override public function placeAnimatedPartsSky(workingLayer:DisplayObjectContainer):void
		{
			workingLayer.addChild(rainAndThunder);
		}
		
		private var point1:Point = new Point();
		private var point2:Point = new Point();
		
		override public function getWaveIndicatorPointForPathAt(pathIndex:int):Point
		{
			point1.x = enemyEntranceLocations[0].x + 105;
			point1.y = enemyEntranceLocations[0].y;
			
			point2.x = enemyEntranceLocations[1].x + 105;
			point2.y = enemyEntranceLocations[1].y;
			
			if (pathIndex == 0)
				return point1;
			
			return point2;
		}
	}

}