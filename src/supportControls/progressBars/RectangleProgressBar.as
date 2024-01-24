/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.progressBars
{
	import flash.display.Shape;
	import nslib.controls.ProgressBarBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class RectangleProgressBar extends ProgressBarBase
	{
		public var barWidth:Number = 50;
		
		public var barHeight:Number = 50;
		
		private var progressShape:Shape = new Shape();
		
		//////////////////////////
		
		public function RectangleProgressBar()
		{
			super();
		}
		
		/////////////////////////
		
		override protected function drawBase():void
		{
			addChild(progressShape);
		}
		
		override protected function drawProgress():void
		{
			if (isNaN(progress))
				return;
			
			progressShape.graphics.clear();
			progressShape.graphics.beginFill(0, 0.5);
			progressShape.graphics.drawRect(0, 0, barWidth, barHeight);
			
			progressShape.graphics.beginFill(0, 0.5);
			progressShape.graphics.drawRect(0, barHeight * progress, barWidth, barHeight * (1 - progress));
		}
		
		override protected function performFinalDrawing():void 
		{
			// we just clear everything when the progress is 1
			progressShape.graphics.clear();
		}
		
		override protected function performDrawingOnReset():void 
		{
			drawProgress();
		}
	}

}