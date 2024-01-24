/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class AlignUtil
	{
		public static function centerSimple(object:DisplayObject, parent:DisplayObject, offsetX:Number = 0, offsetY:Number = 0):void
		{
			if (!object)
				return;
			
			object.x = ((parent ? parent.width : 0) - object.width) / 2 + offsetX;
			object.y = ((parent ? parent.height : 0) - object.height) / 2 + offsetY;
		}
		
		public static function centerWithinBounds(object:DisplayObject, width:Number, height:Number):void
		{
			if (!object)
				return;
			
			object.x = (width - object.width) / 2;
			object.y = (height - object.height) / 2;
		}
		
		public static function centerWidth(object:DisplayObject, parent:DisplayObject, offsetX:Number = 0):void
		{
			if (!object || !parent)
				return;
			
			object.x = (parent.width - object.width) / 2 + offsetX;
		}
		
		public static function centerHeight(object:DisplayObject, parent:DisplayObject, offsetY:Number = 0):void
		{
			if (!object || !parent)
				return;
			
			object.y = (parent.height - object.height) / 2 + offsetY;
		}
	
	}

}