/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.targetFollowing
{
	import nslib.AIPack.pathFollowing.RotationCalculator;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.controls.NSSprite;
	import nslib.utils.NSMath;
	import flash.display.DisplayObject;
	
	public class TargetFollower extends NSSprite
	{
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		protected var standardInterval:int = 50; // milliseconds
		
		protected var rotationSpeed:Number = 3;
				
		protected var rotationAcceleration:Number = 0.02;
		
		protected var motionSpeed:Number = 3;
		
		protected var deltaTimeCounter:DeltaTime = DeltaTime.globalDeltaTimeCounter;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------]
		
		public function TargetFollower()
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties: Getters and Setters
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  isActivated
		//----------------------------------
		
		private var _isActive:Boolean = false;
		
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		//----------------------------------
		//  target
		//----------------------------------
		
		private var _target:DisplayObject = null;
		
		/**
		 * Target to reach when possible
		 **/
		public function get target():DisplayObject
		{
			return _target;
		}
		
		public function set target(value:DisplayObject):void
		{
			_target = value;
		}
		
		//----------------------------------
		//  currentCosA
		//----------------------------------
		
		private var _currentCosA:Number = 0;
		
		protected function get currentCosA():Number
		{
			return _currentCosA;
		}
		
		//----------------------------------
		//  currentSinA
		//----------------------------------
		
		private var _currentSinA:Number = 0;
		
		protected function get currentSinA():Number
		{
			return _currentSinA;
		}
		
		//----------------------------------
		//  accuarcy
		//----------------------------------
		
		private var _accuarcy:Number = 1;
		
		private var recalcEveryNFrame:Number = 5;
		
		public function get accuarcy():Number
		{
			return _accuarcy;
		}
		
		public function set accuarcy(value:Number):void
		{
			_accuarcy = value;
			
			recalcEveryNFrame = Math.max(1, 5 / value);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: calculating trajectory
		//
		//--------------------------------------------------------------------------
		
		public function activate():void
		{
			_isActive = true;
			deltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
		}
		
		/////////////////		
		
		public function deactivate():void
		{
			_isActive = false;
			deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
		}
		
		private function frameListener(event:DeltaTimeEvent):void
		{
			performMovement();
		}
		
		/////////////////////
		
		private var framesCount:int = 0;
		
		private var goalAngle:Number = 0;
		
		private function performMovement():void
		{
			if (target)
				tryReachTarget();
		}
		
		// will vary from rotationSpeed/2 to rotationSpeed values.
		private var currentRotationSpeed:Number = 0;
		
		private var currentMaxRotationSpeed:Number = 0;
		
		private var rotationCalculator:RotationCalculator = new RotationCalculator();
		
		/**
		 * Tries to navigate to a specified target.
		 */
		protected function tryReachTarget():void
		{
			rotationCalculator.standardInterval = standardInterval;
			rotationCalculator.deltaTimeCounter = deltaTimeCounter;
			
			var curAngle:Number = NSMath.degToRad(rotation);
			_currentCosA = Math.cos(curAngle);
			_currentSinA = Math.sin(curAngle);
			x = x + motionSpeed * _currentCosA * calcDeltaTimeMultiplider();
			y = y + motionSpeed * _currentSinA * calcDeltaTimeMultiplider();
			
			// recalc every N frame depending on the accuracy specified
			if (++framesCount > recalcEveryNFrame)
			{
				framesCount = 0;
				
				//currentMaxRotationSpeed = rotationSpeed * 0.5 * (1.5 + Math.random());
				
				var dx:Number = target.x - x;
				var dy:Number = target.y - y;
				goalAngle = NSMath.atan2Rad(dy, dx);
			}
			
			var newAngle:Number = rotationCalculator.performRotation(curAngle, goalAngle, rotationSpeed);
			
			
			if (rotationCalculator.reachedGoalAngleAfterLastRotation)
			{
				newAngle = goalAngle;
			}
				
			rotation = NSMath.radToDeg(newAngle);
			
			//rotation = NSMath.radToDeg(goalAngle);
			
			/*			
			if (currentRotationSpeed < currentMaxRotationSpeed)
				currentRotationSpeed += rotationAcceleration;
			else
				currentRotationSpeed -= rotationAcceleration;
			
			var direction:int = (goalAngle > curAngle) ? 1 : -1
			rotation = rotation + currentRotationSpeed * direction * calcDeltaTimeMultiplider();
			*/
		}
		
		private function calcDeltaTimeMultiplider():Number
		{
			return deltaTimeCounter.dT / standardInterval;
		}
	
	}
}
