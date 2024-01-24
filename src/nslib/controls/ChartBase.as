/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import nslib.controls.supportClasses.ChartSeriesInfo;
	import nslib.utils.FontDescriptor;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ChartBase extends NSSprite
	{
		protected var xMin:Number = 0;
		protected var xMax:Number = 0;
		protected var yMin:Number = 0;
		protected var yMax:Number = 0;
		
		protected var chartScaleX:Number = 1;
		protected var chartScaleY:Number = 1;
		
		///////////////
		
		public function ChartBase()
		{
		
		}
		
		////////////////
		
		private var _dataProvider:Array = null;
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		// array of ChartSeriesInfo
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			invalidateProperties();
		}
		
		/////////
		
		private var _chartWidth:Number = 300;
		
		public function get chartWidth():Number
		{
			return _chartWidth;
		}
		
		public function set chartWidth(value:Number):void
		{
			_chartWidth = value;
			invalidateProperties();
		}
		
		///////////////
		
		private var _chartHeight:Number = 200;
		
		public function get chartHeight():Number
		{
			return _chartHeight;
		}
		
		public function set chartHeight(value:Number):void
		{
			_chartHeight = value;
			invalidateProperties();
		}
		
		////////////////
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			drawChart();
		}
		
		private function drawChart():void
		{
			findBounds();
			
			chartScaleX = chartWidth / xMax;
			chartScaleY = chartHeight / yMax;
			
			graphics.clear();
			drawAxis();
			drawSeries();
		}
		
		protected function findBounds():void
		{
			xMax = Number.MIN_VALUE;
			yMax = Number.MIN_VALUE;
			
			for each (var series:ChartSeriesInfo in dataProvider)
			{
				var len:int = series.xValues.length;
				
				for (var i:int = 0; i < len; i++)
				{
					xMax = Math.max(xMax, Number(series.xValues[i]));
					yMax = Math.max(yMax, Number(series.yValues[i]));
				}
			}
		}
		
		protected function drawAxis():void
		{
			graphics.lineStyle(2, 0);
			graphics.moveTo(-5, 0);
			graphics.lineTo(chartWidth, 0);
			graphics.moveTo(0, 5);
			graphics.lineTo(0, -chartHeight);
			
			removeAllChildren();
			
			var intervalX:Number = getIntervalX();
			var intervalY:Number = getIntervalY();
			
			var counter:Number = 0;
			var label:CustomTextField = null;
			var fd:FontDescriptor = new FontDescriptor(12, 0);
			
			while (counter <= xMax)
			{
				// draw zero only once (for Y axis)
				if (counter > 0)
				{
					label = new CustomTextField(counter + "", fd);
					label.y = 10;
					label.x = counter * chartScaleX - 5;
					addChild(label);
					
					graphics.lineStyle(2, 0);
					graphics.moveTo(label.x + 5, -3);
					graphics.lineTo(label.x + 5, 3);
					graphics.lineStyle(1, 0, 0.5);
					graphics.moveTo(label.x + 5, 3);
					graphics.lineTo(label.x + 5, -chartHeight);
				}
				
				counter += intervalX;
			}
			
			counter = 0;
			
			while (counter <= yMax)
			{
				var needFix:Boolean = (counter - int(counter)) > 0;
				label = new CustomTextField(needFix ? counter.toFixed(2) : counter + "", fd);
				label.x = -label.width - 5;
				label.y = -counter * chartScaleY - 5;
				addChild(label);
				
				graphics.lineStyle(2, 0);
				graphics.moveTo(-3, label.y + 5);
				graphics.lineTo(3, label.y + 5);
				graphics.lineStyle(1, 0, 0.5);
				graphics.moveTo(3, label.y + 5);
				graphics.lineTo(chartWidth, label.y + 5);
				
				counter += intervalY;
			}
		}
		
		protected function drawSeries():void
		{
			// must be implemented in subclasses
		}
		
		protected function getIntervalX():Number
		{
			return getIntervalForDifference(xMax - xMin);
		}
		
		protected function getIntervalY():Number
		{
			return getIntervalForDifference(yMax - yMin);
		}
		
		private function getIntervalForDifference(difference:Number):Number
		{
			if (difference == 0)
				return 100;
			
			if (difference < 0.5)
				return 0.05;
			else if (difference >= 0.5 && difference < 2)
				return 0.1;
			else if (difference >= 5 && difference < 20)
				return 1;
			else if (difference >= 20 && difference < 50)
				return 5;
			else if (difference >= 50 && difference < 200)
				return 10;
			else if (difference >= 200 && difference < 1000)
				return 50;
			else if (difference >= 1000 && difference < 5000)
				return 200;
			else if (difference >= 5000 && difference < 20000)
				return 500;
			else if (difference >= 20000 && difference < 50000)
				return 2000;
			else if (difference >= 50000 && difference < 200000)
				return 10000;
			else if (difference >= 200000)
				return 50000;
			
			return 100;
		}
	}

}