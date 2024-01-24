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
	
	
	public class SelfOrganizingMap
	{
		
		public var inputNeuronCount:int;
		public var outputNeuronCount:int;
		public var outputWeightMatrix:Matrix;
		public var output:Array;
		public var normalizationType:int;
		public var winnersOutputVal:Number = 0;
		public var currentClosest:Number = 0;
		
		public function SelfOrganizingMap(inputCount:int, outputCount:int, normalizationType:int):void
		{
			this.inputNeuronCount = inputCount;
			this.outputNeuronCount = outputCount;
			this.outputWeightMatrix = new Matrix(outputNeuronCount, inputNeuronCount + 1);
			this.output = [];
			this.normalizationType = normalizationType;
		}
		
		public function getWinner(input:NormalizeInput):int
		{
			var win:int = 0;
			
			var closest:Number = 1000;
			
			for (var i:int = 0; i < outputNeuronCount; i++)
			{
				var optr:Matrix = outputWeightMatrix.getColumn(i);
				
				output[i] = MatrixMath.calcVectorDistance(input.getInputMatrix(), optr);

				if (output[i] < closest)
				{
					closest = output[i];
					win = i;
				}
			}
			
			winnersOutputVal = closest;
			
			return win;
		}
		
		public function getStatisticsForAllOutputNeurons(input:NormalizeInput, trainingSetIndex:int, objectsList:Array = null):String
		{
			var line:String = "";
			var closest:Number = 1000;
			var closestIndex:int = 0;
			
			for (var i:int = 0; i < outputNeuronCount; i++)
			{
				var optr:Matrix = outputWeightMatrix.getColumn(i);
				
				var value:Number = MatrixMath.calcVectorDistance(input.getInputMatrix(), optr);
				line += "" + value.toFixed(3) + " ";
				
				if (value < closest) {
					closestIndex = i;
					closest = value;
				}
			}
			
			currentClosest = closest;
			
			line += " || best: " + closest.toFixed(3) + " # " + closestIndex;
			if (objectsList)
				line += " supposed: " + objectsList[trainingSetIndex] + " learnt: " + objectsList[closestIndex];
				
			return line;
		}
		
		public function getWinnersOutputVal():Number
		{
			return winnersOutputVal;
		}
		
		public function getWeightMatrix():Matrix
		{
			return outputWeightMatrix;
		}
	
	}

}