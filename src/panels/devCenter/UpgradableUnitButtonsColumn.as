/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.devCenter
{
	import flash.display.Bitmap;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UpgradableUnitButtonsColumn extends NSSprite
	{
		////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/transparent bar.png")]
		private static var transparentBarImage:Class;
		
		////////////
		
		public var columnName:String = null;
		
		/////
		
		private var nameContainer:NSSprite = new NSSprite();
		
		private var nameLabel:CustomTextField = new CustomTextField("Weapon");
		
		private var buttonLevel0:UpgradableUnitButton = new UpgradableUnitButton();
		
		private var buttonLevel1:UpgradableUnitButton = new UpgradableUnitButton();
		
		private var buttonLevel2:UpgradableUnitButton = new UpgradableUnitButton();
		
		////////////
		
		public function UpgradableUnitButtonsColumn(columnName:String):void
		{
			this.columnName = columnName;
			constructColumn();
		}
		
		////////////
		
		private var _upgradeLevel:int = int.MIN_VALUE;
		
		private var upgradeLevelChanged:Boolean = false;
		
		public function get upgradeLevel():int
		{
			return _upgradeLevel;
		}
		
		public function set upgradeLevel(value:int):void
		{
			if (_upgradeLevel != value)
			{
				_upgradeLevel = value;
				upgradeLevelChanged = true;
			}
		}
		
		//////
		
		private var _starsAvailable:int = 0;
		
		private var starsAvailableChanged:Boolean = false;
		
		public function get starsAvailable():int
		{
			return _starsAvailable;
		}
		
		public function set starsAvailable(value:int):void
		{
			if (_starsAvailable != value)
			{
				_starsAvailable = value;
				starsAvailableChanged = true;
			}
		}
		
		////////////
		
		private function constructColumn():void
		{
			var bar:Bitmap = new transparentBarImage() as Bitmap;
			bar.width = 100;
			bar.height = 360;
			addChild(bar);
			
			nameLabel.fontDescriptor = new FontDescriptor(20, 0xFFFFFF, FontResources.JUNEGULL);
			nameLabel.textWidth = 90;
			nameLabel.alignCenter = true;
			nameLabel.text = columnName;
			//nameLabel.graphics.lineStyle(2, 0x00ff00);
			//nameContainer.graphics.drawRect(0, 0, nameLabel.width, nameLabel.height);
			
			nameContainer.graphics.lineStyle(2, 0xFFFFFF);
			nameContainer.graphics.beginFill(0, 0.7);
			nameContainer.graphics.drawRoundRect(0, 0, 90, 40, 10, 10);
			
			nameLabel.x = 0;
			nameLabel.y = (nameLabel.numLines == 1) ? 8 : 0;
			//nameContainer.width = 90;
			//nameContainer.height = 40;
			nameContainer.addChild(nameLabel);
			
			nameContainer.x = 5;
			nameContainer.y = 310;
			
			addChild(nameContainer);
			
			buttonLevel2.x = 50;
			buttonLevel2.y = 45;
			
			buttonLevel1.x = 50;
			buttonLevel1.y = 145;
			
			buttonLevel0.x = 50;
			buttonLevel0.y = 245;
			
			addChild(buttonLevel0);
			addChild(buttonLevel1);
			addChild(buttonLevel2);
		}
		
		public function buildColumnForWeaponID(weaponId:String):void
		{
			buttonLevel0.buildButtonForWeaponInfo(WeaponResources.getWeaponInfoByIDAndLevel(weaponId, 0));
			buttonLevel1.buildButtonForWeaponInfo(WeaponResources.getWeaponInfoByIDAndLevel(weaponId, 1));
			buttonLevel2.buildButtonForWeaponInfo(WeaponResources.getWeaponInfoByIDAndLevel(weaponId, 2));
		}
		
		//////////
		
		// refreshes the column after applying updates
		public function refresh():void
		{
			// need to apply updates only when something has changed
			if (!starsAvailableChanged && !upgradeLevelChanged)
				return;
			
			starsAvailableChanged = false;
			upgradeLevelChanged = false;
			
			switch (upgradeLevel)
			{
				case-1: 
					buttonLevel0.currentState = (starsAvailable >= buttonLevel0.currentPrice) ? UpgradableUnitButton.STATE_ENABLED_FOR_UPGRADE : UpgradableUnitButton.STATE_UNLOCKED;
					buttonLevel1.currentState = UpgradableUnitButton.STATE_LOCKED;
					buttonLevel2.currentState = UpgradableUnitButton.STATE_LOCKED;
					break;
				case 0: 
					buttonLevel0.currentState = UpgradableUnitButton.STATE_UPGRADED;
					buttonLevel1.currentState = (starsAvailable >= buttonLevel1.currentPrice) ? UpgradableUnitButton.STATE_ENABLED_FOR_UPGRADE : UpgradableUnitButton.STATE_UNLOCKED;
					buttonLevel2.currentState = UpgradableUnitButton.STATE_LOCKED;
					break;
				case 1: 
					buttonLevel0.currentState = UpgradableUnitButton.STATE_UPGRADED;
					buttonLevel1.currentState = UpgradableUnitButton.STATE_UPGRADED;
					buttonLevel2.currentState = (starsAvailable >= buttonLevel2.currentPrice) ? UpgradableUnitButton.STATE_ENABLED_FOR_UPGRADE : UpgradableUnitButton.STATE_UNLOCKED;
					break;
				case 2: 
					buttonLevel0.currentState = UpgradableUnitButton.STATE_UPGRADED;
					buttonLevel1.currentState = UpgradableUnitButton.STATE_UPGRADED;
					buttonLevel2.currentState = UpgradableUnitButton.STATE_UPGRADED;
					break;
			}
		}
	
	}

}