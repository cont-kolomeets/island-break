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
	public class Edge
	{
		public var point1:Point;
		public var point2:Point;
		public var bounds:BoundaryRect;
		public var plane:Plane;
		
		public function Edge(point1:Point, point2:Point, normalsType:int , expand:int = 1)
		{
			this.point1 = point1;
			this.point2 = point2;
			
			var xMin:Number;
			var yMin:Number;
			var xMax:Number;
			var yMax:Number;
			
			if (point1.x <= point2.x)
			{
				xMin = point1.x;
				xMax = point2.x;
			}
			else
			{
				xMin = point2.x;
				xMax = point1.x;
			}
			
			if (point1.y <= point2.y)
			{
				yMin = point1.y;
				yMax = point2.y;
			}
			else
			{
				yMin = point2.y;
				yMax = point1.y;
			}
			
			bounds = new BoundaryRect(xMin - expand, yMin - expand, (xMax - xMin) + expand * 2, (yMax - yMin) + expand * 2);
			plane = GeometryCalculator.createPlaneForEdge(this, normalsType);
			
		}
		
		public function contains(pointX:Number, pointY:Number):Boolean
		{
			return bounds.contains(pointX, pointY);
		}
		
		public function containsAsPoint(point:Point):Boolean
		{
			return bounds.contains(point.x, point.y);
		}
		
		public function toString():String
		{
			return "point1: " + point1 + " point2: " + point2;
		}
	
	}

}