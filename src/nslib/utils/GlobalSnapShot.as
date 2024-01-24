/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class GlobalSnapShot
	{
		public static var bitmapData:BitmapData;
		
		private var stage:Stage;
		
		public function GlobalSnapShot() 
		{
		}
		
		public function start(stage:Stage):void
		{
			this.stage = stage;
			
			bitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false);
			stage.addEventListener(Event.ENTER_FRAME, frameListener);
		}
		
		public function stop():void
		{
			if (stage)
				stage.removeEventListener(Event.ENTER_FRAME, frameListener);
		}
		
		private function frameListener(event:Event):void
		{
		 if (stage)
			{
				bitmapData.draw(stage);
			}
		}
		
	}

}