/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.progressBars
{
	import nslib.controls.ProgressBarBase;
	import nslib.geometry.Graph;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SectorProgressBar extends ProgressBarBase
	{
		private var progressShape:Graph = new Graph();
		
		//////////////////////////
		
		public function SectorProgressBar()
		{
			progressShape.clearOnEveryDrawing = true;
		}
		
		/////////////////////////
		
		override protected function drawBase():void
		{
			addChild(progressShape);
		}
		
		override protected function drawProgress():void
		{
			progressShape.lineStyle(1, 0x094503, 0.5);
			progressShape.fill(0x094503, 0.5);
			progressShape.drawSector(23, -NSMath.PI / 2, NSMath.PI * 2 * (1 - progress) - NSMath.PI / 2);
		}
	
	}

}