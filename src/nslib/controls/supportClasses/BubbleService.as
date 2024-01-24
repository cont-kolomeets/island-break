/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls.supportClasses
{
	import flash.events.MouseEvent;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BubbleService
	{
		private static var scalingInfoHash:Array = [];
		
		public static function applyBubbleOnMouseOver(component:NSSprite, scalingFactor:Number):void
		{
			component.addEventListener(MouseEvent.MOUSE_OVER, component_mouseOver1Handler, false, 0, true);
			component.addEventListener(MouseEvent.MOUSE_OUT, component_mouseOut1Handler, false, 0, true);
			
			var obj:Object = new Object();
			obj.scalingFactor = scalingFactor;
			obj.scaleX = component.scaleX;
			obj.scaleY = component.scaleY;
			obj.newScaleX = component.scaleX * scalingFactor;
			obj.newScaleY = component.scaleY * scalingFactor;
			
			scalingInfoHash[component.uniqueKey + "over"] = obj;
		}
		
		public static function removeBubbleOnMouseOver(component:NSSprite):void
		{
			component.removeEventListener(MouseEvent.MOUSE_OVER, component_mouseOver1Handler);
			component.removeEventListener(MouseEvent.MOUSE_OUT, component_mouseOut1Handler);
			
			delete scalingInfoHash[component.uniqueKey + "over"];
		}
		
		private static function component_mouseOver1Handler(event:MouseEvent):void
		{
			var component:NSSprite = event.currentTarget as NSSprite;
			
			component.scaleX = scalingInfoHash[component.uniqueKey + "over"].newScaleX;
			component.scaleY = scalingInfoHash[component.uniqueKey + "over"].newScaleY;
		}
		
		private static function component_mouseOut1Handler(event:MouseEvent):void
		{
			var component:NSSprite = event.currentTarget as NSSprite;
			
			component.scaleX = scalingInfoHash[component.uniqueKey + "over"].scaleX;
			component.scaleY = scalingInfoHash[component.uniqueKey + "over"].scaleY;
		}
		
		//////////////////////////////////
		
		public static function applyBubbleOnMouseClick(component:NSSprite, scalingFactor:Number):void
		{
			component.addEventListener(MouseEvent.MOUSE_DOWN, component_mouseDown2Handler, false, 0, true);
			component.addEventListener(MouseEvent.MOUSE_UP, component_mouseUp2Handler, false, 0, true);
			component.addEventListener(MouseEvent.MOUSE_OUT, component_mouseOut2Handler, false, 0, true);
			
			var obj:Object = new Object();
			obj.scalingFactor = scalingFactor;
			obj.scaleX = component.scaleX;
			obj.scaleY = component.scaleY;
			obj.newScaleX = component.scaleX * scalingFactor;
			obj.newScaleY = component.scaleY * scalingFactor;
			
			scalingInfoHash[component.uniqueKey + "down"] = obj;
		}
		
		public static function removeBubbleOnMouseClick(component:NSSprite):void
		{
			component.removeEventListener(MouseEvent.MOUSE_DOWN, component_mouseDown2Handler);
			component.removeEventListener(MouseEvent.MOUSE_UP, component_mouseUp2Handler);
			component.removeEventListener(MouseEvent.MOUSE_OUT, component_mouseOut2Handler);
			
			delete scalingInfoHash[component.uniqueKey + "down"];
		}
		
		private static function component_mouseDown2Handler(event:MouseEvent):void
		{
			var component:NSSprite = event.currentTarget as NSSprite;
			
			component.scaleX = scalingInfoHash[component.uniqueKey + "down"].newScaleX;
			component.scaleY = scalingInfoHash[component.uniqueKey + "down"].newScaleY;
		}
		
		private static function component_mouseOut2Handler(event:MouseEvent):void
		{
			var component:NSSprite = event.currentTarget as NSSprite;
			
			if (scalingInfoHash[component.uniqueKey + "over"])
			{
				component.scaleX = scalingInfoHash[component.uniqueKey + "over"].scaleX;
				component.scaleY = scalingInfoHash[component.uniqueKey + "over"].scaleY;
			}
			else
			{
				component.scaleX = scalingInfoHash[component.uniqueKey + "down"].scaleX;
				component.scaleY = scalingInfoHash[component.uniqueKey + "down"].scaleY;
			}
		}
		
		private static function component_mouseUp2Handler(event:MouseEvent):void
		{
			var component:NSSprite = event.currentTarget as NSSprite;
			
			if (scalingInfoHash[component.uniqueKey + "over"])
			{
				component.scaleX = scalingInfoHash[component.uniqueKey + "over"].newScaleX;
				component.scaleY = scalingInfoHash[component.uniqueKey + "over"].newScaleY;
			}
			else
			{
				component.scaleX = scalingInfoHash[component.uniqueKey + "down"].scaleX;
				component.scaleY = scalingInfoHash[component.uniqueKey + "down"].scaleY;
			}
		}
	
	}

}