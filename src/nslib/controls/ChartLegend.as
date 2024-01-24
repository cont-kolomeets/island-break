/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import nslib.controls.supportClasses.ChartSeriesInfo;
	import nslib.controls.supportClasses.LayoutConstants;
	import nslib.utils.FontDescriptor;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ChartLegend extends LayoutContainer
	{
		
		public function ChartLegend()
		{
			layout = LayoutConstants.VERTICAL;
			horizontalAlignment = "left";
		}
		
		public function constructFromDataProvider(dataProvider:Array):void
		{
			removeAllChildren();
			
			for each (var series:ChartSeriesInfo in dataProvider)
			{
				if (!series.label)
					continue;
				
				var holder:NSSprite = new NSSprite();
				holder.graphics.lineStyle(2, series.color);
				holder.graphics.moveTo(0, 2);
				holder.graphics.lineTo(20, 2);
				
				var label:CustomTextField = new CustomTextField(series.label, new FontDescriptor(12, 0));
				label.x = 25;
				label.y = -label.height / 2;
				holder.addChild(label);
				
				addChild(holder);
			}
		
		}
	
	}

}