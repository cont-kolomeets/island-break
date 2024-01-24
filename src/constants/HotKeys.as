/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package constants
{
	import infoObjects.WeaponInfo;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class HotKeys
	{
		public static const AIR_SUPPORT:String = "W";
		
		public static const BOMB_SUPPORT:String = "Q";
		
		public static const CANNON:String = "1";
		
		public static const MACHINE_GUN:String = "2";
		
		public static const ELECTRIC_TOWER:String = "3";
		
		public static const REPAIR_CENTER:String = "4";
		
		public static function getHotKeyForWeaponInfo(weaponInfo:WeaponInfo):String
		{
			if (weaponInfo.level > 0)
				return null;
			
			switch (weaponInfo.weaponId)
			{
				case WeaponResources.USER_CANNON: 
					return CANNON;
				case WeaponResources.USER_MACHINE_GUN: 
					return MACHINE_GUN;
				case WeaponResources.USER_ELECTRIC_TOWER: 
					return ELECTRIC_TOWER;
				case WeaponResources.USER_REPAIR_CENTER: 
					return REPAIR_CENTER;
			}
			
			return null;
		}
	
	}

}