/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.fireWorks
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class FireWork extends EventDispatcher
	{
		public var workingLayer:DisplayObjectContainer = null;
		
		public var particleType:String = FireWorkParticle.TYPE_SQUARE;
		
		public var particleRadius:int = 3;
		
		public var scaleParticles:Boolean = false;
		
		private var deltaTimeCounter:DeltaTime = DeltaTime.globalDeltaTimeCounter;
		
		private var isBusy:Boolean = false;
		
		private var particles:Array = [];
		
		private var duration:Number = 0;
		
		private var currentTime:Number = 0;
		
		public function FireWork()
		{
		}
		
		public function putFireWorkAt(x:Number, y:Number, color:int, duration:Number = 1000, numParticles:int = 10):void
		{
			if (isBusy)
				return;
			
			isBusy = true;
			currentTime = 0;
			
			this.duration = duration;
			generateParticlesAt(x, y, color, numParticles);
			
			deltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeCounter_deltaTimeAquiredHandler);
		}
		
		private function deltaTimeCounter_deltaTimeAquiredHandler(event:DeltaTimeEvent):void
		{
			currentTime += event.lastDeltaTime;
			
			if (currentTime > duration)
			{
				isBusy = false;
				deltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, deltaTimeCounter_deltaTimeAquiredHandler);
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			for each (var particle:FireWorkParticle in particles)
			{
				if (particle.deactivated)
					continue;
				
				particle.vx *= 0.98;
				particle.vy += 0.0005 * event.lastDeltaTime;
				
				particle.x += particle.vx * event.lastDeltaTime;
				particle.y += particle.vy * event.lastDeltaTime;
				
				particle.existingTime += event.lastDeltaTime;
				
				if (particle.existingTime >= particle.lifeTime)
				{
					if (workingLayer.contains(particle))
						workingLayer.removeChild(particle);
					
					particle.deactivated = true;
					continue;
				}
				
				particle.alpha = 1 - particle.existingTime / particle.lifeTime;
				
				if (scaleParticles)
				{
					particle.scaleX = Math.min(1, particle.existingTime / particle.lifeTime * 2);
					particle.scaleY = Math.min(1, particle.existingTime / particle.lifeTime * 2);
				}
			}
		}
		
		private function generateParticlesAt(x:Number, y:Number, color:int, numParticles:int):void
		{
			particles.length = 0;
			
			for (var i:int = 0; i < numParticles; i++)
			{
				var particle:FireWorkParticle = new FireWorkParticle(color, particleRadius, particleType);
				particle.lifeTime = duration / 2 * (1 + Math.random());
				particle.x = x;
				particle.y = y;
				particle.vx = 0.1 - Math.random() * 0.2;
				particle.vy = 0.1 - Math.random() * 0.5;
				
				if (scaleParticles)
				{
					particle.scaleX = 0;
					particle.scaleY = 0;
				}
				
				particles.push(particle);
				
				if (!workingLayer)
					throw new Error("WorkingLayer is not specified!");
				
				workingLayer.addChild(particle);
			}
		}
	
	}

}