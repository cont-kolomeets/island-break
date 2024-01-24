/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.base
{
	import constants.WeaponContants;
	import islandBreak.controllers.WeaponController;
	import events.WeaponEvent;
	import flash.display.Bitmap;
	import nslib.animation.engines.AnimationEngine;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	import nslib.utils.NSMath;
	import nslib.utils.TrigonometryUtil;
	import supportClasses.BulletType;
	import supportClasses.WeaponType;
	import weapons.ammo.bullets.CannonBullet;
	import weapons.base.supportClasses.WeaponUtil;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class CannonBase extends Weapon
	{
		////////////////////////
		
		protected var headPart:Bitmap = null;
		
		protected var gun:Bitmap = null;
		
		protected var delayBeforeShootingTimer:AdvancedTimer = new AdvancedTimer(50, 1);
		
		// flags
		
		private var pendingFire:Boolean = false;
		
		////////////////////////////////////////////////////////////
		
		public function CannonBase(weaponId:String = null, level:int = 0)
		{
			super(weaponId, level);
		}
		
		//----------------------------------
		//  shootDelay
		//----------------------------------
		
		public function get delayBeforeShooting():Number
		{
			return delayBeforeShootingTimer.delay;
		}
		
		public function set delayBeforeShooting(value:Number):void
		{
			delayBeforeShootingTimer.delay = value;
		}
		
		//------------------------------------------------------------------------------
		//
		// Configuration
		//
		//------------------------------------------------------------------------------
		
		override protected function applyConfigurationForTheCurrentLevel():void
		{
			super.applyConfigurationForTheCurrentLevel();
			
			this.delayBeforeShooting = currentInfo.delayBeforeShooting;
		}
		
		//------------------------------------------------------------------------------
		//
		// Shooting
		//
		//------------------------------------------------------------------------------
		
		override protected function tryFire():void
		{
			if (!hitTarget || !currentInfo.isAmmoSupport)
			{
				pendingFire = false;
				return;
			}
			
			if (delayBeforeShootingTimer.running || shootDelayTimer.running)
			{
				pendingFire = true;
				return;
			}
			
			if (!pendingFire)
			{
				pendingFire = true;
				delayBeforeShootingTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, delayBeforeShootingTimer_completedHandler);
				delayBeforeShootingTimer.start();
				return;
			}
			
			// it might be a time for shooting
			// but the current target may not be at the right position
			if (!ensureCannonIsPointingAtEnemy())
				return;
			
			dispatchEvent(new WeaponEvent(WeaponEvent.FIRE));
			
			shootingOffsetY = (NSMath.random() > 0.5) ? shootingOffsetY : (-shootingOffsetY);
			
			var cosA:Number = NSMath.cosRad(headAngle);
			var sinA:Number = NSMath.sinRad(headAngle);
			
			fireBullet(x + shootingOffsetX * cosA - shootingOffsetY * sinA, y + shootingOffsetX * sinA + shootingOffsetY * cosA);
			
			shootDelayTimer.start();
			
			animateGun();
		}
		
		private function ensureCannonIsPointingAtEnemy():Boolean
		{
			var dx:Number = hitObject.x - x;
			var dy:Number = hitObject.y - y;
			var goalAngle:Number = NSMath.atan2Rad(dy, dx);
			
			return TrigonometryUtil.calcArcDifference(headAngle, goalAngle) < 0.1; // less then 18 degrees
		}
		
		private function delayBeforeShootingTimer_completedHandler(event:AdvancedTimerEvent):void
		{
			tryFire();
		}
		
		protected function fireBullet(x:int, y:int):void
		{
			var params:Object = new Object();
			params.type = (currentInfo.weaponType == WeaponType.ENEMY) ? BulletType.ENEMY : BulletType.USER;
			params.x = x;
			params.y = y;
			params.radius = WeaponContants.CANNON_BULLET_RADIUS;
			params.hitPower = currentInfo.hitPower;
			
			WeaponController.launchBullet(CannonBullet, params, hitTarget.x, hitTarget.y, 1 / currentInfo.bulletSpeed);
		}
		
		protected function animateGun():void
		{
			if (!gun || !headPart)
				return;
			
			var speed:Number = 100;
			
			AnimationEngine.globalAnimator.moveObjects(gun, gun.x, gun.y, gun.x - 4, gun.y, speed);
			AnimationEngine.globalAnimator.moveObjects(gun, gun.x - 4, gun.y, gun.x, gun.y, speed, AnimationEngine.globalAnimator + speed);
			
			AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x, headPart.y, headPart.x - 1, headPart.y, speed);
			AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x - 1, headPart.y, headPart.x, headPart.y, speed, AnimationEngine.globalAnimator + speed);
		}
		
		override public function deactivate():void 
		{
			super.deactivate();
			delayBeforeShootingTimer.reset();
		}
	
		//------------------------------------------------------------------------------
		//
		// Drawing levels
		//
		//------------------------------------------------------------------------------
	
		// no implementation
	}

}