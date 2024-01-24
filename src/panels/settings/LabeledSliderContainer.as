/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.settings
{
	import flash.display.Shape;
	import flash.events.Event;
	import nslib.controls.CustomTextField;
	import nslib.controls.events.SliderEvent;
	import nslib.controls.events.ToggleButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.controls.ThumbSlider;
	import nslib.controls.ToggleButton;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class LabeledSliderContainer extends NSSprite
	{
		public static const PARAMETERS_CHANGED:String = "parametersChanged";
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/thumb normal.png")]
		private static var thumbNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/thumb disabled.png")]
		private static var thumbDisabledImage:Class;
		
		//////////
		
		public var labelFunction:Function = null;
		
		private var nameField:CustomTextField = new CustomTextField();
		
		private var slider:ThumbSlider = new ThumbSlider();
		
		private var valueField:CustomTextField = new CustomTextField();
		
		private var switchButton:ToggleButton = new ToggleButton();
		
		///////////
		
		public function LabeledSliderContainer()
		{
			construct();
		}
		
		//////////
		
		public function set nameLabel(value:String):void
		{
			nameField.text = value;
		}
		
		////
		
		public function get sliderValue():Number
		{
			return slider.value;
		}
		
		public function set sliderValue(value:Number):void
		{
			slider.value = value;
		}
		
		////
		
		public function set snapInterval(value:Number):void
		{
			slider.snapInterval = value;
		}
		
		////
		
		public function set enabled(value:Boolean):void
		{
			slider.enabled = value;
		}
		
		////
		
		public function showSwitchButton(value:Boolean):void
		{
			switchButton.visible = value;
		}
		
		////
		
		public function get switchButtonUp():Boolean
		{
			return switchButton.isUpState;
		}
		
		public function set switchButtonUp(value:Boolean):void
		{
			if (value)
				switchButton.setUp();
			else
				switchButton.setDown();
		}
		
		//////////
		
		private function construct():void
		{
			nameField.fontDescriptor = new FontDescriptor(20, 0xF1DD25, FontResources.BOMBARD);
			valueField.fontDescriptor = new FontDescriptor(20, 0xF1DD25, FontResources.BOMBARD);
			
			nameField.x = 0;
			nameField.y = 10;
			
			ControlConfigurator.configureButton(slider.thumbButton, thumbNormalImage, null, null, thumbDisabledImage);
			slider.x = 120;
			slider.y = 10;
			slider.minimum = 0;
			slider.maximum = 1;
			slider.sliderWidth = 110;
			
			var track:Shape = new Shape();
			track.graphics.lineStyle(5, 0xFFFFFF, 0.5);
			track.graphics.moveTo(10, 5);
			track.graphics.lineTo(slider.width + 10, 5);
			
			slider.trackSkin = track;
			
			valueField.x = 260;
			valueField.y = 10;
			
			switchButton.x = 300;
			switchButton.y = 3;
			switchButton.useManualToggle = true;
			
			addChild(nameField);
			addChild(slider);
			addChild(valueField);
			addChild(switchButton);
			
			if (stage)
				addListeners();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
		}
		
		public function configureButton(imageUpState:*, imageDownState:*):void
		{
			ControlConfigurator.configureButton(switchButton.upButton, imageUpState);
			ControlConfigurator.configureButton(switchButton.downButton, imageDownState);
		}
		
		/////////
		
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
			slider.addEventListener(SliderEvent.VALUE_CHANGED, slider_valueChangedHandler);
			switchButton.addEventListener(ToggleButtonEvent.STATE_CHANGED, switchButton_stateChangedHandler);
		}
		
		private function removeListeners():void
		{
			slider.removeEventListener(SliderEvent.VALUE_CHANGED, slider_valueChangedHandler);
			switchButton.removeEventListener(ToggleButtonEvent.STATE_CHANGED, switchButton_stateChangedHandler);
		}
		
		private function slider_valueChangedHandler(event:SliderEvent):void
		{
			// updating the value field
			if (labelFunction == null)
				valueField.text = int(slider.value * 100) + "%";
			else
				valueField.text = labelFunction(slider.value);
				
			dispatchEvent(new Event(PARAMETERS_CHANGED));
		}
		
		private function switchButton_stateChangedHandler(event:ToggleButtonEvent):void
		{
			slider.enabled = switchButton.isUpState;
			valueField.alpha = switchButton.isUpState ? 1 : 0.4;
			dispatchEvent(new Event(PARAMETERS_CHANGED));
		}
	
	}

}