/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.devCenter
{
	import flash.display.Bitmap;
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
	public class DevCenterToolBar extends NSSprite
	{
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button cancel normal.png")]
		private static var cancelButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button cancel over.png")]
		private static var cancelButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button cancel down.png")]
		private static var cancelButtonDownImage:Class;
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button undo normal.png")]
		private static var undoButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button undo over.png")]
		private static var undoButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button undo down.png")]
		private static var undoButtonDownImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button undo disabled.png")]
		private static var undoButtonDisabledImage:Class;
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button done normal.png")]
		private static var doneButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button done over.png")]
		private static var doneButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/buttons/button done down.png")]
		private static var doneButtonDownImage:Class;
		
		////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/star.png")]
		private static var starImage:Class;
		
		////////////////
		
		public var buttonCancel:Button = new Button();
		
		public var buttonUndo:Button = new Button();
		
		public var buttonDone:Button = new Button();
		
		private var starLabel:CustomTextField = new CustomTextField();
		
		///////
		
		private var gap:Number = 20;
		
		////////////////
		
		public function DevCenterToolBar()
		{
			constructToolBar();
		}
		
		////////////////
		
		public function set starsAvailable(value:int):void
		{
			starLabel.text = "" + value;
		}
		
		////////////////
		
		private function constructToolBar():void
		{
			var star:Bitmap = new starImage() as Bitmap;
			addChild(star);
			
			starLabel.fontDescriptor = new FontDescriptor(40, 0xFFFFFF, FontResources.JUNEGULL);
			starLabel.x = star.width + 20;
			starLabel.y = 15;
			addChild(starLabel);
			
			ControlConfigurator.configureButton(buttonCancel, cancelButtonNormalImage, cancelButtonOverImage, cancelButtonDownImage);
			ControlConfigurator.configureButton(buttonUndo, undoButtonNormalImage, undoButtonOverImage, undoButtonDownImage, undoButtonDisabledImage);
			ControlConfigurator.configureButton(buttonDone, doneButtonNormalImage, doneButtonOverImage, doneButtonDownImage);
			
			buttonCancel.refresh(true);
			buttonUndo.refresh(true);
			buttonDone.refresh(true);
			
			buttonCancel.x = 190;
			buttonCancel.y = 5;
			buttonUndo.x = buttonCancel.x + buttonCancel.width + gap;
			buttonUndo.y = 5;
			buttonDone.x = buttonUndo.x + buttonUndo.width + gap;
			buttonDone.y = 5;
			
			addChild(buttonCancel);
			addChild(buttonUndo);
			addChild(buttonDone);
		}
	
	}

}