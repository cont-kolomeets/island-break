/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.common
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PaperWithTextBase extends NSSprite
	{
		public var paperWidth:Number = NaN;
		
		public var paperHeight:Number = NaN;
		
		public var textOffsetX:Number = 0;
		
		public var textOffsetY:Number = 0;
		
		public var textPaddingLeft:Number = 35;
		
		public var textPaddingRight:Number = 35;
		
		public var shadowThickness:Number = 1.5;
		
		public var fontDescriptor:FontDescriptor = null;
		
		// Positions itself in the middle of the parent
		public var autoCenter:Boolean = true;
		
		///////
		
		private var titlePaper:Bitmap = null;
		
		private var label:CustomTextField = new CustomTextField();
		
		////////
		
		public function PaperWithTextBase(title:String = null, fontSize:int = -1)
		{
			if (title)
				setTitleText(title, fontSize);
		}
		
		///////
		
		private var _imageClass:Class = null;
		
		public function set imageClass(value:Class):void
		{
			_imageClass = value;
			
			construct();
		}
		
		///////
		
		private function construct():void
		{
			removeAllChildren();
			titlePaper = new _imageClass() as Bitmap;
			titlePaper.smoothing = true;
			addChild(titlePaper);
			addChild(label);
			
			tryResizeImage();
		}
		
		// Sets new text for the title.
		public function setTitleText(text:String, fontSize:int = -1, showShadow:Boolean = true):void
		{
			label.text = null;
			label.appendText(text, fontDescriptor ? fontDescriptor : new FontDescriptor(((fontSize == -1) ? 25 : fontSize), 0xFFFFFF, FontResources.YARDSALE));
			
			label.filters = showShadow ? [new DropShadowFilter(0, 0, 0, 0.8, 10, 10, shadowThickness)] : [];
			
			tryResizeImage();
		}
		
		private function tryResizeImage():void
		{
			// parent needs only for centering against it
			if (autoCenter && !parent)
			{
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
				return;
			}
			
			if (titlePaper)
				resizeTitlePaper();
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			tryResizeImage();
		}
		
		private function resizeTitlePaper():void
		{
			titlePaper.width = !isNaN(paperWidth) ? paperWidth : Math.max(100, label.width + textPaddingLeft + textPaddingRight);
			titlePaper.height = !isNaN(paperHeight) ? paperHeight : label.height * 2;
			
			if (autoCenter)
			{
				titlePaper.x = (parent.width - titlePaper.width) / 2;
				titlePaper.y = 0;
			}
			
			label.x = titlePaper.x + (titlePaper.width - label.width) / 2 + textOffsetX;
			label.y = titlePaper.y + (titlePaper.height - label.height) / 2 + textOffsetY;
		}
	}

}