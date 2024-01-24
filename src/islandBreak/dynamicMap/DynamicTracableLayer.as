package islandBreak.dynamicMap
{
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import islandBreak.constants.GamePlayConstants;
	import islandBreak.constants.MapConstants;
	import nslib.controls.NSSprite;
	import nslib.utils.ObjectsPoolUtil;
	import nslib.utils.OptimizedArray;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class DynamicTracableLayer extends NSSprite
	{
		private const PART_POOL_ID:String = "DynamicTracableLayer";
		
		private const PART_SIZE:int = 128;
		
		private var screenRect:Rectangle = new Rectangle(0, 0, GamePlayConstants.STAGE_WIDTH + MapConstants.EXPANSION, GamePlayConstants.STAGE_HEIGHT + MapConstants.EXPANSION);
		
		///////////
		
		public function DynamicTracableLayer()
		{
			prepareParts();
		}
		
		///////////
		
		private function prepareParts():void
		{
			for (var i:int = 0; i < 35; i++)
			{
				var partInfo:PartInfo = new PartInfo();
				partInfo.image = new DynamicBitmap(new BitmapData(PART_SIZE, PART_SIZE, true, 0x00000000));
				partInfo.poolID = PART_POOL_ID;
				
				ObjectsPoolUtil.returnObject(partInfo, true, PartInfo);
			}
		}
		
		////////////
		
		private function partShouldBeShown(part:PartInfo):Boolean
		{
			screenRect.x = -this.x - MapConstants.EXPANSION / 2;
			screenRect.y = -this.y - MapConstants.EXPANSION / 2;
			
			return screenRect.contains(part.centerX, part.centerY);
		}
		
		private var clearColorTransform:ColorTransform = new ColorTransform(0, 0, 0, 0);
		
		private var parts:OptimizedArray = new OptimizedArray();
		
		private var hashIndex:Object = {};
		
		public function updateParts():void
		{
			var len:int = parts.length;
			
			for (var i:int = 0; i < len; i++)
			{
				var partInfo:PartInfo = parts.getItemAt(i) as PartInfo;
				
				if (partInfo && !partShouldBeShown(partInfo))
				{
					partInfo.applyColorTransform(clearColorTransform);
					
					if (contains(partInfo.image))
						removeChild(partInfo.image);
					
					parts.removeItemAt(i);
					delete hashIndex[partInfo.indexX + "," + partInfo.indexY];
					ObjectsPoolUtil.returnObject(partInfo);
				}
			}
			
			checkIfPartsAreNeeded();
		}
		
		private function checkIfPartsAreNeeded():void
		{
			var indexXMin:int = -this.x / PART_SIZE;
			var indexYMin:int = -this.y / PART_SIZE;
			
			var indexXMax:int = (GamePlayConstants.STAGE_WIDTH - this.x) / PART_SIZE;
			var indexYMax:int = (GamePlayConstants.STAGE_HEIGHT - this.y) / PART_SIZE;
			
			for (var i:int = indexXMin; i <= indexXMax; i++)
				for (var j:int = indexYMin; j <= indexYMax; j++)
					if (hashIndex[i + "," + j] == undefined)
						tryPutPartAt(i, j);
		}
		
		private var imagesArray:Array = [];
		
		public function getBitmapsAt(xFrom:Number, yFrom:Number, xTo:Number, yTo:Number):Array
		{
			imagesArray.length = 0;
			
			var indexXMin:int = xFrom / PART_SIZE;
			var indexYMin:int = yFrom / PART_SIZE;
			
			var indexXMax:int = xTo / PART_SIZE;
			var indexYMax:int = yTo / PART_SIZE;
			
			for (var i:int = indexXMin; i <= indexXMax; i++)
				for (var j:int = indexYMin; j <= indexYMax; j++)
				{
					var info:PartInfo = hashIndex[i + "," + j];
					
					if (info)
						imagesArray.push(info.image);
				}
			
			return imagesArray;
		}
		
		public function applyColorTransformToAllBitmapData(colorTransform:ColorTransform):void
		{
			for each (var partInfo:PartInfo in hashIndex)
				partInfo.applyColorTransform(colorTransform);
		}
		
		public function applyFilterToAllBitmapData(filter:BitmapFilter):void
		{
			for each (var partInfo:PartInfo in hashIndex)
				partInfo.applyFilter(filter);
		}
		
		private function tryPutPartAt(indexX:int, indexY:int):void
		{
			var partInfo:PartInfo = ObjectsPoolUtil.takeObjectOnlyIfExists(PartInfo, null, PART_POOL_ID);
			
			if (partInfo)
			{
				partInfo.x = indexX * PART_SIZE;
				partInfo.y = indexY * PART_SIZE;
				partInfo.image.x = partInfo.x;
				partInfo.image.y = partInfo.y;
				partInfo.indexX = indexX;
				partInfo.indexY = indexY;
				partInfo.centerX = partInfo.x + partInfo.image.width / 2;
				partInfo.centerY = partInfo.y + partInfo.image.height / 2;
				
				parts.addItem(partInfo);
				hashIndex[partInfo.indexX + "," + partInfo.indexY] = partInfo;
				
				if (!contains(partInfo.image))
					addChild(partInfo.image);
			}
		}
	}

}