/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import islandBreak.controllers.WeaponController;
	import events.WeaponEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nslib.animation.engines.AnimationEngine;
	import nslib.sequencers.MultiSequencer;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyBomberTank extends EnemyTrackedTankBase
	{
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/light bomber f01.png")]
		private static var lightBomberF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/light bomber f02.png")]
		private static var lightBomberF02Image:Class;
		
		//////////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/heavy bomber f01.png")]
		private static var heavyBomberF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/heavy bomber f02.png")]
		private static var heavyBomberF02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/heavy bomber f03.png")]
		private static var heavyBomberF03Image:Class;
		
		/////////////////////////////////////////////////////
		
		public function EnemyBomberTank(level:int = 0)
		{
			super(WeaponResources.ENEMY_BOMBER_TANK, level);
		}
		
		////////////////////////////////////////////////////////////
		
		private var shootCount:int = 0;
		
		override protected function tryFire():void
		{
			if (!hitTarget || shootDelayTimer.running)
				return;
			
			dispatchEvent(new WeaponEvent(WeaponEvent.FIRE));
			
			if (currentInfo.level == 1)
			{
				shootingOffsetX = offsets[shootCount % 2].x;
				shootingOffsetY = offsets[shootCount % 2].y;
				
				base.playState("" + (shootCount % 2));
				
				shootCount++;
			}
			else
			{
				base.playState("0");
			}
			
			fireBullet(x + shootingOffsetX * bodyAngleCos - shootingOffsetY * bodyAngleSin, y + shootingOffsetX * bodyAngleSin + shootingOffsetY * bodyAngleCos);
			
			shootDelayTimer.start();
			
			AnimationEngine.globalAnimator.executeFunction(resetVisualState, null, AnimationEngine.globalAnimator.currentTime + 1000);
		}
		
		private function resetVisualState():void
		{
			base.playState("-1");
		}
		
		protected function fireBullet(x:int, y:int):void
		{
			var params:Object = new Object();
			params.hitPower = currentInfo.hitPower;
			params.type = currentInfo.weaponType;
			
			WeaponController.launchCannonBall(x, y, hitTarget.x, hitTarget.y, 2000, params);
		}
		
		////////////////////////////////////////////////////////////
		
		private var base:MultiSequencer = new MultiSequencer();
		
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
			base.removeAllStates();
			var tempImage:Bitmap = new lightBomberF01Image() as Bitmap;
			base.x = tempImage.height / 2;
			base.y = -tempImage.width / 2;
			base.rotation = 90;
			base.smoothing = true;
			
			base.addStateAsImage("-1", lightBomberF01Image);
			base.addStateAsImage("0", lightBomberF02Image);
			
			base.playState("-1");
			
			shootingOffsetX = -5;
			shootingOffsetY = 0;
			
			body.addChild(base);
			
			addChild(body);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private var offsets:Array = [];
		
		override protected function drawWeaponLevel1():void
		{
			prebuild();
			createTracks();
			
			//base
			base.removeAllStates();
			var tempImage:Bitmap = new heavyBomberF01Image() as Bitmap;
			base.x = tempImage.height / 2;
			base.y = -tempImage.width / 2;
			base.rotation = 90;
			base.smoothing = true;
			
			base.addStateAsImage("-1", heavyBomberF01Image);
			base.addStateAsImage("0", heavyBomberF02Image);
			base.addStateAsImage("1", heavyBomberF03Image);
			
			offsets.length = 0;
			offsets.push({x: -5, y: -5});
			offsets.push({x: 5, y: -5});
			
			base.playState("-1");
			
			body.addChild(base);
			
			addChild(body);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			stopTracks();
			base.stopAllStates();
		}
	}

}