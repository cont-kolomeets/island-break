package islandBreak.dynamicMap
{
	import flash.geom.Rectangle;
	import islandBreak.constants.GamePlayConstants;
	import islandBreak.constants.MapConstants;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class DynamicPartInfoHolder extends NSSprite
	{
		private var parts:Array = null;
		
		private var indexHash:Object = {};
		
		private var screenRect:Rectangle = new Rectangle(0, 0, GamePlayConstants.STAGE_WIDTH + MapConstants.EXPANSION, GamePlayConstants.STAGE_HEIGHT + MapConstants.EXPANSION);
		
		////////////
		
		public function DynamicPartInfoHolder()
		{
		}
		
		/////////////
		
		public function applyParts(parts:Array):void
		{
			removeAllChildren();
			
			for each (var partInfo:PartInfo in parts)
				indexHash[partInfo.indexX + "," + partInfo.indexY] = partInfo;
			
			this.parts = parts;
		}
		
		private function partShouldBeShown(part:PartInfo):Boolean
		{
			screenRect.x = -this.x - MapConstants.EXPANSION / 2;
			screenRect.y = -this.y - MapConstants.EXPANSION / 2;
			
			return screenRect.contains(part.centerX, part.centerY);
		}
		
		public function updateParts():void
		{
			for each (var part:PartInfo in parts)
				if (partShouldBeShown(part))
				{
					if (part.isReusable)
					{
						if (!part.image)
						{
							part.prepareData();
							addChild(part.image);
						}
					}
					else if (!contains(part.image))
					{
						part.prepareData();
						addChild(part.image);
					}
				}
				else
				{
					if (part.image && contains(part.image))
					{
						removeChild(part.image);
						part.notifyRemovedFromMap();
					}
				}
		}
		
		private var imagesArray:Array = [];
		
		public function getBitmapsAt(xFrom:Number, yFrom:Number, xTo:Number, yTo:Number):Array
		{
			imagesArray.length = 0;
			
			var indexXMin:int = xFrom / MapConstants.MAP_PART_WIDTH;
			var indexYMin:int = yFrom / MapConstants.MAP_PART_HEIGHT;
			
			var indexXMax:int = xTo / MapConstants.MAP_PART_WIDTH;
			var indexYMax:int = yTo / MapConstants.MAP_PART_HEIGHT;
			
			for (var i:int = indexXMin; i <= indexXMax; i++)
				for (var j:int = indexYMin; j <= indexYMax; j++)
				{
					var info:PartInfo = indexHash[i + "," + j];
					
					if (info)
						imagesArray.push(info.image);
				}
			
			return imagesArray;
		}
		
		public function applyLayerPart(layerPart:LayerPart):void
		{
			MapBuilder.applyLayerPart(parts, layerPart, indexHash);
		}
	
	}

}