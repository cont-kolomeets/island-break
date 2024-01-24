/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class FPSMonitor extends Sprite
	{
		public var running:Boolean = false;
		
		private var fpsShown:Boolean = true;
		
		private var textField:TextField = new TextField();
		
		private var avg:Number = 0;
		
		private var measuresCount:Number = 0;
		
		private var sum:Number = 0;
		
		///////////////////////////////////////////////
		
		public function FPSMonitor()
		{			
			addChild(textField);
			
			DeltaTime.globalDeltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, delatTimeAquiredHandler);
			running = true;
		}
		
		///////////////////////////////////////////////
		
		public function set showFPS(value:Boolean):void
		{
			if (value && !fpsShown)
				addChild(textField);
			
			if (!value && fpsShown)
				removeChild(textField);
		}
		
		///////////////////////////////////////////////
		
		public function stop():void
		{
			DeltaTime.globalDeltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, delatTimeAquiredHandler);
			running = false;
		}
		
		public function start():void
		{
			DeltaTime.globalDeltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, delatTimeAquiredHandler);
			running = true;
		}
		
		private function delatTimeAquiredHandler(event:DeltaTimeEvent):void
		{
			if (fpsShown)
			{
				sum += 1000.0 / (event.lastDeltaTime + 0.1);
				avg = sum / (++measuresCount);
				
				textField.text = "fps " + int(1000 / event.lastDeltaTime) + "\n avg " + avg.toFixed(1);
			}
		}
	
	}

}