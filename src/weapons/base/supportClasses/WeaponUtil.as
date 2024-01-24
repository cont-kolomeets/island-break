/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.base.supportClasses
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import nslib.utils.NSMath;
	import weapons.base.AirCraft;
	import weapons.base.IGroundWeapon;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponUtil
	{
		// returns true if the specified target is reachable for the weapon.
		public static function isReachable(weapon:IWeapon, target:IWeapon):Boolean
		{
			//if (weapon is AirCraft)
			//	return ((NSMath.abs(AirCraft(weapon).anchor.x - target.x) < weapon.currentInfo.hitRadius) && (NSMath.abs(AirCraft(weapon).anchor.y - target.y) < weapon.currentInfo.hitRadius))
			//else
				return ((NSMath.abs(weapon.x - target.x) < weapon.currentInfo.hitRadius) && (NSMath.abs(weapon.y - target.y) < weapon.currentInfo.hitRadius))
		}
		
		public static function weaponCanHitTarget(weapon:IWeapon, target:IWeapon):Boolean
		{
			// must be active
			if (!target.isActive)
				return false;
			
			// must be able to hit this type
			if ((target is AirCraft) && !weapon.currentInfo.canHitAircrafts)
				return false;
			
			// if the target is invisible and the weapon cannot detect it, just continue
			if (target.isActingInvisible && !weapon.currentInfo.canHitInvisibleUnits)
				return false;
			
			// special case: Freezing energy ball
			// does not hit a unit if it is already froze, but chooses another one
			if (weapon.currentInfo.canFreezeUnits)
				if (target is Weapon && Weapon(target).isFrozen)
					return false;
			
			// must be reachable	
			if (!WeaponUtil.isReachable(weapon, target))
				return false;
			
			return true;
		}
		
		///////////////
		
		public static function tryFindItemOnLayerAt(x:Number, y:Number, layer:DisplayObjectContainer):IGroundWeapon
		{
			// try to find an item, over which a click may have possibly happened
			var len:int = layer.numChildren;
			
			// start from top children for consisntency
			for (var i:int = len - 1; i >= 0; i--)
			{
				var child:* = layer.getChildAt(i);
				
				if ((child is IGroundWeapon) && interactionDetected(child as IGroundWeapon, x, y))
					return IGroundWeapon(child);
			}
			
			return null;
		}
		
		public static const staticInteractionRect:Rectangle = new Rectangle( -25, -25, 50, 50);
		
		private static const interactionSide:Number = 50;
		
		private static var interactionRect:Rectangle = new Rectangle();
		
		public static function interactionDetected(item:IGroundWeapon, mouseX:Number, mouseY:Number):Boolean
		{
			// set width and height only once
			if (interactionRect.width == 0)
			{
				interactionRect.width = interactionSide;
				interactionRect.height = interactionSide;
			}
			
			interactionRect.x = Weapon(item).x - interactionSide / 2;
			interactionRect.y = Weapon(item).y - interactionSide / 2;
			
			return interactionRect.contains(mouseX, mouseY);
		}
	
	}

}