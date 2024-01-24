/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.mapObjects
{
	import nslib.AIPack.anchorFollowing.AnchorFollower;
	import nslib.sequencers.ImageSequencer;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Bird extends AnchorFollower
	{
		public static const BIRD_TYPE_HUGE_WHITE:String = "hugeWhite";
		
		public static const BIRD_TYPE_BIG_BLACK:String = "bigBlack";
		
		public static const BIRD_TYPE_SMALL_BLACK:String = "smallBlack";
		
		public static const BIRD_TYPE_SMALL_RED:String = "smallRed";
		
		public static const BIRD_TYPE_SMALL_YELLOW:String = "smallYellow";
		
		public static const BIRD_TYPE_SMALL_MAGENTA:String = "smallMagenta";
		
		public static const BIRD_TYPE_SMALL_GREEN:String = "smallGreen";
		
		public static const BIRD_TYPE_TINY_CYAN:String = "tinyCyan";
		
		///////////////
		
		// big bird
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird 01 f01.png")]
		private static var bird01F01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird 01 f02.png")]
		private static var bird01F02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird 01 f03.png")]
		private static var bird01F03Image:Class;
		
		// small bird
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird 02 f01.png")]
		private static var bird02F01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird 02 f02.png")]
		private static var bird02F02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird 02 f03.png")]
		private static var bird02F03Image:Class;
		
		// huge white bird
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird 03 f01.png")]
		private static var bird03F01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird 03 f02.png")]
		private static var bird03F02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird 03 f03.png")]
		private static var bird03F03Image:Class;
		
		// small red bird
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird red f01.png")]
		private static var birdRedF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird red f02.png")]
		private static var birdRedF02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird red f03.png")]
		private static var birdRedF03Image:Class;
		
		// small yellow bird
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird yellow f01.png")]
		private static var birdYellowF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird yellow f02.png")]
		private static var birdYellowF02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird yellow f03.png")]
		private static var birdYellowF03Image:Class;
		
		// small magenta bird
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird magenta f01.png")]
		private static var birdMagentaF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird magenta f02.png")]
		private static var birdMagentaF02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird magenta f03.png")]
		private static var birdMagentaF03Image:Class;
		
		// small green bird
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird green f01.png")]
		private static var birdGreenF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird green f02.png")]
		private static var birdGreenF02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird green f03.png")]
		private static var birdGreenF03Image:Class;
		
		// tiny cyan bird
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird cyan f01.png")]
		private static var birdCyanF01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird cyan f02.png")]
		private static var birdCyanF02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/birds/bird cyan f03.png")]
		private static var birdCyanF03Image:Class;
		
		/////////
		
		private const BIRD_LAND_INDEX:int = 1;
		
		private var type:String = null;
		
		private var birdSequence:ImageSequencer = new ImageSequencer();
		
		/////////
		
		public function Bird(type:String)
		{
			this.type = type;
			
			construct();
		}
		
		////////
		
		private var _isSettled:Boolean = false;
		
		public function get isSettled():Boolean
		{
			return _isSettled;
		}
		
		///////
		
		protected function construct():void
		{
			birdSequence.playInLoop = true;
			birdSequence.smoothing = true;
			
			if (type == BIRD_TYPE_BIG_BLACK)
			{
				birdSequence.addImages([bird01F01Image, bird01F02Image, bird01F03Image, bird01F02Image]);
				birdSequence.frameRate = 25;
			}
			else if (type == BIRD_TYPE_SMALL_BLACK)
			{
				birdSequence.addImages([bird02F01Image, bird02F02Image, bird02F03Image, bird02F02Image]);
				birdSequence.frameRate = 25;
			}
			else if (type == BIRD_TYPE_HUGE_WHITE)
			{
				birdSequence.addImages([bird03F03Image, bird03F02Image, bird03F02Image, bird03F02Image, bird03F01Image, bird03F02Image]);
				birdSequence.frameRate = 5;
			}
			else if (type == BIRD_TYPE_SMALL_RED)
			{
				birdSequence.addImages([birdRedF01Image, birdRedF02Image, birdRedF03Image, birdRedF02Image]);
				birdSequence.frameRate = 25;
			}
			else if (type == BIRD_TYPE_SMALL_YELLOW)
			{
				birdSequence.addImages([birdYellowF01Image, birdYellowF02Image, birdYellowF03Image, birdYellowF02Image]);
				birdSequence.frameRate = 25;
			}
			else if (type == BIRD_TYPE_SMALL_MAGENTA)
			{
				birdSequence.addImages([birdMagentaF01Image, birdMagentaF02Image, birdMagentaF03Image, birdMagentaF02Image]);
				birdSequence.frameRate = 25;
			}
			else if (type == BIRD_TYPE_SMALL_GREEN)
			{
				birdSequence.addImages([birdGreenF01Image, birdGreenF02Image, birdGreenF03Image, birdGreenF02Image]);
				birdSequence.frameRate = 25;
			}
			else if (type == BIRD_TYPE_TINY_CYAN)
			{
				birdSequence.addImages([birdCyanF01Image, birdCyanF02Image, birdCyanF03Image, birdCyanF02Image]);
				birdSequence.frameRate = 25;
			}
			else
				throw new Error("Specified type is not supported!");
			
			birdSequence.rotation = 90;
			birdSequence.x = birdSequence.height / 2;
			birdSequence.y = -birdSequence.width / 2;
			
			body.addChild(birdSequence);
			addChild(body);
		}
		
		override public function activate():void
		{
			super.activate();
			
			birdSequence.start();
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			
			birdSequence.stop();
		}
		
		public function settle():void
		{
			_isSettled = true;
			super.deactivate();
			birdSequence.setCurrentFrameIndex(BIRD_LAND_INDEX);
		}
		
		public function unsettle():void
		{
			_isSettled = false;
			activate();
		}
	
	}

}