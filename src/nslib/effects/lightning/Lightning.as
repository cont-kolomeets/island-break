/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.lightning
{
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import nslib.effects.explosions.Explosion;
	import nslib.effects.traceEffects.TraceController;
	import nslib.geometry.Graph;
	import nslib.geometry.SimplePoint;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Lightning
	{
		private var container:NSSprite;
		
		private var traceController:TraceController;
		
		private var explosion:Explosion;
		
		private var lightningShape1:Graph = new Graph();
		
		private var lightningShape2:Graph = new Graph();
		
		private var start:SimplePoint;
		
		private var end:SimplePoint;
		
		private var amplitude:Number = NaN;
		
		private var repetitions:int = 0;
		
		////////////////////////////////////////////////////////////////////////
		
		public function Lightning(container:NSSprite, traceController:TraceController)
		{
			this.container = container;
			this.traceController = traceController;
			
			explosion = new Explosion(container, traceController);
			explosion.ballCenterColor = 0xCDF8EF;
			explosion.ballRimColor = 0x37E3C1;
			explosion.fragmentCenterColor = 0x97E0F2;
			explosion.fragmentRimColor = 0x6DD3ED;
			
			lightningShape1.lineStyle(1, 0x63E7CC, 0.8);
			lightningShape1.clearOnEveryDrawing = true;
			lightningShape2.lineStyle(1, 0x63E7CC, 0.8);
			lightningShape2.clearOnEveryDrawing = true;
		}
		
		///////////////////////////////////////////////////////////////////////
		
		public function set lightningColor(value:int):void
		{
			lightningShape1.lineStyle(1, value, 0.8);
			lightningShape2.lineStyle(1, value, 0.8);
		}
		
		////////////////////////////////////////////////////////////////////////
		
		public function drawSingleLightning(x1:Number, y1:Number, x2:Number, y2:Number, amplitude:Number, repetitions:int):void
		{
			lightningShape1.drawNoisyLine(x1, y1, x2, y2, amplitude, repetitions, true);
			
			container.addChild(lightningShape1);
			
			AnimationEngine.globalAnimator.fadeOut([lightningShape1], 1000, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.removeFromParent(lightningShape1, container, AnimationEngine.globalAnimator.currentTime + 1000);
			AnimationEngine.globalAnimator.fadeIn([lightningShape1], 10, AnimationEngine.globalAnimator.currentTime + 1000);
			
			explosion.explode(x2, y2, 2, 50, false);
		}
		
		public function drawFrequentLightning(x1:Number, y1:Number, x2:Number, y2:Number, amplitude:Number, noiseRepetitions:Number, duration:Number):void
		{
			start = new SimplePoint(x1, y1);
			end = new SimplePoint(x2, y2);
			this.amplitude = amplitude;
			this.repetitions = noiseRepetitions;
			
			container.addChild(lightningShape1);
			container.addChild(lightningShape2);
			
			var flashes:int = int(duration / 30);
			var explosions:int = NSMath.max(1, int(duration / 300));
			
			for (var i:int = 0; i < flashes; i++)
				AnimationEngine.globalAnimator.executeFunction(performSingleDrawing, null, AnimationEngine.globalAnimator.currentTime + i * 30);
				
			for (var j:int = 0; j < explosions; j++)
				AnimationEngine.globalAnimator.executeFunction(performSingleExplosion, null, AnimationEngine.globalAnimator.currentTime + j * 300);
			
			AnimationEngine.globalAnimator.removeFromParent(lightningShape1, container, AnimationEngine.globalAnimator.currentTime + duration);
			AnimationEngine.globalAnimator.removeFromParent(lightningShape2, container, AnimationEngine.globalAnimator.currentTime + duration);
		}
		
		private function performSingleDrawing():void
		{
			lightningShape1.drawNoisyLine(start.x, start.y, end.x, end.y, amplitude, repetitions, true);
			lightningShape2.drawNoisyLine(start.x, start.y, end.x, end.y, amplitude, repetitions, true);
		}
		
		private function performSingleExplosion():void
		{
			explosion.explode(end.x, end.y, 2, 50, false);
		}
	
	}

}