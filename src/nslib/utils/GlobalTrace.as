/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils 
{
	import flash.display.Sprite;
	import nslib.controls.NSSprite;
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class GlobalTrace 
	{
		public static var field:GlobalTraceField;
		
		public static var mainApp:NSSprite;
		
		public static function traceText(text:*, color:int = 0xB91591):void
		{
			if (field)
				field.traceText(String(text), color);
		}
		
		public static function monitorProperty(obj:*, propName:String):void
		{
			if (field)
			{
				field.mainApp = mainApp;
				field.monitorProperty(obj, propName);
			}
		}
		
	}

}