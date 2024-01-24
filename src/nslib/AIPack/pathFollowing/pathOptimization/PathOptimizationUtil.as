/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.pathFollowing.pathOptimization
{
	import nslib.AIPack.grid.GridArray;
	import nslib.AIPack.grid.Location;
	import nslib.AIPack.pathFollowing.PathUtil;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PathOptimizationUtil
	{
		private static var optimizationSuccess:Boolean = true;
		
		public static function performInitialOptimization(path:Array, grid:GridArray):Array
		{
			optimizationSuccess = true;
			
			var pathHash:Object = {};
			var optimizedPath:Array = [];
			// hash of locations added to the path
			var addedHash:Object = {};
			var doNotOptimizeHash:Object = {};
			
			for each (var location:Location in path)
			{
				pathHash[location.uniqueKey] = location;
				
				if (location.canGenerateRestrictedOffset())
				{
					doNotOptimizeHash[location.uniqueKey] = location;
					// mark all location around it for non-optimization
					for (var i:int = -1; i <= 1; i++)
						for (var j:int = -1; j <= 1; j++)
						{
							var surrLocation:Location = grid.getElementAtIndex(location.indexX + i, location.indexY + j);
							doNotOptimizeHash[surrLocation.uniqueKey] = surrLocation;
						}
				}
			}
			
			var usedHash:Object = {};
			
			addOptimizedBestLocation(path[0], optimizedPath, pathHash, addedHash, doNotOptimizeHash, 0, grid);
			
			if (!optimizationSuccess)
				return null;
				
			recalcChildParentRelationship(optimizedPath);
			
			return optimizedPath;
		}
		
		private static function addOptimizedBestLocation(location:Location, optimizedPath:Array, pathHash:Object, addedHash:Object, doNotOptimizeHash:Object, iteration:int, grid:GridArray):void
		{
			if (addedHash[location.uniqueKey] != undefined)
			{
				optimizationSuccess = false;
				return;
			}
			
			optimizedPath.push(location);
			addedHash[location.uniqueKey] = location;
			
			var bestLocation:Location = null;
			
			if (doNotOptimizeHash[location.uniqueKey] != undefined)
				bestLocation = location.parent;
			else if (location.linkedLocation && !addedHash[location.linkedLocation.uniqueKey])
				bestLocation = location.linkedLocation;
			else
				bestLocation = findBestLocationAround(location, pathHash, addedHash, grid);
			
			// if the best location has been found we need to process it
			if (bestLocation)
				addOptimizedBestLocation(bestLocation, optimizedPath, pathHash, addedHash, doNotOptimizeHash, ++iteration, grid);
		}
		
		private static function findBestLocationAround(location:Location, pathHash:Object, addedHash:Object, grid:GridArray):Location
		{
			// if location is the last in the chain just leave
			if (!location.parent)
				return null;
			
			var bestLocation:Location = location.parent;
			var minG:int = int.MAX_VALUE;
			
			// repeat a similar procedure as above
			for (var i:int = -1; i <= 1; i++)
				for (var j:int = -1; j <= 1; j++)
					if (i != 0 || j != 0)
					{
						var surrLocation:Location = grid.getElementAtIndex(location.indexX + i, location.indexY + j);
						
						// if for some reason a restricted location could not be retrieved, continue searching
						if (!surrLocation)
							continue;
						
						if (addedHash[surrLocation.uniqueKey] == undefined && pathHash[surrLocation.uniqueKey] && !PathUtil.locationsCrossCorner(location, surrLocation, grid) && PathUtil.locationIsPassable(surrLocation))
						{
							if (surrLocation.G < minG)
							{
								minG = surrLocation.G;
								bestLocation = surrLocation;
							}
						}
					}
			
			return bestLocation;
		}
		
		////
		
		private static function recalcChildParentRelationship(path:Array):void
		{
			var len:int = path.length;
			
			for (var i:int = 0; i < (len - 1); i++)
				path[i].parent = path[i + 1];
		}
	
	}

}