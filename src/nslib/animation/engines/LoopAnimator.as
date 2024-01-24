/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.animation.engines
{
	import flash.utils.Dictionary;
	import nslib.animation.engines.AnimationEngine;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class LoopAnimator
	{
		private var dictionary:Dictionary = new Dictionary();
		
		private var running:Boolean = true;
		
		/////////////////////////////////////
		
		public function LoopAnimator()
		{
		}
		
		/////////////////////////////////////
		
		public function registerFunctionToExecute(func:Function, parameters:Array, interval:Number, delay:Number = NaN):void
		{
			// prevent registering the same function twice
			if (dictionary[func] != undefined)
				return;
			
			var info:FuncInfo = new FuncInfo();
			info.func = func;
			info.parameters = parameters;
			info.interval = interval;
			info.timer = new AdvancedTimer(interval);
			
			dictionary[func] = info;
			
			if (running && isNaN(delay))
				startTimerForInfo(info)
			else if (running)
				AnimationEngine.globalAnimator.executeFunction(startTimerForInfo, [info], AnimationEngine.globalAnimator.currentTime + delay);
		}
		
		public function unregisterFunction(func:Function):void
		{
			if (dictionary[func] != undefined)
			{
				var info:FuncInfo = dictionary[func];
				stopTimerForInfo(info);
			}
			
			delete dictionary[func];
		}
		
		private function stopTimerForInfo(info:FuncInfo):void
		{
			info.timer.stop();
			info.timer.removeEventListener(AdvancedTimerEvent.REPETITION_COMPLETED, timer_repetitionCompletedHandler);
		}
		
		private function startTimerForInfo(info:FuncInfo):void
		{
			// if no reference in dictionary, it means that the function has been unregistered
			if (dictionary[info.func] == undefined || !running)
				return;
			
			info.func.apply(null, info.parameters);
			
			info.timer.addEventListener(AdvancedTimerEvent.REPETITION_COMPLETED, timer_repetitionCompletedHandler);
			info.timer.reset();
			info.timer.start();
		}
		
		private function timer_repetitionCompletedHandler(event:AdvancedTimerEvent):void
		{
			var info:FuncInfo = getInfoForTimer(event.currentTarget as AdvancedTimer);
			
			// if no reference in dictionary, it means that the function has been unregistered
			if (dictionary[info.func] == undefined || !running)
				return;
			
			info.func.apply(null, info.parameters);
		}
		
		private function getInfoForTimer(timer:AdvancedTimer):FuncInfo
		{
			for each (var info:FuncInfo in dictionary)
				if (info.timer == timer)
					return info;
			
			return null;
		}
		
		public function start(executeImmediately:Boolean = false):void
		{
			running = true;
			
			if (executeImmediately)
				for each (var info:FuncInfo in dictionary)
					startTimerForInfo(info);
		}
		
		public function stop():void
		{
			running = false;
		}
		
		public function clear():void
		{
			// stop execution
			stop();
			
			//stopAllTimers
			for each (var info:FuncInfo in dictionary)
				stopTimerForInfo(info);
			// clear all references
			dictionary = new Dictionary();
		}
	}

}
import nslib.timers.AdvancedTimer;

class FuncInfo
{
	public var func:Function;
	
	public var parameters:Array;
	
	public var interval:Number = 1000;
	
	public var timer:AdvancedTimer;
}