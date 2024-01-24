/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import flash.utils.Dictionary;
	import infoObjects.WaveInfo;
	import infoObjects.WeaponInfo;
	import mainPack.ModeSettings;
	import nslib.utils.ArrayList;
	import supportClasses.resources.waveConfigs.WaveConfig;
	import supportClasses.resources.WeaponResources;
	import weapons.base.AirCraft;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	import weapons.enemy.EnemyBomberTank;
	import weapons.enemy.EnemyEnergyBall;
	import weapons.enemy.EnemyHelicopter;
	import weapons.enemy.EnemyInvisibleTank;
	import weapons.enemy.EnemyMobileVehicle;
	import weapons.enemy.EnemyPlane;
	import weapons.enemy.EnemyPlaneFactory;
	import weapons.enemy.EnemyRepairTank;
	import weapons.enemy.EnemyTank;
	import weapons.enemy.EnemyWalkingRobot;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WaveGenerator
	{
		// stores infos for new enemies for waves
		private static var newEnemiesInfosHash:Object = null;
		
		//////////////////////////////////
		
		// collects new enemy for each wave for faster access.
		public static function initialize():void
		{
			collectNewEnemiesInfos();
		}
		
		private static function getWAVES(levelMode:String = null):Array
		{
			if (!levelMode)
				return WaveConfig.WAVES;
			
			switch (levelMode)
			{
				case ModeSettings.MODE_NORMAL: 
					return WaveConfig.WAVES;
				case ModeSettings.MODE_HARD: 
					return WaveConfig.WAVES_HARD;
				case ModeSettings.MODE_UNREAL: 
					return WaveConfig.WAVES_UNREAL;
			}
			
			return null;
		}
		
		private static function collectNewEnemiesInfos():void
		{
			newEnemiesInfosHash = {};
			
			var uniqueFilterHash:Object = {};
			
			for (var level:int = 0; level < getWAVES().length; level++)
			{
				var nWaves:int = (getWAVES()[level] as Array).length;
				
				for (var wave:int = 0; wave < nWaves; wave++)
				{
					// new enemies for the current wave
					var newEnemiesInfos:Array = [];
					var waveArray:Array = getWaveObjects(level, wave, null);
					
					for (var i:int = WaveConfig.WAVE_OBJECTS_SHIFT; i < waveArray.length; i++)
					{
						var obj:Object = waveArray[i];
						
						if (obj.name == undefined || obj.level == undefined)
							throw new Error("Description object is corrupted for level: " + level + " and wave: " + wave + "! Check WaveConfig class.");
						
						var key:String = String(obj.name) + "_" + String(obj.level);
						
						var isBoss:Boolean = (obj.name == "helicopter") && (obj.level == 2);
						
						// do not show new enemy tip for the boss
						if (!isBoss && uniqueFilterHash[key] == undefined)
						{
							uniqueFilterHash[key] = "occupied";
							var info:WeaponInfo = WeaponResources.getWeaponInfoByIDAndLevel(String(obj.name), int(obj.level));
							
							if (!info)
								throw new Error("Could not create weapon info for " + String(obj.name) + " level: " + obj.level + ". Check WaveConfig class.");
							else
								newEnemiesInfos.push(info);
						}
					}
					
					newEnemiesInfosHash[level + "_" + wave] = newEnemiesInfos;
				}
			}
		}
		
		// returns Array of WeaponInfo objects for enemies that appear in the specified
		// wave for the first time in the game.
		public static function getInfosForNewEnemies(gameLevel:int, waveCount:int):Array
		{
			return newEnemiesInfosHash[gameLevel + "_" + waveCount];
		}
		
		// Returns a tip index if some is specified for the given wave.
		// Otherwise returns -1.
		public static function getTipIndexForWave(gameLevel:int, waveCount:int, levelMode:String):int
		{
			var index:int = getWAVES(levelMode)[gameLevel][waveCount][WaveConfig.TIP_INDEX_INDEX];
			
			return (index >= 0) ? index : -1;
		}
		
		// returns Array of WeaponInfo objects for all enemies ever appeared
		// in all lelves prior and including the specified one
		public static function getEnabledEnemiesForLevel(gameLevel:int):Array
		{
			var result:ArrayList = new ArrayList();
			
			for (var i:int = 0; i < gameLevel; i++)
			{
				var numWaves:int = getNumberOfWavesForLevel(i, null);
				for (var w:int = 0; w < numWaves; w++)
					result.addFromArray(getInfosForNewEnemies(i, w));
			}
			
			return result.source;
		}
		
		///////////////////////////////////
		
		public static function levelHasAircrafts(gameLevel:int):Boolean
		{
			return Boolean(gameLevel > 2);
		}
		
		///////////////////////////////////
		
		public static function generateEnemyStack(gameLevel:int, waveCount:int, levelMode:String):ArrayList
		{
			var stack:ArrayList = new ArrayList();
			
			var waveArray:Array = getWaveObjects(gameLevel, waveCount, levelMode);
			
			for (var i:int = WaveConfig.WAVE_OBJECTS_SHIFT; i < waveArray.length; i++)
			{
				var obj:Object = waveArray[i];
				var enemy:IWeapon;
				
				switch (obj.name)
				{
					case WeaponResources.ENEMY_TANK: 
						enemy = new EnemyTank();
						break;
					case WeaponResources.ENEMY_MOBILE_VEHICLE: 
						enemy = new EnemyMobileVehicle();
						break;
					case WeaponResources.ENEMY_PLANE: 
						enemy = new EnemyPlane();
						break;
					case WeaponResources.ENEMY_HELICOPTER: 
						enemy = new EnemyHelicopter();
						break;
					case WeaponResources.ENEMY_ENERGY_BALL: 
						enemy = new EnemyEnergyBall();
						break;
					case WeaponResources.ENEMY_WALKING_ROBOT: 
						enemy = new EnemyWalkingRobot();
						break;
					case WeaponResources.ENEMY_INVISIBLE_TANK: 
						enemy = new EnemyInvisibleTank();
						break;
					case WeaponResources.ENEMY_FACTORY_TANK: 
						enemy = new EnemyPlaneFactory();
						break;
					case WeaponResources.ENEMY_BOMBER_TANK: 
						enemy = new EnemyBomberTank();
						break;
					case WeaponResources.ENEMY_REPAIR_TANK: 
						enemy = new EnemyRepairTank();
						break;
				}
				
				enemy.upgradeToLevel(int(obj.level));
				
				// need to assign a path index if available
				if (enemy is Weapon)
					Weapon(enemy).pathIndex = (obj.pathIndex != undefined) ? int(obj.pathIndex) : 0;
				else if (enemy is AirCraft)
					AirCraft(enemy).pathIndex = (obj.pathIndex != undefined) ? int(obj.pathIndex) : 0;
				
				// need to place ground enemy units
				if (enemy is Weapon)
					Weapon(enemy).isPlaced = true;
				
				stack.addItem(enemy);
			}
			
			return stack;
		}
		
		public static function getWaveObjects(gameLevel:int, waveCount:int, levelMode:String):Array
		{
			var WAVES:Array = getWAVES(levelMode);
			
			if (!WAVES[gameLevel] || !WAVES[gameLevel][waveCount])
				return [];
			
			var waveArray:Array = WAVES[gameLevel][waveCount] as Array;
			
			return waveArray;
		}
		
		public static function getBeforeWaveDelay(gameLevel:int, waveCount:int, levelMode:String):int
		{
			var WAVES:Array = getWAVES(levelMode);
			
			if (!WAVES[gameLevel] || !WAVES[gameLevel][waveCount])
				return -1;
			
			return WAVES[gameLevel][waveCount][WaveConfig.DELAY_BEFORE_WAVE_INDEX];
		}
		
		public static function getAfterWaveDelay(gameLevel:int, waveCount:int, levelMode:String):int
		{
			var WAVES:Array = getWAVES(levelMode);
			
			if (!WAVES[gameLevel] || !WAVES[gameLevel][waveCount])
				return -1;
			
			return WAVES[gameLevel][waveCount][WaveConfig.DELAY_AFTER_WAVE_INDEX];
		}
		
		public static function getInteravalBetweenEnemyUtinsForPathAt(gameLevel:int, waveCount:int, pathIndex:int, levelMode:String):int
		{
			var WAVES:Array = getWAVES(levelMode);
			
			if (!WAVES[gameLevel] || !WAVES[gameLevel][waveCount])
				return -1;
			
			return WAVES[gameLevel][waveCount][WaveConfig.DELAY_BETWEEN_UNITS_INDEX_NORMAL][pathIndex];
		}
		
		public static function getSpecialDelayForEnemyUnit(gameLevel:int, waveCount:int, pathIndex:int, unitIndex:int, levelMode:String):Number
		{
			var WAVES:Array = getWAVES(levelMode);
			
			if (!WAVES[gameLevel] || !WAVES[gameLevel][waveCount])
				return NaN;
			
			var waveArray:Object = WAVES[gameLevel][waveCount];
			
			var processedUnitsCount:int = 0;
			
			for (var i:int = WaveConfig.WAVE_OBJECTS_SHIFT; i < waveArray.length; i++)
			{
				var obj:Object = waveArray[i];
				
				if (!obj)
					throw new Error("Illegal search for wave objects!");
				
				// checking the specified path index
				if (obj.pathIndex != undefined)
					if (pathIndex != -1 && int(obj.pathIndex) != pathIndex)
						continue;
				
				if (processedUnitsCount++ == unitIndex)
				{
					var specialDelayIndex:int = (obj.specialDelayIndex != undefined) ? int(obj.specialDelay) : -1;
					
					return (specialDelayIndex == -1) ? NaN : waveArray[WaveConfig.DELAY_BETWEEN_UNITS_INDEX_SPECIAL][specialDelayIndex];
				}
			}
			
			return NaN;
		}
		
		public static function getNumberOfWavesForLevel(gameLevel:int, levelMode:String):int
		{
			var WAVES:Array = getWAVES(levelMode);
			
			if (!WAVES[gameLevel])
				return -1;
			
			return WAVES[gameLevel].length;
		}
		
		public static function getWaveInfoForPathAt(gameLevel:int, waveCount:int, levelMode:String, pathIndex:int = -1):WaveInfo
		{
			var wi:WaveInfo = new WaveInfo();
			
			var dictionary:Dictionary = new Dictionary();
			var uniqueEnemiesArray:Array = [];
			
			var waveArray:Array = getWaveObjects(gameLevel, waveCount, levelMode);
			
			for (var i:int = WaveConfig.WAVE_OBJECTS_SHIFT; i < waveArray.length; i++)
			{
				var obj:Object = waveArray[i];
				
				// checking the specified path index
				if (pathIndex != -1 && int(obj.pathIndex) != pathIndex)
					continue;
				
				var weaponInfo:WeaponInfo = WeaponResources.getWeaponInfoByIDAndLevel(String(obj.name), int(obj.level));
				var key:String = weaponInfo.name + weaponInfo.level;
				
				var isBoss:Boolean = weaponInfo.weaponId == "helicopter" && weaponInfo.level == 2;
				
				if (!isBoss && weaponInfo)
					if (dictionary[key])
						dictionary[key].count = int(dictionary[key].count) + 1;
					else
					{
						uniqueEnemiesArray.push(key);
						dictionary[key] = {count: 1, info: weaponInfo};
					}
			}
			
			for each (var uniqueKey:String in uniqueEnemiesArray)
				wi.registerUnit(WeaponInfo(dictionary[uniqueKey].info), int(dictionary[uniqueKey].count));
			
			wi.waveCount = waveCount;
			
			return wi;
		}
	
	}

}