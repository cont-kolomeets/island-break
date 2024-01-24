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
	import infoObjects.panelInfos.VictoryPanelInfo;
	import mainPack.ModeSettings;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.effects.fireWorks.BatchFireWork;
	import nslib.effects.fireWorks.FireWork;
	import nslib.effects.fireWorks.FireWorkParticle;
	import nslib.utils.FontDescriptor;
	import panels.common.MessageNotifier;
	import panels.PanelBase;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class VictoryPanel extends PanelBase
	{
		public static const CONTINUE_CLICKED:String = "continueClicked";
		
		public static const RESTART_CLICKED:String = "restartClicked";
		
		/////////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/victory panel/base.png")]
		private static var baseImage:Class;
		
		///////////
		
		[Embed(source="F:/Island Defence/media/images/panels/victory panel/button continue normal.png")]
		private static var buttonContinueNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/victory panel/button continue over.png")]
		private static var buttonContinueOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/victory panel/button continue down.png")]
		private static var buttonContinueDownImage:Class;
		
		///////////
		
		[Embed(source="F:/Island Defence/media/images/panels/victory panel/button restart normal.png")]
		private static var buttonRestartNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/victory panel/button restart over.png")]
		private static var buttonRestartOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/victory panel/button restart down.png")]
		private static var buttonRestartDownImage:Class;
		
		/////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/victory panel/star earned.png")]
		private static var starEarnedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/victory panel/star empty.png")]
		private static var starEmptyImage:Class;
		
		////////////////////
		
		private var fireworkContainer:NSSprite = new NSSprite();
		
		private var baseContainer:NSSprite = new NSSprite();
		
		private var starsContainer:NSSprite = new NSSprite();
		
		private var continueButton:Button = new Button();
		
		private var restartButton:Button = new Button();
		
		//////
		
		private var batchFirework:BatchFireWork = new BatchFireWork();
		
		private var messageNotifier:MessageNotifier = new MessageNotifier();
		
		/////////////
		
		private var stars:Array = [];
		
		///////////////////
		
		function VictoryPanel()
		{
			super();
			constructPanel();
		}
		
		///////////////////
		
		private function constructPanel():void
		{
			blockScreenFillAlpha = 0.7;
			enableBlockScreen = true;
			
			addChild(fireworkContainer);
			
			var base:Bitmap = new baseImage() as Bitmap;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			base.smoothing = true;
			baseContainer.addChild(base);
			
			baseContainer.x = GamePlayConstants.STAGE_WIDTH / 2;
			baseContainer.y = 180;
			
			addChild(baseContainer);
			
			ControlConfigurator.configureButton(continueButton, buttonContinueNormalImage, buttonContinueOverImage, buttonContinueDownImage);
			ControlConfigurator.configureButton(restartButton, buttonRestartNormalImage, buttonRestartOverImage, buttonRestartDownImage);
			
			continueButton.x = 250;
			continueButton.y = 350;
			
			restartButton.x = 260;
			restartButton.y = 440;
			
			addChild(continueButton);
			addChild(restartButton);
			
			starsContainer.x = GamePlayConstants.STAGE_WIDTH / 2;
			starsContainer.y = 290;
			addChild(starsContainer);
			
			fillStartContainerWithEmptyStars();
			
			messageNotifier.stayDuration = 0;
			messageNotifier.workingLayer = this;
		}
		
		private function fillStartContainerWithEmptyStars():void
		{
			addEmptyStar(-70, 0);
			addEmptyStar(0, -20);
			addEmptyStar(70, 0);
		}
		
		private function addEmptyStar(offsetX:Number, offsetY:Number):void
		{
			var star:Bitmap = new starEmptyImage() as Bitmap;
			star.x = -star.width / 2 + offsetX;
			star.y = -star.height / 2 + offsetY;
			
			starsContainer.addChild(star);
		}
		
		// pops an earned star of an empty one
		private function popEarnedStar(offsetX:Number, offsetY:Number, timeOffset:int = 0):void
		{
			var star:Bitmap = new starEarnedImage() as Bitmap;
			star.x = -star.width / 2;
			star.y = -star.height / 2;
			star.smoothing = true;
			
			var starContainer:NSSprite = new NSSprite();
			starContainer.x = offsetX;
			starContainer.y = offsetY;
			starContainer.addChild(star);
			// preparing for animation
			starContainer.alpha = 0;
			
			starsContainer.addChild(starContainer);
			
			stars.push(starContainer);
			
			// hack fix: waiting for the show animation
			AnimationEngine.globalAnimator.animateProperty(starContainer, "alpha", 0, 1, NaN, 100, AnimationEngine.globalAnimator.currentTime + 2000 + timeOffset);
			AnimationEngine.globalAnimator.scaleObjects(starContainer, 1, 1, 1.2, 1.2, 200, AnimationEngine.globalAnimator.currentTime + 2000 + timeOffset);
			AnimationEngine.globalAnimator.scaleObjects(starContainer, 1.2, 1.2, 1, 1, 200, AnimationEngine.globalAnimator.currentTime + 2200 + timeOffset); // back animation
		}
		
		///////////////////
		
		override public function show():void
		{
			super.show();
			
			messageNotifier.clear();
			showAnimation();
			
			continueButton.addEventListener(ButtonEvent.BUTTON_CLICK, continueButton_clickHandler);
			restartButton.addEventListener(ButtonEvent.BUTTON_CLICK, restartButton_clickHandler);

			var prototype:FireWork = new FireWork();
			prototype.particleType = FireWorkParticle.TYPE_STAR;
			prototype.particleRadius = 4;
			batchFirework.workingLayer = fireworkContainer;
			batchFirework.startFirework(prototype, 20, 0xFFFF00, 1000, 500);
		}
		
		override public function hide():void
		{
			super.hide();
			removeStars();
			
			continueButton.removeEventListener(ButtonEvent.BUTTON_CLICK, continueButton_clickHandler);
			restartButton.removeEventListener(ButtonEvent.BUTTON_CLICK, restartButton_clickHandler);
			
			batchFirework.stop();
		}
		
		///////////////
		
		private function showAnimation():void
		{
			AnimationEngine.globalAnimator.animateProperty(baseContainer, "alpha", 0, 1, NaN, 200, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.scaleObjects(baseContainer, 2, 2, 0.9, 0.9, 500, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.scaleObjects(baseContainer, 0.9, 0.9, 1, 1, 100, AnimationEngine.globalAnimator.currentTime + 500); // back animation
			
			starsContainer.alpha = 0;
			AnimationEngine.globalAnimator.animateProperty(starsContainer, "alpha", 0, 1, NaN, 300, AnimationEngine.globalAnimator.currentTime + 1000);
			
			/////////
			AnimationEngine.globalAnimator.moveObjects(continueButton, continueButton.x, GamePlayConstants.STAGE_HEIGHT + 50, continueButton.x, continueButton.y - 10, 600, AnimationEngine.globalAnimator.currentTime + 500);
			AnimationEngine.globalAnimator.moveObjects(continueButton, continueButton.x, continueButton.y - 10, continueButton.x, continueButton.y, 300, AnimationEngine.globalAnimator.currentTime + 1200); // back animation
			
			AnimationEngine.globalAnimator.moveObjects(restartButton, restartButton.x, GamePlayConstants.STAGE_HEIGHT + 50, restartButton.x, restartButton.y - 10, 600, AnimationEngine.globalAnimator.currentTime + 700);
			AnimationEngine.globalAnimator.moveObjects(restartButton, restartButton.x, restartButton.y - 10, restartButton.x, restartButton.y, 300, AnimationEngine.globalAnimator.currentTime + 1400); // back animation
			
			continueButton.y = GamePlayConstants.STAGE_HEIGHT + 50;
			restartButton.y = GamePlayConstants.STAGE_HEIGHT + 50;
		}
		
		////////////////
		
		override public function applyPanelInfo(panelInfo:*):void
		{
			super.applyPanelInfo(panelInfo);
			
			starsContainer.visible = false;
			
			if (VictoryPanelInfo(panelInfo).levelMode == ModeSettings.MODE_NORMAL)
			{
				starsContainer.visible = true;
				showStars(VictoryPanelInfo(panelInfo).starsEarned);
			}
			else if (VictoryPanelInfo(panelInfo).levelMode == ModeSettings.MODE_HARD)
				messageNotifier.showScreenNotification("HARD!", new FontDescriptor(50, 0xF13530, FontResources.YARDSALE));
			else if (VictoryPanelInfo(panelInfo).levelMode == ModeSettings.MODE_UNREAL)
				messageNotifier.showScreenNotification("UNREAL!", new FontDescriptor(50, 0xB73CF9, FontResources.YARDSALE));
		}
		
		private function showStars(numberOfStars:int):void
		{
			if (numberOfStars > 0)
				popEarnedStar(-70, 0, 0);
			
			if (numberOfStars > 1)
				popEarnedStar(0, -20, 500);
			
			if (numberOfStars > 2)
				popEarnedStar(70, 0, 1000);
		}
		
		private function removeStars():void
		{
			starsContainer.removeAllChildren();
			fillStartContainerWithEmptyStars();
		}
		
		//////////////////
		
		private function continueButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(CONTINUE_CLICKED));
		}
		
		private function restartButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(RESTART_CLICKED));
		}
	
	}

}