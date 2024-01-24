/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.pathFollowing
{
	import nslib.AIPack.events.TrajectoryFollowerEvent;
	import nslib.AIPack.grid.Location;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GoalMotionEngine
	{
		public var motionForbidden:Boolean = false;
		public var enableSimultaniousMotionAndRotation:Boolean = true;
		public var enableEarlyRotation:Boolean = true;
		
		private var subject:TrajectoryFollower;
		
		// distance from one goal to the next one
		private var localDist:Number = 0;
		private var goalDist:Number = 0;
		private var goalAngle:Number;
		private var goalIsSet:Boolean = false;
		private var motionMode:int = MotionMode.TURNING;
		
		/// flags
		
		private var trajectoryChanged:Boolean = true;
		private var earlyRoationGoalIsSet:Boolean = false;
		
		private var rotationCalculator:RotationCalculator = new RotationCalculator();
		
		////////////////////////
		
		public function GoalMotionEngine(subject:TrajectoryFollower)
		{
			this.subject = subject;
		}
		
		////////////////////////
		
		public function notifyTrajectoryChanged():void
		{
			trajectoryChanged = true;
		}
		
		public function performIteration():void
		{
			if (!goalIsSet)
				setGoalParameters();
			
			performRotation();
			
			if (!motionForbidden)
				performMotion();
		}
		
		// notifies to skin the current goal and move to the next one
		public function skipToNextPoint():void
		{
			notifyGoalReached();
		}
		
		private function setGoalParameters():void
		{
			if (!subject || !subject.trajectory || subject.trajectory.length == 0)
				return;
			
			// trying to skip every second point to make the motion smoother
			//if (subject.trajectory.length > 1)
			//	subject.trajectory.removeItemAt(0);
			
			var goalLoaction:Location = Location(subject.trajectory.getItemAt(0));
			
			var dx:Number = goalLoaction.x - subject.x;
			var dy:Number = goalLoaction.y - subject.y;
			
			// setting a goal angle
			if (trajectoryChanged || !enableEarlyRotation)
				goalAngle = NSMath.atan2Rad(dy, dx);
			
			trajectoryChanged = false;
			
			// setting a goal distance
			goalDist = NSMath.sqrt(dx * dx + dy * dy);
			localDist = goalDist;
			
			motionMode = MotionMode.TURNING;
			
			goalIsSet = true;
		}
		
		// sets goal angle for location following the current goal
		private function setGoalAngleForNextLocation():void
		{
			if (!subject || !subject.trajectory || subject.trajectory.length < 2)
				return;
			
			var nextGoalLoaction:Location = Location(subject.trajectory.getItemAt(1));
			
			// this is a special desicion not to turn before reaching goal locations with links (they may be used for implementing teleports)
			if (Location(subject.trajectory.getItemAt(0)).linkedLocation)
				return;
			
			var dx:Number = nextGoalLoaction.x - subject.x;
			var dy:Number = nextGoalLoaction.y - subject.y;
			goalAngle = NSMath.atan2Rad(dy, dx);
			
			earlyRoationGoalIsSet = true;
		}
		
		/**
		 * Trajectory-defined motion and rotation.
		 */
		
		private function performMotion():void
		{
			if (enableSimultaniousMotionAndRotation || motionMode == MotionMode.MOVING)
			{
				var dx:Number = subject.motionSpeed * calcDeltaTimeMultiplider() * subject.bodyAngleCos;
				var dy:Number = subject.motionSpeed * calcDeltaTimeMultiplider() * subject.bodyAngleSin;
				subject.x += dx;
				subject.y += dy;
				var dist:Number = NSMath.sqrt(dx * dx + dy * dy);
				
				goalDist -= dist;
				
				if (enableEarlyRotation && !earlyRoationGoalIsSet && (goalDist / localDist < 0.5))
					setGoalAngleForNextLocation();
				
				if (goalDist < 0)
				{
					goalDist = 0;
					notifyGoalReached();
				}
			}
		}
		
		private function performRotation():void
		{
			if (enableSimultaniousMotionAndRotation || motionMode == MotionMode.TURNING)
			{
				rotationCalculator.deltaTimeCounter = subject.deltaTimeCounter;
				rotationCalculator.standardInterval = subject.standardInterval;
				
				subject.bodyAngle = rotationCalculator.performRotation(subject.bodyAngle, goalAngle, subject.rotationSpeed, 0.02, 0.5, 3);
				
				if (rotationCalculator.reachedGoalAngleAfterLastRotation)
				{
					subject.bodyAngle = goalAngle;
					motionMode = MotionMode.MOVING;
				}
			}
		}
		
		private function notifyGoalReached():void
		{
			subject.trajectory.removeItemAt(0);
			
			if (subject.trajectory.length == 0)
				subject.dispatchEvent(new TrajectoryFollowerEvent(TrajectoryFollowerEvent.REACHED_END_OF_PATH));
			
			goalIsSet = false;
			earlyRoationGoalIsSet = false;
		}
		
		private function calcDeltaTimeMultiplider():Number
		{
			return subject.deltaTimeCounter.dT / subject.standardInterval;
		}
	}

}