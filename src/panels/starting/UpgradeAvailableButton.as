/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import flash.display.Bitmap;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UpgradeAvailableButton extends NSSprite
	{
		[Embed(source="F:/Island Defence/media/images/panels/map/upgrade available star.png")]
		private static var starImage:Class;
		
		//////////////
		
		private var numberField:CustomTextField = new CustomTextField(null, new FontDescriptor(20, 0, FontResources.BOMBARD));
		
		//////////////
		
		public function UpgradeAvailableButton()
		{
			construct();
		}
		
		/////////////
		
		public function set numUpgrades(value:int):void
		{
			numberField.text = "" + value;
		}
		
		/////////////
		
		private function construct():void
		{
			buttonMode = true;
			mouseEnabled = true;
			
			var star:Bitmap = new starImage() as Bitmap;
			addChild(star);
		
			//addChild(numberField);
		}
	}

}