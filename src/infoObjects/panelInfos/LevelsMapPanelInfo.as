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
	public class LevelsMapPanelInfo 
	{
		// current game info
		public var gameInfo:GameInfo = null;
		
		public function LevelsMapPanelInfo(gameInfo:GameInfo) 
		{
			this.gameInfo = gameInfo;
		}
	}

}