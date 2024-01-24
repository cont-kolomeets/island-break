/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import constants.GamePlayConstants;
	import controllers.SoundController;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import infoObjects.gameInfo.LevelInfo;
	import mainPack.ModeSettings;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.LayoutContainer;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.BubbleService;
	import nslib.utils.FontDescriptor;
	import panels.common.PaperTitle;
	import panels.news.ImportantNotification;
	import panels.PanelBase;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.SoundResources;
	import supportClasses.SponsorInfoGenerator;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class LevelInfoPanel extends PanelBase
	{
		public static const TO_BATTLE_CLIKCED:String = "toBattleClicked";
		
		public static const CLOSE_CLICKED:String = "closeClicked";
		
		/////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/frame.png")]
		private static var frameImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/close button down.png")]
		private static var closeButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/close button over.png")]
		private static var closeButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/close button down.png")]
		private static var closeButtonDownImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/star filled.png")]
		private static var starFilledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/star empty.png")]
		private static var starEmptyImage:Class;
		
		///////
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/to battle button normal.png")]
		private static var toBattleButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/to battle button over.png")]
		private static var toBattleButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/to battle button down.png")]
		private static var toBattleButtonDownImage:Class;
		
		////////////////////////////
		
		private var frameHolder:NSSprite = new NSSprite();
		
		private var paperTitle:PaperTitle = new PaperTitle();
		
		private var toBattleButton:Button = new Button();
		
		private var closeButton:Button = new Button();
		
		private var levelThumb:Bitmap = new Bitmap();
		
		private var levelDescription:LevelDescriptionPanel = new LevelDescriptionPanel();
		
		private var starsHolder:LayoutContainer = new LayoutContainer();
		
		private var importantNotification:ImportantNotification = new ImportantNotification();
		
		//private var levelModeBar:LevelModeBar = new LevelModeBar();
		
		////////////////////////////
		
		public function LevelInfoPanel()
		{
			constructPanelBase();
		}
		
		///////////////////////////
		
		private function constructPanelBase():void
		{
			blockScreenFillAlpha = 0.7;
			enableBlockScreen = true;
			
			var frameBaseImage:Bitmap = new frameImage() as Bitmap;
			// adding base
			frameHolder.addChild(frameBaseImage);
			
			frameHolder.addChild(paperTitle);
			
			//levelModeBar.x = 267;
			//levelModeBar.y = 220;
			
			// adding buttons
			toBattleButton.fontDescriptor = new FontDescriptor(25, 0xC0F40B, FontResources.YARDSALE);
			toBattleButton.x = 470;
			toBattleButton.y = 222;
			//BubbleService.applyBubbleOnMouseOver(toBattleButton, 1.03);
			ControlConfigurator.configureButton(toBattleButton, toBattleButtonNormalImage, toBattleButtonOverImage, toBattleButtonDownImage);

			// adding a logo for sponsor
			var sponsorLogo:NSSprite = SponsorInfoGenerator.createSponsorLogoForLevelInfoPage();

			sponsorLogo.x = 270;
			sponsorLogo.y = 237;
			frameHolder.addChild(sponsorLogo);
			
			///////////
			
			closeButton.x = 570;
			closeButton.y = 30;
			ControlConfigurator.configureButton(closeButton, closeButtonNormalImage, closeButtonOverImage, closeButtonDownImage);
			BubbleService.applyBubbleOnMouseOver(closeButton, 1.03);
			
			/////////
			
			var levelThumbBorder:Shape = new Shape();
			levelThumbBorder.graphics.lineStyle(5, 0xFE9155, 1);
			levelThumbBorder.graphics.drawRect(0, 0, 170, 134);
			
			levelThumbBorder.x = 70;
			levelThumbBorder.y = 80;
			
			levelThumb.x = 70;
			levelThumb.y = 80;
			
			starsHolder.x = 90;
			starsHolder.y = 220;
			
			//////////
			
			levelDescription.x = 270;
			levelDescription.y = 85;
			
			//frameHolder.addChild(levelModeBar);
			frameHolder.addChild(toBattleButton);
			frameHolder.addChild(closeButton);
			
			frameHolder.addChild(levelThumbBorder);
			frameHolder.addChild(levelThumb);
			frameHolder.addChild(starsHolder);
			frameHolder.addChild(levelDescription);
			
			addChild(frameHolder);
			
			importantNotification.animationEngine = AnimationEngine.globalAnimator;
		}
		
		override public function show():void
		{
			super.show();
			
			//levelModeBar.show();
			//levelModeBar.addEventListener(LevelModeBar.MODE_CHANGED, levelModeBar_modeChangedHandler);
			
			frameHolder.alpha = 0;
			AnimationEngine.globalAnimator.animateProperty(frameHolder, "alpha", 0, 1, NaN, 300, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.moveObjects(frameHolder, 25, 0, 25, 70, 300, AnimationEngine.globalAnimator.currentTime);
			//AnimationEngine.globalAnimator.moveObjects(frameHolder, 25, 70, 25, 50, 300, AnimationEngine.globalAnimator.currentTime + 500); // back animation
			showBlockScreen();
			
			toBattleButton.addEventListener(MouseEvent.CLICK, toBattleButton_clickHandler);
			closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
			
			SoundController.instance.playSound(SoundResources.SOUND_WINDOW_SLIDE);
			
			GameTracker.api.customMsg(TrackingMessages.OPENED_LEVEL_INFO);
		}
		
		override public function hide():void
		{
			super.hide();
			
			//levelModeBar.hide();
			//levelModeBar.removeEventListener(LevelModeBar.MODE_CHANGED, levelModeBar_modeChangedHandler);
			
			hideBlockScreen();
			toBattleButton.removeEventListener(MouseEvent.CLICK, toBattleButton_clickHandler);
			closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
		}
		
		private function toBattleButton_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(TO_BATTLE_CLIKCED));
		}
		
		private function closeButton_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(CLOSE_CLICKED));
		}
		
		/*private function levelModeBar_modeChangedHandler(event:Event):void
		{
			levelDescription.showDescriptionForCurrentMode(LevelInfo(panelInfo), getCurrentLevelMode());
		}*/
		
		// gets LevelInfo of selected level.
		override public function applyPanelInfo(panelInfo:*):void
		{
			super.applyPanelInfo(panelInfo);
			
			if (!panelInfo)
				return;
			
			//levelModeBar.updateForLevelInfo(LevelInfo(panelInfo));
			showLevelInfo();
			levelDescription.showDescriptionForCurrentMode(LevelInfo(panelInfo), getCurrentLevelMode());
			
			importantNotification.visible = false;
		}
		
		public function recommendToMakeDevelopments():void
		{
			importantNotification.notification = "Levels will get harder. Make sure you spend your stars on new developments!";
			importantNotification.y = GamePlayConstants.STAGE_HEIGHT - 110;
			importantNotification.x = GamePlayConstants.STAGE_WIDTH / 2 + 20; // compensating the shift of contentContainer
			addChild(importantNotification);
			
			importantNotification.visible = true;
			importantNotification.popUpNotification(1000);
		}
		
		private function showLevelInfo():void
		{
			var levelInfo:LevelInfo = panelInfo as LevelInfo;
			
			starsHolder.removeAllChildren();
			for (var i:int = 1; i <= 3; i++)
			{
				var star:Bitmap = (i <= levelInfo.starsEarned) ? (new starFilledImage() as Bitmap) : (new starEmptyImage() as Bitmap);
				starsHolder.addChild(star);
			}
			
			levelThumb.bitmapData = levelInfo.bitMapIconBig;
			
			paperTitle.setTitleText("Level " + (levelInfo.index + 1) + " : " + levelInfo.name, 22);
		}
		
		public function getCurrentLevelMode():String
		{
			return ModeSettings.MODE_NORMAL;// levelModeBar.getCurrentMode();
		}
	
	}

}