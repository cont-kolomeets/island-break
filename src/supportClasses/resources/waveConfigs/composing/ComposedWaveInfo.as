/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources.waveConfigs.composing
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ComposedWaveInfo
	{
		public var delayBeforeWave:int = 0;
		
		public var delayAfterWave:int = 0;
		
		public var delayBetweenUnits:Array = null;
		
		public var tipIndex:int = -1;
		
		///////
		
		public function ComposedWaveInfo()
		{
		
		}
		
		//////
		
		private var hash:Object = {};
		
		private var _waveObjects:Array = null;
		
		public function get waveObjects():Array
		{
			return _waveObjects;
		}
		
		public function set waveObjects(value:Array):void
		{
			_waveObjects = value;
			
			hash = {};
			
			for each (var wo:ComposedWaveObjectInfo in value)
			{
				var key:String = wo.name + wo.level;
				var keyWithPath:String = wo.name + wo.level + wo.pathIndex;
				
				if (hash[key] == undefined)
					hash[key] = 0;
				else
					hash[key] = int(hash[key]) + 1;
				
				if (hash[keyWithPath] == undefined)
					hash[keyWithPath] = 0;
				else
					hash[keyWithPath] = int(hash[keyWithPath]) + 1;
			}
		}
		
		/////////////
		
		public function getNumUnits(name:String, level:int):int
		{
			return int(hash[name + level]);
		}
		
		public function getNumUnitsForPath(name:String, level:int, pathIndex:int):int
		{
			return int(hash[name + level + pathIndex]);
		}
		
		//// statistics
		
		public function calcAvgParameter(parameterName:String, pathIndex:int = -1):Number
		{
			var sumValue:Number = 0;
			var count:int = 0;
			
			for each (var wo:ComposedWaveObjectInfo in waveObjects)
			{
				if (pathIndex != -1 && wo.pathIndex != pathIndex)
					continue;
				
				sumValue += isNaN(wo.weaponInfo[parameterName]) ? 0 : Number(wo.weaponInfo[parameterName]);
				count++;
			}
			
			return Number(sumValue / count);
		}
	
	}

}