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
	import nslib.controls.events.ToggleButtonEvent;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ToggleButton extends NSSprite
	{
		public var upButton:Button = new Button();
		
		public var downButton:Button = new Button();
		
		private var isUp:Boolean = true;
		
		private var isAddedToStage:Boolean = false;
		
		public function ToggleButton(upLabel:String = "", downLabel:String = "")
		{
			super();
			
			addChild(upButton);
			addChild(downButton);
			
			upButton.label = upLabel;
			downButton.label = downLabel;
			
			updateState();
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			isAddedToStage = true;
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
			
			if (useManualToggle)
				addEventListener(MouseEvent.CLICK, this_clickHandler, false, 0, true);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			isAddedToStage = false;
			
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			
			removeEventListener(MouseEvent.CLICK, this_clickHandler, false);
		}
		
		////////////////////////
		
		// if true, a user has to change states manually calling methods setUp() and setDown().
		private var _useManualToggle:Boolean = false;
		
		public function get useManualToggle():Boolean
		{
			return _useManualToggle;
		}
		
		public function set useManualToggle(value:Boolean):void
		{
			_useManualToggle = value;
			
			if (!value)
				removeEventListener(MouseEvent.CLICK, this_clickHandler, false);
			else if (isAddedToStage)
				addEventListener(MouseEvent.CLICK, this_clickHandler, false, 0, true);
		}
		
		/////////////////////////
		
		public function get isUpState():Boolean
		{
			return isUp;
		}
		
		//////////
		
		public function setUp():void
		{
			isUp = true;
			updateState();
		}
		
		public function setDown():void
		{
			isUp = false;
			updateState();
		}
		
		public function toggle():void
		{
			isUp = !isUp;
			updateState();
		}
		
		private function this_clickHandler(event:MouseEvent):void
		{
			toggle();
			dispatchEvent(new ToggleButtonEvent(ToggleButtonEvent.STATE_CHANGED_USER_INTERACTION));
		}
		
		private function updateState():void
		{
			upButton.visible = isUp;
			downButton.visible = !isUp;
			
			dispatchEvent(new ToggleButtonEvent(ToggleButtonEvent.STATE_CHANGED));
		}
	
	}

}