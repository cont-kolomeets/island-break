/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.achievementsCenter 
{
	import nslib.controls.Button;
	import nslib.controls.ButtonBar;
	import nslib.controls.NSSprite;
	import supportClasses.ControlConfigurator;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AchievementsCenterToolBar extends NSSprite 
	{
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/common images/buttons/button back normal.png")]
		private static var backButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/buttons/button back over.png")]
		private static var backButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/buttons/button back down.png")]
		private static var backButtonDownImage:Class;
		
		//////////////
				
		public var backButton:Button = new Button();
		
		public var pageButtonBar:ButtonBar = new ButtonBar();
		
		//////////////
		
		public function AchievementsCenterToolBar() 
		{
			construct();
		}
		
		///////////////
		
		private function construct():void
		{
			pageButtonBar.buttonClass = PageButton;
			pageButtonBar.dataProvider = [{label:"1"}, {label:"2"}, {label:"3"}];
			pageButtonBar.x = 80;
			pageButtonBar.y = 5;
			
			addChild(pageButtonBar);
			
			// adding button
			ControlConfigurator.configureButton(backButton, backButtonNormalImage, backButtonOverImage, backButtonDownImage);
			backButton.x = 520;
			addChild(backButton);
		}
		
	}

}