/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.objects
{
	import events.TeleportEvent;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import supportClasses.animation.ConstantRotator;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class OneWayTeleport extends Teleport
	{
		
		public static const COLOR_PINK:int = 0xEB41E7;
		
		public static const COLOR_VIOLET:int = 0x9301F3;
		
		public static const COLOR_BLUE:int = 0x2520FF;
		
		public static const COLOR_CYAN:int = 0x3DDEE2;
		
		/////////////
		
		[Embed(source="F:/Island Defence/media/images/common images/teleport/teleport 01 base.png")]
		private static var baseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/teleport/teleport 01 door pink.png")]
		private static var doorPinkImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/teleport/teleport 01 door violet.png")]
		private static var doorVioletImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/teleport/teleport 01 door blue.png")]
		private static var doorBlueImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/teleport/teleport 01 door cyan.png")]
		private static var doorCyanImage:Class;
		
		////////////
		
		public var rotationSpeed:Number = 2;
		
		private var doorContainer:NSSprite = new NSSprite();
		
		private var constantRotator:ConstantRotator;
		
		////////////
		
		public function OneWayTeleport(color:int = -1)
		{
			super();
			
			_color = color;
			
			construct();
		}
		
		///////////
		
		private var _color:int = -1;
		
		public function get color():int
		{
			return _color;
		}
		
		///////////
		
		private function construct():void
		{
			rect = new Rectangle(-10, -10, 20, 20);
			
			var base:Bitmap = new baseImage() as Bitmap;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			addChild(base);
			
			var door:Bitmap = null;
			
			switch (color)
			{
				case COLOR_BLUE: 
					door = new doorBlueImage() as Bitmap;
					break;
				case COLOR_CYAN: 
					door = new doorCyanImage() as Bitmap;
					break;
				case COLOR_VIOLET: 
					door = new doorVioletImage() as Bitmap;
					break;
				case COLOR_PINK: 
					door = new doorPinkImage() as Bitmap;
					break;
				default: 
					door = new doorPinkImage() as Bitmap;
					break;
			}
			
			door.x = -door.width / 2;
			door.y = -door.height / 2;
			doorContainer.addChild(door);
			
			addChild(doorContainer);
			
			constantRotator = new ConstantRotator(doorContainer, 2);
		}
		
		//////////// Animation
		
		/////////// disappear
		
		override public function showDisappearAnimationForWeapon(weapon:Weapon, moveToTeleportPosition:Boolean = true, callBack:Function = null):void
		{
			// first freeze the weapon
			weapon.motionForbidden = true;
			
			AnimationEngine.globalAnimator.moveObjects(weapon, weapon.x, weapon.y, this.x, this.y, 1000, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.scaleObjects(weapon, 1, 1, 0.2, 0.2, 1000, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.animateProperty(weapon, "alpha", 1, 0, NaN, 1000, AnimationEngine.globalAnimator.currentTime);
			
			if (callBack != null)
				AnimationEngine.globalAnimator.executeFunction(callBack, null, AnimationEngine.globalAnimator.currentTime + 1200);
			
			// moving spark
			
			if (this.parent && oppositePort)
			{
				var teleportingSpark:Shape = new Shape();
				
				teleportingSpark.graphics.beginFill(0xFFFFFF, 0.7);
				teleportingSpark.graphics.drawCircle(0, 0, 5);
				
				teleportingSpark.alpha = 0;
				this.parent.addChild(teleportingSpark);
				
				AnimationEngine.globalAnimator.animateProperty(teleportingSpark, "alpha", 0, 1, NaN, 100, AnimationEngine.globalAnimator.currentTime + 1000);
				AnimationEngine.globalAnimator.moveObjects(teleportingSpark, this.x, this.y, oppositePort.x, oppositePort.y, 1000, AnimationEngine.globalAnimator.currentTime + 1000);
				
				AnimationEngine.globalAnimator.removeFromParent(teleportingSpark, this.parent, AnimationEngine.globalAnimator.currentTime + 2000);
			}
			
			AnimationEngine.globalAnimator.executeFunction(dispatchDisappearAnimationCompletedEvent, [weapon], AnimationEngine.globalAnimator.currentTime + 2000);
		}
		
		private function dispatchDisappearAnimationCompletedEvent(weapon:Weapon):void
		{
			dispatchEvent(new TeleportEvent(TeleportEvent.DISAPPEAR_ANIMATION_COMPLETED, weapon));
		}
		
		/////////// appear
		
		override public function showAppearAnimationForWeapon(weapon:IWeapon, moveToTeleportPosition:Boolean = true, duration:Number = 300, callBack:Function = null):void
		{
			if (moveToTeleportPosition)
			{
				weapon.x = this.x;
				weapon.y = this.y;
			}
			
			AnimationEngine.globalAnimator.scaleObjects(weapon, 0.2, 0.2, 1, 1, duration, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.animateProperty(weapon, "alpha", 0, 1, NaN, duration, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.executeFunction(dispatchAppearAnimationCompletedEvent, [weapon], AnimationEngine.globalAnimator.currentTime + duration);
			
			if(callBack != null)
				AnimationEngine.globalAnimator.executeFunction(callBack, null, AnimationEngine.globalAnimator.currentTime + duration);
		}
		
		private function dispatchAppearAnimationCompletedEvent(weapon:IWeapon):void
		{
			if(weapon is Weapon)
				Weapon(weapon).motionForbidden = false;
			
			dispatchEvent(new TeleportEvent(TeleportEvent.APPEAR_ANIMATION_COMPLETED, weapon));
		}
	
	}

}