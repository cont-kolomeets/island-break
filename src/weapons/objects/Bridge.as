/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.objects
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import nslib.controls.NSSprite;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Bridge extends NSSprite
	{
		public static const DIRECTION_VERTICAL:String = "vertical";
		
		public static const DIRECTION_HORIZONTAL:String = "horizontal";
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/common images/bridge/bridge 01.png")]
		private static var baseImage:Class;
		
		//////////
		
		public var rect:Rectangle = null;
		
		//////////
		
		public function Bridge(direction:String = DIRECTION_HORIZONTAL)
		{
			_direction = direction;
			construct();
		}
		
		/////////
		
		private var _direction:String = DIRECTION_HORIZONTAL;
		
		public function get direction():String
		{
			return _direction;
		}
		
		/////////
		
		private function construct():void
		{
			rect = new Rectangle(-60, -60, 120, 120);
			
			var base:Bitmap = new baseImage() as Bitmap;
			
			if (direction == DIRECTION_HORIZONTAL)
			{
				base.x = -base.width / 2;
				base.y = -base.height / 2;
			}
			else
			{
				base.rotation = -90;
				base.x = -base.width / 2;
				base.y = base.height / 2;
			}
			
			addChild(base);
		}
		
		/////////
		
		// returns true if a weapon should go under the bridge
		public function weaponShouldGoUnder(weapon:Weapon, checkIntersection:Boolean = true):Boolean
		{
			if (checkIntersection && !rect.contains(weapon.x - this.x, weapon.y - this.y))
				return false;
			
			if (direction == DIRECTION_HORIZONTAL)
			{
				if (Math.abs(weapon.x - this.x) < rect.width / 3)
					return true;
			}
			else
			{
				if (Math.abs(weapon.y - this.y) < rect.height / 3)
					return true;
			}
			
			return false;
		}
	
	}

}