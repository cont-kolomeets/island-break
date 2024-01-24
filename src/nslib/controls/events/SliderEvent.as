/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SliderEvent extends Event 
	{
		public static const VALUE_CHANGED:String = "valueChanged";
		
		public static const THUMB_RELEASED:String = "thumbReleased";
		
		public var newValue:Number = 0;
		
		// whether the value was changed by a user
		public var userInteraction:Boolean = false;
		
		public function SliderEvent(type:String, newValue:Number, userInteraction:Boolean) 
		{
			super(type);
			
			this.newValue = newValue;
			this.userInteraction = userInteraction;
		}
		
	}

}