package bot.ui 
{
	import constants.GamePlayConstants;
	import flash.display.Sprite;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.AlignUtil;
	import nslib.utils.FontDescriptor;
	import panels.settings.LabeledSliderContainer;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class GameBotUIPanel extends NSSprite 
	{
		public var speedSlider:LabeledSliderContainer = new LabeledSliderContainer();
				
		private var shadowScreen:Sprite = new Sprite();
		
		//////////
		
		public function GameBotUIPanel() 
		{
			construct();
		}
		
		/////////
		
		private function construct():void
		{
			shadowScreen.graphics.clear();
			shadowScreen.graphics.beginFill(0, 0.2);
			shadowScreen.graphics.drawRect(0, 0, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			
			addChild(shadowScreen);
			
			var title:CustomTextField = new CustomTextField("BOT PLAYING", new FontDescriptor(50, 0xFFFFFF, FontResources.BOMBARD));
			
			AlignUtil.centerWidth(title, this);
			title.y = 5;
			
			addChild(title);
			
			speedSlider.nameLabel = "Game Speed";
			speedSlider.x = GamePlayConstants.STAGE_WIDTH - speedSlider.width - 50;
			speedSlider.y = 50;
			
			addChild(speedSlider);
		}
		
	}

}