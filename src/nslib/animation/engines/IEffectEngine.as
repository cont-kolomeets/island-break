/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.animation.engines 
{
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public interface IEffectEngine 
	{
		function set target(obj:Object):void;
		
        function set targets(objs:Array):void;

		function play():void;
		
		function stop():void;
	}

}