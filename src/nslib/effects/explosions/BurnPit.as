/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.explosions
{
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import nslib.effects.traceEffects.TracableObject;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BurnPit extends TracableObject
	{
		public var centerColor:int = 0;
		
		public var rimColor:int = 0xAAAAAA;
		
		////////////////////////////////////////////////////////////////////////
		
		public function BurnPit(radius:int = 3)
		{
			super(radius);
		}
		
		//////////////////////////////////////////////////////
		
		override protected function draw():Shape
		{
			var fragmentShape:Shape = new Shape();
			
			fragmentShape.graphics.beginGradientFill(GradientType.RADIAL, [centerColor, rimColor], [0.7, 0.6], [0, radius * 2]);
			fragmentShape.graphics.drawCircle(0, 0, radius);
			fragmentShape.filters = [new BlurFilter(radius / 2, radius / 2)]
			
			return fragmentShape;
		}
	}

}