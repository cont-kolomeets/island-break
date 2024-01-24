/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package mainPack
{
	import infoObjects.gameInfo.BonusInfo;
	
	/**
	 * DifficultyConfig changes some parameters of the game according to a difficulty mode.
	 */
	public class DifficultyConfig
	{
		public static const DIFFICULTY_EASY:String = "easy";
		public static const DIFFICULTY_NORMAL:String = "normal";
		public static const DIFFICULTY_HARD:String = "hard";
		
		/**
		 * Armor of every enemy will be multiplied by this coefficient. 
		 */
		public static var armorCoefficient:Number = 0;
		
		/**
		 * User's lives will be multiplied by this coefficient.
		 */
		public static var livesCoefficient:Number = 1;
		
		/**
		 * Sets a new difficulty mode. 
		 * @param	difficulty Must be on the constants of DifficultyConfig class.
		 */
		public static function configureForDifficulty(difficulty:String):void
		{
			switch (difficulty)
			{
				case DIFFICULTY_EASY: 
					armorCoefficient = 0.5;
					livesCoefficient = 1.2;
					break;
				case DIFFICULTY_NORMAL: 
					armorCoefficient = 0.8;
					livesCoefficient = 1;
					break;
				case DIFFICULTY_HARD: 
					armorCoefficient = 1;
					livesCoefficient = 0.9;
					break;
			}
		}
		
		///// for bonuses
		
		private static var _currentBonusInfo:BonusInfo = null;
		
		/**
		 * In some difficulty modes there is some bonus assigned. 
		 * @see infoObjects.gameInfo.BonusInfo
		 */
		public static function get currentBonusInfo():BonusInfo
		{
			return _currentBonusInfo;
		}
		
		public static function assingCurrentBonusInfo(bonusInfo:BonusInfo):void
		{
			_currentBonusInfo = bonusInfo;
		}
	}

}