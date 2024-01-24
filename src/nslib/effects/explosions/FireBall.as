/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.explosions 
{
	import flash.display.GradientType;
	import flash.filters.BlurFilter;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class FireBall extends Particle
	{
		public var radius:int = 0;
		
		public var centerColor:int = 0xDAF516;
		
		public var rimColor:int = 0xD20000;
		
		public function FireBall() 
		{
			super();
			
			drawFireBall();
		}
		
		private function drawFireBall():void
		{
			graphics.beginGradientFill(GradientType.RADIAL, [centerColor, rimColor], [1, 0.9], [0, 50]);
			graphics.drawCircle(0, 0, radius);
			filters = [new BlurFilter(5, 5)];
		}
		
		public function update():void
		{
			drawFireBall();
		}
		
	}

}