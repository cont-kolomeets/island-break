/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.panelInfos
{
	import infoObjects.gameInfo.DevelopmentInfo;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponSettingsPanelInfo
	{
		public var x:int;
		
		public var y:int;
		
		public var priceToRepair:int;
		
		public var priceToSell:int;
		
		public var priceToUpgrade:int;
		
		public var selectedItem:*;
		
		public var totalScores:int;
		
		// current development info.
		public var developmentInfo:DevelopmentInfo;
		
		public var numPaths:int = 1;
		
		public var currentLevelHasAircrafts:Boolean = false;
		
		public function WeaponSettingsPanelInfo(x:int, y:int, priceToRepair:int, priceToSell:int, priceToUpgrade:int, totalScores:int, selectedItem:*, developmentInfo:DevelopmentInfo, numPaths:int = 1, currentLevelHasAircrafts:Boolean = false)
		{
			this.x = x;
			this.y = y;
			this.priceToRepair = priceToRepair;
			this.priceToSell = priceToSell;
			this.priceToUpgrade = priceToUpgrade;
			this.totalScores = totalScores;
			this.selectedItem = selectedItem;
			this.developmentInfo = developmentInfo;
			this.numPaths = numPaths;
			this.currentLevelHasAircrafts = currentLevelHasAircrafts;
		}
	
	}

}