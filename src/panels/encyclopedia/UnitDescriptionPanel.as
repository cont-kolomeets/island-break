/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import infoObjects.WeaponInfo;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import panels.common.PhotoContainer;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UnitDescriptionPanel extends NSSprite
	{
		private var realImagePhotoContainer:PhotoContainer = new PhotoContainer();
		
		private var inGameImagePhotoContainer:PhotoContainer = new PhotoContainer();
		
		private var descriptionLabel:CustomTextField = new CustomTextField(null, new FontDescriptor(15, 0xFFFFFF, FontResources.BOMBARD));
		
		private var unitProperitesContainer:UnitPropertiesContainer = new UnitPropertiesContainer();
		
		////////
		
		public function UnitDescriptionPanel()
		{
			construct();
		}
		
		////////
		
		private function construct():void
		{
			var filter:DropShadowFilter = new DropShadowFilter(0, 0, 0, 1, 12, 12, 1.5);
			
			realImagePhotoContainer.scaleX = 0.8;
			realImagePhotoContainer.scaleY = 0.8;
			realImagePhotoContainer.x = 110;
			realImagePhotoContainer.y = -10;
			realImagePhotoContainer.filters = [filter];
			
			inGameImagePhotoContainer.x = 190;
			inGameImagePhotoContainer.y = 70;
			inGameImagePhotoContainer.filters = [filter];
			
			var labelBackground:Shape = new Shape();
			labelBackground.graphics.lineStyle(2, 0x608D0A);
			labelBackground.graphics.beginFill(0, 0.5);
			labelBackground.x = 0;
			labelBackground.y = 110;
			
			// one rect for description
			labelBackground.graphics.drawRoundRect(0, 0, 222, 92, 10, 10);
			// one rect for properties
			labelBackground.graphics.drawRoundRect(0, 100, 222, 85, 10, 10);
			
			descriptionLabel.x = 10;
			descriptionLabel.y = 117;
			descriptionLabel.textWidth = 220;
			
			unitProperitesContainer.x = 10;
			unitProperitesContainer.y = 210;
			
			addChild(labelBackground);
			addChild(realImagePhotoContainer);
			addChild(inGameImagePhotoContainer);
			addChild(descriptionLabel);
			addChild(unitProperitesContainer);
		}
		
		//////////
		
		public function showDescriptionForWeapon(info:WeaponInfo):void
		{
			realImagePhotoContainer.fillPhotoContainerWithBigImage(info);
			inGameImagePhotoContainer.fillPhotoContainerWithInGameImage(info);
			unitProperitesContainer.showInfoForWeapon(info);
			
			descriptionLabel.text = null;
			
			if (info)
			{
				descriptionLabel.appendText(info.name, new FontDescriptor(17, 0xFAEB85, FontResources.BOMBARD));
				descriptionLabel.caretToNextLine(5);
				descriptionLabel.appendMultiLinedText(info.generalDescription, new FontDescriptor(13, 0xFFFFFF, FontResources.BOMBARD));
			}
		}
	
	}

}