/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.pathFollowing
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import nslib.AIPack.grid.Location;
	import nslib.animation.DeltaTime;
	import nslib.controls.NSSprite;
	import nslib.interactableObjects.MovableObject;
	import nslib.utils.ArrayList;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TrajectoryFollower extends MovableObject
	{
		public var deltaTimeCounter:DeltaTime = DeltaTime.globalDeltaTimeCounter;
		
		public var rotationSpeed:Number = 0.1;
		
		public var standardInterval:int = 50; // milliseconds
		
		public var motionSpeed:Number = 3;
		
		public var startWithClosestLocation:Boolean = true;
		
		public var isMobile:Boolean = false;
		
		public var pathIndex:int = -1;
		
		// this part will rotate
		// it is very usefull not to rotate the whole object, but
		// only a specific part, since you can add some static objects
		// like shadows or energy bars, which should not rotate
		protected var body:NSSprite = new NSSprite();
		
		private var goalMotionEngine:GoalMotionEngine;
		
		////////////////////////////////////
		
		public function TrajectoryFollower()
		{
			super();
			
			goalMotionEngine = new GoalMotionEngine(this);
		}
		
		/////////////////////////////////////
		
		private var internalX:Number = 0;
		
		// need more precise control over coordinates
		override public function get x():Number 
		{
			return internalX;
		}
		
		override public function set x(value:Number):void 
		{
			internalX = value;
			super.x = value;
		}
		
		private var internalY:Number = 0;
		
		override public function get y():Number 
		{
			return internalY;
		}
		
		override public function set y(value:Number):void 
		{
			internalY = value;
			super.y = value;
		}
		
		/////////
		
		// in radians
		public function get bodyAngle():Number
		{
			return NSMath.degToRad(body.rotation);
		}
		
		public function set bodyAngle(value:Number):void
		{
			body.rotation = NSMath.radToDeg(value);
			recalcCosSin();
		}
		
		private function recalcCosSin():void
		{
			_bodyAngleCos = NSMath.cosRad(bodyAngle);
			_bodyAngleSin = NSMath.sinRad(bodyAngle);
		}
		
		////////////
		
		private var _bodyAngleCos:Number = 1;
		
		public function get bodyAngleCos():Number
		{
			return _bodyAngleCos;
		}
		
		////////////
		
		private var _bodyAngleSin:Number = 0;
		
		public function get bodyAngleSin():Number
		{
			return _bodyAngleSin;
		}
		
		////////////
		
		public function get partRotatingAlongTrajectory():NSSprite
		{
			return body;
		}
		
		////////////
		
		private var _trajectory:ArrayList;
		
		private var initialPathLength:int = 0;
		
		public function get trajectory():ArrayList
		{
			return _trajectory;
		}
		
		public function set trajectory(value:ArrayList):void
		{
			_trajectory = new ArrayList();
			
			for (var i:int = 0; i < value.length; i++)
				_trajectory.addItem(value.getItemAt(i));
			
			if (startWithClosestLocation)
				cutTrajectory();
			
			initialPathLength = _trajectory.length;
		}
		
		////////////
		
		private var _isActive:Boolean = false;
		
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		////////////
		
		public function get motionForbidden():Boolean
		{
			return goalMotionEngine.motionForbidden;
		}
		
		/////////////
		
		public function set motionForbidden(value:Boolean):void
		{
			goalMotionEngine.motionForbidden = value;
		}
		
		//////////////
		
		private var _rect:Rectangle = new Rectangle(0, 0, 0, 0); //must be reimplemented in subclasses
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function set rect(value:Rectangle):void
		{
			_rect = value;
		}
		
		override public function getBounds(targetCoordinateSpace:DisplayObject):flash.geom.Rectangle
		{
			if (targetCoordinateSpace == this)
				return rect;
			
			return super.getBounds(targetCoordinateSpace);
		}
		
		/////////////////////////////////////
		
		public function performIterationFollowingTrajectory():void
		{
			if (isActive)
				goalMotionEngine.performIteration();
		}
		
		public function activate():void
		{
			if (startWithClosestLocation)
				cutTrajectory();
			
			_isActive = true;
		}
		
		public function deactivate():void
		{
			_isActive = false;
		}
		
		private function cutTrajectory():void
		{
			if (!_trajectory)
				return;
			
			var minDist:Number = Number.MAX_VALUE;
			var closestLocation:Location = null;
			
			for each (var location:Location in _trajectory.source)
			{
				var dist:Number = calcDistToLocation(x, y, location);
				if (dist < minDist)
				{
					minDist = dist;
					closestLocation = location;
				}
			}
			
			if (_trajectory.getItemIndex(closestLocation) != -1)
			{
				var newPath:Array = [];
				var index:int = _trajectory.getItemIndex(closestLocation);
				
				for (var i:int = index; i < _trajectory.length; i++)
					newPath.push(_trajectory.getItemAt(i));
				
				_trajectory.source = newPath;
			}
		}
		
		public function calcDistToLocation(x:Number, y:Number, location:Location):Number
		{
			return NSMath.sqrt((location.x - x) * (location.x - x) + (location.y - y) * (location.y - y));
		}
		
		public function skipToNextPoint():void
		{
			goalMotionEngine.skipToNextPoint();
		}
		
		// 0 - 1
		public function getPassedPercentage():Number
		{
			return trajectory ? (1 - trajectory.length / initialPathLength) : 0;
		}
	}

}