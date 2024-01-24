/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.objects
{
	import constants.MapConstants;
	import flash.display.Bitmap;
	import nslib.AIPack.grid.GridArray;
	import nslib.AIPack.grid.Location;
	import nslib.AIPack.grid.LocationConstants;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TrafficLight extends NSSprite
	{
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		public static const DIRECTION_VERTICAL:String = "vertical";
		
		[Embed(source="F:/Island Defence/media/images/common images/traffic light/traffic light base.png")]
		private static var baseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/traffic light/traffic light base highlighted.png")]
		private static var highlightedBaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/traffic light/traffic light triangle green.png")]
		private static var triangleGreenImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/traffic light/traffic light triangle yellow.png")]
		private static var triangleYellowImage:Class;
		
		/////////////////////////////
		
		public var grid:GridArray = null;
		
		private var direction:String = null;
		
		private var state:int = 1;
		
		private var baseBM:Bitmap = new baseImage();
		
		private var highlightedBaseBM:Bitmap = new highlightedBaseImage();
		
		private var triangleYellowBM:Bitmap = new triangleYellowImage();
		
		private var triangleGreenBM:Bitmap = new triangleGreenImage();
		
		private var triangleContainer:NSSprite = new NSSprite();
		
		/////////////////////////////
		
		public function TrafficLight(direction:String = DIRECTION_HORIZONTAL)
		{
			super();
			
			this.direction = direction;
			
			construct();
		}
		
		/////////////////////////////
		
		private function construct():void
		{
			// position parts
			baseBM.x = -baseBM.width / 2;
			baseBM.y = -baseBM.height / 2;
			
			highlightedBaseBM.x = -highlightedBaseBM.width / 2;
			highlightedBaseBM.y = -highlightedBaseBM.height / 2;
			
			triangleGreenBM.x = -triangleGreenBM.width / 2;
			triangleGreenBM.y = -triangleGreenBM.height / 2;
			
			triangleYellowBM.x = -triangleYellowBM.width / 2;
			triangleYellowBM.y = -triangleYellowBM.height / 2;
			
			drawCurrentState();
		}
		
		public function toggle():void
		{
			state *= -1;
			
			drawCurrentState();
			updateGrid();
		}
		
		private function drawCurrentState():void
		{
			removeAllChildren();
			
			addChild(highlightedBaseBM);
			
			triangleContainer.removeAllChildren();
			triangleContainer.addChild(triangleYellowBM);
			
			addChild(triangleContainer);
			
			var rotationAngle:Number = 0;
			
			if (direction == DIRECTION_HORIZONTAL)
				rotationAngle = (state == 1) ? 0 : 180;
			else
				rotationAngle = (state == 1) ? -90 : 90;
			
			triangleContainer.rotation = rotationAngle;
			
			AnimationEngine.globalAnimator.stopExecutingFunctionByID("removeHighlight" + this.uniqueKey);
			AnimationEngine.globalAnimator.executeFunction(removeHighlight, null, AnimationEngine.globalAnimator.currentTime + 1000, "removeHighlight" + this.uniqueKey);
		}
		
		private function removeHighlight():void
		{
			removeAllChildren();
			
			addChild(baseBM);
			
			triangleContainer.removeAllChildren();
			triangleContainer.addChild(triangleGreenBM);
			
			addChild(triangleContainer);
		}
		
		public function applyToGrid():void
		{
			updateGrid();
		}
		
		private function updateGrid():void
		{
			if (!grid)
				new Error("No grid found for traffic light");
			
			var location:Location = grid.getElement(this.x, this.y);
			var locationToChange:Location = null;
			
			if (direction == DIRECTION_HORIZONTAL)
			{
				// open one
				locationToChange = grid.getElementAtIndex(location.indexX + state, location.indexY);
				locationToChange.id = LocationConstants.EMPTY;
				locationToChange.filter = MapConstants.LOCATION_EMPTY_FILTER;
				
				// and close the other
				locationToChange = grid.getElementAtIndex(location.indexX - state, location.indexY);
				locationToChange.id = LocationConstants.OBSTACLE;
				locationToChange.filter = MapConstants.LOCATION_ULTIMATE_OBSTACLE_FILTER;
			}
			else
			{
				// open one
				locationToChange = grid.getElementAtIndex(location.indexX, location.indexY - state);
				locationToChange.id = LocationConstants.EMPTY;
				locationToChange.filter = MapConstants.LOCATION_EMPTY_FILTER;
				
				// and close the other
				locationToChange = grid.getElementAtIndex(location.indexX, location.indexY + state);
				locationToChange.id = LocationConstants.OBSTACLE;
				locationToChange.filter = MapConstants.LOCATION_ULTIMATE_OBSTACLE_FILTER;
			}
		}
	}

}