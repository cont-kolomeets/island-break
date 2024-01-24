/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.utils.getTimer;
	
	public class PerformanceTestUtil
	{
		public static function executeFunction(func1:Function, executions:int = 1000):Number
		{
			var startTime:int = getTimer();
			
			for (var i:int = 0; i < executions; i++)
				func1();
			
			return (getTimer() - startTime);
		}
	}
}
