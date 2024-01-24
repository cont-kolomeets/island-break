/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import controllers.SoundController;
	import islandBreak.controllers.WeaponController;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import nslib.core.Globals;
	import nslib.utils.MouseUtil;
	import supportClasses.resources.SoundResources;
	import supportClasses.WeaponType;
	import weapons.base.IWeapon;
	import weapons.base.supportClasses.WeaponUtil;
	import weapons.base.Weapon;
	import weapons.repairCenter.RepairCenter;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class AdvancedTargetingVisualizer extends EventDispatcher
	{
		public static const SELECTION_FINISHED:String = "selectionFinished";
		
		//////////
		
		public var workingLayer:Shape = null;
		
		public var gameStage:GameStage = null;
		
		private var isRectSelectionMode:Boolean = false;
		
		private var startingPoint:Point = new Point();
		
		private var selectedItems:Array = [];
		
		private var currentRect:Rectangle = new Rectangle();
		
		private var lastTargetedEnemy:IWeapon = null;
		
		/////////////
		
		public function AdvancedTargetingVisualizer()
		{
		}
		
		/////////////
		
		private var _isSelecting:Boolean = false;
		
		public function get isSelecting():Boolean
		{
			return _isSelecting && isValidSelection();
		}
		
		/////////////
		
		public function startSelection():void
		{
			if (isSelecting)
				return;
			
			_isSelecting = true;
			isRectSelectionMode = true;
			startingPoint.x = MouseUtil.getCursorCoordinates().x;
			startingPoint.y = MouseUtil.getCursorCoordinates().y;
			resetCurrentRect();
			selectedItems.length = 0;
			lastTargetedEnemy = null;
			
			gameStage.addEventListener(MouseEvent.MOUSE_UP, gameStage_mouseUpHandler);
			gameStage.addEventListener(MouseEvent.MOUSE_MOVE, gameStage_mouseMoveHandler);
			
			Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		private function isValidSelection():Boolean
		{
			return currentRect.width > 50 || currentRect.height > 50;
		}
		
		public function getLastTargetedEnemy():IWeapon
		{
			return lastTargetedEnemy;
		}
		
		public function clearSelection():void
		{
			_isSelecting = false;
			selectedItems.length = 0;
			resetCurrentRect();
			workingLayer.graphics.clear();
			
			gameStage.removeEventListener(MouseEvent.MOUSE_DOWN, gameStage_mouseDownHandler);
			gameStage.removeEventListener(MouseEvent.MOUSE_UP, gameStage_mouseUpHandler);
			gameStage.removeEventListener(MouseEvent.MOUSE_MOVE, gameStage_mouseMoveHandler);
			
			Globals.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			
			dispatchEvent(new Event(SELECTION_FINISHED));
		}
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ESCAPE)
				clearSelection();
		}
		
		private function gameStage_mouseMoveHandler(event:MouseEvent):void
		{
			if (isRectSelectionMode)
			{
				workingLayer.graphics.clear();
				
				updateCurrentRect();
				
				workingLayer.graphics.lineStyle(1, 0x00FF00, 0.8);
				workingLayer.graphics.beginFill(0x00FF00, 0.3);
				workingLayer.graphics.drawRect(currentRect.x, currentRect.y, currentRect.width, currentRect.height);
			}
			else
				drawTargetLines();
		}
		
		private var enemyIsHovered:Boolean = false;
		
		public function notifyEnemyIsHovered(value:Boolean):void
		{
			enemyIsHovered = value;
		}
		
		private function drawTargetLines():void
		{
			workingLayer.graphics.clear();
			
			var curX:Number = MouseUtil.getCursorCoordinates().x;
			var curY:Number = MouseUtil.getCursorCoordinates().y;
			
			var size:Number = 4;
			var offset:Number = 10;
			
			// draw shadow
			workingLayer.graphics.lineStyle(2, 0, 0.3);
			drawTargetLinesWithParameters(curX + 2, curY + 2, size, offset);
			
			// draw lines
			workingLayer.graphics.lineStyle(2, enemyIsHovered ? 0xEC0000 : 0x00E600, 0.8);
			drawTargetLinesWithParameters(curX, curY, size, offset);
		}
		
		private function drawTargetLinesWithParameters(curX:Number, curY:Number, size:Number, offset:Number):void
		{
			workingLayer.graphics.moveTo(curX, curY - offset);
			workingLayer.graphics.lineTo(curX + size, curY - offset - size * 1.5);
			workingLayer.graphics.lineTo(curX - size, curY - offset - size * 1.5);
			workingLayer.graphics.lineTo(curX, curY - offset);
			
			workingLayer.graphics.moveTo(curX, curY + offset);
			workingLayer.graphics.lineTo(curX + size, curY + offset + size * 1.5);
			workingLayer.graphics.lineTo(curX - size, curY + offset + size * 1.5);
			workingLayer.graphics.lineTo(curX, curY + offset);
			
			workingLayer.graphics.moveTo(curX - offset, curY);
			workingLayer.graphics.lineTo(curX - offset - size * 1.5, curY - size);
			workingLayer.graphics.lineTo(curX - offset - size * 1.5, curY + size);
			workingLayer.graphics.lineTo(curX - offset, curY);
			
			workingLayer.graphics.moveTo(curX + offset, curY);
			workingLayer.graphics.lineTo(curX + offset + size * 1.5, curY - size);
			workingLayer.graphics.lineTo(curX + offset + size * 1.5, curY + size);
			workingLayer.graphics.lineTo(curX + offset, curY);
			
			for each (var item:Weapon in selectedItems)
			{
				workingLayer.graphics.moveTo(curX, curY);
				workingLayer.graphics.lineTo(item.x, item.y);
				workingLayer.graphics.drawCircle(item.x, item.y, 25);
			}
		}
		
		private function updateCurrentRect():void
		{
			var curX:Number = MouseUtil.getCursorCoordinates().x;
			var curY:Number = MouseUtil.getCursorCoordinates().y;
			
			currentRect.x = Math.min(startingPoint.x, curX);
			currentRect.y = Math.min(startingPoint.y, curY);
			
			currentRect.width = Math.abs(startingPoint.x - curX);
			currentRect.height = Math.abs(startingPoint.y - curY);
		}
		
		private function resetCurrentRect():void
		{
			currentRect.x = 0;
			currentRect.y = 0;
			currentRect.width = 0;
			currentRect.height = 0;
		}
		
		private function gameStage_mouseUpHandler(event:MouseEvent):void
		{
			if (!isValidSelection())
			{
				clearSelection();
				return;
			}
			
			isRectSelectionMode = false;
			
			var itemsToCheck:Array = WeaponController.instance.userUnits.source;
			
			for each (var item:IWeapon in itemsToCheck)
				if (item is Weapon && currentRect.contains(item.x, item.y))
					selectedItems.push(item);
			
			if (selectedItems.length > 0)
			{
				drawTargetLines();
				gameStage.removeEventListener(MouseEvent.MOUSE_UP, gameStage_mouseUpHandler);
				gameStage.addEventListener(MouseEvent.MOUSE_DOWN, gameStage_mouseDownHandler);
			}
			else
				clearSelection();
		}
		
		private function gameStage_mouseDownHandler(event:MouseEvent):void
		{
			// try assign items
			var itemUnderCursor:Weapon = WeaponUtil.tryFindItemOnLayerAt(event.stageX, event.stageY, gameStage.childrenLayer) as Weapon;
			
			if (itemUnderCursor && itemUnderCursor.currentInfo.weaponType == WeaponType.ENEMY)
			{
				for each (var userItem:Weapon in selectedItems)
					// if user item was not desroyed or removed from the game stage
					if (userItem.isActive && !(userItem is RepairCenter))
						userItem.preferredHitObject = itemUnderCursor;
				
				itemUnderCursor.indicatesAsPreferredTarget();
			}
			
			lastTargetedEnemy = itemUnderCursor;
			
			if (itemUnderCursor)
				SoundController.instance.playSound(SoundResources.SOUND_ACTIVE_ENEMY_SELECTION);
			
			clearSelection();
		}
	}
}