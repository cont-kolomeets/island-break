/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.news
{
	import constants.GamePlayConstants;
	import controllers.SoundController;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import infoObjects.TipInfo;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.BubbleService;
	import supportClasses.resources.SoundResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class NewsContainer extends NSSprite
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const VIEWING_COMPLETED:String = "viewingCompleted";
		
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		private var contentContainer:NSSprite = new NSSprite();
		
		private var paperContainer:StretchablePaperContainer = new StretchablePaperContainer();
		
		private var titleImage:StickingPaper = new StickingPaper();
		
		private var buttonOk:StickingPaper = new StickingPaper();
		
		private var buttonSkip:StickingPaper = new StickingPaper();
		
		private var buttonNext:StickingPaper = new StickingPaper();
		
		private var importantNotification:ImportantNotification = new ImportantNotification();
		
		////////// internal parameters for tips
		
		private var currentTipInfo:TipInfo = null;
		
		private var currentPageIndex:int = -1;
		
		private var currentTipImage:Bitmap = null;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function NewsContainer()
		{
			construct();
		}
		
		/////////////
		
		private var _animationEngine:AnimationEngine = null;
		
		public function get animationEngine():AnimationEngine
		{
			return _animationEngine;
		}
		
		public function set animationEngine(value:AnimationEngine):void
		{
			_animationEngine = value;
			
			paperContainer.animationEngine = value;
			importantNotification.animationEngine = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		private function construct():void
		{
			// build buttons
			buttonOk.color = StickingPaper.COLOR_RED;
			buttonOk.setTitleText("OK!");
			buttonOk.buttonMode = true;
			BubbleService.applyBubbleOnMouseOver(buttonOk, 1.03);
			
			buttonSkip.color = StickingPaper.COLOR_BLUE;
			buttonSkip.setTitleText("SKIP THIS!");
			buttonSkip.buttonMode = true;
			BubbleService.applyBubbleOnMouseOver(buttonSkip, 1.03);
			
			buttonNext.color = StickingPaper.COLOR_RED;
			buttonNext.setTitleText("NEXT TIP!");
			buttonNext.buttonMode = true;
			BubbleService.applyBubbleOnMouseOver(buttonNext, 1.03);
			
			// centering content
			contentContainer.x = GamePlayConstants.STAGE_WIDTH / 2;
			contentContainer.y = GamePlayConstants.STAGE_HEIGHT / 2;
			addChild(contentContainer);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Medthods: showing info for enemy
		//
		//--------------------------------------------------------------------------
		
		public function openForNewEnemy(content:NewEnemyInfoContent, notification:String = null):void
		{
			// this offset is needed for proper fitting
			contentContainer.x = GamePlayConstants.STAGE_WIDTH / 2 + 30;
			
			// need to shift up if there is some notification
			contentContainer.y = GamePlayConstants.STAGE_HEIGHT / 2 - (notification ? 70 : 20);
			
			prepareBase();
			addTitleAndButtonsForNewEnemy();
			showBaseFrameTransitionAnimation(true, null, 20, 0, content.textHeight);
			animateStickingOut(false);
			
			content.x = -paperContainer.widthAfterAnimation / 2 + 30;
			content.y = -content.height / 2;
			contentContainer.addChild(content);
			
			if (notification)
			{
				importantNotification.notification = notification;
				importantNotification.y = 230;
				importantNotification.x = -30; // compensating the shift of contentContainer
				contentContainer.addChild(importantNotification);
				
				importantNotification.visible = true;
				importantNotification.popUpNotification(1000);
			}
			else
				importantNotification.visible = false;
		}
		
		// adds a title and buttons
		private function addTitleAndButtonsForNewEnemy():void
		{
			titleImage.color = StickingPaper.COLOR_RED;
			titleImage.setTitleText("NEW ENEMY!");
			contentContainer.addChildAt(titleImage, 0);
			
			// preparing for animation
			titleImage.alpha = 0;
			
			// adding a button behind the base frame
			contentContainer.addChildAt(buttonOk, 0);
			// preparing for animation
			buttonOk.alpha = 0;
			
			buttonOk.addEventListener(MouseEvent.CLICK, buttonOk_clickHandler);
			buttonOk.addEventListener(MouseEvent.MOUSE_OVER, button_mouseOverHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Medthods: showing info for tips
		//
		//--------------------------------------------------------------------------
		
		public function openForTip(tipInfo:TipInfo):void
		{
			currentTipInfo = tipInfo;
			currentPageIndex = 0;
			var hasMultiplePages:Boolean = currentTipInfo.images.length > 1;
			
			contentContainer.x = GamePlayConstants.STAGE_WIDTH / 2;
			contentContainer.y = GamePlayConstants.STAGE_HEIGHT / 2;
			prepareBase();
			addTitleAndButtonsForGameTip();
			showImageForCurrentPage();
			animateStickingOut(hasMultiplePages, true);
		}
		
		private function showImageForCurrentPage():void
		{
			// remove previous one if exists
			if (currentTipImage && contentContainer.contains(currentTipImage))
				contentContainer.removeChild(currentTipImage);
			
			var imageClass:Class = currentTipInfo.images[currentPageIndex];
			
			if (imageClass)
			{
				currentTipImage = new imageClass() as Bitmap;
				// place in the middle of the paper image
				currentTipImage.x = -currentTipImage.width / 2;
				currentTipImage.y = -currentTipImage.height / 2;
				currentTipImage.smoothing = true;
				contentContainer.addChild(currentTipImage);
				
				// prepare for animation
				currentTipImage.alpha = 0;
				
				var timeOffset:Number = (currentPageIndex == 0) ? 1000 : 300;
				animationEngine.animateProperty(currentTipImage, "alpha", 0, 1, NaN, 200, animationEngine.currentTime + timeOffset);
			}
			
			showBaseFrameTransitionAnimation(Boolean(currentPageIndex == 0), currentTipImage, 35, 35, NaN, true);
		}
		
		private function currentPageIsLast():Boolean
		{
			return Boolean(currentPageIndex == currentTipInfo.images.length - 1);
		}
		
		// adds a title		
		private function addTitleAndButtonsForGameTip():void
		{
			titleImage.color = StickingPaper.COLOR_BLUE;
			titleImage.setTitleText(currentTipInfo.type);
			contentContainer.addChildAt(titleImage, 0);
			
			// preparing for animation
			titleImage.alpha = 0;
			
			updateButtons(true);
			
			buttonOk.addEventListener(MouseEvent.CLICK, buttonOk_clickHandler);
			buttonSkip.addEventListener(MouseEvent.CLICK, buttonSkip_clickHandler);
			buttonNext.addEventListener(MouseEvent.CLICK, buttonNext_clickHandler);
			
			buttonOk.addEventListener(MouseEvent.MOUSE_OVER, button_mouseOverHandler);
			buttonSkip.addEventListener(MouseEvent.MOUSE_OVER, button_mouseOverHandler);
			buttonNext.addEventListener(MouseEvent.MOUSE_OVER, button_mouseOverHandler);
		}
		
		private function updateButtons(prepareForAnimation:Boolean):void
		{
			// remove all buttons first
			if (contentContainer.contains(buttonOk))
				contentContainer.removeChild(buttonOk);
			if (contentContainer.contains(buttonSkip))
				contentContainer.removeChild(buttonSkip);
			if (contentContainer.contains(buttonNext))
				contentContainer.removeChild(buttonNext);
			
			if (!currentPageIsLast())
			{
				// adding a button behind the base frame
				contentContainer.addChildAt(buttonSkip, 0);
				// preparing for animation
				buttonSkip.alpha = prepareForAnimation ? 0 : 1;
				
				contentContainer.addChildAt(buttonNext, 0);
				// preparing for animation
				buttonNext.alpha = prepareForAnimation ? 0 : 1;
			}
			else
			{
				// adding a button behind the base frame
				contentContainer.addChildAt(buttonOk, 0);
				// preparing for animation
				buttonOk.alpha = prepareForAnimation ? 0 : 1;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Medthods: common methods
		//
		//--------------------------------------------------------------------------
		
		// adds the paper image to the center of the screen
		private function prepareBase():void
		{
			contentContainer.removeAllChildren();
			
			// adding base frame
			contentContainer.addChild(paperContainer);
		}
		
		// can be either popping or smooth transition
		private function showBaseFrameTransitionAnimation(isPoping:Boolean = true, objectToFit:DisplayObject = null, borderH:Number = 0, borderV:Number = 0, prefferredHeight:Number = NaN, centerTitle:Boolean = false):void
		{
			paperContainer.showTransitionAnimation(isPoping, objectToFit, borderH, borderV, prefferredHeight);
			
			if (!isPoping)
			{
				positionTitle(300, centerTitle);
				positionButtons(300);
			}
		}
		
		private function positionTitle(duration:Number = NaN, centerTitle:Boolean = false):void
		{
			// when positioning the title and buttons need to take into account the dimentions of the paperContainer
			var newPositionX:Number = centerTitle ? (-titleImage.width / 2) : (-paperContainer.widthAfterAnimation / 2 + 35);
			var newPositionY:Number = -paperContainer.heightAfterAnimation / 2 - titleImage.height / 1.5;
			
			if (isNaN(duration))
			{
				titleImage.x = newPositionX;
				titleImage.y = newPositionY;
			}
			else
				animationEngine.moveObjects(titleImage, titleImage.x, titleImage.y, newPositionX, newPositionY, duration, animationEngine.currentTime);
		}
		
		private function positionButtons(duration:Number = NaN):void
		{
			var leftButtonX:Number = -paperContainer.widthAfterAnimation / 2 + 50;
			var leftButtonY:Number = paperContainer.heightAfterAnimation / 2 - 25;
			
			var rightButtonX:Number = paperContainer.widthAfterAnimation / 2 - 200;
			var rightButtonY:Number = paperContainer.heightAfterAnimation / 2 - 25;
			
			if (isNaN(duration))
			{
				// apply immediate positioning
				buttonNext.x = rightButtonX;
				buttonNext.y = rightButtonY;
				
				buttonSkip.x = leftButtonX;
				buttonSkip.y = leftButtonY;
				
				buttonOk.x = rightButtonX;
				buttonOk.y = rightButtonY;
			}
			else
			{
				// apply smooth positioning
				animationEngine.moveObjects(buttonOk, buttonOk.x, buttonOk.y, rightButtonX, rightButtonY, duration, animationEngine.currentTime);
				animationEngine.moveObjects(buttonNext, buttonNext.x, buttonNext.y, rightButtonX, rightButtonY, duration, animationEngine.currentTime);
				animationEngine.moveObjects(buttonSkip, buttonSkip.x, buttonSkip.y, leftButtonX, leftButtonY, duration, animationEngine.currentTime);
			}
		}
		
		private function animateStickingOut(hasMultiplePages:Boolean, centerTitle:Boolean = false):void
		{
			positionTitle(NaN, centerTitle);
			
			// stiking title out
			animationEngine.animateProperty(titleImage, "alpha", 0, 1, NaN, 10, animationEngine.currentTime + 1000);
			animationEngine.moveObjects(titleImage, titleImage.x, titleImage.y + titleImage.height, titleImage.x, titleImage.y - 10, 250, animationEngine.currentTime + 1000);
			animationEngine.moveObjects(titleImage, titleImage.x, titleImage.y - 10, titleImage.x, titleImage.y, 120, animationEngine.currentTime + 1200); // back motion
			
			positionButtons();
			
			// need to position buttons
			if (hasMultiplePages)
			{
				animateButtonStickingOut(buttonNext);
				animateButtonStickingOut(buttonSkip);
			}
			
			// this button is positioned and animated anyway
			// but in case of multiple pages
			// this button is not added to the content yet
			animateButtonStickingOut(buttonOk);
		}
		
		private function animateButtonStickingOut(button:DisplayObject):void
		{
			// stiking button out
			animationEngine.animateProperty(button, "alpha", 0, 1, NaN, 10, animationEngine.currentTime + 1000);
			animationEngine.moveObjects(button, button.x, button.y - button.height, button.x, button.y + 10, 250, animationEngine.currentTime + 1000);
			animationEngine.moveObjects(button, button.x, button.y + 10, button.x, button.y, 120, animationEngine.currentTime + 1200); // back motion
		}
		
		//--------------------------------------------------------------------------
		//
		//  Medthods: closing
		//
		//--------------------------------------------------------------------------
		
		public function notifyClosed():void
		{
			buttonOk.removeEventListener(MouseEvent.CLICK, buttonOk_clickHandler);
			buttonSkip.removeEventListener(MouseEvent.CLICK, buttonSkip_clickHandler);
			buttonNext.removeEventListener(MouseEvent.CLICK, buttonNext_clickHandler);
			
			buttonOk.removeEventListener(MouseEvent.MOUSE_OVER, button_mouseOverHandler);
			buttonSkip.removeEventListener(MouseEvent.MOUSE_OVER, button_mouseOverHandler);
			buttonNext.removeEventListener(MouseEvent.MOUSE_OVER, button_mouseOverHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Medthods: handling button events
		//
		//--------------------------------------------------------------------------
		
		private function buttonOk_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(VIEWING_COMPLETED));
			
			SoundController.instance.playSound(SoundResources.SOUND_PAPER_TIP_CLOSE);
		}
		
		private function buttonSkip_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event(VIEWING_COMPLETED));
			
			SoundController.instance.playSound(SoundResources.SOUND_PAPER_TIP_CLOSE);
		}
		
		private function buttonNext_clickHandler(event:MouseEvent):void
		{
			currentPageIndex++;
			showImageForCurrentPage();
			updateButtons(false);
			
			SoundController.instance.playSound(SoundResources.SOUND_PAPER_TIP_PAGE_TURN);
		}
		
		private function button_mouseOverHandler(event:MouseEvent):void
		{
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_HOVER);
		}
	}

}