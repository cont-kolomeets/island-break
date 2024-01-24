/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ImageUtil
	{
		public static function scaleToFitHeight(image:*, height:Number, expand:Boolean = false):void
		{
			var ratio:Number = image.height / height;
			
			if (expand || ratio > 1)
			{
				image.scaleX = 1 / ratio;
				image.scaleY = 1 / ratio;
			}
		}
		
		public static function scaleToFitWidth(image:*, width:Number, expand:Boolean = false):void
		{
			var ratio:Number = image.width / width;
			
			if (expand || ratio > 1)
			{
				image.scaleX = 1 / ratio;
				image.scaleY = 1 / ratio;
			}
		}
		
		public static function scaleBitmapData(bitmapData:BitmapData, scaleX:Number, scaleY:Number):BitmapData
		{
			var width:int = (bitmapData.width * scaleX) || 1;
			var height:int = (bitmapData.height * scaleY) || 1;
			var result:BitmapData = new BitmapData(width, height, bitmapData.transparent, 0x000000);
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleX, scaleY);
			result.draw(bitmapData, matrix, null, null, null, true);
			return result;
		}
	}

}