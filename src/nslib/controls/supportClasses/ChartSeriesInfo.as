/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls.supportClasses
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ChartSeriesInfo
	{
		public var label:String = null;
		
		public var color:int = 0;
		
		public var lineThickness:Number = 2;
		
		public var xValues:Array = null;
		
		public var yValues:Array = null;
		
		//////////
		
		public function ChartSeriesInfo()
		{
		
		}
		
		//////////
		
		public function normalizeY(base:Number = 1):void
		{
			if (!yValues)
				return;
			
			var maxValue:Number = Number.NEGATIVE_INFINITY;
			
			for each (var value:Number in yValues)
				maxValue = Math.max(maxValue, value);
			
			var len:int = yValues.length;
			
			for (var i:int = 0; i < len; i++)
				yValues[i] = yValues[i] / maxValue;
		}
	
	}

}