/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses
{
	import nslib.controls.Button;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * ControlConfigurator provides some util methods for faster configuring some controls.
	 */
	public class ControlConfigurator
	{
		public static function configureButton(button:Button, imageNormal:*, imageOver:* = null, imageDown:* = null, imageDisabled:* = null):void
		{
			button.buttonMode = true;
			button.image = imageNormal;
			button.imageOver = imageOver;
			button.imageDown = imageDown;
			button.imageDisabled = imageDisabled;
		}
	}

}