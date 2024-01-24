/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package events
{
	import flash.events.Event;
	import weapons.base.IWeapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TeleportEvent extends Event
	{
		public static const DISAPPEAR_ANIMATION_COMPLETED:String = "disappearAnimationCompleted";
		
		public static const APPEAR_ANIMATION_COMPLETED:String = "appearAnimationCompleted";
		
		/////////////
		
		public var weapon:IWeapon = null;
		
		public function TeleportEvent(type:String, weapon:IWeapon)
		{
			super(type);
			
			this.weapon = weapon;
		}
	
	}

}