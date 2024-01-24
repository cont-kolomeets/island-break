/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import controllers.SoundController;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nslib.animation.engines.AnimationEngine;
	import nslib.animation.engines.LoopAnimator;
	import nslib.controls.NSSprite;
	import supportClasses.animation.WalkingRobotAnimator;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.WeaponResources;
	import weapons.base.MachineGunBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyWalkingRobot extends MachineGunBase
	{
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/chicken base.png")]
		private static var chickenBaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/chicken leg L.png")]
		private static var chickenLeftLegImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/chicken leg R.png")]
		private static var chickenRightLegImage:Class;
		
		//[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/chicken gun.png")]
		//private static var chickenGunImage:Class;
		
		//////////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/mastadont middle part.png")]
		private static var mastadontMiddlePartImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/mastadont leg L.png")]
		private static var mastadontLeftLegImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/mastadont leg R.png")]
		private static var mastadontRightLegImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/mastadont rocket launcher.png")]
		private static var mastadontRocketLauncherImage:Class;
		
		////////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/turtle base.png")]
		private static var turtleBaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/turtle leg L.png")]
		private static var turtleLeftLegImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/walking/turtle leg R.png")]
		private static var turtleRightLegImage:Class;
		
		/////////////////////////////////////////////////////
		
		public function EnemyWalkingRobot(level:int = 0)
		{
			super(WeaponResources.ENEMY_WALKING_ROBOT, level);
		}
		
		////////////////////////////////////////////////////////////
		
		override protected function tryFire():void
		{
			//if (level == 1)
			//	return;
			
			super.tryFire();
		}
		
		override protected function fireBullet(x:int, y:int):void
		{
			super.fireBullet(x, y);
			
			// adding sounds
			if (currentInfo.level == 0)
				SoundController.instance.playSound(SoundResources.SOUND_MACHINE_GUN_SLOW_SEQUENCE, 0.2);
		}
		
		////////////////////////////////////////////////////////////
		
		private var walkAnimator:WalkingRobotAnimator = new WalkingRobotAnimator();
		
		// chicken
		override protected function drawWeaponLevel0():void
		{
			prebuild();
			
			registerRotatingShootingPart(chickenBaseImage);
			
			registerLeg(chickenLeftLegImage, 90, 0, -12, 10, 0, 670);
			registerLeg(chickenRightLegImage, 90, 0, 12, 10, 0.5, 670);
			
			shootingOffsetX = 10;
			shootingOffsetY = 15;
			
			addChild(body);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		// mastadont
		override protected function drawWeaponLevel1():void
		{
			prebuild();
			
			registerLeg(mastadontLeftLegImage, 90, 0, -13, 15, 0, 2000);
			registerLeg(mastadontRightLegImage, 90, 0, 13, 15, 0, 2000);
			registerLeg(mastadontMiddlePartImage, 90, 5, 0, 3, 0.5, 2000);
			
			// adding rocket launcher
			registerRotatingShootingPart(mastadontRocketLauncherImage);
			
			addChild(body);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		// turtle
		override protected function drawWeaponLevel2():void
		{
			prebuild();
			
			registerLeg(turtleLeftLegImage, 90, 0, -25, 15, 0, 3000);
			registerLeg(turtleRightLegImage, 90, 0, 25, 15, 0, 3000);
			registerLeg(turtleBaseImage, 90, 5, 0, 3, 0.5, 3000);
			
			shootingOffsetX = 10;
			shootingOffsetY = 15;
			
			addChild(body);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		/////////////////
		
		private function prebuild():void
		{
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			walkAnimator.clearAllAnimation();
			walkAnimator.startAllAnimation();
			
			// in case this object is returned for reuse
			removeAllChildren();
			
			// clear the previous level
			body.removeAllChildren();
			head.removeAllChildren();
		}
		
		private function registerMiddlePart(middlePartClass:Class, offsetX:Number):void
		{
			var middlePart:Bitmap = new middlePartClass() as Bitmap;
			middlePart.x = middlePart.height / 2 + offsetX;
			middlePart.y = -middlePart.width / 2;
			middlePart.rotation = 90;
			middlePart.smoothing = true;
			
			body.addChild(middlePart);
		}
		
		private function registerRotatingShootingPart(shootingPartClass:Class):void
		{
			var shootingPart:Bitmap = new shootingPartClass() as Bitmap;
			shootingPart.x = shootingPart.height / 2;
			shootingPart.y = -shootingPart.width / 2;
			shootingPart.rotation = 90;
			shootingPart.smoothing = true;
			head.addChild(shootingPart);
		}
		
		private function registerLeg(legClass:Class, rotation:Number, offsetX:Number, offsetY:Number, amplitude:Number, phase:Number, interval:Number):void
		{
			var leg:Bitmap = new legClass() as Bitmap;
			leg.smoothing = true;
			
			var container:NSSprite = new NSSprite();
			container.addChild(leg);
			
			leg.x = -leg.width / 2;
			leg.y = -leg.height / 2;
			
			container.rotation = rotation;
			container.x = offsetX;
			container.y = offsetY;
			
			body.addChild(container);
			
			walkAnimator.registerLegForMotion(container, amplitude, phase, interval, WalkingRobotAnimator.DIRECTION_HORIZONTAL);
		}
		
		private function tryRegisterSoundsForSteps(interval:Number, phase1:Number, phase2:Number):void
		{
			// need 2 instanses
			var stepSoundFunction1:Function = getStepSoundFunctionForLevel(currentInfo.level);
			var stepSoundFunction2:Function = getStepSoundFunctionForLevel(currentInfo.level);
			
			// set default values
			if (soundControlObject.level0 == undefined)
				soundControlObject.level0 = 0;
			
			if (soundControlObject.level1 == undefined)
				soundControlObject.level1 = 0;
			
			if (soundControlObject.level2 == undefined)
				soundControlObject.level2 = 0;
			
			switch (currentInfo.level)
			{
				case 0: 
					soundControlObject.level0++;
					
					if (soundControlObject.level0 == 1)
					{
						loopAnimatorStep0.start();
						loopAnimatorStep0.registerFunctionToExecute(stepSoundFunction1, [soundControlObject], interval, interval * phase1);
						loopAnimatorStep0.registerFunctionToExecute(stepSoundFunction2, [soundControlObject], interval, interval * phase2);
					}
					break;
				case 1: 
					soundControlObject.level1++;
					
					if (soundControlObject.level1 == 1)
					{
						loopAnimatorStep1.start();
						loopAnimatorStep1.registerFunctionToExecute(stepSoundFunction1, [soundControlObject], interval, interval * phase1);
						loopAnimatorStep1.registerFunctionToExecute(stepSoundFunction2, [soundControlObject], interval, interval * phase2);
					}
					break;
				case 2: 
					soundControlObject.level2++;
					
					if (soundControlObject.level2 == 1)
					{
						loopAnimatorStep2.start();
						loopAnimatorStep2.registerFunctionToExecute(stepSoundFunction1, [soundControlObject], interval, interval * phase1);
						loopAnimatorStep2.registerFunctionToExecute(stepSoundFunction2, [soundControlObject], interval, interval * phase2);
					}
					break;
			}
		}
		
		/////////////////
		
		// global sound control object for all waling robots
		// we don't need hundreds of sounds being played at the same time.
		// we only need one for each type of robots
		private static var soundControlObject:Object = new Object();
		
		// step sound loop animator for level 0
		private static var loopAnimatorStep0:LoopAnimator = new LoopAnimator();
		
		// step sound loop animator for level 1
		private static var loopAnimatorStep1:LoopAnimator = new LoopAnimator();
		
		// step sound loop animator for level 2
		private static var loopAnimatorStep2:LoopAnimator = new LoopAnimator();
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			switch (currentInfo.level)
			{
				case 0: 
					soundControlObject.soundIsOn0 = true;
					tryRegisterSoundsForSteps(670, 0, 0.5);
					break;
				case 1: 
					soundControlObject.soundIsOn1 = true;
					tryRegisterSoundsForSteps(2000, 0, 0.5);
					break;
				case 2: 
					soundControlObject.soundIsOn2 = true;
					tryRegisterSoundsForSteps(3000, 0, 0.5);
					break;
			}
		}
		
		private function getStepSoundFunctionForLevel(level:int):Function
		{
			var stepSoundFunction0:Function = function(soundControlObject:Object):void
			{
				if (soundControlObject.soundIsOn0)
					SoundController.instance.playSound(SoundResources.SOUND_ROBOT_WALKING_01);
			}
			
			var stepSoundFunction1:Function = function(soundControlObject:Object):void
			{
				if (soundControlObject.soundIsOn1)
					SoundController.instance.playSound(SoundResources.SOUND_ROBOT_WALKING_02);
			}
			
			var stepSoundFunction2:Function = function(soundControlObject:Object):void
			{
				if (soundControlObject.soundIsOn2)
					SoundController.instance.playSound(SoundResources.SOUND_ROBOT_WALKING_03);
			}
			
			return (level == 0) ? stepSoundFunction0 : (level == 1) ? stepSoundFunction1 : stepSoundFunction2;
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			walkAnimator.clearAllAnimation();
			
			switch (currentInfo.level)
			{
				case 0: 
					soundControlObject.level0--;
					
					if (soundControlObject.level0 == 0)
					{
						soundControlObject.soundIsOn0 = false;
						loopAnimatorStep0.clear();
					}
					
					if (soundControlObject.level0 < 0)
						throw new Error("soundControlObject.level0 less then 0!");
					break;
				case 1: 
					soundControlObject.level1--;
					
					if (soundControlObject.level1 == 0)
					{
						soundControlObject.soundIsOn1 = false;
						loopAnimatorStep1.clear();
					}
					
					if (soundControlObject.level1 < 0)
						throw new Error("soundControlObject.level1 less then 0!");
					break;
				case 2: 
					soundControlObject.level2--;
					
					if (soundControlObject.level2 == 0)
					{
						soundControlObject.soundIsOn2 = false;
						loopAnimatorStep2.clear();
					}
					
					if (soundControlObject.level2 < 0)
						throw new Error("soundControlObject.level2 less then 0!");
					break;
			}
		}
		
		// animated destroy
		
		override protected function drawPartsExplosion():void
		{
			if (!parent)
				return;
			
			var head:NSSprite = currentInfo.level == 0 ? prepareHead(chickenBaseImage) : currentInfo.level == 1 ? prepareHead(mastadontRocketLauncherImage) : null;
			
			AnimationEngine.globalAnimator.moveObjects(head, x, y, x + 50 - 100 * Math.random(), y + 50 - 100 * Math.random(), 500);
			AnimationEngine.globalAnimator.rotateObjects(head, head.rotation, head.rotation + 360, NaN, 500);
			AnimationEngine.globalAnimator.animateProperty(head, "alpha", 1, 0, NaN, 200, AnimationEngine.globalAnimator.currentTime + 300);
			AnimationEngine.globalAnimator.removeFromParent(head, parent, AnimationEngine.globalAnimator.currentTime + 500);
			
			parent.addChild(head);
		}
		
		private function prepareHead(shootingPartClass:Class):NSSprite
		{
			//head
			var head:NSSprite = new NSSprite();
			
			var shootingPart:Bitmap = new shootingPartClass() as Bitmap;
			shootingPart.x = shootingPart.height / 2;
			shootingPart.y = -shootingPart.width / 2;
			shootingPart.rotation = 90;
			shootingPart.smoothing = true;
			head.addChild(shootingPart);
			
			head.rotation = this.head.rotation;
			
			return head;
		}
	}

}