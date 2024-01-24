/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import flash.events.Event;
	import mainPack.GameSettings;
	import nslib.controls.events.ToggleButtonEvent;
	import nslib.controls.LayoutContainer;
	import nslib.controls.supportClasses.BubbleService;
	import nslib.controls.ToggleButton;
	import supportClasses.ControlConfigurator;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SoundControlPanel extends LayoutContainer
	{
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/common images/sound buttons/button sound on.png")]
		private static var soundOnButtonImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/sound buttons/button sound off.png")]
		private static var soundOffButtonImage:Class;
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/common images/sound buttons/button music on.png")]
		private static var musicOnButtonImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/sound buttons/button music off.png")]
		private static var musicOffButtonImage:Class;
		
		///////////////
		
		private var musicButton:ToggleButton = new ToggleButton();
		
		private var soundButton:ToggleButton = new ToggleButton();
		
		////////////////
		
		public function SoundControlPanel()
		{
			construct();
		}
		
		////////////////
		
		public function get soundOn():Boolean
		{
			return soundButton.isUpState;
		}
		
		public function set soundOn(value:Boolean):void
		{
			if (value)
				soundButton.setUp()
			else
				soundButton.setDown();
		}
		
		////
		
		public function get musicOn():Boolean
		{
			return musicButton.isUpState;
		}
		
		public function set musicOn(value:Boolean):void
		{
			if (value)
				musicButton.setUp()
			else
				musicButton.setDown();
		}
		
		////////////////
		
		private function construct():void
		{
			ControlConfigurator.configureButton(musicButton.upButton, musicOnButtonImage);
			ControlConfigurator.configureButton(musicButton.downButton, musicOffButtonImage);
			musicButton.addEventListener(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION, button_stateChangedHandler, false, 0, true);
			musicButton.useManualToggle = true;
			
			ControlConfigurator.configureButton(soundButton.upButton, soundOnButtonImage);
			ControlConfigurator.configureButton(soundButton.downButton, soundOffButtonImage);
			soundButton.addEventListener(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION, button_stateChangedHandler, false, 0, true);
			soundButton.useManualToggle = true;
			
			addChild(soundButton);
			addChild(musicButton);
			
			BubbleService.applyBubbleOnMouseOver(musicButton, 1.03);
			BubbleService.applyBubbleOnMouseOver(soundButton, 1.03);
		}
		
		// syncronizes buttons with the game settings
		public function update():void
		{
			soundOn = GameSettings.soundOn;
			musicOn = GameSettings.musicOn;
		}
		
		private function button_stateChangedHandler(event:ToggleButtonEvent):void
		{
			updateSettings();
		}
		
		private function updateSettings():void
		{
			GameSettings.soundOn = soundOn;
			GameSettings.musicOn = musicOn;
			GameSettings.saveChagnes();
		}
	}

}