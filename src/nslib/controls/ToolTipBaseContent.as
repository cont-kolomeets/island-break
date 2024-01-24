/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ToolTipBaseContent extends BorderContainer implements IToolTipContent
	{
		protected var header:TextField = new TextField();
		
		protected var body:TextField = new TextField();
		
		//////////////
		
		public function ToolTipBaseContent()
		{
			configureStyling();
		}
		
		//////////////
		
		public function set headerText(value:String):void
		{
			if (value)
			{
				header.text = value;
				
				if (!contains(header))
					addChildAt(header, 0);
			}
			else
			{
				if (contains(header))
					removeChild(header);
			}
			
			invalidateLayout();
		}
		
		///////////////
		
		public function set bodyText(value:String):void
		{
			if (value)
			{
				body.text = value;
				body.height = body.textHeight + 10;
				
				if (!contains(body))
					addChild(body);
			}
			else
			{
				if (contains(body))
					removeChild(body);
			}
			
			invalidateLayout();
		}
		
		////////////////
		
		private var _contentDescriptor:ToolTipSimpleContentDescriptor = null;
		
		public function get contentDescriptor():Object
		{
			return _contentDescriptor;
		}
		
		public function set contentDescriptor(value:Object):void
		{
			if (!(value is ToolTipSimpleContentDescriptor))
				return;
			
			_contentDescriptor = value as ToolTipSimpleContentDescriptor;
			
			headerText = _contentDescriptor.headerText;
			
			var bt:String = "";
			
			if (value.bodyTextsArray)
			{
				var len:int = value.bodyTextsArray.length;
				
				for (var i:int = 0; i < len; i++)
					bt += value.bodyTextsArray[i] + ((i < (len - 1)) ? "\n" : "");
				
				bodyText = bt;
			}
			
			refresh();
		}
		
		/////////////////
		
		private var maxWidth:Number = 120;
		
		private function configureStyling():void
		{
			layout = "vertical";
			
			var simpleFormat:TextFormat = new TextFormat();
			simpleFormat.font = "Comic Sans MS";
			simpleFormat.size = 12;
			
			header.autoSize = TextFieldAutoSize.CENTER;
			header.selectable = false;
			header.textColor = 0x222222;
			header.border = false;
			header.defaultTextFormat = simpleFormat;
			
			body.width = maxWidth;
			body.defaultTextFormat = simpleFormat;
			body.wordWrap = true;
			body.selectable = false;
			body.textColor = 0x222222;
			body.border = false;
		}
	
	}

}