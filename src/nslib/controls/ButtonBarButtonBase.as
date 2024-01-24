/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.controls.ToggleButton;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ButtonBarButtonBase extends NSSprite
	{
		public static const STATE_CHANGED:String = "stateChanged";
		
		//////////
		
		public var dataProviderObject:Object = null;
		
		protected var button:ToggleButton = new ToggleButton();
		
		protected var labelField:CustomTextField = new CustomTextField();
		
		//////////
		
		public function ButtonBarButtonBase()
		{
			construct();
		}
		
		//////////
		
		private var _buttonIndex:int = 0;
		
		public function get buttonIndex():int
		{
			return _buttonIndex;
		}
		
		public function set buttonIndex(value:int):void
		{
			_buttonIndex = value;
		}
		
		///////
		
		private var _label:String = null;
		
		public function get label():String 
		{
			return _label;
		}
		
		public function set label(value:String):void 
		{
			_label = value;
			
			updateLabel();
		}
		
		///////
		
		public function set buttonIsUp(value:Boolean):void
		{
			if (value)
				button.setUp();
			else
				button.setDown();
		}
		
		////////
		
		private function construct():void
		{
			labelField.buttonMode = true;
			buttonMode = true;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
		}
		
		protected function updateLabel():void
		{
			// must be implemented in subclasses.
		}
		
		// adding listeners
		private function addedToStageHandler(event:Event):void
		{
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		// removing listeners
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			button.toggle();
			dispatchEvent(new Event(STATE_CHANGED));
		}
	}

}