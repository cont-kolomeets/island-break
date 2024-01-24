/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.base 
{
	import flash.geom.Rectangle;
	import infoObjects.WeaponInfo;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public interface IGroundWeapon 
	{	
		// X coordinate.
		function get x():Number;
		
		function set x(value:Number):void
		
		// Y coordinate.
		function get y():Number;
		
		function set y(value:Number):void;
		
		// current WeaponInfo
		function get currentInfo():WeaponInfo;
		
		// indicates whether an item was placed on the game stage.
		function get isPlaced():Boolean;
		
		// returns true if the unit is built and ready
		function get isBuilt():Boolean;
		
		// Boundary rectagle. Used to identify bounds of the unit.
		function get rect():Rectangle;
	}
	
}