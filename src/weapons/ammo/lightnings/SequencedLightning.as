/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.ammo.lightnings
{
	import flash.events.Event;
	import nslib.controls.NSSprite;
	import nslib.sequencers.ImageSequencer;
	import nslib.utils.NSMath;
	import nslib.utils.ObjectsPoolUtil;
	import supportClasses.sequences.LightningSequence01;
	import supportClasses.sequences.LightningSequence02;
	import supportClasses.sequences.LightningSequence03;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SequencedLightning
	{
		public static const COLOR_BLUE:int = 0x63E7CC;
		
		public static const COLOR_PINK:int = 0xE85FEB;
		
		public static const COLOR_VIOLET:int = 0x9E78D1;
		
		///////////
		
		protected var container:NSSprite;
		
		private var imageSequencer:ImageSequencer = null;
		
		private var localContainer:NSSprite = new NSSprite();
		
		////////////////////////////////////////////////////////////////////////
		
		public function SequencedLightning(container:NSSprite)
		{
			this.container = container;
		}
		
		////////////////////////////////////////////////////////////////////////
		
		public function drawFrequentLightning(x1:Number, y1:Number, x2:Number, y2:Number, color:int = COLOR_BLUE):void
		{
			imageSequencer = null;
			
			// getting a sequencer
			switch (color)
			{
				case COLOR_PINK: 
					imageSequencer = ObjectsPoolUtil.takeObject(ImageSequencer, null, "lightning_pink");
					break;
				case COLOR_VIOLET: 
					imageSequencer = ObjectsPoolUtil.takeObject(ImageSequencer, null, "lightning_violet");
					break;
				default: 
					imageSequencer = ObjectsPoolUtil.takeObject(ImageSequencer, null, "lightning_blue");
					break;
			}
			
			// if the sequence is new
			if (imageSequencer.sequenceLength == 0)
			{
				switch (color)
				{
					case COLOR_PINK: 
						imageSequencer.addImages(LightningSequence02.images);
						break;
					case COLOR_VIOLET: 
						imageSequencer.addImages(LightningSequence03.images);
						break;
					default: 
						imageSequencer.addImages(LightningSequence01.images);
						break;
				}
			}
			
			localContainer.addChild(imageSequencer);
			container.addChild(localContainer);
			
			localContainer.x = x1;
			localContainer.y = y1;
			
			imageSequencer.x = -imageSequencer.width / 2;
			
			var a:Number = Math.atan2(x1 - x2, y2 - y1);
			localContainer.rotation = NSMath.radToDeg(a);
			
			var scaleFactor:Number = Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) / imageSequencer.height;
			imageSequencer.scaleY = scaleFactor;
			
			imageSequencer.playInLoop = false;
			imageSequencer.clearOnStop = false;
			imageSequencer.addEventListener(ImageSequencer.STOPPED, imageSequencer_stoppedHandler);
			imageSequencer.start();
		}
		
		private function imageSequencer_stoppedHandler(event:Event):void
		{
			imageSequencer.removeEventListener(ImageSequencer.STOPPED, imageSequencer_stoppedHandler);
			imageSequencer.clear();
			imageSequencer.scaleY = 1;
			
			if (container.contains(localContainer))
				container.removeChild(localContainer);
			
			ObjectsPoolUtil.returnObject(imageSequencer);
		}
	
	}
}