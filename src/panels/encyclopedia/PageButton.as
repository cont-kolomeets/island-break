/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import flash.filters.DropShadowFilter;
	import nslib.controls.Button;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PageButton extends NSSprite
	{
		public static const TYPE_STORY:String = "story";
		
		public static const TYPE_USER_WEAPONS:String = "userWeapon";
		
		public static const TYPE_ENEMY_WEAPONS:String = "enemyWeapon";
		
		public static const TYPE_TIPS:String = "tips";
		/////////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/book normal.png")]
		private static var bookNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/book over.png")]
		private static var bookOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/book down.png")]
		private static var bookDownImage:Class;
		
		///////
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/tip normal.png")]
		private static var tipNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/tip over.png")]
		private static var tipOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/tip down.png")]
		private static var tipDownImage:Class;
		
		///////
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/user normal.png")]
		private static var userNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/user over.png")]
		private static var userOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/user down.png")]
		private static var userDownImage:Class;
		
		///////
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/enemy normal.png")]
		private static var enemyNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/enemy over.png")]
		private static var enemyOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/start panel/enemy down.png")]
		private static var enemyDownImage:Class;
		
		///////
		
		/////////////////////
		
		public var type:String = null;
		
		private var button:Button = new Button();
		
		private var labelField:CustomTextField = new CustomTextField(null, new FontDescriptor(36, 0xFFFFFF, FontResources.YARDSALE));
		
		/////////////////////
		
		public function PageButton(type:String)
		{
			this.type = type;
			constructButton();
		}
		
		////////////////////
		
		private function constructButton():void
		{
			switch (type)
			{
				case TYPE_STORY: 
					ControlConfigurator.configureButton(button, bookNormalImage, bookOverImage, bookDownImage);
					labelField.text = "Story";
					break;
				
				case TYPE_TIPS: 
					ControlConfigurator.configureButton(button, tipNormalImage, tipOverImage, tipDownImage);
					labelField.text = "Tips";
					break;
				
				case TYPE_USER_WEAPONS:
					ControlConfigurator.configureButton(button, userNormalImage, userOverImage, userDownImage);
					labelField.text = "User";
					break;
				
				case TYPE_ENEMY_WEAPONS: 
					ControlConfigurator.configureButton(button, enemyNormalImage, enemyOverImage, enemyDownImage);
					labelField.text = "Enemy";
					break;
			}
		
			button.refresh(true);
			button.considerOnlyBoundsForMouseEvents = true;
			addChild(button);
			
			labelField.x = (button.width - labelField.width) / 2;
			labelField.y = 150;
			
			labelField.filters = [new DropShadowFilter(0, 0, 0, 0.8, 10, 10, 1.5)];
			
			addChild(labelField);
		}
	
	}

}