/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package map
{
	import flash.geom.Point;
	import nslib.AIPack.grid.Location;
	import weapons.objects.OneWayTeleport;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapLevel7 extends Map
	{
		[Embed(source="F:/Island Defence/media/images/levels/level 07.jpg")]
		public static var levelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/ground pads/base for weapon yellow.png")]
		public static var baseForWeaponImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/barricade.png")]
		private static var obstacleImage:Class;
		
		//////////////////////////////
		
		//////////////////////////////
		
		public function MapLevel7()
		{
			levelImageClass = levelImage;
			weaponPadClass = baseForWeaponImage;
			defaultObstacleClass = obstacleImage;
			numberOfPaths = 2;
			enemyUnitsAppearFromPortal = true;
			constructMap();
			generateEnemyEnterTeleports();
		}
		
		//////////////////////////////
		
		override protected function createDescription():void
		{
			description = MapLibrary.getMap07();
		}
		
		override public function getEnemyInitialRotationForPathAt(pathIndex:int):Number
		{
			if (pathIndex == 0)
				return Math.PI;
			
			return 0;
		}
		
		override public function getWaveIndicatorRotationForPathAt(pathIndex:int):Number
		{
			if (pathIndex == 0)
				return 0;
			
			return Math.PI;
		}
		
		private var point1:Point = new Point();
		private var point2:Point = new Point();
		
		override public function getWaveIndicatorPointForPathAt(pathIndex:int):Point
		{
			point1.x = enemyEntranceLocations[0].x - 130;
			point1.y = enemyEntranceLocations[0].y;
			
			point2.x = enemyEntranceLocations[1].x + 130;
			point2.y = enemyEntranceLocations[1].y;
			
			if (pathIndex == 0)
				return point1;
			
			return point2;
		}
		
		private function generateEnemyEnterTeleports():void
		{
			var teleport1:OneWayTeleport = new OneWayTeleport(OneWayTeleport.COLOR_PINK);
			var location1:Location = grid.getElement(enemyEntranceLocations[0].x, enemyEntranceLocations[0].y);
			teleport1.x = location1.x;
			teleport1.y = location1.y;
			
			enemyEnterTeleports.push(teleport1);
			
			var teleport2:OneWayTeleport = new OneWayTeleport(OneWayTeleport.COLOR_VIOLET);
			var location2:Location = grid.getElement(enemyEntranceLocations[1].x, enemyEntranceLocations[1].y);
			teleport2.x = location2.x;
			teleport2.y = location2.y;
			
			enemyEnterTeleports.push(teleport2);
		}
	
	}

}