/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import controllers.SoundController;
	import flash.display.Bitmap;
	import infoObjects.gameInfo.LevelInfo;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.SoundResources;
	import supportControls.toolTips.TutorialToolTip;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapFlag extends NSSprite
	{
		[Embed(source="F:/Island Defence/media/images/panels/map/flag normal.png")]
		private static var buttonFlagNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/flag over.png")]
		private static var buttonFlagOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/flag down.png")]
		private static var buttonFlagDownImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/flag without circle.png")]
		private static var flagWithoutCircleImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/flag circle.png")]
		private static var flagCircleImage:Class;
		
		///////
		[Embed(source="F:/Island Defence/media/images/panels/map/star small.png")]
		private static var starSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/hard mode enabled.png")]
		private static var hardModeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/modes/unreal mode enabled.png")]
		private static var unrealModeImage:Class;
		
		/////////////
		
		private var flagButton:Button = new Button();
		
		/////////////
		
		public function MapFlag()
		{
			construct();
		}
		
		/////////////
		
		private function construct():void
		{
			ControlConfigurator.configureButton(flagButton, buttonFlagNormalImage, buttonFlagOverImage, buttonFlagDownImage);
			
			flagButton.refresh(true, true);
			flagButton.x = -flagButton.width / 2 + 18;
			flagButton.y = -flagButton.height + 34;
			
			addChild(flagButton);
		}
		
		//////////////
		
		public function showStartingToolTip():void
		{
			var tooltip:* = ToolTipService.setTooltipWaitingForClick(this, new ToolTipInfo(this, new ToolTipSimpleContentDescriptor("START HERE")), TutorialToolTip);
			AnimationEngine.globalAnimator.animateConstantWaving([tooltip], 300, AnimationEngine.globalAnimator.currentTime, 0.02);
		}
		
		public function animateFlagSticking(timeOffset:int = 0):void
		{
			flagButton.visible = false;
			
			// when animating show a different flag that doesn't have a circle
			var animationFlag:Bitmap = new flagWithoutCircleImage() as Bitmap;
			var animationContainer:NSSprite = new NSSprite();
			var flagCircle:Bitmap = new flagCircleImage() as Bitmap;
			
			animationFlag.x = -animationFlag.width / 2 + 18;
			animationFlag.y = -animationFlag.height + 34;
			animationFlag.smoothing = true;
			animationContainer.alpha = 0;
			animationContainer.scaleY = 1.4;
			
			flagCircle.x = -width / 2 + 23;
			flagCircle.y = -6;
			flagCircle.alpha = 0;
			
			addChild(flagCircle);
			addChild(animationContainer);
			animationContainer.addChild(animationFlag);
			
			var offset:Number = 20;
			
			// sticking a flag
			AnimationEngine.globalAnimator.animateProperty(animationContainer, "alpha", 0, 1, NaN, 100, AnimationEngine.globalAnimator.currentTime + timeOffset);
			AnimationEngine.globalAnimator.moveObjects(animationContainer, 0, 0 - offset, 0, 0, 200, AnimationEngine.globalAnimator.currentTime + timeOffset);
			AnimationEngine.globalAnimator.scaleObjects(animationContainer, 1, 1.4, 1, 0.7, 150, AnimationEngine.globalAnimator.currentTime + 100 + timeOffset);
			AnimationEngine.globalAnimator.scaleObjects(animationContainer, 1, 0.7, 1, 1, 200, AnimationEngine.globalAnimator.currentTime + 250 + timeOffset);
			
			// circle appears
			AnimationEngine.globalAnimator.animateProperty(flagCircle, "alpha", 0, 1, NaN, 200, AnimationEngine.globalAnimator.currentTime + 400 + timeOffset);
			
			// swap flags
			AnimationEngine.globalAnimator.removeFromParent(animationContainer, this, AnimationEngine.globalAnimator.currentTime + 600 + timeOffset);
			AnimationEngine.globalAnimator.removeFromParent(flagCircle, this, AnimationEngine.globalAnimator.currentTime + 600 + timeOffset);
			
			AnimationEngine.globalAnimator.executeFunction(tryAddToParent, null, AnimationEngine.globalAnimator.currentTime + 600 + timeOffset);
			
			SoundController.instance.playSound(SoundResources.SOUND_WINDOW_SLIDE, 1, timeOffset);
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_TAP, 1, timeOffset);
		}
		
		private function tryAddToParent():void
		{
			flagButton.visible = true;
		}
		
		/////////////
		
		public function updateForLevelInfo(info:LevelInfo):void
		{
			/////////////////
			
			var numStars:int = info.starsEarned;
			var toggle:int = 1;
			
			for (var i:int = 0; i < numStars; i++)
			{
				var star:Bitmap = new starSmallImage() as Bitmap;
				
				star.x = flagButton.x + 5 + 10 * i;
				star.y = flagButton.y + 5 * toggle;
				addChild(star);
				
				toggle *= -1;
			}
			
			if (info.hardModePassed)
			{
				var hmIcon:Bitmap = new hardModeImage();
				hmIcon.smoothing = true;
				hmIcon.width = 25;
				hmIcon.height = 25;
				
				hmIcon.x = 0;
				hmIcon.y = -20;
				
				addChildAt(hmIcon, 0);
			}
			
			if (info.unrealModePassed)
			{
				var umIcon:Bitmap = new unrealModeImage();
				umIcon.smoothing = true;
				umIcon.width = 25;
				umIcon.height = 25;
				
				umIcon.x = 30;
				umIcon.y = -60;
				
				addChildAt(umIcon, 0);
			}
		}
		
		////////////
		
		public function deactivate():void
		{
			var tooltip:* = ToolTipService.getToolTipAssignedForComponent(this);
			if (tooltip)
				AnimationEngine.globalAnimator.stopAnimationForObject(tooltip);
			
			ToolTipService.removeAllTooltipsForComponent(this);
		}
	
	}

}