/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.explosions 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import nslib.effects.traceEffects.TracableObject;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ExplosionRing extends TracableObject 
	{
		public var ringColor:int = 0;
		
		////////////////////////////////////////////////////////////////////////
		
		public function ExplosionRing(color:int = 0x00FF00)
		{
			super(0);
			
			ringColor = color;
			
			fadeMultiplier = 0;
		}
		
		//////////////////////////////////////////////////////
		
		override protected function draw():Shape
		{
			var ring:Shape = new Shape();
			
			ring.graphics.lineStyle(20, ringColor, 0.3);
			ring.graphics.drawCircle(0, 0, radius);
			ring.filters = [new BlurFilter(30, 30)];
			
			var matrix:Matrix = new Matrix();
			matrix.translate(radius + 20, radius + 20);
			
			bitmapData = new BitmapData(radius * 2 + 50, radius * 2 + 50, true, 0x00000000);
			bitmapData.draw(ring, matrix);
			
			rect = bitmapData.rect;
			
			return ring;
		}
		
		override public function performColorTransform():void 
		{
			draw();
			super.performColorTransform();
		}
		
	}

}