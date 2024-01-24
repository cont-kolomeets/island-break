/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import flash.events.Event;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import panels.PanelBase;
	import supportClasses.ControlConfigurator;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameOverPanel extends PanelBase
	{
		public static const RESTART_CLICKED:String = "restartClicked";
		
		public static const TO_MENU_CLICKED:String = "toMenuClicked";
		
		/////////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/defeat panel/base.png")]
		private static var baseImage:Class;
		
		///////////
		
		[Embed(source="F:/Island Defence/media/images/panels/defeat panel/button restart normal.png")]
		private static var buttonRestartNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/defeat panel/button restart over.png")]
		private static var buttonRestartOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/defeat panel/button restart down.png")]
		private static var buttonRestartDownImage:Class;
		
		///////////
		
		[Embed(source="F:/Island Defence/media/images/panels/defeat panel/button menu normal.png")]
		private static var buttonMenuNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/defeat panel/button menu over.png")]
		private static var buttonMenuOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/defeat panel/button menu down.png")]
		private static var buttonMenuDownImage:Class;
		
		///////////
		
		private var baseContainer:NSSprite = new NSSprite();
		
		private var starsContainer:NSSprite = new NSSprite();
		
		private var toMenuButton:Button = new Button();
		
		private var restartButton:Button = new Button();
		
		///////////
		
		public function GameOverPanel()
		{
			constructPanel();
		}
		
		///////////
		
		private function constructPanel():void
		{
			blockScreenFillAlpha = 0.7;
			enableBlockScreen = true;
			
			var base:Bitmap = new baseImage() as Bitmap;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			base.smoothing = true;
			baseContainer.addChild(base);
			
			baseContainer.x = GamePlayConstants.STAGE_WIDTH / 2;
			baseContainer.y = 180;
			
			addChild(baseContainer);
			
			ControlConfigurator.configureButton(restartButton, buttonRestartNormalImage, buttonRestartOverImage, buttonRestartDownImage);
			
			ControlConfigurator.configureButton(toMenuButton, buttonMenuNormalImage, buttonMenuOverImage, buttonMenuDownImage);
			
			restartButton.x = 260;
			restartButton.y = 350;
			
			toMenuButton.x = 272;
			toMenuButton.y = 440;
			
			addChild(toMenuButton);
			addChild(restartButton);
		}
		
		///////////////
		
		override public function show():void
		{
			super.show();
			showAnimation();
			
			restartButton.addEventListener(ButtonEvent.BUTTON_CLICK, restartButton_clickHandler);
			toMenuButton.addEventListener(ButtonEvent.BUTTON_CLICK, toMenuButton_clickHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			
			restartButton.removeEventListener(ButtonEvent.BUTTON_CLICK, restartButton_clickHandler);
			toMenuButton.removeEventListener(ButtonEvent.BUTTON_CLICK, toMenuButton_clickHandler);
		}
		
		private function showAnimation():void
		{
			AnimationEngine.globalAnimator.animateProperty(baseContainer, "alpha", 0, 1, NaN, 200, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.scaleObjects(baseContainer, 2, 2, 0.9, 0.9, 500, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.scaleObjects(baseContainer, 0.9, 0.9, 1, 1, 100, AnimationEngine.globalAnimator.currentTime + 500); // back animation
			
			/////////
			
			AnimationEngine.globalAnimator.moveObjects(restartButton, restartButton.x, GamePlayConstants.STAGE_HEIGHT + 50, restartButton.x, restartButton.y - 10, 600, AnimationEngine.globalAnimator.currentTime + 500);
			AnimationEngine.globalAnimator.moveObjects(restartButton, restartButton.x, restartButton.y - 10, restartButton.x, restartButton.y, 300, AnimationEngine.globalAnimator.currentTime + 1200); // back animation
			
			AnimationEngine.globalAnimator.moveObjects(toMenuButton, toMenuButton.x, GamePlayConstants.STAGE_HEIGHT + 50, toMenuButton.x, toMenuButton.y - 10, 600, AnimationEngine.globalAnimator.currentTime + 700);
			AnimationEngine.globalAnimator.moveObjects(toMenuButton, toMenuButton.x, toMenuButton.y - 10, toMenuButton.x, toMenuButton.y, 300, AnimationEngine.globalAnimator.currentTime + 1400); // back animation
			
			toMenuButton.y = GamePlayConstants.STAGE_HEIGHT + 50;
			restartButton.y = GamePlayConstants.STAGE_HEIGHT + 50;
		}
		
		//////////////////////
		
		private function restartButton_clickHandler(event:Event):void
		{
			dispatchEvent(new Event(RESTART_CLICKED));
		}
		
		private function toMenuButton_clickHandler(event:Event):void
		{
			dispatchEvent(new Event(TO_MENU_CLICKED));
		}
	
	}

}