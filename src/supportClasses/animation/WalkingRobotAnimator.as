/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.animation
{
	import flash.display.DisplayObject;
	import nslib.animation.engines.AnimationEngine;
	import nslib.animation.engines.LoopAnimator;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WalkingRobotAnimator
	{
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		public static const DIRECTION_VERTICAL:String = "vertical";
		
		////////////////
		
		private var loopAnimator:LoopAnimator = new LoopAnimator();
		
		////////////////
		
		public function WalkingRobotAnimator()
		{
		}
		
		///////////////
		
		public function registerLegForMotion(leg:DisplayObject, amplitude:Number, phase:Number, interval:Number, direction:String = DIRECTION_VERTICAL):void
		{
			var maxScale:Number = 1.07;
			var minScale:Number = 0.93;
			
			var legMotionFunction:Function = function(direction:String, legXInitial:Number, legYInitial:Number):void
			{
				if (direction == DIRECTION_VERTICAL)
				{
					leg.y = legYInitial - amplitude / 2
					AnimationEngine.globalAnimator.moveObjects(leg, leg.x, leg.y, leg.x, leg.y + amplitude, interval / 2, AnimationEngine.globalAnimator.currentTime);
					AnimationEngine.globalAnimator.moveObjects(leg, leg.x, leg.y + amplitude, leg.x, leg.y, interval / 2, AnimationEngine.globalAnimator.currentTime + interval / 2);
				}
				else if (direction == DIRECTION_HORIZONTAL)
				{
					leg.x = legXInitial - amplitude / 2;
					AnimationEngine.globalAnimator.moveObjects(leg, leg.x, leg.y, leg.x + amplitude, leg.y, interval / 2, AnimationEngine.globalAnimator.currentTime);
					AnimationEngine.globalAnimator.moveObjects(leg, leg.x + amplitude, leg.y, leg.x, leg.y, interval / 2, AnimationEngine.globalAnimator.currentTime + interval / 2);
				}
				
				leg.scaleX = minScale;
				leg.scaleY = minScale;
				AnimationEngine.globalAnimator.scaleObjects(leg, minScale, minScale, maxScale, maxScale, interval / 4, AnimationEngine.globalAnimator.currentTime);
				AnimationEngine.globalAnimator.scaleObjects(leg, maxScale, maxScale, minScale, minScale, interval / 4, AnimationEngine.globalAnimator.currentTime + interval / 4);
				//AnimationEngine.globalAnimator.scaleObjects(leg, minScale, minScale, maxScale, maxScale, interval / 4, AnimationEngine.globalAnimator.currentTime + 2 * interval / 4);
				//AnimationEngine.globalAnimator.scaleObjects(leg, maxScale, maxScale, minScale, minScale, interval / 4, AnimationEngine.globalAnimator.currentTime + 3 * interval / 4);
			};
			
			loopAnimator.registerFunctionToExecute(legMotionFunction, [direction, leg.x, leg.y], interval, interval * phase);
		}
		
		public function startAllAnimation(executeImmediately:Boolean = false):void
		{
			loopAnimator.start(executeImmediately);
		}
		
		public function stopAllAnimation():void
		{
			loopAnimator.stop();
		}
		
		public function clearAllAnimation():void
		{
			loopAnimator.clear();
		}
	}

}