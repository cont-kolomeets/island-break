/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import controllers.WaveGenerator;
	import events.SelectEvent;
	import flash.events.Event;
	import infoObjects.gameInfo.DevelopmentInfo;
	import infoObjects.gameInfo.GameInfo;
	import infoObjects.WeaponInfo;
	import nslib.controls.NSSprite;
	import nslib.utils.ArrayList;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UnitsList extends NSSprite
	{
		public var itemsInRow:int = 5;
		
		public var getInfosFunction:Function = null;
		
		private var unitButtons:ArrayList = new ArrayList();
		
		////////////
		
		public function UnitsList()
		{
		}
		
		////////////
		
		private var rowCount:int = 0;
		private var columnCount:int = 0;
		
		// accepts an array of WeaponInfo objects
		public function showItemsForUserWeaponInfos(developmentInfo:DevelopmentInfo):void
		{
			var infos:Array = getInfosFunction();
			
			clearList();
			
			// reseting flags
			rowCount = 0;
			columnCount = 0;
			
			for (var i:int = 0; i < infos.length; i++)
			{
				var info:WeaponInfo = infos[i] as WeaponInfo;
				
				var unitButton:UnitButton = new UnitButton();
				unitButton.buildButtonForWeaponInfo(info);
				
				if (info.weaponId == WeaponResources.USER_OBSTACLE)
					unitButton.currentState = UnitButton.STATE_UNLOCKED;
				else
					unitButton.currentState = developmentInfo.levelIsDevelopedForWeapon(info) ? UnitButton.STATE_UNLOCKED : UnitButton.STATE_LOCKED;
				
				placeButton(unitButton);
			}
		}
		
		public function showItemsForEnemyWeaponInfos(gameInfo:GameInfo):void
		{
			var infos:Array = getInfosFunction();
			
			clearList();
			
			// reseting flags
			rowCount = 0;
			columnCount = 0;
			
			// getting all enabled enemies (need to increase the number of passed levels to view enemies in advance)
			var enabledEnemies:Array = WaveGenerator.getEnabledEnemiesForLevel(gameInfo.numLevelsPassed + 1);
			// creating hash
			var hash:Object = {};
			
			for each (var enabledInfo:WeaponInfo in enabledEnemies)
				if (gameInfo.helpInfo.enemyAlreadyAppearedOnStage(enabledInfo))
					hash[enabledInfo.weaponId + enabledInfo.level] = true;
			
			for (var i:int = 0; i < infos.length; i++)
			{
				var info:WeaponInfo = infos[i] as WeaponInfo;
				
				var unitButton:UnitButton = new UnitButton();
				unitButton.buildButtonForWeaponInfo(info);
				unitButton.currentState = (hash[info.weaponId + info.level]) ? UnitButton.STATE_UNLOCKED : UnitButton.STATE_LOCKED;
				
				placeButton(unitButton);
			}
		}
		
		private function placeButton(unitButton:UnitButton):void
		{
			unitButton.x = rowCount * 70;
			unitButton.y = columnCount * 70;
			
			if (++rowCount == itemsInRow)
			{
				rowCount = 0;
				columnCount++;
			}
			
			addChild(unitButton);
			
			unitButton.addEventListener(UnitButton.SHOW_INFO, unitButton_showInfoHandler);
			unitButtons.addItem(unitButton);
		}
		
		private function clearList():void
		{
			for each (var unitButton:UnitButton in unitButtons.source)
				unitButton.removeEventListener(UnitButton.SHOW_INFO, unitButton_showInfoHandler);
			
			unitButtons.removeAll();
			removeAllChildren();
		}
		
		private function unitButton_showInfoHandler(event:Event):void
		{
			var unitButton:UnitButton = event.currentTarget as UnitButton;
			
			// unselecting all other buttons
			setUpAllButtons();
			unitButton.setDown();
			
			dispatchEvent(new SelectEvent(SelectEvent.SELECTED, unitButtons.getItemIndex(unitButton), unitButton.currentWeaponInfo));
		}
		
		public function setUpAllButtons():void
		{
			for each (var unitButton:UnitButton in unitButtons.source)
				unitButton.setUp();
		}
	
	}

}