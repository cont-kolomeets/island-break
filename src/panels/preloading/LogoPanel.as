/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.preloading
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import nslib.utils.AlignUtil;
	import nslib.utils.FontDescriptor;
	import panels.common.MessageNotifier;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class LogoPanel extends NSSprite
	{
		public static const LOGO_ANIMATION_COMPLETED:String = "logoAnimationCompleted";
		
		[Embed(source="F:/Island Defence/media/images/common images/logo cube.jpg")]
		private static var logoCubeImage:Class;
		
		/////
		
		private var messageNotifier:MessageNotifier = new MessageNotifier();
		
		/////
		
		public function LogoPanel()
		{
			construct();
		}
		
		//////
		
		private function construct():void
		{
			// drawing white background
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			
			var cube:Bitmap = new logoCubeImage();
			
			AlignUtil.centerSimple(cube, this);
			
			addChild(cube);
			
			messageNotifier.workingLayer = this;
			messageNotifier.stayDuration = 0;
			messageNotifier.offsetY = 130;
		}
		
		public function showLogoAnimation():void
		{
			messageNotifier.showScreenNotification("MULTISIDED", new FontDescriptor(50, 0, FontResources.YARDSALE));
			
			AnimationEngine.globalAnimator.executeFunction(dispatchCompletedEvent, null, AnimationEngine.globalAnimator.currentTime + 6000);
		}
		
		private function dispatchCompletedEvent():void
		{
			dispatchEvent(new Event(LOGO_ANIMATION_COMPLETED));
		}
	
	}

}