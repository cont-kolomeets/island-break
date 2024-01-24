/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import infoObjects.panelInfos.ConfirmDialogInfo;
	import nslib.controls.Button;
	import nslib.controls.events.ButtonEvent;
	import panels.PanelBase;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ConfirmDialog extends PanelBase 
	{
		public static const OK_CLICK:String = "okClick";
		
		public static const CANCEL_CLICK:String = "cancelClick";
		
		/////////////
		
		private var okButton:Button = new Button("OK");
		
		private var cancelButton:Button = new Button("Cancel");
		
		private var messageTextField:TextField = new TextField();
		
		private var screen:Shape = new Shape();
		
		///////////
		
		public function ConfirmDialog() 
		{
			if (stage)
				constructDialog()
			else 
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		//////////
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			constructDialog();
		}
		
		private function constructDialog():void
		{
			var offsetx:int = stage.stageWidth / 2 - 150;
			var offsety:int = stage.stageHeight / 2 - 75;
			
			graphics.beginFill(0x1E7DA2, 0.7);
			graphics.drawRect(offsetx, offsety, 300, 150);
			
			messageTextField.x = offsetx + 20;
			messageTextField.y = offsety + 50;
			messageTextField.width = 260;
			
			okButton.x = offsetx + 100;
			okButton.y = offsety + 100;
			
			cancelButton.x = offsetx + 200;
			cancelButton.y = offsety + 100;
			
			screen.graphics.clear();
			screen.graphics.beginFill(0x000000, 0.2);
			screen.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			addChild(screen);
			addChild(messageTextField);
			addChild(okButton);
			addChild(cancelButton);
		}
		
		override public function applyPanelInfo(panelInfo:*):void 
		{
			super.applyPanelInfo(panelInfo);
			
			messageTextField.text = ConfirmDialogInfo(panelInfo).message;
			screen.visible = ConfirmDialogInfo(panelInfo).modal;
		}
		
		override public function show():void 
		{
			super.show();
			
			okButton.addEventListener(ButtonEvent.BUTTON_CLICK, okButton_clickHandler);
			cancelButton.addEventListener(ButtonEvent.BUTTON_CLICK, cancelButton_clickHandler);
		}
		
		override public function hide():void 
		{
			super.hide();
			
			okButton.removeEventListener(ButtonEvent.BUTTON_CLICK, okButton_clickHandler);
			cancelButton.removeEventListener(ButtonEvent.BUTTON_CLICK, cancelButton_clickHandler);
		}
		
		//////////////////////
		
		private function okButton_clickHandler(event:Event):void
		{
			dispatchEvent(new Event(OK_CLICK));
		}
		
		private function cancelButton_clickHandler(event:Event):void
		{
			dispatchEvent(new Event(CANCEL_CLICK));
		}
		
	}

}