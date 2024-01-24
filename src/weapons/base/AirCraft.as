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
	import islandBreak.controllers.WeaponController;
	import events.WeaponEvent;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import infoObjects.WeaponInfo;
	import mainPack.DifficultyConfig;
	import nslib.AIPack.anchorFollowing.AnchorFollower;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	import supportClasses.resources.WeaponResources;
	import supportClasses.WeaponType;
	
	public class AirCraft extends AnchorFollower implements IWeapon
	{
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------------
		// general
		//------------------------------------------
		
		private var weaponId:String = WeaponResources.DEFAULT_WEAPON_ID;
		
		//------------------------------------------
		// upgradable parameters
		//------------------------------------------
		
		protected var armor:Number = 1;
		
		private var level:int = 0;
		
		//------------------------------------------
		// parameters
		//------------------------------------------
		
		public var pathIndex:int = -1;
		
		protected var currentEnergy:Number = 100;
		
		protected var maxEnergy:Number = 100;
		
		protected var shootingOffsetX:Number = 0;
		
		protected var shootingOffsetY:Number = 0;
		
		//------------------------------------------
		// parts
		//------------------------------------------
		
		protected var energyBar:Shape = new Shape();
		
		protected var flightBar:Shape = new Shape();
		
		//------------------------------------------
		// timers
		//------------------------------------------
		
		protected var shootDelayTimer:AdvancedTimer = new AdvancedTimer(WeaponContants.DEFAULT_SHOOT_DELAY, 1);
		
		protected var workingDelayTimer:AdvancedTimer = new AdvancedTimer(WeaponContants.DEFAULT_AIRCRAFT_WORKING_TIME, 1);
		
		//------------------------------------------
		// flags
		//------------------------------------------
		
		// indicates whether the aircraft's time is over and it's going away.
		protected var isGoingAway:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------]
		
		public function AirCraft(weaponId:String, level:int = 0)
		{
			super();
			
			standardInterval = GamePlayConstants.STANDARD_INTERVAL;
			travelRadius = WeaponContants.DEFAULT_AIRCRAFT_HIT_RADIUS;
			this.weaponId = weaponId;
			
			// set inital infos
			updateInfos();
			
			upgradeToLevel(level);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Getters and Setters
		//
		//--------------------------------------------------------------------------
		
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
		//  anchor
		//----------------------------------
		
		override public function set anchor(value:Point):void
		{
			// if the aircraft is not going away
			if (!isGoingAway)
				super.anchor = value;
		}
		
		//----------------------------------
		//  hitTarget
		//----------------------------------
		
		/**
		 * Target to shoot.
		 */
		public function get hitTarget():Point
		{
			return super.target;
		}
		
		public function set hitTarget(value:Point):void
		{
			// if the aircraft is not going away
			if (!isGoingAway)
				super.target = value;
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
		//  missileShootDelay
		//----------------------------------
		
		public function get missileShootDelay():Number
		{
			return missileShootDelayTimer ? missileShootDelayTimer.delay : NaN;
		}
		
		public function set missileShootDelay(value:Number):void
		{
			if (missileShootDelayTimer)
				missileShootDelayTimer.delay = value;
		}
		
		//----------------------------------
		//  hitRadius
		//----------------------------------
		
		public function get hitRadius():Number
		{
			return super.travelRadius;
		}
		
		public function set hitRadius(value:Number):void
		{
			super.travelRadius = value;
		}
		
		//----------------------------------
		//  workingTimeDelay
		//----------------------------------
		
		public function get workingTimeDelay():Number
		{
			return workingDelayTimer.delay;
		}
		
		public function set workingTimeDelay(value:Number):void
		{
			workingDelayTimer.delay = value;
		}
		
		//----------------------------------
		//  rect
		//----------------------------------
		
		// rectagle defining the unit boundaries
		private var _rect:Rectangle = new Rectangle(0, 0, 0, 0); //must be reimplemented in subclasses
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function set rect(value:Rectangle):void
		{
			_rect = value;
		}
		
		//----------------------------------
		//  isBusyRotatingForTarget
		//----------------------------------
		
		private var _isBusyRotatingForTarget:Boolean = false;
		
		// Need this property only to implement IWeapon interface		
		public function get isBusyRotatingForTarget():Boolean
		{
			return false;
		}
		
		//----------------------------------
		//  isBusyRotatingForTarget
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
		//  isBusyRotatingForTarget
		//----------------------------------
		
		private var _additionalHitTargets:Array = null;
		
		public function get additionalHitTargets():Array
		{
			return _additionalHitTargets;
		}
		
		public function set additionalHitTargets(value:Array):void
		{
			_additionalHitTargets = value;
		}
		
		//----------------------------------
		//  isActingInvisible
		//----------------------------------
		
		// currently this property is not used for aircrafts
		private var _isActingInvisible:Boolean = false;
		
		public function get isActingInvisible():Boolean
		{
			return _isActingInvisible;
		}
		
		public function set isActingInvisible(value:Boolean):void
		{
			setInvisible(value);
		}
		
		private function setInvisible(value:Boolean):void
		{
			_isActingInvisible = value;
			body.alpha = value ? 0.4 : 1;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: calculating trajectory
		//
		//--------------------------------------------------------------------------
		
		override public function activate():void
		{
			super.activate();
			
			workingDelayTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, workingDelayTimer_timerCompletedHandler);
			workingDelayTimer.start();
		}
		
		/////////////////
		
		protected function workingDelayTimer_timerCompletedHandler(event:AdvancedTimerEvent):void
		{
			workingDelayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, workingDelayTimer_timerCompletedHandler);
			anchor = new Point(-100, -100);
			isGoingAway = true;
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			
			workingDelayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, workingDelayTimer_timerCompletedHandler);
			workingDelayTimer.stop();
		}
		
		/////////////////
		
		public function rotateForTarget():void
		{
			if (isBusyRotatingForTarget)
				return;
			
			_isBusyRotatingForTarget = true;
		}
		
		override protected function tryReachPoint(point:Point):void
		{
			super.tryReachPoint(point);
			
			// if the aircraft is going away
			if (isGoingAway)
			{
				if (isOutsideTheScreen())
					dispatchEvent(new WeaponEvent(WeaponEvent.REMOVE));
			}
			
			// check if the tagret is within the aim rect
			if (hitTarget)
				tryFireAtHitTarget(hitTarget, currentCosA, currentSinA);
			
			if (additionalHitTargets)
				tryFireAtAdditionalHitTargets(currentCosA, currentSinA);
		}
		
		private function isOutsideTheScreen():Boolean
		{
			return (((x < -10) || (x > (GamePlayConstants.STAGE_WIDTH + 10))) && ((y < -10) || (y > (GamePlayConstants.STAGE_HEIGHT + 10))));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: firing at targets
		//
		//--------------------------------------------------------------------------
		
		private function tryFireAtHitTarget(target:Point, cosA:Number, sinA:Number):void
		{
			if (hitsAimRect(target, 210, 60, cosA, sinA) || hitsAimRect(target, 90, 40, cosA, sinA) || hitsAimRect(target, 50, 20, cosA, sinA))
			{
				// need to reset the flag indicating that the target is reached and a new target can be set
				if (target == hitTarget && isBusyRotatingForTarget)
					_isBusyRotatingForTarget = false;
				
				fireAtTarget(target);
			}
		}
		
		private function tryFireAtAdditionalHitTargets(cosA:Number, sinA:Number):void
		{
			for each (var additionalTarget:Point in additionalHitTargets)
				tryFireAtHitTarget(additionalTarget, cosA, sinA);
		}
		
		private function hitsAimRect(target:Point, aimDist:Number, radius:Number, cosA:Number, sinA:Number):Boolean
		{
			var aimX:Number = x + aimDist * cosA;
			var aimY:Number = y + aimDist * sinA;
			
			return ((Math.abs(target.x - aimX) < radius) && (Math.abs(target.y - aimY) < radius))
		}
		
		protected function fireAtTarget(target:Point):void
		{
			// must be overriden
		}
		
		// notifies that no target was found around the unit,
		// so the head may return to its initial position
		public function noHitTargetsFound():void
		{
			hitTarget = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: firing with missiles
		//
		//--------------------------------------------------------------------------
		
		protected var missileShootingOffsetX:Number = 0;
		
		protected var missileShootingOffsetY:Number = 0;
		
		private var missileShootDelayTimer:AdvancedTimer = null; // new AdvancedTimer(WeaponContants.DEFAULT_MISSILE_SHOOT_DELAY, 1);
		
		public function busyReloadingMissile():Boolean
		{
			return missileShootDelayTimer && missileShootDelayTimer.running;
		}
		
		// shoots a missile to the location
		public function fireMissileAt(target:IWeapon):Boolean
		{
			// in these cases a missile cannot be launched
			if (!currentInfo.isMissileSupport || missileShootDelayTimer.running)
				return false;
			
			var params:Object = new Object();
			params.hitObject = target;
			
			missileShootingOffsetY = -missileShootingOffsetY;
			
			params.x = x + missileShootingOffsetX * currentCosA - missileShootingOffsetY * currentSinA;
			params.y = y + missileShootingOffsetX * currentSinA + missileShootingOffsetY * currentCosA;
			params.rotation = body.rotation;
			
			WeaponController.launchMissile(params, currentInfo.missileHitPowerMultiplier);
			
			missileShootDelayTimer.start();
			
			return true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: upgrade
		//
		//--------------------------------------------------------------------------
		
		public function isUpgradable():Boolean
		{
			return (level < currentInfo.maxUpgradeLevel);
		}
		
		public function upgradeToLevel(level:int):void
		{
			if (!isUpgradable() || this.level > level)
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
		}
		
		private function applyConfigurationForTheCurrentLevel():void
		{
			this.armor = currentInfo.armor * (currentInfo.weaponType == WeaponType.ENEMY ? DifficultyConfig.armorCoefficient : 1);
			this.shootDelay = currentInfo.shootDelay;
			this.hitRadius = currentInfo.hitRadius;
			this.motionSpeed = currentInfo.motionSpeed;
			this.rotationSpeed = currentInfo.rotationSpeed;
			
			if (currentInfo.isMissileSupport)
			{
				missileShootDelayTimer = new AdvancedTimer(currentInfo.missileShootDelay, 1);
			}
			
			if (this.currentInfo.workingTime && !isNaN(this.currentInfo.workingTime))
				workingDelayTimer.delay = this.currentInfo.workingTime;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: damage
		//
		//--------------------------------------------------------------------------
		
		public function applyDamage(damage:Number):void
		{
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
		
		// drawring energy bar
		protected function updateEnergyBar():void
		{
			energyBar.visible = true;
			
			// default implementation
			energyBar.graphics.clear();
			energyBar.graphics.lineStyle(2, 0x555555);
			energyBar.graphics.drawRect(-10, -30, 20, 4);
			
			energyBar.graphics.lineStyle(0);
			energyBar.graphics.beginFill(0x00FF00);
			energyBar.graphics.drawRect(-10, -30, 20 * currentEnergy / maxEnergy, 4);
			
			energyBar.graphics.beginFill(0xAAAAAA);
			energyBar.graphics.drawRect(-10 + 20 * currentEnergy / maxEnergy, -30, 20 * (maxEnergy - currentEnergy) / maxEnergy, 4);
		}
		
		// drawring energy bar
		protected function updateFlightBar():void
		{
			flightBar.visible = true;
			
			var progress:Number = isGoingAway ? 1 : workingDelayTimer.progress;
			
			// default implementation
			flightBar.graphics.clear();
			flightBar.graphics.lineStyle(2, 0x555555);
			flightBar.graphics.drawRect(-10, -25, 20, 3);
			
			flightBar.graphics.lineStyle(0);
			flightBar.graphics.beginFill(0xF2ED31);
			flightBar.graphics.drawRect(-10, -25, 20 * (1 - progress), 3);
			
			flightBar.graphics.beginFill(0xAAAAAA);
			flightBar.graphics.drawRect(-10 + 20 * (1 - progress), -25, 20 * progress, 3);
		}
		
		public function getDamagePercentage():Number
		{
			return (1 - currentEnergy / maxEnergy);
		}
		
		public function repair():void
		{
			currentEnergy = maxEnergy;
			
			dispatchEvent(new WeaponEvent(WeaponEvent.REPAIRED));
		}
		
		private var updateFlightBarCount:int = 0;
		
		override protected function performMovement():void
		{
			super.performMovement();
			
			if (updateFlightBarCount++ > 50)
			{
				updateFlightBarCount = 0;
				updateFlightBar();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: damage
		//
		//--------------------------------------------------------------------------
		
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
	}
}
