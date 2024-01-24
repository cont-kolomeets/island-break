/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.pathFollowing
{
	import nslib.AIPack.grid.GridArray;
	import nslib.AIPack.grid.Location;
	import nslib.AIPack.grid.LocationConstants;
	import nslib.AIPack.pathFollowing.pathOptimization.PathOptimizationUtil;
	import nslib.AIPack.pathFollowing.pathOptimization.PatternIdentifier;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class PathFinder
	{
		// maximum number of iterations before finding is given up
		public var maxNumIterations:int = 300;
		
		private var grid:GridArray;
		
		// list of cells to consider
		private var openList:Array = [];
		private var checkedLocationsHash:Object = {};
		
		// flags
		private var stopFinding:Boolean = false;
		private var destinationReached:Boolean = false;
		
		// starting point
		private var startingLocation:Location;
		private var destination:Location;
		
		/// support classes
		
		private var patternIdentifier:PatternIdentifier = new PatternIdentifier();
		
		//////////////////
		
		public function PathFinder(grid:GridArray)
		{
			this.grid = grid;
		}
		
		//////////////////
		
		public function findPath(start:Location, finish:Location):Array
		{
			// reseting flags
			openList.length = 0;
			clearLocations();
			checkedLocationsHash = {};
			destinationReached = false;
			stopFinding = false;
			startingLocation = start;
			destination = finish;
			
			addToOpenListAndOpen(start);
			
			start.id = LocationConstants.EMPTY;
			finish.id = LocationConstants.EMPTY;
			
			for (var i:int = 0; i < maxNumIterations && !stopFinding; i++)
				checkOpenList();
			
			// if the destination location has been reached
			if (destinationReached)
				return retracePath();
			
			// otherwise just return an empty array
			return [];
		}
		
		private function checkOpenList():void
		{
			var bestLocation:Location;
			var minF:int = int.MAX_VALUE;
			
			// if there is no location to check
			// just leave
			if (PathUtil.hashIsEmpty(openList))
			{
				stopFinding = true;
				return;
			}
			
			for each (var location:Location in openList)
				if (location && location.F <= minF)
				{
					minF = location.F;
					bestLocation = location;
				}
			
			// if there is no proper location
			// just leave
			if (!bestLocation)
			{
				stopFinding = true;
				return;
			}
			
			// need to check all surrounding locations
			checkAround(bestLocation);
		}

		
		// returns true if the location is passable
		private function locationIsPassable(location:Location):Boolean
		{
			return PathUtil.locationIsPassable(location);
		}
		
		// returns true if passing from one location to the other does not imply cutting a corner of a wall
		private function locationsCrossCorner(location1:Location, location2:Location):Boolean
		{
			return PathUtil.locationsCrossCorner(location1, location2, grid);
		}
		
		// checking all surrounding locations
		private function checkAround(location:Location):void
		{
			// if the location is restricted check only one direction
			if (location.canGenerateRestrictedOffset())
			{
				checkSurroundingLocation(location, location.getAllowedHorizontalOffset(), location.getAllowedVerticalOffset());
			}
			else
				// otherwise check in all directions
				// for x
				for (var i:int = -1; i <= 1; i++)
					// for y
					for (var j:int = -1; j <= 1; j++)
						// do not consider the location itself, only the surrounding ones
						if (i != 0 || j != 0)
						{
							if (checkSurroundingLocation(location, i, j))
								break;
						}
			
			// since this location will never be checked we need to remove it from the open list
			removeFromOpenListAndClose(location);
		}
		
		// returns true if the search should be stopped
		private function checkSurroundingLocation(parentLocation:Location, relativeIndexX:int, relativeIndexY:int):Boolean
		{
			var surrLocation:Location = grid.getElementAtIndex(parentLocation.indexX + relativeIndexX, parentLocation.indexY + relativeIndexY);
			
			// if for some reason a restricted location could not be retrieved, just leave
			if (!surrLocation)
				return false;
			
			// if the location represents an intersection
			if (surrLocation.crossPathingEnabled)
			{
				// get the real restricted location
				// and work with it
				surrLocation = surrLocation.getRestrictedLocationForRelativeOne(parentLocation);
				
				// if for some reason a restricted location could not be retrieved, just leave
				if (!surrLocation)
					return false;
			}
			
			// check for basic conditions:
			// 1: location is passable
			// 2: moving to this location will not cross a corner of a wall
			// 3: location has never been checked
			if (locationIsPassable(surrLocation) && surrLocation.status != LocationConstants.CLOSED && !locationsCrossCorner(parentLocation, surrLocation))
			{
				if (processSurroundingLocationPassedRestrictions(surrLocation, parentLocation, relativeIndexX, relativeIndexY))
					return true;
				
				if (surrLocation.linkedLocation)
					if (processSurroundingLocationPassedRestrictions(surrLocation.linkedLocation, parentLocation, 0, 0))
						return true;
			}
			
			return false;
		}
		
		// returns true if the search should be stopped
		private function processSurroundingLocationPassedRestrictions(surrLocation:Location, parentLocation:Location, relativeIndexX:int, relativeIndexY:int):Boolean
		{
			// assigning parent
			surrLocation.parent = parentLocation;
			
			// assigning relative position
			if (relativeIndexX == 0 && relativeIndexY != 0)
				surrLocation.position = LocationConstants.FACIAL_VERT;
			else if (relativeIndexX != 0 && relativeIndexY == 0)
				surrLocation.position = LocationConstants.FACIAL_HOR;
			else
				surrLocation.position = LocationConstants.DIAGONAL;
			
			// if location is not in the open list yet
			if (surrLocation.status != LocationConstants.OPEN)
			{
				addToOpenListAndOpen(surrLocation);
				
				if (surrLocation.uniqueKey == destination.uniqueKey)
				{
					stopFinding = true;
					destinationReached = true;
					return true;
				}
			}
			// if a location is already in the open list
			// we need to recalc parameters for the location
			else
			{
				var newG:Number = parentLocation.G;
				
				if (surrLocation.position == LocationConstants.FACIAL_HOR)
					newG += 10.5;
				else if (surrLocation.position == LocationConstants.FACIAL_VERT)
					newG += 9.5;
				else
					newG += 14;
				
				if (surrLocation.G < newG)
					PathUtil.calcF(surrLocation, destination);
			}
			
			return false;
		}
		
		////////////// retracing path
		
		private function retracePath():Array
		{
			var resultPath:Array = [];
			
			addLocationToArray(resultPath, destination);
			
			resultPath = optimizePath(resultPath);
			
			return resultPath;
		}
		
		// recursive function to trace all the chain of locations
		private function addLocationToArray(array:Array, location:Location):void
		{
			// calc real coordinates for a location
			if (isNaN(location.x) || isNaN(location.y))
				grid.calcCoordinatesForLocationAt(location.indexX, location.indexY);
			
			array.push(location);
			if (location.parent != null)
				addLocationToArray(array, location.parent);
		}
		
		////////////// Add/remove from the open list
		
		private function addToOpenListAndOpen(location:Location):void
		{
			openList[location.uniqueKey] = location;
			location.status = LocationConstants.OPEN;
			checkedLocationsHash[location.uniqueKey] = location;
			PathUtil.calcF(location, destination);
		}
		
		private function removeFromOpenListAndClose(location:Location):void
		{
			delete openList[location.uniqueKey];
			
			location.status = LocationConstants.CLOSED;
		}
		
		////////
		
		public function clearLocations():void
		{
			for each (var location:Location in checkedLocationsHash)
				location.resetPathProperties();
		}
		
		////////////// Path optimization
		
		private function optimizePath(path:Array):Array
		{
			var firstIteration:Array = PathOptimizationUtil.performInitialOptimization(path, grid);
			
			var secondIteration:Array = null;
			
			if (firstIteration)
				secondIteration = patternIdentifier.performPatternBasedOptimization(firstIteration, grid);
			
			return firstIteration ? secondIteration : [];
		}
	
	}

}