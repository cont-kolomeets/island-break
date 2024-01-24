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
	public class ExplosionFragment extends TracableObject 
	{
		public var centerColor:int = 0xD7581C;
		
		public var rimColor:int = 0x6C503E;
		
		////////////////////////////////////////////////////////////////////////
		
		public function ExplosionFragment(radius:int = 3)
		{
			super(radius);
			//fadeMultiplier = WeaponContants.BULLET_FADE_MULTIPLIER;
		}
		
		//////////////////////////////////////////////////////
		
		override protected function draw():Shape
		{
			var fragmentShape:Shape = new Shape();
			
			fragmentShape.graphics.beginGradientFill(GradientType.RADIAL, [centerColor, rimColor], [1, 1], [0, 12]);
			fragmentShape.graphics.drawCircle(0, 0, radius);
			fragmentShape.filters = [new BlurFilter(3, 3)]
			
			return fragmentShape;
		}
		
	}

}