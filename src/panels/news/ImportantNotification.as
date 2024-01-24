/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.news
{
	import flash.display.Bitmap;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.AlignUtil;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ImportantNotification extends NSSprite
	{
		
		[Embed(source="F:/Island Defence/media/images/common images/notification paper.png")]
		private static var paperImage:Class;
		
		////////////
		
		// local animation engine
		public var animationEngine:AnimationEngine = null;
		
		private var contentContainer:NSSprite = new NSSprite();
		
		private var paper:Bitmap = new paperImage() as Bitmap;
		
		private var notificationField:CustomTextField = new CustomTextField(null, new FontDescriptor(17, 0xFFFFFF, FontResources.KOMTXTB));
		
		public function ImportantNotification()
		{
			construct();
		}
		
		///////////////
		
		private var _notification:String = null;
		
		public function get notification():String
		{
			return notificationField.text;
		}
		
		public function set notification(value:String):void
		{
			notificationField.text = value;
			updateNotificationFieldPosition();
		}
		
		///////////////
		
		private function construct():void
		{
			paper.smoothing = true;
			AlignUtil.centerSimple(paper, contentContainer);
			
			contentContainer.addChild(paper);
			
			notificationField.textWidth = paper.width - 70;
			contentContainer.addChild(notificationField);
			
			this.addChild(contentContainer);
		}
		
		private function updateNotificationFieldPosition():void
		{
			AlignUtil.centerSimple(notificationField, null, 30);
		}
		
		public function popUpNotification(delay:Number):void
		{
			contentContainer.alpha = 0;
			contentContainer.scaleX = 0.7;
			contentContainer.scaleY = 0.7;
			
			animationEngine.animateProperty(contentContainer, "alpha", 0, 1, NaN, 100, animationEngine.currentTime + delay);
			animationEngine.scaleObjects(contentContainer, 0.7, 0.7, 1.1, 1.1, 300, animationEngine.currentTime + delay);
			animationEngine.scaleObjects(contentContainer, 1.1, 1.1, 1, 1, 200, animationEngine.currentTime + 300 + delay); // back animation
		}
	
	}

}