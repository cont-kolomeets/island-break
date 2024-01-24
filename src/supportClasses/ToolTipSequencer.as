/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.core.Globals;
	import nslib.utils.MouseUtil;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ToolTipSequencer
	{
		private var toolTips:Array = [];
		
		private var components:Array = [];
		
		private var clickRects:Array = [];
		
		private var currentStep:int = 0;
		
		private var registeredStep:int = 0;
		
		private var stepFunctions:Object = {};
		
		public function ToolTipSequencer()
		{
		
		}
		
		public function clearSequence():void
		{
			for each (var toolTip:*in toolTips)
				AnimationEngine.globalAnimator.stopAnimationForObject(toolTip);
			
			for each (var component:NSSprite in components)
				ToolTipService.removeAllTooltipsForComponent(component);
			
			currentStep = 0;
			registeredStep = 0;
			toolTips.length = 0;
			components.length = 0;
			clickRects.length = 0;
			stepFunctions = {};
			
			Globals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_DOWN, tryCompleteCurrentStep);
			Globals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_UP, callNextStep);
		}
		
		public function registerStep(component:NSSprite, clickRect:Rectangle, info:ToolTipInfo, clazz:Class, layer:DisplayObjectContainer = null, addWaving:Boolean = true):void
		{
			var stepFunction:Function = function():void
			{
				var tooltip:* = ToolTipService.setTooltipWaitingForClick(component, info, clazz, layer);
				
				if (addWaving)
					AnimationEngine.globalAnimator.animateConstantWaving([tooltip], 300, AnimationEngine.globalAnimator.currentTime, 0.02);
				
				toolTips.push(tooltip);
			}
			
			components.push(component);
			clickRects.push(clickRect);
			
			//Globals.toolTipLayer.graphics.lineStyle(2, 0xFF0000);
			//Globals.toolTipLayer.graphics.drawRect(clickRect.x, clickRect.y, clickRect.width, clickRect.height);
			
			if (registeredStep == 0)
				stepFunction();
			else
				stepFunctions["" + registeredStep] = stepFunction;
			
			registeredStep++;
			
			Globals.topLevelApplication.addEventListener(MouseEvent.MOUSE_DOWN, tryCompleteCurrentStep);
		}
		
		private function tryCompleteCurrentStep(event:MouseEvent):void
		{
			// check if is over the current component
			var currentComponent:NSSprite = components[currentStep];
			
			if (Rectangle(clickRects[currentStep]).contains(MouseUtil.getCursorCoordinates().x, MouseUtil.getCursorCoordinates().y))
			{
				// clear the prev tooltip
				var toolTip:* = ToolTipService.getToolTipAssignedForComponent(currentComponent);
				if (toolTip)
					AnimationEngine.globalAnimator.stopAnimationForObject(toolTip);
				
				ToolTipService.removeAllTooltipsForComponent(currentComponent);
				
				// start next step on mouse up
				Globals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_DOWN, tryCompleteCurrentStep);
				Globals.topLevelApplication.addEventListener(MouseEvent.MOUSE_UP, callNextStep);
			}
		}
		
		public function completeCurrentStepAndGoToNextOne():void
		{
			var currentComponent:NSSprite = components[currentStep];
			
			// clear the prev tooltip
			var toolTip:* = ToolTipService.getToolTipAssignedForComponent(currentComponent);
			if (toolTip)
				AnimationEngine.globalAnimator.stopAnimationForObject(toolTip);
			
			ToolTipService.removeAllTooltipsForComponent(currentComponent);
			
			callNextStep(null);
		}
		
		private function callNextStep(event:MouseEvent):void
		{
			Globals.topLevelApplication.removeEventListener(MouseEvent.MOUSE_UP, callNextStep);
			Globals.topLevelApplication.addEventListener(MouseEvent.MOUSE_DOWN, tryCompleteCurrentStep);
			
			// start the next one
			currentStep++;
			
			if (currentStep == registeredStep)
				clearSequence();
			else
			{
				var stepFunction:Function = stepFunctions["" + currentStep];
				stepFunction();
			}
		}
		
		public function getComponentForCurrentStep():DisplayObject
		{
			return components[currentStep];
		}
	
	}

}