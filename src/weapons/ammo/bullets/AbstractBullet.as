/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.ammo.bullets 
{
	import nslib.effects.traceEffects.TracableObject;
	import supportClasses.WeaponType;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AbstractBullet extends TracableObject implements IBullet
	{
		protected var selfHitPower:Number = 0;
		
		public function AbstractBullet(radius:Number = 0, rotation:Number = 0) 
		{
			super(radius, rotation);
		}
		
		////////////////////////////////////////

		private var _type:String = WeaponType.NONE;
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		//////////////
		
		private var _hitPower:Number = 0;
		
		public function get hitPower():Number 
		{
			return _hitPower;
		}
		
		public function set hitPower(value:Number):void 
		{
			_hitPower = selfHitPower * value;
		}
		
		///////////////////////////////////////
		
		override public function prepareForReuse():void 
		{
			super.prepareForReuse();
			
			// reseting parameters
			hitPower = 0;
		}
		
	}

}