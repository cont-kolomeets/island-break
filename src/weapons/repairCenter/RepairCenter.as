/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.repairCenter
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import nslib.sequencers.ImageSequencer;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	import supportClasses.resources.WeaponResources;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class RepairCenter extends Weapon
	{
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 01 f01.png")]
		private static var repairCenter01frame01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 01 f02.png")]
		private static var repairCenter01frame02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 01 f03.png")]
		private static var repairCenter01frame03Image:Class;
		
		////////////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 02 f01.png")]
		private static var repairCenter02frame01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 02 f02.png")]
		private static var repairCenter02frame02Image:Class;
		
		////////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 still.png")]
		private static var repairCenter03StillImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 f01.png")]
		private static var repairCenter03frame01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 f02.png")]
		private static var repairCenter03frame02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 f03.png")]
		private static var repairCenter03frame03Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 f04.png")]
		private static var repairCenter03frame04Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 f05.png")]
		private static var repairCenter03frame05Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 f06.png")]
		private static var repairCenter03frame06Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 f07.png")]
		private static var repairCenter03frame07Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 f08.png")]
		private static var repairCenter03frame08Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/repair centers/repair center 03 f09.png")]
		private static var repairCenter03frame09Image:Class;
		
		////////////
		
		public function RepairCenter(level:int = 0)
		{
			super(WeaponResources.USER_REPAIR_CENTER, level);
		}
		
		////////////
		
		private var delayTimer:AdvancedTimer = new AdvancedTimer(500, 1);
		
		public function notifyRepairing():void
		{
			base.start();
			
			if (currentInfo.level == 2)
			{
				if (contains(stillImage))
					removeChild(stillImage);
				
				addChild(base);
			}
			
			delayTimer.reset();
			delayTimer.start();
			delayTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, delayTimer_completedHandler);
		}
		
		private function delayTimer_completedHandler(event:AdvancedTimerEvent):void
		{
			delayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, delayTimer_completedHandler);
			
			base.stop();
			
			if (currentInfo.level == 2)
			{
				if (contains(base))
					removeChild(base);
				addChild(stillImage);
			}
		}
		
		////////////
		
		private var stillImage:Bitmap = null;
		
		private var base:ImageSequencer = null;
		
		private function rebuildParts():void
		{
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			// in case this object is returned for reuse
			removeAllChildren();
			
			// clear the previous level
			head.removeAllChildren();
			
			addChild(base);
			
			addChild(energyBar);
			
			updateEnergyBar();
		}
		
		override protected function drawWeaponLevel0():void
		{
			//base
			base = new ImageSequencer();
			base.addImages([repairCenter01frame01Image, repairCenter01frame02Image, repairCenter01frame03Image]);
			base.frameRate = 5;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			base.playInLoop = true;
			
			rebuildParts();
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
		}
		
		override protected function drawWeaponLevel1():void
		{
			//base
			base = new ImageSequencer();
			base.addImages([repairCenter02frame01Image, repairCenter02frame02Image]);
			base.frameRate = 5;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			base.playInLoop = true;
			
			rebuildParts();
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
		}
		
		override protected function drawWeaponLevel2():void
		{
			//base
			base = new ImageSequencer();
			base.addImages([repairCenter03frame01Image, repairCenter03frame02Image, repairCenter03frame03Image, repairCenter03frame04Image, repairCenter03frame05Image, repairCenter03frame06Image, repairCenter03frame07Image, repairCenter03frame08Image, repairCenter03frame09Image]);
			base.frameRate = 5;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			base.playInLoop = true;
			
			stillImage = new repairCenter03StillImage() as Bitmap;
			stillImage.x = -stillImage.width / 2;
			stillImage.y = -stillImage.height / 2;
			
			rebuildParts();
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
		}
	
	}

}