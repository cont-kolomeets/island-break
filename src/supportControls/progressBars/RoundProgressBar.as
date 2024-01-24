/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.progressBars
{
	import controllers.SoundController;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import infoObjects.WaveInfo;
	import mainPack.GameSettings;
	import nslib.controls.NSSprite;
	import nslib.controls.ProgressBarBase;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.geometry.Graph;
	import nslib.utils.NSMath;
	import supportClasses.resources.SoundResources;
	import supportControls.toolTips.WaveToolTip;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class RoundProgressBar extends ProgressBarBase
	{
		
		[Embed(source="F:/Island Defence/media/images/common images/progress bars/wave progress bar base.png")]
		private static var baseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/progress bars/wave progress bar arrow.png")]
		private static var arrowImage:Class;
		
		/////////////////////
		
		public var pathIndex:int = 0;
		
		public var isInitial:Boolean = false;
		
		private var baseShape:Bitmap = null;
		
		private var arrowShape:Bitmap = null;
		
		private var arrowContainer:NSSprite = new NSSprite();
		
		private var progressShape:Graph = new Graph();
		
		//////////////////////////
		
		public function RoundProgressBar()
		{
			mouseEnabled = true;
			buttonMode = true;
			useHandCursor = true;
			progressShape.clearOnEveryDrawing = true;
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		/////////////////////////
		
		private var _arrowAngle:Number = 0;
		
		public function get arrowAngle():Number
		{
			return _arrowAngle;
		}
		
		public function set arrowAngle(value:Number):void
		{
			_arrowAngle = value;
			arrowContainer.rotation = NSMath.radToDeg(value);
		}
		
		/////////////////////////
		
		override protected function drawBase():void
		{
			addChild(progressShape);
			
			baseShape = new baseImage() as Bitmap;
			baseShape.smoothing = true;
			baseShape.x = -baseShape.width / 2;
			baseShape.y = -baseShape.height / 2;
			
			addChild(baseShape);
			
			arrowShape = new arrowImage() as Bitmap;
			arrowShape.smoothing = true;
			arrowShape.x = baseShape.width / 2 - 7;
			arrowShape.y = -arrowShape.height / 2;
			
			arrowContainer.addChild(arrowShape);
			
			addChild(arrowContainer);
		}
		
		override protected function drawProgress():void
		{
			progressShape.lineStyle(3, 0xFF781E, 1);
			progressShape.drawArc(baseShape.width / 2 - 4, 0, NSMath.PI * 2 * progress);
		}
		
		////////////////////
		
		public function applyWaveInfo(waveInfo:WaveInfo):void
		{
			if (!GameSettings.enableTooltips)
				return;
			
			ToolTipService.setToolTip(this, new ToolTipInfo(this, waveInfo), WaveToolTip);
		}
		
		public function removeWaveTooltip():void
		{
			ToolTipService.removeAllTooltipsForComponent(this);
		}
		
		/////////
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			removeWaveTooltip()
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_HOVER);
		}
	
	}

}