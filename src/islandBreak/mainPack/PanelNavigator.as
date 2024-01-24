package islandBreak.mainPack 
{
	import islandBreak.panels.AchievementsPanel;
	import islandBreak.panels.CreditsPanel;
	import islandBreak.panels.DevelopmentPanel;
	import islandBreak.panels.GameControlPanel;
	import islandBreak.panels.GameStage;
	import islandBreak.panels.IntroPanel;
	import nslib.controls.NSSprite;
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class PanelNavigator extends NSSprite
	{
		public var introPanel:IntroPanel = new IntroPanel();
		
		public var creditsPanel:CreditsPanel = new CreditsPanel();
		
		public var gameStage:GameStage = new GameStage();
		
		public var developmentPanel:DevelopmentPanel = new DevelopmentPanel();
		
		public var achievementsPanel:AchievementsPanel = new AchievementsPanel();
		
		/////////////////////
		
		public function PanelNavigator() 
		{
			init();
		}
		
		////////////////////
		
		public function get gameControlPanel():GameControlPanel
		{
			return gameStage.gameControlPanel;
		}
		
		////////////////////
		
		private function init():void
		{
			addChild(gameStage);
			addChild(introPanel);
		}
		
	}

}