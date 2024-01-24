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
	public class EquationSolver
	{
		
		private var x:Number = 0;
		private var parser:ExpressionParser = new ExpressionParser();
		
		public function EquationSolver()
		{
		}
		
		public function solveEquation(eq:String):Number
		{
			
			eq = eq.toLocaleLowerCase();
			
			if (eq.indexOf("=") == -1)
			{
				return Number.NaN;
			}
			
			var before:String = eq.substr(0, eq.indexOf("="));
			var after:String = eq.substr(eq.indexOf("=") + 1, eq.length);
			
			//trace(parseExpressionWithX(before));
			//trace(parseExpressionWithX(after));
			
			x = 0;
			
			var deltaX:Number = 1000;
			var bestX:Number = 0;
			var bestSigma:Number = 1e9;
			var currentBestX:Number = 0;
			
			var sigma:Number = 0;
			
			for (var j:int = 0; j < 20; j++)
			{
				for (var i:int = 0; i < 100; i++)
				{
					x = currentBestX + (NSMath.random() * 2 - 1) * deltaX;
					sigma = NSMath.abs(parseExpressionWithX(before) - parseExpressionWithX(after));
					if (sigma < bestSigma)
					{
						bestSigma = sigma;
						bestX = x;
					}
				}
				currentBestX = bestX;
				//trace(bestX);
				deltaX /= 1.5;
			}
			
			return bestX;
		}
		
		private function parseExpressionWithX(exp:String):Number
		{
			
			if (exp.indexOf("x") == -1)
			{
				return parser.parseExpression(exp);
			}
			
			return parser.parseExpression(replaceWithXValue(exp, "x"));
		
		}
		
		private function replaceWithXValue(s:String, r:String):String
		{
			
			var result:String = "";
			
			for (var i:int = 0; i < s.length; i++)
			{
				
				if (s.charAt(i) == r)
				{
					result += "" + this.x;
				}
				else
				{
					result += s.charAt(i);
				}
			}
			
			return result;
		
		}
	
	}

}