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
	public class UIDUtil
	{
		// even if random values will be the same, this counter
		// will make them different
		private static var uidCounter:int = 0;
		
		public static function generateUniqueID():String
		{
			var result:String = "";
			var id:Number = 1;
			
			for (var j:int = 0; j < 4; j++)
			{
				for (var i:int = 0; i < 10; i++)
					id += NSMath.random();
				
				result += String(id / 10).substring(2, 7) + "-";
			}
			
			return result.substring(0, result.length - 1) + (uidCounter++);
		}
	
	}

}