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
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PathUtil
	{
		public static function locationIsPassable(location:Location):Boolean
		{
			return (location.id == LocationConstants.EMPTY);
		}
		
		// returns true if passing from one location to the other does not imply cutting a corner of a wall
		public static function locationsCrossCorner(location1:Location, location2:Location, grid:GridArray):Boolean
		{
			return (!locationIsPassable(grid.getElementAtIndex(location1.indexX, location2.indexY)) || !locationIsPassable(grid.getElementAtIndex(location2.indexX, location1.indexY)));
		}
		
		///////////// Calculation of location parameters
		
		private static function calcG(location:Location):void
		{
			if (location.parent)
			{
				var dG:Number = 0;
				
				if (location.position == LocationConstants.FACIAL_HOR)
					dG = 10.5;
				else if (location.position == LocationConstants.FACIAL_VERT)
					dG = 9.5;
				else
					dG = 14;
				
				location.G = location.parent.G + dG;
			}
		}
		
		private static function calcH(location:Location, destination:Location):void
		{
			var HNormal:int = 10 * NSMath.abs(location.indexX - destination.indexX) + 10 * NSMath.abs(location.indexY - destination.indexY);
			
			// if this location has a linked one, use it instead
			if (location.linkedLocation)
			{
				var HLinked:int = 10 * NSMath.abs(location.linkedLocation.indexX - destination.indexX) + 10 * NSMath.abs(location.linkedLocation.indexY - destination.indexY);
				location.H = Math.min(HNormal, HLinked);
			}
			else
				location.H = HNormal;
		}
		
		public static function calcF(location:Location, destination:Location):void
		{
			// cost that takes to move from the current position to the next one
			// result = G(parent) + G(step to move from parent to this location)
			calcG(location);
			// estimated manhattan distance from this location to the end point
			calcH(location, destination);
			// F is the final cost for this location
			// this value is considered to pick the best one
			location.F = location.G + location.H;
		}
		
		public static function hashIsEmpty(hash:Object):Boolean
		{
			for (var id:String in hash)
				if (hash[id] != undefined)
					return false;
			
			return true;
		}
	}

}