/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import nslib.sequencers.ImageSequencer;
	import nslib.utils.AlignUtil;
	import supportClasses.animation.ConstantRotator;
	import supportClasses.DustGenerator;
	import supportClasses.resources.WeaponResources;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyMobileVehicle extends Weapon
	{
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/fast and light/wheel 01 f01.png")]
		private static var wheelImageF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/fast and light/wheel 01 f02.png")]
		private static var wheelImageF02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/fast and light/wheel 01 f03.png")]
		private static var wheelImageF03Image:Class;
		
		////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/fast and light/tricycle base.png")]
		private static var tricycleBaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/fast and light/car base.png")]
		private static var carBaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/fast and light/triball.png")]
		private static var triballBaseImage:Class;
		
		/////////////////////////////////////////////////////
		
		private var duster:DustGenerator = null;
		
		/////////////////////////////////////////////////////
		
		public function EnemyMobileVehicle(level:int = 0)
		{
			super(WeaponResources.ENEMY_MOBILE_VEHICLE, level);
		}
		
		////////////////////////////////////////////////////
		
		private var base:Bitmap = null;
		
		private function prebuild():void
		{
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			// in case this object is returned for reuse
			removeAllChildren();
			
			// clear the previous level
			body.removeAllChildren();
			head.removeAllChildren();
			
			updateEnergyBar();
			
			addChild(body);
			addChild(head);
			addChild(energyBar);
		}
		
		// tricycle
		override protected function drawWeaponLevel0():void
		{
			prebuild();
			
			//base
			base = new tricycleBaseImage() as Bitmap;
			base.x = base.height / 2;
			base.y = -base.width / 2;
			base.rotation = 90;
			base.smoothing = true;
			
			// front wheel
			registerWheel(10, 1, 0.9);
			
			// back wheels
			registerWheel(-8, 10);
			registerWheel(-8, -10);
			
			body.addChild(base);
			
			if (!duster)
				duster = new DustGenerator(this);
			duster.startDusting();
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		// car
		override protected function drawWeaponLevel1():void
		{
			prebuild();
			
			//base
			base = new carBaseImage() as Bitmap;
			base.x = base.height / 2;
			base.y = -base.width / 2;
			base.rotation = 90;
			base.smoothing = true;
			
			// back wheels
			registerWheel(-7, 8);
			registerWheel(-7, -8);
			
			// front wheels
			registerWheel(10, 8);
			registerWheel(10, -8);
			
			body.addChild(base);
			
			if (!duster)
				duster = new DustGenerator(this);
			duster.startDusting();
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private var parts:Array = [];
		
		private function clearParts():void
		{
			for each (var item:*in parts)
				if (item is ImageSequencer)
					ImageSequencer(item).stop();
			
			parts.length = 0;
		}
		
		private function registerWheel(offsetX:int, offsetY:int, scaleX:Number = 1, scaleY:Number = 1):void
		{
			var wheel:ImageSequencer = new ImageSequencer();
			wheel.addImages([wheelImageF03Image, wheelImageF02Image, wheelImageF01Image]);
			wheel.start();
			wheel.smoothing = true;
			
			wheel.rotation = 90;
			wheel.scaleX = scaleX;
			wheel.scaleY = scaleY;
			wheel.x = wheel.height / 2 + offsetX;
			wheel.y = -wheel.width / 2 + offsetY;
			
			parts.push(wheel);
			
			body.addChild(wheel);
		}
		
		////////////////////////////
		
		private var rotatingPart:NSSprite;
		
		private var constantRotator:ConstantRotator;
		
		// tripad
		override protected function drawWeaponLevel2():void
		{
			prebuild();
			
			rotatingPart = new NSSprite();
			//base
			base = new triballBaseImage() as Bitmap;
			base.x = base.height / 2;
			base.y = -base.width / 2;
			base.rotation = 90;
			base.smoothing = true;
			
			rotatingPart.addChild(base);
			addChild(rotatingPart);
			// registering for rotation
			constantRotator = new ConstantRotator(rotatingPart, 10);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			if (constantRotator)
				constantRotator.stopRotation();
			
			if (duster)
				duster.stopDusting();
			
			clearParts();
		}
		
		// animated destroy
		
		override protected function drawPartsExplosion():void
		{
			if (!parent || currentInfo.level == 2)
				return;
			
			var initRotation:Number = Math.random();
			var numWheels:int = currentInfo.level == 0 ? 3 : currentInfo.level == 1 ? 4 : 0;

			var rotationDirection:int = 1;
			
			for (var i:int = 0; i < numWheels; i++)
			{
				var wheelImage:Bitmap = new wheelImageF01Image();
				AlignUtil.centerSimple(wheelImage, null);
				
				var imageContainer:NSSprite = new NSSprite();
				imageContainer.addChild(wheelImage);
				
				imageContainer.rotation = 360 * Math.random();
				
				initRotation += Math.PI * 2 / numWheels;
				var dist:Number = 35 + 35 * Math.random();
				AnimationEngine.globalAnimator.moveObjects(imageContainer, x, y, x + dist * Math.cos(initRotation), y + dist * Math.sin(initRotation), 500);
				AnimationEngine.globalAnimator.rotateObjects(imageContainer, imageContainer.rotation, imageContainer.rotation + rotationDirection * (300 + 500 * Math.random()), NaN, 500);
				AnimationEngine.globalAnimator.animateProperty(imageContainer, "alpha", 1, 0, NaN, 150, AnimationEngine.globalAnimator.currentTime + 350);
				AnimationEngine.globalAnimator.removeFromParent(imageContainer, parent, AnimationEngine.globalAnimator.currentTime + 500);
				
				parent.addChild(imageContainer);
				
				rotationDirection *= -1;
			}
		}
	}

}