package islandBreak.dynamicMap 
{
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class SeaPartBitmap extends DynamicBitmap 
	{
		
		public function SeaPartBitmap() 
		{
			super(null);
			
			generateBitmapData();
		}
		
		private function generateBitmapData():void
		{
			this.bitmapData = MapContent.genrateSeaPartBitmapData();
		}
		
	}

}