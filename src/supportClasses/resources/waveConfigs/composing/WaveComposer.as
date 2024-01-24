/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources.waveConfigs.composing
{
	import controllers.WaveGenerator;
	import infoObjects.WeaponInfo;
	import nslib.controls.supportClasses.ChartSeriesInfo;
	import nslib.utils.NSMath;
	import supportClasses.resources.waveConfigs.WaveConfig;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class WaveComposer
	{
		
		public static function calcWaveDifficulty(levelIndex:int, waveCount:int, numPaths:int):Array
		{
			var result:Array = [];
			var waveInfo:ComposedWaveInfo = getWaveInfo(levelIndex, waveCount);
			
			for (var currentPath:int = 0; currentPath < numPaths; currentPath++)
			{
				var avgArmor:Number = waveInfo.calcAvgParameter("armor", currentPath);
				var avgSpeed:Number = waveInfo.calcAvgParameter("motionSpeed", currentPath);
				var avgHitThreshold:Number = waveInfo.calcAvgParameter("hitThreshold", currentPath);
				var avgElectricityResistance:Number = waveInfo.calcAvgParameter("electricityResistance", currentPath);
				
				var difficulty:Number = waveInfo.waveObjects.length * avgArmor * avgSpeed * (1 + avgHitThreshold / 5) * (1 + avgElectricityResistance / 10) / WaveGenerator.getInteravalBetweenEnemyUtinsForPathAt(levelIndex, waveCount, currentPath, null) * 1000;
				result.push(difficulty);
			}
			
			return result;
		}
		
		private static function getWaveInfo(levelIndex:int, waveCount:int):ComposedWaveInfo
		{
			var waveInfo:ComposedWaveInfo = new ComposedWaveInfo();
			var levelObject:Array = WaveConfig.WAVES[levelIndex] as Array;
			var waveObject:Array = levelObject[waveCount];
			
			waveInfo.delayBeforeWave = waveObject[WaveConfig.DELAY_BEFORE_WAVE_INDEX];
			waveInfo.delayAfterWave = waveObject[WaveConfig.DELAY_AFTER_WAVE_INDEX];
			waveInfo.delayBetweenUnits = waveObject[WaveConfig.DELAY_BETWEEN_UNITS_INDEX_NORMAL];
			waveInfo.tipIndex = waveObject[WaveConfig.TIP_INDEX_INDEX];
			
			var waveObjects:Array = [];
			var rawWaveObjects:Array = WaveGenerator.getWaveObjects(levelIndex, waveCount, null);
			
			for (var i:int = WaveConfig.WAVE_OBJECTS_SHIFT; i < rawWaveObjects.length; i++)
			{
				var object:Object = rawWaveObjects[i];
				var wo:ComposedWaveObjectInfo = new ComposedWaveObjectInfo(object.name, object.level, object.pathIndex);
				wo.weaponInfo = WeaponResources.getWeaponInfoByIDAndLevel(wo.name, wo.level);
				
				waveObjects.push(wo);
			}
			
			waveInfo.waveObjects = waveObjects;
			
			return waveInfo;
		}
	}

}