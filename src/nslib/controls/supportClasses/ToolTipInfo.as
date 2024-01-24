/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls.supportClasses
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ToolTipInfo
	{
		public static const POSITION_TOP:String = "top";
		
		public static const POSITION_BOTTOM:String = "bottom";
		
		public static const POSITION_LEFT:String = "left";
		
		public static const POSITION_RIGHT:String = "right";
		
		////////////////////////////////////
		
		public var host:DisplayObject = null;
		
		public var contentDescriptor:Object = null;
		
		// if not specified, a tooltip is positioned automatically
		public var bodyOffsetX:Number = NaN;
		
		public var bodyOffsetY:Number = NaN;
		
		public var tipOffsetX:Number = NaN;
		
		public var tipOffsetY:Number = NaN;
		
		public var prefferablePosition:String = null;
		
		public var autoPositioning:Boolean = true;
		
		/////////////////////////////////////
		
		public function ToolTipInfo(host:DisplayObject = null, contentDescriptor:Object = null, prefferablePosition:String = POSITION_TOP, autoPositioning:Boolean = true, bodyOffsetX:Number = NaN, bodyOffsetY:Number = NaN, tipOffsetX:Number = NaN, tipOffsetY:Number = NaN)
		{
			this.host = host;
			this.contentDescriptor = contentDescriptor;
			this.prefferablePosition = prefferablePosition;
			this.bodyOffsetX = bodyOffsetX;
			this.bodyOffsetY = bodyOffsetY;
			this.tipOffsetX = tipOffsetX;
			this.tipOffsetY = tipOffsetY;
			this.autoPositioning = autoPositioning;
		}
	
	}

}