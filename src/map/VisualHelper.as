/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package map
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.geom.Matrix;
	import nslib.AIPack.grid.GridArray;
	import nslib.AIPack.grid.GridCellInfo;
	import nslib.AIPack.grid.Location;
	import nslib.AIPack.grid.LocationConstants;
	import nslib.controls.NSSprite;
	import nslib.core.Globals;
	import nslib.utils.ArrayList;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class VisualHelper
	{
		public static var defaultContainer:NSSprite;
		
		public function VisualHelper()
		{
		}
		
		public static function drawCircle(stage:Stage, x:Number, y:Number, color:int):void
		{
			var shape:Shape = new Shape();
			Globals.topLevelApplication.addChild(shape);
			shape.graphics.lineStyle(1, color);
			shape.graphics.drawCircle(x, y, 1);
		}
		
		public static function visualizeGrid(container:Shape, grid:GridArray):void
		{
			var color:int;
			var alpha:Number;
			
			container.graphics.clear();
			
			//grid.print();
			
			for (var i:int = grid.indexXMin; i <= grid.indexXMax; i++)
				for (var j:int = grid.indexYMin; j <= grid.indexYMax; j++)
					if (grid.getElementAtIndex(i, j))
					{
						switch (Location(grid.getElementAtIndex(i, j)).id)
						{
							case LocationConstants.EMPTY: 
								color = 0;
								alpha = 0;
								break;
							case LocationConstants.OBSTACLE: 
								color = 0x454545;
								alpha = 0.5;
								break;
						}
						
						container.graphics.lineStyle(1, 0);
						container.graphics.beginFill(color, alpha);
						container.graphics.drawRect(i * grid.gridResolution - grid.gridResolution / 2, j * grid.gridResolution - grid.gridResolution / 2, grid.gridResolution, grid.gridResolution);
					}
		}
		
		public static function drawGridCell(container:*, grid:GridArray, location:Location, color:int, alpha:Number = 0.5, clearPreviousDrawings:Boolean = true):void
		{
			container = container ? container : defaultContainer;
			
			if (!container)
				return;
			
			if (clearPreviousDrawings)
				container.graphics.clear();
			container.graphics.beginFill(color, alpha);
			container.graphics.drawRect(location.indexX * grid.gridResolution - grid.gridResolution / 2 + grid.gridOffsetX, location.indexY * grid.gridResolution - grid.gridResolution / 2 + grid.gridOffsetY, grid.gridResolution, grid.gridResolution);
		}
		
		public static function drawGridCellInfo(container:NSSprite, grid:GridArray, location:Location, color:int, alpha:Number = 0.5):void
		{
			container = container ? container : defaultContainer;
			
			var gridInfo:GridCellInfo = new GridCellInfo(location, false);
			
			container.addChild(gridInfo);
			
			gridInfo.graphics.beginFill(color, alpha);
			gridInfo.x = location.indexX * grid.gridResolution;
			gridInfo.y = location.indexY * grid.gridResolution;
			
			gridInfo.graphics.drawRect(-grid.gridResolution / 2, -grid.gridResolution / 2, grid.gridResolution, grid.gridResolution);
		}
		
		/*public static function drawGridCellRelation(subject:Tom, location:Location, color:int, alpha:Number = 1):void
		   {
		   var grid:GridArray = subject.motionEngine.vision.grid;
		   subject.stage.addChild(subject.animationEngine.grid);
		
		   subject.animationEngine.grid.graphics.lineStyle(1, color, alpha);
		   subject.animationEngine.grid.graphics.drawCircle(location.indexX * grid.gridResolution, location.indexY * grid.gridResolution, grid.gridResolution / 4);
		
		   if (location.parent)
		   {
		   subject.animationEngine.grid.graphics.moveTo(location.indexX * grid.gridResolution, location.indexY * grid.gridResolution);
		   subject.animationEngine.grid.graphics.lineTo(location.parent.indexX * grid.gridResolution, location.parent.indexY * grid.gridResolution);
		   }
		 }*/
		
		/*private static var arrows:Array = [];
		
		public static function drawTrajectoryStack(container:NSSprite, tStack:ArrayList, color:int, alpha:Number = 0.5, removePreviousDrawing:Boolean = true):void
		{
			if (tStack.length == 0)
				return;
			
			if (removePreviousDrawing)
			{
				
				for each (var a:Shape in arrows)
					if (container.contains(a))
						container.removeChild(a);
				
				arrows = [];
			}
			
			container.graphics.clear();
			
			var len:int = tStack.length;
			for (var i:int = 0; i < (len - 1); i++)
			{		
				var numArrows:int = 1;
				
				var deltaIndexX:int = Math.abs(Location(tStack.getItemAt(i)).indexX - Location(tStack.getItemAt(i + 1)).indexX);
				var deltaIndexY:int = Math.abs(Location(tStack.getItemAt(i)).indexY - Location(tStack.getItemAt(i + 1)).indexY);
				
				// check if we deal with teleporting
				if (deltaIndexX > 1 || deltaIndexY > 1)
				{
					numArrows = int(Math.sqrt(deltaIndexX * deltaIndexX + deltaIndexY * deltaIndexY));
				}
				
				for (var n:int = 0; n < numArrows; n++)
				{
					var arrowColor:int = (Location(tStack.getItemAt(i)).color != -1) ? Location(tStack.getItemAt(i)).color : color;
					var arrow:Shape = createArrow(arrowColor);
					arrow.x = tStack.getItemAt(i).x + (tStack.getItemAt(i + 1).x - tStack.getItemAt(i).x) * (n + 1) / (numArrows + 1);
					arrow.y = tStack.getItemAt(i).y + (tStack.getItemAt(i + 1).y - tStack.getItemAt(i).y) * (n + 1) / (numArrows + 1);
					
					arrow.rotation = 360 / NSMath.PI / 2 * NSMath.atan2Rad((tStack.getItemAt(i + 1).y - tStack.getItemAt(i).y), (tStack.getItemAt(i + 1).x - tStack.getItemAt(i).x));
					
					container.addChild(arrow);
					arrows.push(arrow);
				}
			}
		}
		*/
		
		public static function drawTrajectoryStack(container:Bitmap, tStack:ArrayList, color:int, alpha:Number = 0.5, removePreviousDrawing:Boolean = true):void
		{
			if (tStack.length == 0)
				return;
			
			var workingBitmapData:BitmapData = container.bitmapData;
				
			if (removePreviousDrawing)
			{
				workingBitmapData = new BitmapData(GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT, true, 0x00000000);
				container.bitmapData = workingBitmapData;
			}

			var arrowColor:int = (Location(tStack.getItemAt(i)).color != -1) ? Location(tStack.getItemAt(i)).color : color;
			var arrow:Shape = createArrow(arrowColor);
			
			var len:int = tStack.length;
			for (var i:int = 0; i < (len - 1); i++)
			{		
				var numArrows:int = 1;
				
				var deltaIndexX:int = Math.abs(Location(tStack.getItemAt(i)).indexX - Location(tStack.getItemAt(i + 1)).indexX);
				var deltaIndexY:int = Math.abs(Location(tStack.getItemAt(i)).indexY - Location(tStack.getItemAt(i + 1)).indexY);
				
				// check if we deal with teleporting
				if (deltaIndexX > 1 || deltaIndexY > 1)
				{
					throw new Error("Teleporting is not supported for this version of the game!");
					numArrows = int(Math.sqrt(deltaIndexX * deltaIndexX + deltaIndexY * deltaIndexY));
				}
				
				for (var n:int = 0; n < numArrows; n++)
				{
					var matrix:Matrix = new Matrix();
					
					var angle:Number = NSMath.atan2Rad((tStack.getItemAt(i + 1).y - tStack.getItemAt(i).y), (tStack.getItemAt(i + 1).x - tStack.getItemAt(i).x));
					matrix.rotate(angle);
					
					var dx:Number = tStack.getItemAt(i).x + (tStack.getItemAt(i + 1).x - tStack.getItemAt(i).x) * (n + 1) / (numArrows + 1);
					var dy:Number = tStack.getItemAt(i).y + (tStack.getItemAt(i + 1).y - tStack.getItemAt(i).y) * (n + 1) / (numArrows + 1);
					matrix.translate(dx, dy);
					
					if (dx == 0 || dy == 0)
						throw new Error("Check drawing of trajectory! Class: VisualHelper.");
					
					container.bitmapData.draw(arrow, matrix);
				}
			}
		}
		
		private static function createArrow(color:int = -1):Shape
		{
			// draw arrow
			var arrow:Shape = new Shape();
			arrow.graphics.lineStyle(2, ((color != -1) ? color : 0x555555), 0.3);
			arrow.graphics.moveTo(10, 0);
			arrow.graphics.lineTo(7, -4);
			arrow.graphics.lineTo(7, -2);
			arrow.graphics.lineTo(-10, -2);
			arrow.graphics.lineTo(-10, 2);
			arrow.graphics.lineTo(7, 2);
			arrow.graphics.lineTo(7, 4);
			arrow.graphics.lineTo(10, 0);
			
			return arrow;
		}
	}

}