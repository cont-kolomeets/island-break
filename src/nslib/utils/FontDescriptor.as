/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * FontDescriptor describes font properties.
	 */
	public class FontDescriptor
	{
		public var fontSize:int = 0;
		
		public var color:int = 0;
		
		public var fontStyle:String = null;
		
		public var fontName:String = null;
		
		public var fontWeight:String = null;
		
		public function FontDescriptor(fontSize:int = 20, color:int = 0, fontName:String = "none", fontWeight:String = "normal", fontStyle:String = "none")
		{
			this.fontSize = fontSize;
			this.color = color;
			this.fontName = fontName;
			this.fontWeight = fontWeight;
			this.fontStyle = fontStyle;
		}
		
		public function toTextFormat():TextFormat
		{
			var format:TextFormat = new TextFormat();
			format.font = fontName;
			format.color = color;
			format.size = fontSize;
			format.italic = fontStyle;
			format.bold = fontWeight;
			
			return format;
		}
		
		public function copy():FontDescriptor
		{
			return new FontDescriptor(fontSize, color, fontName, fontWeight, fontStyle);
		}
	
	}

}