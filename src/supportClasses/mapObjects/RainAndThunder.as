/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.mapObjects
{
	import constants.GamePlayConstants;
	import controllers.SoundController;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import nslib.controls.NSSprite;
	import nslib.sequencers.ImageSequencer;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	import supportClasses.resources.SoundResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class RainAndThunder extends NSSprite
	{
		private var _thunderInterval:int = 10000;
		
		private var thunderScreen:Shape = new Shape();
		
		private var rainSequence:ImageSequencer = new ImageSequencer();
		
		private var numRainFrames:int = 5;
		
		private var thunderTimer:AdvancedTimer = new AdvancedTimer(60000, 1);
		
		//////////
		
		public function RainAndThunder()
		{
			construct();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//////////
		
		public function get thunderInterval():int
		{
			return thunderTimer.delay;
		}
		
		public function set thunderInterval(value:int):void
		{
			thunderTimer.delay = value;
		}
		
		///////////
		
		private function construct():void
		{
			rainSequence.smoothing = false;
			rainSequence.frameRate = 10;
			rainSequence.playInLoop = true;
			
			thunderScreen.graphics.beginFill(0xFFFFFF, 0.2);
			thunderScreen.graphics.drawRect(0, 0, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			
			thunderScreen.visible = false;
			
			for (var i:int = 0; i < numRainFrames; i++)
				rainSequence.addImage(generateRaneBitmap());
			
			addChild(rainSequence);
			addChild(thunderScreen);
		}
		
		///////////
		
		private function generateRaneBitmap():Bitmap
		{
			var rainData:BitmapData = new BitmapData(GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT, true, 0x00000000);
			
			var density:int = 50;
			
			var drop:Shape = new Shape();
			drop.graphics.lineStyle(1, 0xFFFFFF, 0.5);
			drop.graphics.moveTo(-3, -3);
			drop.graphics.lineTo(3, 3);
			
			for (var i:int = 0; i < density; i++)
			{
				var matrix:Matrix = new Matrix();
				matrix.translate(GamePlayConstants.STAGE_WIDTH * Math.random(), GamePlayConstants.STAGE_HEIGHT * Math.random());
				rainData.draw(drop, matrix, null);
			}
			
			return new Bitmap(rainData);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			rainSequence.start();
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			thunderTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, thunderTimer_timerCompleted);
			thunderTimer.reset();
			thunderTimer.start();
		}
		
		private function thunderTimer_timerCompleted(event:AdvancedTimerEvent):void
		{
			frameCount = 0;
			thunderScreen.visible = true;
			
			thunderTimer.reset();
			thunderTimer.start();
			
			addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		private var frameCount:int = 0;
		
		private function frameHandler(event:Event):void
		{
			frameCount++;
			
			if (frameCount == 1)
				thunderScreen.visible = false;
			else if (frameCount == 3)
				thunderScreen.visible = true;
			else if (frameCount == 6)
			{
				thunderScreen.visible = false;
				removeEventListener(Event.ENTER_FRAME, frameHandler);
				
				// play thunder sound
				SoundController.instance.playSound(SoundResources.SOUND_THUNDER);
			}
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			rainSequence.stop();
			
			// stop timer
			thunderTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, thunderTimer_timerCompleted);
			thunderTimer.reset();
		}
	}

}