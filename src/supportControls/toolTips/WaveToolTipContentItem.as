/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.toolTips
{
	import flash.display.Bitmap;
	import infoObjects.WeaponInfo;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import nslib.utils.ImageUtil;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WaveToolTipContentItem extends NSSprite
	{
		public var paddingLeft:Number = 5;
		
		public var horizontalGap:Number = 10;
		
		public var preferredWidth:Number = 140;
		
		public var preferredHeight:Number = 40;
		
		private var nameLabelField:CustomTextField = new CustomTextField();
		
		private var numberLabelField:CustomTextField = new CustomTextField();
		
		////////////////
		
		public function WaveToolTipContentItem()
		{
			configure();
		}
		
		/////////////////
		
		private function configure():void
		{
		}
		
		/////////////////
		
		public function constructFromInfo(weaponInfo:WeaponInfo, count:int):void
		{
			nameLabelField.text = null;
			nameLabelField.textWidth = 70;
			nameLabelField.appendMultiLinedText(weaponInfo.name, new FontDescriptor(12, 0xF9EF73, FontResources.BOMBARD));
			
			numberLabelField.text = null;
			numberLabelField.appendText(String(count), new FontDescriptor(13, 0xFFFFFF, FontResources.BOMBARD));
			
			var image:Bitmap = new weaponInfo.iconSmall() as Bitmap;
			image.smoothing = true;
			ImageUtil.scaleToFitHeight(image, 35);
			image.x = paddingLeft;
			image.y = (40 - image.height) / 2;
			
			nameLabelField.x = 60;
			nameLabelField.y = (preferredHeight - nameLabelField.height) / 2;
			
			numberLabelField.x = 60 + nameLabelField.width + 5;
			numberLabelField.y = (preferredHeight - numberLabelField.height) / 2;
			
			addChild(image);
			addChild(nameLabelField);
			addChild(numberLabelField);
			
			graphics.clear();
			graphics.lineStyle(2, 0xFFFFFF, 0.3);
			graphics.beginFill(0xAAAAAA, 0.1);
			graphics.drawRoundRect(0, 0, preferredWidth, preferredHeight, 3, 3);
		}
	
	}

}