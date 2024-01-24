/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.grid
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GridCellInfo extends Sprite
	{
		private var text:TextField = new TextField();
		
		public function GridCellInfo(location:Location, mouseSensitive:Boolean = true, cellSize:Number = 40)
		{
			if (mouseSensitive)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
				addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			}
			
			var format:TextFormat = new TextFormat();
			format.size = 8;
			
			text.defaultTextFormat = format;
			text.text = "G = " + location.G + "\nH = " + location.H + "\nF = " + location.F;
			text.width = cellSize;
			text.x = -cellSize / 2;
			text.y = - cellSize / 2;
			text.selectable = false;
			text.textColor = 0x333333;
			addChild(text);
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			text.visible = true;
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			text.visible = false;
		}
	}

}