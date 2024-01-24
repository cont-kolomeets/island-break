package nslib.effects.traceEffects
{
	import bot.GameBot;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nslib.utils.ObjectsPoolUtil;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class DynamicTraceController extends TraceControllerBase
	{
		private var container:IDynamicTracableContainer;
		
		private var blurFilter:BlurFilter = new BlurFilter(2, 2, BitmapFilterQuality.LOW);
		
		// optimization
		private var refPoint:Point = new Point();
		
		// optimization
		private var refRect:Rectangle = new Rectangle();
		
		////////////////
		
		public function DynamicTraceController(container:IDynamicTracableContainer)
		{
			this.container = container;
			// this will be needed throughout the entire game
			container.addEventListener(Event.ENTER_FRAME, container_enterFrameHandler);
		}
		
		/////////////////
		
		private function container_enterFrameHandler(event:Event):void
		{
			updateTraceArea();
		}
		
		///////////////
		
		private function updateTraceArea():void
		{
			container.applyTraceColorTransform();
			
			var to:TracableObject = null;
			
			var wasLocked:Boolean = tracableObjects.locked;
			tracableObjects.locked = true;
			
			var bitmap:Bitmap = null;
			
			for each (to in tracableObjects.source)
				applyTO(to);
			
			tracableObjects.locked = wasLocked;
			
			//container.applyFilter(blurFilter);
			
			wasLocked = tracableObjectsToApplyAfterBlurring.locked;
			tracableObjectsToApplyAfterBlurring.locked = true;
			
			for each (to in tracableObjectsToApplyAfterBlurring.source)
				applyTO(to);
			
			tracableObjectsToApplyAfterBlurring.locked = wasLocked;
			
			if (tracableObjectsToRemove.length > 0)
			{
				for each (to in tracableObjectsToRemove)
				{
					tracableObjects.removeItem(to);
					tracableObjectsToApplyAfterBlurring.removeItem(to);
					ObjectsPoolUtil.returnObject(to);
				}
				
				tracableObjectsToRemove.length = 0;
			}
		}
		
		private function applyTO(to:TracableObject):void
		{
			to.performColorTransform();
			refPoint.x = to.x - to.radius - 1;
			refPoint.y = to.y - to.radius - 1;
			
			var bitmaps:Array = container.getTracableBitMapsToDrawAtXY(refPoint.x, refPoint.y, refPoint.x + to.bitmapData.width, refPoint.y + to.bitmapData.height);
			
			for each (var bitmap:Bitmap in bitmaps)
			{
				// might be outside the screen
				if (!bitmap)
					return;
				
				refPoint.x -= bitmap.x;
				refPoint.y -= bitmap.y;
				
				bitmap.bitmapData.lock();
				bitmap.bitmapData.copyPixels(to.bitmapData, to.rect, refPoint, null, null, true);
				bitmap.bitmapData.unlock();
				
				refPoint.x += bitmap.x;
				refPoint.y += bitmap.y;
			}
		}
		
		//////////////
		
		override public function putImageForFadingAt(x:int, y:int, bitmapData:BitmapData):void
		{
			refPoint.x = x;
			refPoint.y = y;
			
			var bitmaps:Array = container.getTracableBitMapsToDrawAtXY(refPoint.x, refPoint.y, refPoint.x + bitmapData.width, refPoint.y + bitmapData.height);
			
			for each (var bitmap:Bitmap in bitmaps)
			{
				// might be outside the screen
				if (!bitmap)
					return;
				
				refPoint.x -= bitmap.x;
				refPoint.y -= bitmap.y;
				
				bitmap.bitmapData.lock();
				bitmap.bitmapData.copyPixels(bitmapData, bitmapData.rect, refPoint, null, null, true);
				bitmap.bitmapData.unlock();
				
				refPoint.x += bitmap.x;
				refPoint.y += bitmap.y;
			}
		}
		
		/////////////////////////////////////
		
		override public function putPermanentImage(spotObject:*, params:Object = null):void
		{
			var spot:TracableObject = null;
			
			if (spotObject is Class)
				spot = ObjectsPoolUtil.takeObject(Class(spotObject), params);
			else if (spotObject is TracableObject)
				spot = spotObject;
			else
				return;
			
			spot.createBitmapData();
			
			applyTO(spot);
			
			ObjectsPoolUtil.returnObject(spot);
		}
		
		override public function putPermanentBitmapDataAt(bitmapData:BitmapData, x:Number, y:Number):void
		{
			refPoint.x = x;
			refPoint.y = y;
			
			//container.permanentBitmapData.copyPixels(bitmapData, refRect, refPoint, null, null, true);
			
			var bitmaps:Array = container.getPermanentBitMapsToDrawAtXY(refPoint.x, refPoint.y, refPoint.x + bitmapData.width, refPoint.y + bitmapData.height);
			
			for each (var bitmap:Bitmap in bitmaps)
			{
				// might be outside the screen
				if (!bitmap)
					return;
				
				refPoint.x -= bitmap.x;
				refPoint.y -= bitmap.y;
				
				bitmap.bitmapData.lock();
				bitmap.bitmapData.copyPixels(bitmapData, bitmapData.rect, refPoint, null, null, true);
				bitmap.bitmapData.unlock();
				
				refPoint.x += bitmap.x;
				refPoint.y += bitmap.y;
			}
		}
	
	}

}