/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import panels.PanelBase;
	import supportClasses.resources.StoryResources;
	import supportClasses.resources.TipResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ImageSlidePanel extends PanelBase
	{
		public static const TYPE_TIP_PANEL:String = "tipPanel";
		
		public static const TYPE_STORY_PANEL:String = "storyPanel";
		
		/////////////
		
		[Embed(source="F:/Island Defence/media/images/common images/paper big.png")]
		private static var baseFrameImage:Class;
		
		///////////////////
		
		
		public var type:String = null;
		
		private var baseFrame:Bitmap = null;
		
		private var baseFrameContainer:NSSprite = new NSSprite();
		
		private var slideHolder:NSSprite = new NSSprite();
		
		private var toolbar:SlidePanelToolBar = null;
		
		/////
		
		private var currentSlideIndex:int = 0;
		
		///////////////////
		
		public function ImageSlidePanel(type:String)
		{
			this.type = type;
			
			toolbar = new SlidePanelToolBar(type == TYPE_TIP_PANEL ? SlidePanelToolBar.TYPE_TIP : type == TYPE_STORY_PANEL ? SlidePanelToolBar.TYPE_STORY : null);
			
			construct();
		}
		
		///////////////////
		
		private function construct():void
		{
			baseFrame = new baseFrameImage() as Bitmap;
			baseFrame.smoothing = true;
			baseFrameContainer.addChild(baseFrame);
			
			addChild(baseFrameContainer);
			
			toolbar.x = 220;
			toolbar.y = 450;
			
			addChild(toolbar);
			
			addChild(slideHolder);
			
			showSlideAt(currentSlideIndex);
			
			/*var logo:NSSprite = type == TYPE_TIP_PANEL ? SponsorInfoGenerator.createSponsorLogoForEncyclopediaTipsPage() : SponsorInfoGenerator.createSponsorLogoForEncyclopediaStoryPage();
			logo.x = 87;
			logo.y = GamePlayConstants.STAGE_HEIGHT - 70;
			addChild(logo);*/
		}
		
		////////////////
		
		override public function show():void
		{
			super.show();
			
			toolbar.show();
			
			toolbar.nextSlideButton.addEventListener(ButtonEvent.BUTTON_CLICK, nextSlideButton_clickHandler);
			toolbar.prevSlideButton.addEventListener(ButtonEvent.BUTTON_CLICK, prevSlideButton_clickHandler);
			
			// reset paging
			showSlideAt(0);
		}
		
		override public function hide():void
		{
			super.hide();
			
			toolbar.hide();
			
			toolbar.nextSlideButton.removeEventListener(ButtonEvent.BUTTON_CLICK, nextSlideButton_clickHandler);
			toolbar.prevSlideButton.removeEventListener(ButtonEvent.BUTTON_CLICK, prevSlideButton_clickHandler);
		}
		
		private function showSlideAt(index:int):void
		{
			var numImages:int = type == TYPE_TIP_PANEL ? TipResources.getNumImages() : type == TYPE_STORY_PANEL ? StoryResources.getNumImages() : 0;
			// not allowing the index to get out of bounds
			currentSlideIndex = Math.min(Math.max(0, index), (numImages - 1));
			
			slideHolder.removeAllChildren();
			var slideClass:Class = type == TYPE_TIP_PANEL ? TipResources.getTipImageAt(currentSlideIndex) : type == TYPE_STORY_PANEL ? StoryResources.getStoryPartAt(currentSlideIndex) : null;
			var slideImage:Bitmap = new slideClass() as Bitmap;
			slideImage.smoothing = true;
			// scale slide image
			var ratio:Number = 350 / slideImage.height;
			ratio = (ratio > 1) ? 1 : ratio;
			slideImage.scaleX = ratio;
			slideImage.scaleY = ratio;
			slideHolder.addChild(slideImage);
			
			slideHolder.x = (GamePlayConstants.STAGE_WIDTH - slideHolder.width) / 2;
			slideHolder.y = (GamePlayConstants.STAGE_HEIGHT - slideHolder.height) / 2 - 10;
			
			toolbar.setCurrentSlideIndex(currentSlideIndex);
			
			fitPaperContainer(slideHolder);
		}
		
		private function fitPaperContainer(slideHolder:NSSprite):void
		{
			baseFrameContainer.x = slideHolder.x - 25;
			baseFrameContainer.y = slideHolder.y - 30;
			
			// reset scale
			baseFrameContainer.scaleX = 1;
			baseFrameContainer.scaleY = 1;
			
			baseFrameContainer.scaleX = (slideHolder.width + 60) / baseFrameContainer.width;
			baseFrameContainer.scaleY = (slideHolder.height + 60) / baseFrameContainer.height;
		}
		
		private function nextSlideButton_clickHandler(event:ButtonEvent):void
		{
			showSlideAt(currentSlideIndex + 1);
		}
		
		private function prevSlideButton_clickHandler(event:ButtonEvent):void
		{
			showSlideAt(currentSlideIndex - 1);
		}
	
	}

}