/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nslib.controls.events.SliderEvent;
	import nslib.utils.ArrayList;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BarSlider extends NSSprite
	{		
		private var bars:ArrayList = new ArrayList();
		private var mouseIsDown:Boolean = false;
		
		///////////////////////////////////
		
		public function BarSlider()
		{
			super();
			
			constructSlider();
			
			if (stage)
				addListenersToStage();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//////////////////////////////////
		
		private var _value:Number = 0.5;
		private var _maximum:Number = 1;
		private var _minimum:Number = 0;
		
		private var _barsNumber:int = 5;
		private var _barWidth:Number = 10;
		private var _barMinHeight:Number = 10;
		private var _barMaxHeight:Number = 50;
		private var _gap:Number = 5;
		private var _selectedColor:Number = 0xFFFFFF;
		private var _deselectedColor:Number = 0x111111;
		private var _selectedAlpha:Number = 1;
		private var _deselectedAlpha:Number = 0.3;
				
		public function get barsNumber():int 
		{
			return _barsNumber;
		}
		
		public function set barsNumber(value:int):void 
		{
			_barsNumber = value;
			invalidateProperties();
		}
		
		public function get barWidth():Number 
		{
			return _barWidth;
		}
		
		public function set barWidth(value:Number):void 
		{
			_barWidth = value;
			invalidateProperties();
		}
		
		public function get barMinHeight():Number 
		{
			return _barMinHeight;
		}
		
		public function set barMinHeight(value:Number):void 
		{
			_barMinHeight = value;
			invalidateProperties();
		}
		
		public function get barMaxHeight():Number 
		{
			return _barMaxHeight;
		}
		
		public function set barMaxHeight(value:Number):void 
		{
			_barMaxHeight = value;
			invalidateProperties();
		}
		
		public function get gap():Number 
		{
			return _gap;
		}
		
		public function set gap(value:Number):void 
		{
			_gap = value;
			invalidateProperties();
		}
		
		public function get selectedColor():Number 
		{
			return _selectedColor;
		}
		
		public function set selectedColor(value:Number):void 
		{
			_selectedColor = value;
			invalidateProperties();
		}
		
		public function get deselectedColor():Number 
		{
			return _deselectedColor;
		}
		
		public function set deselectedColor(value:Number):void 
		{
			_deselectedColor = value;
			invalidateProperties();
		}
		
		public function get selectedAlpha():Number 
		{
			return _selectedAlpha;
		}
		
		public function set selectedAlpha(value:Number):void 
		{
			_selectedAlpha = value;
			invalidateProperties();
		}
		
		public function get deselectedAlpha():Number 
		{
			return _deselectedAlpha;
		}
		
		public function set deselectedAlpha(value:Number):void 
		{
			_deselectedAlpha = value;
			invalidateProperties();
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
			invalidateProperties();
		}
		
		public function get maximum():Number 
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void 
		{
			_maximum = value;
			invalidateProperties();
		}
		
		public function get minimum():Number 
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void 
		{
			_minimum = value;
			invalidateProperties();
		}
		
		//////////////////////////////////
		
		override protected function commitProperties():void 
		{
			super.commitProperties();
			refresh();
		}
		
		public function refresh():void
		{
			constructSlider();
		}
		
		private function constructSlider():void
		{
			removeBars();
			
			for (var i:int = 0; i < barsNumber; i++)
				addBar(i * (barWidth + gap), 0, (maximum - minimum) / Number(barsNumber - 1) * i);
			
			colorizeBars();
		}
		
		private function addBar(x:Number, y:Number, value:Number):void
		{
			var bar:NSSprite = new NSSprite();
			bar.name = "" + value;
			
			bar.x = x;
			bar.y = y;
			
			bar.addEventListener(MouseEvent.MOUSE_DOWN, bar_mouseDownHandler, false, 0, true);
			bar.addEventListener(MouseEvent.MOUSE_MOVE, bar_mouseMoveHandler, false, 0, true);
			
			bars.addItem(bar);
			
			addChild(bar);
		}
		
		private function removeBars():void
		{
			for each (var bar:NSSprite in bars.source)
			{
				if (contains(bar))
					removeChild(bar);
				
				bar.removeEventListener(MouseEvent.MOUSE_DOWN, bar_mouseDownHandler);
				bar.removeEventListener(MouseEvent.MOUSE_MOVE, bar_mouseMoveHandler);
			}
			
			bars.removeAll();
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addListenersToStage();
		}
		
		///////////////////////////////////////////////////////////////////////
		
		private function bar_mouseDownHandler(event:MouseEvent):void
		{
			value = Number(event.currentTarget.name);
			dispatchEvent(new SliderEvent(SliderEvent.VALUE_CHANGED, value));
			colorizeBars();
		}
		
		private function bar_mouseMoveHandler(event:MouseEvent):void
		{
			if (!mouseIsDown)
				return;
			
			value = Number(event.currentTarget.name);
			dispatchEvent(new SliderEvent(SliderEvent.VALUE_CHANGED, value));
			colorizeBars();
		}
		
		private function colorizeBars():void
		{
			for (var i:int = 0; i < bars.length; i++)
			{
				var bar:NSSprite = bars.getItemAt(i) as Sprite;
				
				bar.graphics.clear();
				
				if (Number(bar.name) <= value)
					bar.graphics.beginFill(selectedColor, selectedAlpha);
				else
					bar.graphics.beginFill(deselectedColor, deselectedAlpha);
				
				var barHeight:Number = barMinHeight + (barMaxHeight - barMinHeight) / Number(barsNumber - 1) * i;
				bar.graphics.drawRect(0, -barHeight, barWidth, barHeight);
				
				bar.graphics.beginFill(0, 0.01);
				bar.graphics.drawRect(barWidth, -barHeight, gap, barHeight);
			}
		}
		
		//////////////////////////////////////////////////////////////////////
		
		private function addListenersToStage():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler, true, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, true, 0, true);
		}
		
		private function stage_mouseDownHandler(event:MouseEvent):void
		{
			mouseIsDown = true;
		}
		
		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			mouseIsDown = false;
		}
	
	}

}