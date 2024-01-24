package islandBreak.supportControls
{
	import constants.WeaponContants;
	import flash.display.Shader;
	import flash.display.Shape;
	import islandBreak.controllers.WeaponController;
	import islandBreak.dynamicMap.DynamicMap;
	import nslib.controls.NSSprite;
	import nslib.geometry.DashedLine;
	import nslib.geometry.Graph;
	import nslib.utils.NSMath;
	import weapons.base.IWeapon;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class MiniMap extends NSSprite
	{
		private var mapThumb:Shape = null;
		
		private var frame:Shape = new Shape();
		
		private var dashLines:DashedLine = null;
		
		private var mapContent:Shape = new Shape();
		
		private var mapMask:Shape = new Shape();
		private var mapMask2:Shape = new Shape();
		
		private var userPlane:Shape = new Shape();
		
		public function MiniMap()
		{
			construct();
		}
		
		private function construct():void
		{
			frame.graphics.beginFill(0x0D4406, 0.8);
			frame.graphics.lineStyle(2, 0x1DA50E, 0.8);
			
			frame.graphics.drawRect(0, 0, 150, 150);
			
			dashLines = new DashedLine(0.5, 0x1DA50E);
			dashLines.alpha = 0.7;
			dashLines.moveTo(0, 30);
			dashLines.lineTo(150, 30);
			dashLines.moveTo(0, 60);
			dashLines.lineTo(150, 60);
			dashLines.moveTo(0, 90);
			dashLines.lineTo(150, 90);
			dashLines.moveTo(0, 120);
			dashLines.lineTo(150, 120);
			
			dashLines.moveTo(30, 0);
			dashLines.lineTo(30, 150);
			dashLines.moveTo(60, 0);
			dashLines.lineTo(60, 150);
			dashLines.moveTo(90, 0);
			dashLines.lineTo(90, 150);
			dashLines.moveTo(120, 0);
			dashLines.lineTo(120, 150);
			
			dashLines.cacheAsBitmap = true;
			
			mapMask.graphics.beginFill(0x1DA50E);
			mapMask.graphics.lineStyle(2, 0x1DA50E);
			
			mapMask.graphics.drawRect(0, 0, 150, 150);
			
			mapMask2.graphics.beginFill(0x1DA50E);
			mapMask2.graphics.lineStyle(2, 0x1DA50E);
			
			mapMask2.graphics.drawRect(0, 0, 150, 150);
			
			userPlane.x = 75;
			userPlane.y = 75;
			
			userPlane.graphics.lineStyle(1, 0xAAAAFF);
			userPlane.graphics.beginFill(0xAAAAFF, 0.5);
			userPlane.graphics.moveTo(10, 0);
			userPlane.graphics.lineTo(-5, -5);
			userPlane.graphics.lineTo(-5, 5);
			userPlane.graphics.lineTo(10, 0);
		}
		
		public function applyMapThumb(thumb:Shape):void
		{
			removeAllChildren();
			addChild(frame);
			addChild(mapMask);
			addChild(mapMask2);
			
			mapThumb = thumb;
			mapThumb.mask = mapMask;
			
			mapContent.mask = mapMask2;
			
			addChild(mapThumb);
			addChild(mapContent);
			addChild(dashLines);
			addChild(userPlane);
		}
		
		private var updateCount:int = 0;
		
		public function update(bodyAngle:Number, map:DynamicMap):void
		{
			if (updateCount++ < 2)
				return;
				
			updateCount = 0;
			
			mapThumb.x = convertToMiniMapCoordinates(map.x, map);
			mapThumb.y = convertToMiniMapCoordinates(map.y, map);
			
			userPlane.rotation = NSMath.radToDeg(bodyAngle);
			
			mapContent.graphics.clear();
			mapContent.graphics.lineStyle(1, 0xFF0000, 0.8);
			
			for each (var enemy:IWeapon in WeaponController.instance.userUnits.source)
				mapContent.graphics.drawCircle(convertToMiniMapCoordinates(map.x + enemy.x, map), convertToMiniMapCoordinates(map.y + enemy.y, map), 1);
				
			mapContent.graphics.lineStyle(1, 0x0000FF, 0.8);
			
			for each (var helper:IWeapon in WeaponController.instance.enemies.source)
				mapContent.graphics.drawCircle(convertToMiniMapCoordinates(map.x + helper.x, map), convertToMiniMapCoordinates(map.y + helper.y, map), 1);
		}
		
		private function convertToMiniMapCoordinates(coord:Number, map:DynamicMap):Number
		{
			return coord * map.thumbRatio + frame.width / 2 - 15;
		}
	
	}

}