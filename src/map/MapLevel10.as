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
	import weapons.objects.TrafficLight;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapLevel10 extends Map
	{
		[Embed(source="F:/Island Defence/media/images/levels/level 10.jpg")]
		public static var levelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/ground pads/base for weapon yellow.png")]
		public static var baseForWeaponImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/barricade.png")]
		private static var obstacleImage:Class;
		
		//////////////////////////////
		
		//////////////////////////////
		
		public function MapLevel10()
		{
			levelImageClass = levelImage;
			weaponPadClass = baseForWeaponImage;
			defaultObstacleClass = obstacleImage;
			numberOfPaths = 2;
			enemyUnitsDisappearToPortal = true;
			constructMap();
			generateEnemyExitTeleports();
		}
		
		//////////////////////////////
		
		override protected function createDescription():void
		{
			description = MapLibrary.getMap10();
		}
		
		override public function generateTrafficLights():Array
		{
			var trafficLights:Array = super.generateTrafficLights();
			
			// toggle oppositely
			TrafficLight(trafficLights[0]).toggle();
			
			return trafficLights;
		}
		
		private var point1:Point = new Point();
		private var point2:Point = new Point();
		
		override public function getWaveIndicatorPointForPathAt(pathIndex:int):Point
		{
			point1.x = enemyEntranceLocations[0].x + 100;
			point1.y = enemyEntranceLocations[0].y;
			
			point2.x = enemyEntranceLocations[1].x - 100;
			point2.y = enemyEntranceLocations[1].y;
			
			if (pathIndex == 0)
				return point1;
			
			return point2;
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