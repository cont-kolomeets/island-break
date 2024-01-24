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
	 * @author Kolomeets Alexander
	 */
	public interface ISerializable 
	{
		function serialize():Object;
		function implementDeserializedProperties(obj:Object):void;
	}

}