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
	import weapons.base.ElectricCannonBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UserElectricTower extends ElectricCannonBase
	{
		///// basic
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/electric towers/electric tower 01 base.png")]
		private static var electricTower01BaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/electric towers/electric tower 01 head.png")]
		private static var electricTower01HeadImage:Class;
		
		///// intermediate
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/electric towers/electric tower 02.png")]
		private static var electricTower02Image:Class;
		
		///// advanced
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/electric towers/electric tower 03.png")]
		private static var electricTower03Image:Class;
		
		////////////////////////////////////////////////////////////
		
		public function UserElectricTower(level:int = 0)
		{
			super(WeaponResources.USER_ELECTRIC_TOWER, level);
		}
		
		override protected function fireBullet(x:int, y:int):void 
		{
			super.fireBullet(x, y);
			
			// adding sounds
			SoundController.instance.playSound(SoundResources.SOUND_SHOCK_SINGLE_01, 0.3);
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
			
			addChild(base);
			
			if (headPart)
			{
				head.addChild(headPart);
				addChild(head);
			}
			
			addChild(energyBar);
			
			updateEnergyBar();
		}
		
		override protected function drawWeaponLevel0():void
		{
			//base
			base = new electricTower01BaseImage() as Bitmap;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			
			//head
			headPart = new electricTower01HeadImage() as Bitmap;
			//headPart.smoothing = true;
			headPart.rotation = 90;
			headPart.x = headPart.width / 2;
			headPart.y = -headPart.height / 2;
			headPart.smoothing = true;
			
			rebuildParts();
			
			shootingOffsetX = 10;
			shootingOffsetY = 0;
		}
		
		override protected function drawWeaponLevel1():void
		{
			//base
			base = new electricTower02Image() as Bitmap;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			
			headPart = null;
			
			rebuildParts();
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
		}
		
		override protected function drawWeaponLevel2():void
		{
			//base
			base = new electricTower03Image() as Bitmap;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			
			headPart = null;
			
			rebuildParts();
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
		}
	}

}