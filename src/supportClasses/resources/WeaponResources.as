/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources
{
	import infoObjects.WeaponInfo;
	import supportClasses.WeaponType;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponResources
	{
		//------------------------------------------
		// Available weaponIds : default
		//------------------------------------------
		
		public static const DEFAULT_WEAPON_ID:String = "defaultWeapon";
		
		//------------------------------------------
		// Available weaponIds : user
		//------------------------------------------
		
		public static const USER_CANNON:String = "cannon";
		
		public static const USER_MACHINE_GUN:String = "machineGun";
		
		public static const USER_ELECTRIC_TOWER:String = "electricTower";
		
		public static const USER_OBSTACLE:String = "obstacle";
		
		public static const USER_REPAIR_CENTER:String = "repairCenter";
		
		public static const USER_AIR_SUPPORT:String = "airSupport";
		
		public static const USER_BOMB_SUPPORT:String = "bombSupport";
		
		//------------------------------------------
		// Available weaponIds : enemy
		//------------------------------------------
		
		public static const ENEMY_MOBILE_VEHICLE:String = "mobileVehicle";
		
		public static const ENEMY_TANK:String = "tank";
		
		public static const ENEMY_PLANE:String = "plane";
		
		public static const ENEMY_HELICOPTER:String = "helicopter";
		
		public static const ENEMY_ENERGY_BALL:String = "energyBall";
		
		public static const ENEMY_WALKING_ROBOT:String = "walkingRobot";
		
		public static const ENEMY_INVISIBLE_TANK:String = "invisibleTank";
		
		public static const ENEMY_BOMBER_TANK:String = "bomberTank";
		
		public static const ENEMY_FACTORY_TANK:String = "factoryTank";
		
		public static const ENEMY_REPAIR_TANK:String = "repairTank";
		
		//------------------------------------------
		// collecting data
		//------------------------------------------
		
		private static var hash:Object = null;
		
		private static var userWeaponInfos:Array = null;
		
		private static var enemyWeaponInfos:Array = null;
		
		// this method should be called on application start.
		// it parses the config xml and fills the hash with references to
		// weapon infos.
		public static function initialize():void
		{
			hash = {};
			userWeaponInfos = [];
			enemyWeaponInfos = [];
			
			collectConfiguration(WeaponResourcesUserConfig.config, true);
			collectConfiguration(WeaponResourcesEnemyConfig.config, false);
		}
		
		private static function collectConfiguration(config:XML, isUserConfig:Boolean):void
		{
			var weaponsList:XMLList = config.weapon;
			
			for each (var w:XML in weaponsList)
			{
				var info:WeaponInfo = getWeaponInfoFromXML(w, isUserConfig);
				
				// assign type
				info.weaponType = isUserConfig ? WeaponType.USER : WeaponType.ENEMY;
				
				hash[info.weaponId + info.level] = info;
				
				if (info.weaponId != DEFAULT_WEAPON_ID && info.weaponId != USER_OBSTACLE)
				{
					if (isUserConfig)
						userWeaponInfos.push(info);
					else
						enemyWeaponInfos.push(info);
				}
			}
		}
		
		private static function getWeaponInfoFromXML(xml:XML, isUserConfig:Boolean):WeaponInfo
		{
			var info:WeaponInfo = WeaponInfo.fromXML(xml);
			
			if (isUserConfig)
			{
				info.iconSmall = WeaponUserImageResources.getSmallImageById(int(xml.@id));
				info.iconMiddle = WeaponUserImageResources.getMiddleImageById(int(xml.@id));
				info.iconBig = WeaponUserImageResources.getBigImageById(int(xml.@id));
				info.iconSmallForDisabledState = WeaponUserImageResources.getSmallImageForDisabledStateById(int(xml.@id));
				info.iconSmallInGame = WeaponUserImageResources.getSmallInGameImageById(int(xml.@id));
			}
			else
			{
				info.iconSmall = WeaponEnemyImageResources.getSmallImageById(int(xml.@id));
				//info.iconMiddle = WeaponEnemyImageResources.getMiddleImageById(int(xml.@id));
				info.iconBig = WeaponEnemyImageResources.getBigImageById(int(xml.@id));
				info.iconSmallForDisabledState = WeaponEnemyImageResources.getSmallImageForDisabledStateById(int(xml.@id));
				info.iconSmallInGame = WeaponEnemyImageResources.getSmallInGameImageById(int(xml.@id));
			}
			
			//traceWeaponInformation(info);
			
			return info;
		}
		
		private static function traceWeaponInformation(info:WeaponInfo):void
		{
			trace("*************************NEW WEAPON***************************************");
			
			trace(info.weaponId + "    level: " + info.level);
			trace("-----------------------------");
			
			//if(info.armor 
			trace("armorDescription = \"" + info.armor * 10 + "\""); // will be shown as HP in UI
			
			// will be shown as armor in UI
			if (info.hitThreshold < 2)
				trace("hitThresholdDescription = \"weak\"");
			else if (info.hitThreshold >= 2 && info.hitThreshold < 7)
				trace("hitThresholdDescription = \"medium\"");
			else if (info.hitThreshold >= 7 && info.hitThreshold < 20)
				trace("hitThresholdDescription = \"heavy\"");
			else if (info.hitThreshold >= 20)
				trace("hitThresholdDescription = \"very heavy\"");
			
			if (info.hitPower)
			{
				var hitPowerRange:String = "" + int(info.hitPower * 0.8) + "-" + int(info.hitPower * 1.2);
				trace("hitPowerDescription = \"" + hitPowerRange + "\"");
			}
			
			if (info.hitRadius)
			{
				if (info.hitRadius < 100)
					trace("hitRadiusDescription = \"low\"");
				else if (info.hitRadius >= 100 && info.hitRadius < 170)
					trace("hitRadiusDescription = \"average\"");
				else if (info.hitRadius >= 170 && info.hitRadius < 250)
					trace("hitRadiusDescription = \"long\"");
				else if (info.hitRadius >= 250)
					trace("hitRadiusDescription = \"very long\"");
			}
			
			if (info.motionSpeed)
			{
				if (info.motionSpeed < 0.8)
					trace("speedDescription = \"slow\"");
				else if (info.motionSpeed >= 0.8 && info.motionSpeed < 1.2)
					trace("speedDescription = \"average\"");
				else if (info.motionSpeed >= 1.2 && info.motionSpeed < 3)
					trace("speedDescription = \"fast\"");
				else if (info.motionSpeed >= 3)
					trace("speedDescription = \"very fast\"");
			}
			
			if (info.shootDelay)
			{
				if (info.shootDelay < 300)
					trace("shootDelayDescription = \"very fast\"");
				else if (info.shootDelay >= 300 && info.shootDelay < 700)
					trace("shootDelayDescription = \"fast\"");
				else if (info.shootDelay >= 700 && info.shootDelay < 3000)
					trace("shootDelayDescription = \"slow\"");
				else if (info.shootDelay >= 3000)
					trace("shootDelayDescription = \"very slow\"");
			}
			
			if (info.missileShootDelay)
			{
				if (info.missileShootDelay < 1000)
					trace("missileShootDelayDescription = \"very fast\"");
				else if (info.missileShootDelay >= 1000 && info.missileShootDelay < 2000)
					trace("missileShootDelayDescription = \"fast\"");
				else if (info.missileShootDelay >= 2000 && info.missileShootDelay < 5000)
					trace("missileShootDelayDescription = \"slow\"");
				else if (info.missileShootDelay >= 5000)
					trace("missileShootDelayDescription = \"very slow\"");
			}
		}
		
		// returns WeaponInfo by the specified weaponId.
		public static function getWeaponInfoByIDAndLevel(weaponId:String, level:int):WeaponInfo
		{
			return hash[weaponId + level] as WeaponInfo;
		}
		
		public static function getAllUserWeaponInfos():Array
		{
			return userWeaponInfos;
		}
		
		public static function getAllEnemyWeaponInfos():Array
		{
			return enemyWeaponInfos;
		}
	
	}

}