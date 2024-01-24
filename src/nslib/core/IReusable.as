/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.core 
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public interface IReusable 
	{		
		// using this id will allow to diffirentiate two objects of the same class,
		// in case it is required to take an object with some specific content.
		function get poolID():String;
		
		function set poolID(value:String):void;
		
		// This is the same as disposing an object.
		function prepareForPooling():void;
		
		// In the method all parameters should be set to default values
		// the same as when constructing an instance of this object.
		function prepareForReuse():void;
	}
	
}