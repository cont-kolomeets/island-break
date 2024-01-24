/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.gameInfo
{
	import flash.display.BitmapData;
	import supportClasses.resources.LevelsInfoResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * LevelInfo contains information about a level.
	 */
	public class LevelInfo
	{
		
		public static function toObject(levelInfo:LevelInfo):Object
		{
			var obj:Object = new Object();
			obj.available = levelInfo.available;
			obj.index = levelInfo.index;
			obj.passed = levelInfo.passed;
			obj.starsEarned = levelInfo.starsEarned;
			obj.hardModePassed = levelInfo.hardModePassed;
			obj.unrealModePassed = levelInfo.unrealModePassed;
			
			return obj;
		}
		
		public static function fromObject(obj:Object):LevelInfo
		{
			var levelInfo:LevelInfo = new LevelInfo(0, false, false, 0);
			
			levelInfo.available = Boolean(obj.available);
			levelInfo.index = int(obj.index);
			levelInfo.passed = Boolean(obj.passed);
			levelInfo.starsEarned = int(obj.starsEarned);
			levelInfo.hardModePassed = obj.hardModePassed;
			levelInfo.unrealModePassed = obj.unrealModePassed;
			
			return levelInfo;
		}
		
		///////////
		
		// indicates whether this level is available to play.
		public var available:Boolean = false;
		
		// indicates whether this level is paseed	
		public var passed:Boolean = false;
		
		// zero-based index
		public var index:int = 0;
		
		// number of stars earned
		public var starsEarned:int = 0;
		
		public var hardModePassed:Boolean = false;
		public var unrealModePassed:Boolean = false;
		
		public function LevelInfo(index:int, available:Boolean, passed:Boolean, starsEarned:int)
		{
			this.index = index;
			this.available = available;
			this.starsEarned = starsEarned;
			this.passed = passed;
		}
		
		//////////
		
		public function get name():String
		{
			return LevelsInfoResources.getLevelNameByIndex(index);
		}
		
		public function get description():String
		{
			return LevelsInfoResources.getLevelDescriptionByIndex(index);
		}
		
		public function get bitMapIconSmall():BitmapData
		{
			return LevelsInfoResources.getLevelImageBitmapByIndex(index, false).bitmapData;
		}
		
		public function get bitMapIconBig():BitmapData
		{
			return LevelsInfoResources.getLevelImageBitmapByIndex(index, true) ? LevelsInfoResources.getLevelImageBitmapByIndex(index, true).bitmapData : null;
		}
		
		public function get iconSmall():Class
		{
			return LevelsInfoResources.getLevelImageClassByIndex(index, false);
		}
		
		public function get iconBig():Class
		{
			return LevelsInfoResources.getLevelImageClassByIndex(index, true);
		}
	}

}