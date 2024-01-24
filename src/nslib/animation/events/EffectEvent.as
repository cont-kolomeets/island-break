/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.animation.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class EffectEvent extends Event
	{
		public static const EFFECT_ENDED:String = "effectEnded";
		
		public function EffectEvent(type:String) 
		{
			super(type);
		}
		
	}

}