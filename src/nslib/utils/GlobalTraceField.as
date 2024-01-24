/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class GlobalTraceField extends NSSprite
	{
		public static const UP:int = 1;
		public static const DOWN:int = -1;
		
		public var traceDirection:int = DOWN;
		public var showLineCount:Boolean = true;
		public var maxAllowedFields:int = 20;
		public var mainApp:NSSprite;
		
		private var interval:Number = 20;
		private var currentPosition:Number = 0;
		private var currentMonitorLabelPosition:Number = 0;
		private var lineCount:int = 0;
		private var fields:ArrayList = new ArrayList();
		private var container:NSSprite = new NSSprite();
		private var monitorContainer:NSSprite = new NSSprite();
		
		public function GlobalTraceField()
		{
			addChild(container);
			addChild(monitorContainer);
			traceText("ready...");
		}
		
		public function traceText(text:String, color:int = 0xB91591):void
		{
			var format:TextFormat = new TextFormat();
			format.color = color;
			
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.defaultTextFormat = format;
			textField.text = (showLineCount ? (lineCount++ + " ") : "") + text;
			textField.y = currentPosition;
			textField.width = 1000;
			
			container.addChild(textField);
			
			container.y -= interval * traceDirection;
			currentPosition += interval * traceDirection;
			
			fields.addItem(textField);
			
			if (fields.length > maxAllowedFields)
			{
				container.removeChild(TextField(fields.getItemAt(0)));
				fields.removeItemAt(0);
			}
		}
		
		private var monitorPropList:ArrayList = new ArrayList();
		
		public function monitorProperty(obj:*, propName:String):void
		{
			var bundle:Object = new Object();
			bundle.obj = obj;
			bundle.name = propName;
			bundle.textField = createMonitorTextField();
			
			monitorPropList.addItem(bundle);
			
			mainApp.addEventListener(Event.ENTER_FRAME, frameListener);
		}
		
		public function createMonitorTextField():TextField
		{
			var format:TextFormat = new TextFormat();
			format.color = 0xFF00FF;
			
			var textField:TextField = new TextField();
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.defaultTextFormat = format;
			textField.y = currentMonitorLabelPosition;
			textField.width = 300;
			
			monitorContainer.addChild(textField);
			
			container.y -= interval * traceDirection;
			monitorContainer.y -= interval * traceDirection;
			currentMonitorLabelPosition += interval * traceDirection;
			
			
			return textField;
		}
		
		private function frameListener(event:Event):void
		{
			for each (var bundle:Object in monitorPropList.source)
			{
				if (Object(bundle.obj).hasOwnProperty(bundle.name))
					bundle.textField.text = bundle.name + ": " + bundle.obj[bundle.name];
			}
		}
	
	}

}