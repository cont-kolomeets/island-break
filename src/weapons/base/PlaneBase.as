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
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import nslib.controls.NSSprite;
	import nslib.utils.NSMath;
	import supportClasses.BulletType;
	import supportClasses.WeaponType;
	import weapons.ammo.bullets.MachineGunBullet;
	import weapons.base.AirCraft;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PlaneBase extends AirCraft
	{	
		
		protected var shadowContainer:NSSprite = new NSSprite();
		
		protected var shadowStaticContainer:NSSprite = null;
		
		///////////////////
		
		public function PlaneBase(weaponId:String = null, level:int = 0)
		{
			super(weaponId, level);
		}
		
		////////////////////////////
		
		override public function get bodyAngle():Number 
		{
			return super.bodyAngle;
		}
		
		override public function set bodyAngle(value:Number):void 
		{
			super.bodyAngle = value;
			adjustShadow();
		}
		
		/////////////////////////////
		
		override protected function fireAtTarget(target:Point):void
		{
			if (!target || shootDelayTimer.running || !currentInfo.isAmmoSupport)
				return;
			
			dispatchEvent(new WeaponEvent(WeaponEvent.FIRE));
			
			shootingOffsetY = (NSMath.random() > 0.5) ? shootingOffsetY : (-shootingOffsetY);
			
			fireBullet(x + shootingOffsetX * currentCosA + shootingOffsetY * currentSinA, y + shootingOffsetX * currentSinA + shootingOffsetY * currentCosA, target.x, target.y);
			
			shootDelayTimer.start();
		}
		
		private function fireBullet(xFrom:int, yFrom:int, xTo:int, yTo:int):void
		{
			var params:Object = new Object();
			params.type = (currentInfo.weaponType == WeaponType.ENEMY) ? BulletType.ENEMY : BulletType.USER;
			params.x = xFrom;
			params.y = yFrom;
			params.radius = WeaponContants.MACHINE_GUN_BULLET_RADIUS;
			params.rotation = NSMath.degToRad(body.rotation);
			params.hitPower = currentInfo.hitPower;
			
			WeaponController.launchBullet(MachineGunBullet, params, xTo, yTo, 1 / currentInfo.bulletSpeed);
		}
		
		////////////////////
		
		override protected function tryReachPoint(point:Point):void
		{
			super.tryReachPoint(point);
			
			adjustShadow();
			leaveTrace();
		}
		
		//------------------------------------------------------------------------------
		//
		// Drawing levels
		//
		//------------------------------------------------------------------------------
		
		protected var traceBitmapData:BitmapData = null;
		
		protected var traceOffsetX:Number = 0;
		
		protected var traceOffsetY:Number = 8;
		
		protected function prepareTrace(useEmptyTrace:Boolean = false):void
		{
			if (useEmptyTrace)
			{
				traceBitmapData = null;
			}
			else
			{
				var shape:Shape = new Shape();
				shape.graphics.beginFill(0, 1);
				shape.graphics.drawCircle(2, 2, 2);
				
				traceBitmapData = new BitmapData(4, 4, true, 0x000000);
				traceBitmapData.draw(shape);
			}
		}
		
		private function leaveTrace():void
		{
			if (!traceBitmapData)
				return;
			
			var x1:Number = x + traceOffsetX * currentCosA - traceOffsetY * currentSinA;
			var y1:Number = y + traceOffsetX * currentSinA + traceOffsetY * currentCosA;
			
			WeaponController.putImageForFadingAt(x1, y1, traceBitmapData);
			
			if (traceOffsetY != 0)
			{
				var x2:Number = x + traceOffsetX * currentCosA - (-traceOffsetY) * currentSinA;
				var y2:Number = y + traceOffsetX * currentSinA + (-traceOffsetY) * currentCosA;
				
				WeaponController.putImageForFadingAt(x2, y2, traceBitmapData);
			}
		}
		
		// regardless of the rotation angle the shadow should be offset in the same direction
		protected function adjustShadow():void
		{
			shadowContainer.x = 30;
			shadowContainer.y = 30;
			shadowContainer.rotation = body.rotation;
			
			if (shadowStaticContainer)
			{
				shadowStaticContainer.x = 30;
				shadowStaticContainer.y = 30;
			}
		}
	}

}