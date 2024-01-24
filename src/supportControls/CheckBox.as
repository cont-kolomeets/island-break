/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.controls.ToggleButton;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class CheckBox extends NSSprite
	{
		public static const STATE_CHANGED:String = "stateChagned";
		
		////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/check box checked.png")]
		private static var checkedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/check box unchecked.png")]
		private static var uncheckedImage:Class;
		
		////////////
		
		private var check:ToggleButton = new ToggleButton();
		
		private var textField:CustomTextField = new CustomTextField();
		
		////////////
		
		public function CheckBox(label:String = null)
		{
			construct(label);
		}
		
		////////////
		
		public function set label(value:String):void
		{
			textField.text = value;
		}
		
		/////////
		
		public function set fontDescriptor(value:FontDescriptor):void
		{
			textField.fontDescriptor = value;
			
			// need to reassign text to refresh
			if (textField.text)
				textField.text = textField.text;
		}
		
		/////////
		
		public function get selected():Boolean
		{
			return !check.isUpState;
		}
		
		public function set selected(value:Boolean):void
		{
			if (value)
				check.setDown();
			else
				check.setUp();
		}
		
		////////////
		
		private function construct(label:String = null):void
		{
			mouseEnabled = true;
			buttonMode = true;
			textField.clickable = true;
			check.useManualToggle = false;
			
			ControlConfigurator.configureButton(check.upButton, uncheckedImage);
			ControlConfigurator.configureButton(check.downButton, checkedImage);
			
			check.upButton.refresh(true);
			check.downButton.refresh(true);
			
			check.x = 0;
			check.y = 0;
			addChild(check);
			
			textField.text = label;
			textField.x = check.upButton.width + 10;
			textField.y = 3;
			addChild(textField);
			
			if (stage)
				addListeners();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			addListeners();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeListeners();
		}
		
		private function addListeners():void
		{
			addEventListener(MouseEvent.CLICK, mouseClickHandler, false);
		}
		
		private function removeListeners():void
		{
			removeEventListener(MouseEvent.CLICK, mouseClickHandler, false);
		}
		
		/////////
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			check.toggle();
			dispatchEvent(new Event(STATE_CHANGED));
		}
	
	}

}