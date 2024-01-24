/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.events.Event;
	import nslib.controls.events.ButtonBarEvent;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ButtonBar extends LayoutContainer
	{
		////////////////
		
		public var buttonClass:Class = ButtonBarButtonBase;
		
		public var buttons:Array = [];
		
		///////////////
		
		public function ButtonBar()
		{
			horizontalGap = 10;
			verticalGap = 10;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
		}
		
		////////////////
		
		private var _dataProvider:Array = null;
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			
			clearButtonsHandlers();
			buttons.length = 0;
			removeAllChildren();
			
			if (value)
				createButtonsFromDataProvider();
		}
		
		///////////////
		
		private var _selectedIndex:int = 0;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			setSelectedIndex(value);
		}
		
		////////////////
		
		private function createButtonsFromDataProvider():void
		{
			var len:int = dataProvider.length;
			
			for (var i:int = 0; i < len; i++)
			{
				var button:ButtonBarButtonBase = new buttonClass();
				
				button.buttonIndex = i;
				// all important information is passed in object
				button.dataProviderObject = dataProvider[i];
				button.label = dataProvider[i].label;
				
				// selecting the first button
				if (i == 0)
					button.buttonIsUp = false;
				
				addChild(button);
				
				buttons.push(button);
			}
		}
		
		// adding listeners
		private function addedToStageHandler(event:Event):void
		{
			for each (var button:ButtonBarButtonBase in buttons)
				button.addEventListener(ButtonBarButtonBase.STATE_CHANGED, buttonChangedHandler);
		}
		
		// removing listeners
		private function removedFromStageHandler(event:Event):void
		{
			clearButtonsHandlers();
		}
		
		private function clearButtonsHandlers():void
		{
			for each (var button:ButtonBarButtonBase in buttons)
				button.removeEventListener(ButtonBarButtonBase.STATE_CHANGED, buttonChangedHandler);
		}
		
		///////////////
		
		private function buttonChangedHandler(event:Event):void
		{
			var index:int = ButtonBarButtonBase(event.currentTarget).buttonIndex;
			
			setSelectedIndex(index);
			
			dispatchEvent(new ButtonBarEvent(ButtonBarEvent.INDEX_CHANGED, index));
		}
		
		private function setSelectedIndex(index:int):void
		{
			index = Math.max(0, Math.min(index, buttons.length - 1));
			
			if (_selectedIndex == index)
				return;
			
			_selectedIndex = index;
			
			for each (var button:ButtonBarButtonBase in buttons)
				if (button.buttonIndex != index)
					button.buttonIsUp = true;
				else
					// force button to be in the down state
					button.buttonIsUp = false;
		}
	}

}