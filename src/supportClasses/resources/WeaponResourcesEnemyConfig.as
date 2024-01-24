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
	public class WeaponResourcesEnemyConfig
	{
		
		public static const config:XML =
			
			<weapons>
				
				< weapon 
					id = "defaultEnemy" 
					weaponId = "defaultenemyWeapon" 
					name = "Default Enemy Weapon" />
				
				
				//--------------------------------------------------------------------------
				//
				//  Light and fast vehicles
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "0" 
					weaponId = "mobileVehicle" 
					level = "0" 
					name = "Trike"
					generalDescription = "Weak ground-based unit that can be easily handled by any of your towers."
					descriptiveParamters = "Fast Speed,Weak Armor,No Attack"
					
					armorDescription = "20"
					hitThresholdDescription = "weak"
					speedDescription = "fast"
					
					destroyBonus="25"
					
					maxUpgradeLevel = "2"
					shootDelay = ""
					armor = "0.2"
					hitRadius = ""
					hitPower = ""
					electricityResistance = "0"
					bulletSpeed = ""
					motionSpeed = "1.7"
					rotationSpeed = "0.2"
					gunRotationSpeed = ""
					invincibilityDelay = "2000"
					isAmmoSupport = "false" />
				
				< weapon 
					id = "1" 
					weaponId = "mobileVehicle" 
					level = "1" 
					name = "Rally Car"
					generalDescription = "These fast units can easily dodge your defensive line if not properly handled."
					descriptiveParamters = "Very Fast Speed,Weak Armor,No Attack"
					
					armorDescription = "20"
					hitThresholdDescription = "weak"
					speedDescription = "very fast"
					
					destroyBonus="30"
					
					maxUpgradeLevel = "2"
					shootDelay = ""
					armor = "0.2"
					hitRadius = ""
					hitPower = ""
					electricityResistance = "2"
					bulletSpeed = ""
					motionSpeed = "3.5"
					rotationSpeed = "0.2"
					gunRotationSpeed = ""
					invincibilityDelay = "2000"
					isAmmoSupport = "false"
					
					specialNotificationWhenFirstAppearing = "Make sure you have enough machine guns so they don’t overwhelm you!"/>
				
				< weapon 
					id = "2" 
					weaponId = "mobileVehicle" 
					level = "2" 
					name = "Triball"
					generalDescription = "These hovering units can weave through defenses in a heartbeat."
					descriptiveParamters = "Passes Over Other Enemies,Exremely Fast,Weak Armor"
					
					armorDescription = "50"
					hitThresholdDescription = "weak"
					speedDescription = "super fast"
					
					destroyBonus="35"
					
					maxUpgradeLevel = "2"
					shootDelay = ""
					armor = "0.2"
					hitRadius = ""
					hitPower = ""
					electricityResistance = "5"
					bulletSpeed = ""
					motionSpeed = "4.5"
					rotationSpeed = "0.2"
					gunRotationSpeed = ""
					invincibilityDelay = "2000"
					isAmmoSupport = "false"
					
					specialNotificationWhenFirstAppearing = "Electric towers combined with machine guns are the best way to deal with them!" />
				
				//--------------------------------------------------------------------------
				//
				//  Simple tanks
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "3" 
					weaponId = "tank" 
					level = "0" 
					name = "Light Tank"
					generalDescription = "Basic armored enemy dealing light damage."
					descriptiveParamters = "Heavy Armor,Slow Speed,Average Damage"
					
					armorDescription = "75"
					hitThresholdDescription = "heavy"
					hitPowerDescription = "8-12"
					hitRadiusDescription = "long"
					speedDescription = "slow"
					shootDelayDescription = "slow"
					
					destroyBonus="35"
					
					maxUpgradeLevel = "1"
					shootDelay = "2000"
					armor = "0.75"
					hitRadius = "200"
					hitPower = "10"
					hitThreshold="10"
					electricityResistance = "0"
					bulletSpeed = "0.1"
					motionSpeed = "0.7"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					isAmmoSupport = "true"/>
				
				< weapon 
					id = "4" 
					weaponId = "tank" 
					level = "1" 
					name = "Heavy Tank"
					generalDescription = "Strong tank equipped with heavy armor and the ability to withstand sustained attack."
					descriptiveParamters = "Very Heavy Armor,High Damage,Slow Speed"
					
					armorDescription = "250"
					hitThresholdDescription = "very heavy"
					hitPowerDescription = "16-24"
					hitRadiusDescription = "long"
					speedDescription = "slow"
					shootDelayDescription = "slow"
					
					destroyBonus="35"
					
					maxUpgradeLevel = "1"
					shootDelay = "2000"
					armor = "2.5"
					hitRadius = "200"
					hitPower = "20"
					hitThreshold="15"
					electricityResistance = "5"
					bulletSpeed = "0.1"
					motionSpeed = "0.5"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					isAmmoSupport = "true"/>
				
				
				//--------------------------------------------------------------------------
				//
				//  Planes
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "5" 
					weaponId = "plane" 
					level = "0" 
					name = "Light Fighter"
					generalDescription = "Swift flying unit, which is not bound by any path."
					descriptiveParamters = "Very Fast Speed,Flies All Over the Battlefield,Weak Armor"
					
					armorDescription = "125"
					hitThresholdDescription = "weak"
					hitPowerDescription = "1-2"
					hitRadiusDescription = "long"
					speedDescription = "very fast"
					shootDelayDescription = "very fast"
					
					destroyBonus="40"
					
					maxUpgradeLevel = "2"
					shootDelay = "100"
					armor = "1.25"
					hitRadius = "200"
					hitPower = "2"
					bulletSpeed = "0.3"
					motionSpeed = "3"
					rotationSpeed = "3"
					isAmmoSupport = "true"
					isMissileSupport = "false" 
					canHitAircrafts = "true"
					
					specialNotificationWhenFirstAppearing = "Electric towers and bombs CANNOT hit aircrafts! Use cannons and machine guns!" />
				
				
				< weapon 
					id = "6" 
					weaponId = "plane" 
					level = "1" 
					name = "Speedy Bombardier"
					generalDescription = "Very fast plane. Very hard to catch."
					descriptiveParamters = "Fast Speed,Heavy Armor,Powerful Attack"
					
					armorDescription = "400"
					hitThresholdDescription = "weak"
					hitPowerDescription = "12-18/4-6"
					hitRadiusDescription = "long"
					speedDescription = "very fast"
					shootDelayDescription = "very fast"
					missileShootDelayDescription = "slow"
					
					destroyBonus="70"
					
					maxUpgradeLevel = "2"
					shootDelay = "100"
					missileShootDelay="2000"
					armor = "2"
					hitRadius = "200"
					hitPower = "15"
					bulletSpeed = "0.3"
					motionSpeed = "5"
					rotationSpeed = "3"
					isAmmoSupport = "true"
					isMissileSupport = "true" 
					canHitAircrafts = "true"/>
				
				
				< weapon 
					id = "7" 
					weaponId = "plane" 
					level = "2" 
					name = "Tiny Swifter"
					generalDescription = "Tiny plane that brings no destruction but very annoying and hard to hit."
					descriptiveParamters = "Fast Speed,No Armor,No Attack"
					
					armorDescription = "75"
					hitThresholdDescription = "weak"
					speedDescription = "fast"
					
					destroyBonus="20"
					
					maxUpgradeLevel = "2"
					shootDelay = "100"
					armor = "0.75"
					motionSpeed = "2.5"
					rotationSpeed = "3"
					isAmmoSupport = "false"
					isMissileSupport = "false" 
					canHitAircrafts = "true"/>
				
				
				//--------------------------------------------------------------------------
				//
				//  Helicopters
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "8" 
					weaponId = "helicopter" 
					level = "0" 
					name = "Light Copter"
					generalDescription = "These units are stronger than planes and able to stand a lot of attack."
					descriptiveParamters = "Average Speed,High HP"
					
					armorDescription = "300"
					hitThresholdDescription = "weak"
					hitPowerDescription = "1-2"
					hitRadiusDescription = "long"
					speedDescription = "fast"
					shootDelayDescription = "very fast"
					
					destroyBonus="40"
					
					maxUpgradeLevel = "2"
					shootDelay = "100"
					armor = "2"
					hitRadius = "200"
					hitPower = "2"
					bulletSpeed = "0.3"
					motionSpeed = "2.5"
					rotationSpeed = "3"
					isAmmoSupport = "true"
					isMissileSupport = "false" 
					canHitAircrafts = "true"/>
				
				< weapon 
					id = "9" 
					weaponId = "helicopter" 
					level = "1" 
					name = "Heavy Copter"
					generalDescription = "Very strong helicopter that can last much longer in the battlefield."
					descriptiveParamters = "Very High HP,Average Speed,Powerful Damage"
					
					armorDescription = "1000"
					hitThresholdDescription = "weak"
					hitPowerDescription = "3-4/4-6"
					hitRadiusDescription = "very long"
					speedDescription = "fast"
					shootDelayDescription = "very fast"
					missileShootDelayDescription = "slow"
					
					destroyBonus="50"
					
					maxUpgradeLevel = "2"
					shootDelay = "100"
					missileShootDelay="2500"
					armor = "6"
					hitRadius = "400"
					hitPower = "4"
					bulletSpeed = "0.3"
					motionSpeed = "2"
					rotationSpeed = "3"
					workingTime="100000"
					isAmmoSupport = "true"
					isMissileSupport = "true" 
					canHitAircrafts = "true" />
					
				< weapon 
					id = "boss" 
					weaponId = "helicopter"
					level = "2" 
					name = "Boss"
					generalDescription = "Boss"
					descriptiveParamters = "Very High HP,Slow Speed,Very Powerful Damage"
					
					armorDescription = ""
					hitThresholdDescription = ""
					hitPowerDescription = ""
					hitRadiusDescription = ""
					speedDescription = ""
					shootDelayDescription = ""
					missileShootDelayDescription = ""
					
					destroyBonus="1000"
					
					maxUpgradeLevel = "2"
					shootDelay = "100"
					missileShootDelay="300"
					armor = "10"
					hitRadius = "200"
					hitPower = "4"
					missileHitPowerMultiplier = "20"
					bulletSpeed = "0.5"
					motionSpeed = "3"
					rotationSpeed = "1.5"
					workingTime="100000000"
					isAmmoSupport = "true"
					isMissileSupport = "true" 
					canHitAircrafts = "true"/>
				
				
				//--------------------------------------------------------------------------
				//
				//  Energy balls
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "10" 
					weaponId = "energyBall" 
					level = "0" 
					name = "Zapper"
					generalDescription = "Intangible lumps of pure energy. They ignore any physical attack."
					descriptiveParamters = "Resistant to Physical Attack,Passes Over Other Enemies,Low Damage"
					
					armorDescription = "10"
					shockPowerDescription = "4-6"
					hitRadiusDescription = "short"
					speedDescription = "average"
					shootDelayDescription = "very slow"
					
					destroyBonus="30"
					
					maxUpgradeLevel = "1"
					shootDelay = "3000"
					armor = "0.2"
					hitRadius = "70"
					hitPower = "5"
					electrolizingDuration = "4000"
					electricityResistance = "20"
					bulletSpeed = "2"
					motionSpeed = "1"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					canFreezeUnits = "false"
					isAmmoSupport = "true"
					resistantToBullets = "true"
					specialNotificationWhenFirstAppearing = "Make sure you have enough electric towers to handle them!" />
				
				<weapon 
					id = "11" 
					weaponId = "energyBall" 
					level = "1" 
					name = "Freezer"
					generalDescription = "Casting paralyzing rays completely incapacitates your towers for a while."
					descriptiveParamters = "Resistant to Physical Attack,Paralyzes Your Towers,Passes Over Other Enemies"
					
					armorDescription = "30"
					shockPowerDescription = "5-8"
					hitRadiusDescription = "short"
					speedDescription = "average"
					shootDelayDescription = "very slow"
					
					destroyBonus="50"
					
					maxUpgradeLevel = "1"
					shootDelay = "3000"
					armor = "0.4"
					hitRadius = "70"
					hitPower = "7"
					electrolizingDuration = "8000"
					electricityResistance = "20"
					bulletSpeed = "2"
					motionSpeed = "0.9"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					canFreezeUnits = "true"
					isAmmoSupport = "true"
					resistantToBullets = "true"
					specialNotificationWhenFirstAppearing = "Can lead heavy units through your defenses by paralyzing your powerful towers!" />
				
				//--------------------------------------------------------------------------
				//
				//  Walking robots
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "12" 
					weaponId = "walkingRobot" 
					level = "0" 
					name = "Metal Chicken"
					generalDescription = "Swift walking robot equipped with light armor. Dangerous in large numbers."
					descriptiveParamters = "Fast Speed,Average Armor,Low Damage"
					
					armorDescription = "70"
					hitThresholdDescription = "average"
					hitPowerDescription = "1"
					hitRadiusDescription = "long"
					speedDescription = "fast"
					shootDelayDescription = "fast"
					
					destroyBonus="30"
					
					maxUpgradeLevel = "2"
					shootDelay = "300"
					armor = "0.7"
					hitRadius = "200"
					hitPower = "1"
					hitThreshold="5"
					electricityResistance = "0"
					bulletSpeed = "0.3"
					motionSpeed = "1.5"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					isAmmoSupport = "true"
					isMissileSupport = "false" />
				
				< weapon 
					id = "13" 
					weaponId = "walkingRobot" 
					level = "1" 
					name = "Mastodon"
					generalDescription = "Heavily armored unit equipped with missiles to obliterate everything in its path."
					descriptiveParamters = "Very Heavy Armor,High Damage,Slow Speed"
					
					armorDescription = "300"
					hitThresholdDescription = "very heavy"
					hitPowerDescription = "4-6/4-6"
					hitRadiusDescription = "very long"
					speedDescription = "slow"
					missileShootDelayDescription = "slow"
					
					destroyBonus="40"
					
					maxUpgradeLevel = "2"
					missileShootDelay="2000"
					armor = "3"
					hitThreshold="15"
					hitRadius = "300"
					hitPower = "5"
					electricityResistance = "3"
					bulletSpeed = "0.1"
					motionSpeed = "0.6"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					isAmmoSupport = "false"
					isMissileSupport = "true" />
				
				
				< weapon 
					id = "14" 
					weaponId = "walkingRobot" 
					level = "2" 
					name = "Iron Turtle"
					generalDescription = "This unit is equipped with enormous armor but has a very slow speed, which should give you enough time to deal with it."
					descriptiveParamters = "Extremely Heavy Armor,Very Slow Speed,No Attack"
					
					armorDescription = "2000"
					hitThresholdDescription = "very heavy"
					speedDescription = "very slow"
					
					destroyBonus="100"
					
					maxUpgradeLevel = "2"
					shootDelay = "1000"
					armor = "20"
					hitThreshold="50"
					electricityResistance = "5"
					motionSpeed = "0.4"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					isAmmoSupport = "false"
					isMissileSupport = "false" />
				
				//--------------------------------------------------------------------------
				//
				//  Invisible tanks
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "15" 
					weaponId = "invisibleTank" 
					level = "0" 
					name = "Fader"
					generalDescription = "Builds an invisible shield that can be removed only by electricity."
					descriptiveParamters = "Undetectable by Non-electric Towers,Heavy Armor"
					
					armorDescription = "100"
					hitThresholdDescription = "heavy"
					speedDescription = "average"
					
					destroyBonus="40"
					
					maxUpgradeLevel = "1"
					shootDelay = "2000"
					armor = "1"
					hitRadius = "200"
					hitPower = "0"
					hitThreshold="10"
					electricityResistance = "0"
					bulletSpeed = "0.1"
					motionSpeed = "1"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					canBecomeInvisible = "true"
					isAmmoSupport = "false"
					
					specialNotificationWhenFirstAppearing = "Use electric towers to remove invisible shield from these enemies!"/>
				
				<weapon 
					id = "16" 
					weaponId = "invisibleTank" 
					level = "1" 
					name = "Veiler"
					generalDescription = "Capable of making other units undetectable by your non-electric towers."
					descriptiveParamters = "Makes Units Undetectable,Heavy Armor"
					
					armorDescription = "150"
					hitThresholdDescription = "heavy"
					speedDescription = "average"
					
					destroyBonus="60"
					
					maxUpgradeLevel = "1"
					shootDelay = "2000"
					armor = "1.5"
					hitRadius = "200"
					hitPower = "0"
					hitThreshold="10"
					electricityResistance = "0"
					bulletSpeed = "0.1"
					motionSpeed = "0.8"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					canBecomeInvisible = "true"
					canMakeInvisible = "true"
					isAmmoSupport = "false"
					
					specialNotificationWhenFirstAppearing = "If you ignore this machine, it will quickly lead enemies past your towers!"/>
				
				//--------------------------------------------------------------------------
				//
				//  Bomber tanks
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "17" 
					weaponId = "bomberTank" 
					level = "0" 
					name = "Bomb Launcher"
					generalDescription = "While equipped with average armor it drops powerful cannonballs on your towers."
					descriptiveParamters = "Very High Damage,Average Armor,Average Speed"
					
					armorDescription = "100"
					hitThresholdDescription = "average"
					hitPowerDescription = "180-220"
					hitRadiusDescription = "average"
					speedDescription = "average"
					shootDelayDescription = "slow"
					
					destroyBonus="40"
					
					maxUpgradeLevel = "1"
					shootDelay = "2000"
					armor = "1"
					hitThreshold="5"
					hitRadius = "100"
					hitPower = "200"
					electricityResistance = "0"
					bulletSpeed = "0.1"
					motionSpeed = "0.8"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					isAmmoSupport = "true" />
				
				<weapon 
					id = "18" 
					weaponId = "bomberTank" 
					level = "1" 
					name = "Heavy Bombardier"
					generalDescription = "Overwhelms its enemies with rains of cannonballs."
					descriptiveParamters = "Extremely High Damage,Heavy Armor,Slow Speed"
					
					armorDescription = "200"
					hitThresholdDescription = "heavy"
					hitPowerDescription = "320-380"
					hitRadiusDescription = "average"
					speedDescription = "slow"
					shootDelayDescription = "slow"
					
					destroyBonus="70"
					
					maxUpgradeLevel = "1"
					shootDelay = "2000"
					armor = "3"
					hitThreshold="10"
					hitRadius = "120"
					hitPower = "350"
					electricityResistance = "0"
					bulletSpeed = "0.1"
					motionSpeed = "0.7"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					isAmmoSupport = "true"/>
				
				//--------------------------------------------------------------------------
				//
				//  Factory tanks
				//
				//--------------------------------------------------------------------------
				
				<weapon 
					id = "19" 
					weaponId = "factoryTank" 
					level = "0" 
					name = "Plane Creator"
					generalDescription = "Constantly spawns new planes to the battlefield."
					descriptiveParamters = "Respawns New Planes,Very Heavy Armor,Slow Speed"
					
					armorDescription = "200"
					hitThresholdDescription = "very heavy"
					speedDescription = "slow"
					
					destroyBonus="35"
					
					maxUpgradeLevel = "0"
					shootDelay = "2000"
					armor = "2"
					hitThreshold="15"
					electricityResistance = "0"
					motionSpeed = "0.7"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					isAmmoSupport = "false"/>
				
				//--------------------------------------------------------------------------
				//
				//  Repair tank
				//
				//--------------------------------------------------------------------------
				
				< weapon 
					id = "20" 
					weaponId = "repairTank" 
					level = "0" 
					name = "Recoverer"
					generalDescription = "While being completely harmful recovers all damaged enemies within its range."
					descriptiveParamters = "Repairs Damaged Units,Average Armor,Average Speed"
					
					armorDescription = "100"
					hitThresholdDescription = "average"
					speedDescription = "average"
					hitRadiusDescription = "long"
					
					destroyBonus="35"
					
					maxUpgradeLevel = "0"
					shootDelay = "2000"
					armor = "1"
					hitThreshold="5"
					hitRadius = "200"
					hitPower = "0.25"
					electricityResistance = "0"
					bulletSpeed = "0.1"
					motionSpeed = "0.8"
					rotationSpeed = "0.2"
					gunRotationSpeed = "0.1"
					invincibilityDelay = "2000"
					canRepairUnits = "true"
					isAmmoSupport = "false"
					
					specialNotificationWhenFirstAppearing = "Can quickly become a threat when it appears in groups!"/>
			
			</weapons>;
	
	}

}