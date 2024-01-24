/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import constants.GamePlayConstants;
	import events.ClearSlotEvent;
	import flash.display.Bitmap;
	import infoObjects.gameInfo.GameInfo;
	import nslib.controls.Button;
	import nslib.controls.CustomTextField;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.LayoutContainer;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.LayoutConstants;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.LevelsInfoResources;
	import supportControls.toolTips.HintToolTip;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SlotsPanelSlot extends NSSprite
	{
		[Embed(source="F:/Island Defence/media/images/panels/slots panel/slot empty.png")]
		private static var slotEmptyImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/slots panel/slot filled.png")]
		private static var slotFilledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/slots panel/slot over.png")]
		private static var slotOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/slots panel/slot down.png")]
		private static var slotDownImage:Class;
		
		/////////
		
		[Embed(source="F:/Island Defence/media/images/panels/slots panel/clear button normal.png")]
		private static var clearButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/slots panel/clear button over.png")]
		private static var clearButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/slots panel/clear button down.png")]
		private static var clearButtonDownImage:Class;
		
		/////////
		
		public var slotIndex:int = 0;
		
		private var slotButton:Button = new Button();
		
		private var clearButton:Button = new Button();
		
		/////////
		
		public function SlotsPanelSlot()
		{
		}
		
		/////////
		
		public function updateForGameInfo(info:GameInfo):void
		{
			removeAllChildren();
			buttonMode = true;
			
			// adding main button
			ControlConfigurator.configureButton(slotButton, (info ? slotFilledImage : slotEmptyImage), slotOverImage, slotDownImage);
			slotButton.considerOnlyBoundsForMouseEvents = true;
			addChild(slotButton);
			
			clearButton.mouseEnabled = Boolean(info != null);
			clearButton.alpha = (info == null) ? 0.5 : 1;
			
			// adding 'empty' label
			if (info == null)
			{
				var emptyLabel:CustomTextField = new CustomTextField("Empty", new FontDescriptor(20, 0xAAAAAA, FontResources.YARDSALE));
				emptyLabel.x = (width - emptyLabel.width) / 2;
				emptyLabel.y = (height - emptyLabel.height) / 2;
				addChild(emptyLabel);
			}
			else
			{
				// adding clear button
				ControlConfigurator.configureButton(clearButton, clearButtonNormalImage, clearButtonOverImage, clearButtonDownImage);
				clearButton.x = width - 40;
				clearButton.y = 15;
				ToolTipService.setToolTip(clearButton, new ToolTipInfo(clearButton, new ToolTipSimpleContentDescriptor(null, ["CLEAR THIS SLOT"])), HintToolTip);
				
				clearButton.addEventListener(ButtonEvent.BUTTON_CLICK, clearButton_clickHandler, false, 0, true);
				
				addChild(clearButton);
				
				/////////////
				
				var container:LayoutContainer = new LayoutContainer();
				addChild(container);
				container.width = width;
				container.height = height;
				container.layout = LayoutConstants.VERTICAL;
				container.verticalGap = 5;
				
				// adding date label
				var dateLabel:CustomTextField = new CustomTextField(info.dateFormatted, new FontDescriptor(15, 0xFFFFFF, FontResources.YARDSALE));
				
				// adding reached level number label
				var levelLabel:CustomTextField = new CustomTextField("Level " + Math.min(GamePlayConstants.NUMBER_OF_LEVELS, info.numLevelsPassed + 1), new FontDescriptor(20, 0xFFFFFF, FontResources.YARDSALE));
				
				var thumb:Bitmap = LevelsInfoResources.getLevelImageBitmapByIndex(Math.min(GamePlayConstants.NUMBER_OF_LEVELS - 1, info.numLevelsPassed));
				
				container.addChild(dateLabel);
				container.addChild(levelLabel);
				
				if (thumb)
					container.addChild(thumb);
			}
		}
		
		public function deactivate():void
		{
			clearButton.removeEventListener(ButtonEvent.BUTTON_CLICK, clearButton_clickHandler, false);
			ToolTipService.removeAllTooltipsForComponent(clearButton);
		}
		
		private function clearButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new ClearSlotEvent(ClearSlotEvent.CLEAR_SLOT, slotIndex));
		}
	}

}