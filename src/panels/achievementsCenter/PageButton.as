/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.achievementsCenter
{
	import nslib.controls.ButtonBarButtonBase;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PageButton extends ButtonBarButtonBase
	{
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/buttons/button up.png")]
		private static var buttonUpImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/buttons/button down.png")]
		private static var buttonDownImage:Class;
		
		//////////
		
		public function PageButton()
		{
			super();
			construct();
		}
		
		//////////
		
		override protected function updateLabel():void 
		{
			labelField.fontDescriptor = new FontDescriptor(30, 0xFFFFFF, FontResources.JUNEGULL);
			labelField.text = label;
			
			labelField.x = (button.upButton.width - labelField.width) / 2;
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