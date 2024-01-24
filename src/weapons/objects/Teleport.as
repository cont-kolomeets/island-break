/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.objects
{
	import flash.geom.Rectangle;
	import nslib.controls.NSSprite;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;

	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Teleport extends NSSprite
	{		
		public var rect:Rectangle = null;
		
		//public var oneWay:Boolean = false;
		
		public var oppositePort:Teleport = null;
		
		//////////////
		
		public function Teleport():void
		{
			
		}
		
		///////////////
		
		public function showDisappearAnimationForWeapon(weapon:Weapon, moveToTeleportPosition:Boolean = false, callBack:Function = null):void
		{
			// must be implemented in subclasses
		}
		
		public function showAppearAnimationForWeapon(weapon:IWeapon, moveToTeleportPosition:Boolean = true, duration:Number = 300, callBack:Function = null):void
		{
			// must be implemented in subclasses
		}
	}

}