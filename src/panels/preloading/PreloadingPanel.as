/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.preloading
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import flash.display.JointStyle;
	import flash.events.Event;
	import nslib.controls.Button;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportClasses.SponsorInfoGenerator;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PreloadingPanel extends NSSprite
	{
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/base.jpg")]
		private static var titleBaseImage:Class;
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/play button normal.png")]
		private static var playButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/play button over.png")]
		private static var playButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/play button down.png")]
		private static var playButtonDownImage:Class;
		
		/////////////
		
		public var playButton:Button = new Button();
		
		private var progressBar:NSSprite = new NSSprite();
		
		private var preloaderImage:Bitmap = new titleBaseImage() as Bitmap;
		
		private var percentageField:CustomTextField = new CustomTextField(null, new FontDescriptor(40, 0xA2CD0A, FontResources.KOMTXTB));
		
		/////////////
		
		public function PreloadingPanel()
		{
			construct();
		}
		
		/////////////
		
		private var _progress:Number = 0;
		
		public function get progress():Number
		{
			return _progress;
		}
		
		public function set progress(value:Number):void
		{
			_progress = Math.min(1, Math.max(0, value));
			updateProgressBar();
		}
		
		///////////
		
		private function construct():void
		{
			var logoPanel:NSSprite = SponsorInfoGenerator.createSponsorsLogoForPreloadingPage();
			logoPanel.x = (GamePlayConstants.STAGE_WIDTH - logoPanel.width) / 2;
			logoPanel.y = 40;
			
			ControlConfigurator.configureButton(playButton, playButtonNormalImage, playButtonOverImage, playButtonDownImage);
			playButton.x = 273;
			playButton.y = 390;
			playButton.visible = false;
			
			progressBar.x = 50;
			progressBar.y = 390;
			
			percentageField.y = 390 + barHeight + 5;
			
			addChild(preloaderImage);
			addChild(logoPanel);
			addChild(progressBar);
			addChild(percentageField);
			addChild(playButton);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			SponsorInfoGenerator.releasePreloaderLogo();
		}
		
		/////////////
		
		private var barWidth:Number = GamePlayConstants.STAGE_WIDTH - 100;
		
		private var barHeight:Number = 30;
		
		private function updateProgressBar():void
		{
			progressBar.graphics.clear();
			progressBar.graphics.lineStyle(3, 0x303A03, 1, false, "normal", null, JointStyle.ROUND);
			progressBar.graphics.beginFill(0, 0.7);
			progressBar.graphics.drawRect(0, 0, barWidth, barHeight);
			progressBar.graphics.lineStyle(0, 0, 0);
			progressBar.graphics.beginFill(0x87B107);
			progressBar.graphics.drawRect(2, 2, barWidth * progress - 4 + 1, (barHeight - 3) / 2);
			progressBar.graphics.beginFill(0x6D8F05);
			progressBar.graphics.drawRect(2, 2 + (barHeight - 3) / 2, barWidth * progress - 4 + 1, (barHeight - 3) / 2);
			
			percentageField.text = "" + int(progress * 100) + "%";
			percentageField.x = (GamePlayConstants.STAGE_WIDTH - percentageField.width) / 2 + 12;
		}
		
		public function showPlayButton():void
		{
			playButton.visible = true;
			progressBar.visible = false;
			percentageField.visible = false;
		}
	
	}

}