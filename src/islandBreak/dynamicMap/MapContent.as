package islandBreak.dynamicMap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import islandBreak.constants.MapConstants;
	import islandBreak.supportClasses.resources.EnemyWeaponLocationConfig;
	import islandBreak.supportClasses.resources.MapContentLocations;
	import nslib.sequencers.ImageSequencer;
	import nslib.utils.ImageUtil;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class MapContent
	{
		public static const ISLAND_CENTERS:Array = [[2000, 2000, 300], [3000, 1500, 100], [2500, 4000, 70]];
		
		///////////
		
		[Embed(source="F:/Island Break/media/images/ground objects/palm 01.png")]
		public static var palm01:Class;
		
		[Embed(source="F:/Island Break/media/images/ground objects/stones small.png")]
		public static var stonesSmall:Class;
		
		[Embed(source="F:/Island Break/media/images/ground objects/stones big.png")]
		public static var stonesBig:Class;
		
		[Embed(source="F:/Island Break/media/images/ground objects/grass 01.png")]
		public static var grass01:Class;
		
		[Embed(source="F:/Island Break/media/images/ground objects/sand pattern.png")]
		public static var sandPattern:Class;
		
		[Embed(source="F:/Island Break/media/images/common images/ground pads/base for weapon yellow.png")]
		public static var yellowPad:Class;
		
		///////////
		
		private static var shape:Shape = new Shape();
		
		public static function genrateSeaPartBitmapData():BitmapData
		{
			var bitmapData:BitmapData = new BitmapData(MapConstants.MAP_PART_WIDTH, MapConstants.MAP_PART_HEIGHT, false, 0x53A5D5);
			
			// generate random dots
			//0x95D5F9
			//0x4289B5
			//0xF7F9FF
			
			shape.graphics.clear();
			shape.graphics.beginFill(0x53A5D5);
			shape.graphics.drawRect(0, 0, MapConstants.MAP_PART_WIDTH, MapConstants.MAP_PART_HEIGHT);
			
			for (var i:int = 0; i < 10; i++)
			{
				var width:Number = 3 + 10 * Math.random();
				shape.graphics.beginFill(0x95D5F9);
				shape.graphics.drawEllipse(10 + Math.random() * (MapConstants.MAP_PART_WIDTH - 20), 10 + Math.random() * (MapConstants.MAP_PART_HEIGHT - 20), width, width * 1.5);
				
				width = 3 + 10 * Math.random();
				shape.graphics.beginFill(0x4289B5);
				shape.graphics.drawEllipse(10 + Math.random() * (MapConstants.MAP_PART_WIDTH - 20), 10 + Math.random() * (MapConstants.MAP_PART_HEIGHT - 20), width, width * 1.5);
				
				width = 3 + 5 * Math.random();
				shape.graphics.beginFill(0xF7F9FF);
				shape.graphics.drawEllipse(10 + Math.random() * (MapConstants.MAP_PART_WIDTH - 20), 10 + Math.random() * (MapConstants.MAP_PART_HEIGHT - 20), width, width * 1.5);
			}
			
			bitmapData.draw(shape, null, null, null, null, false);
			
			return bitmapData;
		}
		
		public static function getIslandShapes():Array
		{
			var shapes:Array = [];
			
			for each (var loc:Array in ISLAND_CENTERS)
			{
				var shape:Shape = new Shape();
				
				var radius:Number = loc[2];
				
				shape.x = loc[0] - loc[2];
				shape.y = loc[1] - loc[2];
				
				shape.graphics.beginFill(0xFEE6BA);
				shape.graphics.lineStyle(10, 0xF4FCFF);
				shape.graphics.drawCircle(radius, radius, radius);
				
				shape.graphics.endFill();
				shape.graphics.lineStyle(10, 0x93D3F7);
				shape.graphics.drawCircle(radius, radius, radius + 10);
				
				shapes.push(shape);
			}
			
			return shapes;
		}
		
		// layer is an array of LayerPart objects
		public static function getSandPatternLayer():Array
		{
			var parts:Array = [];
			
			var sandPattern:Bitmap = new sandPattern();
			
			var bitmapData:BitmapData = sandPattern.bitmapData;
			bitmapData.colorTransform(bitmapData.rect, new ColorTransform(1, 1, 1, 0.3));
			
			for each (var obj:Object in MapContentLocations.sandPatterns)
			{
				var part:LayerPart = new LayerPart();
				part.x = obj.x;
				part.y = obj.y;
				
				part.bitmapData = ImageUtil.scaleBitmapData(bitmapData, obj.scale, obj.scale);
				
				parts.push(part);
			}
			
			return parts;
		}
		
		// layer is an array of LayerPart objects
		public static function getPadsLayer():Array
		{
			var parts:Array = [];
			
			var pad:Bitmap = new yellowPad();
			
			var bitmapData:BitmapData = pad.bitmapData;
			bitmapData.colorTransform(bitmapData.rect, new ColorTransform(1, 1, 1, 0.5));
			
			for each (var obj:Object in EnemyWeaponLocationConfig.CONFIG[0])
			{
				var part:LayerPart = new LayerPart();
				part.x = obj.x - pad.width / 2;
				part.y = obj.y - pad.height / 2;
				
				part.bitmapData = bitmapData;
				
				parts.push(part);
			}
			
			return parts;
		}
		
		public static function getGrassLayer():Array
		{
			return [];
		}
		
		public static function getSomeItemsLayer():Array
		{
			return [];
		}
		
		public static function getStoneLayer():Array
		{
			var parts:Array = [];
			
			var stone:Bitmap = new stonesBig();
			
			var bitmapData:BitmapData = stone.bitmapData;
			var shadowBitmapData:BitmapData = createShadow(bitmapData);
			
			for each (var obj:Object in MapContentLocations.stonesBig)
			{
				var part:LayerPart = new LayerPart();
				part.x = obj.x;
				part.y = obj.y;
				part.shadowOffset = 7;
				
				var angle:Number = NSMath.degToRad(obj.angle);
				part.bitmapData = ImageUtil.scaleBitmapData(rotateBitmapData(bitmapData, angle), obj.scale, obj.scale);
				part.shadowBitmapData = ImageUtil.scaleBitmapData(rotateBitmapData(shadowBitmapData, angle), obj.scale, obj.scale);
				
				parts.push(part);
			}
			
			return parts;
		}
		
		public static function getPalmTreeLayer():Array
		{
			var parts:Array = [];
			
			var treeImage:Bitmap = new palm01();
			
			var bitmapData:BitmapData = treeImage.bitmapData;
			var shadowBitmapData:BitmapData = createShadow(bitmapData);
			
			for each (var obj:Object in MapContentLocations.palmTrees)
			{
				var part:LayerPart = new LayerPart();
				part.x = obj.x;
				part.y = obj.y
				part.shadowOffset = 10;
				
				var angle:Number = NSMath.degToRad(obj.angle);
				part.bitmapData = ImageUtil.scaleBitmapData(rotateBitmapData(bitmapData, angle), obj.scale, obj.scale);
				part.shadowBitmapData = ImageUtil.scaleBitmapData(rotateBitmapData(shadowBitmapData, angle), obj.scale, obj.scale);
				
				parts.push(part);
			}
			
			return parts;
		}
		
		private static var shadowCT:ColorTransform = new ColorTransform(0, 0, 0, 0.4);
		
		private static function createShadow(bitmapData:BitmapData):BitmapData
		{
			var shadow:BitmapData = bitmapData.clone();
			
			shadow.colorTransform(shadow.rect, shadowCT);
			
			return shadow;
		}
		
		private static function rotateBitmapData(bitmapData:BitmapData, angleRadians:Number):BitmapData
		{
			if (bitmapData.width != bitmapData.height)
				throw new Error("Dimensions are not equal!");
			
			var newData:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			
			var rotationMatrix:Matrix = new Matrix();
			rotationMatrix.translate(-newData.width / 2, -newData.height / 2);
			rotationMatrix.rotate(angleRadians);
			rotationMatrix.translate(newData.width / 2, newData.height / 2);
			newData.draw(bitmapData, rotationMatrix);
			
			return newData;
		}
	}

}