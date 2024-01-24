/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.designer 
{
	import nslib.controls.CustomTextField;
	import nslib.controls.LayoutContainer;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.LayoutConstants;
	import nslib.controls.ToggleButton;
	import nslib.interactableObjects.MovableObject;
	import nslib.utils.FontDescriptor;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class DesignerControlPanel extends MovableObject 
	{		
		private var title:CustomTextField = new CustomTextField("Designer", new FontDescriptor(15, 0));
		
		public var showInfoButton:ToggleButton = new ToggleButton("Info on", "Info off");
		
		public function DesignerControlPanel() 
		{
			construct();
		}
		
		/////////
		
		private function construct():void
		{
			var layout:LayoutContainer = new LayoutContainer();
			layout.layout = LayoutConstants.VERTICAL;
			
			addChild(layout);
			
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.beginFill(0xAAAAAA, 0.8);
			graphics.drawRect(0, 0, 100, 50);
			
			showInfoButton.useManualToggle = true;
			showInfoButton.buttonMode = true;
			showInfoButton.upButton.buttonMode = true;
			showInfoButton.downButton.buttonMode = true;
			
			layout.addChild(title);
			layout.addChild(showInfoButton);
		}
		
	}

}