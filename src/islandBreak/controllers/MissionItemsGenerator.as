package islandBreak.controllers
{
	import flash.geom.Point;
	import islandBreak.supportClasses.resources.EnemyWeaponLocationConfig;
	import supportClasses.resources.WeaponResources;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	import weapons.user.UserCannon;
	import weapons.user.UserMachineGunTower;
	import weapons.user.UserPlane;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class MissionItemsGenerator
	{
		public static function generateItemsForMission(missionIndex:int):Array
		{
			var itemsArray:Array = [];
			
			var itemInfos:Array = EnemyWeaponLocationConfig.CONFIG[missionIndex];
			
			for each (var info:Object in itemInfos)
			{
				var item:IWeapon = null;
				
				if (info.name == WeaponResources.USER_CANNON)
					item = new UserCannon(info.level);
				else if (info.name == WeaponResources.USER_MACHINE_GUN)
					item = new UserMachineGunTower(info.level);
				else if (info.name == WeaponResources.USER_AIR_SUPPORT)
				{
					item = new UserPlane(info.level);
					UserPlane(item).anchor = new Point(info.x, info.y);
				}
				
				item.x = info.x;
				item.y = info.y;
				itemsArray.push(item);
			}
			
			return itemsArray;
		}
	}

}