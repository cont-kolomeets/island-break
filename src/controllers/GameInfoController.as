/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import constants.GamePlayConstants;
	import events.AchievementEvent;
	import flash.events.EventDispatcher;
	import infoObjects.gameInfo.GameInfo;
	import infoObjects.gameInfo.LevelInfo;
	import mainPack.ModeSettings;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * GameInfoController applies a specified SavedGameInfo.
	 * GameInfoController is used to generate the current SavedGameInfo.
	 * GameInfoController contains current information about levels.
	 */
	public class GameInfoController extends EventDispatcher
	{
		private var currentGameInfo:GameInfo = null;
		
		private var serializer:GameInfoSerializer = new GameInfoSerializer();
		
		private var currentSlot:int = 0;
		
		///////////////////////////////////////
		
		public function GameInfoController()
		{
			AchievementsController.instance.gameInfoController = this;
			AchievementsController.instance.addEventListener(AchievementEvent.ACHIEVEMENT_REACHED, achievementsController_achievementReachedHandler);
		}
		
		///////////////////////////////////////
		
		// returns the current game info
		// this instance will be used throughout the whole app
		public function get gameInfo():GameInfo
		{
			return currentGameInfo;
		}
		
		// the specified gameInfo becomes the current one
		public function applyGameInfo(gameInfo:GameInfo):void
		{
			currentGameInfo = gameInfo ? gameInfo : new GameInfo();
		}
		
		public function setCurrentSlot(slotIndex:int):void
		{
			currentSlot = slotIndex;
		}
		
		/**
		 * Returns total amount of stars earned.
		 */
		public function notifyLevelCompleted(level:int, livesLeft:int, levelMode:String):int
		{
			var levelInfo:LevelInfo = currentGameInfo.levelInfos[level];
			var numStartEarnedOnThisLevel:int = -1;
			
			// need to calculate stars only for normal mode
			if (levelMode == ModeSettings.MODE_NORMAL)
			{
				levelInfo.passed = true;
				
				var numStarsEarnedPreviously:int = levelInfo.starsEarned;
				
				numStartEarnedOnThisLevel = calcEarnedNumberOfStars(livesLeft, level);
				
				levelInfo.starsEarned = Math.max(levelInfo.starsEarned, numStartEarnedOnThisLevel);
				
				// check if a level is improved
				if (numStarsEarnedPreviously > 0 && levelInfo.starsEarned > numStarsEarnedPreviously)
					AchievementsController.notifyLevelImproved();
				
				if (level < (GamePlayConstants.NUMBER_OF_LEVELS - 1))
					LevelInfo(currentGameInfo.levelInfos[level + 1]).available = true;
			}
			else
			{
				if (!levelInfo.passed || levelInfo.starsEarned < 3)
					throw new Error("Hard or Unreal mode was allowed for a non-passed level or a level with less than 3 stars!");
				
				if (levelMode == ModeSettings.MODE_HARD)
					levelInfo.hardModePassed = true;
				
				if (levelMode == ModeSettings.MODE_UNREAL)
					levelInfo.unrealModePassed = true;
					
				ModeSettings.assignBonusesAfterCompletingLevel(level, levelMode, gameInfo.bonusInfo);
			}
			
			currentGameInfo.refresh();
			
			return numStartEarnedOnThisLevel;
		}
		
		private function calcEarnedNumberOfStars(lives:int, currentLevel:int):int
		{
			var result:int = 0;
			
			var numLives:int = WaveGenerator.getNumberOfWavesForLevel(currentLevel, ModeSettings.MODE_NORMAL);
			
			if (lives > (numLives * 2 / 3))
				result = 3;
			else if (lives <= (numLives / 3))
				result = 1;
			else
				result = 2;
			
			return result;
		}
		
		// saves the current game to the currently used slot.
		public function saveCurrentGame():void
		{
			serializer.saveGameInfoToFile(currentGameInfo, currentSlot);
		}
		
		public function clearGameAtSlot(slotIndex:int):void
		{
			serializer.clearGameAtSlot(slotIndex);
		}
		
		// returns an array of GameInfo object for previously saved games.
		public function loadSavedGames():Array
		{
			return serializer.loadSavedGamesFromFile();
		}
		
		///////////////////
		
		private function achievementsController_achievementReachedHandler(event:AchievementEvent):void
		{
			dispatchEvent(event);
		}
	}

}