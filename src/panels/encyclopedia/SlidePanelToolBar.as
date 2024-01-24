/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import nslib.controls.Button;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.BubbleService;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.StoryResources;
	import supportClasses.resources.TipResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SlidePanelToolBar extends NSSprite
	{
		public static const TYPE_TIP:String = "tip";
		
		public static const TYPE_STORY:String = "story";
		
		/////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips panel/button next.png")]
		private static var nextButtonImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/tips panel/button previous.png")]
		private static var prevButtonImage:Class;
		
		////////////////
		
		public var type:String = null;
		
		public var nextSlideButton:Button = new Button();
		
		public var prevSlideButton:Button = new Button();
		
		private var navigationField:CustomTextField = new CustomTextField(null, new FontDescriptor(32, 0xFFFFFF, FontResources.JUNEGULL));
		
		////////////////
		
		public function SlidePanelToolBar(type:String)
		{
			this.type = type;
			
			construct();
		}
		
		////////////////
		
		private function construct():void
		{
			ControlConfigurator.configureButton(nextSlideButton, nextButtonImage);
			nextSlideButton.smoothing = true;
			ControlConfigurator.configureButton(prevSlideButton, prevButtonImage);
			prevSlideButton.smoothing = true;
			
			prevSlideButton.x = 0;
			prevSlideButton.y = 0;
			
			navigationField.y = 20;
			
			nextSlideButton.x = 200;
			nextSlideButton.y = 0;
			
			addChild(nextSlideButton);
			addChild(prevSlideButton);
			addChild(navigationField);
		}
		
		private function getNumImages():int
		{
			return type == TYPE_TIP ? TipResources.getNumImages() : type == TYPE_STORY ? StoryResources.getNumImages() : 0;
		}
		
		public function setCurrentSlideIndex(currentSlideIndex:int):void
		{
			navigationField.text = (currentSlideIndex + 1) + " / " + getNumImages();
			navigationField.x = (this.width - navigationField.width) / 2;
			
			updateNavigationButtons(currentSlideIndex);
		}
		
		private function updateNavigationButtons(currentSlideIndex:int):void
		{
			nextSlideButton.enabled = Boolean(currentSlideIndex < (getNumImages() - 1));
			nextSlideButton.alpha = (currentSlideIndex < (getNumImages() - 1)) ? 1 : 0.5;
			
			prevSlideButton.enabled = Boolean(currentSlideIndex > 0);
			prevSlideButton.alpha = (currentSlideIndex > 0) ? 1 : 0.5;
		}
		
		public function show():void
		{
			BubbleService.applyBubbleOnMouseClick(nextSlideButton, 0.9);
			BubbleService.applyBubbleOnMouseClick(prevSlideButton, 0.9);
		}
		
		public function hide():void
		{
			BubbleService.removeBubbleOnMouseClick(nextSlideButton);
			BubbleService.removeBubbleOnMouseClick(prevSlideButton);
		}
	
	}

}