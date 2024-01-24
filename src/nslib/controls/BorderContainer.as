/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls 
{
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BorderContainer extends LayoutContainer 
	{
		
		public function BorderContainer() 
		{
		}
		
		////////////////////////////////
		
		private var _cornerRadius:Number = 0;
		private var _strokeColor:int = 0x555555;
		private var _strokeWeight:int = 1;
		private var _strokeAlpha:int = 1;
		private var _backgroundColor:int = 0x00FF00;
		private var _backgroundAlpha:Number = 0.5;
		private var _backgroundVisible:Boolean = true;
		
		public function get cornerRadius():Number
		{
			return _cornerRadius;
		}
		
		public function set cornerRadius(value:Number):void
		{
			_cornerRadius = value;
			invalidateProperties();
		}
		
		public function get strokeColor():int
		{
			return _strokeColor;
		}
		
		public function set strokeColor(value:int):void
		{
			_strokeColor = value;
			invalidateProperties();
		}
		
		public function get strokeWeight():int
		{
			return _strokeWeight;
		}
		
		public function set strokeWeight(value:int):void
		{
			_strokeWeight = value;
			invalidateProperties();
		}
		
		public function get strokeAlpha():int
		{
			return _strokeAlpha;
		}
		
		public function set strokeAlpha(value:int):void
		{
			_strokeAlpha = value;
			invalidateProperties();
		}
		
		public function get backgroundColor():int
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:int):void
		{
			_backgroundColor = value;
			invalidateProperties();
		}
		
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
			invalidateProperties();
		}
		
		public function get backgroundVisible():Boolean
		{
			return _backgroundVisible;
		}
		
		public function set backgroundVisible(value:Boolean):void
		{
			_backgroundVisible = value;
			invalidateProperties();
		}

		//////////////////////////
		
		override protected function updateLayout():void 
		{
			super.updateLayout();
			drawBackground();
		}
		
		override protected function commitProperties():void 
		{
			super.commitProperties();
			drawBackground();
		}
		
		private function drawBackground():void
		{
			graphics.clear();
			
			if (!backgroundVisible)
				return;
			
			graphics.lineStyle(strokeWeight, strokeColor, strokeAlpha);
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.drawRoundRect(0, 0, width, height, cornerRadius, cornerRadius);
		}
		
	}

}