/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import controllers.SoundController;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nslib.animation.engines.LoopAnimator;
	import nslib.controls.NSSprite;
	import nslib.sequencers.ImageSequencer;
	import supportClasses.animation.ConstantRotator;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.WeaponResources;
	import weapons.base.ElectricCannonBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyEnergyBall extends ElectricCannonBase
	{
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 01 f01.png")]
		private static var blueEnergyBall01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 01 f02.png")]
		private static var blueEnergyBall02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 01 f03.png")]
		private static var blueEnergyBall03Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 01 f04.png")]
		private static var blueEnergyBall04Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 01 f05.png")]
		private static var blueEnergyBall05Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 01 f06.png")]
		private static var blueEnergyBall06Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 01 f07.png")]
		private static var blueEnergyBall07Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 01 f08.png")]
		private static var blueEnergyBall08Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 01 f09.png")]
		private static var blueEnergyBall09Image:Class;
		
		////////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 02 f01.png")]
		private static var violetEnergyBall01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 02 f02.png")]
		private static var violetEnergyBall02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 02 f03.png")]
		private static var violetEnergyBall03Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 02 f04.png")]
		private static var violetEnergyBall04Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 02 f05.png")]
		private static var violetEnergyBall05Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 02 f06.png")]
		private static var violetEnergyBall06Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 02 f07.png")]
		private static var violetEnergyBall07Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/energy balls/energy ball 02 f08.png")]
		private static var violetEnergyBall08Image:Class;
		
		/////////////////////////////////////////////////////
		
		public function EnemyEnergyBall(level:int = 0)
		{
			super(WeaponResources.ENEMY_ENERGY_BALL, level);
		}
		
		//////////
		
		override protected function fireBullet(x:int, y:int):void 
		{
			super.fireBullet(x, y);
			
			// adding sounds
			SoundController.instance.playSound(SoundResources.SOUND_SHOCK_SINGLE_01, 0.3);
		}
		
		////////////////////////////////////////////////////////////
		
		override protected function animateGun():void
		{
			// there is no gun here to animate
		}
		
		////////////
		
		private var base:ImageSequencer = new ImageSequencer();
		
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
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
		}
		
		override protected function drawWeaponLevel0():void
		{
			//base
			base.removeAllImages();
			base.addImages([blueEnergyBall01Image, blueEnergyBall02Image, blueEnergyBall03Image, blueEnergyBall04Image, blueEnergyBall05Image, blueEnergyBall06Image, blueEnergyBall07Image, blueEnergyBall08Image, blueEnergyBall09Image]);
			base.frameRate = 10;
			base.playInLoop = true;
			
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			base.smoothing = true;
			base.start();
			
			rebuildParts();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private var rotator:ConstantRotator = null;
		
		override protected function drawWeaponLevel1():void
		{
			//base
			base.removeAllImages();
			base.addImages([violetEnergyBall01Image, violetEnergyBall02Image, violetEnergyBall03Image, violetEnergyBall04Image, violetEnergyBall05Image, violetEnergyBall06Image, violetEnergyBall07Image, violetEnergyBall08Image, violetEnergyBall07Image, violetEnergyBall06Image, violetEnergyBall05Image, violetEnergyBall04Image, violetEnergyBall03Image, violetEnergyBall02Image]);
			base.frameRate = 10;
			base.playInLoop = true;
			
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			base.smoothing = true;
			base.start();
			
			rebuildParts();
			
			// creating a contaner for rotation
			
			body.removeAllChildren();
			
			var container:NSSprite = new NSSprite();
			
			container.addChild(base);
			body.addChild(container);
			
			rotator = new ConstantRotator(container, 10);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		//////////
				
		private var loopAnimator:LoopAnimator = new LoopAnimator();
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
						
			var sparkSoundFunction:Function = function():void
			{
				SoundController.instance.playSound(SoundResources.SOUND_ELECTRIC_BALL_01, 0.15);
			}
			
			loopAnimator.registerFunctionToExecute(sparkSoundFunction, null, 5000);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			if (base)
				base.stop();
			
			if (rotator)
				rotator.stopRotation();
				
			loopAnimator.clear();
		}
	
	}

}