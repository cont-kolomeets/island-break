/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.ammo.cannonBalls
{
	import islandBreak.controllers.WeaponController;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import nslib.sequencers.ImageSequencer;
	import supportClasses.WeaponType;
	import weapons.ammo.bullets.IBullet;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class CannonBall extends EventDispatcher implements IBullet
	{
		public static const LAUNCH_COMPLETED:String = "launchCompleted";
		
		//////////////////////////////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/common weapon/cannon ball.png")]
		private static var cannonBallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/common weapon/cannon ball shadow.png")]
		private static var cannonBallShadowImage:Class;
				
		// dust sequence
		
		[Embed(source="F:/Island Defence/media/images/common images/fire smoke/fire smoke f01.png")]
		private static var fireSmokeF01:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/fire smoke/fire smoke f02.png")]
		private static var fireSmokeF02:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/fire smoke/fire smoke f03.png")]
		private static var fireSmokeF03:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/fire smoke/fire smoke f04.png")]
		private static var fireSmokeF04:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/fire smoke/fire smoke f05.png")]
		private static var fireSmokeF05:Class;
		
		//////////////////////////////////
		
		public var container:NSSprite = null;
		
		private var ball:Bitmap = new cannonBallImage() as Bitmap;
		
		private var ballContainer:NSSprite = new NSSprite();
		
		private var ballShadow:Bitmap = new cannonBallShadowImage() as Bitmap;
		
		private var ballShadowContainer:NSSprite = new NSSprite();
		
		private var fireSmoke:ImageSequencer = new ImageSequencer();
		
		//////////////////////////////////
		
		public function CannonBall()
		{
			construct();
		}
		
		/////////////
		
		public function get x():Number
		{
			return ballContainer.x;
		}
		
		public function get y():Number
		{
			return ballContainer.y;
		}
		
		///////
		
		private var _type:String = WeaponType.NONE;
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		/////
		
		private var _hitPower:Number = 0;
		
		public function get hitPower():Number
		{
			return _hitPower;
		}
		
		public function set hitPower(value:Number):void
		{
			_hitPower = value;
		}
		
		//////////////////////////////////
		
		private function construct():void
		{
			ball.x = -ball.width / 2;
			ball.y = -ball.height / 2;
			ball.smoothing = true;
			ballContainer.addChild(ball);
			
			ballShadow.x = -ballShadow.width / 2;
			ballShadow.y = -ballShadow.height / 2;
			ballShadow.smoothing = true;
			ballShadowContainer.addChild(ballShadow);
			
			fireSmoke.removeAllImages();
			fireSmoke.clearOnStop = true;
			fireSmoke.playInLoop = false;
			fireSmoke.frameRate = 10;
			fireSmoke.addImages([fireSmokeF01, fireSmokeF02, fireSmokeF03, fireSmokeF04, fireSmokeF05]);
		}
		
		public function launchBall(fromX:Number, fromY:Number, toX:Number, toY:Number, duration:Number = 2000):void
		{
			container.addChild(fireSmoke);
			fireSmoke.x = fromX - fireSmoke.width / 2 + 1;
			fireSmoke.y = fromY - fireSmoke.height / 2;
			
			container.addChild(ballShadowContainer);
			container.addChild(ballContainer);
			
			AnimationEngine.globalAnimator.moveObjects(ballContainer, fromX, fromY, toX, toY, duration, AnimationEngine.globalAnimator.currentTime);
			
			AnimationEngine.globalAnimator.animateProperty(ballShadowContainer, "x", fromX, toX, NaN, duration, AnimationEngine.globalAnimator.currentTime, null, 1, shadowOffsetFunction, 1);
			AnimationEngine.globalAnimator.animateProperty(ballShadowContainer, "y", fromY, toY, NaN, duration, AnimationEngine.globalAnimator.currentTime, null, 1, shadowOffsetFunction, 1);
			
			AnimationEngine.globalAnimator.scaleObjects([ballContainer, ballShadowContainer], 0.2, 0.2, 1, 1, duration / 2, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.scaleObjects([ballContainer, ballShadowContainer], 1, 1, 0.2, 0.2, duration / 2, AnimationEngine.globalAnimator.currentTime + duration / 2);
			AnimationEngine.globalAnimator.executeFunction(explodeBall, null, AnimationEngine.globalAnimator.currentTime + duration);
			
			fireSmoke.stop();
			fireSmoke.start();
		}
		
		private function shadowOffsetFunction(progress:Number, factor:Number):Number
		{
			return (30 - ((progress - 0.5) * (progress - 0.5)) * 120);
		}
		
		private function explodeBall():void
		{
			if (container.contains(ballShadowContainer))
				container.removeChild(ballShadowContainer);
			
			if (container.contains(ballContainer))
				container.removeChild(ballContainer);
			
			WeaponController.putNormalExplosion(ballContainer.x, ballContainer.y);
			
			dispatchEvent(new Event(LAUNCH_COMPLETED));
		}
	
	}

}