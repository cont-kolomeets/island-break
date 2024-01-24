/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.news
{
	import controllers.SoundController;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.SoundResources;
	import supportControls.toolTips.HintToolTip;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class NewsNotificationToolBar extends NSSprite
	{
		////////////////////////////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button new enemy normal.png")]
		private static var newEnemyButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button new enemy over.png")]
		private static var newEnemyButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button new enemy normal.png")]
		private static var newEnemyButtonDownImage:Class;
		
		/////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button tip normal.png")]
		private static var tipButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button tip over.png")]
		private static var tipButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/button tip normal.png")]
		private static var tipButtonDownImage:Class;
		
		////////////////////////////////////
		
		public var newEnemyButton:Button = new Button();
		
		public var tipButton:Button = new Button();
		
		private var newEnemyButtonContainer:NSSprite = new NSSprite();
		
		private var tipButtonContainer:NSSprite = new NSSprite();
		
		//////////////
		
		public function NewsNotificationToolBar()
		{
			construct();
		}
		
		//////////////
		
		private function construct():void
		{
			ControlConfigurator.configureButton(newEnemyButton, newEnemyButtonNormalImage, newEnemyButtonOverImage, newEnemyButtonDownImage);
			newEnemyButton.smoothing = true;
			
			ControlConfigurator.configureButton(tipButton, tipButtonNormalImage, tipButtonOverImage, tipButtonDownImage);
			tipButton.smoothing = true;
			
			addChild(newEnemyButtonContainer);
			addChild(tipButtonContainer);
		}
		
		public function showButtonForEnemy(needShowGuideToolTipForEnemyButtonFlag:Boolean = false):void
		{
			newEnemyButtonContainer.removeAllChildren();
			
			// adding button
			newEnemyButton.x = -newEnemyButton.width / 2;
			newEnemyButton.y = -newEnemyButton.height / 2;
			newEnemyButtonContainer.addChild(newEnemyButton);
			
			AnimationEngine.globalAnimator.executeFunction(syncBubblingAnimation, null, AnimationEngine.globalAnimator.currentTime + 300);
			
			newEnemyButtonContainer.scaleX = 1;
			newEnemyButtonContainer.scaleY = 1;
			
			if (needShowGuideToolTipForEnemyButtonFlag)
			{
				var tooltip:* = ToolTipService.setTooltipWaitingForClick(newEnemyButton, new ToolTipInfo(newEnemyButton, new ToolTipSimpleContentDescriptor(null, ["CLICK HERE!"], null, null, new FontDescriptor(14, 0xD12125, FontResources.KOMTXTB)), ToolTipInfo.POSITION_RIGHT, true), HintToolTip, this.parent.parent);
				AnimationEngine.globalAnimator.animateConstantBubbling([tooltip], 300, AnimationEngine.globalAnimator.currentTime, 0.1);
			}
			
			// need to apply correct scale for animation
			newEnemyButtonContainer.scaleX = 0.2;
			newEnemyButtonContainer.scaleY = 0.2;
			AnimationEngine.globalAnimator.animatePopping([newEnemyButtonContainer], 0.2, 1.2, 300, AnimationEngine.globalAnimator.currentTime);
			
			updateButtonsPositions();
			updateToolTipForTipButton();
			
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_POP);
		}
		
		private function syncBubblingAnimation():void
		{
			AnimationEngine.globalAnimator.stopAnimationForObject(newEnemyButtonContainer);
			newEnemyButtonContainer.scaleX = 1;
			newEnemyButtonContainer.scaleY = 1;
			AnimationEngine.globalAnimator.animateConstantBubbling([newEnemyButtonContainer], 300, AnimationEngine.globalAnimator.currentTime, 0.2);
			
			AnimationEngine.globalAnimator.stopAnimationForObject(tipButtonContainer);
			tipButtonContainer.scaleX = 1;
			tipButtonContainer.scaleY = 1;
			AnimationEngine.globalAnimator.animateConstantBubbling([tipButtonContainer], 300, AnimationEngine.globalAnimator.currentTime, 0.2);
		}
		
		public function showButtonForTip(needShowGuideToolTipForTipsFlag:Boolean = false):void
		{
			tipButtonContainer.removeAllChildren();
			
			// adding button
			tipButton.x = -tipButton.width / 2;
			tipButton.y = -tipButton.height / 2;
			tipButtonContainer.addChild(tipButton);
			
			AnimationEngine.globalAnimator.executeFunction(syncBubblingAnimation, null, AnimationEngine.globalAnimator.currentTime + 300);
			
			if (needShowGuideToolTipForTipsFlag)
				showToolTipForTipButton();
			
			// need to apply correct scale for animation
			tipButtonContainer.scaleX = 0.2;
			tipButtonContainer.scaleY = 0.2;
			AnimationEngine.globalAnimator.animatePopping([tipButtonContainer], 0.2, 1.2, 300, AnimationEngine.globalAnimator.currentTime);
			
			updateButtonsPositions();
			
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_POP);
		}
		
		private function showToolTipForTipButton():void
		{
			var tooltip:* = ToolTipService.setTooltipWaitingForClick(tipButton, new ToolTipInfo(tipButton, new ToolTipSimpleContentDescriptor(null, ["GAME TIP!"], null, null, new FontDescriptor(14, 0x1D38F8, FontResources.KOMTXTB)), ToolTipInfo.POSITION_RIGHT, true), HintToolTip, this.parent.parent);
			AnimationEngine.globalAnimator.animateConstantBubbling([tooltip], 300, AnimationEngine.globalAnimator.currentTime, 0.1);
		}
		
		/// clear buttons
		
		public function clearToolBar():void
		{
			clearNewEnemyButton();
			clearTipButton();
		}
		
		public function clearNewEnemyButton():void
		{
			newEnemyButtonContainer.removeAllChildren();
			
			AnimationEngine.globalAnimator.stopAnimationForObject(newEnemyButtonContainer);
			
			updateButtonsPositions();
			updateToolTipForTipButton();
			
			var tooltip:* = ToolTipService.getToolTipAssignedForComponent(newEnemyButton);
			if (tooltip)
				AnimationEngine.globalAnimator.stopAnimationForObject(tooltip);
			
			// in case there was some tooltip assigned to this button, it needs to be removed
			ToolTipService.removeAllTooltipsForComponent(newEnemyButton);
		}
		
		public function clearTipButton():void
		{
			tipButtonContainer.removeAllChildren();
			
			AnimationEngine.globalAnimator.stopAnimationForObject(tipButtonContainer);
			
			updateButtonsPositions();
			
			var tooltip:* = ToolTipService.getToolTipAssignedForComponent(tipButton);
			if (tooltip)
				AnimationEngine.globalAnimator.stopAnimationForObject(tooltip);
			
			// in case there was some tooltip assigned to this button, it needs to be removed
			ToolTipService.removeAllTooltipsForComponent(tipButton);
		}
		
		//////////// working with positioning
		
		public function updateButtonsPositions():void
		{
			// if a button for new enemy is shown, need to shift the tip button
			tipButtonContainer.y = (newEnemyButtonContainer.numChildren > 0) ? 80 : 0;
		}
		
		private function updateToolTipForTipButton():void
		{
			// need to update tooltip if there is some assigned
			if (tipButtonContainer.numChildren > 0)
			{
				var tooltip:* = ToolTipService.getToolTipAssignedForComponent(tipButton);
				if (tooltip)
				{
					AnimationEngine.globalAnimator.stopAnimationForObject(tooltip);
					ToolTipService.removeAllTooltipsForComponent(tipButton);
					showToolTipForTipButton();
				}
			}
		}
	
	}

}