/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.SOM
{
	import nslib.matrixUtils.Matrix;
	
	public class TrainSelfOrganizingMap
	{
		
		public var map:SelfOrganizingMap;
		public var normailizer:NormalizeInput;
		public var trainingSet:Array;
		public var overallError:Number = 0;
		private var currentTSetIndex:int = 0;
		public var finished:Boolean = false;
		
		public function TrainSelfOrganizingMap():void
		{
		}
		
		public function initialize(map:SelfOrganizingMap, trainingSet:Array):void
		{
			this.map = map;
			this.trainingSet = trainingSet;
			
			finished = false;
			currentTSetIndex = 0;
		}

		public function iteration():void
		{
			if (currentTSetIndex < trainingSet.length)
			{
				normailizer = new NormalizeInput(NormalizationType.MULTIPLICATIVE);
				normailizer.calculateFactors(trainingSet[currentTSetIndex] as Array);
				
				var inputMatrix:Matrix = normailizer.getInputMatrix();
				
				for (var i:int = 0; i < inputMatrix.getNOfRows(); i++)
				{
					map.outputWeightMatrix.setValueAt(inputMatrix.getValueAt(0, i), currentTSetIndex, i);
				}
				
				currentTSetIndex++;
			}
			else
				finished = true;
		}
		
		
		
		public function summarizeResults(objectsList:Array = null, indexInListForINeuron:Array = null):void
		{
			overallError = 0;
			
			for (var i:int = 0; i < trainingSet.length; i++)
			{
				normailizer = new NormalizeInput(NormalizationType.MULTIPLICATIVE);
				normailizer.calculateFactors(trainingSet[i] as Array);
				trace(map.getStatisticsForAllOutputNeurons(normailizer, i, objectsList));
				overallError += map.currentClosest;
			}
			
			overallError /= trainingSet.length;
			
			trace("Error=" + overallError);
		}
	}

}