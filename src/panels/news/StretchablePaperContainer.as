/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.news
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class StretchablePaperContainer extends NSSprite
	{
		///////////
		
		[Embed(source="F:/Island Defence/media/images/common images/paper big.png")]
		private static var baseFrameImage:Class;
		
		///////////
		
		public var animationEngine:AnimationEngine = null;
		
		public var transitionDuration:Number = 300;
		
		public var poppingDuration:Number = 1000;
		
		private var baseFrame:Bitmap = null;
		
		///////////
		
		public function StretchablePaperContainer()
		{
			construct();
		}
		
		///////////
		
		private var _widthAfterAnimation:Number = NaN;
		
		public function get widthAfterAnimation():Number
		{
			return _widthAfterAnimation;
		}
		
		/////
		
		private var _heightAfterAnimation:Number = NaN;
		
		public function get heightAfterAnimation():Number
		{
			return _heightAfterAnimation;
		}
		
		///////////
		
		private function construct():void
		{
			baseFrame = new baseFrameImage() as Bitmap;
			baseFrame.smoothing = true;
			//baseFrame.filters = [new DropShadowFilter(0, 0, 0x796A13, 1, 5, 5, 10)];
			
			baseFrame.x = -baseFrame.width / 2;
			baseFrame.y = -baseFrame.height / 2;
			addChild(baseFrame);
		}
		
		///////////
		
		public function resetScale():void
		{
			scaleX = 1;
			scaleY = 1;
		}
		
		// can be either popping or smooth transition
		public function showTransitionAnimation(isPoping:Boolean = true, objectToFit:DisplayObject = null, borderH:Number = 0, borderV:Number = 0, prefferredHeight:Number = NaN):void
		{
			var xScaleMemo:Number = scaleX;
			var yScaleMemo:Number = scaleY;
			
			resetScale();
			
			var xScaleRatio:Number = 1;
			var yScaleRatio:Number = 1;
			
			// bubbling of the frame base
			if (objectToFit)
			{
				xScaleRatio = Math.max((objectToFit.width + borderH * 2), 500) / width;
				yScaleRatio = (isNaN(prefferredHeight) ? (objectToFit.height + borderV * 2) : prefferredHeight) / height;
			}
			else if (!isNaN(prefferredHeight))
				yScaleRatio = prefferredHeight / height;
			
			scaleX = xScaleRatio;
			scaleY = yScaleRatio;
			
			// remember for other components
			_widthAfterAnimation = width;
			_heightAfterAnimation = height;
			
			// this is done so that uneven line in the paper can conver sticking buttons a little less.
			if (!isNaN(prefferredHeight))
			{
				yScaleRatio *= 0.95;
				scaleY = yScaleRatio;
			}
			
			if (isPoping)
			{
				alpha = 0;
				scaleX = 0.3;
				scaleY = 0.1;
				animationEngine.animateProperty(this, "alpha", 0, 1, NaN, 100, animationEngine.currentTime + 100);
				animationEngine.scaleObjects(this, 0.3, 0.1, 1.1 * xScaleRatio, 1.1 * yScaleRatio, 300, animationEngine.currentTime + 100);
				animationEngine.scaleObjects(this, 1.1 * xScaleRatio, 1.1 * yScaleRatio, xScaleRatio, yScaleRatio, 120, animationEngine.currentTime + 400); // back motion
			}
			else
			{
				scaleX = xScaleMemo;
				scaleY = yScaleMemo;
				animationEngine.scaleObjects(this, xScaleMemo, yScaleMemo, xScaleRatio, yScaleRatio, transitionDuration, animationEngine.currentTime);
			}
		}
	}

}