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
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UpgradableUnitButtonStarPlate extends NSSprite
	{
		public static const STATE_DISABLED:String = "disabled";
		
		public static const STATE_ENABLED_FOR_UPGRADE:String = "enabledForUpgrade";
		
		///////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/star plate disabled.png")]
		private static var starPlateDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/star plate enabled.png")]
		private static var starPlateEnabledImage:Class;
		
		//[Embed(source="F:/Island Defence/media/images/panels/dev center/star plate over.png")]
		//private static var starPlateOverImage:Class;
		
		//////////
		
		private var disabledImage:Bitmap = null;
		
		private var enabledImage:Bitmap = null;
		
		private var label:CustomTextField = new CustomTextField();
		
		//////////
		
		public function UpgradableUnitButtonStarPlate()
		{
			refresh();
		}
		
		//////////
		
		public function set numberOfStars(value:int):void
		{
			label.text = "" + value;
		}
		
		/////////
		
		private var _currentState:String = STATE_DISABLED;
		
		public function get currentState():String
		{
			return _currentState;
		}
		
		public function set currentState(value:String):void
		{
			if (_currentState != value)
			{
				_currentState = value;
				refresh();
			}
		}

		
		/////////
		
		// refreshes after the state is changed
		private function refresh():void
		{
			removeAllChildren();
			
			var text:String = label.text;
			
			if (currentState == STATE_DISABLED)
			{
				if (!disabledImage)
					disabledImage = new starPlateDisabledImage() as Bitmap;
				
				addChild(disabledImage);
				
				label.fontDescriptor = new FontDescriptor(20, 0xAAAAAA, FontResources.JUNEGULL);
			}
			else if (currentState == STATE_ENABLED_FOR_UPGRADE)
			{
				if (!enabledImage)
					enabledImage = new starPlateEnabledImage() as Bitmap;
					
				addChild(enabledImage);
				
				label.fontDescriptor = new FontDescriptor(20, 0xFFFFFF, FontResources.JUNEGULL);
			}
			
			label.text = text;
			label.x = 27;
			label.y = 7;
			addChild(label);
		}
	}

}