/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.ammo.bullets
{
	import constants.WeaponContants;
	import flash.display.Shape;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MachineGunBullet extends AbstractBullet
	{
		private static var bulletShapes:Array = [];
		
		////////////////////////////////////////////////////////////////////////
		
		public function MachineGunBullet(type:String = "user", rotation:Number = 0)
		{
			super(WeaponContants.MACHINE_GUN_BULLET_RADIUS, rotation);
			this.type = type;
			selfHitPower = WeaponContants.MACHINE_GUN_BULLET_HIT_POWER;
			fadeMultiplier = WeaponContants.MACHINE_GUN_BULLET_FADE_MULTIPLIER;
		}
		
		//////////////////////////////////////////////////////
		
		override public function prepareForReuse():void
		{
			super.prepareForReuse();
			selfHitPower = WeaponContants.MACHINE_GUN_BULLET_HIT_POWER;
			fadeMultiplier = WeaponContants.MACHINE_GUN_BULLET_FADE_MULTIPLIER;
		}
		
		override public function get applyBeforeBlurring():Boolean
		{
			return false;
		}
		
		override protected function draw():Shape
		{
			// 5 degree precision
			var index:int = int(NSMath.radToDeg(rotation) / 5);
			var bulletShape:Shape = bulletShapes[index];
			
			if (!bulletShape)
			{
				bulletShape = new Shape();
				bulletShape.graphics.lineStyle(3, 0x3F3F3F);
				bulletShape.graphics.moveTo(0, 0);
				bulletShape.graphics.lineTo(5 * NSMath.cosRad(rotation), 5 * NSMath.sinRad(rotation));
				
				bulletShapes[index] = bulletShape;
			}
			
			return bulletShape;
		}
	}

}