/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import constants.WeaponContants;
	import events.WeaponEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nslib.sequencers.ImageSequencer;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyPlaneFactory extends EnemyTrackedTankBase
	{
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/plane factory f01.png")]
		private static var planeCreator01F01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/plane factory f02.png")]
		private static var planeCreator01F02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/plane factory f03.png")]
		private static var planeCreator01F03Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/plane factory f04.png")]
		private static var planeCreator01F04Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/plane factory f05.png")]
		private static var planeCreator01F05Image:Class;
		
		/////////////////////////////////////////////////////
		
		public function EnemyPlaneFactory(level:int = 0)
		{
			super(WeaponResources.ENEMY_FACTORY_TANK, level);
		}
		
		////////////////////////////////////////////////////////////
		
		private var base:ImageSequencer = new ImageSequencer();
		
		private function prebuild():void
		{
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			// in case this object is returned for reuse
			removeAllChildren();
			
			// clear the previous level
			body.removeAllChildren();
			head.removeAllChildren();
		}
		
		override protected function drawWeaponLevel0():void
		{
			prebuild();
			createTracks();
			
			//base
			base.removeAllImages();
			base.addImages([planeCreator01F01Image, planeCreator01F02Image, planeCreator01F03Image, planeCreator01F04Image, planeCreator01F05Image]);
			base.x = base.height / 2;
			base.y = -base.width / 2;
			base.rotation = 90;
			base.smoothing = true;
			base.playInLoop = false;
			base.frameRate = 10;
			
			body.addChild(base);
			
			addChild(body);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
			
			creationDelayTimer.addEventListener(AdvancedTimerEvent.REPETITION_COMPLETED, creationDelayTimer_repetitionCompletedHanler);
			creationDelayTimer.start();
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			creationDelayTimer.removeEventListener(AdvancedTimerEvent.REPETITION_COMPLETED, creationDelayTimer_repetitionCompletedHanler);
			
			creationDelayTimer.reset();
			
			stopTracks();
		}
		
		/////////////////////////////
		
		private var creationDelayTimer:AdvancedTimer = new AdvancedTimer(WeaponContants.DEFAULT_PLANE_CREATION_FROM_FACTORY_COOL_DOWN);
		
		private function creationDelayTimer_repetitionCompletedHanler(event:AdvancedTimerEvent):void
		{
			base.addEventListener(ImageSequencer.STOPPED, base_stoppedHandler);
			base.start();
		}
		
		private function base_stoppedHandler(event:Event):void
		{
			base.removeEventListener(ImageSequencer.STOPPED, base_stoppedHandler);
			dispatchEvent(new WeaponEvent(WeaponEvent.CREATE_PLANE_FROM_FACTORY));
			
			// need to the sequence play back
			base.reverseBitmapSequence();
			base.addEventListener(ImageSequencer.STOPPED, base_backPlayStoppedHandler);
			base.start();
		}
		
		private function base_backPlayStoppedHandler(event:Event):void
		{
			base.removeEventListener(ImageSequencer.STOPPED, base_backPlayStoppedHandler);
			base.reverseBitmapSequence();
		}
	}

}