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
	public class FadingTextFieldEvent extends Event
	{
		public static const FADING_IN_FINISHED:String = "fadingInFinished";
				
		public static const FADING_OUT_FINISHED:String = "fadingOutFinished";
		
		public function FadingTextFieldEvent(type:String) 
		{
			super(type);
		}
		
	}

}