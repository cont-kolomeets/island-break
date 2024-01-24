/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.settings
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import flash.display.StageQuality;
	import flash.events.Event;
	import mainPack.GameSettings;
	import nslib.animation.DeltaTime;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.core.Globals;
	import nslib.utils.FontDescriptor;
	import panels.PanelBase;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportControls.CheckBox;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SettingsPanel extends PanelBase
	{
		public static const RESUME_CLICKED:String = "resumeClicked";
		
		public static const TO_MENU_CLICKED:String = "toMenuClicked";
		
		public static const RESTART_CLICKED:String = "restartClicked";
		
		/////
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/frame.png")]
		private static var frameImage:Class;
		
		////
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/buttons/button resume normal.png")]
		private static var resumeButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/buttons/button resume over.png")]
		private static var resumeButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/buttons/button resume down.png")]
		private static var resumeButtonDownImage:Class;
		
		////
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/buttons/button quit normal.png")]
		private static var quitButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/buttons/button quit over.png")]
		private static var quitButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/buttons/button quit down.png")]
		private static var quitButtonDownImage:Class;
		
		////
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/buttons/button restart normal.png")]
		private static var restartButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/buttons/button restart over.png")]
		private static var restartButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/settings panel/buttons/button restart down.png")]
		private static var restartButtonDownImage:Class;
		
		//////
		
		[Embed(source="F:/Island Defence/media/images/common images/sound buttons/button sound on.png")]
		private static var soundOnButtonImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/sound buttons/button sound off.png")]
		private static var soundOffButtonImage:Class;
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/common images/sound buttons/button music on.png")]
		private static var musicOnButtonImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/sound buttons/button music off.png")]
		private static var musicOffButtonImage:Class;
		
		///////////
		
		private var frameHolder:NSSprite = new NSSprite();
		
		private var showToolTipsCheckBox:CheckBox = new CheckBox();
		
		private var enableAutoPauseCheckBox:CheckBox = new CheckBox();
		
		private var soundLevelControl:LabeledSliderContainer = new LabeledSliderContainer();
		
		private var musicLevelControl:LabeledSliderContainer = new LabeledSliderContainer();
		
		private var qualityLevelControl:LabeledSliderContainer = new LabeledSliderContainer();
		
		private var buttonResume:Button = new Button();
		
		private var buttonRestart:Button = new Button();
		
		private var buttonToMenu:Button = new Button();
		
		/// for local animation when everything else is paused
		
		private var ae:AnimationEngine = new AnimationEngine();
		
		private var deltaTimeCounter:DeltaTime;
		
		///////////
		
		public function SettingsPanel()
		{
			constructPanel();
		}
		
		///////////
		
		private function constructPanel():void
		{
			blockScreenFillAlpha = 0.7;
			enableBlockScreen = true;
			
			// adding the main frame
			frameHolder.addChild(new frameImage() as Bitmap);
			
			musicLevelControl.nameLabel = "Music Volume";
			musicLevelControl.configureButton(musicOnButtonImage, musicOffButtonImage);
			musicLevelControl.x = 70;
			musicLevelControl.y = 75;
			
			soundLevelControl.nameLabel = "Sound Volume";
			soundLevelControl.configureButton(soundOnButtonImage, soundOffButtonImage);
			soundLevelControl.x = 70;
			soundLevelControl.y = 115;
			
			qualityLevelControl.nameLabel = "Quality Level";
			qualityLevelControl.labelFunction = toQualityLocalized;
			qualityLevelControl.snapInterval = 0.33;
			qualityLevelControl.x = 70;
			qualityLevelControl.y = 155;
			
			showToolTipsCheckBox.fontDescriptor = new FontDescriptor(20, 0xF1DD25, FontResources.BOMBARD);
			showToolTipsCheckBox.label = "Show Tooltips";
			showToolTipsCheckBox.x = 70;
			showToolTipsCheckBox.y = 200;
			
			enableAutoPauseCheckBox.fontDescriptor = new FontDescriptor(20, 0xF1DD25, FontResources.BOMBARD);
			enableAutoPauseCheckBox.label = "Autopause";
			enableAutoPauseCheckBox.x = 240;
			enableAutoPauseCheckBox.y = 200;
			
			// configuring buttons
			ControlConfigurator.configureButton(buttonResume, resumeButtonNormalImage, resumeButtonOverImage, resumeButtonDownImage);
			ControlConfigurator.configureButton(buttonToMenu, quitButtonNormalImage, quitButtonOverImage, quitButtonDownImage);
			ControlConfigurator.configureButton(buttonRestart, restartButtonNormalImage, restartButtonOverImage, restartButtonDownImage);
			
			buttonResume.x = 127;
			buttonResume.y = 235;
			
			buttonToMenu.x = 127;
			buttonToMenu.y = 290;
			
			buttonRestart.x = 127;
			buttonRestart.y = 345;
			
			frameHolder.addChild(musicLevelControl);
			frameHolder.addChild(soundLevelControl);
			frameHolder.addChild(qualityLevelControl);
			frameHolder.addChild(showToolTipsCheckBox);
			frameHolder.addChild(enableAutoPauseCheckBox);
			frameHolder.addChild(buttonResume);
			frameHolder.addChild(buttonToMenu);
			frameHolder.addChild(buttonRestart);
			
			frameHolder.x = (GamePlayConstants.STAGE_WIDTH - frameHolder.width) / 2;
			
			addChild(frameHolder);
			
			/////////
			
			deltaTimeCounter = new DeltaTime(this);
			ae.customDeltaTimeCounter = deltaTimeCounter;
		}
		
		///////////
		
		override public function show():void
		{
			super.show();
			
			Globals.topLevelApplication.addChild(this);
			
			ae.moveObjects(frameHolder, frameHolder.x, -500, frameHolder.x, 50, 300, ae.currentTime);
			showBlockScreen();
			
			updateFromGameSettings();
			
			showToolTipsCheckBox.addEventListener(CheckBox.STATE_CHANGED, updateToggles);
			enableAutoPauseCheckBox.addEventListener(CheckBox.STATE_CHANGED, updateToggles);
			musicLevelControl.addEventListener(LabeledSliderContainer.PARAMETERS_CHANGED, updateMusicVolume);
			soundLevelControl.addEventListener(LabeledSliderContainer.PARAMETERS_CHANGED, updateSoundVolume);
			qualityLevelControl.addEventListener(LabeledSliderContainer.PARAMETERS_CHANGED, updateStageQuality);
			
			buttonResume.addEventListener(ButtonEvent.BUTTON_CLICK, buttonResume_clickHandler);
			buttonToMenu.addEventListener(ButtonEvent.BUTTON_CLICK, buttonToMenu_clickHandler);
			buttonRestart.addEventListener(ButtonEvent.BUTTON_CLICK, buttonRestart_clickHandler);
			
			GameTracker.api.customMsg(TrackingMessages.OPENED_SETTINGS_PANEL);
		}
		
		override public function hide():void
		{
			super.hide();
			
			Globals.topLevelApplication.removeChild(this);
			
			hideBlockScreen();
			
			GameSettings.saveChagnes();
			
			showToolTipsCheckBox.removeEventListener(CheckBox.STATE_CHANGED, updateToggles);
			enableAutoPauseCheckBox.removeEventListener(CheckBox.STATE_CHANGED, updateToggles);
			musicLevelControl.removeEventListener(LabeledSliderContainer.PARAMETERS_CHANGED, updateMusicVolume);
			soundLevelControl.removeEventListener(LabeledSliderContainer.PARAMETERS_CHANGED, updateSoundVolume);
			qualityLevelControl.removeEventListener(LabeledSliderContainer.PARAMETERS_CHANGED, updateStageQuality);
			
			buttonResume.removeEventListener(ButtonEvent.BUTTON_CLICK, buttonResume_clickHandler);
			buttonToMenu.removeEventListener(ButtonEvent.BUTTON_CLICK, buttonToMenu_clickHandler);
			buttonRestart.removeEventListener(ButtonEvent.BUTTON_CLICK, buttonRestart_clickHandler);
		}
		
		///////////
		
		private function updateFromGameSettings():void
		{
			showToolTipsCheckBox.selected = GameSettings.enableTooltips;
			enableAutoPauseCheckBox.selected = GameSettings.enableAutopause;
			
			musicLevelControl.switchButtonUp = GameSettings.musicOn;
			soundLevelControl.switchButtonUp = GameSettings.soundOn;
			
			musicLevelControl.sliderValue = GameSettings.musicLevel;
			soundLevelControl.sliderValue = GameSettings.soundLevel;
			qualityLevelControl.sliderValue = fromQuality(GameSettings.qualityLevel);
		}
		
		private function updateToggles(event:Event = null):void
		{
			GameSettings.enableTooltips = showToolTipsCheckBox.selected;
			GameSettings.enableAutopause = enableAutoPauseCheckBox.selected;
		}
		
		private function updateMusicVolume(event:Event = null):void
		{
			GameSettings.musicOn = musicLevelControl.switchButtonUp;
			GameSettings.musicLevel = musicLevelControl.sliderValue;
		}
		
		private function updateSoundVolume(event:Event = null):void
		{
			GameSettings.soundOn = soundLevelControl.switchButtonUp;
			GameSettings.soundLevel = soundLevelControl.sliderValue;
		}
		
		private function updateStageQuality(event:Event = null):void
		{
			GameSettings.qualityLevel = toQuality(qualityLevelControl.sliderValue);
		}
		
		///////////////
		
		private function fromQuality(quality:String):Number
		{
			switch (quality)
			{
				case StageQuality.BEST: 
					return 1;
				
				case StageQuality.HIGH: 
					return 0.66;
				
				case StageQuality.MEDIUM: 
					return 0.33;
				
				case StageQuality.LOW: 
					return 0;
			}
			
			return 0;
		}
		
		private function toQuality(value:Number):String
		{
			if (value < 0.2)
				return StageQuality.LOW;
			else if (value >= 0.2 && value < 0.5)
				return StageQuality.MEDIUM;
			else if (value >= 0.5 && value < 0.8)
				return StageQuality.HIGH;
			else
				return StageQuality.BEST;
		}
		
		private function toQualityLocalized(value:Number):String
		{
			if (value < 0.2)
				return "Low";
			else if (value >= 0.2 && value < 0.5)
				return "Medium";
			else if (value >= 0.5 && value < 0.8)
				return "High";
			else
				return "Best";
		}
		
		//////////////
		
		override protected function showBlockScreen():void
		{
			if (enableBlockScreen)
				addChildAt(blockScreen, 0);
		}
		
		override protected function hideBlockScreen():void
		{
			if (contains(blockScreen))
				removeChild(blockScreen);
		}
		
		///////////////
		
		private function buttonResume_clickHandler(event:ButtonEvent):void
		{
			hide();
			dispatchEvent(new Event(RESUME_CLICKED));
		}
		
		private function buttonToMenu_clickHandler(event:ButtonEvent):void
		{
			hide();
			dispatchEvent(new Event(TO_MENU_CLICKED));
		}
		
		private function buttonRestart_clickHandler(event:ButtonEvent):void
		{
			hide();
			dispatchEvent(new Event(RESTART_CLICKED));
		}
	}

}