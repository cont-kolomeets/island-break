/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.sequencers
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.controls.NSSprite;
	import nslib.core.IReusable;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ImageSequencer extends NSSprite implements IReusable
	{
		public static const STARTED:String = "started";
		
		public static const STOPPED:String = "stopped";
		
		/////////////////////////////////
		
		public var playInLoop:Boolean = true;
		
		public var clearOnStop:Boolean = false;
		
		public var frameRate:int = 25;
		
		public var running:Boolean = false;
		
		private var bitmaps:Array = [];
		
		private var currentTime:Number = 0;
		
		private var currentFrame:int = 0;
		
		private var deltaTimeCounter:DeltaTime = DeltaTime.globalDeltaTimeCounter;
		
		///////////////////////////////
		
		public function ImageSequencer()
		{
		
		}
		
		//----------------------------------
		//  poolID
		//----------------------------------
		
		private var _poolID:String = "none";
		
		public function get poolID():String
		{
			return _poolID;
		}
		
		public function set poolID(value:String):void
		{
			_poolID = value;
		}
		
		////////////////////////////////
		
		private var calculatedWidth:Number = 0;
		
		override public function get width():Number
		{
			return calculatedWidth;
		}
		
		override public function set width(value:Number):void
		{
			//
		}
		
		////
		
		private var calculatedHeight:Number = 0;
		
		override public function get height():Number
		{
			return calculatedHeight;
		}
		
		override public function set height(value:Number):void
		{
			//
		}
		
		////
		
		public function get sequenceLength():int
		{
			return bitmaps.length;
		}
		
		/////////
		
		private var _smoothing:Boolean = false;
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
			
			for each (var bm:Bitmap in bitmaps)
				bm.smoothing = value;
		}
		
		//////////////////////////////
		
		public function prepareForPooling():void
		{
			// no implementation
		}
		
		public function prepareForReuse():void
		{
			// no implementation
		}
		
		public function sequenceFromAtlas(atlas:Atlas):void
		{
			bitmaps = atlas.generateBitmaps();
			
			stop();
			recalcDimentions();
		}
		
		public function addImage(image:*):void
		{
			stop();
			addSingleImage(image);
			recalcDimentions();
		}
		
		public function addImages(images:Array):void
		{
			stop();
			
			for each (var image:*in images)
				addSingleImage(image);
			
			recalcDimentions();
		}
		
		// adds an image without recalculating the dimentions
		private function addSingleImage(image:*):void
		{
			var bitmap:Bitmap;
			
			if (image is Class)
			{
				var val:* = new image();
				bitmap = new Bitmap(val.bitmapData);
			}
			else if (image is Bitmap)
				bitmap = image as Bitmap;
			else if (image is DisplayObject)
			{
				var bitmapData:BitmapData = new BitmapData(DisplayObject(image).width, DisplayObject(image).height, true, 0x00000000);
				bitmapData.draw(DisplayObject(image));
				bitmap = new Bitmap(bitmapData);
			}
			else
				return;
			
			bitmap.smoothing = smoothing;
			bitmaps.push(bitmap);
			
			removeAllChildren();
			addChild(bitmaps[0] as Bitmap);
		}
		
		/////////////////////////
		
		public function start():void
		{
			if (bitmaps.length == 0)
				return;
			
			if (currentTime == 0)
			{
				removeAllChildren();
				addChild(bitmaps[0] as Bitmap);
				currentFrame = 0;
			}
			
			if (bitmaps.length == 1)
				return;
			
			running = true;
			
			if (deltaTimeCounter)
				deltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeCounter_deltaTimeAquiredHandler);
			
			dispatchEvent(new Event(STARTED));
		}
		
		public function suspend():void
		{
			running = false;
			
			if (deltaTimeCounter)
				deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeCounter_deltaTimeAquiredHandler);
		}
		
		public function stop():void
		{
			running = false;
			
			if (deltaTimeCounter)
				deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeCounter_deltaTimeAquiredHandler);
			
			currentTime = 0;
			currentFrame = 0;
			
			if (clearOnStop)
				removeAllChildren();
			
			dispatchEvent(new Event(STOPPED));
		}
		
		private function deltaTimeCounter_deltaTimeAquiredHandler(event:DeltaTimeEvent):void
		{
			currentTime += event.lastDeltaTime;
			
			var frame:int = currentTime / (1000 / frameRate);
			
			if (frame > currentFrame && frame < bitmaps.length)
			{
				removeAllChildren();
				addChild(bitmaps[frame] as Bitmap);
				currentFrame = frame;
			}
			else if (frame >= bitmaps.length && playInLoop)
			{
				removeAllChildren();
				currentFrame = 0;
				currentTime = 0;
				addChild(bitmaps[0] as Bitmap);
			}
			else if (frame >= bitmaps.length && !playInLoop)
				stop();
		}
		
		/////////////////////////
		
		private function recalcDimentions():void
		{
			calculatedWidth = 0;
			calculatedHeight = 0;
			
			for each (var bitmap:Bitmap in bitmaps)
			{
				calculatedWidth = NSMath.max(calculatedWidth, bitmap.width);
				calculatedHeight = NSMath.max(calculatedHeight, bitmap.height);
			}
		
		}
		
		/////////////////////////
		
		public function clear():void
		{
			removeAllChildren();
		}
		
		public function removeAllImages():void
		{
			stop();
			clear();
			bitmaps.length = 0;
		}
		
		public function getCurrentBitmapData():BitmapData
		{
			if (numChildren > 0)
				return Bitmap(getChildAt(0)).bitmapData;
			
			return null;
		}
		
		public function setCurrentFrameIndex(index:int):void
		{
			if (index < 0 || index > (bitmaps.length-1))
				throw new Error("Specified frame index is out of range!");
				
			// need to hold the sequence
			suspend();
			// reset time so on next start it will run from the beginning
			currentTime = 0;
			currentFrame = index;
			removeAllChildren();
			addChild(bitmaps[index] as Bitmap);
		}
		
		///////////
		
		public function reverseBitmapSequence():void
		{
			stop();
			bitmaps = bitmaps.reverse();
		}	
	}

}