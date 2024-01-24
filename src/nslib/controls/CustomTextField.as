/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.geom.Point;
	import flash.text.engine.TextLine;
	import flash.text.TextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * CustomTextField allows to add text with different fonts.
	 * Please note that any text should be assinged only after configuring all layout.
	 */
	public class CustomTextField extends NSSprite
	{
		// Font descriptor. If none specified the default one is created.
		public var fontDescriptor:FontDescriptor = null;
		
		// it will be used only to split lines for wrapped text
		private var textField:TextField = new TextField();
		
		// used to add mouse sencitivity
		private var screen:NSSprite = null;
		
		// allows to append new text to right position
		private var caretPosition:Point = new Point(0, 0);
		
		// height of the last built line
		private var lastLineHeight:Number = 0;
		
		//////////////////
		
		public function CustomTextField(text:String = null, fontDescriptor:FontDescriptor = null)
		{
			this.fontDescriptor = fontDescriptor ? fontDescriptor : new FontDescriptor();
			
			textField.wordWrap = true;
			
			if (text)
				this.text = text;
		}
		
		//////////////////
		
		private var _clickable:Boolean = false;
		
		public function get clickable():Boolean
		{
			return _clickable;
		}
		
		public function set clickable(value:Boolean):void
		{
			_clickable = value;
			
			mouseEnabled = value;
			
			if (value)
				updateScreen();
			else if (screen && contains(screen))
				removeChild(screen);
		}
		
		///////////////
		
		private var _paddingLeft:Number = 0;
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
		}
		
		//////////////////
		
		private var _paddingRight:Number = 0;
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}
		
		//////////////////
		
		private var _paddingTop:Number = 0;
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
		}
		
		//////////////////
		
		private var _paddingBottom:Number = 0;
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
		}
		
		/////////////////////
		
		override public function get width():Number
		{
			return super.width + paddingLeft + paddingRight;
		}
		
		////////////////////
		
		override public function get height():Number
		{
			return super.height + paddingTop + paddingBottom;
		}
		
		/////////////////////
		
		// aligns at the center only if prefferredWidth is set
		private var _alignCenter:Boolean = false;
		
		public function get alignCenter():Boolean
		{
			return _alignCenter;
		}
		
		public function set alignCenter(value:Boolean):void
		{
			_alignCenter = value;
		}
		
		/////////////////////
		
		// gap between lines
		private var _verticalGap:Number = 2;
		
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		
		public function set verticalGap(value:Number):void
		{
			_verticalGap = value;
		}
		
		///////////////////
		
		private var _textWidth:Number = NaN;
		
		public function get textWidth():Number
		{
			return _textWidth;
		}
		
		public function set textWidth(value:Number):void
		{
			_textWidth = value;
		}
		
		/////////////
		
		private var _numLines:int = 0;
		
		public function get numLines():int
		{
			return _numLines;
		}
		
		/////////////
		
		public function get currentCaretPosition():Point
		{
			return caretPosition;
		}
		
		//////////////////
		
		private var _text:String = null;
		
		public function get text():String
		{
			return _text;
		}
		
		// assing this value to set a text with the default font formatting
		// and the configured layout.
		public function set text(value:String):void
		{
			_text = value;
			
			buildLinesForInitialText();
		}
		
		// builds several lines of text with layout
		// and formatting
		private function buildLinesForInitialText():void
		{
			// clear everything
			removeAllChildren();
			_numLines = 0;
			
			// reseting the caret position
			caretPosition = new Point(paddingLeft, paddingTop);
			
			if (!text)
				return;
			
			if (!isNaN(textWidth))
				buildMultyLinedText(text, fontDescriptor);
			else
				buildSingleLinedText();
			// if textWidth is not specified we need to build a single lined text
			
			// updating the screen if necessary
			updateScreen();
		}
		
		private function buildSingleLinedText():void
		{
			var tl:TextLine = FontResources.generateTextLine(text, fontDescriptor);
			tl.y = caretPosition.y;
			tl.x = caretPosition.x;
			
			addChild(tl);
			
			_numLines++;
			
			// updating the caret position
			caretPosition.y += tl.height + verticalGap;
		}
		
		private function buildMultyLinedText(text:String, fontDescriptor:FontDescriptor, additionalPaddingLeft:int = 0):void
		{
			textField.defaultTextFormat = fontDescriptor.toTextFormat();
			textField.width = textWidth;
			textField.text = text;
			
			var numLines:int = textField.numLines;
			_numLines += numLines;
			
			for (var i:int = 0; i < numLines; i++)
			{
				var line:String = textField.getLineText(i);
				var tl:TextLine = FontResources.generateTextLine(line, fontDescriptor);
				
				if (!tl)
					continue;
				
				addChild(tl);
				
				// considering the layout formatting
				if (alignCenter)
					// getting non-overriden width, since the overriden one
					// includes also paddings
					tl.x = (textWidth - tl.width) / 2;
				else
					tl.x = paddingLeft + additionalPaddingLeft;
				
				tl.y = caretPosition.y;
				
				// updating the caret position
				caretPosition.y += tl.height + verticalGap;
				lastLineHeight = tl.height;
			}
		}
		
		///////////////////////
		// Working with Text
		///////////////////////
		
		// moves the current caret to the next line
		// by the height of the last last build
		// do not use this when alignCenter is true
		public function caretToNextLine(offset:Number = NaN):void
		{
			// updating the overall text
			_text += "\n";
			_numLines++;
			
			caretPosition.x = paddingLeft;
			caretPosition.y += lastLineHeight + verticalGap;
			
			if (!isNaN(offset))
				caretPosition.y += offset;
		}
		
		// moves the caret forward by the specified position
		public function caretForward(distance:Number):void
		{
			caretPosition.x += distance;
		}
		
		// alignCenter doesn't work for this
		public function appendText(text:String, fontDescriptor:FontDescriptor = null, baseLineOffset:Number = 0):void
		{
			fontDescriptor = fontDescriptor ? fontDescriptor : this.fontDescriptor;
			
			var tl:TextLine = FontResources.generateTextLine(text, fontDescriptor);
			
			// check for the space left
			// if there is not enough space, then move to the next line
			if (!isNaN(textWidth))
				if ((textWidth - (caretPosition.x - paddingLeft)) < tl.width)
					caretToNextLine();
			
			tl.x = caretPosition.x;
			tl.y = caretPosition.y + baseLineOffset;
			addChild(tl);
			
			// updating the caret position
			caretPosition.x += tl.width;
			lastLineHeight = tl.height + baseLineOffset;
			
			// updating the overall text
			_text += text;
			
			// updating the screen if necessary
			updateScreen();
		}
		
		// adds texts starting from a new line. Splits if necessary
		public function appendMultiLinedText(text:String, fontDescriptor:FontDescriptor = null, additionalPaddingLeft:int = 0):void
		{
			fontDescriptor = fontDescriptor ? fontDescriptor : this.fontDescriptor;
			
			buildMultyLinedText(text, fontDescriptor, additionalPaddingLeft);
			
			// updating the overall text
			_text += text;
			
			// updating the screen if necessary
			updateScreen();
		}
		
		///////////////////
		
		// updates the size of the screen
		// also adds screen to the top position
		private function updateScreen():void
		{
			if (!_clickable)
				return;
			
			if (!screen)
				screen = new NSSprite();
			
			if (!contains(screen))
				addChildAt(screen, 0);
			
			screen.graphics.clear();
			screen.graphics.beginFill(0, 0.01);
			screen.graphics.drawRect(0, 0, width + paddingLeft + paddingRight, height + paddingTop + paddingBottom);
		}
	}

}