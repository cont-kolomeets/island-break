/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import controllers.SoundController;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.WeaponResources;
	import weapons.base.CannonBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyTank extends CannonBase
	{
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/tank 01 base.png")]
		private static var tank01BaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/tank 01 head.png")]
		private static var tank01HeadImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/tank 01 gun.png")]
		private static var tank01GunImage:Class;
		
		/////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/tank 02 base.png")]
		private static var tank02BaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/tank 02 head.png")]
		private static var tank02HeadImage:Class;
		
		////////////////////////////
		
		public function EnemyTank(level:int = 0)
		{
			super(WeaponResources.ENEMY_TANK, level);
		}
		
		///////////
		
		override protected function fireBullet(x:int, y:int):void
		{
			super.fireBullet(x, y);
			
			// adding sounds
			if (currentInfo.level == 0)
				SoundController.instance.playSound(SoundResources.SOUND_CANNON_SHOOT_01);
			else if (currentInfo.level == 1)
				SoundController.instance.playSound(SoundResources.SOUND_CANNON_SHOOT_02, 0.5);
		}
		
		///////////
		
		override protected function animateGun():void
		{
			if (!headPart)
				return;
			
			var speed:Number = 100;
			
			if (headPart && gun)
			{
				AnimationEngine.globalAnimator.moveObjects(gun, gun.x, gun.y, gun.x - 5, gun.y, speed);
				AnimationEngine.globalAnimator.moveObjects(gun, gun.x - 5, gun.y, gun.x, gun.y, speed, AnimationEngine.globalAnimator + speed);
				
				AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x, headPart.y, headPart.x - 3, headPart.y, speed);
				AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x - 3, headPart.y, headPart.x, headPart.y, speed, AnimationEngine.globalAnimator + speed);
			}
			else
			{
				AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x, headPart.y, headPart.x - 4, headPart.y, speed);
				AnimationEngine.globalAnimator.moveObjects(headPart, headPart.x - 4, headPart.y, headPart.x, headPart.y, speed, AnimationEngine.globalAnimator + speed);
			}
		}
		
		//------------------------------------------------------------------------------
		//
		// Drawing levels
		//
		//------------------------------------------------------------------------------
		
		private var base:Bitmap = null;
		
		private function rebuildParts():void
		{
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			// in case this object is returned for reuse
			removeAllChildren();
			
			// clear the previous level
			body.removeAllChildren();
			head.removeAllChildren();
			
			addChild(body);
			body.addChild(base);
			
			if (gun)
				head.addChild(gun);
			
			head.addChild(headPart);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
		}
		
		override protected function drawWeaponLevel0():void
		{
			base = new tank01BaseImage() as Bitmap;
			base.rotation = 90;
			base.x = base.width / 2;
			base.y = -base.height / 2;
			base.smoothing = true;
			
			//head
			headPart = new tank01HeadImage() as Bitmap;
			//headPart.smoothing = true;
			headPart.x = headPart.height / 2 - 2;
			headPart.y = -headPart.width / 2;
			headPart.rotation = 90;
			headPart.smoothing = true;
			
			//gun
			gun = new tank01GunImage() as Bitmap;
			gun.x = headPart.height / 2 + gun.height / 2;
			gun.y = -gun.width / 2;
			gun.rotation = 90;
			gun.smoothing = true;
			
			rebuildParts();
			
			shootingOffsetX = 20;
			shootingOffsetY = 0;
		}
		
		override protected function drawWeaponLevel1():void
		{
			base = new tank02BaseImage() as Bitmap;
			base.rotation = 90;
			base.x = base.width / 2;
			base.y = -base.height / 2;
			base.smoothing = true;
			
			//head
			headPart = new tank02HeadImage() as Bitmap;
			headPart.smoothing = true;
			headPart.x = headPart.height / 2 - 2;
			headPart.y = -headPart.width / 2;
			headPart.rotation = 90;
			headPart.smoothing = true;
			
			gun = null;
			
			rebuildParts();
			
			shootingOffsetX = 20;
			shootingOffsetY = 3;
		}
		
		// animated destroy
		
		override protected function drawPartsExplosion():void
		{
			if (!parent)
				return;
			
			var head:NSSprite = currentInfo.level == 0 ? prepareHeadLevel0() : currentInfo.level == 1 ? prepareHeadLevel1() : null;
			
			AnimationEngine.globalAnimator.moveObjects(head, x, y, x + 50 - 100 * Math.random(), y + 50 - 100 * Math.random(), 500);
			AnimationEngine.globalAnimator.rotateObjects(head, head.rotation, head.rotation + 360, NaN, 500);
			AnimationEngine.globalAnimator.animateProperty(head, "alpha", 1, 0, NaN, 200, AnimationEngine.globalAnimator.currentTime + 300);
			AnimationEngine.globalAnimator.removeFromParent(head, parent, AnimationEngine.globalAnimator.currentTime + 500);
			
			parent.addChild(head);
		}
		
		private function prepareHeadLevel0():NSSprite
		{
			//head
			var head:NSSprite = new NSSprite();
			
			headPart = new tank01HeadImage() as Bitmap;
			//headPart.smoothing = true;
			headPart.x = headPart.height / 2 - 2;
			headPart.y = -headPart.width / 2;
			headPart.rotation = 90;
			headPart.smoothing = true;
			
			//gun
			gun = new tank01GunImage() as Bitmap;
			gun.x = headPart.height / 2 + gun.height / 2;
			gun.y = -gun.width / 2;
			gun.rotation = 90;
			gun.smoothing = true;
			
			head.addChild(gun);
			head.addChild(headPart);
			
			head.rotation = this.head.rotation;
			
			return head;
		}
		
		private function prepareHeadLevel1():NSSprite
		{
			//head
			var head:NSSprite = new NSSprite();
			
			headPart = new tank02HeadImage() as Bitmap;
			headPart.smoothing = true;
			headPart.x = headPart.height / 2 - 2;
			headPart.y = -headPart.width / 2;
			headPart.rotation = 90;
			headPart.smoothing = true;
			
			head.addChild(headPart);
			
			head.rotation = this.head.rotation;
			
			return head;
		}
	}

}