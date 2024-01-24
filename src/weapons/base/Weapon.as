/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.base
{
	import constants.GamePlayConstants;
	import constants.WeaponContants;
	import controllers.AchievementsController;
	import controllers.SoundController;
	import islandBreak.controllers.WeaponController;
	import events.WeaponEvent;
	import flash.display.Shape;
	import flash.geom.Point;
	import infoObjects.WeaponInfo;
	import mainPack.DifficultyConfig;
	import nslib.AIPack.pathFollowing.RotationCalculator;
	import nslib.AIPack.pathFollowing.TrajectoryFollower;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.controls.NSSprite;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	import nslib.utils.NSMath;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.WeaponResources;
	import supportClasses.WeaponType;
	import weapons.base.supportClasses.WeaponIndicatorsVisualizer;
	import weapons.base.supportClasses.WeaponPreferenceDescriptor;
	import weapons.objects.Bridge;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Weapon extends TrajectoryFollower implements IWeapon, IGroundWeapon, IPurchasableItem
	{
		//------------------------------------------
		// general
		//------------------------------------------
		
		private var weaponId:String = WeaponResources.DEFAULT_WEAPON_ID;
		
		// the default one is assigned
		public var preferenceDescriptor:WeaponPreferenceDescriptor = new WeaponPreferenceDescriptor();
		
		//------------------------------------------
		// additional parameters
		//------------------------------------------
		
		// the angle of the gun in the resting position.
		// by default this value is NaN and the resting angle is the same as that of the body.
		public var gunRestAngle:Number = NaN;
		
		//------------------------------------------
		// upgradable parameters (for private use only)
		//------------------------------------------
		
		private var level:int = 0;
		
		private var armor:Number = 1;
		
		//------------------------------------------
		// parts
		//------------------------------------------
		
		protected var head:NSSprite = new NSSprite();
		
		protected var indicatorsVisualizer:WeaponIndicatorsVisualizer = new WeaponIndicatorsVisualizer();
		
		//------------------------------------------
		// parameters
		//------------------------------------------
		
		protected var shootingOffsetX:Number = 0;
		
		protected var shootingOffsetY:Number = 0;
		
		private var goalAngle:Number = 0;
			
		protected var currentEnergy:Number = 100;
		
		protected var maxEnergy:Number = 100;
		
		protected var gunRotationSpeed:Number = WeaponContants.DEFAULT_MINIMUM_GUN_ROTATION_SPEED;
		
		//------------------------------------------
		// flags
		//------------------------------------------
		
		// Indicates whether a unit is being built
		public var isBuilding:Boolean = false;
		
		// Indicates whether a unit cannot be damaged at the moment
		private var isInvincible:Boolean = false;
		
		private var isBusyRotatingGunToOriginalPosition:Boolean = false;
		
		//------------------------------------------
		// timers
		//------------------------------------------
		
		protected var shootDelayTimer:AdvancedTimer = new AdvancedTimer(WeaponContants.DEFAULT_SHOOT_DELAY, 1);
		
		private var invincibilityDelayTimer:AdvancedTimer = new AdvancedTimer(WeaponContants.DEFAULT_INVINCIBILITY_DELAY, 1);
		
		private var buildingDelayTimer:AdvancedTimer = new AdvancedTimer(WeaponContants.DEFAULT_BUILDING_DELAY, 1);
		
		private var electricShockDelayTimer:AdvancedTimer = new AdvancedTimer(WeaponContants.DEFAULT_ELECTRIC_SHOCK_DELAY, 1);
		
		/////////////////////////////////
		
		public function Weapon(weaponId:String, level:int = 0)
		{
			super();
			
			mouseEnabled = true;
			standardInterval = GamePlayConstants.STANDARD_INTERVAL;
			this.weaponId = weaponId;
			// initialize infos
			updateInfos();
			
			indicatorsVisualizer.weapon = this;
			
			upgradeToLevel(level);
			
			preferenceDescriptor.hostWeapon = this;
		}
		
		//////////////////////////////////
		
		//----------------------------------
		//  currentInfo
		//----------------------------------
		
		private var _currentInfo:WeaponInfo = null;
		
		// Returns WeaponInfo for the current level.
		public function get currentInfo():WeaponInfo
		{
			return _currentInfo;
		}
		
		private function updateInfos():void
		{
			_currentInfo = WeaponResources.getWeaponInfoByIDAndLevel(weaponId, level);
			_nextInfo = isUpgradable() ? WeaponResources.getWeaponInfoByIDAndLevel(weaponId, level + 1) : null;
		}
		
		//----------------------------------
		//  nextInfo
		//----------------------------------
		
		private var _nextInfo:WeaponInfo = null;
		
		// Returns WeaponInfo for the next level.
		// If not available return null.
		public function get nextInfo():WeaponInfo
		{
			return _nextInfo;
		}
		
		//----------------------------------
		//  isPlaced
		//----------------------------------
		
		private var _isPlaced:Boolean = false;
		
		public function get isPlaced():Boolean
		{
			return _isPlaced;
		}
		
		public function set isPlaced(value:Boolean):void
		{
			if (value)
				dispatchEvent(new WeaponEvent(WeaponEvent.PLACED));
			
			_isPlaced = value;
			
			indicatorsVisualizer.updateEnergyBar(currentEnergy, maxEnergy);
		}
		
		//----------------------------------
		//  isBuilt
		//----------------------------------	
		
		// indicates that the obstacle is built and ready
		private var _isBuilt:Boolean = false;
		
		public function get isBuilt():Boolean
		{
			return _isBuilt;
		}
		
		//----------------------------------
		//  headAngle
		//----------------------------------
		
		// in radians
		public function get headAngle():Number
		{
			return NSMath.degToRad(head.rotation);
		}
		
		public function set headAngle(value:Number):void
		{
			head.rotation = NSMath.radToDeg(value);
		}
		
		//----------------------------------
		//  shootDelay
		//----------------------------------
		
		public function get shootDelay():Number
		{
			return shootDelayTimer.delay;
		}
		
		public function set shootDelay(value:Number):void
		{
			shootDelayTimer.delay = value;
		}
		
		//----------------------------------
		//  invincibilityDelay
		//----------------------------------
		
		public function set invincibilityDelay(value:int):void
		{
			invincibilityDelayTimer.delay = value;
		}
		
		//----------------------------------
		//  buildingDelay
		//----------------------------------
		
		public function set buildingDelay(value:int):void
		{
			buildingDelayTimer.delay = value;
		}
		
		//----------------------------------
		//  hitRadius
		//----------------------------------
		
		private var _hitRadius:Number = WeaponContants.DEFAULT_HIT_RADIUS;
		
		public function get hitRadius():Number
		{
			return _hitRadius;
		}
		
		public function set hitRadius(value:Number):void
		{
			_hitRadius = value;
		}
		
		//----------------------------------
		//  isBusyRotatingForTarget
		//----------------------------------
		
		// Indicates whether a unit is rotating
		private var _isBusyRotatingForTarget:Boolean = false;
		
		public function get isBusyRotatingForTarget():Boolean
		{
			return _isBusyRotatingForTarget;
		}
		
		//----------------------------------
		//  hitTarget
		//----------------------------------
		
		// current hit target
		private var _hitTarget:Point = null;
		
		public function get hitTarget():Point
		{
			return _hitTarget;
		}
		
		public function set hitTarget(value:Point):void
		{
			_hitTarget = value;
			//enemyDetected();
		}
		
		//----------------------------------
		//  hitObject
		//----------------------------------
		
		// current hit target
		private var _hitObject:IWeapon = null;
		
		public function get hitObject():IWeapon
		{
			return _hitObject;
		}
		
		public function set hitObject(value:IWeapon):void
		{
			_hitObject = value;
		}
		
		//----------------------------------
		//  preferredHitObject
		//----------------------------------
		
		// preferred hit target
		private var _preferredHitObject:IWeapon = null;
		
		public function get preferredHitObject():IWeapon
		{
			return _preferredHitObject;
		}
		
		public function set preferredHitObject(value:IWeapon):void
		{
			_preferredHitObject = value;
		}
		
		//----------------------------------
		//  currentLocation
		//----------------------------------
		
		// current hit target
		private var _currentLocation:Point = null;
		
		public function get currentLocation():Point
		{
			if (!_currentLocation)
				return _currentLocation = new Point(x, y);
			else
			{
				_currentLocation.x = x;
				_currentLocation.y = y;
				
				return _currentLocation;
			}
		}
		
		//----------------------------------
		//  isActingInvisible
		//----------------------------------
		
		private var _isActingInvisible:Boolean = false;
		
		public function get isActingInvisible():Boolean
		{
			return _isActingInvisible;
		}
		
		public function set isActingInvisible(value:Boolean):void
		{
			if (isBeingElectrolized)
				return;
			
			setInvisible(value);
		}
		
		private function setInvisible(value:Boolean):void
		{
			_isActingInvisible = value;
			body.alpha = value ? 0.4 : 1;
			head.alpha = value ? 0.4 : 1;
		}
		
		//----------------------------------
		//  isBeingElectrolized
		//----------------------------------
		
		public function get isBeingElectrolized():Boolean
		{
			return electricShockDelayTimer.running;
		}
		
		//----------------------------------
		//  affordable
		//----------------------------------
		
		private var _affordable:Boolean = false;
		
		public function get affordable():Boolean
		{
			return _affordable;
		}
		
		public function set affordable(value:Boolean):void
		{
			_affordable = value;
			
			//mouseEnabled = value;
			//mouseChildren = value;
			
			if (value)
				addMouseSensitivity();
			else
				removeMouseSensitivity();
			
			alpha = value ? 1 : 0.4;
		}
		
		//------------------------------------------
		// Methods
		//------------------------------------------
		
		/////////////////////////////
		
		protected function applyConfigurationForTheCurrentLevel():void
		{
			this.armor = currentInfo.armor * (currentInfo.weaponType == WeaponType.ENEMY ? DifficultyConfig.armorCoefficient : 1);
			this.shootDelay = currentInfo.shootDelay;
			this.hitRadius = currentInfo.hitRadius;
			this.motionSpeed = currentInfo.motionSpeed;
			this.rotationSpeed = currentInfo.rotationSpeed;
			this.gunRotationSpeed = currentInfo.gunRotationSpeed;
			this.invincibilityDelay = currentInfo.invincibilityDelay;
			this.buildingDelay = currentInfo.buildingDelay;
			
			missileShootDelayTimer.delay = currentInfo.missileShootDelay;
			
			setInvisible(currentInfo.canBecomeInvisible);
		}
		
		/////////////////////////////////////////
		
		protected function drawWeaponLevel0():void
		{
			//must be overriden in subclasses
		}
		
		protected function drawWeaponLevel1():void
		{
			//must be overriden in subclasses
		}
		
		protected function drawWeaponLevel2():void
		{
			//must be overriden in subclasses
		}
		
		protected function drawWeaponLevel3():void
		{
			//must be overriden in subclasses
		}
		
		protected function drawWeaponLevel4():void
		{
			//must be overriden in subclasses
		}
		
		//------------------------------------------
		// Activation/Deactivation
		//------------------------------------------
		
		override public function activate():void
		{
			// this will be only for shooting units
			if (currentInfo.isAmmoSupport)
				deltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
			
			if (currentInfo.buildingDelay > 0 && !isNaN(currentInfo.buildingDelay))
			{
				buildingDelayTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, buildingDelayTimer_completeHandler);
				buildingDelayTimer.reset();
				buildingDelayTimer.start();
				showBuildingProgress();
			}
			else
				buildingDelayTimer_completeHandler(null);
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			
			preferredHitObject = null;
			
			shootDelayTimer.reset();
			buildingDelayTimer.reset();
			invincibilityDelayTimer.reset();
			electricShockDelayTimer.reset();
			deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
			buildingDelayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, buildingDelayTimer_completeHandler);
			invincibilityDelayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, invincibilityDelayTimer_completeHandler);
			electricShockDelayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, electricShockDelayTimer_timerCompletedHandler);
		}
		
		//------------------------------------------
		// Body Rotation
		//------------------------------------------
		
		public function rotateForTarget():void
		{
			if (!isActive || _isBusyRotatingForTarget)
				return;
			
			_isBusyRotatingForTarget = true;
			isBusyRotatingGunToOriginalPosition = false;
			
			var dx:Number = hitTarget.x - x;
			var dy:Number = hitTarget.y - y;
			goalAngle = NSMath.atan2Rad(dy, dx);
		}
		
		private function frameListener(event:DeltaTimeEvent):void
		{
			if (isFrozen)
				return;
			
			if (_isBusyRotatingForTarget || isBusyRotatingGunToOriginalPosition)
				performRotation();
		}
		
		protected function enemyDetected():void
		{
		
		}
		
		//------------------------------------------
		// Head Rotation
		//------------------------------------------
		
		private var rotationCalculator:RotationCalculator = new RotationCalculator();
		
		private function performRotation():void
		{
			// if the weapon is frozen just leave
			if (gunRotationSpeed == 0)
				return;
			
			rotationCalculator.deltaTimeCounter = deltaTimeCounter;
			rotationCalculator.standardInterval = standardInterval;
			
			// based on gun rotaion speed
			// cannon : 0.05, 0.075, 0.1
			// machine gun: 0.3, 0.4, 0.5 (90 degrees)
			var matchAccuracy:Number = 0.045 + 0.15 * gunRotationSpeed / 0.5; // from 0.05 to 0.2
			var easingCoefficient1:Number = matchAccuracy * 2;
			var easingCoefficient2:Number = 1 / easingCoefficient1;
			headAngle = rotationCalculator.performRotation(headAngle, goalAngle, gunRotationSpeed, 0.05, easingCoefficient1, easingCoefficient2);
			
			if (rotationCalculator.reachedGoalAngleAfterLastRotation)
			{
				headAngle = goalAngle;
				_isBusyRotatingForTarget = false;
				isBusyRotatingGunToOriginalPosition = false;
				tryFire();
			}
		}
		
		//------------------------------------------
		// Hitting a Target
		//------------------------------------------
		
		// notifies that no target was found around the unit,
		// so the head may return to its initial position
		public function noHitTargetsFound():void
		{
			//if (contains(pointer))
			//	removeChild(pointer);
			
			hitTarget = null;
			
			_isBusyRotatingForTarget = false;
			isBusyRotatingGunToOriginalPosition = true;
			goalAngle = isNaN(gunRestAngle) ? bodyAngle : gunRestAngle;
		}
		
		// makes an attemp to fire a bullet or something else
		protected function tryFire():void
		{
			// must be overriden in subclasses
		}
		
		//------------------------------------------
		// Missiles
		//------------------------------------------
		
		protected var missileShootDelayTimer:AdvancedTimer = new AdvancedTimer(WeaponContants.DEFAULT_MISSILE_SHOOT_DELAY, 1);
		
		protected var missileShootingOffsetX:Number = 0;
		
		protected var missileShootingOffsetY:Number = 0;
		
		public function busyReloadingMissile():Boolean
		{
			return missileShootDelayTimer.running;
		}
		
		public function fireMissileAt(target:IWeapon):Boolean
		{
			// in these cases a missile cannot be launched
			if (!currentInfo.isMissileSupport || missileShootDelayTimer.running)
				return false;
			
			var params:Object = new Object();
			params.hitObject = target;
			
			var cosA:Number = NSMath.cosRad(headAngle);
			var sinA:Number = NSMath.sinRad(headAngle);
			
			missileShootingOffsetY = -missileShootingOffsetY;
			
			params.x = x + missileShootingOffsetX * cosA - missileShootingOffsetY * sinA;
			params.y = y + missileShootingOffsetX * sinA + missileShootingOffsetY * cosA;
			params.rotation = NSMath.radToDeg(headAngle);
			
			WeaponController.launchMissile(params);
			
			missileShootDelayTimer.start();
			
			return true;
		}
		
		//------------------------------------------
		// Applying Damage
		//------------------------------------------
		
		public function applyDamage(damage:Number):void
		{
			// if the damage is too weak, just leave
			if (isInvincible || currentInfo.resistantToBullets)
				return;
			
			// checking threshold
			if (damage < currentInfo.hitThreshold)
				damage *= damage / currentInfo.hitThreshold;
			
			// applying some random to damage +-25%
			damage *= 1.25 - 0.5 * Math.random();
			
			currentEnergy -= damage / armor;
			
			dispatchEvent(new WeaponEvent(WeaponEvent.DAMAGED));
			
			if (currentEnergy <= 0)
			{
				currentEnergy = 0;
				internalDestroy();
			}
			
			updateEnergyBar();
		}
		
		////////////
		
		private var isDestroyed:Boolean = false;
		
		protected function internalDestroy():void
		{
			if (isDestroyed)
				return;
			
			isDestroyed = true;
			
			drawPartsExplosion();
			finalDestory();
		}
		
		protected function drawPartsExplosion():void
		{
			// must be implemented in subclasses
		}
		
		protected function finalDestory():void
		{
			dispatchEvent(new WeaponEvent(WeaponEvent.DESTROYED));
		}
		
		///////////////
		
		protected function get energyBar():Shape
		{
			return indicatorsVisualizer.energyBar;
		}
		
		protected function updateEnergyBar():void
		{
			indicatorsVisualizer.updateEnergyBar(currentEnergy, maxEnergy);
		}
		
		///////////////////////////
		
		public function notifyPreferencesChanged():void
		{
			updatePreferenceIndicator();
		}
		
		protected function updatePreferenceIndicator():void
		{
			indicatorsVisualizer.updatePreferenceIndicator();
		}
		
		/////////////////////////////
		
		/**
		 * @return Value from 0 to 1. 0 means intact.
		 */
		public function getDamagePercentage():Number
		{
			return (1 - currentEnergy / maxEnergy);
		}
		
		/**
		 * Repairs a unit by the specified amount of percent.
		 * @param	byPercent Amount of percantage by which the unit will be repaired.
		 * For example if the current damage percentage is 50, only 50 percent of repair is enough.
		 * The default value is 100 which means total reapiar.
		 */
		public function repair(byPercent:Number = 100):void
		{
			currentEnergy = currentEnergy / maxEnergy * 100 + byPercent;
			currentEnergy = Math.min(currentEnergy, maxEnergy);
			
			updateEnergyBar();
			
			dispatchEvent(new WeaponEvent(WeaponEvent.REPAIRED));
		}
		
		//------------------------------------------
		// Working with upgrade
		//------------------------------------------
		
		public function isUpgradable():Boolean
		{
			return (level < currentInfo.maxUpgradeLevel);
		}
		
		public function upgradeToNextLevel():void
		{
			upgradeToLevel(level + 1);
		}
		
		public function upgradeToLevel(level:int):void
		{
			if (level != 0 && (!isUpgradable() || this.level > level))
				return;
			
			setLevel(level);
		}
		
		private function setLevel(level:int):void
		{
			this.level = level;
			updateInfos();
			
			applyConfigurationForTheCurrentLevel();
			
			dispatchEvent(new WeaponEvent(WeaponEvent.UPGRADED));
			
			if (level == 0)
				drawWeaponLevel0();
			else if (level == 1)
				drawWeaponLevel1();
			else if (level == 2)
				drawWeaponLevel2();
			else if (level == 3)
				drawWeaponLevel3();
			else if (level == 4)
				drawWeaponLevel4();
			
			updatePreferenceIndicator();
		}
		
		//------------------------------------------
		// Building Weapon
		//------------------------------------------
		
		private function buildingDelayTimer_completeHandler(event:AdvancedTimerEvent):void
		{
			super.activate();
			buildingDelayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, buildingDelayTimer_completeHandler);
			removeBuildingProgress();
			
			invincibilityDelayTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, invincibilityDelayTimer_completeHandler);
			invincibilityDelayTimer.reset();
			invincibilityDelayTimer.start();
			applyInvincibility();
		}
		
		private function showBuildingProgress():void
		{
			isBuilding = true;
			
			indicatorsVisualizer.showBuildingProgress();
		}
		
		private function removeBuildingProgress():void
		{
			indicatorsVisualizer.removeBuildingProgress();
			
			isBuilding = false;
			_isBuilt = true;
			dispatchEvent(new WeaponEvent(WeaponEvent.BUILDING_COMPLETE));
		}
		
		//------------------------------------------
		// Applying Invincibility
		//------------------------------------------
		
		private function invincibilityDelayTimer_completeHandler(event:AdvancedTimerEvent):void
		{
			invincibilityDelayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, invincibilityDelayTimer_completeHandler);
			removeInvincibility();
		}
		
		protected function applyInvincibility():void
		{
			// can be overriden in subclasses
			isInvincible = true;
		}
		
		protected function removeInvincibility():void
		{
			// can be overriden in subclasses
			isInvincible = false;
		}
		
		//------------------------------------------
		// Applying Shock
		//------------------------------------------
		
		private var initialSpeed:Number = NaN;
		
		private var initialGunRotationSpeed:Number = NaN;
		
		public function get isFrozen():Boolean
		{
			return indicatorsVisualizer.isFrozen;
		}
		
		// electricDamage - damage when electrolized
		// duraction of electrolization
		// if should get frozen completely
		public function applyElectricShock(electricDamage:Number, duration:Number, completelyFreeze:Boolean = false):void
		{
			if (isInvincible)
				return;
			
			if (!electricShockDelayTimer.running)
			{
				initialGunRotationSpeed = gunRotationSpeed;
				initialSpeed = motionSpeed;
			}
			
			dispatchEvent(new WeaponEvent(WeaponEvent.ELECTRILIZED));
			
			/*var ratio:Number = (currentInfo.electricityResistance - electricDamage) / currentInfo.electricityResistance;
			
			   ratio = Math.max(0, ratio);
			
			 currentEnergy -= electricDamage * (1 - ratio) / armor;*/
			
			// no hit threshold considered
			// applying some random to damage +-25%
			electricDamage *= 1.25 - 0.5 * Math.random();
			currentEnergy -= electricDamage / armor;
			
			dispatchEvent(new WeaponEvent(WeaponEvent.DAMAGED));
			
			if (currentEnergy <= 0)
			{
				currentEnergy = 0;
				internalDestroy();
				return;
			}
			
			updateEnergyBar();
			
			electricShockDelayTimer.delay = duration;
			electricShockDelayTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, electricShockDelayTimer_timerCompletedHandler);
			electricShockDelayTimer.reset();
			electricShockDelayTimer.start();
			
			if (!isFrozen)
				slowDownSpeed(electricDamage, completelyFreeze);
			
			// make the unit temporarely lose this ability
			setInvisible(false);
			
			if (completelyFreeze)
				SoundController.instance.playSound(SoundResources.SOUND_WEAPON_FREEZING);
		}
		
		private function electricShockDelayTimer_timerCompletedHandler(event:AdvancedTimerEvent):void
		{
			electricShockDelayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, electricShockDelayTimer_timerCompletedHandler);
			recoverSpeed();
			
			// make the unit regain this ability
			if (currentInfo.canBecomeInvisible)
				setInvisible(true);
		}
		
		private function slowDownSpeed(electricDamage:Number, completelyFreeze:Boolean):void
		{
			if (completelyFreeze)
			{
				if (!isFrozen && currentInfo.weaponType == WeaponType.USER)
					AchievementsController.notifyUserUnitFrozen();
				
				indicatorsVisualizer.addFrozenCap();
				
				motionSpeed = 0;
				gunRotationSpeed = 0;
				return;
			}
			
			// motion speed
			var ratio:Number = (currentInfo.electricityResistance - electricDamage) / currentInfo.electricityResistance;
			
			if ((currentInfo.electricityResistance * 2) > electricDamage)
				// has accumulative effect
				motionSpeed = motionSpeed * ratio;
			else
				motionSpeed = initialSpeed / 1.5;
			
			// set a lower limit for slowing down
			motionSpeed = NSMath.max(motionSpeed, initialSpeed / 1.5);
			
			// gun rotation speed
			
			if ((currentInfo.electricityResistance * 2) > electricDamage)
				// has accumulative effect
				gunRotationSpeed = gunRotationSpeed * ratio;
			else
				gunRotationSpeed = initialGunRotationSpeed / 2;
			
			gunRotationSpeed = NSMath.max(gunRotationSpeed, initialGunRotationSpeed / 2);
		}
		
		private function recoverSpeed():void
		{
			// unfreeze if necessary
			indicatorsVisualizer.removeFrozenCap();
			
			motionSpeed = initialSpeed;
			gunRotationSpeed = initialGunRotationSpeed;
		}
		
		//------------------------------------------
		// Working with active enemy indicator
		//------------------------------------------
		
		public function get isIndicatedAsAcitveEnemy():Boolean
		{
			return indicatorsVisualizer.isIndicatedAsAcitveEnemy;
		}
		
		// TO DO do not use bitmap filters
		public function showActiveEnemyIndicator(value:Boolean):void
		{
			indicatorsVisualizer.showActiveEnemyIndicator(value);
		}
		
		//------------------------------------------
		// Working with hovered indicator
		//------------------------------------------
		
		public function get isIndicatedAsHovered():Boolean
		{
			return indicatorsVisualizer.isIndicatedAsHovered;
		}
		
		// TO DO do not use bitmap filters
		public function showHoveredOverIndicator(value:Boolean):void
		{
			indicatorsVisualizer.showHoveredOverIndicator(value);
		}
		
		//------------------------------------------
		// Working with bridge animation
		//------------------------------------------
		
		private var currentBridge:Bridge = null;
		
		public function registerBridgeToMoveOver(bridge:Bridge):void
		{
			currentBridge = bridge;
			
			deltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, checkForBridge);
		}
		
		public function unregisterBridgeToMoveOver():void
		{
			currentBridge = null;
			
			deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, checkForBridge);
			
			// reseting scale
			body.scaleX = 1;
			body.scaleY = 1;
			head.scaleX = 1;
			head.scaleY = 1;
		}
		
		private function checkForBridge(event:DeltaTimeEvent):void
		{
			if (!currentBridge)
				return;
			
			var scaleFactor:Number = 1;
			
			if (currentBridge.direction == Bridge.DIRECTION_HORIZONTAL)
				scaleFactor = 1.1 - Math.min(1, Math.abs(this.x - currentBridge.x) / (currentBridge.rect.width / 2) / 10);
			else
				scaleFactor = 1.1 - Math.min(1, Math.abs(this.y - currentBridge.y) / (currentBridge.rect.height / 2) / 10);
			
			body.scaleX = scaleFactor;
			body.scaleY = scaleFactor;
			head.scaleX = scaleFactor;
			head.scaleY = scaleFactor;
		}
		
				
		//------------------------------------------
		// showing progress available
		//------------------------------------------
		
		public function configureUgradeAvailableIndicator(show:Boolean, enoughMoney:Boolean):void
		{
			indicatorsVisualizer.configureUgradeAvailableIndicator(show, enoughMoney);
		}
		
		//------------------------------------------
		// showing preferred target indicator
		//------------------------------------------
		
		public function indicatesAsPreferredTarget():void
		{
			indicatorsVisualizer.indicatesAsPreferredTarget();
		}
	}
}