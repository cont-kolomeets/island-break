/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.sound
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.core.Globals;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class SoundLooper
	{
		private var localSound:Sound = null;
		
		private var firstChannel:SoundChannel = null;
		private var secondChannel:SoundChannel = null;
		
		private var currentPlayingChannel:SoundChannel = null;
		
		private var delayTimer:Timer = new Timer(100, 1);
		
		/////////////////
		
		public function SoundLooper(soundClass:Class, mergeInterval:Number = 0)
		{
			localSound = new soundClass() as Sound;
			
			delayTimer.delay = localSound.length - mergeInterval;
		}
		
		//////////////////
		
		private var _volume:Number = 1;
		
		private var localSoundTransform:SoundTransform = new SoundTransform();
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
			
			localSoundTransform.volume = value;
			
			if (firstChannel)
				firstChannel.soundTransform = localSoundTransform;
			
			if (secondChannel)
				secondChannel.soundTransform = localSoundTransform;
		}
		
		public function get currentChannel():SoundChannel
		{
			return currentPlayingChannel;
		}
		
		////////////////// palying in loops
		
		public function play(volume:Number/*, delay:Number = 0*/):SoundChannel
		{
			stopImmediately();
			
			firstChannel = localSound.play(0/*delay*/, 0, localSoundTransform);
			this.volume = volume;
			
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayTimer_timerCompletedHandler);
			delayTimer.reset();
			delayTimer.start();
			
			currentPlayingChannel = firstChannel;
			
			return currentPlayingChannel;
		}
		
		public function stopImmediately():void
		{
			delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, delayTimer_timerCompletedHandler);
			
			if (firstChannel)
				firstChannel.stop();
			
			if (secondChannel)
				secondChannel.stop();
		}
		
		private function delayTimer_timerCompletedHandler(event:Event):void
		{
			if (currentPlayingChannel == firstChannel)
			{
				if (secondChannel)
					secondChannel.stop();
				
				secondChannel = localSound.play(0, 0, localSoundTransform);
				this.volume = volume;
				currentPlayingChannel = secondChannel;
			}
			else if (currentPlayingChannel == secondChannel)
			{
				if (firstChannel)
					firstChannel.stop();
				
				firstChannel = localSound.play(0, 0, localSoundTransform);
				this.volume = volume;
				currentPlayingChannel = firstChannel;
			}
			
			delayTimer.reset();
			delayTimer.start();
		}
		
		/////////////////// fading out
		
		private var deltaTimeCounter:DeltaTime = null;
		
		private var initialVolumeLevel:Number = 0;
		
		private var fadeDuration:Number = 0;
		
		public function stopWhileFadingOut(fadeOut:Boolean = false, fadeDuration:Number = 1000):void
		{
			if (fadeOut)
			{
				if (!deltaTimeCounter)
					deltaTimeCounter = new DeltaTime(Globals.topLevelApplication);
				
				initialVolumeLevel = _volume;
				this.fadeDuration = fadeDuration;
				deltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameHandler);
			}
		}
		
		private function frameHandler(event:DeltaTimeEvent):void
		{
			volume -= initialVolumeLevel * event.lastDeltaTime / fadeDuration;
			
			if (volume <= 0)
			{
				stopImmediately();
				deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameHandler);
			}
		}
	
	}

}