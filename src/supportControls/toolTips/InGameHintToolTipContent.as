/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.toolTips
{
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class InGameHintToolTipContent extends HintToolTipContent
	{
		
		public function InGameHintToolTipContent()
		{
			headerTextFontDescriptor = new FontDescriptor(14, 0xFFE840, FontResources.JUNEGULL);
			bodyTextFontDescriptor = new FontDescriptor(13, 0xFFFFFF, FontResources.BOMBARD);
			
			verticalGap = 8;
		}
	
	}

}