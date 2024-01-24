/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package
{
	import constants.GamePlayConstants;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import nslib.core.Globals;
	import panels.preloading.PreloadingPanel;
	
	/**
	 * SimplePreloader preloads the app. After preloading creates an instance of Main class.
	 */
	public class SimplePreloader extends MovieClip
	{
		/**
		 * Panel to view some information when preloading, including the current progress. 
		 */
		private var panel:PreloadingPanel = new PreloadingPanel();
		
		public function SimplePreloader()
		{
			if (stage)
				configureStage();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			addChild(panel);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			configureStage();
		}
		
		/**
		 * Configures some parameters for the stage. 
		 */
		private function configureStage():void
		{
			Globals.stage = stage;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = GamePlayConstants.GAME_NORMAL_FRAME_RATE;
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void
		{
			// updating the progress
			panel.progress = e.bytesLoaded / e.bytesTotal;
		}
		
		private function checkFrame(e:Event):void
		{
			if (currentFrame == totalFrames)
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			startup();
		}
		
		/**
		 * Creates the app itself and addes it behind, giving some time for components to initialize before a user
		 * presses the "Play" button.
		 */
		private function startup():void
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChildAt(new mainClass() as DisplayObject, 0);
			
			panel.showPlayButton();
			panel.playButton.addEventListener(MouseEvent.CLICK, playButton_clickHandler);
		}
		
		private function playButton_clickHandler(event:MouseEvent):void
		{
			panel.playButton.removeEventListener(MouseEvent.CLICK, playButton_clickHandler);
			
			removeChild(panel);
			
			// starting the app
			Object(getChildAt(0)).start();
		}
	}

}