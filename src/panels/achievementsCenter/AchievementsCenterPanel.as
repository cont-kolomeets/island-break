/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.achievementsCenter
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import infoObjects.gameInfo.GameInfo;
	import nslib.controls.events.ButtonBarEvent;
	import nslib.controls.events.ButtonEvent;
	import panels.common.JungleFrameContainer;
	import panels.PanelBase;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AchievementsCenterPanel extends PanelBase
	{
		public static const BACK_CLICKED:String = "backClicked";
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/golden cup.png")]
		private static var goldenCupImage:Class;
		
		////////////
		
		private var frame:JungleFrameContainer = new JungleFrameContainer("Achievements");
		
		private var pager:AchievementsCenterPager = new AchievementsCenterPager();
		
		private var toolBar:AchievementsCenterToolBar = new AchievementsCenterToolBar();
		
		////////////
		
		public function AchievementsCenterPanel()
		{
			construct();
		}
		
		/////////////
		
		private function construct():void
		{
			addChild(frame);
			
			var goldenCup:Bitmap = new goldenCupImage() as Bitmap;
			
			goldenCup.x = (frame.width - goldenCup.width) / 2;
			goldenCup.y = (frame.height - goldenCup.height) / 2;
			addChild(goldenCup);
			
			pager.x = 50;
			pager.y = 85;
			addChild(pager);
			
			toolBar.x = 0;
			toolBar.y = 470;
			addChild(toolBar);
		}
		
		/////////////
		
		override public function show():void
		{
			super.show();
			toolBar.backButton.addEventListener(ButtonEvent.BUTTON_CLICK, backButton_clickHandler);
			
			toolBar.pageButtonBar.addEventListener(ButtonBarEvent.INDEX_CHANGED, pageButtonBar_indexChangedHandler);
			
			resetPaging();
			
			GameTracker.api.customMsg(TrackingMessages.VISITED_ACHIEVEMENTS);
		}
		
		override public function hide():void
		{
			super.hide();
			toolBar.backButton.removeEventListener(ButtonEvent.BUTTON_CLICK, backButton_clickHandler);
			
			toolBar.pageButtonBar.removeEventListener(ButtonBarEvent.INDEX_CHANGED, pageButtonBar_indexChangedHandler);
		}
		
		/////////////
		
		override public function applyPanelInfo(panelInfo:*):void 
		{
			super.applyPanelInfo(panelInfo);
			
			pager.displayAchievements(GameInfo(panelInfo));
		}
		
		/////////////
		
		private function backButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(BACK_CLICKED));
		}
		
		private function pageButtonBar_indexChangedHandler(event:ButtonBarEvent):void
		{
			pager.showPageAt(event.newIndex);
		}
		
		private function resetPaging():void
		{
			// force showing the 1st page
			toolBar.pageButtonBar.selectedIndex = 0;
			pager.showPageAt(0);
		}
	
	}

}