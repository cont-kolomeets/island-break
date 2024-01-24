/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.geometry
{
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Graph extends Shape
	{
		public var clearOnEveryDrawing:Boolean = false;
		public var precision:Number = 0.01;
		public var center:Point = new Point(0, 0);
		public var lineColor:int = 0;
		public var lineWeight:int = 1;
		public var lineAlpha:Number = 1;
		public var fillColor:int = 0;
		public var fillAlpha:Number = 1;
		public var useDashedLine:Boolean = false;
		public var dashLength:int = 5;
		
		public function Graph()
		{
			super();
		}
		
		public function lineStyle(lineWeight:int, lineColor:int, lineAlpha:Number, useDashedLine:Boolean = false):void
		{
			this.lineWeight = lineWeight;
			this.lineColor = lineColor;
			this.lineAlpha = lineAlpha;
			this.useDashedLine = useDashedLine;
		}
		
		public function fill(fillColor:int, fillAlpha:Number):void
		{
			this.fillColor = fillColor;
			this.fillAlpha = fillAlpha;
		}
		
		public function clear():void
		{
			graphics.clear();
		}
		
		// x0, y0 - staring point, x3, y3 - ending point.
		// x1, y1 - anchor 1, x2, y2 - anchor 2.
		public function drawBezierCurve(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, animate:Boolean = false, duration:Number = NaN):void
		{
			var param:CurveParameters = new CurveParameters();
			param.cx = 3 * (x1 - x0);
			param.bx = 3 * (x2 - x1) - param.cx;
			param.ax = x3 - x0 - param.cx - param.bx;
			param.cy = 3 * (y1 - y0);
			param.by = 3 * (y2 - y1) - param.cy;
			param.ay = y3 - y0 - param.cy - param.by;
			
			if (clearOnEveryDrawing)
				clear();
			
			graphics.lineStyle(lineWeight, lineColor, lineAlpha);
			graphics.endFill();
			
			var cycles:int = 1 / precision;
			
			param.x0 = x0;
			param.y0 = y0;
			param.curX = x0;
			param.curY = y0;
			
			if (animate)
			{
				var timer:Timer = new Timer(duration / cycles, cycles);
				var cyclesCount:int = 0;
				
				timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void
					{
						drawBezierCurveAtCycle(cyclesCount, param);
						cyclesCount++;
					});
				
				timer.start();
			}
			else
				for (var i:int = 0; i <= cycles; i++)
					drawBezierCurveAtCycle(i, param);
		}
		
		private function drawBezierCurveAtCycle(cycle:int, param:CurveParameters):void
		{
			var t:Number = precision * cycle;
			
			graphics.moveTo(param.curX, param.curY);
			var curXMemo:Number = param.curX;
			var curYMemo:Number = param.curY;
			param.curX = param.ax * t * t * t + param.bx * t * t + param.cx * t + param.x0;
			param.curY = param.ay * t * t * t + param.by * t * t + param.cy * t + param.y0;
			
			if (useDashedLine)
			{
				param.lineLen += Math.sqrt((param.curX - curXMemo) * (param.curX - curXMemo) + (param.curY - curYMemo) * (param.curY - curYMemo));
				
				if (param.lineLen > dashLength)
				{
					param.lineLen = 0;
					param.drawingDash = !param.drawingDash;
				}
				
				if (param.drawingDash)
					graphics.lineTo(param.curX, param.curY);
			}
			else
				graphics.lineTo(param.curX, param.curY);
			
			if (int(t * 100) == 50)
			{
				center.x = param.curX;
				center.y = param.curY;
			}
		}
		
		public function drawArc(radius:Number, angleFrom:Number, angleTo:Number, resolution:Number = 100):void
		{
			if (clearOnEveryDrawing)
				clear();
			
			graphics.lineStyle(lineWeight, lineColor, lineAlpha);
			graphics.endFill();
			
			var angle:Number = angleFrom;
			var deltaAlpha:Number = (angleTo - angleFrom) / resolution;
			var curX:Number = radius * NSMath.cosRad(angle);
			var curY:Number = radius * NSMath.sinRad(angle);
			
			for (var i:int = 0; i < resolution; i++)
			{
				graphics.moveTo(curX, curY);
				
				angle += deltaAlpha;
				curX = radius * NSMath.cosRad(angle);
				curY = radius * NSMath.sinRad(angle);
				
				graphics.lineTo(curX, curY);
			}
			
			graphics.moveTo(curX, curY);
		}
		
		public function drawSector(radius:Number, angleFrom:Number, angleTo:Number, resolution:Number = 100):void
		{
			if (clearOnEveryDrawing)
				clear();
			
			graphics.lineStyle(lineWeight, lineColor, lineAlpha);
			graphics.beginFill(fillColor, fillAlpha);
			
			var angle:Number = angleFrom;
			var deltaAlpha:Number = (angleTo - angleFrom) / resolution;
			var curX:Number = 0;
			var curY:Number = 0;
			
			graphics.moveTo(curX, curY);
			
			for (var i:int = 0; i < resolution; i++)
			{
				angle += deltaAlpha;
				curX = radius * NSMath.cosRad(angle);
				curY = radius * NSMath.sinRad(angle);
				
				graphics.lineTo(curX, curY);
			}
			
			graphics.lineTo(0, 0);
		}
		
		public function drawNoisyLine(x1:Number, y1:Number, x2:Number, y2:Number, amplitude:Number, repetitions:Number, useBlurSharpEffect:Boolean = false):void
		{
			var points:Array = [];
			
			if (clearOnEveryDrawing)
				clear();
			
			graphics.endFill();
			
			if (useBlurSharpEffect)
				graphics.lineStyle(lineWeight + 3, lineColor, lineAlpha / 4);
			else
				graphics.lineStyle(lineWeight, lineColor, lineAlpha);
			
			graphics.moveTo(x1, y1);
			
			var deltaX:Number = (x2 - x1) / repetitions;
			var deltaY:Number = (y2 - y1) / repetitions;
			var curX:Number = x1;
			var curY:Number = y1;
			
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;
			
			var a:Number = NSMath.atan2Rad(dy, dx);
			
			var cosValue:Number = NSMath.cosRad(NSMath.PI / 2 - a);
			var sinValue:Number = NSMath.sinRad(NSMath.PI / 2 - a);
			
			for (var i:int = 0; i < repetitions; i++)
			{
				curX = x1 + deltaX * i + (-deltaX / 4 + deltaX / 2 * NSMath.random()) + (-amplitude / 2 + amplitude * NSMath.random()) * cosValue;
				curY = y1 + deltaY * i + (-deltaY / 4 + deltaY / 2 * NSMath.random()) + (-amplitude / 2 + amplitude * NSMath.random()) * sinValue;
				
				graphics.lineTo(curX, curY);
				
				if (useBlurSharpEffect)
					points.push([curX, curY]);
			}
			
			graphics.lineTo(x2, y2);
			
			if (useBlurSharpEffect)
			{
				graphics.lineStyle(lineWeight, lineColor, lineAlpha);
				
				graphics.moveTo(x1, y1);
				for (var j:int = 0; j < repetitions; j++)
					graphics.lineTo(points[j][0], points[j][1]);
				
				graphics.lineTo(x2, y2);
			}
		}
	
	}

}

class CurveParameters
{
	public var x0:Number;
	public var y0:Number;
	
	public var cx:Number;
	public var bx:Number;
	public var ax:Number;
	public var cy:Number;
	public var by:Number;
	public var ay:Number;
	
	public var curX:Number;
	public var curY:Number;
	
	public var lineLen:int = 0;
	public var drawingDash:Boolean = true;
}