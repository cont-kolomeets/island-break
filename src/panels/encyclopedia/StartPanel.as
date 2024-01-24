/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia 
{
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class StartPanel extends NSSprite 
	{
		public var storyButton:PageButton = new PageButton(PageButton.TYPE_STORY);
		
		public var tipsButton:PageButton = new PageButton(PageButton.TYPE_TIPS);
		
		public var userWeaponButton:PageButton = new PageButton(PageButton.TYPE_USER_WEAPONS);
		
		public var enemyWeaponButton:PageButton = new PageButton(PageButton.TYPE_ENEMY_WEAPONS);
		
		/////
		
		private var verticalGap:Number = 10;
		
		private var horizontalGap:Number = 60;
		
		//////////////////
		
		public function StartPanel() 
		{
			construct();
		}
		
		//////////////////
		
		private function construct():void
		{
			storyButton.x = 0;
			storyButton.y = 0;
			
			userWeaponButton.x = storyButton.width + horizontalGap;
			userWeaponButton.y = 0;
			
			enemyWeaponButton.x = 0;
			enemyWeaponButton.y = storyButton.height + verticalGap;
			
			tipsButton.x = storyButton.width + horizontalGap;
			tipsButton.y = storyButton.height + verticalGap;
			
			addChild(storyButton);
			addChild(tipsButton);
			addChild(userWeaponButton);
			addChild(enemyWeaponButton);
		}
		
	}

}