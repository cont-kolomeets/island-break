/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.fireWorks
{
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class FireWorkParticle extends Shape
	{
		public static const TYPE_SQUARE:String = "square";
		
		public static const TYPE_CIRCLE:String = "circle";
		
		public static const TYPE_STAR:String = "star";
		
		public var lifeTime:Number = 0;
		
		public var existingTime:Number = 0;
		
		public var vx:Number = 0;
		
		public var vy:Number = 0;
		
		public var deactivated:Boolean = false;
		
		private var type:String = null;
		
		public function FireWorkParticle(color:int, radius:Number, type:String)
		{
			this.type = type;
			
			construct(color, radius);
		}
		
		private function construct(color:int, radius:Number):void
		{
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.beginFill(color);
			
			if (type == TYPE_SQUARE)
				graphics.drawRect(-radius / 2, -radius / 2, radius, radius);
			else if (type == TYPE_CIRCLE)
				graphics.drawCircle(0, 0, radius);
			else if (type == TYPE_STAR)
			{
				graphics.moveTo(0, -radius);
				graphics.lineTo(radius / 3, -radius / 3);
				graphics.lineTo(radius, -radius / 2.7);
				graphics.lineTo(radius / 2.2, radius / 4);
				graphics.lineTo(radius / 1.8, radius / 1.2);
				graphics.lineTo(0, radius / 2);
				graphics.lineTo(-radius / 1.8, radius / 1.2);
				graphics.lineTo(-radius / 2.2, radius / 4);
				graphics.lineTo(-radius, -radius / 2.7);
				graphics.lineTo(-radius / 3, -radius / 3);
				graphics.moveTo(0, -radius);
			}
			else
				throw new Error("Specified unsupportable type!");
		}
	
	}

}