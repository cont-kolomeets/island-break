/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package map
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import supportClasses.mapObjects.Bird;
	import supportClasses.mapObjects.BirdFlightProgram;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapLevel1 extends Map
	{
		[Embed(source="F:/Island Defence/media/images/levels/level 01.jpg")]
		public static var levelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/ground pads/base for weapon yellow.png")]
		public static var baseForWeaponImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/barricade.png")]
		private static var obstacleImage:Class;
		
		//////////////////////////////
		
		//////////////////////////////
		
		public function MapLevel1()
		{
			super();
			
			levelImageClass = levelImage;
			weaponPadClass = baseForWeaponImage;
			defaultObstacleClass = obstacleImage;
			numberOfPaths = 1;
			gunRestAngle = Math.PI;
			constructMap();
			
			// configure birds
			birdsFlightProgram = new BirdFlightProgram();

			birdsFlightProgram.startingPoint = new Point(650, 550);
			birdsFlightProgram.anchorPoints = [new Point(650, 450), new Point(600, 460), new Point(620, 440), new Point(670, 450)];
			birdsFlightProgram.travelRadii = [20, 5, 20, 20];
			birdsFlightProgram.locationDeviationPixels = 25;
			birdsFlightProgram.radiusDeviationPercentage = 50;
			birdsFlightProgram.changeInterval = 10000;
			birdsFlightProgram.birdTypes = [Bird.BIRD_TYPE_SMALL_BLACK, Bird.BIRD_TYPE_SMALL_BLACK];
		}
		
		///////////////////////////////
		
		override protected function createDescription():void
		{
			description = MapLibrary.getMap01();
		}
		
		//private var seaSequencer:ImageSequencer = new ImageSequencer();
		
		override public function placeAnimatedPartsGround(workingLayer:DisplayObjectContainer):void 
		{
			/*seaSequencer.addEventListener(Event.REMOVED_FROM_STAGE, seaSequencer_removedFromStageHandler);
			
			seaSequencer.frameRate = 2;
			seaSequencer.playInLoop = true;
			seaSequencer.addImages([seaF01Image, seaF02Image, seaF03Image, seaF04Image, seaF05Image, seaF06Image, seaF07Image, seaF08Image]);
			
			seaSequencer.start();
			
			seaSequencer.x = 0;
			seaSequencer.y = GamePlayConstants.STAGE_HEIGHT - seaSequencer.height;
			
			workingLayer.addChild(seaSequencer);*/
		}
		
		/*private function seaSequencer_removedFromStageHandler(event:Event):void
		{
			seaSequencer.stop();
			seaSequencer.removeEventListener(Event.REMOVED_FROM_STAGE, seaSequencer_removedFromStageHandler);
		}*/

	}

}