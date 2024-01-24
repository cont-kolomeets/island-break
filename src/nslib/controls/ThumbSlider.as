/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import nslib.controls.events.SliderEvent;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ThumbSlider extends SliderRange
	{
		/////////////
		
		public var trackButton:Button = new Button();
		
		public var thumbButton:Button = new Button();
		
		// flags
		
		private var isDragged:Boolean = false;
		
		/////////////
		
		public function ThumbSlider()
		{
			constructSlider();
		}
		
		//////////////
		
		private var _sliderWidth:Number = 100;
		
		public function get sliderWidth():Number
		{
			return _sliderWidth;
		}
		
		public function set sliderWidth(value:Number):void
		{
			_sliderWidth = value;
			refreshButton();
		}
		
		/////////////
		
		private var _enabled:Boolean = true;
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			thumbButton.enabled = value;
			trackButton.enabled = value;
		}
		
		///////////
		
		override public function set value(newValue:Number):void
		{
			super.value = newValue;
			refreshButton();
			dispatchEvent(new SliderEvent(SliderEvent.VALUE_CHANGED, newValue, false));
		}
		
		//////////
		
		// correction snap interval
		
		override public function set snapInterval(value:Number):void
		{
			var nSnaps:Number = Math.round((maximum - minimum) / value);
			var ratio:Number = (maximum - minimum) / (nSnaps * value);
			
			super.snapInterval = value / ratio;
		}
		
		//////////
		
		private var _trackSkin:Shape = new Shape();
		
		private var trackSkinChanged:Boolean = false;
		
		public function get trackSkin():Shape
		{
			return _trackSkin;
		}
		
		public function set trackSkin(value:Shape):void
		{
			_trackSkin = value;
			trackSkinChanged = true;
			
			refreshButton();
		}
		
		/////////////
		
		private function constructSlider():void
		{
			trackButton.buttonMode = false;
			trackButton.mouseEnabled = false;
			trackButton.mouseChildren = false;
			
			/////////
			
			thumbButton.buttonMode = true;
			
			// setting default thumb image
			var thumbImage:Shape = new Shape();
			thumbImage.graphics.lineStyle(3, 0, 0.8);
			thumbImage.graphics.beginFill(0xAAAAAA, 1);
			thumbImage.graphics.drawRect(-15, -15, 30, 30);
			
			thumbButton.image = thumbImage;
			
			/////////
			
			thumbButton.addEventListener(MouseEvent.MOUSE_DOWN, thumbButton_mouseDownHandler);
			
			refreshButton();
			
			addChild(trackButton);
			addChild(thumbButton);
			
			if (stage)
				addListeners();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
		}
		
		/////////////
		
		private function addedToStageHandler(event:Event):void
		{
			addListeners();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeListeners();
		}
		
		private function addListeners():void
		{
			if (stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, true, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, true, 0, true);
			}
		}
		
		private function removeListeners():void
		{
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, true);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, true);
			}
		}
		
		/////////////
		
		protected function refreshButton():void
		{
			trackButton.width = sliderWidth;
			trackButton.height = 20;
			
			if (!trackSkinChanged)
			{
				trackSkin.graphics.clear();
				trackSkin.graphics.lineStyle(3, 0, 0.8);
				trackSkin.graphics.lineTo(_sliderWidth, 0);
			}
			
			trackButton.image = trackSkin;
			
			locateThumb();
		}
		
		//////////////
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			locateThumb();
		}
		
		private function locateThumb():void
		{
			thumbButton.x = value / (maximum - minimum) * sliderWidth;
		}
		
		private function changeValue():void
		{
			// value before verification
			var rawValue:Number = thumbButton.x * (maximum - minimum) / sliderWidth;
			
			if (snapInterval != 0)
			{
				// need to racalc the thumb position and value
				// gettting the closes value
				super.value = getClosestSnapValue(rawValue);
				
				locateThumb();
			}
			else
				super.value = rawValue;
			
			dispatchEvent(new SliderEvent(SliderEvent.VALUE_CHANGED, value, true));
		}
		
		private function getClosestSnapValue(value:Number):Number
		{
			return Math.round((value - minimum) / snapInterval) * snapInterval + minimum;
		}
		
		//////////////
		
		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			if (isDragged)
				dispatchEvent(new SliderEvent(SliderEvent.THUMB_RELEASED, value, true));
			
			isDragged = false;
		}
		
		private function stage_mouseMoveHandler(event:MouseEvent):void
		{
			var local:Point = globalToLocal(new Point(event.stageX - thumbButton.width / 2, event.stageY));
			
			if (isDragged)
			{
				thumbButton.x = Math.min(sliderWidth, Math.max(0, local.x));
				changeValue();
			}
		}
		
		private function thumbButton_mouseDownHandler(event:MouseEvent):void
		{
			isDragged = true;
		}
	
	}

}