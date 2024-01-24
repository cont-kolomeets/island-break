/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import constants.MapConstants;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import map.Map;
	import map.MapLevel1;
	import map.MapLevel10;
	import map.MapLevel2;
	import map.MapLevel3;
	import map.MapLevel4;
	import map.MapLevel5;
	import map.MapLevel6;
	import map.MapLevel7;
	import map.MapLevel8;
	import map.MapLevel9;
	import map.VisualHelper;
	import nslib.AIPack.grid.Location;
	import nslib.AIPack.grid.LocationConstants;
	import nslib.AIPack.pathFollowing.PathFinder;
	import nslib.utils.ArrayList;
	import panels.inGame.GameStage;
	import weapons.base.IGroundWeapon;
	import weapons.objects.Obstacle;
	import weapons.objects.TrafficLight;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapController
	{
		public static const PATH_COLORS:Array = [0xFF0000, 0x0000FF, 0xAB0EBC];
		
		public var currentMap:Map;
		public var trajectories:Array = [];
		public var weaponController:WeaponController;
		
		private var pathFinder:PathFinder;
		private var gs:GameStage;
		
		private var trafficLights:Array = [];
		
		/////////////////////
		
		public function MapController(gameStage:GameStage)
		{
			gs = gameStage;
			
			VisualHelper.defaultContainer = gameStage;
		}
		
		/////////////////////
		
		public function reset():void
		{
			trajectories.length = 0;
			currentMap = null;
			trafficLights.length = 0;
		}
		
		// loads map for the level specified.
		public function loadMapForLevel(level:int, customMapDescription:Array = null):void
		{
			if (level == 0)
				currentMap = new MapLevel1();
			else if (level == 1)
				currentMap = new MapLevel2();
			else if (level == 2)
				currentMap = new MapLevel3();
			else if (level == 3)
				currentMap = new MapLevel4();
			else if (level == 4)
				currentMap = new MapLevel5();
			else if (level == 5)
				currentMap = new MapLevel6();
			else if (level == 6)
				currentMap = new MapLevel7();
			else if (level == 7)
				currentMap = new MapLevel8();
			else if (level == 8)
				currentMap = new MapLevel9();
			else if (level == 9)
				currentMap = new MapLevel10();
			
			if (customMapDescription)
				currentMap.applyCustomDescription(customMapDescription);
			
			trajectories.length = 0;
			
			for (var i:int = 0; i < currentMap.numberOfPaths; i++)
				trajectories.push(new ArrayList());
			
			pathFinder = new PathFinder(currentMap.grid);
		
			//VisualHelper.visualizeGrid(gs.background, currentMap.grid);
		}
		
		// generates bitmapdata for the current map.
		public function generateBitmapData():BitmapData
		{
			return currentMap.generateBitmapData();
		}
		
		public function generateTrajectories():void
		{
			for (var i:int = 0; i < trajectories.length; i++)
			{
				trajectories[i].removeAll();
				
				var path:Array = pathFinder.findPath(currentMap.getEnemyEntranceLocationForPathAt(i), currentMap.getEnemyExitLocationForPathAt(i));
				path = path.reverse();
				
				ArrayList(trajectories[i]).source = path;
			}
		}
		
		// use case: very ofter there are more than one the shortest possible ways
		// from start to end. For this reason a test trajectory and a real trajectory may
		// be equal in distance, but look slightly different. That's why sometimes it is
		// usefull to just apply the latest test trajectories to make them real ones.
		public function applyLatestTestTrajectories():void
		{
			for (var i:int = 0; i < trajectories.length; i++)
				ArrayList(trajectories[i]).source = ArrayList(testTrajectories[i]).source;
		}
		
		public function visualizeTrajectories():void
		{
			for (var i:int = 0; i < trajectories.length; i++)
				VisualHelper.drawTrajectoryStack(gs.trajectoryLayer, trajectories[i], PATH_COLORS[i], 0.5, (i == 0));
		
			//VisualHelper.drawTrajectoryArrows(gs, trajectory, gs.deltaTimeCounter);
		}
		
		///////////////////////////////////////////////////////
		
		private var testTrajectories:Array = [];
		
		private function generateTestTrajectories():void
		{
			testTrajectories = [];
			
			for (var i:int = 0; i < trajectories.length; i++)
			{
				var testTrajectory:ArrayList = new ArrayList();
				
				var path:Array = pathFinder.findPath(currentMap.getEnemyEntranceLocationForPathAt(i), currentMap.getEnemyExitLocationForPathAt(i));
				path = path.reverse();
				
				testTrajectory.source = path;
				
				testTrajectories.push(testTrajectory);
			}
		}
		
		private function visualizeTestTrajectories():void
		{
			for (var i:int = 0; i < testTrajectories.length; i++)
				VisualHelper.drawTrajectoryStack(gs.trajectoryLayer, testTrajectories[i], PATH_COLORS[i], 0.5, Boolean(i == 0));
		}
		
		//////////////////////////////////////////
		
		public function clearTrajectories():void
		{
			gs.trajectoryLayer.bitmapData = null;
		}
		
		public function checkIfValidItemToPlaceAt(item:IGroundWeapon, x:int, y:int):void
		{
			if (!currentMap.grid.coordinatesAreOutOfBounds(x, y))
			{
				var location:Location = currentMap.grid.generateLocationFromXY(x, y);
				var color:int = isLegitimatePosition(item, x, y) ? 0x00FF00 : 0xFF0000;
				
				VisualHelper.drawGridCell(gs.background, currentMap.grid, location, color);
			}
		}
		
		// this value is used to prevent unnecessary recalculation of trajectories
		// since locations are highly discrete.
		private var latestTestedLocation:Location = null;
		
		private var latestResult:Boolean = false;
		
		public function isLegitimatePosition(item:IGroundWeapon, x:int, y:int):Boolean
		{
			if (currentMap.grid.coordinatesAreOutOfBounds(x, y))
				return false;
			
			var location:Location = currentMap.grid.generateLocationFromXY(x, y);
			
			if (location == latestTestedLocation)
				return latestResult;
			
			latestResult = testLocationForValidity(item, location);
			
			// need to show the real trajectories in these cases
			if (!latestResult && testTrajectoriesWereVisualizedLastTime)
			{
				testTrajectoriesWereVisualizedLastTime = false;
				visualizeTrajectories();
			}
			
			latestTestedLocation = location;
			return latestResult;
		}
		
		// this flag is used for the following reason.
		// once the location to test is over an empty spot and covers any
		// of the trajectories, we draw test trajectories
		// but next time we do a validation test we may be not over any trajectory
		// so we need to visualize real paths.
		private var testTrajectoriesWereVisualizedLastTime:Boolean = false;
		
		private function testLocationForValidity(item:IGroundWeapon, location:Location):Boolean
		{
			// the location must be empty
			// check filters
			if (item is Obstacle)
			{
				// the location must be completely empty
				if (location.filter != MapConstants.LOCATION_EMPTY_FILTER)
					return false;
			}
			// the location must be free for wepaons
			else if (location.filter != MapConstants.LOCATION_ONLY_USER_WEAPON_FREE_FILTER)
				return false;
			
			// check if the location covers either the start or the end points
			for (var i:int = 0; i < trajectories.length; i++)
				if (location == currentMap.getEnemyEntranceLocationForPathAt(i) || location == currentMap.getEnemyExitLocationForPathAt(i))
					return false;
			
			// the location must not cover any enemy unit (not used in the current version of the game)
			//if (locationCoversEnemy(location))
			//	return false;
			
			// if we are over an empty location then we need to make run some tests
			if (location.id == LocationConstants.EMPTY && spotIsOverAnyTrajectory(location.x, location.y))
			{
				// here we temporarily set this point as 'obstacle'
				assignOccupiedLocation(location);
				// then generate a trajectory
				generateTestTrajectories();
				// clear the point
				clearLocationOccupation(location);
				
				// all trajectories should be able to reach their goal points
				for (var j:int = 0; j < testTrajectories.length; j++)
					if (testTrajectories[j].length == 0)
						return false;
				
				visualizeTestTrajectories();
				
				testTrajectoriesWereVisualizedLastTime = true;
			}
			else if (testTrajectoriesWereVisualizedLastTime)
			{
				testTrajectoriesWereVisualizedLastTime = false;
				visualizeTrajectories();
			}
			
			return true;
		}
		
		/*public function locationCoversEnemy(locationToCheck:Location):Boolean
		{
			for each (var enemy:DisplayObject in weaponController.enemies.source)
			{
				var location:Location = currentMap.grid.generateLocationFromXY(enemy.x, enemy.y);
				if (location && location.uniqueKey == locationToCheck.uniqueKey)
					return true;
			}
			
			return false
		}*/
		
		public function getSnapPoint(x:int, y:int):Point
		{
			var location:Location = currentMap.grid.generateLocationFromXY(x, y);
			return new Point(location.x, location.y);
		}
		
		public function assignSpot(x:int, y:int):void
		{
			var location:Location = currentMap.grid.generateLocationFromXY(x, y);
			
			assignOccupiedLocation(location);
		}
		
		private function assignOccupiedLocation(location:Location):void
		{
			if (location.id == LocationConstants.OBSTACLE)
			{
				// this can be only a user unit
				location.filter = MapConstants.LOCATION_ONLY_USER_WEAPON_OCCUPIED_FILTER;
			}
			else
			{
				// this can be only a barricade
				location.id = LocationConstants.OBSTACLE;
				location.filter = MapConstants.LOCATION_ONLY_BARRICADE_OCCUPIED_FILTER;
			}
			
			// need to clear the memorized value
			latestTestedLocation = null;
		}
		
		public function clearSpot(x:int, y:int):void
		{
			var location:Location = currentMap.grid.generateLocationFromXY(x, y);
			
			clearLocationOccupation(location);
		}
		
		private function clearLocationOccupation(location:Location):void
		{
			if (location.filter == MapConstants.LOCATION_ONLY_BARRICADE_OCCUPIED_FILTER)
			{
				// need to completely clear the location
				location.id = LocationConstants.EMPTY;
				location.filter = MapConstants.LOCATION_EMPTY_FILTER;
			}
			else if (location.filter == MapConstants.LOCATION_ONLY_USER_WEAPON_OCCUPIED_FILTER)
				location.filter = MapConstants.LOCATION_ONLY_USER_WEAPON_FREE_FILTER;
			
			// need to clear the memorized value
			latestTestedLocation = null;
		}
		
		public function clearValidation():void
		{
			gs.background.graphics.clear();
		}
		
		public function spotIsOverAnyTrajectory(x:Number, y:Number):Boolean
		{
			var snapLocation:Location = currentMap.grid.getElement(x, y);
			
			for each (var trajectory:ArrayList in trajectories)
				for each (var location:Location in trajectory.source)
					if (location.indexX == snapLocation.indexX && location.indexY == snapLocation.indexY)
						return true;
			
			return false;
		}
		
		//////// working with traffic lights
		
		public function registerTrafficLight(trafficLight:TrafficLight):void
		{
			trafficLights.push(trafficLight);
		}
		
		public function toggleAllTrafficLights():void
		{
			for each(var trafficLight:TrafficLight in trafficLights)
				trafficLight.toggle();
				
			clearTrajectories();
			generateTrajectories();
			visualizeTrajectories();
			clearValidation();
		}
	
	}

}