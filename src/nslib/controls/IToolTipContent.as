/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public interface IToolTipContent
	{
		function get contentDescriptor():Object;
		
		function set contentDescriptor(value:Object):void;
		
		function get width():Number;
		
		function set width(value:Number):void;
		
		function get height():Number;
		
		function set height(value:Number):void;
	}

}