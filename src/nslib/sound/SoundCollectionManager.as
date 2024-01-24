/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.sound
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import nslib.utils.GlobalTrace;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class SoundCollectionManager
	{
		private var maxLimit:int = 0;
		
		private var playCount:int = 0;
		
		private var localSound:Sound = null;
		
		private var localSoundTransform:SoundTransform = new SoundTransform();
		
		////////////
		
		public function SoundCollectionManager(soundClass:Class, maxLimit:int = 1)
		{
			this.maxLimit = maxLimit;
			localSound = new soundClass() as Sound;
		}
		
		////////////
		
		public function requestPlaySound(volume:Number = 1):void
		{
			if (playCount >= maxLimit)
				return;
			
			var channel:SoundChannel = localSound.play(0, 0);
			
			// if the channel cannot be allocated
			// then just leave
			if (!channel)
				return;
				
			playCount++;
			
			GlobalTrace.traceText(playCount);
			
			localSoundTransform.volume = volume;
			channel.soundTransform = localSoundTransform;
			
			channel.addEventListener(Event.SOUND_COMPLETE, channel_soundCompleteHandler);
		}
		
		private function channel_soundCompleteHandler(event:Event):void
		{
			var channel:SoundChannel = event.currentTarget as SoundChannel;
			channel.removeEventListener(Event.SOUND_COMPLETE, channel_soundCompleteHandler);
			channel.stop();
			
			playCount--;
		}
	
	}

}