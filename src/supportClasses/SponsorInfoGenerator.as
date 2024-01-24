/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.engine.FontDescription;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.AlignUtil;
	import nslib.utils.FontDescriptor;
	import nslib.utils.PopUpUtil;
	import panels.achievementsCenter.MultiPerposedNotificationContainer;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class SponsorInfoGenerator
	{
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/sponsor logo panel.png")]
		private static var sponsorLogoPanelImage:Class;
		
		////////////
		
		private static var sponsorLogosHash:Object = {};
		
		////////////
		
		public static function createSponsorsLogoForPreloadingPage():NSSprite
		{
			var logoImage:Bitmap = new sponsorLogoPanelImage() as Bitmap;
			var sprite:NSSprite = new NSSprite();
			
			sprite.addChild(logoImage);
			
			sprite.mouseEnabled = true;
			sprite.buttonMode = true;
			
			sponsorLogosHash["preloadingPage"] = sprite;
			sprite.addEventListener(MouseEvent.CLICK, sponsorLogo_clickedHanlder);
			
			return sprite;
		}
		
		public static function releasePreloaderLogo():void
		{
			if (sponsorLogosHash["preloadingPage"] != undefined)
			{
				sponsorLogosHash["preloadingPage"].removeEventListener(MouseEvent.CLICK, sponsorLogo_clickedHanlder);
				delete sponsorLogosHash["preloadingPage"];
			}
		}
		
		private static function createLogoWithText(id:String, singleLined:Boolean = false, fontSize:int = 16):NSSprite
		{
			var container:NSSprite = new NSSprite();
			container.mouseEnabled = true;
			container.buttonMode = true;
			
			var logo:Shape = createLogoPlaceHolder();
			
			container.addChild(logo);
			
			var sponsorLabel:CustomTextField = new CustomTextField(null, new FontDescriptor(fontSize, 0xF9EC91, FontResources.KOMTXTB));
			
			if (singleLined)
			{
				sponsorLabel.text = "MORE GAMES";
				sponsorLabel.x = 35;
				sponsorLabel.y = 7 - (fontSize - 16);
			}
			else
			{
				sponsorLabel.alignCenter = true;
				sponsorLabel.textWidth = 65;
				sponsorLabel.appendMultiLinedText("MORE GAMES");
				
				sponsorLabel.x = 35;
				sponsorLabel.y = 0;
			}
			
			container.addChild(sponsorLabel);
			
			var screen:NSSprite = new NSSprite();
			screen.mouseEnabled = true;
			screen.buttonMode = true;
			screen.graphics.beginFill(0, 0.01);
			screen.graphics.drawRect(0, 0, container.width, container.height);
			
			container.addChild(screen);
			
			sponsorLogosHash[id] = container;
			container.addEventListener(MouseEvent.CLICK, sponsorLogo_clickedHanlder);
			
			return container;
		}
		
		private static function createLogoPlaceHolder():Shape
		{
			var sprite:Shape = new Shape();
			
			sprite.graphics.lineStyle(2, 0xF9EC91);
			sprite.graphics.beginFill(0xF9EC91, 0.2);
			
			sprite.graphics.drawRoundRect(0, 0, 32, 32, 10, 10);
			
			return sprite;
		}
		
		public static function createSponsorLogoForLevelInfoPage():NSSprite
		{
			return createLogoWithText("levelInfoPage", true, 18);
		}
		
		public static function createSponsorLogoForMapPage():NSSprite
		{
			return createLogoWithText("mapPage", true, 16);
		}
		
		public static function createSponsorLogoForEncyclopediaStartPage():NSSprite
		{
			return createLogoWithText("encyclopediaStartPage");
		}
		
		public static function createSponsorLogoForEncyclopediaTipsPage():NSSprite
		{
			return createLogoWithText("encyclopediaTipsPage");
		}
		
		public static function createSponsorLogoForEncyclopediaStoryPage():NSSprite
		{
			return createLogoWithText("encyclopediaStoryPage");
		}
		
		private static function sponsorLogo_clickedHanlder(event:MouseEvent):void
		{
			navigateToSponsor();
		}
		
		// temp container
		private static var notificationContainer:MultiPerposedNotificationContainer;
		
		public static function navigateToSponsor():void
		{
			if (!notificationContainer)
				notificationContainer = new MultiPerposedNotificationContainer();
			
			notificationContainer.showCustomNotification("  To Sponsor's Site!", new FontDescriptor(25, 0xF9EC91, FontResources.KOMTXTB));
			
			PopUpUtil.addPopUp(notificationContainer, true, true, 0.7);
		
			//navigateToURL(new URLRequest("www.google.com"), "_blank");
		}
	
	}

}