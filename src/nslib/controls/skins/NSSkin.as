/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls.skins 
{
	import nslib.controls.NSSprite;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class NSSkin 
	{
		protected var hostComponent:NSSprite;
		
		public function NSSkin() 
		{
			
		}
		
		public function setHostComponent(value:NSSprite):void
		{
			hostComponent = value;
		}
		
	}

}