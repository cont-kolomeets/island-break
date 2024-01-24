/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package mainPack
{
	import controllers.WaveGenerator;
	import infoObjects.gameInfo.BonusInfo;
	import infoObjects.gameInfo.DevelopmentInfo;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ModeSettings
	{
		public static const MODE_NORMAL:String = "modeNormal";
		
		public static const MODE_HARD:String = "modeHard";
		
		public static const MODE_UNREAL:String = "modeUnreal";
		
		public static function getDescriptionsForLevel(levelIndex:int, mode:String):Array
		{
			var descriptions:Array = [];
			
			switch (levelIndex)
			{
				case 0: 
					if (mode == MODE_HARD)
					{
						descriptions.push("3 hard waves.");
						descriptions.push("Only cannons allowed.");
						descriptions.push("No bombs or air support.");
						descriptions.push("Cooldown for bomb support reduced by 10%.");
					}
					else if (mode == MODE_UNREAL)
					{
						descriptions.push("1 super wave.");
						descriptions.push("Only cannons allowed.");
						descriptions.push("Cooldown for air support reduced by 10%.");
					}
					
					break;
			}
			
			return descriptions;
		
			// Bonus:
			// Cooldown for bomb support reduced by 5.
			// Cooldown for air support reduced by 5.
			// Air support lasts longer by 5 s.
			// Destroying an enemy brings more money by 10%
			// All attackes have a chance of dealing double damage
			// Increase attack range
			// Towers return 90% of value when sold
			// ... Towers construction and upgrading costs reduced by 10%
			// ... Towers repair costs reduced by 10%
			//... Repair center performs faster damage fixing
		}
		
		public static function getNumberOfLivesForLevel(levelIndex:int, mode:String):int
		{
			switch (mode)
			{
				case MODE_NORMAL: 
					return WaveGenerator.getNumberOfWavesForLevel(levelIndex, mode) * DifficultyConfig.livesCoefficient;
				case MODE_HARD: 
					switch (levelIndex)
				{
					case 0: 
						return 3;
				}
				case MODE_UNREAL: 
					switch (levelIndex)
				{
					case 0: 
						return 1;
				}
			}
			
			return -1;
		}
		
		public static function getDevelopmentInfoForLevel(levelIndex:int, mode:String):DevelopmentInfo
		{
			if (mode == MODE_NORMAL)
				throw new Error("getDevelopmentInfoForLevel() method cannot be used for normal mode!");
			
			var devInfo:DevelopmentInfo = new DevelopmentInfo();
			devInfo.lockedForMode = true;
			
			if (mode == MODE_HARD)
			{
				switch (levelIndex)
				{
					case 0: 
						devInfo.cannonLevel = 0;
						devInfo.machineGunLevel = -1;
						break;
				}
			}
			else if (mode == MODE_UNREAL)
			{
				switch (levelIndex)
				{
					case 0: 
						devInfo.cannonLevel = 0;
						devInfo.machineGunLevel = -1;
						break;
				}
			}
			
			return devInfo;
		}
		
		public static function getScoresForLevel(levelIndex:int, mode:String):int
		{
			if (mode == MODE_NORMAL)
				throw new Error("getScoresForLevel() method cannot be used for normal mode!");
			
			if (mode == MODE_HARD)
			{
				switch (levelIndex)
				{
					case 0: 
						return 1000;
				}
			}
			else if (mode == MODE_UNREAL)
			{
				switch (levelIndex)
				{
					case 0: 
						return 1000;
				}
			}
			
			return -1;
		}
		
		public static function earningMonyAllowedForLevel(levelIndex:int, mode:String):Boolean
		{
			if (mode == MODE_HARD)
			{
				switch (levelIndex)
				{
					case 0: 
						return true;
				}
			}
			else if (mode == MODE_UNREAL)
			{
				switch (levelIndex)
				{
					case 0: 
						return false;
				}
			}
			
			return true;
		}
		
		public static function assignBonusesAfterCompletingLevel(levelIndex:int, mode:String, bonusInfo:BonusInfo):void
		{
			if (mode == MODE_HARD)
			{
				switch (levelIndex)
				{
					case 0: 
						bonusInfo.airSupportCoolDownCoefficient = 0.5;
						bonusInfo.bombSupportCoolDownCoefficient = 0.5;
						bonusInfo.totalMoneyCoefficient = 2;
						break;
				}
			}
			else if (mode == MODE_UNREAL)
			{
				switch (levelIndex)
				{
					case 0: 
						bonusInfo.bombSupportCoolDownCoefficient = 0.5;
						break;
				}
			}
		}
	
	}

}