/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.anchorFollowing
{
	import flash.geom.Point;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.controls.NSSprite;
	import nslib.utils.NSMath;
	
	public class AnchorFollower extends NSSprite
	{
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		public var motionSpeed:Number = 3;
		
		public var rotationSpeed:Number = 3;
		
		// this part will rotate
		// it is very usefull not to rotate the whole object, but
		// only a specific part, since you can add some static objects
		// like shadows or energy bars, which should not rotate
		protected var body:NSSprite = new NSSprite();
		
		protected var standardInterval:int = 50; // milliseconds
		
		protected var deltaTimeCounter:DeltaTime = DeltaTime.globalDeltaTimeCounter;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------]
		
		public function AnchorFollower()
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
		//  anchor
		//----------------------------------
		
		private var _anchor:Point = new Point(0, 0);
		
		/**
		 * Point to fly around.
		 */
		public function get anchor():Point
		{
			return _anchor;
		}
		
		public function set anchor(value:Point):void
		{
			_anchor = value;
		}
		
		//----------------------------------
		//  target
		//----------------------------------
		
		private var _target:Point = null;
		
		/**
		 * Target to reach when possible
		 **/
		public function get target():Point
		{
			return _target;
		}
		
		public function set target(value:Point):void
		{
			_target = value;
		}
		
		//----------------------------------
		//  travelRadius
		//----------------------------------
		
		private var _travelRadius:Number = 0;
		
		public function get travelRadius():Number
		{
			return _travelRadius;
		}
		
		public function set travelRadius(value:Number):void
		{
			_travelRadius = value;
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
		
		/////////////////////////////////////
		
		public function get bodyAngle():Number
		{
			return NSMath.degToRad(body.rotation);
		}
		
		public function set bodyAngle(value:Number):void
		{
			body.rotation = NSMath.radToDeg(value);
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
		
		private var goalAngleIsSet:Boolean = false;
		
		private var goalAngle:Number = 0;
		
		protected function performMovement():void
		{
			if (tryReachTarget())
				return;
			
			tryReachPoint(anchor);
		}
		
		private function tryReachTarget():Boolean
		{
			if (!canReachTarget())
				return false;
			
			tryReachPoint(target);
			
			return true;
		}
		
		// will vary from rotationSpeed/2 to rotationSpeed values.
		private var currentRotationSpeed:Number = 0;
		
		private var currentMaxRotationSpeed:Number = 0;
		
		private var rotationAcceleration:Number = 0.02;
		
		public function resetNavigation():void
		{
			goalAngleIsSet = false;
		}
		
		protected function updateCurrentSinCos():void
		{
			var curAngle:Number = NSMath.degToRad(body.rotation);
			_currentCosA = Math.cos(curAngle);
			_currentSinA = Math.sin(curAngle);
		}
		
		/**
		 * Tries to navigate to a specified point.
		 * @param point Point to navigate to.
		 */
		protected function tryReachPoint(point:Point):void
		{
			var curAngle:Number = NSMath.degToRad(body.rotation);
			updateCurrentSinCos();
			x = x + motionSpeed * _currentCosA * calcDeltaTimeMultiplier();
			y = y + motionSpeed * _currentSinA * calcDeltaTimeMultiplier();
			
			if (!goalAngleIsSet)
			{
				currentMaxRotationSpeed = rotationSpeed * 0.5 * (1.5 + Math.random());
				
				var dx:Number = point.x - x;
				var dy:Number = point.y - y;
				goalAngle = NSMath.atan2Rad(dy, dx);
				goalAngleIsSet = true;
			}
			
			if (Math.abs(goalAngle - curAngle) < 0.05)
			{
				goalAngleIsSet = false;
				return;
			}
			
			if (currentRotationSpeed < currentMaxRotationSpeed)
				currentRotationSpeed += rotationAcceleration;
			else
				currentRotationSpeed -= rotationAcceleration;
			
			var direction:int = (goalAngle > curAngle) ? 1 : -1
			body.rotation = body.rotation + currentRotationSpeed * direction * calcDeltaTimeMultiplier();
		}
		
		private function canReachTarget():Boolean
		{
			if (!target)
				return false;
			
			if (Math.abs(anchor.x - target.x) > travelRadius || Math.abs(anchor.y - target.y) > travelRadius)
				return false;
			
			return true;
		}
		
		private function calcDeltaTimeMultiplier():Number
		{
			return deltaTimeCounter.dT / standardInterval;
		}
	
	}
}
