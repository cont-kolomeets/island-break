/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls.supportClasses 
{
	import nslib.utils.FontDescriptor;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * ToolTipSimpleContentDescriptor describes content of a tooltip.
	 */
	public class ToolTipSimpleContentDescriptor 
	{
		public var headerText:String;
		
		public var bodyTextsArray:Array;
		
		public var imagesArray:Array;
		
		public var headerFontDescriptor:FontDescriptor = null;
		
		public var bodyFontDescriptor:FontDescriptor = null;
		
		public function ToolTipSimpleContentDescriptor(headerText:String = null, bodyTextsArray:Array = null, imagesArray:Array = null, headerFontDescriptor:FontDescriptor = null, bodyFontDescriptor:FontDescriptor = null) 
		{
			this.headerText = headerText;
			this.bodyTextsArray = bodyTextsArray;
			this.imagesArray = imagesArray;
			this.headerFontDescriptor = headerFontDescriptor;
			this.bodyFontDescriptor = bodyFontDescriptor;
		}
		
	}

}