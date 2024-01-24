/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import nslib.controls.NSSprite;
	import nslib.core.Globals;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class PopUpUtil
	{
		private static var modalScreen:NSSprite;
		
		private static var containerToUse:DisplayObjectContainer = null;
		
		private static var poppedObjects:Array = null;
		
		public static function addPopUp(object:DisplayObject, center:Boolean = true, modal:Boolean = true, modalScreenOpacity:Number = 0.5):void
		{
			if (!containerToUse)
				containerToUse = Globals.stage;
			
			if (!containerToUse)
				return;
			
			if (!poppedObjects)
				poppedObjects = [];
			
			poppedObjects.push(object);
			
			var width:Number = Globals.stage.stageWidth;
			var height:Number = Globals.stage.stageHeight;
			
			if (modal)
			{
				if (!modalScreen)
				{
					modalScreen = new NSSprite();
					modalScreen.graphics.beginFill(0, modalScreenOpacity);
					modalScreen.graphics.drawRect(0, 0, width, height);
					
					modalScreen.mouseEnabled = true;
					
					containerToUse.addEventListener(MouseEvent.CLICK, containerToUse_mouseClickHandler, true);
					containerToUse.addChild(modalScreen);
				}
			}
			
			if (center)
				AlignUtil.centerWithinBounds(object, width, height);
			
			containerToUse.addChild(object);
		}
		
		private static function containerToUse_mouseClickHandler(event:MouseEvent):void
		{
			containerToUse.removeEventListener(MouseEvent.CLICK, containerToUse_mouseClickHandler, true);
			
			for each (var object:DisplayObject in poppedObjects)
				if (containerToUse.contains(object))
					containerToUse.removeChild(object);
			
			if (containerToUse.contains(modalScreen))
				containerToUse.removeChild(modalScreen);
			
			modalScreen = null;
			poppedObjects = null;
		}
		
		public static function removePopUp(object:DisplayObject):void
		{
			if (!containerToUse)
				return;
			
			if (containerToUse.contains(object))
				containerToUse.removeChild(object);
			
			poppedObjects = ArrayUtil.removeItem(poppedObjects, object);
			
			if (poppedObjects.length == 0 && modalScreen)
				containerToUse_mouseClickHandler(null);
		}
	
	}

}