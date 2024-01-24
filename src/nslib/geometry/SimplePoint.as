/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.geometry 
{
	/**
	 * ...
	 * @author Alex
	 */
	public class SimplePoint 
	{
		public var x:Number;
		public var y:Number;
		
		public function SimplePoint(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
		}
		
		public function toString():String {
			return "x = " + x + ", y = " + y;
		}
		
	}

}