/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import panels.PanelBase;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PauseScreen extends PanelBase
	{
		[Embed(source="F:/Island Defence/media/images/panels/pause screen/base.png")]
		private static var baseImage:Class;
		
		//////////
		
		private var baseContainer:NSSprite = new NSSprite();
		
		private var labelField:CustomTextField = new CustomTextField("Autopause option can be disabled in the settings menu", new FontDescriptor(20, 0xFFFFFF, FontResources.KOMTXTB));
		
		//////////
		
		public function PauseScreen()
		{
			super();
			constructPanel();
		}
		
		//////////
		
		private function constructPanel():void
		{
			blockScreenFillAlpha = 0.7;
			enableBlockScreen = true;
			
			var base:Bitmap = new baseImage() as Bitmap;
			base.x = -base.width / 2;
			base.y = -base.height / 2;
			baseContainer.addChild(base);
			
			baseContainer.x = GamePlayConstants.STAGE_WIDTH / 2;
			baseContainer.y = GamePlayConstants.STAGE_HEIGHT / 2;
			
			labelField.x = (GamePlayConstants.STAGE_WIDTH - labelField.width) / 2;
			labelField.y = GamePlayConstants.STAGE_HEIGHT / 2 + 50;
			
			addChild(baseContainer);
			addChild(labelField);
		}
		
		public function showAutopauseNotification(value:Boolean):void
		{
			labelField.visible = value;
		}
	}

}