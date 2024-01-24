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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.BubbleService;
	import panels.common.PaperTitle;
	import panels.PanelBase;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.SoundResources;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class CreditsPanel extends PanelBase
	{
		public static const CLOSE_CLICKED:String = "closeClicked";
		
		/////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/credits frame.png")]
		private static var frameImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/close button down.png")]
		private static var closeButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/close button over.png")]
		private static var closeButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/close button down.png")]
		private static var closeButtonDownImage:Class;
		
		////////////////////////////
		
		private var frameHolder:NSSprite = new NSSprite();
		
		private var paperTitle:PaperTitle = new PaperTitle();
		
		private var closeButton:Button = new Button();
		
		////////////////////////////
		
		public function CreditsPanel()
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
			
			paperTitle.setTitleText("Credits", 25);
			
			closeButton.x = 530;
			closeButton.y = 10;
			ControlConfigurator.configureButton(closeButton, closeButtonNormalImage, closeButtonOverImage, closeButtonDownImage);
			BubbleService.applyBubbleOnMouseOver(closeButton, 1.03);
			
			frameHolder.addChild(closeButton);
			
			addChild(frameHolder);
		}
		
		override public function show():void
		{
			super.show();
			
			frameHolder.x = (GamePlayConstants.STAGE_WIDTH - frameHolder.width) / 2;
			frameHolder.y = (GamePlayConstants.STAGE_HEIGHT - frameHolder.height) / 2;
			
			frameHolder.alpha = 0;
			AnimationEngine.globalAnimator.animateProperty(frameHolder, "alpha", 0, 1, NaN, 300, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.moveObjects(frameHolder, frameHolder.x, 0, frameHolder.x, frameHolder.y, 300, AnimationEngine.globalAnimator.currentTime);
			//AnimationEngine.globalAnimator.moveObjects(frameHolder, 25, 70, 25, 50, 300, AnimationEngine.globalAnimator.currentTime + 500); // back animation
			showBlockScreen();
			
			closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
			
			SoundController.instance.playSound(SoundResources.SOUND_WINDOW_SLIDE);
			
			GameTracker.api.customMsg(TrackingMessages.VISITED_CREDITS);
		}
		
		override public function hide():void
		{
			super.hide();
			
			hideBlockScreen();
			
			closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
		}
		
		private function closeButton_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(CLOSE_CLICKED));
		}
	
	}

}