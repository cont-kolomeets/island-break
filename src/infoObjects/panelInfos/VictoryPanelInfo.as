/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.panelInfos
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class VictoryPanelInfo
	{
		public var starsEarned:int = 0;
		
		public var levelMode:String = null;
		
		public function VictoryPanelInfo(starsEarned:int, levelMode:String)
		{
			this.starsEarned = starsEarned;
			this.levelMode = levelMode;
		}
	
	}

}