/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WaveInfo
	{
		public var waveCount:int = 0;
		
		private var hash:Object = {};
		
		private var sortedArray:Array = [];
		
		public function registerUnit(weaponInfo:WeaponInfo, count:int):void
		{
			var infoObject:Object = {name: weaponInfo.name, count: count, weaponInfo: weaponInfo};
			sortedArray.push(infoObject);
			hash[weaponInfo.name] = infoObject;
		}
		
		public function getNumUnits():int
		{
			return sortedArray.length;
		}
		
		public function getCountForUnitAt(index:int):int
		{
			var obj:Object = sortedArray[index];
			
			if (obj)
				return obj.count;
			
			return -1;
		}
		
		public function getCountForName(name:String):int
		{
			var obj:Object = hash[name];
			
			if (obj)
				return obj.count;
			
			return -1;
		}
		
		public function getNameForUnitAt(index:int):String
		{
			var obj:Object = sortedArray[index];
			
			if (obj)
				return obj.name;
			
			return null;
		}
		
		public function getInfoForUnitAt(index:int):WeaponInfo
		{
			var obj:Object = sortedArray[index];
			
			if (obj)
				return obj.weaponInfo;
			
			return null;
		}
	}

}