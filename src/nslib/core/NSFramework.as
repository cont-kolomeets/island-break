/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.core 
{
	import nslib.animation.DeltaTime;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import nslib.utils.MouseUtil;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class NSFramework 
	{
		/**
		 * This function should be called when the application starts.
		 * @param	mainSprite The main sprite of the application
		 */
		public static function initialize(mainSprite:NSSprite):void
		{
			DeltaTime.globalDeltaTimeCounter = new DeltaTime(mainSprite);
			AnimationEngine.globalAnimator = new AnimationEngine();
			AnimationEngine.globalAnimator.reset();
			MouseUtil.initialize(mainSprite.stage);
			Globals.topLevelApplication = mainSprite;
			Globals.stage = mainSprite.stage;
		}
		
	}

}