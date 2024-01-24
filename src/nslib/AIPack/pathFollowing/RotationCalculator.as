/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.pathFollowing
{
	import nslib.animation.DeltaTime;
	import nslib.utils.NSMath;
	import nslib.utils.TrigonometryUtil;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class RotationCalculator
	{
		public var deltaTimeCounter:DeltaTime;
		
		public var standardInterval:Number = 50; // milliseconds
		
		/////////////////////
		
		public function RotationCalculator()
		{
		}
		
		//////////////////////
		
		private var _reachedGoalAngleAfterLastRotation:Boolean = false;
		
		public function get reachedGoalAngleAfterLastRotation():Boolean
		{
			return _reachedGoalAngleAfterLastRotation;
		}
		
		//////////////////////
		
		// Performs rotation of the current angle.
		// Returns modified current angle.
		// easingCoefficient1 - from what ration easing will start (0.1 - means 18 degrees)
		// easingCoefficient2 - factor of easing. Try to keep the value (easingCoefficient1 x easingCoefficient2) equal to 1 for better performance.
		// to remove easing just set easingCoefficient1 to zero
		// warning: if the rotationSpeed is too high it may never fall into the macthing accuracy range.
		public function performRotation(curAngle:Number, goalAngle:Number, rotationSpeed:Number, matchAccuracy:Number = 0.1, easingCoefficient1:Number = 0.2, easingCoefficient2:Number = 5):Number
		{
			curAngle = TrigonometryUtil.castToMinusPIToPlusPIRange(curAngle);
			
			var ratio:Number = TrigonometryUtil.calcArcDifference(goalAngle, curAngle) / NSMath.PI;
			var easingCoefficient:Number = (ratio < easingCoefficient1) ? (0.01 + ratio * easingCoefficient2) : 1;
			var deltaRotationSpeed:Number = rotationSpeed * calcDeltaTimeMultiplider() * easingCoefficient;
			
			if (haveDifferentSigns(goalAngle, curAngle) && NSMath.abs(goalAngle - curAngle) > NSMath.PI)
			{
				if (goalAngle > curAngle)
					curAngle -= deltaRotationSpeed;
				else
					curAngle += deltaRotationSpeed;
			}
			else
			{
				if (goalAngle > curAngle)
					curAngle += deltaRotationSpeed;
				else
					curAngle -= deltaRotationSpeed;
			}
			
			_reachedGoalAngleAfterLastRotation = TrigonometryUtil.calcArcDifference(goalAngle, curAngle) < matchAccuracy;
			
			return curAngle;
		}
		
		private function haveDifferentSigns(a:Number, b:Number):Boolean
		{
			if ((a > 0 && b < 0) || (a < 0 && b > 0))
				return true;
			
			return false;
		}
		
		private function calcDeltaTimeMultiplider():Number
		{
			return deltaTimeCounter.dT / standardInterval;
		}
	
	}

}