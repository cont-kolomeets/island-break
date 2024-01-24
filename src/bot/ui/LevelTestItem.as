package bot.ui
{
	import bot.events.StatEvent;
	import flash.display.Shape;
	import nslib.controls.CustomTextField;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import panels.statistics.StatInfo;
	import supportClasses.resources.FontResources;
	import supportControls.CheckBox;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class LevelTestItem extends NSSprite
	{
		public var checkBox:CheckBox = new CheckBox();
		
		public var showStatButton:ControlButton = new ControlButton("Stats");
		
		private var indicator:Shape = new Shape();
		
		private var liveLabel:CustomTextField = new CustomTextField(null, new FontDescriptor(15, 0, FontResources.BOMBARD));
		
		public function LevelTestItem(label:String)
		{
			construct();
			checkBox.label = label;
		}
		
		private function construct():void
		{
			reset();
			
			checkBox.y = -7;
			checkBox.x = 30;
			checkBox.fontDescriptor = new FontDescriptor(15, 0, FontResources.BOMBARD);
			
			showStatButton.x = 150;
			showStatButton.addEventListener(ButtonEvent.BUTTON_CLICK, showStatHandler);
			
			liveLabel.x = 170 + showStatButton.width;
			liveLabel.y = 5;
			
			addChild(indicator);
			addChild(checkBox);
			addChild(showStatButton);
			addChild(liveLabel);
		}
		
		public function reset():void
		{
			liveLabel.text = null;
			
			indicator.graphics.clear();
			indicator.graphics.lineStyle(2, 0);
			indicator.graphics.beginFill(0xAAAAAA);
			indicator.graphics.drawRect(0, 0, 20, 20);
			
			showStatButton.enabled = false;
			showStatButton.alpha = 0.5;
		}
		
		public function setFailed(livesLeft:int, livesTotal:int):void
		{
			indicator.graphics.clear();
			indicator.graphics.lineStyle(2, 0);
			indicator.graphics.beginFill(0xFF0000);
			indicator.graphics.drawRect(0, 0, 20, 20);
			
			liveLabel.text = "" + livesLeft + "/" + livesTotal;
		}
		
		public function setCompleted(livesLeft:int, livesTotal:int):void
		{
			indicator.graphics.clear();
			indicator.graphics.lineStyle(2, 0);
			indicator.graphics.beginFill(0x00FF00);
			indicator.graphics.drawRect(0, 0, 20, 20);
			
			liveLabel.text = "" + livesLeft + "/" + livesTotal;
		}
		
		public function applyStatData(statInfo:StatInfo):void
		{
			showStatButton.alpha = 1;
			showStatButton.enabled = true;
			
			if (statInfo.levelPassedSuccessfully)
				setCompleted(statInfo.livesLeft, statInfo.livesTotal);
			else
				setFailed(statInfo.livesLeft, statInfo.livesTotal);
		}
		
		private function showStatHandler(event:ButtonEvent):void
		{
			dispatchEvent(new StatEvent(StatEvent.SHOW_STAT, -1));
		}
	
	}

}