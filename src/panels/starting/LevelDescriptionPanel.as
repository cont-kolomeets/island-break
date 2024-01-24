/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import flash.display.Bitmap;
	import infoObjects.gameInfo.LevelInfo;
	import mainPack.ModeSettings;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class LevelDescriptionPanel extends NSSprite
	{
		[Embed(source="F:/Island Defence/media/images/panels/game status menu/lives.png")]
		private static var livesImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game status menu/money.png")]
		private static var moneyImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game status menu/wave.png")]
		private static var waveImage:Class;
		
		////////////
		
		private var levelDescription:CustomTextField = new CustomTextField();
		
		private var imageContainer:NSSprite = new NSSprite();
		
		///////////
		
		public function LevelDescriptionPanel()
		{
			construct();
		}
		
		////////////
		
		private function construct():void
		{
			levelDescription.textWidth = 320;
			levelDescription.fontDescriptor = new FontDescriptor(15, 0xF7FFAA, FontResources.BOMBARD);
			
			addChild(levelDescription);
			addChild(imageContainer);
		}

		public function showDescriptionForCurrentMode(levelInfo:LevelInfo, mode:String):void
		{
			levelDescription.text = null;
			imageContainer.removeAllChildren();
			
			if (mode == ModeSettings.MODE_NORMAL)
			{
				levelDescription.appendText("Campaign", new FontDescriptor(22, 0xFEFFF9, FontResources.BOMBARD));
				levelDescription.caretToNextLine(10);
				levelDescription.appendMultiLinedText(levelInfo.description, new FontDescriptor(16, 0xF7FFAA, FontResources.BOMBARD));
			}
			else
			{
				if (mode == ModeSettings.MODE_HARD)
					levelDescription.appendText("Hard Mode", new FontDescriptor(22, 0xF8310E, FontResources.BOMBARD));
				else if (mode == ModeSettings.MODE_UNREAL)
					levelDescription.appendText("Unreal Mode", new FontDescriptor(22, 0xC90DF0, FontResources.BOMBARD));
				
				levelDescription.caretToNextLine(10);
				
				var descriptions:Array = ModeSettings.getDescriptionsForLevel(levelInfo.index, mode);
				var len:int = descriptions.length - 1;
				
				for (var i:int = 0; i < len; i++)
				{
					var line:String = descriptions[i];
					
					addImageAt(levelDescription.currentCaretPosition.x, levelDescription.currentCaretPosition.y - 8);
					
					levelDescription.caretForward(30);
					levelDescription.appendText(line, new FontDescriptor(16, 0xF7FFAA, FontResources.BOMBARD));
					levelDescription.caretToNextLine(2);
				}
				
				levelDescription.currentCaretPosition.x = 0;
				levelDescription.currentCaretPosition.y = 90;
				
				levelDescription.appendText("Upgrades: ", new FontDescriptor(18, 0x1CFF3E, FontResources.BOMBARD));
				levelDescription.appendText(descriptions[len], new FontDescriptor(16, 0xF7FFAA, FontResources.BOMBARD));
			}
		}
		
		private function addImageAt(x:int, y:int):void
		{
			var icon:Bitmap = new waveImage() as Bitmap;
			icon.x = x;
			icon.y = y;
			
			imageContainer.addChild(icon);
		}
	
	}

}