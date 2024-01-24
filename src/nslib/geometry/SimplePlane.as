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
	public class SimplePlane 
	{
		
		public var a:Number;
		public var b:Number;
		public var c:Number;
		
		public function SimplePlane(a:Number, b:Number, c:Number) 
		{
			this.a = a;
			this.b = b;
			this.c = c;
		}
		
		public function toString():String {
			
			return "(" + a + ", " + b + ", " + c + ")";
		}
		
	}

}