package islandBreak.dynamicMap
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class LayerPart
	{
		public var bitmapData:BitmapData = null;
		
		public var shadowBitmapData:BitmapData = null;
		
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public var matrix:Matrix = null;
		
		public var colorTransform:ColorTransform = null;
		
		public var reusableType:String = null;
		
		public var isReusable:Boolean = false;
		
		public var shadowOffset:Number = 0;
		
		public function LayerPart()
		{
		
		}
		
		public function dispose():void
		{
			if (bitmapData)
				bitmapData.dispose();
			
			if (shadowBitmapData)
				shadowBitmapData.dispose();
		}
	
	}

}