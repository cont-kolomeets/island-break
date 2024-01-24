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
	public class TutorialToolTipContent extends HintToolTipContent 
	{
		
		public function TutorialToolTipContent() 
		{
			super();
			
			headerTextFontDescriptor = new FontDescriptor(14, 0, FontResources.KOMTXTB);
			header.textWidth = 140;
			header.paddingBottom = 2;
		}
		
	}

}