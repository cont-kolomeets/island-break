/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.timers
{
	import flash.events.EventDispatcher;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.timers.events.AdvancedTimerEvent;
	import nslib.utils.NSMath;
	
	[Event(name="repetitionCompleted",type="nslib.timers.events.AdvancedTimerEvent")]
	
	[Event(name="timerCompleted",type="nslib.timers.events.AdvancedTimerEvent")]
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AdvancedTimer extends EventDispatcher
	{
		private const MIN_DELAY:Number = 10;
		
		public var totalRepetitions:int = 0; // zero means infinity
		
		public var running:Boolean = false;
		
		private var deltaTimeCounter:DeltaTime = DeltaTime.globalDeltaTimeCounter;
		
		private var timeLeft:Number = 0;
		
		private var timerIsSuspended:Boolean = false;
		
		////////////////////////////////////////////
		
		public function AdvancedTimer(delay:Number = 10, repetitions:int = 0)
		{
			this.delay = delay;
			this.totalRepetitions = repetitions;
		}
		
		////////////////////////////////////////////
		
		private var _delay:Number = MIN_DELAY;
		
		public function get delay():Number
		{
			return _delay;
		}
		
		public function set delay(value:Number):void
		{
			_delay = NSMath.max(value, MIN_DELAY);
		}
		
		///////
		
		private var _progress:Number = 0;
		
		// progress per repetition
		public function get progress():Number
		{
			return _progress;
		}
		
		//////////////
		
		private var _repetitionsCount:int = 0;
		
		// number of repetitions completed
		public function get repetitionsCount():int
		{
			return _repetitionsCount;
		}
		
		////////////////////////////////////////////
		
		public function start():void
		{
			if (!timerIsSuspended)
				timeLeft = _delay;
			
			timerIsSuspended = false;
			running = true;
			
			deltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeCounter_deltaTimeAquiredHandler);
		}
		
		private function deltaTimeCounter_deltaTimeAquiredHandler(event:DeltaTimeEvent):void
		{
			timeLeft -= event.lastDeltaTime;
			
			_progress = 1 - timeLeft / delay;
			
			if (timeLeft <= 0)
			{
				// amount of time passed after the moment had come
				var overtime:Number = Math.abs(timeLeft);
				
				timeLeft = 0;
				if (totalRepetitions == 0 || ++_repetitionsCount < totalRepetitions)
					startNextRepetition(overtime);
				else
					completeTimer();
			}
		}
		
		private function startNextRepetition(overtime:Number):void
		{
			_progress = 1;
			dispatchEvent(new AdvancedTimerEvent(AdvancedTimerEvent.REPETITION_COMPLETED));
			timeLeft = _delay - overtime;
		}
		
		private function completeTimer():void
		{
			reset();
			_progress = 1; // restoring progress after reset so that a listener can get the final progress value.
			dispatchEvent(new AdvancedTimerEvent(AdvancedTimerEvent.TIMER_COMPLETED));
			_progress = 0; // setting the real value
		}
		
		/**
		 * Stops the current repetition. When calling the start() method,
		 * the repetition starts from the beginning and the timer runs for the
		 * remaining number of repetitions.
		 */
		public function stop():void
		{
			timerIsSuspended = false;
			running = false;
			_progress = 0;
			deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeCounter_deltaTimeAquiredHandler);
		}
		
		/**
		 * Stops the current repetition, but remembers the amount of time left to finish the current repetition.
		 * When calling the start() method, the timer runs first for the memorized amount of time of the interrupted repetition, and
		 * then runs for the remaining number of repetitions.
		 */
		public function suspend():void
		{
			timerIsSuspended = true;
			running = false;
			deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeCounter_deltaTimeAquiredHandler);
		}
		
		public function reset():void
		{
			_repetitionsCount = 0;
			timerIsSuspended = false;
			running = false;
			_progress = 0;
			deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeCounter_deltaTimeAquiredHandler);
		}
	
	}

}