/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import nslib.animation.engines.AnimationEngine;
	import nslib.sequencers.ImageSequencer;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyTrackedTankBase extends Weapon
	{
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/track 01 f01.png")]
		private static var trackF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/track 01 f02.png")]
		private static var trackF02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/track 01 f03.png")]
		private static var trackF03Image:Class;
		
		/////////////////////////////////////////////////////
		
		public function EnemyTrackedTankBase(weaponId:String = null, level:int = 0)
		{
			super(weaponId, level);
		}
		
		////////////////////////////////////////////////////////////
		
		private var trackLeft:ImageSequencer = new ImageSequencer();
		
		private var trackRight:ImageSequencer = new ImageSequencer();
		
		protected function createTracks(scale:Number = 1, offsetX:Number = 0):void
		{
			trackLeft.removeAllImages();
			trackLeft.addImages([trackF03Image, trackF02Image, trackF01Image]);
			trackLeft.start();
			trackLeft.smoothing = true;
			
			trackLeft.rotation = 90;
			trackLeft.scaleX = scale;
			trackLeft.scaleY = scale;
			trackLeft.x = (trackLeft.height * scaleY) / 2 + offsetX;
			trackLeft.y = -(trackLeft.width * scaleY) / 2 + 15 * scale;
			
			body.addChild(trackLeft);
			
			trackRight.removeAllImages();
			trackRight.addImages([trackF01Image, trackF02Image, trackF03Image]);
			trackRight.start();
			trackRight.smoothing = true;
			
			trackRight.rotation = 90;
			trackRight.scaleX = scale;
			trackRight.scaleY = scale;
			trackRight.x = (trackRight.height * scaleY) / 2 + offsetX;
			trackRight.y = -(trackRight.width * scaleY) / 2 - 15 * scale;
			
			body.addChild(trackRight);
		}
		
		protected function stopTracks():void
		{
			trackLeft.stop();
			trackRight.stop();
		}
		
		// animated destroy
		
		/*override protected function drawPartsExplosion():void
		{
			if (!parent || currentInfo.level == 2)
				return;
			
			var initRotation:Number = bodyAngle + Math.PI / 2;
			
			for (var i:int = 0; i < 2; i++)
			{
				var track:DisplayObject = i == 0 ? trackLeft : trackRight;

				initRotation += Math.PI;
				var dist:Number = 25 + 25 * Math.random();
				AnimationEngine.globalAnimator.moveObjects(track, x + track.x, y + track.y, x + track.x + dist * Math.cos(initRotation), y + track.y + dist * Math.sin(initRotation), 500);
				AnimationEngine.globalAnimator.animateProperty(track, "alpha", 1, 0, NaN, 150, AnimationEngine.globalAnimator.currentTime + 350);
				AnimationEngine.globalAnimator.removeFromParent(track, parent, AnimationEngine.globalAnimator.currentTime + 500);
				
				parent.addChild(track);
			}
		}*/
	}

}