/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.mapObjects
{
	import flash.geom.Point;
	import nslib.controls.NSSprite;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	
	/**
	 * Creates a group of flying birds.
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BirdsGenerator
	{
		public var workingLayer:NSSprite = null;
		
		private var birds:Array = [];
		
		private var programTimer:AdvancedTimer = new AdvancedTimer(100, 1);
		
		private var currentProgram:BirdFlightProgram = null;
		
		private var currentAnchorIndex:int = 0;
		
		/////////////////////
		
		public function BirdsGenerator()
		{
		}
		
		/////////////////////
		
		public function dispatchBridsWithProgram(program:BirdFlightProgram):void
		{
			if (programTimer.running)
				throw new Error("The flight program is currently running!");
			
			// remove all previous birds
			removeBirds();
			
			programTimer.delay = program.changeInterval;
			
			currentProgram = program;
			currentAnchorIndex = 0;
			
			if (program.anchorPoints.length == 0 || program.anchorPoints.length != program.travelRadii.length)
				throw new Error("Program is not correct!");
			
			programTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, programTimer_timerCompletedHandler);
			programTimer.start();
			
			// create birds
			for each (var type:String in program.birdTypes)
				var bird:Bird = dispatchBirdWithParameters(type, program.startingPoint, program.locationDeviationPixels);
			
			// command to the first anchor
			commandBirdsToNextAnchor();
		}
		
		private function programTimer_timerCompletedHandler(event:AdvancedTimerEvent):void
		{
			if (currentAnchorIndex == currentProgram.anchorPoints.length)
			{
				if (currentProgram.flyInLoop)
					currentAnchorIndex = 0;
				else
				{
					stopProgram();
					return;
				}
			}
			
			commandBirdsToNextAnchor();
			
			programTimer.reset();
			programTimer.start();
		}
		
		private function commandBirdsToNextAnchor():void
		{
			var nextAnchor:Point = currentProgram.anchorPoints[currentAnchorIndex];
			var travelRadius:Number = currentProgram.travelRadii[currentAnchorIndex];
			
			currentAnchorIndex++;
			
			for each (var bird:Bird in birds)
				if (nextAnchor)
				{
					if (bird.isSettled)
						bird.unsettle();
					
					applyParametersToBird(bird, nextAnchor, currentProgram.locationDeviationPixels, travelRadius, currentProgram.radiusDeviationPercentage, currentProgram.travelSpeed, currentProgram.speedDeviationPercentage);
				}
				else
					bird.settle();
		}
		
		public function stopProgram():void
		{
			programTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, programTimer_timerCompletedHandler);
			programTimer.reset();
			
			removeBirds();
			
			currentProgram = null;
		}
		
		public function dispatchBirds(numBirds:int, startingPoint:Point, anchor:Point, travelRadius:int, type:String):void
		{
			if (programTimer.running)
				throw new Error("The flight program is currently running!");
			
			if (!workingLayer)
				throw new Error("Working layer not specified!");
			
			for (var i:int = 0; i < numBirds; i++)
			{
				var bird:Bird = dispatchBirdWithParameters(type, startingPoint, 25);
				applyParametersToBird(bird, anchor, 25, travelRadius, 25);
			}
		}
		
		private function dispatchBirdWithParameters(type:String, startingPoint:Point, locationDeviationPixels:Number):Bird
		{
			var bird:Bird = new Bird(type);
			
			// apply deviation
			bird.x = startingPoint.x + (locationDeviationPixels - locationDeviationPixels * 2 * Math.random());
			bird.y = startingPoint.y + (locationDeviationPixels - locationDeviationPixels * 2 * Math.random());
			
			bird.activate();
			
			workingLayer.addChild(bird);
			
			birds.push(bird);
			
			return bird;
		}
		
		private function applyParametersToBird(bird:Bird, anchor:Point, locationDeviationPixels:Number, travelRadius:Number, radiusDeviationPercentage:Number, travelSpeed:Number = NaN, speedDeviationPercentage:Number = NaN):void
		{
			// apply deviation
			var newAnchor:Point = new Point(anchor.x + (locationDeviationPixels - locationDeviationPixels * 2 * Math.random()), anchor.y + (locationDeviationPixels - locationDeviationPixels * 2 * Math.random()));
			
			bird.anchor = newAnchor;
			bird.travelRadius = travelRadius * (1 + radiusDeviationPercentage / 100 - Math.random());
			
			if (!isNaN(travelSpeed))
				bird.motionSpeed = isNaN(speedDeviationPercentage) ? travelSpeed : (travelSpeed * (1 + speedDeviationPercentage / 100 - Math.random()));
		}
		
		public function removeBirds():void
		{
			for each (var bird:Bird in birds)
			{
				bird.deactivate();
				
				if (workingLayer.contains(bird))
					workingLayer.removeChild(bird);
			}
			
			birds.length = 0;
		}
	}

}