package islandBreak.dynamicMap
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import islandBreak.constants.MapConstants;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class MapBuilder
	{
		public static function generateMapForIsland():DynamicMap
		{
			var indexHash:Object = {};
			
			// draw the sea
			var parts:Array = createParts(indexHash);
			
			// draw the island
			applyShapes(parts, MapContent.getIslandShapes(), indexHash);
			
			// draw other items
			applyLayer(parts, MapContent.getSandPatternLayer(), indexHash);
			applyLayer(parts, MapContent.getPadsLayer(), indexHash);
			applyLayer(parts, MapContent.getGrassLayer(), indexHash);
			applyLayer(parts, MapContent.getSomeItemsLayer(), indexHash);
			applyLayer(parts, MapContent.getStoneLayer(), indexHash);
			applyLayer(parts, MapContent.getPalmTreeLayer(), indexHash);
			
			var map:DynamicMap = new DynamicMap();
			map.applyParts(parts);
			
			return map;
		}
		
		// this is the sea level
		private static function createParts(indexHash:Object):Array
		{
			var parts:Array = [];
			
			var xPos:Number = 0;
			var yPos:Number = 0;
			
			for (var i:int = 0; i < MapConstants.PARTS_VERTICAL; i++)
			{
				xPos = 0;
				
				for (var j:int = 0; j < MapConstants.PARTS_HORIZONTAL; j++)
				{
					var partInfo:PartInfo = new PartInfo();
					partInfo.image = null;
					partInfo.isReusable = true;
					partInfo.reusablePartType = ReusablePartType.REUSABLE_PART_SEA;
					partInfo.x = xPos;
					partInfo.y = yPos;
					partInfo.indexX = j;
					partInfo.indexY = i;
					partInfo.centerX = partInfo.x + MapConstants.MAP_PART_WIDTH / 2;
					partInfo.centerY = partInfo.y + MapConstants.MAP_PART_HEIGHT / 2;
					
					parts.push(partInfo);
					
					xPos += MapConstants.MAP_PART_WIDTH;
					
					indexHash[j + "," + i] = partInfo;
				}
				
				yPos += MapConstants.MAP_PART_HEIGHT;
			}
			
			return parts;
		}
		
		// optimizations
		private static var intersectingParts:Array = [];
		
		private static function getIntersectingParts(indexHash:Object, layerPart:LayerPart):Array
		{
			intersectingParts.length = 0;
			
			var indexXMin:int = layerPart.x / MapConstants.MAP_PART_WIDTH;
			var indexYMin:int = layerPart.y / MapConstants.MAP_PART_HEIGHT;
			
			var indexXMax:int = (layerPart.x + +layerPart.bitmapData.width + layerPart.shadowOffset) / MapConstants.MAP_PART_WIDTH;
			var indexYMax:int = (layerPart.y + layerPart.bitmapData.height + layerPart.shadowOffset) / MapConstants.MAP_PART_HEIGHT;
			
			return getIntersectingPartFromBounds(indexHash, indexXMin, indexYMin, indexXMax, indexYMax);
		}
		
		private static function getIntersectingPartsFromShape(indexHash:Object, shape:Shape):Array
		{
			intersectingParts.length = 0;
			
			var indexXMin:int = shape.x / MapConstants.MAP_PART_WIDTH;
			var indexYMin:int = shape.y / MapConstants.MAP_PART_HEIGHT;
			
			var indexXMax:int = (shape.x + shape.width) / MapConstants.MAP_PART_WIDTH;
			var indexYMax:int = (shape.y + shape.height) / MapConstants.MAP_PART_HEIGHT;
			
			return getIntersectingPartFromBounds(indexHash, indexXMin, indexYMin, indexXMax, indexYMax);
		}
		
		private static function getIntersectingPartFromBounds(indexHash:Object, indexXMin:Number, indexYMin:Number, indexXMax:Number, indexYMax:Number):Array
		{
			intersectingParts.length = 0;
			
			for (var i:int = indexXMin; i <= indexXMax; i++)
				for (var j:int = indexYMin; j <= indexYMax; j++)
					intersectingParts.push(indexHash[i + "," + j]);
			
			return intersectingParts;
		}
		
		private static function getPartInfoByXY(indexHash:Object, x:Number, y:Number):PartInfo
		{
			var indexX:int = x / MapConstants.MAP_PART_WIDTH;
			var indexY:int = y / MapConstants.MAP_PART_HEIGHT;
			
			return indexHash[indexX + "," + indexY];
		}
		
		private static var point:Point = new Point();
		
		private static function applyLayer(parts:Array, layerParts:Array, indexHash:Object):void
		{
			for each (var layerPart:LayerPart in layerParts)
				applyLayerPart(parts, layerPart, indexHash);
		}
		
		public static function applyLayerPart(parts:Array, layerPart:LayerPart, indexHash:Object):void
		{
			var intersectingParts:Array = getIntersectingParts(indexHash, layerPart);
			for each (var partInfo:PartInfo in intersectingParts)
			{
				if (partInfo.isReusable)
				{
					partInfo.prepareData();
					partInfo.isReusable = false;
				}
				
				if (layerPart.shadowBitmapData)
				{
					point.x = layerPart.x - partInfo.x + layerPart.shadowOffset;
					point.y = layerPart.y - partInfo.y + layerPart.shadowOffset;
					
					// adding shadow first
					partInfo.image.bitmapData.copyPixels(layerPart.shadowBitmapData, layerPart.shadowBitmapData.rect, point, null, null, true);
				}
				
				point.x = layerPart.x - partInfo.x;
				point.y = layerPart.y - partInfo.y;
				
				partInfo.image.bitmapData.copyPixels(layerPart.bitmapData, layerPart.bitmapData.rect, point, null, null, true);
			}
		}
		
		private static function applyShapes(parts:Array, shapes:Array, indexHash:Object):void
		{
			var point:Point = new Point();
			
			for each (var shape:Shape in shapes)
			{
				var intersectingParts:Array = getIntersectingPartsFromShape(indexHash, shape);
				
				for each (var partInfo:PartInfo in intersectingParts)
				{
					if (partInfo.isReusable)
					{
						partInfo.prepareData();
						partInfo.isReusable = false;
					}
					
					var matrix:Matrix = new Matrix();
					matrix.translate(shape.x - partInfo.x, shape.y - partInfo.y);
					
					partInfo.image.bitmapData.draw(shape, matrix);
				}
			}
		}
	
	}

}