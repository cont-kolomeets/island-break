/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.sequencers
{
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MultiSequencer extends NSSprite
	{
		private var states:Array = [];
		
		/////////////////
		
		public function MultiSequencer()
		{
			super();
		}
		
		//////////////////
		
		private var _smoothing:Boolean = false;
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
			
			for each (var imSeq:ImageSequencer in states)
				imSeq.smoothing = value;
		}
		
		/////////////////
		
		public function addState(state:String, imageSequencer:ImageSequencer):void
		{
			states[state] = imageSequencer;
			
			imageSequencer.smoothing = this.smoothing;
		}
		
		public function addStateAsImage(state:String, image:*):void
		{
			var imageSequencer:ImageSequencer = new ImageSequencer();
			imageSequencer.addImage(image);
			
			addState(state, imageSequencer);
		}
		
		public function removeAllStates():void
		{
			stopAllStates();
			
			states.length = 0;
			removeAllChildren();
		}
		
		public function stopAllStates():void
		{
			for each (var imSeq:ImageSequencer in states)
				imSeq.stop();
		}
		
		public function playState(state:String):void
		{
			if (!states[state])
				return;
			
			for each (var imSeq:ImageSequencer in states)
				imSeq.stop();
			
			removeAllChildren();
			
			ImageSequencer(states[state]).start();
			
			addChild(ImageSequencer(states[state]));
		}
	
	}

}