/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils 
{
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import nslib.utils.FontDescriptor;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class TextUtil 
	{
		
		// creates text line for specified parameters
		public static function generateTextLine(text:String, fontDescriptor:FontDescriptor = null, width:Number = NaN):TextLine
		{
			if (!fontDescriptor)
				fontDescriptor = new FontDescriptor();
			
			var textBlock:TextBlock = new TextBlock();
			var textElement:TextElement = new TextElement(text);
			
			// element format
			
			var elementFormat:ElementFormat = new ElementFormat();
			elementFormat.fontSize = fontDescriptor.fontSize;
			elementFormat.color = fontDescriptor.color;
			elementFormat.baselineShift = elementFormat.fontSize * 0.9;
			elementFormat.breakOpportunity = BreakOpportunity.AUTO;
			
			// font description
			var fontDescription:FontDescription = new FontDescription();
			fontDescription.fontWeight = (fontDescriptor.fontWeight == "bold") ? FontWeight.BOLD : FontWeight.NORMAL;
			fontDescription.fontPosture = (fontDescriptor.fontStyle == "italic") ? FontPosture.ITALIC : FontPosture.NORMAL;
			
			fontDescription.fontLookup = FontLookup.EMBEDDED_CFF;
			fontDescription.fontName = fontDescriptor.fontName;
			
			//////////////
			
			elementFormat.fontDescription = fontDescription;
			
			textElement.elementFormat = elementFormat;
			textBlock.content = textElement;
			
			return textBlock.createTextLine(null, (!isNaN(width) ? width : 1000000));
		}
		
	}

}