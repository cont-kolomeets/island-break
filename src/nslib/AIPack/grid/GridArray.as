/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.grid
{
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class GridArray
	{
		// if 'true' the grid cannot be expanded any more
		public var restictBounds:Boolean = false;
		public var gridResolution:Number = 20;
		public var gridOffsetX:Number = 0;
		public var gridOffsetY:Number = 0;
		public var defaultLocationID:String = LocationConstants.NONE;
		public var indexXMin:Number = Number.POSITIVE_INFINITY;
		public var indexXMax:Number = Number.NEGATIVE_INFINITY;
		public var indexYMin:Number = Number.POSITIVE_INFINITY;
		public var indexYMax:Number = Number.NEGATIVE_INFINITY;
		private var source:Array = [];
		
		public function GridArray()
		{
		}
		
		public function getElement(x:int, y:int):Location
		{
			var indexX:int = convertCoordinateXToIndex(x);
			var indexY:int = convertCoordinateYToIndex(y);
			
			if (source[indexY] is Array)
				if ((source[indexY] as Array)[indexX])
					return (source[indexY] as Array)[indexX];
			
			setElementAt(defaultLocationID, indexX, indexY);
			
			return getElementAtIndex(indexX, indexY);
		}
		
		public function getElementAtIndex(indexX:int, indexY:int):Location
		{
			if (source[indexY] is Array)
				if ((source[indexY] as Array)[indexX])
					return (source[indexY] as Array)[indexX];
			
			if (!setElementAt(defaultLocationID, indexX, indexY))
				return null;
			
			return getElementAtIndex(indexX, indexY);
		}
		
		public function setElement(id:String, x:int, y:int):void
		{
			var indexX:int = convertCoordinateXToIndex(x);
			var indexY:int = convertCoordinateYToIndex(y);
			
			setElementAt(id, indexX, indexY);
		}
		
		// returns true if successful
		public function setElementAt(id:String, indexX:int, indexY:int):Boolean
		{
			if (restictBounds && indicesAreOutOfBounds(indexX, indexY))
				return false;
			
			if (source[indexY] is Array)
			{
				if ((source[indexY] as Array)[indexX])
				{
					Location((source[indexY] as Array)[indexX]).id = id;
					return true;
				}
				else
					(source[indexY] as Array)[indexX] = new Location(indexX, indexY, id, convertIndexXToCoordinate(indexX), convertIndexYToCoordinate(indexY));
			}
			else
			{
				var array:Array = [];
				array[indexX] = new Location(indexX, indexY, id, convertIndexXToCoordinate(indexX), convertIndexYToCoordinate(indexY));
				source[indexY] = array;
			}
			
			updateMinMaxIndexes(indexX, indexY);
			
			return true;
		}
		
		private function updateMinMaxIndexes(indexX:int, indexY:int):void
		{
			if (indexXMax < indexX)
				indexXMax = indexX;
			if (indexXMin > indexX)
				indexXMin = indexX;
			
			if (indexYMax < indexY)
				indexYMax = indexY;
			if (indexYMin > indexY)
				indexYMin = indexY;
		}
		
		private function convertCoordinateXToIndex(x:int):int
		{
			return NSMath.round((x - gridOffsetX)/ gridResolution);
		}
		
		private function convertCoordinateYToIndex(y:int):int
		{
			return NSMath.round((y - gridOffsetY) / gridResolution);
		}
		
		private function convertIndexXToCoordinate(i:int):Number
		{
			return gridOffsetX + i * gridResolution;
		}
		
		private function convertIndexYToCoordinate(j:int):Number
		{
			return gridOffsetY + j * gridResolution;
		}
		
		public function print():void
		{
			//trace("max " + indexYMax);
			//trace("min " + indexYMin);
		
		/*for (var y:int = indexYMin; y <= indexYMax; y++)
		   if (source[y] is Array)
		 trace(source[y] as Array);*/
		}
		
		public function createRandomGrid(indexXFrom:int, indexXTo:int, indexYFrom:int, indexYTo:int, thickness:Number = 0.5):void
		{
			for (var i:int = indexXFrom; i <= indexXTo; i++)
				for (var j:int = indexYFrom; j <= indexYTo; j++)
					setElementAt((NSMath.random() < thickness) ? LocationConstants.OBSTACLE : LocationConstants.EMPTY, i, j);
		}
		
		// returns a grid location for the specified coordinates
		public function generateLocationFromXY(x:Number, y:Number):Location
		{
			return getElement(x, y);
		}
		
		public function calcCoordinatesForLocationAt(indexX:int, indexY:int):void
		{
			var location:Location = getElementAtIndex(indexX, indexY);
			location.x = convertIndexXToCoordinate(indexX);
			location.y = convertIndexYToCoordinate(indexY);
		}
		
		public function coordinatesAreOutOfBounds(x:Number, y:Number):Boolean
		{
			var indexX:int = convertCoordinateXToIndex(x);
			var indexY:int = convertCoordinateYToIndex(y);
			
			return indicesAreOutOfBounds(indexX, indexY);
		}
		
		public function indicesAreOutOfBounds(indexX:int, indexY:int):Boolean
		{
			return ((indexX < indexXMin) || (indexX > indexXMax) || (indexY < indexYMin) || (indexY > indexYMax));
		}
		
		public function clear():void
		{
			source.length = 0;
			indexXMin = Number.POSITIVE_INFINITY;
			indexXMax = Number.NEGATIVE_INFINITY;
			indexYMin = Number.POSITIVE_INFINITY;
			indexYMax = Number.NEGATIVE_INFINITY;
		}
	
	}

}