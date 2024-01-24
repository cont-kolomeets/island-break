/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import nslib.utils.AlignUtil;
	import supportClasses.animation.ConstantRotator;
	import supportClasses.resources.WeaponResources;
	import weapons.base.PlaneBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyHelicopter extends PlaneBase
	{
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/helicopter 01.png")]
		private static var helicopter01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/heavy helicopter 01.png")]
		private static var helicopter02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/boss body.png")]
		private static var bossBodyImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/helicopter rotator.png")]
		private static var helicopterRotatorImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/boss rotator.png")]
		private static var bossRotatorImage:Class;
		
		/////////// shadows
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/helicopter 01 shadow.png")]
		private static var helicopter01ShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/heavy helicopter 01 shadow.png")]
		private static var helicopter02ShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/boss body shadow.png")]
		private static var bossBodyShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/helicopter rotator shadow.png")]
		private static var helicopterRotatorShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/boss rotator shadow.png")]
		private static var bossRotatorshadowImage:Class;
		
		///////////////
		
		public function EnemyHelicopter(level:int = 0)
		{
			super(WeaponResources.ENEMY_HELICOPTER, level);
		}
		
		///////////////
		
		public function setArmor(value:Number):void
		{
			armor = value;
		}
		
		///////////////
		
		override protected function drawWeaponLevel0():void
		{
			// in case this object is returned for reuse
			removeAllChildren();
			
			body.removeAllChildren();
			
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			// shadow
			registerBaseShadow(helicopter01ShadowImage);
			
			//body
			registerBodyImage(helicopter01Image);
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
			
			prepareTrace(true);
			
			addChild(shadowContainer);
			addChild(body);
			addChild(energyBar);
			addChild(flightBar);
			
			updateEnergyBar();
			updateFlightBar();
			
			/// adding rotator
			clearParts();
			
			addRotatorAt(helicopterRotatorImage, helicopterRotatorShadowImage, 0, 0, 20, true);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		override protected function drawWeaponLevel1():void
		{
			// in case this object is returned for reuse
			removeAllChildren();
			
			body.removeAllChildren();
			
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			// shadow
			registerBaseShadow(helicopter02ShadowImage);
			
			//body
			registerBodyImage(helicopter02Image);
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
			
			prepareTrace(true);
			
			addChild(shadowContainer);
			addChild(body);
			addChild(energyBar);
			addChild(flightBar);
			
			updateEnergyBar();
			updateFlightBar();
			
			/// adding rotators
			clearParts();
			
			addRotatorAt(helicopterRotatorImage, helicopterRotatorShadowImage, 0, -18, 20, false);
			addRotatorAt(helicopterRotatorImage, helicopterRotatorShadowImage, 0, 18, 20, false);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		// BOSS !!!!!!!!
		override protected function drawWeaponLevel2():void
		{
			// in case this object is returned for reuse
			removeAllChildren();
			
			body.removeAllChildren();
			
			//implementing boundaries rectangle
			rect = new Rectangle(-30, -30, 60, 60);
			
			// shadow
			registerBaseShadow(bossBodyShadowImage);
			
			//body
			registerBodyImage(bossBodyImage);
			
			shootingOffsetX = 5;
			shootingOffsetY = 30;
			
			missileShootingOffsetX = 20;
			missileShootingOffsetY = 30;
			
			prepareTrace(true);
			
			addChild(shadowContainer);
			addChild(body);
			addChild(energyBar);
			addChild(flightBar);
			
			updateEnergyBar();
			updateFlightBar();
			
			/// adding rotators
			clearParts();
			
			addRotatorAt(bossRotatorImage, bossRotatorshadowImage, 7, -47, 30, false);
			addRotatorAt(bossRotatorImage, bossRotatorshadowImage, 7, 47, 30, false);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		////////////////
		
		private function registerBaseShadow(shadowClass:Class):void
		{
			shadowContainer.removeAllChildren();
			var shadowImage:Bitmap = new shadowClass() as Bitmap;
			shadowImage.rotation = 90;
			shadowImage.x = shadowImage.width / 2;
			shadowImage.y = -shadowImage.height / 2;
			shadowImage.smoothing = true;
			shadowContainer.addChild(shadowImage);
		}
		
		private function registerBodyImage(bodyImageClass:Class):void
		{
			var bodyImage:Bitmap = new bodyImageClass() as Bitmap;
			bodyImage.rotation = 90;
			bodyImage.x = bodyImage.width / 2;
			bodyImage.y = -bodyImage.height / 2;
			bodyImage.smoothing = true;
			body.addChild(bodyImage);
		}
		
		private function clearParts():void
		{
			for each (var item:*in parts)
				if (item is ConstantRotator)
					ConstantRotator(item).stopRotation();
			
			parts.length = 0;
		}
		
		// need this array to keep references to sprites
		private var parts:Array = [];
		
		private function addRotatorAt(rotatorClass:Class, rotatorShadowClass:Class, x:int, y:int, rotationSpeed:Number, addSeparately:Boolean = false):void
		{
			var rotatingPart:NSSprite = new NSSprite();
			//base
			var rotatorImage:Bitmap = new rotatorClass() as Bitmap;
			rotatorImage.x = -rotatorImage.width / 2;
			rotatorImage.y = -rotatorImage.height / 2;
			rotatorImage.smoothing = true;
			
			rotatingPart.addChild(rotatorImage);
			rotatingPart.x = x;
			rotatingPart.y = y;
			
			if (!addSeparately)
				body.addChild(rotatingPart)
			else
				addChild(rotatingPart);
			// registering for rotation
			var constantRotator:ConstantRotator = new ConstantRotator(rotatingPart, rotationSpeed);
			
			// rotator shadow
			var rotatingPartShadow:NSSprite = new NSSprite();
			//base
			var rotatorShadowImage:Bitmap = new rotatorShadowClass() as Bitmap;
			rotatorShadowImage.x = -rotatorShadowImage.width / 2;
			rotatorShadowImage.y = -rotatorShadowImage.height / 2;
			rotatorShadowImage.smoothing = true;
			
			rotatingPartShadow.addChild(rotatorShadowImage);
			rotatingPartShadow.x = x;
			rotatingPartShadow.y = y;
			
			if (!addSeparately)
				shadowContainer.addChild(rotatingPartShadow)
			else
			{
				shadowStaticContainer = new NSSprite();
				shadowStaticContainer.addChild(rotatingPartShadow);
				addChild(shadowStaticContainer);
			}
			
			// registering for rotation
			var constantShadowRotator:ConstantRotator = new ConstantRotator(rotatingPartShadow, rotationSpeed);
			
			parts.push(rotatingPart);
			parts.push(constantRotator);
			parts.push(rotatingPartShadow);
			parts.push(constantShadowRotator);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			clearParts();
		}
		
		// animated destroy
		
		override protected function drawPartsExplosion():void
		{
			if (!parent)
				return;
			
			var initRotation:Number = Math.PI * 2 * Math.random();
			
			for (var i:int = 0; i < (currentInfo.level == 0 ? 1 : 2); i++)
			{
				var rotatorImage:Bitmap = null;
				
				if (currentInfo.level == 2)
					rotatorImage = new bossRotatorImage();
				else
					rotatorImage = new helicopterRotatorImage();
				
				var rotatorContainer:NSSprite = new NSSprite();
				
				AlignUtil.centerSimple(rotatorImage, null);
				rotatorContainer.addChild(rotatorImage);
				
				rotatorContainer.rotation = 360 * Math.random();
				
				initRotation += Math.PI;
				var dist:Number = (currentInfo.level == 2 ? 150 : 90) + 60 * Math.random();
				AnimationEngine.globalAnimator.moveObjects(rotatorContainer, x, y, x + dist * Math.cos(initRotation), y + dist * Math.sin(initRotation), 500);
				AnimationEngine.globalAnimator.rotateObjects(rotatorContainer, rotatorContainer.rotation, rotatorContainer.rotation + 360, NaN, 500);
				AnimationEngine.globalAnimator.animateProperty(rotatorContainer, "alpha", 1, 0, NaN, 150, AnimationEngine.globalAnimator.currentTime + 350);
				AnimationEngine.globalAnimator.removeFromParent(rotatorContainer, parent, AnimationEngine.globalAnimator.currentTime + 500);
				
				parent.addChild(rotatorContainer);
			}
		}
	}

}