/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.geometry
{
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class GeometryCalculator
	{
		
		public function GeometryCalculator()
		{
		
		}
		
		public static function calcDist(point1:Point, point2:Point):Number
		{
			var dx:Number = point1.x - point2.x;
			var dy:Number = point1.y - point2.y;
			
			return MathEasy.sqrt(dx * dx + dy * dy);
		}
		
		public static function calcInersectionPoint(point1:Point, point2:Point, point3:Point, point4:Point):Point
		{
			var result:Point = new Point(0, 0);
			var a1:Number = (point2.y - point1.y) / (point2.x - point1.x + 0.00000001);
			var b1:Number = point1.y - point1.x * a1;
			
			var a2:Number = (point4.y - point3.y) / (point4.x - point3.x + 0.00000001);
			var b2:Number = point3.y - point3.x * a2;
			
			result.x = (b1 - b2) / (a2 - a1 + 0.00000001);
			result.y = b1 + a1 * result.x;
			
			return result;
		}
		
		public static function boundsIntersect(bound1:BoundaryRect, bound2:BoundaryRect):Boolean
		{
			if ((bound1.x + bound1.width) < bound2.x)
				return false;
			if ((bound2.x + bound2.width) < bound1.x)
				return false;
			
			if ((bound1.y + bound1.height) < bound2.y)
				return false;
			if ((bound2.y + bound2.height) < bound1.y)
				return false;
			
			return true;
		}
		
		public static function boundAndEdgeIntersect(bound1:BoundaryRect, edge:Edge):Boolean
		{
			var pointUL:Point = new Point(bound1.x, bound1.y);
			var pointUR:Point = new Point(bound1.x + bound1.width, bound1.y);
			var pointLL:Point = new Point(bound1.x, bound1.y + bound1.height);
			var pointLR:Point = new Point(bound1.x + bound1.width, bound1.y + bound1.height);
			
			if (bound1.containsPoint(calcInersectionPoint(pointUL, pointUR, edge.point1, edge.point2)))
				return true;
			if (bound1.containsPoint(calcInersectionPoint(pointUR, pointLR, edge.point1, edge.point2)))
				return true;
			if (bound1.containsPoint(calcInersectionPoint(pointLR, pointLL, edge.point1, edge.point2)))
				return true;
			if (bound1.containsPoint(calcInersectionPoint(pointLL, pointUL, edge.point1, edge.point2)))
				return true;
			
			return false;
		}
		
		public static function findClosesPointToEdgeFromPoint(point:Point, edge:Edge):Point
		{
			var dx:Number = edge.point2.x - edge.point1.x;
			var dy:Number = edge.point2.y - edge.point1.y;
			var tga:Number = dy / (dx + 0.000000001);
			var b:Number = edge.point1.y - edge.point1.x * tga;
			
			var tgb:Number = NSMath.tan(NSMath.PI / 2 + NSMath.atan2(dy, dx));
			
			var b1:Number = point.y - point.x * tgb;
			
			var x:Number = (b - b1) / (tgb - tga + 0.00000001);
			var y:Number = tga * x + b;
			
			return new Point(x, y);
		}
		
		public static function calcDistFromPointToPlane(point:Point, plane:Plane):Number
		{
			return (point.x * plane.a + point.y * plane.b + plane.c);
		}
		
		public static function pointsAreAtTheSameSideFromLine(edge:Edge, point1:Point, point2:Point):Boolean
		{
			var dx:Number = edge.point2.x - edge.point1.x;
			var dy:Number = edge.point2.y - edge.point1.y;
			var tga:Number = dy / (dx + 0.000000001);
			var b:Number = edge.point1.y - edge.point1.x * tga;
			
			var b1:Number = point1.y - point1.x * tga;
			var b2:Number = point2.y - point2.x * tga;
			
			if (((b1 < b) && (b2 < b)) || ((b1 > b) && (b2 > b)))
				return true;
			
			return false;
		}
		
		public static function pointIsAboveEdge(point:Point, edge:Edge):Boolean
		{
			var dx:Number = edge.point2.x - edge.point1.x;
			var dy:Number = edge.point2.y - edge.point1.y;
			var tga:Number = dy / (dx + 0.000000001);
			var b:Number = edge.point1.y - edge.point1.x * tga;
			
			var b1:Number = point.y - point.x * tga;
			
			if (b1 > b)
				return true;
			
			return false;
		}
		
		public static function calcDistFromPointToEdge(point:Point, edge:Edge):Number
		{
			//return calcDist(point, findClosesPointToEdgeFromPoint(point, edge));
			return calcDistFromPointToPlane(point, edge.plane);
		}
		
		public static function createPlaneForEdge(edge:Edge, normalsType:int):Plane
		{
			var dx:Number = edge.point2.x - edge.point1.x;
			var dy:Number = edge.point2.y - edge.point1.y;
			var a:Number = NSMath.atan2(dy, dx);
			
			var planeA:Number = 0;
			var planeB:Number = 0;
			var planeC:Number = 0;
			
			if (normalsType == NormalsType.NORMALS_INSIDE)
			{
				planeA = -NSMath.cos(-NSMath.PI / 2 + a);
				planeB = -NSMath.sin(-NSMath.PI / 2 + a);
			}
			if (normalsType == NormalsType.NORMALS_OUTSIDE)
			{
				planeA = NSMath.cos(NSMath.PI / 2 - a);
				planeB = -NSMath.sin(NSMath.PI / 2 - a);
			}
			
			if (pointsAreAtTheSameSideFromLine(edge, new Point(0, 0), new Point(edge.point1.x + planeA, edge.point1.y + planeB)))
				planeC = calcDist(new Point(0, 0), findClosesPointToEdgeFromPoint(new Point(0, 0), edge));
			else
				planeC = -calcDist(new Point(0, 0), findClosesPointToEdgeFromPoint(new Point(0, 0), edge));
			
			return new Plane(planeA, planeB, planeC);
		}
		
		public static function calcNormalVectorFor2Balls(ballReflecting:Ball, ballSteady:Ball):Point
		{
			var dx:Number = ballSteady.x - ballReflecting.x;
			var dy:Number = ballSteady.y - ballReflecting.y;
			var a:Number = NSMath.atan2(dy, dx);
			
			return new Point(-NSMath.cos(a), -NSMath.sin(a));
		}
		
		// needs to be checked!
		public static function findPointAtDistanceFromEdge(edge:Edge, pointAtEdge:Point, distance:Number):Boolean
		{
			var dx:Number = edge.point2.x - edge.point1.x;
			var dy:Number = edge.point2.y - edge.point1.y;
			
			var a:Number = NSMath.atan2(dy, dx);
			
			var x:Number = pointAtEdge.x + distance * cos(NSMath.PI / 2 - a);
			var y:Number = pointAtEdge.y + distance * sin(NSMath.PI / 2 - a);
			
			return new Point(x, y);
		}
	
	}

}