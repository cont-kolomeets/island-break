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
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class ColorUtil
	{
		
		public function ColorUtils()
		{
		}
		
		public static function getRed(color:int):int
		{
			return (color >> 16) & 0xFF;
		}
		
		public static function getGreen(color:int):int
		{
			return (color >> 8) & 0xFF;
		}
		
		public static function getBlue(color:int):int
		{
			return color & 0xFF;
		}
		
		public static function avgChanel(color:int):int
		{
			var red:int = (color >> 16) & 0xFF;
			var green:int = (color >> 8) & 0xFF;
			var blue:int = color & 0xFF;
			
			return (red + green + blue) / 3;
		}
		
		public static function setValueForAllChanels(val:int):int
		{
			if (val > 255)
				val = 255;
			if (val < 0)
				val = 0;
			if (isNaN(val))
				val = 0;
			
			var color:int = 0x000000;
			color |= (val << 16);
			color |= (val << 8);
			color |= val;
			
			return color;
		}
		
		public static function isPartOfGradient(color:int, colorToCompareWith:int):Boolean
		{
			//if (getBlue(color) == getBlue(colorToCompareWith) && getGreen(color) == getGreen(colorToCompareWith) && getRed(color) == getRed(colorToCompareWith))
			//	return true;
			
			var ratio:Number = 1;
			
			if (getBlue(color) >= getGreen(color) && getBlue(color) >= getRed(color))
			{
				if (getBlue(color) == 0 || getBlue(color) > getBlue(colorToCompareWith))
					return false;
				ratio = getBlue(color) / getBlue(colorToCompareWith);
			}
			
			if (getGreen(color) >= getBlue(color) && getGreen(color) >= getRed(color))
			{
				if (getGreen(color) == 0 || getGreen(color) > getGreen(colorToCompareWith))
					return false;
				ratio = getGreen(color) / getGreen(colorToCompareWith);
			}
			
			if (getRed(color) >= getBlue(color) && getRed(color) >= getGreen(color))
			{
				if (getRed(color) == 0 || getRed(color) > getRed(colorToCompareWith))
					return false;
				ratio = getRed(color) / getRed(colorToCompareWith);
			}
			
			trace(ratio);
			
			if (int(getBlue(colorToCompareWith) * ratio) == getBlue(color) && int(getGreen(colorToCompareWith) * ratio) == getGreen(color) && int(getRed(colorToCompareWith) * ratio) == getRed(color))
				return true;
			
			return false;
		}
		
		public static function pickColor(x:Number, y:Number, stage:Stage):int
		{
			var bitmapData:BitmapData;
			
			if (stage)
			{
				bitmapData = new BitmapData(1, 1, false, 0);
				var matrix:Matrix = new flash.geom.Matrix();
				matrix.translate(-x, -y);
				bitmapData.draw(stage, matrix, null, null, new Rectangle(0, 0, 1, 1), false);
				trace(bitmapData.getPixel(0, 0));
			}
			
			return bitmapData.getPixel(0, 0);
		}
	
	}

}