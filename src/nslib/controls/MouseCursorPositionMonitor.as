/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import nslib.utils.MouseUtil;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MouseCursorPositionMonitor extends Sprite
	{
		public var relativeObject:DisplayObject = null;
		
		private var textField:TextField = new TextField();
		
		public function MouseCursorPositionMonitor()
		{
			addChild(textField);
			addEventListener(Event.ENTER_FRAME, frameListener, false, 0, true);
		}
		
		private var _color:int = 0;
		
		public function get color():int
		{
			return _color;
		}
		
		public function set color(value:int):void
		{
			_color = value;
			textField.textColor = value;
		}
		
		private function frameListener(event:Event):void
		{
			var point:Point = MouseUtil.getCursorCoordinates();
			
			var x:Number = relativeObject ? (point.x - relativeObject.x) : point.x;
			var y:Number = relativeObject ? (point.y - relativeObject.y) : point.y;
			
			textField.text = "x: " + int(x) + " y: " + int(y);
		}
	
	}

}