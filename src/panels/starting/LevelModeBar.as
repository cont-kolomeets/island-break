/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import infoObjects.gameInfo.LevelInfo;
	import mainPack.ModeSettings;
	import nslib.controls.events.ToggleButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.controls.ToggleButton;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportControls.toolTips.HintToolTip;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class LevelModeBar extends NSSprite
	{
		public static const MODE_CHANGED:String = "modeChanged";
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/normal mode enabled.png")]
		private static var normalModeEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/normal mode selected.png")]
		private static var normalModeSelectedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/hard mode enabled.png")]
		private static var hardModeEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/hard mode selected.png")]
		private static var hardModeSelectedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/hard mode disabled.png")]
		private static var hardModeDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/unreal mode enabled.png")]
		private static var unrealModeEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/unreal mode selected.png")]
		private static var unrealModeSelectedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/unreal mode disabled.png")]
		private static var unrealModeDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/ok icon.png")]
		private static var okImage:Class;
		
		//////////////
		
		private var normalButton:ToggleButton = new ToggleButton();
		private var hardButton:ToggleButton = new ToggleButton();
		private var unrealButton:ToggleButton = new ToggleButton();
		private var completedSignContainer:NSSprite = new NSSprite();
		
		///////////
		
		private var currentInfo:LevelInfo = null;
		
		///////////
		
		public function LevelModeBar()
		{
			construct();
		}
		
		//////////////
		
		private function construct():void
		{
			ControlConfigurator.configureButton(normalButton.upButton, normalModeEnabledImage);
			ControlConfigurator.configureButton(normalButton.downButton, normalModeSelectedImage);
			
			ControlConfigurator.configureButton(hardButton.upButton, hardModeEnabledImage);
			ControlConfigurator.configureButton(hardButton.downButton, hardModeSelectedImage);
			
			ControlConfigurator.configureButton(unrealButton.upButton, unrealModeEnabledImage);
			ControlConfigurator.configureButton(unrealButton.downButton, unrealModeSelectedImage);
			
			normalButton.x = 0;
			normalButton.y = 0;
			normalButton.useManualToggle = true;
			
			hardButton.x = 45;
			hardButton.y = 0;
			hardButton.useManualToggle = true;
			
			unrealButton.x = 90;
			unrealButton.y = 0;
			unrealButton.useManualToggle = true;
			
			addChild(normalButton);
			addChild(hardButton);
			addChild(unrealButton);
			addChild(completedSignContainer);
			
			resetToInitialState();
		}
		
		private function resetToInitialState():void
		{
			completedSignContainer.removeAllChildren();
			
			normalButton.setDown();
			
			hardButton.setUp();
			hardButton.upButton.image = hardModeDisabledImage;
			hardButton.upButton.buttonMode = false;
			
			unrealButton.setUp();
			unrealButton.upButton.image = unrealModeDisabledImage;
			unrealButton.upButton.buttonMode = false;
		}
		
		public function updateForLevelInfo(info:LevelInfo):void
		{
			currentInfo = info;
			
			resetToInitialState();
			
			if (info.starsEarned == 3)
			{
				addCompletedSignForButton(normalButton);
				hardButton.upButton.image = hardModeEnabledImage;
				hardButton.upButton.buttonMode = true;
			}
			
			if (info.hardModePassed)
			{
				addCompletedSignForButton(hardButton);
				unrealButton.upButton.image = unrealModeEnabledImage;
				unrealButton.upButton.buttonMode = true;
			}
			
			if (info.unrealModePassed)
				addCompletedSignForButton(unrealButton);
			
			if ((info.hardModePassed || info.unrealModePassed) && info.starsEarned != 3)
				throw new Error("Hard or Unreal mode enabled while 3 stars were not earned!");
			
			// normal mode
			if (info.starsEarned == 3)
				ToolTipService.setToolTip(normalButton, new ToolTipInfo(normalButton, new ToolTipSimpleContentDescriptor("Normal Mode", ["This mode is fully completed!"], null, new FontDescriptor(12, 0x0114FE, FontResources.YARDSALE)), ToolTipInfo.POSITION_BOTTOM), HintToolTip);
			else
				ToolTipService.setToolTip(normalButton, new ToolTipInfo(normalButton, new ToolTipSimpleContentDescriptor("Normal Mode", ["Complete this mode with 3 stars and unlock more challenging ones!"], null, new FontDescriptor(12, 0x0114FE, FontResources.YARDSALE)), ToolTipInfo.POSITION_BOTTOM), HintToolTip);
			
			// hard mode
			if (info.starsEarned == 3)
			{
				if (info.hardModePassed)
					ToolTipService.setToolTip(hardButton, new ToolTipInfo(hardButton, new ToolTipSimpleContentDescriptor("Hard Mode", ["This mode is fully completed!"], null, new FontDescriptor(12, 0xF13030, FontResources.YARDSALE)), ToolTipInfo.POSITION_BOTTOM), HintToolTip);
				else
					ToolTipService.setToolTip(hardButton, new ToolTipInfo(hardButton, new ToolTipSimpleContentDescriptor("Hard Mode", ["Try to withstand much harder attack!"], null, new FontDescriptor(12, 0xF13030, FontResources.YARDSALE)), ToolTipInfo.POSITION_BOTTOM), HintToolTip);
			}
			else
				ToolTipService.setToolTip(hardButton, new ToolTipInfo(hardButton, new ToolTipSimpleContentDescriptor("Hard Mode", ["Hard battle! Complete Normal mode with 3 stars to unlock!"], null, new FontDescriptor(12, 0xF13030, FontResources.YARDSALE)), ToolTipInfo.POSITION_BOTTOM), HintToolTip);
			
			// unreal mode
			if (info.hardModePassed)
			{
				if (info.unrealModePassed)
					ToolTipService.setToolTip(unrealButton, new ToolTipInfo(unrealButton, new ToolTipSimpleContentDescriptor("Unreal Mode", ["This mode is fully completed!"], null, new FontDescriptor(12, 0xAD23E9, FontResources.YARDSALE)), ToolTipInfo.POSITION_BOTTOM), HintToolTip);
				else
					ToolTipService.setToolTip(unrealButton, new ToolTipInfo(unrealButton, new ToolTipSimpleContentDescriptor("Unreal Mode", ["Survive in this unreal battle!"], null, new FontDescriptor(12, 0xAD23E9, FontResources.YARDSALE)), ToolTipInfo.POSITION_BOTTOM), HintToolTip);
			}
			else
				ToolTipService.setToolTip(unrealButton, new ToolTipInfo(unrealButton, new ToolTipSimpleContentDescriptor("Unreal Mode", ["Unreal battle! Complete Normal and Hard modes to unlock!"], null, new FontDescriptor(12, 0xAD23E9, FontResources.YARDSALE)), ToolTipInfo.POSITION_BOTTOM), HintToolTip);
		
		}
		
		private function addCompletedSignForButton(button:ToggleButton):void
		{
			var okSign:Bitmap = null;
			okSign = new okImage() as Bitmap;
			okSign.x = button.x + 20;
			okSign.y = button.y + 28;
			completedSignContainer.addChild(okSign);
		}
		
		public function show():void
		{
			normalButton.addEventListener(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION, stateChangedHandler);
			hardButton.addEventListener(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION, stateChangedHandler);
			unrealButton.addEventListener(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION, stateChangedHandler);
		}
		
		public function hide():void
		{
			ToolTipService.removeAllTooltipsForComponent(normalButton);
			ToolTipService.removeAllTooltipsForComponent(hardButton);
			ToolTipService.removeAllTooltipsForComponent(unrealButton);

			normalButton.removeEventListener(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION, stateChangedHandler);
			hardButton.removeEventListener(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION, stateChangedHandler);
			unrealButton.removeEventListener(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION, stateChangedHandler);
		}
		
		private function stateChangedHandler(event:ToggleButtonEvent):void
		{
			// block events from disabled buttons
			if (event.currentTarget == hardButton && currentInfo.starsEarned < 3)
			{
				hardButton.setUp();
				return;
			}
			
			if (event.currentTarget == unrealButton && !currentInfo.hardModePassed)
			{
				unrealButton.setUp();
				return;
			}
			
			normalButton.setUp();
			hardButton.setUp();
			unrealButton.setUp();
			
			ToggleButton(event.currentTarget).setDown();
			
			dispatchEvent(new Event(MODE_CHANGED));
		}
		
		public function getCurrentMode():String
		{
			if (!normalButton.isUpState)
				return ModeSettings.MODE_NORMAL;
			else if (!hardButton.isUpState)
				return ModeSettings.MODE_HARD;
			else if (!unrealButton.isUpState)
				return ModeSettings.MODE_UNREAL;
			
			throw new Error("Mode must be selected!");
			
			return null;
		}
	}

}