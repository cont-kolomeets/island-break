/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.base 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import infoObjects.WeaponInfo;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public interface IWeapon
	{
		// indicates whether the weapon is active
		// Active means: placed and ready to fight.
		function get isActive():Boolean;
		
		// Returns true if a weapon is currently rotating a gun
		// to shoot at a target.
		function get isBusyRotatingForTarget():Boolean;
		
		// Current target location to shoot at.
		function get hitTarget():Point;
		
		// Current object to shoot at.
		function get hitObject():IWeapon;
		
		function set hitObject(value:IWeapon):void;
		
		function set hitTarget(value:Point):void;
		
		// X coordinate.
		function get x():Number;
		
		function set x(value:Number):void
		
		// Y coordinate.
		function get y():Number;
		
		function set y(value:Number):void;
		
		// angle of the body
		function get bodyAngle():Number;
		
		function set bodyAngle(value:Number):void
		
		// Boundary rectagle. Used to indentify whether a unit is hit by a bullet.
		function get rect():Rectangle;
		
		// Just converts current x and y to Point.
		function get currentLocation():Point;
		
		function get currentInfo():WeaponInfo;
		
		function get isActingInvisible():Boolean;
		
		function set isActingInvisible(value:Boolean):void;
		
		/////////////////////////////////////////////
		
		// Activates a weapon.
		function activate():void;
		
		// Decativates a weapon.
		function deactivate():void;
		
		// Upgrades a weapon to the specified level.
		function upgradeToLevel(level:int):void;
		
		// Notifies that no hit targets found.
		// E.g. a cannon in this case may rotate its gun
		// to the initial position.
		function noHitTargetsFound():void;
		
		// Notifies that hitTarget has been assigned
		// and a unit should now start rotating for the target.
		function rotateForTarget():void;
		
		// Applies damage to the weapon.
		function applyDamage(damage:Number):void;
				
		// Fires a missile at the specified target.
		// Must return true if the specified target is approved.
		function fireMissileAt(target:IWeapon):Boolean;
		
		// if true, the unit is not ready to fire a missile
		function busyReloadingMissile():Boolean;
	}
	
}