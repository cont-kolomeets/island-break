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
	public class ExpressionParser extends Parser
	{
		
		private var deepestBraPos:int = 0;
		private var deepestKetPos:int = 0;
		
		public function parseExpression(s:String):Number
		{
			s = filter(s);
			
			var counter:int = 0;
			
			while (true)
			{
				
				if (++counter > 100)
					break;
				
				findDeepestBraKetPos(s, 0);
				if (deepestBraPos == -1)
				{
					break;
				}
				else
				{
					s = treatBrakets(s);
				}
			}
			
			return parseSimpleExpression(s);
		
		}
		
		public function filter(s:String):String
		{
			
			var result:String = "";
			var array:Array = s.split("");
			var part:String;
			
			for each (part in array)
			{
				if (part != " ")
					result += part;
			}
			
			array = result.split("");
			result = "";
			
			for (var i:int = 0; i < array.length; i++)
			{
				
				if (array[i] == "-" && array[i + 1] == "-" && i < ( array.length-1))
				{
					result += "+";
					i++;
				}else {
					result += array[i];
				}
			}
			
			return result;
		
		}
		
		private function treatBrakets(s:String):String
		{
			
			var pieceOfLine:String = s.substring(deepestBraPos + 1, deepestKetPos);
			var newValue:Number = parseSimpleExpression(pieceOfLine);
			
			if (checkForExpressionBeforeBrakets(s, "sin"))
			{
				return replaceCutOff(s, createStringWithoutE(NSMath.sinRad(newValue)), deepestBraPos - 3, deepestKetPos + 1);
			}
			
			if (checkForExpressionBeforeBrakets(s, "cos"))
			{
				return replaceCutOff(s, createStringWithoutE(NSMath.cosRad(newValue)), deepestBraPos - 3, deepestKetPos + 1);
			}
			
			if (checkForExpressionBeforeBrakets(s, "round"))
			{
				return replaceCutOff(s, createStringWithoutE(NSMath.round(newValue)), deepestBraPos - 5, deepestKetPos + 1);
			}
			
			if (checkForExpressionBeforeBrakets(s, "abs"))
			{
				return replaceCutOff(s, createStringWithoutE(NSMath.abs(newValue)), deepestBraPos - 3, deepestKetPos + 1);
			}
			
			if (checkForExpressionBeforeBrakets(s, "exp"))
			{
				return replaceCutOff(s, createStringWithoutE(NSMath.pow(NSMath.E, newValue)), deepestBraPos - 3, deepestKetPos + 1);
			}
			
			if (checkForExpressionBeforeBrakets(s, "ln"))
			{
				return replaceCutOff(s, createStringWithoutE(NSMath.log(newValue)), deepestBraPos - 2, deepestKetPos + 1);
			}
			
			if (checkForExpressionBeforeBrakets(s, "log"))
			{
				return replaceCutOff(s, createStringWithoutE((NSMath.log(newValue) / 2.31)), deepestBraPos - 3, deepestKetPos + 1);
			}
			
			if (checkForExpressionBeforeBrakets(s, "sqrt"))
			{
				return replaceCutOff(s, createStringWithoutE(NSMath.sqrt(newValue)), deepestBraPos - 3, deepestKetPos + 1);
			}
			
			return replaceCutOff(s, createStringWithoutE(newValue), deepestBraPos, deepestKetPos + 1);
		}
		
		private function checkForExpressionBeforeBrakets(s:String, expr:String):Boolean
		{
			if (deepestBraPos >= expr.length)
			{
				if (s.substring(deepestBraPos - expr.length, deepestBraPos) == expr)
					return true;
			}
			
			return false;
		}
		
		private function parseSimpleExpression(s:String):Number
		{
			
			var array:Array = [];
			var changed:Boolean = false;
			
			while (true)
			{
				changed = false;
				for (var i:int = 1; i < s.length; i++)
				{
					
					if ((s.charAt(i) == "+" || s.charAt(i) == "-") && (s.charAt(i - 1) != "*" && s.charAt(i - 1) != "/" && s.charAt(i - 1) != "^"))
					{
						
						array.push(s.substring(0, i));
						s = s.substring(i, s.length);
						changed = true;
						break;
					}
				}
				if (!changed)
				{
					array.push(s);
					break;
				}
			}
			
			var result:Number = 0;
			
			for each (var line:String in array)
			{
				//System.out.println(line);
				result += calcValueFromMultDevExt(line);
			}
			
			return result;
		}
		
		private function calcValueFromMultDevExt(s:String):Number
		{
			
			var scannedValue:Number = 0;
			var result:Number = 1;
			var prevSign:String = null;
			var changed:Boolean = false;
			
			while (true)
			{
				changed = false;
				for (var i:int = 0; i < s.length; i++)
				{
					if (s.charAt(i) == "*" || s.charAt(i) == "/" || s.charAt(i) == "^")
					{
						
						scannedValue = this.parseFloat(s.substring(0, i));
						
						if (prevSign != null)
						{
							if (prevSign == "M")
							{
								result *= scannedValue;
							}
							if (prevSign == "D")
							{
								result /= scannedValue;
							}
							if (prevSign == "E")
							{
								result = NSMath.pow(result, scannedValue);
							}
						}
						else
						{
							result = scannedValue;
						}
						
						if (s.charAt(i) == "*")
						{
							prevSign = "M";
						}
						if (s.charAt(i) == "/")
						{
							prevSign = "D";
						}
						if (s.charAt(i) == "^")
						{
							prevSign = "E";
						}
						
						s = s.substring(i + 1, s.length);
						
						changed = true;
						break;
					}
				}
				if (!changed)
				{
					
					scannedValue = this.parseFloat(s);
					//System.out.println(scannedValue);
					
					if (prevSign != null)
					{
						if (prevSign == "M")
						{
							result *= scannedValue;
						}
						if (prevSign == "D")
						{
							result /= scannedValue;
						}
						if (prevSign == "E")
						{
							result = NSMath.pow(result, scannedValue);
						}
					}
					else
					{
						result = scannedValue;
					}
					break;
				}
				
			}
			
			return result;
		
		}
		
		private function findDeepestBraKetPos(s:String, start:int):void
		{
			
			deepestBraPos = -1;
			
			for (var i:int = start; i < s.length; i++)
			{
				if (s.charAt(i) == "(")
				{
					deepestBraPos = i;
					findDeepestKetPos(s, i + 1);
				}
			}
		}
		
		private function findDeepestKetPos(s:String, start:int):void
		{
			
			for (var i:int = start; i < s.length; i++)
			{
				if (s.charAt(i) == ")")
				{
					deepestKetPos = i;
					return;
				}
				if (s.charAt(i) == "(")
				{
					deepestBraPos = i;
					findDeepestKetPos(s, i + 1);
				}
			}
		
		}
		
		private function cutOff(s:String, from:int, to:int):String
		{
			
			var s1:String = s.substring(0, from);
			var s2:String = s.substring(to, s.length);
			
			return s1 + s2;
		
		}
		
		private function replaceCutOff(s:String, insert:String, from:int, to:int):String
		{
			
			var s1:String = s.substring(0, from);
			var s2:String = s.substring(to, s.length);
			
			return s1 + insert + s2;
		
		}
		
		public function createStringWithoutE(x:Number):String
		{
			
			var s:String = "" + x;
			var result:String;
			
			s = s.toUpperCase();
			
			if (s.indexOf("E") == -1)
			{
				return s;
			}
			else
			{
				
				var afterE:String = s.substring(s.indexOf("E") + 1, s.length);
				
				var n:int = parseInt(afterE);
				
				var sign:String = "";
				
				if (s.indexOf("-") == 0)
				{
					sign = "-";
					s = s.substring(1, s.length);
				}
				
				var posOfDot:int = s.indexOf(".");
				var withoutDot:String = s.substring(0, s.indexOf(".")) + s.substring(s.indexOf(".") + 1, s.indexOf("E"));
				
				if (n < 0)
				{
					
					result = "0.";
					
					for (var i:int = 1; i < (-n); i++)
						result += "0";
					
					return (sign + result + withoutDot);
				}
				
				if (n > 0)
				{
					
					result = withoutDot;
					
					for (var j:int = 0; j < (n - (withoutDot.length - posOfDot)); j++)
						result += "0";
					
					return (sign + result);
				}
				
			}
			
			return null;
		}
	
	}

}