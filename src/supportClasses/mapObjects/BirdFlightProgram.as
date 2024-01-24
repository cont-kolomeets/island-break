/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.mapObjects
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BirdFlightProgram
	{
		public var birdTypes:Array = null;
		
		public var startingPoint:Point = null;
		
		public var anchorPoints:Array = null;
		
		public var travelRadii:Array = null;
		
		public var travelSpeed:Number = NaN;
		
		public var changeInterval:Number = 0;
		
		public var flyInLoop:Boolean = true;
		
		//public var removeAfterProgramIsOver:Boolean = false;
		
		public var locationDeviationPixels:int = 0;
		
		public var radiusDeviationPercentage:Number = 0;
		
		public var speedDeviationPercentage:Number = NaN;
		
		public function BirdFlightProgram()
		{
		
		}
	
	}

}