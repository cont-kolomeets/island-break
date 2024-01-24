/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.traceEffects
{
	import bot.GameBot;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nslib.utils.ObjectsPoolUtil;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TraceController extends TraceControllerBase
	{
		public var updatePermanentBitmapDataEveryNFrames:int = 50;
		
		private var originPoint:Point = new Point(0, 0);
		
		private var blurFilter:BlurFilter = new BlurFilter(2, 2);
		
		private var container:ITracableContainer;
		
		private var refPoint:Point = new Point();
		
		private var refRect:Rectangle = new Rectangle();
		
		/////////////////
		
		public function TraceController(container:ITracableContainer)
		{
			this.container = container;
			// this will be needed throughout the entire game
			container.addEventListener(Event.ENTER_FRAME, container_enterFrameHandler);
		}
		
		////////////////
		
		private function container_enterFrameHandler(event:Event):void
		{
			if (GameBot.supressUI)
				return;
			
			updateTraceArea();
			updatePermanentArea();
		}
		
		/////////////
		
		private function updateTraceArea():void
		{
			container.traceBitmapData.lock();
			
			container.traceBitmapData.colorTransform(container.traceRect, container.traceColorTransform);
			
			var to:TracableObject = null;
			
			var wasLocked:Boolean = tracableObjects.locked;
			tracableObjects.locked = true;
			
			for each (to in tracableObjects.source)
			{
				to.performColorTransform();
				refPoint.x = to.x - to.radius - 1;
				refPoint.y = to.y - to.radius - 1;
				container.traceBitmapData.copyPixels(to.bitmapData, to.rect, refPoint, null, null, true);
			}
			
			tracableObjects.locked = wasLocked;
			
			container.traceBitmapData.applyFilter(container.traceBitmapData, container.traceRect, originPoint, blurFilter);
			
			wasLocked = tracableObjectsToApplyAfterBlurring.locked;
			tracableObjectsToApplyAfterBlurring.locked = true;
			
			for each (to in tracableObjectsToApplyAfterBlurring.source)
			{
				to.performColorTransform();
				refPoint.x = to.x - to.radius - 1;
				refPoint.y = to.y - to.radius - 1;
				container.traceBitmapData.copyPixels(to.bitmapData, to.rect, refPoint, null, null, true);
			}
			
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
			
			container.traceBitmapData.unlock();
		}
		
		private var permanentAreaUpdateCount:int = 0;
		
		private function updatePermanentArea():void
		{
			if (!container.permanentBitmapData || !container.permanentBitmapDataColorTransform)
				return;
			
			if (++permanentAreaUpdateCount < updatePermanentBitmapDataEveryNFrames)
				return;
			else
				permanentAreaUpdateCount = 0;
			
			// usually it is nice to have a slow fading effect of permanent marks
			container.permanentBitmapData.lock();
			container.permanentBitmapData.colorTransform(container.traceRect, container.permanentBitmapDataColorTransform);
			container.traceBitmapData.unlock();
		}
		
		//////////////
		
		override public function putImageForFadingAt(x:int, y:int, bitmapData:BitmapData):void
		{
			if (GameBot.supressUI)
				return;
				
			refPoint.x = x;
			refPoint.y = y;
			container.traceBitmapData.copyPixels(bitmapData, bitmapData.rect, refPoint, null, null, true);
		}
		
		/////////////////////////////////////
		
		override public function putPermanentImage(spotObject:*, params:Object = null):void
		{
			if (GameBot.supressUI)
				return;
			
			var spot:TracableObject = null;
			
			if (spotObject is Class)
				spot = ObjectsPoolUtil.takeObject(Class(spotObject), params);
			else if (spotObject is TracableObject)
				spot = spotObject;
			else
				return;
			
			spot.createBitmapData();
			
			container.permanentBitmapData.lock();
			refPoint.x = spot.x - spot.radius - 1;
			refPoint.y = spot.y - spot.radius - 1;
			container.permanentBitmapData.copyPixels(spot.bitmapData, spot.rect, refPoint, null, null, true);
			container.permanentBitmapData.unlock();
			
			ObjectsPoolUtil.returnObject(spot);
		}
		
		override public function putPermanentBitmapDataAt(bitmapData:BitmapData, x:Number, y:Number):void
		{
			if (GameBot.supressUI)
				return;
			
			container.permanentBitmapData.lock();
			
			refPoint.x = x;
			refPoint.y = y;
			refRect.x = 0;
			refRect.y = 0;
			refRect.width = bitmapData.width;
			refRect.height = bitmapData.height;
			container.permanentBitmapData.copyPixels(bitmapData, refRect, refPoint, null, null, true);
			container.permanentBitmapData.unlock();
		}
	
	}

}