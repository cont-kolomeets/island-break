/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.animation.events 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class AnimationEvent extends Event 
	{
		public static const ANIMATION_COMPLETED:String = "animationCompleted";
		
		public static const ANIMATION_ROUTINE_COMPLETED_FOR_THIS_OBJECT:String = "animationRoutineCompletedForThisObject";

		public static const DRAWING_COMPLETE:String = "drawingComplete";
		
		public function AnimationEvent(type:String) 
		{
			super(type);
		}
		
	}

}