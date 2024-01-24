/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.ammo.bullets 
{
	import flash.events.IEventDispatcher;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public interface IBullet extends IEventDispatcher
	{
		function get x():Number;
		
		function get y():Number;
		
		function get type():String;
		
		function get hitPower():Number;
	}

}