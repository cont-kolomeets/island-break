/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.user
{
	import controllers.SoundController;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.WeaponResources;
	import weapons.base.CannonBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UserCannon extends CannonBase
	{
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/cannons/cannon base.png")]
		private static var cannonBaseImage:Class;
		
		///// basic
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/cannons/cannon 01 gun.png")]
		private static var cannon01GunImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/cannons/cannon 01 head.png")]
		private static var cannon01HeadImage:Class;
		
		///// intermediate
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/cannons/cannon 02 gun.png")]
		private static var cannon02GunImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/cannons/cannon 02 head.png")]
		private static var cannon02HeadImage:Class;
		
		///// advanced
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/cannons/cannon 03 gun.png")]
		private static var cannon03GunImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/cannons/cannon 03 head.png")]
		private static var cannon03HeadImage:Class;
		
		////////////////////////////////////////////////////////////
		
		public function UserCannon(level:int = 0)
		{
			super(WeaponResources.USER_CANNON, level);
		}
		
		////////////
		
		override protected function fireBullet(x:int, y:int):void 
		{
			super.fireBullet(x, y);
			
			// adding sounds
			SoundController.instance.playSound(SoundResources.SOUND_CANNON_SHOOT_01);
		}
		
		override protected function enemyDetected():void 
		{
			super.enemyDetected();
			
			SoundController.instance.playSound(SoundResources.SOUND_WEAPON_ACTIVATION_01);
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
			head.removeAllChildren();
			
			//base
			if (!base)
			{
				base = new cannonBaseImage() as Bitmap;
				base.x = -base.width / 2;
				base.y = -base.height / 2;
			}
			addChildAt(base, 0);
			
			head.addChild(gun);
			head.addChild(headPart);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
		}
		
		override protected function drawWeaponLevel0():void
		{
			//head
			headPart = new cannon01HeadImage() as Bitmap;
			//headStaticPart.smoothing = true;
			headPart.x = headPart.height / 2 - 2;
			headPart.y = -headPart.width / 2;
			headPart.rotation = 90;
			headPart.smoothing = true;
			
			//gun
			gun = new cannon01GunImage() as Bitmap;
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
			//head
			headPart = new cannon02HeadImage() as Bitmap;
			//headStaticPart.smoothing = true;
			headPart.x = headPart.height / 2 - 2;
			headPart.y = -headPart.width / 2;
			headPart.rotation = 90;
			headPart.smoothing = true;
			
			//gun
			gun = new cannon02GunImage() as Bitmap;
			gun.x = headPart.height / 2 + gun.height / 2;
			gun.y = -gun.width / 2;
			gun.rotation = 90;
			gun.smoothing = true;
			
			rebuildParts();
			
			shootingOffsetX = 25;
			shootingOffsetY = 3;
		}
		
		override protected function drawWeaponLevel2():void
		{
			//head
			headPart = new cannon03HeadImage() as Bitmap;
			//headStaticPart.smoothing = true;
			headPart.x = headPart.height / 2 - 2;
			headPart.y = -headPart.width / 2;
			headPart.rotation = 90;
			headPart.smoothing = true;
			
			//gun
			gun = new cannon03GunImage() as Bitmap;
			gun.x = headPart.height / 2 + gun.height / 2;
			gun.y = -gun.width / 2;
			gun.rotation = 90;
			gun.smoothing = true;
			
			rebuildParts();
			
			shootingOffsetX = 25;
			shootingOffsetY = 3;
			
			missileShootingOffsetX = 5;
			missileShootingOffsetY = 10;
		}
	}

}