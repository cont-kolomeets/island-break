/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.panelInfos 
{
	/**
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SlotsPanelInfo 
	{
		//Array of GameInfo objects for previously saved games.
		public var gameInfos:Array = [];
		
		public function SlotsPanelInfo(gameInfos:Array) 
		{
			this.gameInfos = gameInfos;
		}
		
	}

}