/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses
{
	import flash.events.Event;
	import nslib.sequencers.ImageSequencer;
	import nslib.utils.ArrayList;
	import nslib.utils.ObjectsPoolUtil;
	import supportClasses.sequences.DustSequence;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class DustGenerator
	{
		/////////
		
		private static const OBJECT_POOL_ID:String = "duster";
		
		private static function takeDustSequenceFromPool():ImageSequencer
		{
			var imageSequencer:ImageSequencer = ObjectsPoolUtil.takeObject(ImageSequencer, null, OBJECT_POOL_ID);
			// adding fire balls
			
			// if the sequence is new
			if (imageSequencer.sequenceLength == 0)
				imageSequencer.addImages(DustSequence.images);
			
			return imageSequencer;
		}
		
		////////////////
		
		private var owner:Weapon = null;
		
		private var runningSequencers:ArrayList = new ArrayList();
		
		/////////
		
		public function DustGenerator(owner:Weapon)
		{
			this.owner = owner;
		}
		
		/////////
		
		public function startDusting():void
		{
			putCloud();
		}
		
		private function putCloud():void
		{
			var imageSequencer:ImageSequencer = takeDustSequenceFromPool();
			
			imageSequencer.rotation = 180;
			imageSequencer.x = -owner.rect.width / 1.7;
			imageSequencer.y = imageSequencer.height / 2;
			
			imageSequencer.playInLoop = true;
			imageSequencer.clearOnStop = true;
			imageSequencer.frameRate = 10;
			imageSequencer.addEventListener(ImageSequencer.STOPPED, imageSequencer_stoppedHandler);
			imageSequencer.start();
			
			owner.partRotatingAlongTrajectory.addChildAt(imageSequencer, 0);
			
			runningSequencers.addItem(imageSequencer);
		}
		
		private function imageSequencer_stoppedHandler(event:Event):void
		{
			removeImageSequencer(event.currentTarget as ImageSequencer);
		}
		
		private function removeImageSequencer(imageSequencer:ImageSequencer):void
		{
			imageSequencer.removeEventListener(ImageSequencer.STOPPED, imageSequencer_stoppedHandler);
			imageSequencer.stop();
			imageSequencer.clear();
			
			if (owner.partRotatingAlongTrajectory.contains(imageSequencer))
				owner.partRotatingAlongTrajectory.removeChild(imageSequencer);
			
			if (!runningSequencers.locked)
				runningSequencers.removeItem(imageSequencer);
			
			ObjectsPoolUtil.returnObject(imageSequencer);
		}
		
		public function stopDusting():void
		{
			var wasLocked:Boolean = runningSequencers.locked;
			runningSequencers.locked = true;
			
			for each (var imageSequencer:ImageSequencer in runningSequencers.source)
				removeImageSequencer(imageSequencer);
				
			runningSequencers.locked = wasLocked;
			
			runningSequencers.removeAll();
		}
	
	}

}