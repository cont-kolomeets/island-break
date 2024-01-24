/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects
{
	import supportClasses.WeaponType;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * WeaponInfo contains full information about a weapon's configuration, prices and descriptions.
	 * This class has only read-only settings. None of these properites should be changed.
	 */
	public class WeaponInfo extends Object
	{
		//------------------------------------------
		// Descriptive paramaters
		//------------------------------------------
		
		public var name:String = "name";
		public var weaponId:String = null;
		public var weaponType:String = WeaponType.NONE;
		
		// these parameters may be represented by a range
		public var armorDescription:String = null;
		public var hitThresholdDescription:String = null;
		public var hitPowerDescription:String = null;
		public var hitRadiusDescription:String = null;
		public var speedDescription:String = null;
		public var shootDelayDescription:String = null;
		public var missileShootDelayDescription:String = null;
		public var shockPowerDescription:String = null;
		public var repairPowerDescription:String = null;
		public var electricityResistanceDescrition:String = null;
		
		//------------------------------------------
		// Paramaters for tooltips
		//------------------------------------------
		
		public var iconSmall:Class = null;
		public var iconMiddle:Class = null;
		public var iconBig:Class = null;
		public var iconSmallForDisabledState:Class = null;
		public var iconSmallInGame:Class = null;
		public var generalDescription:String = null;
		// such as ["heavy armor", "slow speed"], wiil be used for the "New Enemy" popup.
		public var descriptiveParamters:Array = null;
		public var specialNotificationWhenFirstAppearing:String = null;
		
		//------------------------------------------
		// Paramaters for scores
		//------------------------------------------
		
		public var buyPrice:int = 0;
		public var sellPrice:int = 0;
		public var totalRepairPrice:int = 0;
		public var upgradePrice:int = 0;
		// in stars
		public var developmentPrice:int = 0;
		public var destroyBonus:int = 0;
		
		//------------------------------------------
		// Unit configuration
		//------------------------------------------
		
		public var level:int = 0;
		public var maxUpgradeLevel:int = 0;
		public var shootDelay:Number = 0;
		public var missileShootDelay:Number = 0;
		public var delayBeforeShooting:Number = 0;
		public var armor:Number = 0;
		public var hitRadius:Number = 0;
		public var hitPower:Number = 0;
		public var missileHitPowerMultiplier:Number = 1;
		public var hitThreshold:Number = 0;
		public var electricityResistance:Number = 0;
		public var electrolizingDuration:Number = 0;
		
		//public var bulletHitPower:Number = 0;
		public var bulletSpeed:Number = 0;
		public var motionSpeed:Number = 0;
		public var rotationSpeed:Number = 0;
		public var gunRotationSpeed:Number = 0;
		public var invincibilityDelay:Number = 0;
		public var buildingDelay:Number = 0;
		public var isMissileSupport:Boolean = false;
		public var isAmmoSupport:Boolean = false;
		public var canHitAircrafts:Boolean = false;
		public var canHitInvisibleUnits:Boolean = false;
		public var canFreezeUnits:Boolean = false;
		public var canRepairUnits:Boolean = false;
		
		public var workingTime:Number = 0;
		
		// special abilities
		public var canBecomeInvisible:Boolean = false;
		public var canMakeInvisible:Boolean = false;
		public var resistantToBullets:Boolean = false;
		public var resistantToElecticity:Boolean = false;
		
		//------------------------------------------
		// Constructor
		//------------------------------------------
		
		public function WeaponInfo()
		{
		}
		
		//------------------------------------------
		// Util method
		//------------------------------------------
		
		public static function fromXML(xml:XML):WeaponInfo
		{
			var info:WeaponInfo = new WeaponInfo();
			
			//------------------------------------------
			// Descriptive paramaters
			//------------------------------------------
			
			info.name = xml.@name;
			info.weaponId = xml.@weaponId;
			
			// these parameters may be represented by a range
			info.armorDescription = xml.@armorDescription;
			info.hitThresholdDescription = xml.@hitThresholdDescription;
			info.hitPowerDescription = xml.@hitPowerDescription;
			info.hitRadiusDescription = xml.@hitRadiusDescription;
			info.speedDescription = xml.@speedDescription;
			info.shootDelayDescription = xml.@shootDelayDescription;
			info.missileShootDelayDescription = xml.@missileShootDelayDescription;
			info.shockPowerDescription = xml.@shockPowerDescription;
			info.repairPowerDescription = xml.@repairPowerDescription;
			info.electricityResistanceDescrition = xml.@electricityResistanceDescrition;
			info.electrolizingDuration = xml.@electrolizingDuration;
			
			//------------------------------------------
			// Paramaters for tooltips
			//------------------------------------------
			
			info.generalDescription = xml.@generalDescription;
			info.descriptiveParamters = (xml.@descriptiveParamters != undefined) ? String(xml.@descriptiveParamters).split(",") : null;
			info.specialNotificationWhenFirstAppearing = xml.@specialNotificationWhenFirstAppearing;
			
			//------------------------------------------
			// Paramaters for scores
			//------------------------------------------
			
			info.buyPrice = xml.@buyPrice;
			info.sellPrice = xml.@sellPrice;
			info.totalRepairPrice = xml.@totalRepairPrice;
			info.upgradePrice = xml.@upgradePrice;
			info.developmentPrice = xml.@developmentPrice;
			info.destroyBonus = xml.@destroyBonus;
			
			//------------------------------------------
			// Unit configuration
			//------------------------------------------
			
			info.level = xml.@level;
			info.maxUpgradeLevel = xml.@maxUpgradeLevel;
			info.shootDelay = xml.@shootDelay;
			info.missileShootDelay = xml.@missileShootDelay;
			info.delayBeforeShooting = int(xml.@delayBeforeShooting);
			info.armor = xml.@armor;
			info.hitRadius = xml.@hitRadius;
			info.hitPower = xml.@hitPower;
			info.missileHitPowerMultiplier = xml.@missileHitPowerMultiplier != undefined ? xml.@missileHitPowerMultiplier : 1;
			info.hitThreshold = xml.@hitThreshold;
			info.electricityResistance = xml.@electricityResistance;
			//info.bulletHitPower = xml.@bulletHitPower;
			info.bulletSpeed = xml.@bulletSpeed;
			info.motionSpeed = xml.@motionSpeed;
			info.rotationSpeed = xml.@rotationSpeed;
			info.gunRotationSpeed = xml.@gunRotationSpeed;
			info.invincibilityDelay = xml.@invincibilityDelay;
			info.buildingDelay = xml.@buildingDelay;
			info.isMissileSupport = Boolean(String(xml.@isMissileSupport) == "true");
			info.isAmmoSupport = Boolean(String(xml.@isAmmoSupport) == "true");
			info.canHitAircrafts = Boolean(String(xml.@canHitAircrafts) == "true");
			info.canHitInvisibleUnits = Boolean(String(xml.@canHitInvisibleUnits) == "true");
			info.canFreezeUnits = Boolean(String(xml.@canFreezeUnits) == "true");
			info.canRepairUnits = Boolean(String(xml.@canRepairUnits) == "true");
			info.canBecomeInvisible = Boolean(String(xml.@canBecomeInvisible) == "true");
			info.canMakeInvisible = Boolean(String(xml.@canMakeInvisible) == "true");
			info.resistantToBullets = Boolean(String(xml.@resistantToBullets) == "true");
			info.resistantToElecticity = Boolean(String(xml.@resistantToElecticity) == "true");
			info.workingTime = xml.@workingTime;
			
			return info;
		}
	
	}

}