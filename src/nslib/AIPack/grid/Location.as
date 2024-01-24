/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.grid
{
	
	/**
	 * ...
	 * @author Alex
	 */
	public class Location
	{
		private static var uniqueID:int = 0;
		
		public var uniqueKey:String = "" + uniqueID++;
		
		public var indexX:Number;
		public var indexY:Number;
		
		public var parent:Location;
		public var status:String = LocationConstants.NONE;
		public var position:String = LocationConstants.NONE;
		
		// efficiency coefficient. F = G + H.
		public var F:int = 0;
		
		// full route
		public var G:int = 0;
		
		// estimation to destination
		public var H:int = 0;
		
		public var age:int = 0;
		
		public var seenAsEmptyCount:int = 0;
		
		// used for teleports
		public var linkedLocation:Location = null;
		
		public var color:int = -1;
		
		public var directionRestriction:String = null;
		
		public var filter:String = null;
		
		///////////////////////////////////////////////
		
		public function Location(indexX:Number, indexY:Number, id:String = "none", x:Number = NaN, y:Number = NaN)
		{
			this.indexX = indexX;
			this.indexY = indexY;
			this.id = id;
			_x = x;
			_y = y;
		}
		
		///////////////////////////////////////////////
		
		//----------------------------------
		//  x
		//----------------------------------
		
		private var _x:Number = NaN;
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
			
			syncWithRestrictedLocations();
		}
		
		//----------------------------------
		//  y
		//----------------------------------
		
		private var _y:Number = NaN;
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
			
			syncWithRestrictedLocations();
		}
		
		//----------------------------------
		//  id
		//----------------------------------
		
		private var _id:String;
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
			age = 0;
			
			syncWithRestrictedLocations();
		}
		
		//----------------------------------
		//  crossPathingEnabled
		//----------------------------------
		
		private var horizontalLocation:Location = null;
		
		private var verticalLocation:Location = null;
		
		private var _crossPathingEnabled:Boolean = false;
		
		public function get crossPathingEnabled():Boolean
		{
			return _crossPathingEnabled;
		}
		
		public function set crossPathingEnabled(value:Boolean):void
		{
			_crossPathingEnabled = value;
			
			if (!value)
			{
				horizontalLocation = null;
				verticalLocation = null;
			}
			else
			{
				horizontalLocation = this.copy();
				horizontalLocation.directionRestriction = LocationConstants.PASSING_HORIZONTAL;
				
				verticalLocation = this.copy();
				verticalLocation.directionRestriction = LocationConstants.PASSING_VERTICAL;
			}
		}
		
		/////////////////////// Reseting properties
		
		public function resetPathProperties(removeLinkedLocation:Boolean = false):void
		{
			F = 0;
			G = 0;
			H = 0;
			position = LocationConstants.NONE;
			status = LocationConstants.NONE;
			parent = null;
			
			if (removeLinkedLocation)
				linkedLocation = null;
			
			if (horizontalLocation)
				horizontalLocation.resetPathProperties();
			
			if (verticalLocation)
				verticalLocation.resetPathProperties();
		}
		
		public function resetAllProperites():void
		{
			color = -1;
			crossPathingEnabled = false;
			
			resetPathProperties(true);
		}
		
		/////////////////////// Synchronizing properties
		
		private function syncWithRestrictedLocations():void
		{
			if (horizontalLocation)
				syncWithLocation(horizontalLocation);
			if (verticalLocation)
				syncWithLocation(verticalLocation);
		}
		
		private function syncWithLocation(location:Location):void
		{
			location.x = this.x;
			location.y = this.y;
			location.id = this.id;
		}
		
		/////////////////////// Working with restricted locations
		
		public function getRestrictedLocationForRelativeOne(relativeLocation:Location):Location
		{
			if (!crossPathingEnabled)
				return null;
			
			if (relativeLocation.indexX == this.indexX && Math.abs(relativeLocation.indexY - this.indexY) == 1)
				return verticalLocation;
			
			if (relativeLocation.indexY == this.indexY && Math.abs(relativeLocation.indexX - this.indexX) == 1)
				return horizontalLocation;
			
			return null;
		}
		
		public function canGenerateRestrictedOffset():Boolean
		{
			return (directionRestriction && parent);
		}
		
		public function getAllowedHorizontalOffset():Number
		{
			if (directionRestriction == null)
				return NaN;
			
			if (directionRestriction == LocationConstants.PASSING_HORIZONTAL)
			{
				if (!parent)
					return NaN;
				else
					return (this.indexX - parent.indexX);
			}
			else
				return 0;
		}
		
		public function getAllowedVerticalOffset():Number
		{
			if (directionRestriction == null)
				return NaN;
			
			if (directionRestriction == LocationConstants.PASSING_VERTICAL)
			{
				if (!parent)
					return NaN;
				else
					return (this.indexY - parent.indexY);
			}
			else
				return 0;
		}
		
		//////////////////// Util methods
		
		public function copy():Location
		{
			return new Location(this.indexX, this.indexY, this.id, this.x, this.y);
		}
		
		public function toString():String
		{
			return "indexX: " + indexX + ", indexY: " + indexY + ", id: " + id + ", x = " + x + ", y = " + y;
		}
	
	}

}