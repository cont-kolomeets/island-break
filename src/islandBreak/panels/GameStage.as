package islandBreak.panels
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import islandBreak.constants.GamePlayConstants;
	import islandBreak.controllers.ItemDynamicPlacer;
	import islandBreak.dynamicMap.DynamicMap;
	import islandBreak.dynamicMap.DynamicTracableLayer;
	import islandBreak.dynamicMap.MapBuilder;
	import islandBreak.dynamicMap.PartInfo;
	import islandBreak.supportControls.MiniMap;
	import nslib.controls.NSSprite;
	import nslib.effects.traceEffects.IDynamicTracableContainer;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class GameStage extends PanelBase implements IDynamicTracableContainer
	{
		public var map:DynamicMap = null;
		
		// layer to put children
		public var groundItemLayer:ItemDynamicPlacer = new ItemDynamicPlacer();
		
		// layer to put aircrafts
		public var aircraftDynamicLayer:ItemDynamicPlacer = new ItemDynamicPlacer();
		
		public var aircraftUserLayer:NSSprite = new NSSprite();
		
		public var tracableLayer:DynamicTracableLayer = new DynamicTracableLayer();
		
		// layer to put menus
		public var menuLayer:NSSprite = new NSSprite();
		
		public var miniMap:MiniMap = new MiniMap();
		
		//////////////////
		
		// panel that holds lots of contorls
		public var gameControlPanel:GameControlPanel = new GameControlPanel();
		
		// used to draw some lines
		public var drawingLayer:Shape = new Shape();
		
		private var layersToUpdate:Array = null;
		
		//////////////
		
		public function GameStage()
		{
			construct();
		}
		
		public function reset():void
		{
			construct();
		}
		
		////////////
		
		private function construct():void
		{
			removeAllChildren();
			
			if (!map)
				map = MapBuilder.generateMapForIsland();
			
			groundItemLayer.reset();
			aircraftDynamicLayer.reset();
			aircraftUserLayer.removeAllChildren();
			drawingLayer.graphics.clear();
			
			addChild(map);
			addChild(groundItemLayer);
			addChild(tracableLayer);
			addChild(aircraftDynamicLayer);
			addChild(aircraftUserLayer);
			addChild(drawingLayer);
			addChild(gameControlPanel);
			
			layersToUpdate = [map, groundItemLayer, aircraftDynamicLayer, drawingLayer, tracableLayer, aircraftUserLayer];
			
			miniMap.x = GamePlayConstants.STAGE_WIDTH - 160;
			miniMap.y = GamePlayConstants.STAGE_HEIGHT - 160;
			
			miniMap.applyMapThumb(map.getThumb());
			
			addChild(miniMap);
			
			moveScreenTo(0, 0, 0);
		}
		
		public function moveScreenTo(xTo:Number, yTo:Number, userPlaneBodyAngle:Number):void
		{
			for each (var layer:DisplayObject in layersToUpdate)
			{
				layer.x = xTo;
				layer.y = yTo;
			}
			
			map.updateParts();
			tracableLayer.updateParts();
			groundItemLayer.updateItems();
			aircraftDynamicLayer.updateItems();
			
			// center user aircraft
			if (aircraftUserLayer.numChildren > 0)
			{
				var userAircraft:DisplayObject = aircraftUserLayer.getChildAt(0);
				
				if (userAircraft)
				{
					userAircraft.x = -aircraftUserLayer.x + GamePlayConstants.STAGE_WIDTH / 2;
					userAircraft.y = -aircraftUserLayer.y + GamePlayConstants.STAGE_HEIGHT / 2;
				}
			}
			
			miniMap.update(userPlaneBodyAngle, map);
		}
		
		//////////////
		
		private var traceColorTransform:ColorTransform = new ColorTransform(1, 1, 1, 0.95);
		
		public function applyTraceColorTransform():void
		{
			tracableLayer.applyColorTransformToAllBitmapData(traceColorTransform);
		}
		
		public function applyFilter(filter:BitmapFilter):void
		{
			tracableLayer.applyFilterToAllBitmapData(filter);
		}
		
		public function getTracableBitMapsToDrawAtXY(xFrom:Number, yFrom:Number, xTo:Number, yTo:Number):Array
		{
			return tracableLayer.getBitmapsAt(xFrom, yFrom, xTo, yTo);
		}
		
		public function getPermanentBitMapsToDrawAtXY(xFrom:Number, yFrom:Number, xTo:Number, yTo:Number):Array
		{
			return map.getBitmapsAt(xFrom, yFrom, xTo, yTo);
		}
	
	}

}