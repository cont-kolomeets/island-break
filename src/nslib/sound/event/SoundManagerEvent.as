/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.sound.event 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SoundManagerEvent extends Event
	{
		public static const ALL_SOUNDS_FINISHED_PLAYING:String = "allSoundsFinishedPlaying";
		
		public function SoundManagerEvent(type:String) 
		{
			super(type);
		}
		
	}

}