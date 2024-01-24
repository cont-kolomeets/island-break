/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.statistics
{
	import flash.display.Shape;
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
		//////////
		
		public function PageButton()
		{
			super();
			construct();
		}
		
		//////////
		
		override protected function updateLabel():void
		{
			labelField.fontDescriptor = new FontDescriptor(13, 0, FontResources.BOMBARD);
			labelField.text = label;
			
			labelField.x = (button.upButton.width - labelField.width) / 2;
		}
		
		////////
		
		private function construct():void
		{
			var buttonUpImage:Shape = new Shape();
			buttonUpImage.graphics.lineStyle(2, 0);
			buttonUpImage.graphics.beginFill(0xDDDDDD);
			buttonUpImage.graphics.drawRoundRect(0, 0, 50, 25, 5, 5);
			
			var buttonDownImage:Shape = new Shape();
			buttonDownImage.graphics.lineStyle(2, 0);
			buttonDownImage.graphics.beginFill(0xCCCCCC);
			buttonDownImage.graphics.drawRoundRect(0, 0, 50, 25, 5, 5);
			
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