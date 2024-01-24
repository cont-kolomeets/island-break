/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class DamagableObjectEvent extends Event 
	{
		public static const DAMAGED:String = "damaged";
		
		public static const EXPLODE:String = "explode";
		
		public function DamagableObjectEvent(type:String) 
		{ 
			super(type);	
		} 
		
	}
	
}