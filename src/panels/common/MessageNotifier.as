/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.common
{
	import constants.GamePlayConstants;
	import flash.display.Shape;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MessageNotifier
	{
		public var workingLayer:NSSprite = null;
		
		// zero means infinity
		public var stayDuration:Number = 3000;
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		
		private var notificationField:CustomTextField = new CustomTextField(null, new FontDescriptor(50, 0xAC0ED3, FontResources.YARDSALE));
		private var notificationFieldMask:CustomTextField = new CustomTextField(null, new FontDescriptor(50, 0xAC0ED3, FontResources.YARDSALE));
		private var notificationFieldBackground:CustomTextField = new CustomTextField(null, new FontDescriptor(50, 0, FontResources.YARDSALE));
		private var bleach:Shape = new Shape();
		private var messageContainer:NSSprite = new NSSprite();
		
		public function clear():void
		{
			if (workingLayer.contains(messageContainer))
				workingLayer.removeChild(messageContainer);
		}
		
		public function showScreenNotification(text:String, fontDescriptor:FontDescriptor = null):void
		{
			if (workingLayer.contains(messageContainer))
				workingLayer.removeChild(messageContainer);
			
			if (fontDescriptor)
			{
				notificationField.fontDescriptor = fontDescriptor;
				notificationFieldMask.fontDescriptor = fontDescriptor;
				
				var bgFontDescriptor:FontDescriptor = fontDescriptor.copy();
				bgFontDescriptor.color = 0;
				
				notificationFieldBackground.fontDescriptor = bgFontDescriptor;
			}
			
			notificationField.text = text;
			notificationFieldMask.text = text;
			notificationFieldBackground.text = text;
			
			notificationFieldBackground.x = -notificationFieldBackground.width / 2 + 2;
			notificationFieldBackground.y = -notificationFieldBackground.height / 2 + 3;
			messageContainer.addChild(notificationFieldBackground);
			
			notificationField.x = -notificationField.width / 2;
			notificationField.y = -notificationField.height / 2;
			messageContainer.addChild(notificationField);
			
			notificationFieldMask.x = -notificationFieldMask.width / 2;
			notificationFieldMask.y = -notificationFieldMask.height / 2;
			messageContainer.addChild(notificationFieldMask);
			
			// adding on top
			messageContainer.x = GamePlayConstants.STAGE_WIDTH / 2 + offsetX;
			messageContainer.y = GamePlayConstants.STAGE_HEIGHT / 2 + offsetY;
			workingLayer.addChild(messageContainer);
			
			messageContainer.alpha = 0;
			AnimationEngine.globalAnimator.animateProperty(messageContainer, "alpha", 0, 0.8, NaN, 500, AnimationEngine.globalAnimator.currentTime + 1000);
			AnimationEngine.globalAnimator.scaleObjects(messageContainer, 5, 5, 1, 1, 500, AnimationEngine.globalAnimator.currentTime + 1000);
			
			if (stayDuration > 0)
			{
				AnimationEngine.globalAnimator.animateProperty(messageContainer, "alpha", 0.8, 0, NaN, 1000, AnimationEngine.globalAnimator.currentTime + stayDuration);
				AnimationEngine.globalAnimator.removeFromParent(messageContainer, workingLayer, AnimationEngine.globalAnimator.currentTime + stayDuration + 1000);
			}
			
			bleach.rotation = 30;
			
			bleach.graphics.beginFill(0xFFFFFF, 0.9);
			bleach.graphics.drawRect(0, 0, 30, 100);
			
			bleach.x = -notificationField.width / 2 - 50;
			bleach.y = -notificationField.height / 2 - 20;
			messageContainer.addChild(bleach);
			bleach.mask = notificationFieldMask;
			AnimationEngine.globalAnimator.moveObjects(bleach, bleach.x, bleach.y, bleach.x + notificationField.width + 100, bleach.y, 500, AnimationEngine.globalAnimator.currentTime + 1500);
		}
	
	}

}