/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.fireWorks
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import nslib.animation.engines.AnimationEngine;
	import nslib.utils.UIDUtil;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BatchFireWork extends EventDispatcher
	{
		public var workingLayer:DisplayObjectContainer = null;
		
		private var functionIDs:Array = [];
		
		public function BatchFireWork()
		{
		}
		
		public function startFirework(prototype:FireWork, numFlashes:int, color:int, flashDuration:Number, interval:int = 1000):void
		{
			stop();
			
			var totalTime:Number = 0;
			
			var flashFunction:Function = function():void
			{
				var fireWork:FireWork = new FireWork();
				fireWork.workingLayer = workingLayer;
				fireWork.particleRadius = prototype.particleRadius;
				fireWork.scaleParticles = prototype.scaleParticles;
				fireWork.particleType = prototype.particleType;
				
				fireWork.putFireWorkAt(workingLayer.stage.stageWidth * Math.random(), workingLayer.stage.stageHeight * Math.random(), color, flashDuration);
			}
			
			for (var i:int = 0; i < numFlashes; i++)
			{
				var functionID:String = UIDUtil.generateUniqueID();
				AnimationEngine.globalAnimator.executeFunction(flashFunction, null, AnimationEngine.globalAnimator.currentTime + totalTime, functionID);
				totalTime += interval * Math.random();
				
				functionIDs.push(functionID);
			}
		}
		
		public function stop():void
		{
			for each(var id:String in functionIDs)
				AnimationEngine.globalAnimator.stopExecutingFunctionByID(id);
			
			functionIDs.length = 0;
		}
	
	}

}