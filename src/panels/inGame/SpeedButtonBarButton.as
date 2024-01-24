/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame 
{
	import nslib.controls.ButtonBarButtonBase;
	import supportClasses.ControlConfigurator;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SpeedButtonBarButton extends ButtonBarButtonBase
	{
		/////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button speed up normal.png")]
		private static var buttonSpeedUpNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button speed up over.png")]
		private static var buttonSpeedUpOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button speed up down.png")]
		private static var buttonSpeedUpDownImage:Class;
		
		//////////
		
		public function SpeedButtonBarButton()
		{
			super();
			construct();
		}
		
		//////////
		
		override public function set buttonIndex(value:int):void 
		{
			super.buttonIndex = value;
			
			// let not the normal speed button stand out so much
			if (value == 0)
				ControlConfigurator.configureButton(button.downButton, buttonSpeedUpOverImage);
		}
		
		//////////
		
		override protected function updateLabel():void
		{
			labelField.fontDescriptor = null;
			labelField.text = null;
		}
		
		////////
		
		private function construct():void
		{
			ControlConfigurator.configureButton(button.upButton, buttonSpeedUpNormalImage, buttonSpeedUpOverImage);
			ControlConfigurator.configureButton(button.downButton, buttonSpeedUpDownImage);
			addChild(button);
			
			button.upButton.refresh(true);
			button.downButton.refresh(true);
		}
	}

}