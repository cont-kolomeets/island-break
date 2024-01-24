/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.news 
{
	import nslib.utils.FontDescriptor;
	import panels.common.PaperWithTextBase;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class StickingPaper extends PaperWithTextBase 
	{
		public static const COLOR_RED:int = 0;
		
		public static const COLOR_BLUE:int = 1;
		
		///////
		
		[Embed(source="F:/Island Defence/media/images/panels/news/red paper.png")]
		private static var redPaperImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/news/blue paper.png")]
		private static var bluePaperImage:Class;
		
		///////
		
		public function StickingPaper() 
		{
			super();
			
			mouseEnabled = true;
			paperHeight = 60;
			autoCenter = false;
			fontDescriptor = new FontDescriptor(20, 0xFFFFFF, FontResources.YARDSALE);
		}
		
		///////
		
		public function set color(value:int):void
		{
			switch(value)
			{
				case COLOR_RED:
					imageClass = redPaperImage;
					break;
				case COLOR_BLUE:
					imageClass = bluePaperImage;
					break;
			}
		}
	}

}