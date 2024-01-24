/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.sound
{
	import flash.media.SoundChannel;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class SoundEffectManager
	{
		private var deltaTimeConter:DeltaTime = DeltaTime.globalDeltaTimeCounter;
		
		private var isBusy:Boolean = false;
		
		private var duration:Number = 0;
		
		private var initialVolumLevel:Number = 1;
		
		private var currentVolumLevel:Number = 1;
		
		private var volumeTo:Number = 1;
		
		private var channelFrom:SoundChannel = null;
		
		private var channelTo:SoundChannel = null;
		
		private var fadingOut:Boolean = true;
		
		/////////////////
		
		public function SoundEffectManager()
		{
		
		}
		
		/////////////////
		
		/// the first channel fades out then the second fades in
		public function perfromSmoothTransitionBetweenChannels(channelFrom:SoundChannel, channelTo:SoundChannel, duration:Number = 1000):void
		{
			if (isBusy)
				return;
			
			isBusy = true;
			
			// configuring
			this.channelFrom = channelFrom;
			this.channelTo = channelTo;
			initialVolumLevel = channelFrom.soundTransform.volume;
			currentVolumLevel = initialVolumLevel;
			volumeTo = initialVolumLevel;
			this.duration = duration;
			fadingOut = true;
			
			deltaTimeConter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameHandler);
		}
		
		private function frameHandler(event:DeltaTimeEvent):void
		{
			if (fadingOut)
			{
				currentVolumLevel -= initialVolumLevel * event.lastDeltaTime / (duration / 2);
				
				channelFrom.soundTransform.volume = Math.max(0, currentVolumLevel);;
				
				if (currentVolumLevel <= 0)
				{
					channelFrom.stop();
					currentVolumLevel = 0;
					fadingOut = false;
					
					if (!channelTo)
						stop();
				}
			}
			else
			{
				currentVolumLevel += volumeTo * event.lastDeltaTime / (duration / 2);
				
				channelTo.soundTransform.volume = Math.min(1, currentVolumLevel);;
				
				if (currentVolumLevel >= volumeTo)
					stop();
			}
		
		}
		
		public function isRunning():Boolean
		{
			return isBusy;
		}
		
		public function stop():void
		{
			isBusy = false;
			deltaTimeConter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameHandler);
		}
	
	}

}