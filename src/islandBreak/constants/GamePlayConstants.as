/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package islandBreak.constants 
{
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GamePlayConstants 
	{
		public static const GAME_VERSION:String = "0.01";
		
		// number of lives in the beginning of the game.
		public static const INITIAL_NUMBER_OF_LIVES:int = 5;
		
		// estimated interval between frames in milliseconds. Value 40 corresponds to 25 frames per second.
		public static const STANDARD_INTERVAL:int = 40;
		
		public static const GAME_NORMAL_FRAME_RATE:int = 30;
		
		// total number of levels.
		public static const NUMBER_OF_LEVELS:int = 10;
		
		// use this not to have to wait for the stage property to be assigned.
		public static const STAGE_WIDTH:int = 700;
		
		// use this not to have to wait for the stage property to be assigned.
		public static const STAGE_HEIGHT:int = 550;
	}

}