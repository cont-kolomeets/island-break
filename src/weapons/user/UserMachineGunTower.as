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
	import weapons.base.MachineGunBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UserMachineGunTower extends MachineGunBase
	{
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/machine guns/machine gun base.png")]
		private static var machineGunBaseImage:Class;
		
		///// basic
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/machine guns/machine gun 01 head.png")]
		private static var machineGun01HeadImage:Class;
		
		///// intermediate
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/machine guns/machine gun 02 head.png")]
		private static var machineGun02HeadImage:Class;
		
		///// advanced
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/machine guns/machine gun 03 head.png")]
		private static var machineGun03HeadImage:Class;
		
		//////////////////////////////////////
		
		public function UserMachineGunTower(level:int = 0)
		{
			super(WeaponResources.USER_MACHINE_GUN, level);
		}
		
		override protected function fireBullet(x:int, y:int):void
		{
			super.fireBullet(x, y);
			
			// adding sounds
			if (currentInfo.level == 0)
				SoundController.instance.playSound(SoundResources.SOUND_MACHINE_GUN_SLOW_SEQUENCE, 0.2);
			else if (currentInfo.level == 1)
				SoundController.instance.playSound(SoundResources.SOUND_MACHINE_GUN_AVERAGE_SEQUENCE, 0.2);
			else if (currentInfo.level == 2)
				SoundController.instance.playSound(SoundResources.SOUND_MACHINE_GUN_AVERAGE_SEQUENCE, 0.2);
		}
		
		override protected function enemyDetected():void
		{
			super.enemyDetected();
			
			SoundController.instance.playSound(SoundResources.SOUND_WEAPON_ACTIVATION_02);
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
				base = new machineGunBaseImage() as Bitmap;
				base.x = -base.width / 2;
				base.y = -base.height / 2;
			}
			addChildAt(base, 0);
			
			head.addChild(headPart);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
		}
		
		override protected function drawWeaponLevel0():void
		{
			//head
			headPart = new machineGun01HeadImage() as Bitmap;
			//headPart.smoothing = true;
			headPart.rotation = 90;
			headPart.x = headPart.width / 1.5;
			headPart.y = -headPart.height / 2;
			headPart.smoothing = true;
			
			rebuildParts();
			
			shootingOffsetX = 20;
			shootingOffsetY = 0;
		}
		
		override protected function drawWeaponLevel1():void
		{
			//head
			headPart = new machineGun02HeadImage() as Bitmap;
			//headPart.smoothing = true;
			headPart.x = headPart.height / 1.5;
			headPart.y = -headPart.width / 2;
			headPart.rotation = 90;
			headPart.smoothing = true;
			
			rebuildParts();
			
			shootingOffsetX = 20;
			shootingOffsetY = 5;
		}
		
		override protected function drawWeaponLevel2():void
		{
			//head
			headPart = new machineGun03HeadImage() as Bitmap;
			//headPart.smoothing = true;
			headPart.x = headPart.height / 1.5;
			headPart.y = -headPart.width / 2;
			headPart.rotation = 90;
			headPart.smoothing = true;
			
			rebuildParts();
			
			shootingOffsetX = 20;
			shootingOffsetY = 5;
		}
	
	}

}