package nslib.designer 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ObjectParam 
	{
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public var scaleX:Number = 1;
		
		public var scaleY:Number = 1;
		
		public var alpha:Number = 1;
		
		public var rotation:Number = 0;
		
		////////////
		
		public function ObjectParam() 
		{
		}
		
		///////////
		
		public function fromObject(object:DisplayObject):void
		{
			x = object.x;
			y = object.y;
			scaleX = object.scaleX;
			scaleY = object.scaleY;
			alpha = object.alpha;
			rotation = object.rotation;
		}
		
		public function toObject(object:DisplayObject):void
		{
			object.x = x;
			object.y = y;
			object.scaleX = scaleX;
			object.scaleY = scaleY;
			object.alpha = alpha;
			object.rotation = rotation;
		}
		
	}

}