/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.toolTips
{
	import constants.GamePlayConstants;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import nslib.controls.LayoutContainer;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.ToolTipBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * HintToolTip used to show little hints.
	 */
	public class HintToolTip extends ToolTipBase
	{
		private var appliedOffsetX:Number = 0;
		
		private var appliedOffsetY:Number = 0;
		
		/////////////////////////
		
		public function HintToolTip(contentClass:Class = null)
		{
			super(contentClass ? contentClass : HintToolTipContent);
		}
		
		////////////////////////////
		
		protected var tipFillColor:Number = 0xF1EF8B;
		
		protected var tipFillAlpha:Number = 1;
		
		protected var tipStrokeColor:Number = 0x613A01;
		
		protected var tipStrokeAlpha:Number = 1;
		
		protected var tipStrokeWeight:Number = 1;
		
		protected var tipCornerRadius:Number = 10;
		
		public function getContent():HintToolTipContent
		{
			return super.toolTipContent as HintToolTipContent;
		}
		
		override protected function drawToolTip():void
		{
			if (!toolTipInfo)
				return;
			
			graphics.clear();
			graphics.lineStyle(tipStrokeWeight, tipStrokeColor, tipStrokeAlpha);
			graphics.beginFill(tipFillColor, tipFillAlpha);
			
			switch (toolTipInfo.prefferablePosition)
			{
				case ToolTipInfo.POSITION_TOP: 
					drawTopState();
					break;
				case ToolTipInfo.POSITION_BOTTOM: 
					drawBottomState();
					break;
				case ToolTipInfo.POSITION_LEFT: 
					drawLeftState();
					break;
				case ToolTipInfo.POSITION_RIGHT: 
					drawRightState();
					break;
			}
		}
		
		private function drawTopState():void
		{
			graphics.moveTo(tipCornerRadius, 0);
			graphics.lineTo(toolTipContent.width - tipCornerRadius, 0);
			graphics.curveTo(toolTipContent.width, 0, toolTipContent.width, tipCornerRadius);
			graphics.lineTo(toolTipContent.width, toolTipContent.height - tipCornerRadius);
			graphics.curveTo(toolTipContent.width, toolTipContent.height, toolTipContent.width - tipCornerRadius, toolTipContent.height);
			graphics.lineTo(20 - appliedOffsetX, toolTipContent.height);
			graphics.lineTo(-toolTipInfo.bodyOffsetX + toolTipInfo.tipOffsetX, -toolTipInfo.bodyOffsetY + toolTipInfo.tipOffsetY);
			graphics.lineTo(10 - appliedOffsetX, toolTipContent.height);
			graphics.lineTo(tipCornerRadius, toolTipContent.height);
			graphics.curveTo(0, toolTipContent.height, 0, toolTipContent.height - tipCornerRadius);
			graphics.lineTo(0, tipCornerRadius);
			graphics.curveTo(0, 0, tipCornerRadius, 0);
			graphics.moveTo(0, 0);
		}
		
		private function drawBottomState():void
		{
			graphics.moveTo(tipCornerRadius, 0);
			graphics.lineTo(10 - appliedOffsetX, 0);
			graphics.lineTo(-toolTipInfo.bodyOffsetX + toolTipInfo.tipOffsetX, -toolTipInfo.bodyOffsetY + toolTipInfo.tipOffsetY);
			graphics.lineTo(20 - appliedOffsetX, 0);
			graphics.lineTo(toolTipContent.width - tipCornerRadius, 0);
			graphics.curveTo(toolTipContent.width, 0, toolTipContent.width, tipCornerRadius);
			graphics.lineTo(toolTipContent.width, toolTipContent.height - tipCornerRadius);
			graphics.curveTo(toolTipContent.width, toolTipContent.height, toolTipContent.width - tipCornerRadius, toolTipContent.height);
			graphics.lineTo(tipCornerRadius, toolTipContent.height);
			graphics.curveTo(0, toolTipContent.height, 0, toolTipContent.height - tipCornerRadius);
			graphics.lineTo(0, tipCornerRadius);
			graphics.curveTo(0, 0, tipCornerRadius, 0);
			graphics.moveTo(0, 0);
		}
		
		private function drawLeftState():void
		{
			graphics.moveTo(tipCornerRadius, 0);
			graphics.lineTo(toolTipContent.width - tipCornerRadius, 0);
			graphics.curveTo(toolTipContent.width, 0, toolTipContent.width, tipCornerRadius);
			graphics.lineTo(toolTipContent.width, toolTipContent.height / 2 - 5 - appliedOffsetY);
			graphics.lineTo(-toolTipInfo.bodyOffsetX + toolTipInfo.tipOffsetX, -toolTipInfo.bodyOffsetY + toolTipInfo.tipOffsetY);
			graphics.lineTo(toolTipContent.width, toolTipContent.height / 2 + 5 - appliedOffsetY);
			graphics.lineTo(toolTipContent.width, toolTipContent.height - tipCornerRadius);
			graphics.curveTo(toolTipContent.width, toolTipContent.height, toolTipContent.width - tipCornerRadius, toolTipContent.height);
			graphics.lineTo(tipCornerRadius, toolTipContent.height);
			graphics.curveTo(0, toolTipContent.height, 0, toolTipContent.height - tipCornerRadius);
			graphics.lineTo(0, tipCornerRadius);
			graphics.curveTo(0, 0, tipCornerRadius, 0);
			graphics.moveTo(0, 0);
		}
		
		private function drawRightState():void
		{
			graphics.moveTo(tipCornerRadius, 0);
			graphics.lineTo(toolTipContent.width - tipCornerRadius, 0);
			graphics.curveTo(toolTipContent.width, 0, toolTipContent.width, tipCornerRadius);
			graphics.lineTo(toolTipContent.width, toolTipContent.height - tipCornerRadius);
			graphics.curveTo(toolTipContent.width, toolTipContent.height, toolTipContent.width - tipCornerRadius, toolTipContent.height);
			graphics.lineTo(tipCornerRadius, toolTipContent.height);
			graphics.curveTo(0, toolTipContent.height, 0, toolTipContent.height - tipCornerRadius);
			graphics.lineTo(0, toolTipContent.height / 2 + 5 - appliedOffsetY);
			graphics.lineTo(-toolTipInfo.bodyOffsetX + toolTipInfo.tipOffsetX, -toolTipInfo.bodyOffsetY + toolTipInfo.tipOffsetY);
			graphics.lineTo(0, toolTipContent.height / 2 - 5 - appliedOffsetY);
			graphics.lineTo(0, tipCornerRadius);
			graphics.curveTo(0, 0, tipCornerRadius, 0);
			graphics.moveTo(0, 0);
		}
		
		////////////////////////////
		
		// positions the tooltip after assigning ToolTipInfo
		override protected function applySmartPositioning():void
		{
			if (!toolTipInfo.autoPositioning)
				return;
			
			// if the host is LayoutContainer it may not have initialized sizes
			// so we need to force it.
			if (host is LayoutContainer)
				LayoutContainer(host).refresh();
			
			//if (content is LayoutContainer)
			//	LayoutContainer(content).refresh(true, true);
			
			switch (toolTipInfo.prefferablePosition)
			{
				case ToolTipInfo.POSITION_TOP: 
					positionAtTop();
					break;
				case ToolTipInfo.POSITION_BOTTOM: 
					positionAtBottom();
					break;
				case ToolTipInfo.POSITION_LEFT: 
					positionAtLeft();
					break;
				case ToolTipInfo.POSITION_RIGHT: 
					positonAtRight();
					break;
			}
		}
		
		private function positionAtTop():void
		{
			var bounds:Rectangle = host.getBounds(host);
			var middleX:Number = bounds.x + bounds.width / 2;
			var middleY:Number = bounds.y + bounds.height / 2;
			
			toolTipInfo.bodyOffsetX = middleX - 10 + appliedOffsetX;
			toolTipInfo.bodyOffsetY = bounds.y - (toolTipContent.height + 20) + appliedOffsetY;
			toolTipInfo.tipOffsetX = middleX;
			toolTipInfo.tipOffsetY = bounds.y;
		}
		
		private function positionAtBottom():void
		{
			var bounds:Rectangle = host.getBounds(host);
			var middleX:Number = bounds.x + bounds.width / 2;
			var middleY:Number = bounds.y + bounds.height / 2;
			
			toolTipInfo.bodyOffsetX = middleX - 10 + appliedOffsetX;
			toolTipInfo.bodyOffsetY = bounds.y + bounds.height + 20 + appliedOffsetY;
			toolTipInfo.tipOffsetX = middleX;
			toolTipInfo.tipOffsetY = bounds.y + bounds.height;
		}
		
		private function positionAtLeft():void
		{
			var bounds:Rectangle = host.getBounds(host);
			var middleX:Number = bounds.x + bounds.width / 2;
			var middleY:Number = bounds.y + bounds.height / 2;
			
			toolTipInfo.bodyOffsetX = bounds.x - toolTipContent.width - 30 + appliedOffsetX;
			toolTipInfo.bodyOffsetY = middleY - toolTipContent.height / 2 + appliedOffsetY;
			toolTipInfo.tipOffsetX = bounds.x;
			toolTipInfo.tipOffsetY = middleY;
		}
		
		private function positonAtRight():void
		{
			var bounds:Rectangle = host.getBounds(host);
			var middleX:Number = bounds.x + bounds.width / 2;
			var middleY:Number = bounds.y + bounds.height / 2;
			
			toolTipInfo.bodyOffsetX = bounds.x + bounds.width + 30 + appliedOffsetX;
			toolTipInfo.bodyOffsetY = middleY - toolTipContent.height / 2 + appliedOffsetY;
			toolTipInfo.tipOffsetX = bounds.x + bounds.width;
			toolTipInfo.tipOffsetY = middleY;
		}
		
		/////////////////////
		
		// This method should be called to position a tooltip relative to its host.
		override public function positionRelativeToComponent():void
		{
			if (!toolTipLayer)
				return;
			
			performRelativePositioning();
			
			if (!toolTipInfo.autoPositioning)
				return;
			
			if (currentPositionIsValid())
				return;
			
			// try positions one by one
			if (tryPosition(ToolTipInfo.POSITION_TOP))
				return;
			else if (tryPosition(ToolTipInfo.POSITION_RIGHT))
				return;
			else if (tryPosition(ToolTipInfo.POSITION_BOTTOM))
				return;
			else if (tryPosition(ToolTipInfo.POSITION_LEFT))
				return;
		}
		
		/////////////////////
		
		private var offsetPossible:Boolean = false;
		
		private var requiredOffsetX:Number = 0;
		
		private var requiredOffsetY:Number = 0;
		
		private const TOLERANCE:Number = 5;
		
		private function currentPositionIsValid():Boolean
		{
			var globalPosition:Point = toolTipLayer.localToGlobal(new Point(x, y));
			
			var positionIsValid:Boolean = true;
			offsetPossible = true;
			requiredOffsetX = 0;
			requiredOffsetY = 0;
			
			// now we have the global position of tooltip
			// lets find the required offset
			var xOffsetRequired:Boolean = (globalPosition.x < -TOLERANCE || (globalPosition.x + toolTipContent.width - TOLERANCE) > GamePlayConstants.STAGE_WIDTH);
			
			if (xOffsetRequired)
			{
				positionIsValid = false;
				
				if (globalPosition.x < 0)
					requiredOffsetX = -globalPosition.x + 5;
				else
					requiredOffsetX = GamePlayConstants.STAGE_WIDTH - (globalPosition.x + toolTipContent.width) - 5;
				
				offsetPossible = (toolTipInfo.prefferablePosition != ToolTipInfo.POSITION_LEFT) && (toolTipInfo.prefferablePosition != ToolTipInfo.POSITION_RIGHT) && Boolean(Math.abs(requiredOffsetX) <= toolTipContent.width);
			}
			
			if (!offsetPossible)
			{
				requiredOffsetX = 0;
				requiredOffsetY = 0;
				return false;
			}
			
			var yOffsetRequired:Boolean = (globalPosition.y < -TOLERANCE || (globalPosition.y + toolTipContent.height - TOLERANCE) > GamePlayConstants.STAGE_HEIGHT);
			
			if (yOffsetRequired)
			{
				positionIsValid = false;
				
				if (globalPosition.y < 0)
					requiredOffsetY = -globalPosition.y + 5;
				else
					requiredOffsetY = GamePlayConstants.STAGE_HEIGHT - (globalPosition.y + toolTipContent.height) - 5;
				
				offsetPossible = (toolTipInfo.prefferablePosition != ToolTipInfo.POSITION_TOP) && (toolTipInfo.prefferablePosition != ToolTipInfo.POSITION_BOTTOM) && Boolean(Math.abs(requiredOffsetY) <= toolTipContent.height);
			}
			
			if (!offsetPossible)
			{
				requiredOffsetX = 0;
				requiredOffsetY = 0;
				return false;
			}
			
			return positionIsValid;
		}
		
		private function tryPosition(position:String):Boolean
		{
			// first iteration without offset
			appliedOffsetX = 0;
			appliedOffsetY = 0;
			setNewPrefferablePosition(position, true);
			performRelativePositioning();
			var result:Boolean = currentPositionIsValid();
			
			if (result)
				return true;
			
			if (offsetPossible)
			{
				// try apply offset
				appliedOffsetX = requiredOffsetX;
				appliedOffsetY = requiredOffsetY;
				setNewPrefferablePosition(position, true);
				performRelativePositioning();
				result = currentPositionIsValid();
			}
			
			return result;
		}
		
		private function performRelativePositioning():void
		{
			var hostLocation:Point = host.localToGlobal(new Point(toolTipInfo.bodyOffsetX, toolTipInfo.bodyOffsetY));
			var toolTipLocation:Point = toolTipLayer.globalToLocal(hostLocation);
			
			x = toolTipLocation.x;
			y = toolTipLocation.y;
		}
	}

}