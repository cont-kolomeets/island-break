/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import nslib.animation.engines.AnimationEngine;
	import nslib.sequencers.ImageSequencer;
	import nslib.sequencers.MultiSequencer;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	import supportClasses.resources.WeaponResources;
	import weapons.base.IWeapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyRepairTank extends EnemyTrackedTankBase
	{
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/repair tank f01.png")]
		private static var tank01BaseF01:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/repair tank f02.png")]
		private static var tank01BaseF02:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/repair tank f03.png")]
		private static var tank01BaseF03:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/repair tank f04.png")]
		private static var tank01BaseF04:Class;
		
		/////////////////////////////////////////////////////
		
		public function EnemyRepairTank(level:int = 0)
		{
			super(WeaponResources.ENEMY_REPAIR_TANK, level);
		}
		
		////////////////////////////////////////////////////////////
		
		private var delayTimer:AdvancedTimer = new AdvancedTimer(500, 1);
		
		private var itemDictionary:Dictionary = new Dictionary();
		
		public function notifyRepairing(target:IWeapon):void
		{
			base.playState("repair");
			
			delayTimer.reset();
			delayTimer.start();
			delayTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, delayTimer_completedHandler);
			
			if (this.parent && itemDictionary[target] == undefined)
			{
				var repairSpark:Shape = new Shape();
				
				repairSpark.graphics.beginFill(0xA966FB, 0.7);
				repairSpark.graphics.drawCircle(0, 0, 4);
				
				this.parent.addChild(repairSpark);
				
				// need to shoot one spark per item
				itemDictionary[target] = true;
				
				// rough assumptions the target object has the same parent as this one
				AnimationEngine.globalAnimator.moveObjects(repairSpark, this.x, this.y, target.x, target.y, 1000, AnimationEngine.globalAnimator.currentTime);
				AnimationEngine.globalAnimator.removeFromParent(repairSpark, this.parent, AnimationEngine.globalAnimator.currentTime + 1000);
				
				var clearHashFunction:Function = function(item:IWeapon):void
				{
					delete itemDictionary[item];
				}
				
				AnimationEngine.globalAnimator.executeFunction(clearHashFunction, [target], AnimationEngine.globalAnimator.currentTime + 1000);
			}
		}
		
		private function delayTimer_completedHandler(event:AdvancedTimerEvent):void
		{
			delayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, delayTimer_completedHandler);
			
			base.playState("still");
		}
		
		////////////////////
		
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
			base.addStateAsImage("still", tank01BaseF01);
			
			var repairSequence:ImageSequencer = new ImageSequencer();
			repairSequence.addImages([tank01BaseF02, tank01BaseF03, tank01BaseF04]);
			repairSequence.frameRate = 10;
			repairSequence.playInLoop = true;
			
			base.addState("repair", repairSequence);
			
			base.playState("still");
			
			var tempImage:Bitmap = new tank01BaseF01() as Bitmap;
			base.x = tempImage.height / 2;
			base.y = -tempImage.width / 2;
			base.rotation = 90;
			base.smoothing = true;
			
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
			
			if (base)
				base.stopAllStates();
		}
	}

}