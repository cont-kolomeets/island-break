/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses
{
	import islandBreak.controllers.WeaponController;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BombLauncher
	{
		private static var explosionX:int = 0;
		
		private static var explosionY:int = 0;
		
		private static var offset:int = 20;
		
		public static function launchBomb(x:int, y:int, level:int = 0):void
		{
			explosionX = x;
			explosionY = y;
			
			switch (level)
			{
				case 0: 
					launchBombLevel0();
					break;
				case 1: 
					launchBombLevel1();
					break;
				case 2: 
					launchBombLevel2();
					break;
			}
		
		}
		
		private static function launchBombLevel0():void
		{
			WeaponController.putDevastatingExplosion(explosionX, explosionY, 7);
		}
		
		private static function launchBombLevel1():void
		{
			WeaponController.putDevastatingExplosion(explosionX - offset, explosionY, 7);
			WeaponController.putDevastatingExplosion(explosionX + offset, explosionY, 7);
		}
		
		private static function launchBombLevel2():void
		{
			WeaponController.putDevastatingExplosion(explosionX, explosionY - offset, 7);
			WeaponController.putDevastatingExplosion(explosionX - offset, explosionY + offset / 2, 7);
			WeaponController.putDevastatingExplosion(explosionX + offset, explosionY + offset / 2, 7);
		}
	}

}