/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources.waveConfigs.composing
{
	import infoObjects.WeaponInfo;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ComposedWaveObjectInfo
	{
		public var name:String = null;
		
		public var level:int = 0;
		
		public var pathIndex:int = 0;
		
		public var weaponInfo:WeaponInfo = null;
		
		public function ComposedWaveObjectInfo(name:String, level:int, pathIndex:int = 0)
		{
			this.name = name;
			this.level = level;
			this.pathIndex = pathIndex;
		}
	
	}

}