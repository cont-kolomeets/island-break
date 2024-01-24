package islandBreak.dynamicMap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import nslib.core.IReusable;
	import nslib.utils.UIDUtil;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class DynamicBitmap extends Bitmap implements IReusable
	{
		public function DynamicBitmap(bitmapData:BitmapData)
		{
			super(bitmapData);
		}
		
		public var _poolID:String = null;
		
		public function get poolID():String
		{
			return _poolID;
		}
		
		public function set poolID(value:String):void
		{
			_poolID = value;
		}
		
		public function prepareForPooling():void
		{
		}
		
		public function prepareForReuse():void
		{
		}
	}

}