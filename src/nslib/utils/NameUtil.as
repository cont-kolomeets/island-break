/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils 
{
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class NameUtil 
	{
		/*
		 * Truncates full qualified class name for a specified object to display only the base name.
		 **/
		public static function getTruncatedClassName(item:*):String
		{
			var className:String;
			
			if (item is String)
				className = String(item);
			else
			{
				var array:Array = getQualifiedClassName(item).split("::");
				className = array[array.length - 1];
			}
			
			return className;
		}
		
	}

}