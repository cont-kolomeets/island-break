/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import nslib.controls.NSSprite;
	import nslib.core.Globals;
	import nslib.core.NSFramework;
	import nslib.designer.Designer;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class DesignerTest extends NSSprite
	{
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/bomb support aim.png")]
		private static var bombAimImage:Class;
		
		private var designer:Designer = new Designer();
		
		public function DesignerTest()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			init();
		}
		
		private function init():void
		{
			NSFramework.initialize(this);

			var aim:Bitmap = new bombAimImage();
			aim.x = 200;
			aim.y = 200;
			
			addChild(aim);
			
			for (var i:int = 0; i < 10; i++)
			{
				var sprite:NSSprite = generateSprite();
				sprite.x = 700 * Math.random();
				sprite.y = 500 * Math.random();
				addChild(sprite);
			}
			
			addChild(designer);
		}
		
		private function generateSprite():NSSprite
		{
			var sprite:NSSprite = new NSSprite();
			sprite.graphics.beginFill(0xFFFFFF * Math.random(), 0.2 + 0.5 * Math.random());
			
			sprite.graphics.drawRect(-50 * Math.random(), -50 * Math.random(), 50 + 50 * Math.random(), 50 + 50 * Math.random());
			
			return sprite;
		}
	
	}

}