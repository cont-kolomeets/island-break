/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.events.Event;
	import nslib.controls.events.ProgressBarEvent;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ProgressBarBase extends NSSprite
	{
		public var progressPrecision:Number = 0.01;
		
		protected var timer:AdvancedTimer = new AdvancedTimer(100, 1);
		
		private var isStarted:Boolean = false;
		
		/////////////////////////////
		
		public function ProgressBarBase()
		{
			drawBase();
		}
		
		///////////
		
		public function get progress():Number
		{
			if (isStarted)
				return timer.progress;
			
			return 0;
		}
		
		///////////
		
		public function get running():Boolean
		{
			return timer.running;
		}
		
		/////////////////////////////
		
		public function start(delay:Number):void
		{
			if (!timer || timer.running)
				return;
			
			timer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, timer_timerCompletedHandler);
			addEventListener(Event.ENTER_FRAME, frameListener);
			timer.delay = delay;
			timer.reset();
			timer.start();
			
			dispatchEvent(new ProgressBarEvent(ProgressBarEvent.PROGRESS_STARTED));
			isStarted = true;
			
			// the progress should be drawn immediately without waiting for the next frame
			drawProgress();
		}
		
		public function suspend():void
		{
			timer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, timer_timerCompletedHandler);
			removeEventListener(Event.ENTER_FRAME, frameListener);
			timer.suspend();
		}
		
		public function resume():void
		{
			timer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, timer_timerCompletedHandler);
			addEventListener(Event.ENTER_FRAME, frameListener);
			timer.start();
		}
		
		public function reset():void
		{
			internalResetWithoutDrawing();
			performDrawingOnReset();
		}
		
		private function internalResetWithoutDrawing():void
		{
			timer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, timer_timerCompletedHandler);
			removeEventListener(Event.ENTER_FRAME, frameListener);
			timer.reset();
			isStarted = false;
			lastProgress = Number.MAX_VALUE;
		}
		
		private function timer_timerCompletedHandler(event:AdvancedTimerEvent):void
		{
			performFinalDrawing();
			
			internalResetWithoutDrawing();
			dispatchEvent(new ProgressBarEvent(ProgressBarEvent.PROGRESS_COMPLETE));
		}
		
		protected function performDrawingOnReset():void
		{
			// must be implemented in subclasses
		}
		
		protected function performFinalDrawing():void
		{
			drawProgress();
		}
		
		private var lastProgress:Number = Number.MAX_VALUE;
		
		private function frameListener(event:Event):void
		{
			var currentProgress:Number = progress;
			
			if ((currentProgress < lastProgress) || ((currentProgress - lastProgress) > progressPrecision))
			{
				drawProgress();
				lastProgress = currentProgress;
			}
		}
		
		protected function drawBase():void
		{
			//must be implemented in subclasses.
		}
		
		protected function drawProgress():void
		{
			//must be implemented in subclasses.
		}
	
	}

}