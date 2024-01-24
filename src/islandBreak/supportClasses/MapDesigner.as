package islandBreak.supportClasses
{
	import adobe.utils.CustomActions;
	import events.NewsEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import islandBreak.dynamicMap.DynamicMap;
	import islandBreak.dynamicMap.LayerPart;
	import islandBreak.dynamicMap.MapBuilder;
	import islandBreak.dynamicMap.MapContent;
	import islandBreak.panels.GameStage;
	import islandBreak.supportClasses.resources.MapContentLocations;
	import nslib.controls.NSSprite;
	import nslib.core.Globals;
	import nslib.utils.MouseUtil;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class MapDesigner
	{
		public var gameStage:GameStage = null;
		private var palmTrees:Array = null;
		private var stonesBig:Array = null;
		private var stonesMiddle:Array = null;
		private var stonesSmall:Array = null;
		private var sandPatterns:Array = null;
		
		private var arrays:Object = null;
		
		public function MapDesigner()
		{
			palmTrees = createInfoArray(MapContentLocations.palmTrees);
			stonesBig = createInfoArray(MapContentLocations.stonesBig);
			stonesMiddle = createInfoArray(MapContentLocations.stonesMiddle);
			stonesSmall = createInfoArray(MapContentLocations.stonesSmall);
			sandPatterns = createInfoArray(MapContentLocations.sandPatterns);
			
			arrays = {palmTrees: palmTrees, stonesBig: stonesBig, stonesMiddle: stonesMiddle, stonesSmall: stonesSmall, sandPatterns: sandPatterns};
		}
		
		private function createInfoArray(array:Array):Array
		{
			var newArray:Array = [];
			
			for each (var obj:Object in array)
			{
				var info:ItemInfo = new ItemInfo();
				info.x = obj.x;
				info.y = obj.y;
				info.angle = obj.angle;
				info.scale = obj.scale;
				
				newArray.push(info);
			}
			
			return newArray;
		}
		
		public function startDesigningMap():void
		{
			Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		private var screenX:Number = 0;
		private var screenY:Number = 0;
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.LEFT)
				screenX += 50;
			
			if (event.keyCode == Keyboard.RIGHT)
				screenX -= 50;
			
			if (event.keyCode == Keyboard.UP)
				screenY += 50;
			
			if (event.keyCode == Keyboard.DOWN)
				screenY -= 50;
			
			gameStage.moveScreenTo(screenX, screenY, 0);
			
			if (event.keyCode == Keyboard.T)
				putObject(MapContent.palm01, palmTrees);
			
			if (event.keyCode == Keyboard.B)
				putObject(MapContent.stonesBig, stonesBig);
			
			if (event.keyCode == Keyboard.M)
				putObject(MapContent.stonesSmall, stonesMiddle);
			
			if (event.keyCode == Keyboard.L)
				putObject(MapContent.stonesSmall, stonesSmall);
			
			if (event.keyCode == Keyboard.P)
				putObject(MapContent.sandPattern, sandPatterns);
			
			var lastItem:NSSprite = null;
			
			if (event.keyCode == Keyboard.U)
			{
				var lastArray:Array = lastArrays.pop();
				
				if (lastArray)
					lastArray.pop();
				
				lastItem = lastItems.pop();
				
				if (lastItem && gameStage.groundItemLayer.contains(lastItem))
					gameStage.groundItemLayer.removeChild(lastItem);
			}
			
			if (event.keyCode == Keyboard.R)
			{
				lastItem = lastItems[lastItems.length - 1];
				
				if (!lastItem)
					return;
				
				lastItem.rotation += 10;
				updateLastItemInArray();
			}
			
			if (event.keyCode == Keyboard.Q)
			{
				lastItem = lastItems[lastItems.length - 1];
				
				if (!lastItem)
					return;
				
				lastItem.scaleX -= 0.1;
				lastItem.scaleY -= 0.1;
				updateLastItemInArray();
			}
			
			if (event.keyCode == Keyboard.W)
			{
				lastItem = lastItems[lastItems.length - 1];
				
				if (!lastItem)
					return;
				
				lastItem.scaleX += 0.1;
				lastItem.scaleY += 0.1;
				updateLastItemInArray();
			}
			
			if (event.keyCode == Keyboard.NUMPAD_8)
			{
				lastItem = lastItems[lastItems.length - 1];
				
				if (!lastItem)
					return;
				
				lastItem.y -= 10;
				updateLastItemInArray();
			}
			
			if (event.keyCode == Keyboard.NUMPAD_5)
			{
				lastItem = lastItems[lastItems.length - 1];
				
				if (!lastItem)
					return;
				
				lastItem.y += 10;
				updateLastItemInArray();
			}
			
			if (event.keyCode == Keyboard.NUMPAD_4)
			{
				lastItem = lastItems[lastItems.length - 1];
				
				if (!lastItem)
					return;
				
				lastItem.x -= 10;
				updateLastItemInArray();
			}
			
			if (event.keyCode == Keyboard.NUMPAD_6)
			{
				lastItem = lastItems[lastItems.length - 1];
				
				if (!lastItem)
					return;
				
				lastItem.x += 10;
				updateLastItemInArray();
			}
			
			if (event.keyCode == Keyboard.S)
			{
				var fileRef:FileReference = new FileReference();
				
				var string:String = "";
				
				for (var id:String in arrays)
					string += "public static var " + id + ":Array = [" + (arrays[id] as Array).join(", ") + "];\n";
				
				fileRef.save(string, "MapDesign.txt");
			}
		}
		
		private var lastArrays:Array = [];
		
		private var lastItems:Array = [];
		
		private function putObject(cls:Class, array:Array):void
		{
			var point:Point = getCurrentPoint();
			var bm:Bitmap = new cls();
			
			var container:NSSprite = new NSSprite();
			
			lastItems.push(container);
			
			bm.x = -bm.width / 2;
			bm.y = -bm.height / 2;
			
			container.x = point.x;
			container.y = point.y;
			
			container.addChild(bm);
			
			gameStage.groundItemLayer.addChild(container);
			
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.x = container.x - bm.width / 2;
			itemInfo.y = container.y - bm.height / 2;
			
			array.push(itemInfo);
			
			lastArrays.push(array);
		}
		
		private function updateLastItemInArray():void
		{
			var lastArray:Array = lastArrays[lastArrays.length - 1];
			lastArray.pop();
			
			var lastItem:NSSprite = lastItems[lastItems.length - 1];
			
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.x = lastItem.x - lastItem.getChildAt(0).width / 2 * lastItem.scaleX;
			itemInfo.y = lastItem.y - lastItem.getChildAt(0).height / 2 * lastItem.scaleY;
			itemInfo.angle = lastItem.rotation;
			itemInfo.scale = lastItem.scaleX;
			
			lastArray.push(itemInfo);
		}
		
		private function getCurrentPoint():Point
		{
			var point:Point = new Point();
			
			point.x = MouseUtil.getCursorCoordinates().x - gameStage.groundItemLayer.x;
			point.y = MouseUtil.getCursorCoordinates().y - gameStage.groundItemLayer.y;
			
			return point;
		}
		
		private function createLayerPart(x:Number, y:Number, data:BitmapData):LayerPart
		{
			var layerPart:LayerPart = new LayerPart();
			layerPart.x = x;
			layerPart.y = y;
			layerPart.bitmapData = data;
			
			return layerPart;
		}
	}
}

class ItemInfo
{
	public var x:int = 0;
	public var y:int = 0;
	public var angle:Number = 0;
	public var scale:Number = 1;
	
	public function toString():String
	{
		return "{ x:" + x + ", y:" + y + ", angle:" + angle + ", scale:" + scale + " }";
	}
}