package bot.ui
{
	import bot.events.StatEvent;
	import bot.ui.ControlButton;
	import constants.GamePlayConstants;
	import flash.display.Sprite;
	import flash.events.Event;
	import nslib.controls.LayoutContainer;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.LayoutConstants;
	import panels.settings.LabeledSliderContainer;
	import panels.statistics.StatInfo;
	import supportControls.CheckBox;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class BotGlobalTestControlPanel extends NSSprite
	{
		public var speedSlider:LabeledSliderContainer = new LabeledSliderContainer();
		
		public var useSuperSpeedButton:CheckBox = new CheckBox("Super Speed");
		
		public var startButton:ControlButton = new ControlButton("Start");
		
		public var stopButton:ControlButton = new ControlButton("Stop");
		
		public var closeButton:ControlButton = new ControlButton("Close");
		
		private var shadowScreen:Sprite = new Sprite();
		
		private var allCheckBox:CheckBox = new CheckBox("All");
		
		private var level0CheckBox:LevelTestItem = new LevelTestItem("Level 1");
		private var level1CheckBox:LevelTestItem = new LevelTestItem("Level 2");
		private var level2CheckBox:LevelTestItem = new LevelTestItem("Level 3");
		private var level3CheckBox:LevelTestItem = new LevelTestItem("Level 4");
		private var level4CheckBox:LevelTestItem = new LevelTestItem("Level 5");
		private var level5CheckBox:LevelTestItem = new LevelTestItem("Level 6");
		private var level6CheckBox:LevelTestItem = new LevelTestItem("Level 7");
		private var level7CheckBox:LevelTestItem = new LevelTestItem("Level 8");
		private var level8CheckBox:LevelTestItem = new LevelTestItem("Level 9");
		private var level9CheckBox:LevelTestItem = new LevelTestItem("Level 10");
		
		private var checkBoxContainer:LayoutContainer = new LayoutContainer();
		
		private var checkboxes:Array = null;
		
		//////////////
		
		public function BotGlobalTestControlPanel()
		{
			construct();
		}
		
		///////////////
		
		private function construct():void
		{
			shadowScreen.graphics.clear();
			shadowScreen.graphics.beginFill(0xAAAAAA, 0.8);
			shadowScreen.graphics.drawRect(0, 0, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			
			addChild(shadowScreen);
			
			checkboxes = [level0CheckBox, level1CheckBox, level2CheckBox, level3CheckBox, level4CheckBox, level5CheckBox, level6CheckBox, level7CheckBox, level8CheckBox, level9CheckBox];
			
			checkBoxContainer.x = 50;
			checkBoxContainer.y = 10;
			
			checkBoxContainer.layout = LayoutConstants.VERTICAL;
			checkBoxContainer.horizontalAlignment = "left";
			
			checkBoxContainer.addChild(allCheckBox);
			
			for each (var checkBox:LevelTestItem in checkboxes)
			{
				checkBox.addEventListener(StatEvent.SHOW_STAT, showStatHandler);
				checkBoxContainer.addChild(checkBox);
			}
			
			var buttonContainer:LayoutContainer = new LayoutContainer();
			buttonContainer.layout = LayoutConstants.HORIZONTAL;
			
			buttonContainer.addChild(startButton);
			buttonContainer.addChild(stopButton);
			buttonContainer.addChild(closeButton);
			
			checkBoxContainer.addChild(buttonContainer);
			
			addChild(checkBoxContainer);
			
			allCheckBox.addEventListener(CheckBox.STATE_CHANGED, allCheckBox_stateChangedHandler);
			
			speedSlider.nameLabel = "Game Speed";
			speedSlider.x = GamePlayConstants.STAGE_WIDTH - speedSlider.width - 80;
			speedSlider.y = 50;
			
			addChild(speedSlider);
			
			useSuperSpeedButton.x = GamePlayConstants.STAGE_WIDTH - speedSlider.width - 80;
			useSuperSpeedButton.y = 90;
			useSuperSpeedButton.addEventListener(CheckBox.STATE_CHANGED, useSuperSpeedButton_stateChangedHandler);
			
			addChild(useSuperSpeedButton);
		}
		
		public function reset():void
		{
			for each (var checkBox:LevelTestItem in checkboxes)
				checkBox.reset();
		}
		
		private function selectAll():void
		{
			for each (var checkBox:LevelTestItem in checkboxes)
				checkBox.checkBox.selected = true;
		}
		
		private function deselectAll():void
		{
			for each (var checkBox:LevelTestItem in checkboxes)
				checkBox.checkBox.selected = false;
		}
		
		private function allCheckBox_stateChangedHandler(event:Event):void
		{
			if (allCheckBox.selected)
				selectAll();
			else
				deselectAll();
		}
		
		public function getSelectedLevels():Array
		{
			var result:Array = [];
			
			for (var i:int = 0; i < checkboxes.length; i++)
				if (LevelTestItem(checkboxes[i]).checkBox.selected)
					result.push(i);
			
			return result;
		}
		
		public function applyStatInfo(statInfo:StatInfo):void
		{
			var checkbox:LevelTestItem = checkboxes[statInfo.levelIndex];
			
			checkbox.applyStatData(statInfo);
		}
		
		private function showStatHandler(event:StatEvent):void
		{
			event.levelIndex = checkboxes.lastIndexOf(event.currentTarget);
			
			dispatchEvent(event);
		}
		
		private function useSuperSpeedButton_stateChangedHandler(event:Event):void
		{
			speedSlider.enabled = !useSuperSpeedButton.selected;
		}
	}

}