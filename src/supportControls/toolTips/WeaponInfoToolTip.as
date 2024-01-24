/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.toolTips 
{
	import nslib.controls.ToolTipBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * InfoToolTip used to show detailed information about a unit.
	 */
	public class WeaponInfoToolTip extends HintToolTip 
	{
		
		public function WeaponInfoToolTip() 
		{
			super(WeaponInfoToolTipContent);
			
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