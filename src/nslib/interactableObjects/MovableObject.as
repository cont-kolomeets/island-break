/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.interactableObjects
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nslib.controls.NSSprite;
	import nslib.interactableObjects.events.MoveEvent;
	import nslib.utils.MouseUtil;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class MovableObject extends NSSprite
	{
		public var snappingInterval:Number = 0;
		
		private var mouseDown:Boolean = false;
		
		private var attachedToCursor:Boolean = false;
		
		private var attachedToCenter:Boolean = false;
		
		public function MovableObject()
		{
			super();
			
			mouseEnabled = true;
		}
		
		////////////
		
		private var _interactionRectangle:Rectangle = null;
		
		public function get interactionRectangle():Rectangle
		{
			return _interactionRectangle;
		}
		
		public function set interactionRectangle(rect:Rectangle):void
		{
			_interactionRectangle = rect;
		}
		
		////////////
		
		private var _isBeingDraged:Boolean = false;
		
		public function get isBeingDraged():Boolean
		{
			return _isBeingDraged;
		}
		
		////////////
		
		public function addMouseSensitivity():void
		{
			if (interactionRectangle)
			{
				graphics.clear();
				graphics.beginFill(0, 0.01);
				graphics.drawRect(interactionRectangle.x, interactionRectangle.y, interactionRectangle.width, interactionRectangle.height);
			}
			
			if (stage)
				addListeners();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
		}
		
		private function addedToStageListener(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			addListeners();
		}
		
		private function addListeners():void
		{
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler, false, 0, true);
			
			if (attachedToCursor)
				addMouseMovementHandlers();
		}
		
		public function removeMouseSensitivity():void
		{
			// clear and interaction rectangle
			if(interactionRectangle)
				graphics.clear();
			
			releaseMouse();
			
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
		}
		
		public function releaseMouse():void
		{
			mouseDown = false;
			removeMouseMovementHandlers();
		}
		
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		
		///////// handlers
		
		private function addMouseMovementHandlers():void
		{
			_isBeingDraged = true;
			
			if (stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, true, 0, true);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove_Handler, false, 0, true);
			}
			
			addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, false, 0, true);
		}
		
		private function removeMouseMovementHandlers():void
		{
			_isBeingDraged = false;
			
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, true);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove_Handler);
			}
			
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, false);
		}
		
		private function mouseDown_Handler(event:MouseEvent):void
		{
			// add handlers
			addMouseMovementHandlers();
			
			// configure parameters
			
			mouseDown = true;
			
			var locPoint:Point = this.globalToLocal(new Point(event.stageX, event.stageY))
			offsetX = -locPoint.x;
			offsetY = -locPoint.y;
			
			this.x = event.stageX + offsetX;
			this.y = event.stageY + offsetY;
			performSnapping();
		}
		
		private function mouseUp_Handler(event:MouseEvent):void
		{
			releaseMouse();
		}
		
		public function forceDetatchFromMouse():void
		{
			releaseMouse();
		}
		
		private function mouseMove_Handler(event:MouseEvent):void
		{
			if (attachedToCursor)
			{
				this.x = event.stageX;
				this.y = event.stageY;
				
				if (attachedToCenter)
				{
					this.x -= width / 2;
					this.y -= height / 2;
				}
				
				if (hasEventListener(MoveEvent.MOVED))
					dispatchEvent(new MoveEvent(MoveEvent.MOVED, event.stageX, event.stageY));
				return;
			}
			
			if (mouseDown)
			{
				this.x = event.stageX + offsetX;
				this.y = event.stageY + offsetY;
				
				if (hasEventListener(MoveEvent.MOVED))
					dispatchEvent(new MoveEvent(MoveEvent.MOVED, event.stageX, event.stageY));
				
				performSnapping();
			}
		}
		
		//////// operations with cursor
		
		public function attachToCursor(snapImmediatelly:Boolean = true, attachedToCenter:Boolean = false):void
		{
			this.attachedToCenter = attachedToCenter;
			attachedToCursor = true;
			
			addMouseMovementHandlers();
			
			if (snapImmediatelly)
				snapToCursor();
		}
		
		public function snapToCursor():void
		{
			var point:Point = MouseUtil.getCursorCoordinates();
			this.x = point.x;
			this.y = point.y;
		}
		
		public function detachFromCursor():void
		{
			attachedToCursor = false;
			attachedToCenter = false;
			
			if (!mouseDown)
				removeMouseMovementHandlers();
		}
		
		private function performSnapping():void
		{
			if (snappingInterval == 0)
				return;
			
			x = snappingInterval * NSMath.round(x / snappingInterval);
			y = snappingInterval * NSMath.round(y / snappingInterval);
		}
	
	}

}