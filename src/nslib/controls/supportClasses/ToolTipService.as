/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls.supportClasses
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import nslib.controls.NSSprite;
	import nslib.controls.ToolTipBase;
	import nslib.core.Globals;
	import nslib.utils.MouseUtil;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * ToolTipService provides methods to work with tooltips.
	 * To show tooltips you need to assign toolTipLayer.
	 */
	public class ToolTipService
	{
		public static var toolTipLayer:NSSprite;
		
		private static var toolTipsHash:Dictionary = new Dictionary();
		
		private static var activeToolTip:ToolTipBase = null;
		
		/**
		 * Shows a tooltip when a component is hovered by the mouse cursor.
		 * @param	component Component to associate with.
		 * @param	toolTipInfo ToolTipInfo.
		 * @param	toolTipClass Class.
		 * @param	followMouse Indicates whether a tooltip should strictly follow the mouse cursor when the component is hovered.
		 */
		public static function setToolTip(component:DisplayObject, toolTipInfo:ToolTipInfo, toolTipClass:Class, tryUpdate:Boolean = false):void
		{
			var toolTip:* = null;
			
			var info:ToolTipInfoObject = toolTipsHash[component];
			var canBeUpdated:Boolean = info && (info.isPermanent == false) && (getQualifiedClassName(info.toolTip) == getQualifiedClassName(toolTipClass));
			
			if (!canBeUpdated || !tryUpdate)
			{
				toolTip = new toolTipClass();
				
				if (!(toolTip is ToolTipBase))
					return;
				
				// remove all other tooltips
				if (toolTipsHash[component] != undefined)
					removeAllTooltipsForComponent(component);
			}
			else if (tryUpdate)
				toolTip = info.toolTip;
			
			// need to apply parameters to let the tooltip calculate its layout.
			ToolTipBase(toolTip).toolTipLayer = toolTipLayer;
			ToolTipBase(toolTip).sensitivityContainer = component;
			ToolTipBase(toolTip).toolTipInfo = toolTipInfo;
			
			component.addEventListener(MouseEvent.MOUSE_OVER, component_mouseOverHandler, false, 0, true);
			
			var param:ToolTipInfoObject = new ToolTipInfoObject();
			param.toolTip = toolTip;
			param.component = component;
			param.isPermanent = false;
			param.layer = toolTipLayer;
			toolTipsHash[component] = param;
		}
		
		private static function component_mouseOverHandler(event:MouseEvent):void
		{
			var toolTip:ToolTipBase = toolTipsHash[event.currentTarget].toolTip as ToolTipBase;
			
			clearToolTipLayer();
			
			if (toolTipLayer)
			{
				toolTip.positionRelativeToComponent();
				
				toolTipLayer.addChild(toolTip);
				activeToolTip = toolTip;
				Globals.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false);
				(event.currentTarget as NSSprite).addEventListener(Event.REMOVED_FROM_STAGE, component_removedFromStageHandler, false);
			}
		}
		
		private static function stage_mouseMoveHandler(event:MouseEvent):void
		{
			if (!activeToolTip)
				return;
			
			if (!MouseUtil.isMouseOver(activeToolTip.sensitivityContainer))
				removeActiveToolTipFromLayer();
		}
		
		private static function component_removedFromStageHandler(event:Event):void
		{
			if (!activeToolTip)
				return;
			
			removeActiveToolTipFromLayer();
		}
		
		private static function removeActiveToolTipFromLayer():void
		{
			if (toolTipLayer.contains(activeToolTip))
				toolTipLayer.removeChild(activeToolTip);
			
			Globals.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false);
			activeToolTip.sensitivityContainer.removeEventListener(Event.REMOVED_FROM_STAGE, component_removedFromStageHandler, false);
			
			activeToolTip = null;
		}
		
		private static function clearToolTipLayer():void
		{
			if (toolTipLayer)
				for each (var item:*in toolTipsHash)
					if (item is ToolTipInfoObject)
						if (!item.isPermanent && toolTipLayer.contains(item.toolTip))
							toolTipLayer.removeChild(item.toolTip);
		}
		
		////////////////////////////////
		
		/**
		 * Adds a tooltip waiting for a user's click either on the tooltip or an associated component.
		 * @param	component Component to associate tooltip with.
		 * @param	toolTipInfo ToolIipInfo.
		 * @param	toolTipClass Class of tooltip.
		 * @param   toolTipIsClickable If true, tooltip will be removed on click.
		 * @return Instance of tooltip created.
		 */
		public static function setTooltipWaitingForClick(component:DisplayObject, toolTipInfo:ToolTipInfo, toolTipClass:Class, customLayer:DisplayObjectContainer = null):ToolTipBase
		{
			var toolTip:* = new toolTipClass();
			
			if (!(toolTip is ToolTipBase))
				return null;
			
			// remove all other tooltips
			if (toolTipsHash[component] != undefined)
				removeAllTooltipsForComponent(component);
			
			ToolTipBase(toolTip).toolTipLayer = toolTipLayer;
			ToolTipBase(toolTip).sensitivityContainer = component;
			ToolTipBase(toolTip).toolTipInfo = toolTipInfo;
			
			component.addEventListener(MouseEvent.CLICK, component_clickHandler, true, 0, true);
			component.addEventListener(MouseEvent.CLICK, component_clickHandler, false, 0, true);
			component.addEventListener(Event.REMOVED_FROM_STAGE, componentForPermanentToolTip_removedFromStageHandler, false);
			
			var layerToAddTo:DisplayObjectContainer = customLayer ? customLayer : toolTipLayer;
			
			if (toolTipLayer)
			{
				toolTip.positionRelativeToComponent();
				layerToAddTo.addChild(toolTip);
			}
			
			var param:ToolTipInfoObject = new ToolTipInfoObject();
			param.toolTip = toolTip;
			param.layer = layerToAddTo;
			param.component = component;
			param.isPermanent = true;
			toolTipsHash[component] = param;
			
			return toolTip;
		}
		
		private static function component_clickHandler(event:MouseEvent):void
		{
			var info:ToolTipInfoObject = toolTipsHash[event.currentTarget];
			
			if (info)
				deleteTooltip(info.toolTip, info);
		}
		
		private static function componentForPermanentToolTip_removedFromStageHandler(event:Event):void
		{
			var info:ToolTipInfoObject = toolTipsHash[event.currentTarget];
			
			if (info)
				deleteTooltip(info.toolTip, info);
		}
		
		// removes the tooltip, all references, and listeners related to it completely
		private static function deleteTooltip(toolTip:ToolTipBase, params:ToolTipInfoObject):void
		{
			// removing all possible handlers
			toolTip.sensitivityContainer.removeEventListener(MouseEvent.CLICK, component_clickHandler, true);
			toolTip.sensitivityContainer.removeEventListener(MouseEvent.CLICK, component_clickHandler, false);
			toolTip.sensitivityContainer.removeEventListener(MouseEvent.MOUSE_OVER, component_mouseOverHandler, false);
			toolTip.sensitivityContainer.removeEventListener(Event.REMOVED_FROM_STAGE, componentForPermanentToolTip_removedFromStageHandler, false);
			
			if (params.layer.contains(toolTip))
				params.layer.removeChild(toolTip);
		}
		
		/////////////////////
		
		public static function removeAllTooltipsForComponent(component:DisplayObject):void
		{
			if (!component || toolTipsHash[component] == undefined)
				return;
			
			var info:ToolTipInfoObject = toolTipsHash[component];
			deleteTooltip(info.toolTip, info);
			
			delete toolTipsHash[component];
		}
		
		/////////////////////
		
		public static function getToolTipAssignedForComponent(component:DisplayObject):ToolTipBase
		{
			var info:ToolTipInfoObject = toolTipsHash[component];
			
			return info ? info.toolTip : null;
		}
	}

}
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import nslib.controls.ToolTipBase;

class ToolTipInfoObject
{
	public var toolTip:ToolTipBase;
	
	public var component:DisplayObject;
	
	public var followMouse:Boolean = false;
	
	public var isPermanent:Boolean = false;
	
	public var layer:DisplayObjectContainer = null;
}