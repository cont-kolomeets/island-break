/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.designer
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import nslib.controls.events.ToggleButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.controls.ToggleButton;
	import nslib.core.Globals;
	import nslib.utils.MouseUtil;
	import nslib.utils.UIComponentUtil;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Designer extends NSSprite
	{
		private var controlPanel:DesignerControlPanel = new DesignerControlPanel();
		
		private var objectInfoPanel:ObjectInfoPanel = new ObjectInfoPanel();
		
		private var highlightAllScreen:Shape = new Shape();
		
		private var highlightSelectedScreen:Shape = new Shape();
		
		///////
		
		public function Designer()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			init();
		}
		
		private function init():void
		{
			construct();
		}
		
		///////
		
		private function construct():void
		{
			controlPanel.addMouseSensitivity();
			
			addChild(highlightAllScreen);
			addChild(highlightSelectedScreen);
			addChild(controlPanel);
			
			addListeners();
		}
		
		private function addListeners():void
		{
			controlPanel.showInfoButton.addEventListener(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION, showInfoButton_stateChangedHandler);
			
			stage.addEventListener(MouseEvent.CLICK, stage_clickHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		////////
		
		private function belongsToDesigner(object:DisplayObject):Boolean
		{
			return UIComponentUtil.isParent(object, this);
		}
		
		private function highLightAllObjectsOnStage():void
		{
			highlightAllScreen.graphics.clear();
			highlightAllScreen.graphics.lineStyle(1, 0x80FFFF, 0.5);
			
			var allChildren:Array = getAllFilteredChildren();
			
			for each (var child:DisplayObject in allChildren)
			{
				var rect:Rectangle = child.getBounds(stage);
				highlightAllScreen.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			}
		}
		
		private function getAllFilteredChildren():Array
		{
			var result:Array = [];
			
			var allChildren:Array = UIComponentUtil.getAllChildren(stage, true);
			
			for each (var child:DisplayObject in allChildren)
				if (!belongsToDesigner(child) && child != Globals.topLevelApplication)
					result.push(child);
			
			return result;
		}
		
		////////
		
		private function showInfoButton_stateChangedHandler(event:ToggleButtonEvent):void
		{
			if (!controlPanel.showInfoButton.isUpState)
				highLightAllObjectsOnStage();
			else
				highlightAllScreen.graphics.clear();
		}
		
		private const MOVE:String = "move";
		private const SCALE:String = "scale";
		private const ALPHA:String = "alpha";
		private const ROTATE:String = "rotate";
		
		private var selectedCount:int = 0;
		
		private var selectedChild:DisplayObject = null;
		
		private var mode:String = MOVE;
		
		private var paramMemo:ObjectParam = new ObjectParam();
		
		private function stage_clickHandler(event:MouseEvent):void
		{
			resetSelection();
			
			if (MouseUtil.isMouseOver(controlPanel))
				return;
			
			selectObjectUnderCursor();
		}
		
		private function resetSelection():void
		{
			if (contains(objectInfoPanel))
				removeChild(objectInfoPanel);
			
			selectedChild = null;
		}
		
		private function selectObjectUnderCursor():void
		{
			var selectedChildren:Array = [];
			var allChildren:Array = getAllFilteredChildren();
			
			for each (var child:DisplayObject in allChildren)
				if (MouseUtil.isMouseOver(child))
					selectedChildren.push(child);
			
			if (selectedChildren.length)
			{
				highlightSelectedScreen.graphics.clear();
				highlightSelectedScreen.graphics.lineStyle(3, 0xFFFF00, 0.5);
				
				if (selectedCount >= selectedChildren.length)
					selectedCount = 0;
				
				selectedChild = selectedChildren[selectedCount];
				
				paramMemo.fromObject(selectedChild);
				selectedCount++;
				
				var rect:Rectangle = selectedChild.getBounds(stage);
				highlightSelectedScreen.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
				
				objectInfoPanel.showInfoForObject(selectedChild, mode);
				objectInfoPanel.x = MouseUtil.getCursorCoordinates().x - objectInfoPanel.width;
				objectInfoPanel.y = MouseUtil.getCursorCoordinates().y - objectInfoPanel.height;
				addChild(objectInfoPanel);
			}
		}
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.M)
				mode = MOVE;
			
			if (event.keyCode == Keyboard.S)
				mode = SCALE;
			
			if (event.keyCode == Keyboard.A)
				mode = ALPHA;
			
			if (event.keyCode == Keyboard.R)
				mode = ROTATE;
			
			if (event.keyCode == Keyboard.C)
				selectObjectUnderCursor();
			
			if (!selectedChild)
				return;
			
			if (event.keyCode == Keyboard.DELETE)
				if (selectedChild.parent)
					selectedChild.parent.removeChild(selectedChild);
					
			if (event.keyCode == Keyboard.H)
				selectedChild.visible = false;
			
			if (event.keyCode == Keyboard.ESCAPE)
			{
				paramMemo.toObject(selectedChild);
				selectedChild.visible = true;
			}
			
			if (mode == MOVE)
			{
				if (event.keyCode == Keyboard.LEFT)
				{
					if (event.shiftKey)
						selectedChild.x -= 1;
					else
						selectedChild.x -= 5;
				}
				
				if (event.keyCode == Keyboard.RIGHT)
				{
					if (event.shiftKey)
						selectedChild.x += 1;
					else
						selectedChild.x += 5;
				}
				
				if (event.keyCode == Keyboard.UP)
				{
					if (event.shiftKey)
						selectedChild.y -= 1;
					else
						selectedChild.y -= 5;
				}
				
				if (event.keyCode == Keyboard.DOWN)
				{
					if (event.shiftKey)
						selectedChild.y += 1;
					else
						selectedChild.y += 5;
				}
			}
			else if (mode == SCALE)
			{
				if (event.keyCode == Keyboard.LEFT)
				{
					if (event.shiftKey)
						selectedChild.scaleX -= 0.01;
					else
						selectedChild.scaleX -= 0.05;
				}
				
				if (event.keyCode == Keyboard.RIGHT)
				{
					if (event.shiftKey)
						selectedChild.scaleX += 0.01;
					else
						selectedChild.scaleX += 0.05;
				}
				
				if (event.keyCode == Keyboard.UP)
				{
					if (event.shiftKey)
						selectedChild.scaleY += 0.01;
					else
						selectedChild.scaleY += 0.05;
				}
				
				if (event.keyCode == Keyboard.DOWN)
				{
					if (event.shiftKey)
						selectedChild.scaleY -= 0.01;
					else
						selectedChild.scaleY -= 0.05;
				}
			}
			else if (mode == ALPHA)
			{
				if (event.keyCode == Keyboard.UP)
				{
					if (event.shiftKey)
						selectedChild.alpha += 0.01;
					else
						selectedChild.alpha += 0.05;
				}
				
				if (event.keyCode == Keyboard.DOWN)
				{
					if (event.shiftKey)
						selectedChild.alpha -= 0.01;
					else
						selectedChild.alpha -= 0.05;
				}
			}
			else if (mode == ROTATE)
			{
				if (event.keyCode == Keyboard.UP)
				{
					if (event.shiftKey)
						selectedChild.rotation += 1;
					else
						selectedChild.rotation += 5;
				}
				
				if (event.keyCode == Keyboard.DOWN)
				{
					if (event.shiftKey)
						selectedChild.rotation -= 1;
					else
						selectedChild.rotation -= 5;
				}
			}
			
			if (selectedChild.scaleX < 0)
				selectedChild.scaleX = 0;
			
			if (selectedChild.scaleY < 0)
				selectedChild.scaleY = 0;
			
			if (selectedChild.alpha < 0)
				selectedChild.alpha = 0;
			
			if (selectedChild.alpha > 1)
				selectedChild.alpha = 1;
			
			objectInfoPanel.showInfoForObject(selectedChild, mode);
		}
	}

}