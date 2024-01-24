/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponResourcesUserConfig
	{
		
		public static const config:XML =
			
			<weapons>
				
				< weapon 
					id = "default" 
					weaponId = "defaultWeapon" 
					name = "Default Weapon" />
				
				< weapon 
					id = "0" 
					weaponId = "obstacle" 
					level = "0" 
					name = "Obstacle"
					generalDescription = "Useful for increasing travel path of units."
					
					buyPrice = "50"
					sellPrice = "25"
					totalRepairPrice = ""
					upgradePrice = "" />
				
				//--------------------------------------------------------------------------
				//
				//  Cannon
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "1" 
					weaponId = "cannon" 
					level = "0" 
					name = "Cannon Basic"
					generalDescription = "Cannon with average damage and a slow rate of fire. Good for dealing with armored units such as tanks."
					
					armorDescription = "2000"
					hitThresholdDescription = "weak"
					hitPowerDescription = "16-24"
					hitRadiusDescription = "average"
					shootDelayDescription = "very slow"
					
					buyPrice = "200"
					sellPrice = "150"
					totalRepairPrice = "50"
					upgradePrice = "300"
					developmentPrice="1"
					
					maxUpgradeLevel = "2"
					shootDelay = "5000"
					delayBeforeShooting = "2000"
					armor = "0.5"
					hitRadius = "150"
					hitPower = "20"
					bulletSpeed = "0.1"
					motionSpeed = "0"
					rotationSpeed = "0"
					gunRotationSpeed = "0.05"
					buildingDelay = "3000" 
					isAmmoSupport = "true"
					canHitAircrafts = "true"
					invincibilityDelay = "0" />
				
				< weapon 
					id = "2" 
					weaponId = "cannon" 
					level = "1" 
					name = "Cannon Intermediate"
					generalDescription = "Enhanced cannon with an improved rate of fire dealing more damage per shot."
					
					armorDescription = "4000"
					hitThresholdDescription = "weak"
					hitPowerDescription = "24-36"
					hitRadiusDescription = "long"
					shootDelayDescription = "very slow"
					
					buyPrice = "300"
					sellPrice = "350"
					totalRepairPrice = "100"
					upgradePrice = "500"
					developmentPrice="2"
					
					maxUpgradeLevel = "2"
					shootDelay = "4000"
					delayBeforeShooting = "1000"
					armor = "1"
					hitRadius = "175"
					hitPower = "30"
					bulletSpeed = "0.2"
					motionSpeed = ""
					rotationSpeed = ""
					gunRotationSpeed = "0.075"
					buildingDelay = "3000" 
					isAmmoSupport = "true"
					canHitAircrafts = "true"
					invincibilityDelay = "" />
				
				< weapon 
					id = "3" 
					weaponId = "cannon" 
					level = "2" 
					name = "Cannon Advanced"
					generalDescription = "Excellent tower equipped with missiles to strike at your enemies from a great distance."
					
					armorDescription = "6000"
					hitThresholdDescription = "weak"
					hitPowerDescription = "32-48/4-6"
					hitRadiusDescription = "long"
					shootDelayDescription = "very slow"
					missileShootDelayDescription = "slow"
					
					buyPrice = "500"
					sellPrice = "700"
					totalRepairPrice = "150"
					upgradePrice = ""
					developmentPrice="2"
					
					maxUpgradeLevel = "2"
					shootDelay = "3000"
					missileShootDelay="4000"
					delayBeforeShooting = "100"
					armor = "1.5"
					hitRadius = "200"
					hitPower = "40"
					bulletSpeed = "0.3"
					motionSpeed = ""
					rotationSpeed = ""
					gunRotationSpeed = "0.1"
					buildingDelay = "3000" 
					invincibilityDelay = ""
					isAmmoSupport = "true"
					isMissileSupport = "true"
					canHitAircrafts="true" />
				
				
				//--------------------------------------------------------------------------
				//
				//  Machine gun
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "4" 
					weaponId = "machineGun" 
					level = "0" 
					name = "M-Gun Basic"
					generalDescription = "Machine gun with a high rate of fire but little damage per shot. Good for handling lightly-armored & fast enemies."
					
					armorDescription = "1500"
					hitThresholdDescription = "weak"
					hitPowerDescription = "1"
					hitRadiusDescription = "average"
					shootDelayDescription = "very fast"
					
					buyPrice = "300"
					sellPrice = "200"
					totalRepairPrice = "75"
					upgradePrice = "400"
					developmentPrice="1"
					
					maxUpgradeLevel = "2"
					shootDelay = "100"
					armor = "0.5"
					hitRadius = "100"
					hitPower = "1"
					bulletSpeed = "0.3"
					motionSpeed = "0"
					rotationSpeed = "0"
					gunRotationSpeed = "0.3"
					buildingDelay = "3000" 
					isAmmoSupport = "true"
					canHitAircrafts = "true"
					invincibilityDelay = "0" />
				
				< weapon 
					id = "5" 
					weaponId = "machineGun" 
					level = "1" 
					name = "M-Gun Intermediate"
					generalDescription = "Tower with a highly improved rate of fire and reaction. Excellent against fast units and aircrafts."
					
					armorDescription = "3000"
					hitThresholdDescription = "weak"
					hitPowerDescription = "1-2"
					hitRadiusDescription = "average"
					shootDelayDescription = "very fast"
					
					buyPrice = "400"
					sellPrice = "475"
					totalRepairPrice = "100"
					upgradePrice = "500"
					developmentPrice="2"
					
					maxUpgradeLevel = "2"
					shootDelay = "90"
					armor = "0.75"
					hitRadius = "150"
					hitPower = "1.5"
					bulletSpeed = "0.5"
					motionSpeed = ""
					rotationSpeed = ""
					gunRotationSpeed = "0.4"
					buildingDelay = "3000" 
					isAmmoSupport = "true"
					canHitAircrafts = "true"
					invincibilityDelay = "" />
				
				< weapon 
					id = "6" 
					weaponId = "machineGun" 
					level = "2" 
					name = "M-Gun Advanced"
					generalDescription = "Tower with an amazing ability to obliterate all lightly-armored units."
					
					armorDescription = "4500"
					hitThresholdDescription = "weak"
					hitPowerDescription = "2"
					hitRadiusDescription = "long"
					shootDelayDescription = "very fast"
					
					buyPrice = "500"
					sellPrice = "800"
					totalRepairPrice = "150"
					upgradePrice = ""
					developmentPrice="2"
					
					maxUpgradeLevel = "2"
					shootDelay = "60"
					armor = "1"
					hitRadius = "200"
					hitPower = "2"
					bulletSpeed = "0.7"
					motionSpeed = ""
					rotationSpeed = ""
					gunRotationSpeed = "0.5"
					buildingDelay = "3000" 
					invincibilityDelay = ""
					isAmmoSupport = "true"
					canHitAircrafts="true" />
				
				
				//--------------------------------------------------------------------------
				//
				//  Electric tower
				//
				//--------------------------------------------------------------------------
				
				
				< weapon 
					id = "7" 
					weaponId = "electricTower" 
					level = "0" 
					name = "E-Tower Basic"
					generalDescription = "Casts armor piercing electric bolts at your enemies to damage their electronic parts. Slows units down by 20%."
					
					armorDescription = "1700"
					hitThresholdDescription = "weak"
					shockPowerDescription = "5-9"
					hitRadiusDescription = "average"
					shootDelayDescription = "very slow"
					
					buyPrice = "400"
					sellPrice = "275"
					totalRepairPrice = "100"
					upgradePrice = "600"
					developmentPrice="1"
					
					maxUpgradeLevel = "2"
					shootDelay = "3000"
					armor = "17"
					hitRadius = "100"
					hitPower = "7"
					electrolizingDuration = "3000"
					bulletSpeed = "2"
					motionSpeed = ""
					rotationSpeed = ""
					gunRotationSpeed = "0.1"
					buildingDelay = "3000" 
					invincibilityDelay = ""
					isAmmoSupport = "true"
					canHitInvisibleUnits = "true" />
				
				< weapon 
					id = "8" 
					weaponId = "electricTower" 
					level = "1" 
					name = "E-Tower Intermediate"
					generalDescription = "Capable of handling up to 2 enemies at a time dealing higher damage and slowing them down by 25-30%."
					
					armorDescription = "3500"
					hitThresholdDescription = "weak"
					shockPowerDescription = "7-11"
					hitRadiusDescription = "average"
					shootDelayDescription = "slow"
					
					buyPrice = "600"
					sellPrice = "700"
					totalRepairPrice = "150"
					upgradePrice = "800"
					developmentPrice="2"
					
					maxUpgradeLevel = "2"
					shootDelay = "800"
					armor = "35"
					hitRadius = "125"
					hitPower = "9"
					electrolizingDuration = "3000"
					bulletSpeed = "2"
					motionSpeed = ""
					rotationSpeed = ""
					gunRotationSpeed = "0.2"
					buildingDelay = "3000" 
					invincibilityDelay = ""
					isAmmoSupport = "true"
					canHitInvisibleUnits = "true" />
				
				< weapon 
					id = "9" 
					weaponId = "electricTower" 
					level = "2" 
					name = "E-Tower Advanced"
					generalDescription = "Handles up to 3 units at a time and deals out significant damage. Will easily stop your enemies’ advance."
					
					armorDescription = "5200"
					hitThresholdDescription = "weak"
					shockPowerDescription = "8-12"
					hitRadiusDescription = "long"
					shootDelayDescription = "fast"
					
					buyPrice = "800"
					sellPrice = "1200"
					totalRepairPrice = "200"
					upgradePrice = ""
					developmentPrice="2"
					
					maxUpgradeLevel = "2"
					shootDelay = "500"
					armor = "52"
					hitRadius = "140"
					hitPower = "10"
					electrolizingDuration = "3000"
					bulletSpeed = "2"
					motionSpeed = ""
					rotationSpeed = ""
					gunRotationSpeed = "0.5"
					buildingDelay = "3000" 
					invincibilityDelay = ""
					isAmmoSupport = "true"
					canHitInvisibleUnits = "true" />
				
				
				//--------------------------------------------------------------------------
				//
				//  Air support
				//
				//--------------------------------------------------------------------------
				
				
				< weapon 
					id = "10" 
					weaponId = "airSupport" 
					level = "0" 
					name = "Dragonfly"
					generalDescription = "Swift plane equipped with machine guns that will give you good air support on the battlefield."
					
					armorDescription = "200"
					hitThresholdDescription = "weak"
					hitPowerDescription = "1-3"
					hitRadiusDescription = "long"
					speedDescription = "very fast"
					shootDelayDescription = "very fast"
					
					developmentPrice="1"
					
					maxUpgradeLevel = "2"
					shootDelay = "100"
					armor = "2"
					hitRadius = "200"
					hitPower = "2"
					bulletSpeed = "0.3"
					motionSpeed = "3"
					rotationSpeed = "3"
					isAmmoSupport = "true"
					canHitAircrafts="true"/>
				
				< weapon 
					id = "11" 
					weaponId = "airSupport" 
					level = "1" 
					name = "Missiler"
					generalDescription = "Powerful aircraft equipped with missiles to obliterate any intruding enemy."
					
					armorDescription = "300"
					hitThresholdDescription = "weak"
					hitPowerDescription = "3-4/4-6"
					hitRadiusDescription = "very long"
					speedDescription = "very fast"
					shootDelayDescription = "fast"
					missileShootDelayDescription = "very slow"
					
					developmentPrice="2"
					
					maxUpgradeLevel = "2"
					shootDelay = "300"
					missileShootDelay="5000"
					armor = "3"
					hitRadius = "250"
					hitPower = "4"
					bulletSpeed = "0.3"
					motionSpeed = "3"
					rotationSpeed = "3"
					isAmmoSupport = "true"
					isMissileSupport = "true"
					canHitAircrafts="true"/>
				
				< weapon 
					id = "12" 
					weaponId = "airSupport" 
					level = "2" 
					name = "Big Bro"
					generalDescription = "Heavy plane equipped with plethora of missiles that will leave your enemies with no chance to survive."
					
					armorDescription = "400"
					hitThresholdDescription = "weak"
					hitPowerDescription = "4-7/4-6"
					hitRadiusDescription = "very long"
					speedDescription = "very fast"
					shootDelayDescription = "fast"
					missileShootDelayDescription = "slow"
					
					developmentPrice="2"
					
					maxUpgradeLevel = "2"
					shootDelay = "300"
					missileShootDelay="2500"
					armor = "4"
					hitRadius = "300"
					hitPower = "6"
					bulletSpeed = "0.3"
					motionSpeed = "3"
					rotationSpeed = "3"
					invincibilityDelay = ""
					isAmmoSupport = "true"
					isMissileSupport = "true"
					canHitAircrafts="true"/>
				
				
				
				//--------------------------------------------------------------------------
				//
				//  Bomb support
				//
				//--------------------------------------------------------------------------
				
				
				< weapon 
					id = "13" 
					weaponId = "bombSupport" 
					level = "0" 
					name = "Single Bomb"
					generalDescription = "Bombards ground-based enemies dealing devastating area damage."
					
					hitPowerDescription = "100-150"
					hitRadiusDescription = "short"
					
					developmentPrice="1"
					
					maxUpgradeLevel = "2"
					hitRadius = "100"
					hitPower = "15"
					bulletSpeed = "2" />
				
				< weapon 
					id = "14" 
					weaponId = "bombSupport" 
					level = "1" 
					name = "Double Bomb"
					generalDescription = "Blasts an even larger area dealing out double the damage."
					
					hitPowerDescription = "200-300"
					hitRadiusDescription = "average"
					
					developmentPrice="1"
					
					maxUpgradeLevel = "2"
					hitRadius = "125"
					hitPower = "15"
					bulletSpeed = "2" />
				
				< weapon 
					id = "15" 
					weaponId = "bombSupport" 
					level = "2" 
					name = "Triple Bomb"
					generalDescription = "Massive explosion with the devastating power to obliterate an entire group of enemies in a single shot."
					
					hitPowerDescription = "300-400"
					hitRadiusDescription = "long"
					
					developmentPrice="1"
					
					maxUpgradeLevel = "2"
					hitRadius = "150"
					hitPower = "15"
					bulletSpeed = "2" />
				
				
				//--------------------------------------------------------------------------
				//
				//  Repair center
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "16" 
					weaponId = "repairCenter" 
					level = "0" 
					name = "Repair Center Basic"
					generalDescription = "Automatically repairs all your damaged units within a wide range. Probably useless in the early stages…"
					
					buyPrice = "500"
					sellPrice = "350"
					totalRepairPrice = "200"
					upgradePrice = "500" 
					developmentPrice="1"
					
					armorDescription = "5000"
					hitThresholdDescription = "weak"
					repairPowerDescription="low"
					hitRadiusDescription = "average"
					
					maxUpgradeLevel = "2"
					armor = "50"
					hitRadius = "150"
					hitPower = "0.1"
					buildingDelay = "3000" />
				
				
				
				< weapon 
					id = "17" 
					weaponId = "repairCenter" 
					level = "1" 
					name = "Repair Center Int"
					generalDescription = "Leaves almost no chance for your enemies to destroy any of your towers!"
					
					buyPrice = "500"
					sellPrice = "700"
					totalRepairPrice = "200"
					upgradePrice = "500" 
					developmentPrice="2"
					
					armorDescription = "7500"
					hitThresholdDescription = "weak"
					repairPowerDescription="average"
					hitRadiusDescription = "average"
					
					maxUpgradeLevel = "2"
					armor = "75"
					hitRadius = "200"
					hitPower = "0.3"
					buildingDelay = "3000" />
				
				< weapon 
					id = "18" 
					weaponId = "repairCenter" 
					level = "2" 
					name = "Repair Center Adv"
					generalDescription = "Station with a great range and outstanding repairing ability. Makes your towers almost invincible."
					
					buyPrice = "500"
					sellPrice = "1000"
					totalRepairPrice = "200"
					upgradePrice = "" 
					developmentPrice="2"
					
					armorDescription = "10000"
					hitThresholdDescription = "weak"
					repairPowerDescription="high"
					hitRadiusDescription = "long"
					
					maxUpgradeLevel = "2"
					armor = "100"
					hitRadius = "250"
					hitPower = "0.6"
					buildingDelay = "3000" />
			
			</weapons>;
	
	}

}