/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	import infoObjects.gameInfo.GameInfo;
	import infoObjects.gameInfo.LevelInfo;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * SaveController is designed to save the current game state to a file to a file.
	 */
	public class GameInfoSerializer extends EventDispatcher
	{
		private var sharedObject:SharedObject = SharedObject.getLocal("islandDefence.gameInfos");
		
		private var slotsAvailable:int = 3;
		
		////////////
		
		public function GameInfoSerializer()
		{
			// comment this to allow game to be saved
			//clear();
			//sharedObject.data["0"] = getFakeGameInfo();
		}
		
		///////////
		
		public function loadSavedGamesFromFile():Array
		{
			var result:Array = [];
			
			if (sharedObject.data)
				for (var i:int = 0; i < slotsAvailable; i++)
				{
					var gameInfo:GameInfo = deserializeGameInfo(sharedObject.data["" + i]);
					
					// if we can't load any game from the slot, just clear the slot.
					if (!gameInfo)
						clearGameAtSlot(i);
					
					result.push(gameInfo);
				}
			
			return result;
		}
		
		public function saveGameInfoToFile(gameInfo:GameInfo, slotIndex:int):void
		{
			// need to set the current date
			gameInfo.updateDate();
			
			sharedObject.data[slotIndex] = serializeGameInfo(gameInfo);
		}
		
		private function serializeGameInfo(gameInfo:GameInfo):Object
		{
			return GameInfo.toObject(gameInfo);
		}
		
		private function deserializeGameInfo(obj:Object):GameInfo
		{
			// checking for right format
			if (!obj || obj.levelInfos == undefined || obj.developmentInfos == undefined)
				return null;
			
			return GameInfo.fromObject(obj);
		
			//return getFakeGameInfo();
		}
		
		public function clearGameAtSlot(slotIndex:int):void
		{
			delete sharedObject.data[slotIndex];
		}
		
		public function clear():void
		{
			if (sharedObject.data)
				for (var id:String in sharedObject.data)
					delete sharedObject.data[id];
		}
		
		////////////
		
		private function getFakeGameInfo():Object
		{
			var gi:GameInfo = new GameInfo();
			
			for (var i:int = 0; i <= 8; i++)
			{
				LevelInfo(gi.levelInfos[i]).passed = true;
				LevelInfo(gi.levelInfos[i]).available = true;
				LevelInfo(gi.levelInfos[i]).starsEarned = 3;
			}
			
			LevelInfo(gi.levelInfos[9]).available = true;
			
			gi.refresh();
			
			return GameInfo.toObject(gi);
		}
	}

}