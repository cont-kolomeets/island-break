/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ArrayUtil
	{		
		public static function addItem(array:Array, item:*, unique:Boolean = true):Array
		{
			if (!unique || array.lastIndexOf(item) == -1)
				array.push(item);
			
			return array;
		}
		
		public static function removeItem(array:Array, item:*):Array
		{
			var result:Array = [];
			var len:int = array.length;
			
			for (var i:int = 0; i < len; i++)
				if (item != array[i])
					result.push(array[i]);
			
			return result;
		}
		
		public static function fromHash(hash:Object):Array
		{
			var result:Array = [];
			
			for (var id:String in hash)
				if (hash[id] != undefined)
					result.push(hash[id]);
			
			return result;
		}
		
		public static function filter(array:Array, filterFunction:Function):Array
		{
			var result:Array = [];
			
			for each (var item:* in array)
				if (filterFunction(item))
					result.push(item);
			
			return result;
		}	
	}

}