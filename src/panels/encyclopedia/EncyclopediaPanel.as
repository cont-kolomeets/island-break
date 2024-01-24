/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import nslib.controls.Button;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import panels.common.JungleFrameContainer;
	import panels.PanelBase;
	import supportClasses.ControlConfigurator;
	import supportClasses.SponsorInfoGenerator;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EncyclopediaPanel extends PanelBase
	{
		public static const BACK_CLICKED:String = "backClicked";
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/background book.png")]
		private static var backgroundBookImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/buttons/button back normal.png")]
		private static var backButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/buttons/button back over.png")]
		private static var backButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/buttons/button back down.png")]
		private static var backButtonDownImage:Class;
		
		////////////////
		
		private var frame:JungleFrameContainer = new JungleFrameContainer("Encyclopedia");
		
		private var backButton:Button = new Button();
		
		private var pageContainer:NSSprite = new NSSprite();
		
		// pages
		
		private var startPage:StartPanel = new StartPanel();
		
		private var storyPage:ImageSlidePanel;
		
		private var enemyWeaponPage:EnemyWeaponsListPanel;
		
		private var userWeaponPage:UserWeaponsListPanel;
		
		private var tipsPage:ImageSlidePanel;
		
		////////
		
		private var currentPage:PanelBase = null;
		
		////////////////
		
		public function EncyclopediaPanel()
		{
			constructPanel();
		}
		
		///////////////
		
		private function constructPanel():void
		{
			// to prevent all tooltips for hidden components
			mouseEnabled = true;
			
			// adding the main frame
			addChild(frame);
			
			var book:Bitmap = new backgroundBookImage() as Bitmap;
			
			book.x = (GamePlayConstants.STAGE_WIDTH - book.width) / 2;
			book.y = (GamePlayConstants.STAGE_HEIGHT - book.height) / 2;
			
			addChild(book);
			
			addChild(pageContainer);
			
			startPage.x = (GamePlayConstants.STAGE_WIDTH - startPage.width) / 2;
			startPage.y = 80;
			pageContainer.addChild(startPage);

			// adding a logo for sponsor
			var sponsorLogo:NSSprite = SponsorInfoGenerator.createSponsorLogoForEncyclopediaStartPage();

			sponsorLogo.x = -startPage.x + 87;
			sponsorLogo.y = GamePlayConstants.STAGE_HEIGHT - 70 - 80;
			startPage.addChild(sponsorLogo);
			
			// adding button
			ControlConfigurator.configureButton(backButton, backButtonNormalImage, backButtonOverImage, backButtonDownImage);
			backButton.x = 520;
			backButton.y = 470;
			addChild(backButton);
		}
		
		///////////////
		
		override public function show():void
		{
			super.show();
			backButton.addEventListener(ButtonEvent.BUTTON_CLICK, backButton_clickHandler);
			
			startPage.storyButton.addEventListener(MouseEvent.CLICK, storyButton_clickHandler);
			startPage.userWeaponButton.addEventListener(MouseEvent.CLICK, userWeaponButton_clickHandler);
			startPage.enemyWeaponButton.addEventListener(MouseEvent.CLICK, enemyWeaponButton_clickHandler);
			startPage.tipsButton.addEventListener(MouseEvent.CLICK, tipsButton_clickHandler);
			
			GameTracker.api.customMsg(TrackingMessages.VISITED_ECNYCLOPEDIA);
		}
		
		override public function hide():void
		{
			super.hide();
			backButton.removeEventListener(ButtonEvent.BUTTON_CLICK, backButton_clickHandler);
			
			startPage.storyButton.addEventListener(MouseEvent.CLICK, storyButton_clickHandler);
			startPage.userWeaponButton.addEventListener(MouseEvent.CLICK, userWeaponButton_clickHandler);
			startPage.enemyWeaponButton.addEventListener(MouseEvent.CLICK, enemyWeaponButton_clickHandler);
			startPage.tipsButton.addEventListener(MouseEvent.CLICK, tipsButton_clickHandler);
		}
		
		override public function applyPanelInfo(panelInfo:*):void
		{
			super.applyPanelInfo(panelInfo);
			
			if (currentPage)
				currentPage.applyPanelInfo(panelInfo);
		}
		
		////////////////
		
		private function setCurrentPage(page:PanelBase):void
		{
			// remove the previous page first
			if (currentPage)
				currentPage.hide();
			
			pageContainer.removeAllChildren();
			
			currentPage = page;
			
			// show a new one
			if (currentPage)
			{
				currentPage.show();
				currentPage.applyPanelInfo(panelInfo);
				pageContainer.addChild(currentPage);
			}
			else
				// or else show the starting page
				pageContainer.addChild(startPage);
		}
		
		/////////////////
		
		private function backButton_clickHandler(event:ButtonEvent):void
		{
			if (currentPage == null)
				dispatchEvent(new Event(BACK_CLICKED));
			else
			{
				setCurrentPage(null);
				frame.setTitleText("Encyclopedia");
			}
		}
		
		////////////////
		
		private function storyButton_clickHandler(event:MouseEvent):void
		{
			if (!storyPage)
				storyPage = new ImageSlidePanel(ImageSlidePanel.TYPE_STORY_PANEL);
			
			setCurrentPage(storyPage);
			
			frame.setTitleText("Story");
		}
		
		private function userWeaponButton_clickHandler(event:MouseEvent):void
		{
			if (!userWeaponPage)
				userWeaponPage = new UserWeaponsListPanel();
			
			setCurrentPage(userWeaponPage);
			
			frame.setTitleText("User weapons");
		}
		
		private function enemyWeaponButton_clickHandler(event:MouseEvent):void
		{
			if (!enemyWeaponPage)
				enemyWeaponPage = new EnemyWeaponsListPanel();
			
			setCurrentPage(enemyWeaponPage);
			
			frame.setTitleText("Enemy weapons");
		}
		
		private function tipsButton_clickHandler(event:MouseEvent):void
		{
			if (!tipsPage)
				tipsPage = new ImageSlidePanel(ImageSlidePanel.TYPE_TIP_PANEL);
			
			setCurrentPage(tipsPage);
			
			frame.setTitleText("Useful tips");
		}
	
	}

}