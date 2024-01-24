/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls 
{
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SliderRange extends NSSprite 
	{
		
		public function SliderRange() 
		{
			super();
		}
		
		//////////////////
		
				
		private var _value:Number = 0;
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(newValue:Number):void 
		{
			_value = newValue;
			invalidateProperties();
		}
		
		///////////
		
		private var _maximum:Number = 100;
		
		public function get maximum():Number 
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void 
		{
			_maximum = value;
			invalidateProperties();
		}
		
		//////////////////
		
		private var _minimum:Number = 0;
		
		public function get minimum():Number 
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void 
		{
			_minimum = value;
			invalidateProperties();
		}
		
		//////////////////
		
		private var _snapInterval:Number = 0;
		
		public function get snapInterval():Number 
		{
			return _snapInterval;
		}
		
		public function set snapInterval(value:Number):void 
		{
			_snapInterval = value;
		}
		
	}

}