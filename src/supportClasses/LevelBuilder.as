/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses
{
	import controllers.MapController;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.ui.Keyboard;
	import mainPack.GameController;
	import map.MapLibrary;
	import nslib.AIPack.grid.Location;
	import nslib.controls.CustomTextField;
	import nslib.core.Globals;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class LevelBuilder
	{
		public var gameController:GameController = null;
		
		public var mapController:MapController = null;
		
		public var resetLevel:Function = null;
		
		private var currentDescription:Array = null;
		
		private var items:Array = ["  ", "OW", "DO", "cb", "TV", "TH", "BV", "BH"];
		
		private var selectedItem:String = "  ";
		
		private var tipField:CustomTextField = new CustomTextField(null, new FontDescriptor(15, 0xE63CE1, FontResources.BOMBARD));
		
		// flags
		
		private var numberOfTeleports:int = 0;
		
		/////////////////////////////////////
		
		public function LevelBuilder()
		{
		}
		
		/////////////////////////////////////
		
		private var _isBuilding:Boolean = false;
		
		public function get isBuilding():Boolean
		{
			return _isBuilding;
		}
		
		/////////////////////////////////////
		
		public function getCurrentDescription():Array
		{
			return currentDescription;
		}
		
		public function startBuilding():void
		{
			_isBuilding = true;
			numberOfTeleports = 0;
			
			prepareInitialDescription();
			
			addInteraction();
			
			updateTextField();
			tipField.x = 10;
			tipField.y = 10;
			Globals.topLevelApplication.addChild(tipField);
		}
		
		public function addInteraction():void
		{
			Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			Globals.stage.addEventListener(MouseEvent.CLICK, stage_mouseClickHandler);
		}
		
		public function removeInteraction():void
		{
			Globals.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			Globals.stage.removeEventListener(MouseEvent.CLICK, stage_mouseClickHandler);
		}
		
		private function updateTextField():void
		{
			tipField.text = null;
			tipField.appendText("0 - empty (  )");
			tipField.caretToNextLine();
			tipField.appendText("1 - Only Weapon (OW)");
			tipField.caretToNextLine();
			tipField.appendText("2 - Default Obstacle (DO)");
			tipField.caretToNextLine();
			tipField.appendText("3 - Complitely Blocked (cb)");
			tipField.caretToNextLine();
			tipField.appendText("4 - Vertical Traffic Light (TV)");
			tipField.caretToNextLine();
			tipField.appendText("5 - Horizontal Traffic Light (TH)");
			tipField.caretToNextLine();
			/*tipField.appendText("4 - Teleport Input (I)");
			tipField.caretToNextLine();
			tipField.appendText("5 - Teleport Output (J)");
			tipField.caretToNextLine();*/
			tipField.appendText("6 - Vertical Bridge (VB)");
			tipField.caretToNextLine();
			tipField.appendText("7 - Horizontal Bridge (HB)");
			tipField.caretToNextLine();
			tipField.appendText("ENTER - save description");
			tipField.caretToNextLine();
			tipField.appendText("Z - undo");
			tipField.caretToNextLine();
			tipField.appendText("C - clear everything");
			tipField.caretToNextLine();
			tipField.appendText("ESCAPE - exit building mode");
			tipField.caretToNextLine();
			tipField.appendText("Selected: '" + selectedItem + "'");
			tipField.caretToNextLine();
		}
		
		private function prepareInitialDescription():void
		{
			prevDescriptions = null;
			
			currentDescription = copyDescription(mapController.currentMap.getMapDescription());
			
			resetLevel();
		}
		
		private function clearEverything():void
		{
			prevDescriptions = null;
			
			var clearDescription:Array = MapLibrary.getEmptyMap();
			
			// perform add operation
			currentDescription = copyDescription(mapController.currentMap.getMapDescription());
			
			var lenY:int = clearDescription.length;
			
			for (var indexY:int = 0; indexY < lenY; indexY++)
			{
				var array:Array = clearDescription[indexY] as Array;
				var lenX:int = array.length;
				
				for (var indexX:int = 0; indexX < lenX; indexX++)
					if (String(array[indexX]) == "  " || String(array[indexX]) == " " || String(array[indexX]) == "")
						currentDescription[indexY][indexX] = "  ";
			}
			
			resetLevel();
		}
		
		public function stopBuilding():void
		{
			_isBuilding = false;
			
			if (Globals.topLevelApplication.contains(tipField))
				Globals.topLevelApplication.removeChild(tipField);
			
			removeInteraction();
		}
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.NUMBER_0: 
					selectedItem = items[0];
					break;
				case Keyboard.NUMBER_1: 
					selectedItem = items[1];
					break;
				case Keyboard.NUMBER_2: 
					selectedItem = items[2];
					break;
				case Keyboard.NUMBER_3: 
					selectedItem = items[3];
					break;
				case Keyboard.NUMBER_4: 
					selectedItem = items[4];
					break;
				case Keyboard.NUMBER_5: 
					selectedItem = items[5];
					break;
				case Keyboard.NUMBER_6: 
					selectedItem = items[6];
					break;
				case Keyboard.NUMBER_7: 
					selectedItem = items[7];
					break;
				case Keyboard.NUMBER_8: 
					selectedItem = items[8];
					break;
				case Keyboard.ENTER: 
					saveCurrentDescription();
					break;
				case Keyboard.ESCAPE: 
					stopBuilding();
					break;
				case Keyboard.Z: 
					undo();
					break;
				case Keyboard.C: 
					clearEverything();
					break;
			}
			
			updateTextField();
		}
		
		private function descriptionContainsItem(item:String):Boolean
		{
			var lenY:int = currentDescription.length;
			
			for (var indexY:int = 0; indexY < lenY; indexY++)
			{
				var array:Array = currentDescription[indexY] as Array;
				var lenX:int = array.length;
				
				for (var indexX:int = 0; indexX < lenX; indexX++)
					if (String(array[indexX]) == item)
						return true;
			}
			
			return false;
		}
		
		private function stage_mouseClickHandler(event:MouseEvent):void
		{
			var itemToApply:String = selectedItem;
			
			if (selectedItem == "I")
			{
				if (descriptionContainsItem("I" + numberOfTeleports))
					return;
				
				itemToApply += numberOfTeleports;
			}
			else if (selectedItem == "J")
			{
				if (!descriptionContainsItem("I" + numberOfTeleports))
					return;
				
				itemToApply += numberOfTeleports;
				numberOfTeleports++;
			}
			
			var location:Location = mapController.currentMap.grid.generateLocationFromXY(event.stageX, event.stageY);
			
			backUpDescription();
			currentDescription[location.indexY - mapController.currentMap.grid.indexYMin][location.indexX - mapController.currentMap.grid.indexXMin] = itemToApply;
			
			resetLevel();
		}
		
		///////////////////// UNDO
		
		private var prevDescriptions:Array = null;
		
		private function backUpDescription():void
		{
			if (!prevDescriptions)
				prevDescriptions = [];
			
			prevDescriptions.push(copyDescription(currentDescription));
		}
		
		private function copyDescription(description:Array):Array
		{
			var copy:Array = [];
			
			for each (var array:Array in description)
				copy.push(array.slice());
			
			return copy;
		}
		
		private function undo():void
		{
			if (!prevDescriptions)
				return;
			
			var prevDescription:Array = prevDescriptions.pop();
			
			if (prevDescription)
			{
				currentDescription = prevDescription;
				resetLevel();
			}
		}
		
		///////////////////////// SAVE
		
		public function saveCurrentDescription():void
		{
			var finalString:String = "";
			
			for each (var array:Array in currentDescription)
				finalString += "localDescription.push(\"" + array.join(",") + "\");" + "\n";
			
			var fileReference:FileReference = new FileReference();
			fileReference.save(finalString, "Description_level " + (gameController.currentLevel + 1) + ".txt");
		}


	}

}