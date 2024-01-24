/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.SOM
{
	
	import nslib.matrixUtils.Matrix;
	import nslib.matrixUtils.MatrixMath;
	import nslib.utils.NSMath;
	
	public class NormalizeInput
	{
		public var normalizationType:int;
		public var normfac:Number = 0;
		public var synth:Number = 0;
		public var inputMatrix:Matrix;
		
		public function NormalizeInput(normalizationType:int):void
		{
			
			this.normalizationType = normalizationType;
		}
		
		public function calculateFactors(input:Array):void
		{
			inputMatrix = createColumnMatrixWithBias(input);
			var vectorLength:Number = MatrixMath.calcVectorLength(inputMatrix);
			var nOfInputs:int = input.length;
			
			if (normalizationType == NormalizationType.MULTIPLICATIVE)
			{
				normfac = 1.0 / vectorLength;
				synth = 0;
			}
			else
			{
				normfac = 1.0 / NSMath.sqrt(nOfInputs);
				var d:Number = nOfInputs - NSMath.pow(vectorLength, 2);
				if (d > 0)
				{
					synth = NSMath.sqrt(d) * normfac;
				}
				else
				{
					synth = 0;
				}
			}
			
			nomalizeInput();
		}
		
		public function createColumnMatrixWithBias(input:Array):Matrix
		{
			var extendedInput:Array = [];
			
			for (var i:int = 0; i < input.length; i++)
				extendedInput[i] = input[i];
			
			extendedInput[input.length] = 1;
			
			return Matrix.createColumnMatrixFromArray(extendedInput);
		}
		
		public function nomalizeInput():void
		{
			for (var i:int = 0; i < inputMatrix.getNOfRows(); i++)
			{
				inputMatrix.setValueAt(inputMatrix.getValueAt(0, i) * getNormFac(), 0, i);
			}
		}
		
		public function getNormFac():Number
		{
			return normfac;
		}
		
		public function getInputMatrix():Matrix
		{
			return inputMatrix;
		}
	
	}

}