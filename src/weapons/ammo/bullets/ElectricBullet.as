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
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ElectricBullet extends AbstractBullet
	{
		public var freezingBullet:Boolean = false;
		
		public var electrolizingDuration:Number = 0;
		
		////////////////////////////////////////////////////////////////////////
		
		public function ElectricBullet(type:String="user")
		{
			super(0);
			this.type = type;
			selfHitPower = WeaponContants.ELECTRIC_BULLET_HIT_POWER;
			fadeMultiplier = 0;
		}
		
		//////////////////////////////////////////////////////
		
		override public function prepareForReuse():void 
		{
			super.prepareForReuse();
			selfHitPower = WeaponContants.ELECTRIC_BULLET_HIT_POWER;
			fadeMultiplier = 0;
			freezingBullet = false;
		}
		
		override protected function draw():Shape
		{
			return new Shape();
		}
	}

}