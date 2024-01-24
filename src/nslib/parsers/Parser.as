/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.parsers
{
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class Parser
	{
		
		public function parseInt(s:String):int
		{
			
			var sign:int = 1;
			
			if (s.charAt(0) == "-")
			{
				sign = -1;
				s = s.substring(1, s.length);
			}
			
			if (s.charAt(0) == "+")
			{
				s = s.substring(1, s.length);
			}
			
			if (s.length > 10)
			{
				throw new Error("Number is out of bounds");
			}
			
			var array:Array = []
			
			for (var i:int = 0; i < s.length; i++)
			{
				array[i] = convertCharToInt(s.charAt(i)) * NSMath.pow(10, s.length - i - 1);
			}
			
			return sign * sumArray(array);
		}
		
		public function parseFloat(s:String):Number
		{
			
			var sign:Number = 1;
			var pointPos:int = s.indexOf(".");
			
			if (pointPos == -1)
			{
				return parseInt(s);
			}
			
			if (s.charAt(0) == "-")
			{
				sign = -1;
				s = s.substring(1, s.length);
				pointPos = s.indexOf(".");
			}
			
			if (s.charAt(0) == "+")
			{
				s = s.substring(1, s.length);
				pointPos = s.indexOf(".");
			}
			
			var s1:String = s.substring(0, pointPos);
			var s2:String = s.substring(pointPos + 1, s.length);
			
			var beforePointArray:Array = [];
			var afterPointArray:Array = [];
			
			for (var i:int = 0; i < s1.length; i++)
			{
				beforePointArray[i] = convertCharToInt(s1.charAt(i)) * NSMath.pow(10, s1.length - i - 1);
			}
			
			for (var j:int = 0; j < s2.length; j++)
			{
				afterPointArray[j] = convertCharToInt(s2.charAt(j)) * NSMath.pow(10, -j - 1);
			}
			//System.out.println("sign = " + sign);
			
			return sign * (sumArray(beforePointArray) + sumArray(afterPointArray));
			
			return 0;
		}
		
		private function convertCharToInt(c:String):int
		{
			
			switch (c)
			{
				case "1": 
					return 1;
				case "2": 
					return 2;
				case "3": 
					return 3;
				case "4": 
					return 4;
				case "5": 
					return 5;
				case "6": 
					return 6;
				case "7": 
					return 7;
				case "8": 
					return 8;
				case "9": 
					return 9;
			}
			
			return 0;
		
		}
		
		/*private function sumArray(array:Array):int
		   {
		
		   var result = 0;
		
		   for each (var v:int in array)
		   {
		   result += v;
		   }
		
		   return result;
		 }*/
		
		private function sumArray(array:Array):Number
		{
			
			var result:Number = 0;
			
			for each (var v:Number in array)
			{
				result += v;
			}
			
			return result;
		}
	
	}

}