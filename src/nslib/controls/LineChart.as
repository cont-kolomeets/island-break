/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import nslib.controls.supportClasses.ChartSeriesInfo;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class LineChart extends ChartBase
	{
		private var legend:ChartLegend = new ChartLegend();
		
		////////////////
		
		public function LineChart()
		{
		}
		
		////////////////
		
		override public function set dataProvider(value:Array):void
		{
			super.dataProvider = value;
			legend.constructFromDataProvider(value);
		}
		
		////////////////
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			legend.x = 20;
			legend.y = -chartHeight + 20;
			addChild(legend);
		}
		
		override protected function drawSeries():void
		{
			for each (var series:ChartSeriesInfo in dataProvider)
			{
				var len:int = series.xValues.length - 1;
				
				graphics.lineStyle(series.lineThickness, series.color);
				
				for (var i:int = 0; i < len; i++)
				{
					graphics.moveTo(series.xValues[i] * chartScaleX, -series.yValues[i] * chartScaleY);
					graphics.lineTo(series.xValues[i + 1] * chartScaleX, -series.yValues[i + 1] * chartScaleY);
					
					graphics.drawCircle(series.xValues[i + 1] * chartScaleX, -series.yValues[i + 1] * chartScaleY, 2);
				}
			}
		}
	
	}

}