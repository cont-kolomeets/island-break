/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls 
{
	import flash.display.DisplayObjectContainer;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import nslib.animation.engines.AnimationEngine;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BonusTextGenerator 
	{
		public static function addTextAt(bonus:int, x:Number, y:Number, parent:DisplayObjectContainer, amplitude:Number = 40, duration:Number = 500):void
		{
			var textField:TextField = new TextField();
			
			var simpleFormat:TextFormat = new TextFormat();
			simpleFormat.font = "Comic Sans MS";
			simpleFormat.size = 18;
			simpleFormat.color = 0xE0D00C;
			
			textField.defaultTextFormat = simpleFormat;
			textField.filters = [new DropShadowFilter(2), new GlowFilter(0xFFFA2F, 1, 3, 3)];
			textField.x = x;
			textField.y = y;
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.text = "+" + String(bonus);
			
			parent.addChild(textField);
			
			AnimationEngine.globalAnimator.moveObjects(textField, textField.x, textField.y, textField.x, textField.y - amplitude, duration, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.removeFromParent(textField, parent, AnimationEngine.globalAnimator.currentTime + duration);
		}
		
	}

}