/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.toolTips
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class InGameHintToolTip extends HintToolTip
	{
		
		public function InGameHintToolTip()
		{
			super(InGameHintToolTipContent);
			
			configureStyling();
		}
		
		private function configureStyling():void
		{
			tipCornerRadius = 2;
			tipFillColor = 0;
			tipFillAlpha = 0.9;
			tipStrokeColor = 0xFFFFFF;
			tipStrokeWeight = 2;
		}
	
	}

}