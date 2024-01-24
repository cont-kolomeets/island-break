/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.animation
{
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EasingFunction
	{
		
		/////////// easing
		
		public static function linear(progress:Number, easingEffectFactor:Number):Number
		{
			return 1;
		}
		
		public static function cosSplash(progress:Number, easingEffectFactor:Number):Number
		{
			//return NSMath.cosRad(progress * 4.7)/2.1 + 0.53;
			return NSMath.cosRad(progress * 12.5) / 4 + 0.75 + NSMath.sinRad(progress * 3.15) / 3;
		}
		
		public static function cosWaveLongPositive(progress:Number, easingEffectFactor:Number):Number
		{
			return 1 + NSMath.cosRad(progress * 12.5 * 1000) / 8 * easingEffectFactor;
		}
		
		public static function sinWaveLongPositive(progress:Number, easingEffectFactor:Number):Number
		{
			return 1 + NSMath.sinRad(progress * 12.5 * 1000) / 8 * easingEffectFactor;
		}
		
		public static function cosWaveLongSimmetrical(progress:Number, easingEffectFactor:Number):Number
		{
			return NSMath.cosRad(progress * 12.5 * 1000) / 8 * easingEffectFactor;
		}
		
		public static function decreaseLinear(progress:Number, easingEffectFactor:Number):Number
		{
			return 1 - progress;
		}
		
		public static function increaseLinear(progress:Number, easingEffectFactor:Number):Number
		{
			return progress;
		}
		
		/*
		 * Math.easeInOutSine = function (t, b, c, d) {
		   return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
		   };
		 * */
		//public static function easeInOutSine(progress:Number, easingEffectFactor:Number = 1):Number
		//{
		//	return -1 / 2 * (Math.cos(Math.PI * progress) - 1) + 1 + progress;
		//}
		
		///////////// offset
		
		public static function noOffset(progress:Number, offsetEffectFactor:Number):Number
		{
			return 0;
		}
	
	}

}