/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources
{
	import flash.text.engine.TextLine;
	import nslib.utils.TextUtil;
	import nslib.utils.FontDescriptor;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class FontResources
	{
		public static const YARDSALE:String = "YARDSALE";
		
		public static const JUNEGULL:String = "JUNEGULL";
		
		public static const KOMTXTB:String = "KOMTXTB";
		
		public static const BOMBARD:String = "BOMBARD";
		
		[Embed(source="F:/Island Defence/media/fonts/YARDSALE.TTF",fontName="YARDSALE")]
		private static var YARDSALE_FONT:Class;
		
		[Embed(source="F:/Island Defence/media/fonts/junegull.ttf",fontName="JUNEGULL")]
		private static var JUNEGULL_FONT:Class;
		
		[Embed(source="F:/Island Defence/media/fonts/KOMTXTB.ttf",fontName="KOMTXTB")]
		private static var KOMTXTB_FONT:Class;
		
		[Embed(source="F:/Island Defence/media/fonts/BOMBARD.otf",fontName="BOMBARD")]
		private static var BOMBARD_FONT:Class;
		
		// creates text line for specified parameters
		public static function generateTextLine(text:String, fontDescriptor:FontDescriptor = null, width:Number = NaN):TextLine
		{
			return TextUtil.generateTextLine(text, fontDescriptor, width);
		}
	
	}

}