/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.mapObjects
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import nslib.controls.NSSprite;
	import nslib.sequencers.ImageSequencer;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Snow extends NSSprite
	{
		private var snowSequence:ImageSequencer = new ImageSequencer();
		
		private var numSnowFrames:int = 10;
		
		//////////
		
		public function Snow()
		{
			construct();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		///////////
		
		private function construct():void
		{
			snowSequence.smoothing = false;
			snowSequence.frameRate = 10;
			snowSequence.playInLoop = true;
			
			for (var i:int = 0; i < numSnowFrames; i++)
				snowSequence.addImage(generateRaneBitmap());
			
			addChild(snowSequence);
		}
		
		///////////
		
		private function generateRaneBitmap():Bitmap
		{
			var snowData:BitmapData = new BitmapData(GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT, true, 0x00000000);
			
			var density:int = 50;
			
			var flake:Shape = new Shape();
			flake.graphics.lineStyle(0, 0xFFFFFF, 0.5);
			flake.graphics.beginFill(0xFFFFFF);
			flake.graphics.drawCircle(0, 0, 1);
			
			for (var i:int = 0; i < density; i++)
			{
				var matrix:Matrix = new Matrix();
				matrix.translate(GamePlayConstants.STAGE_WIDTH * Math.random(), GamePlayConstants.STAGE_HEIGHT * Math.random());
				snowData.draw(flake, matrix, null);
			}
			
			return new Bitmap(snowData);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			snowSequence.start();
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			snowSequence.stop();
		}
	}

}