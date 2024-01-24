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
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class DeltaTimeEvent extends Event
	{
		public static const DELTA_TIME_AQUIRED:String = "deltaTimeAquired";
		
		/**
		 * Last delta time in milliseconds.
		 */
		public var lastDeltaTime:Number = 0;
				
		public function DeltaTimeEvent(type:String, lastDeltaTime:Number) 
		{
			super(type);
			
			this.lastDeltaTime = lastDeltaTime;
		}
		
	}

}