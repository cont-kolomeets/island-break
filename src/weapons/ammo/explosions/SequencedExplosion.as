/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.ammo.explosions
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import nslib.effects.traceEffects.TraceControllerBase;
	import nslib.effects.traceEffects.TraceController;
	import nslib.sequencers.ImageSequencer;
	import nslib.utils.ObjectsPoolUtil;
	import supportClasses.sequences.ExplosionSmallSequence;
	import supportClasses.sequences.ExplosionSmallSequence2;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SequencedExplosion extends EventDispatcher
	{
		public static const EXPLOSION_STARTED:String = "explosionStarted";
		
		public static const EXPLOSION_FINISHED:String = "explosionFinished";
		
		private static const OBJECT_POOL_ID:String = "explosion";
		
		// helps to vary sequences for explosions
		private static var explosionVariator:int = 1;
		
		// prepares explosions for faster access in the future.
		/*public static function prepareInstances(numInstances:int):void
		{
			var instances:Array = [];
			
			for (var i:int = 0; i < numInstances; i++)
				instances.push(takeRandomExplosionFromPool());
			
			for each (var instance:*in instances)
				ObjectsPoolUtil.returnObject(instance);
		}*/
		
		private static function takeRandomExplosionFromPool():ImageSequencer
		{
			var imageSequencer:ImageSequencer = ObjectsPoolUtil.takeObject(ImageSequencer, null, OBJECT_POOL_ID);
			// adding fire balls
			
			// if the sequence is new
			if (imageSequencer.sequenceLength == 0)
			{
				// using a variator
				if (explosionVariator == 1)
					imageSequencer.addImages(ExplosionSmallSequence.images);
				else
					imageSequencer.addImages(ExplosionSmallSequence2.images);
				
				explosionVariator *= -1;
			}
			
			return imageSequencer;
		}
		
		///////////
		
		protected var container:DisplayObjectContainer;
		
		protected var traceController:TraceControllerBase;
		
		private var imageSequencer:ImageSequencer = null;
		
		////////////////////////////////////////////////////////////////////////
		
		public function SequencedExplosion(container:DisplayObjectContainer, traceController:TraceControllerBase)
		{
			this.container = container;
			this.traceController = traceController;
		}
		
		////////////////////////////////////////////////////////////////////////
		
		private var x:int = 0;
		
		private var y:int = 0;
		
		public function explode(x:int, y:int, strength:int = 5):void
		{
			this.x = x;
			this.y = y;
			
			imageSequencer = takeRandomExplosionFromPool();
			
			container.addChild(imageSequencer);
			
			imageSequencer.x = x - imageSequencer.width / 2;
			imageSequencer.y = y - imageSequencer.height / 2;
			
			imageSequencer.playInLoop = false;
			imageSequencer.clearOnStop = false;
			imageSequencer.addEventListener(ImageSequencer.STOPPED, imageSequencer_stoppedHandler);
			imageSequencer.start();
			
			dispatchEvent(new Event(EXPLOSION_STARTED));
		}
		
		private function imageSequencer_stoppedHandler(event:Event):void
		{
			traceController.putPermanentBitmapDataAt(imageSequencer.getCurrentBitmapData(), x - imageSequencer.width / 2, y - imageSequencer.height / 2);
			removeImageSequencer();
			
			dispatchEvent(new Event(EXPLOSION_FINISHED));
		}
		
		private function removeImageSequencer():void
		{
			imageSequencer.removeEventListener(ImageSequencer.STOPPED, imageSequencer_stoppedHandler);
			imageSequencer.stop();
			imageSequencer.clear();
			if (container.contains(imageSequencer))
				container.removeChild(imageSequencer);
			
			ObjectsPoolUtil.returnObject(imageSequencer);
		}
		
		// stops and clears the explosion
		public function stopImmediately():void
		{
			removeImageSequencer();
		}
	}

}