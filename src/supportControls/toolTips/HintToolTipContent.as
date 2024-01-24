/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.toolTips
{
	import nslib.controls.CustomTextField;
	import nslib.controls.IToolTipContent;
	import nslib.controls.LayoutContainer;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class HintToolTipContent extends LayoutContainer implements IToolTipContent
	{
		public var header:CustomTextField = new CustomTextField();
		
		public var body:CustomTextField = new CustomTextField();
		
		//////////////
		
		public function HintToolTipContent()
		{
			configureLayout();
			configureStyling();
		}
		
		//////////////
		
		public function set headerTextFontDescriptor(value:FontDescriptor):void
		{
			header.fontDescriptor = value;
		}
		
		public function set bodyTextFontDescriptor(value:FontDescriptor):void
		{
			body.fontDescriptor = value;
		}
		
		//////////////
		
		public function set headerText(value:String):void
		{
			if (value)
			{
				if (contentDescriptor is ToolTipSimpleContentDescriptor && ToolTipSimpleContentDescriptor(contentDescriptor).headerFontDescriptor)
					header.fontDescriptor = ToolTipSimpleContentDescriptor(contentDescriptor).headerFontDescriptor;
				
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
				if (contentDescriptor is ToolTipSimpleContentDescriptor && ToolTipSimpleContentDescriptor(contentDescriptor).bodyFontDescriptor)
					body.fontDescriptor = ToolTipSimpleContentDescriptor(contentDescriptor).bodyFontDescriptor;
				
				body.text = value;
				
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
			
			// after the layout is set
			// it is reasonable to check whether the width of the header
			// exeeds that of the body. If so make the widht of the body
			// slightly bigger.
			//if (header.textWidth > body.textWidth)
			//	body.textWidth = header.textWidth + 40;
			
			var bt:String = "";
			
			if (value.bodyTextsArray)
			{
				var len:int = value.bodyTextsArray.length;
				
				for (var i:int = 0; i < len; i++)
					bt += value.bodyTextsArray[i] + ((i < (len - 1)) ? "\n" : "");
				
				bodyText = bt;
			}
			
			// in case content changed its layout need to refresh this container
			refresh(false, true);
		}
		
		//////////////////////////
		
		private function configureLayout():void
		{
			layout = "vertical";
			horizontalAlignment = "left";
			paddingTop = 5;
			paddingLeft = 5;
			paddingRight = 5;
			paddingBottom = 5;
		}
		
		/// styling
		
		private var maxWidth:Number = 140;
		
		private function configureStyling():void
		{
			header.fontDescriptor = new FontDescriptor(12, 0, FontResources.YARDSALE);
			header.textWidth = maxWidth;
			
			body.fontDescriptor = new FontDescriptor(14, 0, FontResources.KOMTXTB);
			body.verticalGap = 2;
			body.paddingBottom = 5;
			body.textWidth = maxWidth;
		}
	}

}