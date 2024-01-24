/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls.skins 
{
	import nslib.controls.supportClasses.PositionConstants;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ButtonSkin extends NSSkin
	{
		public var cornerRadius:Number = 10;
		
		public var buttonStrokeColorUp:int = 0x555555;
		public var buttonStrokeColorDown:int = 0x555555;
		public var buttonStrokeColorOver:int = 0x555555;
		public var buttonStrokeColorDisabled:int = 0x555555;
		
		public var buttonStrokeWeightUp:int = 1;
		public var buttonStrokeWeightDown:int = 1;
		public var buttonStrokeWeightOver:int = 1;
		public var buttonStrokeWeightDisabled:int = 1;
		
		public var buttonStrokeAlphaUp:int = 1;
		public var buttonStrokeAlphaDown:int = 1;
		public var buttonStrokeAlphaOver:int = 1;
		public var buttonStrokeAlphaDisabled:int = 1;
		
		public var buttonBackgroundColorUp:int = 0x00FF00;
		public var buttonBackgroundColorDown:int = 0x00FF00;
		public var buttonBackgroundColorOver:int = 0x00FF00;
		public var buttonBackgroundColorDisabled:int = 0x8D8D8D;
		
		public var buttonBackgroundAlphaUp:Number = 1;
		public var buttonBackgroundAlphaDown:Number = 0.6;
		public var buttonBackgroundAlphaOver:Number = 0.8;
		public var buttonBackgroundAlphaDisabled:Number = 0.7;
		
		public var imagePosition:String = PositionConstants.LEFT;
		
		////////////////////////////////////////
		
		public function ButtonSkin() 
		{
			
		}
	}

}