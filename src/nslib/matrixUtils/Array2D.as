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
	public class Array2D
	{
		private var array:Array;
		
		public function Array2D(n1:int, n2:int)
		{
			array = [];
			for (var i:int = 0; i < n1; i++)
			{
				array.push(new ArrayS(n2));
			}
		}
		
		public function getArrayAt(index:int):ArrayS {
			return array[index] as ArrayS;
		}
		
		public function getValueAt(i:int, j:int):* {
			return (array[i] as ArrayS).getItemAt(j);
		}
		
		public function setValueAt(i:int, j:int, value:*):void {
			
			(array[i] as ArrayS).setValueAt(j, value);
		}
		
		public function get length():int {
			return array.length;
		}
	
	}

}