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
	import nslib.utils.NSMath;
	import supportClasses.BulletType;
	import supportClasses.WeaponType;
	import weapons.ammo.bullets.MachineGunBullet;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MachineGunBase extends Weapon
	{		
		protected var headPart:Bitmap = null;
		
		//////////////////////////////////////
		
		public function MachineGunBase(weaponId:String = null, level:int = 0)
		{
			super(weaponId, level);
		}
		
		////////////////////////////////////////////////////////////
		
		override protected function tryFire():void
		{
			if (!hitTarget || shootDelayTimer.running || !currentInfo.isAmmoSupport)
				return;
			
			dispatchEvent(new WeaponEvent(WeaponEvent.FIRE));
			
			shootingOffsetY = (NSMath.random() > 0.5) ? shootingOffsetY : (-shootingOffsetY);
			
			var cosA:Number = NSMath.cosRad(headAngle);
			var sinA:Number = NSMath.sinRad(headAngle);
			
			fireBullet(x + shootingOffsetX * cosA - shootingOffsetY * sinA, y + shootingOffsetX * sinA + shootingOffsetY * cosA);
			
			shootDelayTimer.start();
			
			animateGun();
		}
		
		protected function fireBullet(x:int, y:int):void
		{
			var params:Object = new Object();
			params.type = (currentInfo.weaponType == WeaponType.ENEMY) ? BulletType.ENEMY : BulletType.USER;
			params.x = x;
			params.y = y;
			params.radius = WeaponContants.MACHINE_GUN_BULLET_RADIUS;
			params.rotation = headAngle;
			params.hitPower = currentInfo.hitPower;
			
			WeaponController.launchBullet(MachineGunBullet, params, hitTarget.x, hitTarget.y, 1 / currentInfo.bulletSpeed);
		}
		
		protected function animateGun():void
		{
			if (!headPart)
				return;
			
			var speed:Number = 25;
			
			headPart.x = headPart.width / 1.5;
			headPart.y = -headPart.height / 2;
			
			AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x, headPart.y, headPart.x - 4, headPart.y, speed);
			AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x - 4, headPart.y, headPart.x, headPart.y, speed, AnimationEngine.globalAnimator + speed);
		}
		
		//------------------------------------------------------------------------------
		//
		// Drawing levels
		//
		//------------------------------------------------------------------------------

		// no implementation
	
	}

}