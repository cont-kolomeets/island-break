/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia.supportClasses 
{
	import supportClasses.resources.WeaponResources;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponSelector 
	{
		
		public static function getUserGroundWeaponInfos():Array
		{
			return [
				//WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_OBSTACLE, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_CANNON, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_CANNON, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_CANNON, 2),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_MACHINE_GUN, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_MACHINE_GUN, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_MACHINE_GUN, 2),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_ELECTRIC_TOWER, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_ELECTRIC_TOWER, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_ELECTRIC_TOWER, 2),
			];
		}
		
		public static function getUserAirWeaponInfos():Array
		{
			return [
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_AIR_SUPPORT, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_AIR_SUPPORT, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_AIR_SUPPORT, 2),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_BOMB_SUPPORT, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_BOMB_SUPPORT, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_BOMB_SUPPORT, 2),
			];
		}
		
		public static function getUserRepairCenterInfos():Array
		{
			return [
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_REPAIR_CENTER, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_REPAIR_CENTER, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.USER_REPAIR_CENTER, 2),
			];
		}
		
		///////////////////
		
		public static function getEnemyLightAndFastWeaponInfos():Array
		{
			return [
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_MOBILE_VEHICLE, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_MOBILE_VEHICLE, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_MOBILE_VEHICLE, 2),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_WALKING_ROBOT, 0),
			];
		}
		
		public static function getEnemyArmoredWeaponInfos():Array
		{
			return [
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_TANK, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_TANK, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_WALKING_ROBOT, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_WALKING_ROBOT, 2),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_BOMBER_TANK, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_BOMBER_TANK, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_FACTORY_TANK, 0),
			];
		}
		
		public static function getEnemySpecialWeaponInfos():Array
		{
			return [
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_ENERGY_BALL, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_ENERGY_BALL, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_INVISIBLE_TANK, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_INVISIBLE_TANK, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_REPAIR_TANK, 0),
			];
		}
		
		public static function getEnemyAircraftWeaponInfos():Array
		{
			return [
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_PLANE, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_PLANE, 1),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_PLANE, 2),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_HELICOPTER, 0),
				WeaponResources.getWeaponInfoByIDAndLevel(WeaponResources.ENEMY_HELICOPTER, 1),
			];
		}
		
	}

}