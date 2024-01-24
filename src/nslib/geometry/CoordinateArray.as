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
	public class CoordinateArray 
	{
		private var array:Array = [];
		
		public function CoordinateArray() 
		{
		}
		
		public function addPoint(point:Point):void {
			array.push(point);
		}
		
		public function getPoint(index:int):Point {
			return array[index] as Point;
		}
		
		public function get length():int {
			return array.length;
		}
		
		public function get source():Array {
			return array;
		}
		
		public function toString():String {
			return "" + array;
		}
		
		public static function arrayToCoordinateArray(array2D:Array):CoordinateArray {
			
			var result:CoordinateArray = new CoordinateArray();
			
			for each(var point:Array in array2D) {
				if(point.length > 1)
					result.addPoint(new Point(point[0], point[1]));
			}
			
			return result;
		}
		
	}

}