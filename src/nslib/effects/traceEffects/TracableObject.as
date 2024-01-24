/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.traceEffects
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import nslib.core.IReusable;
	import nslib.effects.events.TracableObjectEvent;
	import nslib.utils.UIDUtil;
	
	[Event(name="readyToBeRemoved",type="alexlib.effects.events.TracableObjectEvent")]
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TracableObject extends EventDispatcher implements IReusable
	{
		///////////////////////////////////////////////////////////////////////
		
		public var bitmapData:BitmapData;
		
		public var rect:Rectangle;
		
		public var uniqueKey:String = UIDUtil.generateUniqueID();
		
		public var fadeMultiplier:Number = 0.5;
		
		private var fadingOut:Boolean = false;
		
		private var alphaCounter:Number = 1;
		
		/////////////////////////////////////////////
		
		public function TracableObject(radius:int = 0, rotation:Number = 0)
		{
			_rotation = rotation;
			_radius = radius;
		}
		
		////////////////////////////////////////////////////////////////////////
		
		private var currentX:Number = 0;
		
		public function get x():Number
		{
			return currentX;
		}
		
		public function set x(value:Number):void
		{
			currentX = value;
		}
		
		private var currentY:Number = 0;
		
		public function get y():Number
		{
			return currentY;
		}
		
		public function set y(value:Number):void
		{
			currentY = value;
		}
		
		///////
		
		private var _radius:int = 3;
		
		public function get radius():int
		{
			return _radius;
		}
		
		public function set radius(value:int):void
		{
			if (_radius == value)
				return;
			
			_radius = value;
		}
		
		///////
		
		private var _rotation:Number = 0;
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void
		{
			if (_rotation == value)
				return;
			
			_rotation = value;
		}
		
		//----------------------------------
		//  poolID
		//----------------------------------
		
		private var _poolID:String = "none";
		
		public function get poolID():String
		{
			return _poolID;
		}
		
		public function set poolID(value:String):void
		{
			_poolID = value;
		}
		
		//----------------------------------
		//  applyBeforeBlurring
		//----------------------------------
		
		public function get applyBeforeBlurring():Boolean
		{
			return true;
		}
		
		////////////////////////////////////////////////////////////////////////
		
		public function prepareForPooling():void
		{
			// no implementation
		}
		
		public function prepareForReuse():void
		{
			fadingOut = false;
			alphaCounter = 1;
			currentX = 0;
			currentY = 0;
		}

		public function createBitmapData():void
		{
			bitmapData = new BitmapData(radius * 2 + 4, radius * 2 + 4, true, 0xFFFFFF);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(radius + 2, radius + 2);
			
			bitmapData.draw(draw(), matrix);
			
			rect = bitmapData.rect;
		}
		
		protected function draw():Shape
		{
			// must be overriden in subclasses
			return new Shape();
		}
		
		public function performColorTransform():void
		{
			if (fadingOut)
			{
				alphaCounter *= fadeMultiplier;
				
				if (alphaCounter < 0.1)
					fadingOutFinished();
			}
		}
		
		public function stop():void
		{
			fadingOut = true;
		}
		
		private function fadingOutFinished():void
		{
			dispatchEvent(new TracableObjectEvent(TracableObjectEvent.READY_TO_BE_REMOVED));
		}
	}

}