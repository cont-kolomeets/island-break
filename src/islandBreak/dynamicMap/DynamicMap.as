package islandBreak.dynamicMap
{
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import islandBreak.constants.GamePlayConstants;
	import islandBreak.constants.MapConstants;
	import nslib.controls.NSSprite;
	import nslib.utils.ObjectsPoolUtil;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class DynamicMap extends DynamicPartInfoHolder
	{
		////////////
		
		public function DynamicMap()
		{
		}
		
		/////////////
		
		public function get thumbRatio():Number
		{
			return 0.05;
		}
		
		public function getThumb():Shape
		{
			var thumb:Shape = new Shape();
			thumb.graphics.beginFill(0x1DA50E);
			thumb.graphics.lineStyle(2, 0x1DA50E, 1);
			
			for each(var loc:Object in MapContent.ISLAND_CENTERS)
				thumb.graphics.drawCircle(loc[0] * thumbRatio, loc[1] * thumbRatio, loc[2] * thumbRatio);
				
			return thumb;
		}
	}

}