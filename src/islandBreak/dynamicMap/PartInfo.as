package islandBreak.dynamicMap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import nslib.core.IReusable;
	import nslib.utils.ObjectsPoolUtil;
	import nslib.utils.UIDUtil;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class PartInfo implements IReusable
	{
		public var reusablePartType:String = null;
		
		public var isReusable:Boolean = false;
		
		public var image:DynamicBitmap = null;
		
		public var indexX:int = 0;
		
		public var indexY:int = 0;
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public var centerX:Number = 0;
		
		public var centerY:Number = 0;
		
		////////////
		
		public function PartInfo()
		{
		}
		
		///////////
		
		public var _poolID:String = null;
		
		public function get poolID():String
		{
			return _poolID;
		}
		
		public function set poolID(value:String):void
		{
			_poolID = value;
		}
		
		//////////
		
		public function prepareForPooling():void
		{
		}
		
		public function prepareForReuse():void
		{
		}
		
		public function prepareData():void
		{
			//if (isReusable && image)
			//	throw new Error("Image was not recycled!");
			
			if (!isReusable && !image)
				throw new Error("Cannot access an image!");
			
			if (isReusable && !image)
			{
				image = takeObjectByKey();
				image.x = this.x;
				image.y = this.y;
			}
		}
		
		private function takeObjectByKey():DynamicBitmap
		{
			if (reusablePartType == ReusablePartType.REUSABLE_PART_SEA)
				return ObjectsPoolUtil.takeObject(SeaPartBitmap);
			
			return null;
		}
		
		public function notifyRemovedFromMap():void
		{
			if (!image)
				throw new Error("Cannot access an image!");
			
			if (isReusable)
			{
				ObjectsPoolUtil.returnObject(image);
				image = null;
			}
		}
		
		public function applyColorTransform(colorTransform:ColorTransform):void
		{
			if (image)
			{
				image.bitmapData.lock();
				image.bitmapData.colorTransform(image.bitmapData.rect, colorTransform);
				image.bitmapData.unlock();
			}
		}
		
		private var originPoint:Point = new Point(0, 0);
		
		public function applyFilter(filter:BitmapFilter):void
		{
			if (image)
			{
				image.bitmapData.lock();
				image.bitmapData.applyFilter(image.bitmapData, image.bitmapData.rect, originPoint, filter);
				image.bitmapData.unlock();
			}
		}
	}

}