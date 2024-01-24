/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.base
{
	import islandBreak.controllers.WeaponController;
	import events.WeaponEvent;
	import flash.display.Bitmap;
	import nslib.animation.engines.AnimationEngine;
	import nslib.utils.NSMath;
	import supportClasses.BulletType;
	import supportClasses.WeaponType;
	import weapons.ammo.bullets.ElectricBullet;
	import weapons.ammo.lightnings.SequencedLightning;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ElectricCannonBase extends Weapon
	{
		//////////////////////
		
		protected var headPart:Bitmap = null
		
		////////////////////////////////////////////////////////////
		
		public function ElectricCannonBase(weaponId:String = null, level:int = 0)
		{
			super(weaponId, level);
		}
		
		////////////////////////////////////////////////////////////
		
		override protected function tryFire():void
		{
			if (!hitTarget || shootDelayTimer.running)
				return;
			
			dispatchEvent(new WeaponEvent(WeaponEvent.FIRE));
			
			var cosA:Number = NSMath.cosRad(headAngle);
			var sinA:Number = NSMath.sinRad(headAngle);
			
			fireBullet(x + shootingOffsetX * cosA - shootingOffsetY * sinA, y + shootingOffsetX * sinA + shootingOffsetY * cosA);
			
			shootDelayTimer.start();
			
			if (currentInfo.level == 0)
				animateGun();
		}
		
		protected function fireBullet(x:int, y:int):void
		{
			var params:Object = new Object();
			params.type = (currentInfo.weaponType == WeaponType.ENEMY) ? BulletType.ENEMY : BulletType.USER;
			params.x = hitTarget.x;
			params.y = hitTarget.y;
			params.hitPower = currentInfo.hitPower;
			params.freezingBullet = currentInfo.canFreezeUnits;
			params.electrolizingDuration = currentInfo.electrolizingDuration;
			
			var currentColor:int = 0;
			
			switch (currentInfo.level)
			{
				case 0: 
					currentColor = SequencedLightning.COLOR_BLUE;
					break;
				case 1: 
					currentColor = SequencedLightning.COLOR_PINK;
					break;
				case 2: 
					currentColor = SequencedLightning.COLOR_VIOLET;
					break;
			}
			
			WeaponController.launchBullet(ElectricBullet, params, hitTarget.x, hitTarget.y, 0);
			WeaponController.putLightning(x, y, hitTarget.x, hitTarget.y, currentColor);
		}
		
		protected function animateGun():void
		{
			if (!headPart)
				return;
			
			var speed:Number = 100;
			
			headPart.x = headPart.width / 1.5;
			headPart.y = -headPart.height / 2;
			
			AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x, headPart.y, headPart.x - 4, headPart.y, speed);
			AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x - 4, headPart.y, headPart.x, headPart.y, speed, AnimationEngine.globalAnimator.currentTime + speed);
		}
	
		//------------------------------------------------------------------------------
		//
		// Drawing levels
		//
		//------------------------------------------------------------------------------	
	
		// no immplementation here
	}

}