/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MouseUtil
	{
		private static var cursorCurrentPosition:Point = new Point(0, 0);
		
		public static function initialize(stage:Stage):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove_Handler);
			//stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
		}
		
		////////////////
		
		private static function mouseMove_Handler(event:MouseEvent):void
		{
			cursorCurrentPosition.x = event.stageX;
			cursorCurrentPosition.y = event.stageY;
		}
		
		private static function mouseDown_Handler(event:MouseEvent):void
		{
			//_isMouseDown = true;
		}
		
		private static function mouseUp_Handler(event:MouseEvent):void
		{
			//_isMouseDown = false;
		}
		
		//////////////////
		
		public static function getCursorCoordinates():Point
		{
			return cursorCurrentPosition;
		}
		
		//private static var _isMouseDown:Boolean = false;
		
		//public static function isMouseDown():Point
		//{
		//	return _isMouseDown;
		//}
		
		public static function isMouseOver(component:DisplayObject, shapeFlag:Boolean = false):Boolean
		{
			if (!component)
				return false;
			
			var point:Point = getCursorCoordinates();
			return component.hitTestPoint(point.x, point.y, shapeFlag);
		}
	}
}