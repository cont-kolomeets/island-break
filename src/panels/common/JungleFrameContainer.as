/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.common
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class JungleFrameContainer extends NSSprite
	{
		
		//[Embed(source="F:/Island Defence/media/images/common images/background.png")]
		//private static var backgroundImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/big frame.png")]
		private static var frameImage:Class;
		
		///////////////////
		
		private var paperTitle:PaperTitle = new PaperTitle();
		
		private var backgroundImage:Shape = new Shape();
		
		///////////////////
		
		public function JungleFrameContainer(title:String, fontSize:int = -1)
		{
			constructFrame();
			paperTitle.setTitleText(title, fontSize);
		}
		
		//////////////////
		
		private function constructFrame():void
		{
			var matrix:Matrix = new Matrix();
			matrix.rotate(Math.PI / 2);
			matrix.createGradientBox(GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT - 100, Math.PI / 2);
			
			backgroundImage.cacheAsBitmap = true;
			backgroundImage.graphics.beginGradientFill(GradientType.LINEAR, [0x374602, 0x040600], [1, 1], [0, 255], matrix);
			backgroundImage.graphics.drawRect(0, 0, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			
			//addChild(new backgroundImage() as Bitmap);
			addChild(backgroundImage);
			addChild(new frameImage() as Bitmap);
			
			addChild(paperTitle);
		}
		
		public function setTitleText(text:String):void
		{
			paperTitle.setTitleText(text);
		}
	}

}