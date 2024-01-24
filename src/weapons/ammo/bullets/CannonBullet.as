/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.ammo.bullets
{
	import constants.WeaponContants;
	import flash.display.Bitmap;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class CannonBullet extends AbstractBullet
	{
		[Embed(source="F:/Island Defence/media/images/weapon/common weapon/cannon ball small.png")]
		private static var cannonBallImage:Class;
		
		private static var cannonBall:Bitmap = new cannonBallImage() as Bitmap;
		
		private static var bulletCannonShapes:Array = [];
		
		private static var bulletExplosionShapes:Array = [];
		
		////////////////////////////////////////////////////////////////////////
		
		public var isFromExplosion:Boolean = false;
		
		public function CannonBullet(type:String = "none")
		{
			super(WeaponContants.CANNON_BULLET_RADIUS);
			this.type = type;
			selfHitPower = WeaponContants.CANNON_BULLET_HIT_POWER;
			fadeMultiplier = WeaponContants.CANNON_BULLET_FADE_MULTIPLIER;
		}
		
		//////////////////////////////////////////////////////
		
		override public function prepareForReuse():void
		{
			super.prepareForReuse();
			selfHitPower = WeaponContants.CANNON_BULLET_HIT_POWER;
			fadeMultiplier = WeaponContants.CANNON_BULLET_FADE_MULTIPLIER;
		}
		
		override public function get applyBeforeBlurring():Boolean
		{
			return false;
		}
		
		override protected function draw():Shape
		{
			if (isFromExplosion)
			{
				var bulletExplosionShape:Shape = bulletExplosionShapes[int(radius)];
				
				if (!bulletExplosionShape)
				{
					bulletExplosionShape = new Shape();
					bulletExplosionShape.graphics.beginFill(0x787878);
					bulletExplosionShape.graphics.drawCircle(0, 0, Math.max(0, radius - 0.5));
					bulletExplosionShape.graphics.lineStyle(1, 0x3C3F3A);
					bulletExplosionShape.graphics.endFill();
					bulletExplosionShape.graphics.drawCircle(0, 0, Math.max(0, radius - 1.5));
					
					bulletExplosionShapes[int(radius)] = bulletExplosionShape;
				}
				
				return bulletExplosionShape;
			}
			else
			{
				var bulletCannonShape:Shape = bulletCannonShapes[int(radius)];
				
				if (!bulletCannonShape)
				{
					bulletCannonShape = new Shape();
					//bulletCannonShape.cacheAsBitmap = true;
					bulletCannonShape.graphics.beginBitmapFill(cannonBall.bitmapData);
					bulletCannonShape.graphics.drawRect(-cannonBall.width / 2, -cannonBall.height / 2, cannonBall.width, cannonBall.height);
					bulletCannonShape.graphics.endFill();
					
					bulletCannonShapes[int(radius)] = bulletCannonShape;
				}
				
				return bulletCannonShape;
			}
			
			return null;
		}
	}

}