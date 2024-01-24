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
	import nslib.controls.NSSprite;
	import supportClasses.animation.ConstantRotator;
	import supportClasses.resources.WeaponResources;
	import weapons.base.IWeapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyInvisibleTank extends EnemyTrackedTankBase
	{		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/invisible tank 01 base.png")]
		private static var tank01BaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/invisible tank 02 base.png")]
		private static var tank02BaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/tanks/invisible tank 02 rotator.png")]
		private static var tank02RotatorImage:Class;
		
		/////////////////////////////////////////////////////
		
		public function EnemyInvisibleTank(level:int = 0)
		{
			super(WeaponResources.ENEMY_INVISIBLE_TANK, level);
		}
		
		////////////////////////////////////////////////////////////
		
		private var itemDictionary:Dictionary = new Dictionary();
		
		public function notifyConcealing(target:IWeapon):void
		{
			if (this.parent && itemDictionary[target] == undefined)
			{
				var repairSpark:Shape = new Shape();
				
				repairSpark.graphics.beginFill(0x707070, 0.7);
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
		
		////////////////////////////////////////////////////////////
		
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
		}
		
		override protected function drawWeaponLevel0():void
		{
			prebuild();
			createTracks(0.7, 0);
			
			//base
			base = new tank01BaseImage() as Bitmap;
			base.x = base.height / 2;
			base.y = -base.width / 2;
			base.rotation = 90;
			base.smoothing = true;
			
			body.addChild(base);
			
			addChild(body);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		override protected function drawWeaponLevel1():void
		{
			prebuild();
			createTracks();
			
			//base
			base = new tank02BaseImage() as Bitmap;
			base.x = base.height / 2;
			base.y = -base.width / 2;
			base.rotation = 90;
			base.smoothing = true;
			
			body.addChild(base);
			
			addRotatorAt(0, 0, 20);
			
			addChild(body);
			addChild(head);
			addChild(energyBar);
			
			updateEnergyBar();
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private var parts:Array = [];
		
		private function clearParts():void
		{
			for each (var item:*in parts)
				if (item is ConstantRotator)
					ConstantRotator(item).stopRotation();
			
			parts.length = 0;
		}
		
		private function addRotatorAt(x:int, y:int, rotationSpeed:Number, scale:Number = 1):void
		{
			var rotatingPart:NSSprite = new NSSprite();
			//base
			var rotatorImage:Bitmap = new tank02RotatorImage() as Bitmap;
			rotatorImage.scaleX = scale;
			rotatorImage.scaleY = scale;
			rotatorImage.x = -rotatorImage.width / 2;
			rotatorImage.y = -rotatorImage.height / 2;
			rotatorImage.smoothing = true;
			
			rotatingPart.addChild(rotatorImage);
			rotatingPart.x = x;
			rotatingPart.y = y;
			
			body.addChild(rotatingPart)
			// registering for rotation
			var constantRotator:ConstantRotator = new ConstantRotator(rotatingPart, rotationSpeed);
			
			parts.push(rotatingPart);
			parts.push(constantRotator);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			clearParts();
			stopTracks();
		}
	}

}