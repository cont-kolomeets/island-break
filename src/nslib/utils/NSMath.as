/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class NSMath
	{		
		public static const PI:Number = 3.1415926;
		
		public static function radToDeg(rad:Number):Number
		{
			return (rad * 57.296);
		}
		
		public static function degToRad(deg:Number):Number
		{
			return (deg / 57.296);
		}
		
		public static function sinRad(value:Number):Number
		{
			return Math.sin(value);
		}
		
		public static function sinDeg(value:int):Number
		{
			return radToDeg(Math.sin(value));
		}
		
		public static function cosRad(value:Number):Number
		{
			return Math.cos(value);
		}
		
		public static function cosDeg(value:Number):Number
		{
			return radToDeg(Math.cos(value));
		}
		
		public static function tgRad(value:Number):Number
		{
			return Math.tan(value);
		}
		
		public static function tgDeg(value:Number):Number
		{
			return radToDeg(Math.tan(value));
		}
		
		public static function abs(value:Number):Number
		{
			return Math.abs(value);
		}
		
		public static function max(value1:Number, value2:Number):Number
		{
			return Math.max(value1, value2);
		}
		
		public static function min(value1:Number, value2:Number):Number
		{
			return Math.min(value1, value2);
		}
		
		public static function floor(value:Number):int
		{
			return Math.floor(value)
		}
		
		public static function round(value:Number):int
		{
			return Math.round(value);
		}
		
		public static function ceil(value:Number):int
		{
			return Math.ceil(value);
		}
		
		public static function random():Number
		{
			return Math.random();
		}
		
		public static function atanRad(tgVal:Number):Number
		{
			return Math.atan(tgVal);
		}
		
		public static function atanDeg(tgVal:Number):Number
		{
			return radToDeg(Math.atan(tgVal));
		}
		
		public static function atan2Rad(y:Number, x:Number):Number
		{
			return Math.atan2(y, x);
		}
		
		public static function atan2Deg(y:Number, x:Number):Number
		{
			return radToDeg(atan2Rad(x, y));
		}
		
		public static function sqrt(value:Number):Number
		{
			return Math.sqrt(value);
		}
		
		public static function applyRotMatrix(point:Point, angleRadians:Number):Point
		{
			var result:Point = new Point(0, 0);
			
			result.x = point.x * cosRad(angleRadians) - point.y * sinRad(angleRadians);
			result.y = point.x * sinRad(angleRadians) + point.y * cosRad(angleRadians);
			
			return result;
		}
		
		public static function pow(base:Number, pow:Number):Number
		{
			return Math.pow(base, pow);
		}
		
		public static function log(value:Number):Number
		{
			return Math.log(value);
		}
	
	}

}