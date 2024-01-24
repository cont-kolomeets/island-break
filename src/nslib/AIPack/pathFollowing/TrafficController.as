/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.pathFollowing
{
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TrafficController
	{
		public var allowOverlap:Boolean = false;
		
		private var followers:Object = {};
		
		private var topFollowers:Object = {};
		
		private var bottomFollowers:Object = {};
		
		private var allowOverlapHash:Object = {};
		
		private var deltaTimeCounter:DeltaTime = DeltaTime.globalDeltaTimeCounter;
		
		//////////////////////////////////////////
		
		public function TrafficController()
		{
		}
		
		//////////////////////////////////////////
		
		public function registerTrajectoryFollower(tf:TrajectoryFollower, allowOverlap:Boolean = false):void
		{
			followers[tf.uniqueKey] = tf;
			
			if (allowOverlap)
				allowOverlapHash[tf.uniqueKey] = tf;
		}
		
		public function unregisterTrajectoryFollower(tf:TrajectoryFollower):void
		{
			delete followers[tf.uniqueKey];
			delete blockHash[tf.uniqueKey];
			delete topFollowers[tf.uniqueKey];
			delete bottomFollowers[tf.uniqueKey];
			delete allowOverlapHash[tf.uniqueKey];
		}
		
		public function placeTrajectoryFollowerOnTopOverlay(tf:TrajectoryFollower):void
		{
			delete bottomFollowers[tf.uniqueKey];
			topFollowers[tf.uniqueKey] = tf;
		}
		
		public function placeTrajectoryFollowerOnBottomOverlay(tf:TrajectoryFollower):void
		{
			delete topFollowers[tf.uniqueKey];
			bottomFollowers[tf.uniqueKey] = tf;
		}
		
		public function removeOverlayRestrictions(tf:TrajectoryFollower):void
		{
			delete topFollowers[tf.uniqueKey];
			delete bottomFollowers[tf.uniqueKey];
		}
		
		public function reset():void
		{
			followers = {};
			allowOverlapHash = {};
			topFollowers = {};
			bottomFollowers = {};
			blockHash = {};
		}
		
		public function startTrafficControl():void
		{
			deltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
		}
		
		public function stopTrafficControl():void
		{
			deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
		}
		
		private function frameListener(event:DeltaTimeEvent):void
		{
			performIterationFollowingTrajectory();
		}
		
		private function performIterationFollowingTrajectory():void
		{
			if (!allowOverlap)
				for each (var tf:TrajectoryFollower in followers)
					if (allowOverlapHash[tf.uniqueKey] == undefined && tf.isMobile && tf.isActive)
						tf.motionForbidden = !wayIsClearForObject(tf);
			
			if (!allowOverlap)
				preventStuck();
			
			performIterationForAll();
		}
		
		private function preventStuck():void
		{
			if (checkIfSomeAreStuck())
				for each (var tf:TrajectoryFollower in followers)
					tf.motionForbidden = false;
			
			blockHash = {};
		}
		
		private function checkIfSomeAreStuck():Boolean
		{
			for each (var tf:TrajectoryFollower in followers)
				if (blockHash[tf.uniqueKey])
					for each (var blockingTF:TrajectoryFollower in followers)
						if (blockingTF.uniqueKey == blockHash[tf.uniqueKey] && blockHash[blockingTF.uniqueKey] == tf.uniqueKey)
							return true;
			
			return false;
		}
		
		private function performIterationForAll():void
		{
			for each (var tf:TrajectoryFollower in followers)
				if (tf.isMobile && tf.isActive)
					tf.performIterationFollowingTrajectory();
		}
		
		private var blockHash:Object = {};
		
		private function wayIsClearForObject(tf:TrajectoryFollower):Boolean
		{
			for each (var anotherTF:TrajectoryFollower in followers)
				if (anotherTF != tf && allowOverlapHash[anotherTF.uniqueKey] == undefined && !followersAreInDifferentLayers(tf, anotherTF))
					if (trajectoryFollwerFacesAnother(tf, anotherTF, tf.rect.width, 0) || trajectoryFollwerFacesAnother(tf, anotherTF, tf.rect.width, -tf.rect.width / 2) || trajectoryFollwerFacesAnother(tf, anotherTF, tf.rect.width, tf.rect.width / 2) || trajectoryFollwerFacesAnother(tf, anotherTF, 0, 0))
					{
						blockHash[tf.uniqueKey] = anotherTF.uniqueKey;
						return false;
					}
			
			delete blockHash[tf.uniqueKey];
			return true;
		}
		
		private function trajectoryFollwerFacesAnother(tf:TrajectoryFollower, anotherTF:TrajectoryFollower, offsetX:Number, offsetY:Number):Boolean
		{
			var x:Number = -offsetY * tf.bodyAngleSin + offsetX * tf.bodyAngleCos + tf.x - anotherTF.x;
			var y:Number = offsetX * tf.bodyAngleSin + offsetY * tf.bodyAngleCos + tf.y - anotherTF.y;
			
			return anotherTF.rect.contains(x, y);
		}
		
		private function followersAreInDifferentLayers(tf1:TrajectoryFollower, tf2:TrajectoryFollower):Boolean
		{
			if ((topFollowers[tf1.uniqueKey] != undefined && bottomFollowers[tf2.uniqueKey] != undefined) || (topFollowers[tf2.uniqueKey] != undefined && bottomFollowers[tf1.uniqueKey] != undefined))
				return true;
			
			return false;
		}
	
	}

}