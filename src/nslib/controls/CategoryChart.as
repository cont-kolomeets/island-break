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
	public class CategoryChart extends ChartBase
	{
		private var categories:Array = [];
		private var categoriesIndicesHash:Object = null;
		
		//////////////////
		
		public function CategoryChart()
		{
		
		}
		
		//////////////////
		
		override public function set dataProvider(value:Array):void
		{
			super.dataProvider = value;
			collectPositions();
		}
		
		/////////////////
		
		private function collectPositions():void
		{
			categories.length = 0;
			categoriesIndicesHash = {};
			
			for each (var series:ChartSeriesInfo in dataProvider)
			{
				var len:int = series.yValues.length;
				
				for (var i:int = 0; i < len; i++)
				{
					var name:String = String(series.yValues[i]);
					
					if (categoriesIndicesHash[name] == undefined)
					{
						categoriesIndicesHash[name] = categories.length;
						categories.push(name);
					}
				}
			}
		}
		
		override protected function findBounds():void
		{
			xMax = Number.MIN_VALUE;
			yMax = chartHeight;
			
			for each (var series:ChartSeriesInfo in dataProvider)
			{
				var len:int = series.xValues.length;
				
				for (var i:int = 0; i < len; i++)
					xMax = Math.max(xMax, Number(series.xValues[i]));
			}
		}
		
		override protected function drawAxis():void
		{
			graphics.lineStyle(2, 0);
			graphics.moveTo(-5, 0);
			graphics.lineTo(chartWidth, 0);
			graphics.moveTo(0, 5);
			graphics.lineTo(0, -chartHeight);
			
			removeAllChildren();
			
			var intervalX:Number = getIntervalX();
			var intervalY:Number = chartHeight / categories.length;
			
			var counter:Number = 0;
			var label:CustomTextField = null;
			var fd:FontDescriptor = new FontDescriptor(12, 0);
			
			while (counter <= xMax)
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
				
				counter += intervalX;
			}
			
			counter = 0;
			
			while (counter <= categories.length)
			{
				label = new CustomTextField(categories[counter], fd);
				label.x = -label.width - 5;
				label.y = -counter * intervalY - intervalY / 2 - 5;
				addChild(label);
				
				graphics.lineStyle(2, 0);
				graphics.moveTo(-3, label.y + 5);
				graphics.lineTo(3, label.y + 5);
				graphics.lineStyle(1, 0, 0.5);
				graphics.moveTo(3, label.y + 5);
				graphics.lineTo(chartWidth, label.y + 5);
				
				counter++;
			}
		}
		
		override protected function drawSeries():void
		{
			var intervalY:Number = chartHeight / categories.length;
			
			for each (var series:ChartSeriesInfo in dataProvider)
			{
				var len:int = series.xValues.length;
				
				graphics.lineStyle(series.lineThickness, series.color / 2);
				graphics.beginFill(series.color);
				
				for (var i:int = 0; i < len; i++)
				{
					graphics.drawCircle(series.xValues[i] * chartScaleX, -categoriesIndicesHash[String(series.yValues[i])] * intervalY - intervalY / 2, 3);
				}
			}
		}
	
	}

}