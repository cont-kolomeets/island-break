/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.interactableObjects
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class DrawableObject extends Sprite
	{
		public var lineColor:int = 0xAAAAAA;
		public var lineThickness:Number = 20;
		private var _mouseDown:Boolean = false;
		private var _startOver:Boolean = true;
		private var lineSprite:NSSprite = new NSSprite();
		
		public function DrawableObject()
		{
			super();
			this.addChild(lineSprite);
		}
		
		public function addMouseSensitivity():void
		{
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
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove_Handler);
		}
		
		public function removeMouseSensitivity():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, true);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove_Handler);
		}
		
		private function mouseDown_Handler(event:MouseEvent):void
		{
			_mouseDown = true;
			_startOver = true;
			
			lineSprite.graphics.lineStyle(lineThickness, lineColor);
			lineSprite.graphics.moveTo(event.stageX - this.x, event.stageY - this.y);
		}
		
		private function mouseUp_Handler(event:MouseEvent):void
		{
			_mouseDown = false;
		}
		
		private function mouseMove_Handler(event:MouseEvent):void
		{
			if (_mouseDown)
			{
				lineSprite.graphics.lineTo(event.stageX - this.x, event.stageY - this.y);
				lineSprite.graphics.moveTo(event.stageX - this.x, event.stageY - this.y);
			}
		}
		
		public function clearDrawing():void
		{
			lineSprite.graphics.clear();
		}
	
	}

}