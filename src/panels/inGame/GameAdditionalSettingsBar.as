/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import events.SpeedControlEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import mainPack.GameSettings;
	import nslib.controls.Button;
	import nslib.controls.ButtonBar;
	import nslib.controls.events.ButtonBarEvent;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.core.Globals;
	import supportClasses.ControlConfigurator;
	import supportClasses.ISettingsObserver;
	import supportControls.toolTips.InGameHintToolTip;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameAdditionalSettingsBar extends NSSprite implements ISettingsObserver
	{
		
		public static const GAME_SETTINGS_CLICKED:String = "gameSettingsClicked";
		
		public static const ENCYCLOPEDIA_CLICKED:String = "encyclopediaClicked";
		
		/////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button settings normal.png")]
		private static var buttonSettingsNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button settings over.png")]
		private static var buttonSettingsOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button settings down.png")]
		private static var buttonSettingsDownImage:Class;
		
		/////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button encyclopedia normal.png")]
		private static var buttonEncyclopediaNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button encyclopedia over.png")]
		private static var buttonEncyclopediaOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button encyclopedia down.png")]
		private static var buttonEncyclopediaDownImage:Class;
		
		///////////////
		
		private var settingsButton:Button = new Button();
		
		private var encyclopediaButton:Button = new Button();
		
		private var speedUpButtonBar:ButtonBar = new ButtonBar();
		
		///////////////
		
		public function GameAdditionalSettingsBar()
		{
			GameSettings.registerObserver(this);
			construct();
		}
		
		//////////////
		
		private function construct():void
		{
			speedUpButtonBar.x = 0;
			speedUpButtonBar.y = 6;
			speedUpButtonBar.buttonClass = SpeedButtonBarButton;
			speedUpButtonBar.dataProvider = [{}, {}, {}];
			speedUpButtonBar.horizontalGap = -3;
			speedUpButtonBar.addEventListener(ButtonBarEvent.INDEX_CHANGED, speedUpButtonBar_indexChangedHander, false, 0, true);
			
			updateToolTips();
			
			encyclopediaButton.x = 74;
			encyclopediaButton.y = 0;
			encyclopediaButton.addEventListener(ButtonEvent.BUTTON_CLICK, encyclopediaButton_clickHandler, false, 0, true);
			ControlConfigurator.configureButton(encyclopediaButton, buttonEncyclopediaNormalImage, buttonEncyclopediaOverImage, buttonEncyclopediaDownImage);
			
			settingsButton.x = 114;
			settingsButton.y = 0;
			settingsButton.addEventListener(ButtonEvent.BUTTON_CLICK, settingsButton_clickHandler, false, 0, true);
			ControlConfigurator.configureButton(settingsButton, buttonSettingsNormalImage, buttonSettingsOverImage, buttonSettingsDownImage);
			
			addChild(speedUpButtonBar);
			addChild(encyclopediaButton);
			addChild(settingsButton);
			
			Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		///////////////
		
		public function toInitialState():void
		{
			speedUpButtonBar.selectedIndex = 0;
		}
		
		public function notifySettingsChanged(propertyName:String):void
		{
			if (propertyName == "enableTooltips")
				updateToolTips();
		}
		
		private function updateToolTips():void
		{
			for (var i:int = 0; i < speedUpButtonBar.buttons.length; i++)
				if (GameSettings.enableTooltips)
				{
					var message:String = null;
					
					switch (i)
					{
						case 0: 
							message = "Normal Speed";
							break;
						case 1: 
							message = "2X Speeding UP!";
							break;
						case 2: 
							message = "4X Speeding UP!";
							break;
					}
					
					ToolTipService.setToolTip(speedUpButtonBar.buttons[i] as DisplayObject, new ToolTipInfo(speedUpButtonBar.buttons[i] as DisplayObject, new ToolTipSimpleContentDescriptor(null, [message]), ToolTipInfo.POSITION_BOTTOM), InGameHintToolTip);
				}
				else
					ToolTipService.removeAllTooltipsForComponent(speedUpButtonBar.buttons[i] as DisplayObject);
		}
		
		/////////////////
		
		private function encyclopediaButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(ENCYCLOPEDIA_CLICKED));
		}
		
		private function settingsButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(GAME_SETTINGS_CLICKED));
		}
		
		private function speedUpButtonBar_indexChangedHander(event:ButtonBarEvent):void
		{
			var newSpeed:int = event.newIndex == 0 ? 1 : event.newIndex == 1 ? 2 : 4;
			
			dispatchEvent(new SpeedControlEvent(SpeedControlEvent.GAME_SPEED_CHANGED, newSpeed));
		}
		
		///
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.NUMPAD_ADD)
				tryIncreaseSpeed();
			else if (event.keyCode == Keyboard.NUMPAD_SUBTRACT)
				tryDecreaseSpeed();
		}
		
		private function tryIncreaseSpeed():void
		{
			var oldIndex:int = speedUpButtonBar.selectedIndex;
			
			speedUpButtonBar.selectedIndex++;
			
			if (oldIndex != speedUpButtonBar.selectedIndex)
				speedUpButtonBar.dispatchEvent(new ButtonBarEvent(ButtonBarEvent.INDEX_CHANGED, speedUpButtonBar.selectedIndex));
		}
		
		private function tryDecreaseSpeed():void
		{
			var oldIndex:int = speedUpButtonBar.selectedIndex;
			
			speedUpButtonBar.selectedIndex--;
			
			if (oldIndex != speedUpButtonBar.selectedIndex)
				speedUpButtonBar.dispatchEvent(new ButtonBarEvent(ButtonBarEvent.INDEX_CHANGED, speedUpButtonBar.selectedIndex));
		}
	}

}