/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import controllers.SoundController;
	import events.ClearSlotEvent;
	import events.PanelEvent;
	import events.SelectEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import infoObjects.gameInfo.GameInfo;
	import infoObjects.panelInfos.SlotsPanelInfo;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.BubbleService;
	import nslib.utils.ArrayList;
	import panels.common.PaperTitle;
	import panels.PanelBase;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.SoundResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * Has: a frame with 3 slots to save your game.
	 * Takes as info: object SavedGameInfo.
	 * Blocks the background.
	 */
	public class SlotsPanel extends PanelBase
	{
		public static const CLOSE_CLICKED:String = "closeClicked";
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/slots panel/frame.png")]
		private static var frameImage:Class;
		
		////
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/close button down.png")]
		private static var closeButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/close button over.png")]
		private static var closeButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/level info panel/close button down.png")]
		private static var closeButtonDownImage:Class;
		
		///////////////
		
		private var slotsHolder:NSSprite = new NSSprite();
		
		private var paperTitle:PaperTitle = new PaperTitle();
		
		private var slots:ArrayList = new ArrayList();
		
		private var savedGamesInfos:Array = new Array();
		
		private var closeButton:Button = new Button();
		
		///////////////////////////////
		
		public function SlotsPanel()
		{
			constructPanelBase();
		}
		
		///////////////////////////////
		
		private function constructPanelBase():void
		{
			blockScreenFillAlpha = 0.8;
			enableBlockScreen = true;
			
			closeButton.x = 560;
			closeButton.y = 20;
			ControlConfigurator.configureButton(closeButton, closeButtonNormalImage, closeButtonOverImage, closeButtonDownImage);
			BubbleService.applyBubbleOnMouseOver(closeButton, 1.03);
			
			///////
			
			addChild(slotsHolder);
			
			slotsHolder.addChild(new frameImage() as Bitmap);
			
			slotsHolder.addChild(paperTitle);
			
			slotsHolder.addChild(closeButton);
			
			paperTitle.setTitleText("Local save slots", 22);
		}
		
		override public function show():void
		{
			super.show();
			AnimationEngine.globalAnimator.moveObjects(slotsHolder, 25, 800, 25, 200, 300, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.moveObjects(slotsHolder, 25, 200, 25, 220, 200, AnimationEngine.globalAnimator.currentTime + 300); // back animation
			showBlockScreen();
			
			closeButton.addEventListener(MouseEvent.CLICK, closeButton_clickHandler);
			
			SoundController.instance.playSound(SoundResources.SOUND_WINDOW_SLIDE);
		}
		
		override public function hide():void
		{
			super.hide();
			
			hideBlockScreen();
			
			// release all unnecessary slots
			clearSlots();
			
			closeButton.removeEventListener(MouseEvent.CLICK, closeButton_clickHandler);
		}
		
		private function closeButton_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(CLOSE_CLICKED));
		}
		
		override public function applyPanelInfo(panelInfo:*):void
		{
			clearSlots();
			savedGamesInfos = SlotsPanelInfo(panelInfo).gameInfos;
			
			// create slots for previously saved games
			for (var i:int = 0; i < savedGamesInfos.length; i++)
				slots.addItem(createSlotAt(i, savedGamesInfos[i]));
		}
		
		private function clearSlots():void
		{
			for each (var slot:SlotsPanelSlot in slots.source)
			{
				if (slotsHolder.contains(slot))
					slotsHolder.removeChild(slot);
				
				slot.removeEventListener(MouseEvent.CLICK, slot_clickHandler);
				slot.removeEventListener(ClearSlotEvent.CLEAR_SLOT, slot_clearSlotHandler);
				slot.deactivate();
			}
			
			slots.removeAll();
		}
		
		private function createSlotAt(i:int, info:GameInfo = null):SlotsPanelSlot
		{
			var slot:SlotsPanelSlot = new SlotsPanelSlot();
			slot.updateForGameInfo(info);
			slot.slotIndex = i;
			
			slot.x = 70 + 170 * i;
			slot.y = 50;
			slotsHolder.addChild(slot);
			
			slot.addEventListener(MouseEvent.CLICK, slot_clickHandler);
			slot.addEventListener(ClearSlotEvent.CLEAR_SLOT, slot_clearSlotHandler);
			
			return slot;
		}
		
		private function slot_clickHandler(event:MouseEvent):void
		{
			var slot:SlotsPanelSlot = event.currentTarget as SlotsPanelSlot;
			
			dispatchEvent(new SelectEvent(SelectEvent.SELECTED, slot.slotIndex, savedGamesInfos[slot.slotIndex]));
		}
		
		private function slot_clearSlotHandler(event:ClearSlotEvent):void
		{
			dispatchEvent(event);
			
			// need to request infos for reset
			dispatchEvent(new PanelEvent(PanelEvent.REQUEST_INFOS));
		}
	}

}