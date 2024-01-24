/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.matrixUtils 
{
	/**
	 * ...
	 * @author Alex
	 */
	public class ArrayS 
	{
		private var array:Array;
		
		public function ArrayS(n:int) 
		{
			array = [];
			for (var j:int = 0; j < n; j++)
			{
				array.push(0);
			}
		}
		
		public function addItem(item:*):void {
			array.push(item);
		}
		
		public function getItemAt(index:int):* {
			return array[index];
		}
		
		public function setValueAt(index:int, value:*):void {
			array[index] = value;
		}
		
		public function get length():int {
			return array.length;
		}
		
	}

}