/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame 
{
	import nslib.controls.ButtonBarButtonBase;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponSettingsPanelPreferenceMenuButton extends ButtonBarButtonBase
	{
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/preference panel gray.png")]
		private static var buttonUpImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/preference panel yellow.png")]
		private static var buttonDownImage:Class;
		
		//////////
		
		public function WeaponSettingsPanelPreferenceMenuButton()
		{
			super();
			construct();
		}
		
		//////////
		
		override protected function updateLabel():void 
		{
			labelField.fontDescriptor = new FontDescriptor(12, dataProviderObject.color ? dataProviderObject.color : 0xFFFFFF, FontResources.BOMBARD);
			labelField.text = label
			
			labelField.x = (button.upButton.width - labelField.width) / 2;
			labelField.y = (button.upButton.height - labelField.height) / 2 - 2;
		}
		
		////////
		
		private function construct():void
		{
			ControlConfigurator.configureButton(button.upButton, buttonUpImage);
			ControlConfigurator.configureButton(button.downButton, buttonDownImage);
			addChild(button);
			
			button.upButton.refresh(true);
			button.downButton.refresh(true);
			
			labelField.x = (button.upButton.width - labelField.width) / 2;
			labelField.y = 5;
			addChild(labelField);
		}
	}

}