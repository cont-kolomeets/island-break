/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers 
{
	import nslib.core.Globals;
	import weapons.ammo.explosions.SequencedExplosion;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * PreloadController preloads objects for faster access from the objects pool to accelerate gameplay.
	 */
	public class PreloadController 
	{
		
		public function PreloadController() 
		{
			
		}
		
		public function startPreloadingForLevel(level:int):void
		{
			preloadExplosions();
		}
		
		private function preloadExplosions():void
		{
			for (var i:int = 0; i < 3; i++)
			{
				var explosion:SequencedExplosion = new SequencedExplosion(Globals.topLevelApplication, WeaponController.traceController);
				explosion.explode(-100, -100);
			}

		}
	}

}