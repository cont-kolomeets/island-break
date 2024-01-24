/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.panelInfos 
{
	import infoObjects.gameInfo.GameInfo;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameControlPanelInfo 
	{
		public var scores:int = 0;
		
		public var totalWaves:int = 0;
		
		public var currentWave:int = 0;
		
		public var lives:int = 0;
		
		public function GameControlPanelInfo(scores:int, totalWaves:int, currentWave:int, lives:int) 
		{
			this.scores = scores;
			this.totalWaves = totalWaves;
			this.currentWave = currentWave;
			this.lives = lives;
		}
		
	}

}