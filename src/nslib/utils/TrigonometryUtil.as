/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TrigonometryUtil
	{
		// must be both in radians
		public static function calcArcDifference(angle1:Number, angle2:Number):Number
		{
			var difference:Number = NSMath.abs(angle1 - angle2);
			if (difference > NSMath.PI)
				difference = 2 * NSMath.PI - difference;
			
			return difference;
		}
		
		// must be in radians
		public static function castToMinusPIToPlusPIRange(angle:Number):Number
		{
			if (angle > NSMath.PI)
				angle = -NSMath.PI * 2 + angle;
			
			if (angle < -NSMath.PI)
				angle = NSMath.PI * 2 + angle;
			
			return angle;
		}
	
	}

}