/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import bot.GameBot;
	import nslib.controls.supportClasses.ChartSeriesInfo;
	import nslib.timers.TimeStamper;
	import nslib.utils.ArrayList;
	import panels.statistics.StatInfo;
	import supportClasses.LogParameters;
	import supportClasses.resources.LogMessages;
	import supportClasses.resources.waveConfigs.composing.WaveComposer;
	import weapons.base.IGroundWeapon;
	import weapons.repairCenter.RepairCenter;
	import weapons.user.UserCannon;
	import weapons.user.UserElectricTower;
	import weapons.user.UserMachineGunTower;
	
	/**
	 * StatisticsController helps to collect statistic data.
	 * Fully static class.
	 */
	public class StatisticsController
	{
		/*
		 *
		 * 1. Начало/конец игровой сессии,
		   2. Включение/выключение паузы,
		   3. Изменение скорости игры,
		   4. Досрочный вызов волны,
		   5. Установка башни Х в координаты АБ,
		   6. Апгрейд башни в месте Х,
		   7. Продажа башни в месте Х,
		   8. Для контроля – потеря кубком жизни,
		   9. Для контроля – выигрыш/проигрыш уровня,
		   10. Для контроля – факт убийства последнего крипа в волне (пишутся координаты крипа).
		
		 */
		
		// global flag defining whether statistics is allowed for the game 
		public static var allowStatiscits:Boolean = false;
		
		private static var currentLevel:int = 0;
		
		private static var stamper:TimeStamper = new TimeStamper();
		
		private static var levelLog:Array = [];
		
		private static var overrallStatistics:Array = [];
		
		//////////
		
		private static var groundUserUnits:ArrayList = new ArrayList();
		
		///////////////////
		
		public static function startStatistics(levelIndex:int):void
		{
			currentLevel = levelIndex;
			levelLog.length = 0;
			groundUserUnits.removeAll();
			stamper.start();
		}
		
		public static function pause():void
		{
			stamper.pause();
		}
		
		public static function resume():void
		{
			stamper.resume();
		}
		
		public static function logMessage(parameters:LogParameters):void
		{
			if (!allowStatiscits)
				throw new Error("Attempt to log a message while statistics for the game is not allowed!");
			
			parameters.timeStamp = stamper.getTimeStamp(false);
			levelLog.push(parameters);
			
			if (parameters.message == LogMessages.TOWER_PLACED)
			{
				if (parameters.item is IGroundWeapon)
				{
					groundUserUnits.addItem(parameters.item);
					performLogForNumGroundUnitsChanged(parameters, true);
				}
			}
			else if (parameters.message == LogMessages.TOWER_SOLD)
			{
				if (parameters.item is IGroundWeapon)
				{
					groundUserUnits.removeItem(parameters.item);
					performLogForNumGroundUnitsChanged(parameters, false);
				}
			}
			else if (parameters.message == LogMessages.TOWER_DESTROYED)
			{
				if (parameters.item is IGroundWeapon)
				{
					groundUserUnits.removeItem(parameters.item);
					performLogForNumGroundUnitsChanged(parameters, false);
				}
			}
		}
		
		private static function performLogForNumGroundUnitsChanged(parameters:LogParameters, unitAdded:Boolean):void
		{
			var param:LogParameters = new LogParameters(LogMessages.NUM_GROUND_UNITS_CHANGED);
			param.userTilesOccupationPercentage = groundUserUnits.length / parameters.totalNumOfTilesForUserWeapon;
			param.item = parameters.item;
			param.unitAdded = unitAdded;
			logMessage(param);
		}
		
		private static function processLoggedMessages():void
		{
			overrallStatistics.length = 0;
			prepareOverallSeriesForMessage(LogMessages.LEVEL_STARTED, 0x00FF2D);
			prepareOverallSeriesForMessage(LogMessages.LEVEL_COMPLETED, 0x00FF2D);
			prepareOverallSeriesForMessage(LogMessages.LEVEL_ACCELERATION_ON, 0x000000);
			prepareOverallSeriesForMessage(LogMessages.LEVEL_ACCELERATION_OFF, 0x000000);
			prepareOverallSeriesForMessage(LogMessages.WAVE_CALLED_EARLIER, 0xE916C4);
			prepareOverallSeriesForMessage(LogMessages.WAVE_STARTED_ITSELF, 0xF78609);
			prepareOverallSeriesForMessage(LogMessages.ENEMY_DESTROYED, 0xFF0000);
			prepareOverallSeriesForMessage(LogMessages.ENEMY_PASSED, 0x0E0C0C);
			prepareOverallSeriesForMessage(LogMessages.TOWER_PLACED, 0x0000FF);
			prepareOverallSeriesForMessage(LogMessages.TOWER_UPGRADED, 0x03AB07);
			prepareOverallSeriesForMessage(LogMessages.TOWER_SOLD, 0xF3ED01);
			prepareOverallSeriesForMessage(LogMessages.TOWER_REPAIRED, 0xC523D1);
			prepareOverallSeriesForMessage(LogMessages.AIR_SUPPORT_CALLED, 0x05E8FA);
			prepareOverallSeriesForMessage(LogMessages.BOMB_DROPPED, 0xD32C2C);
		}
		
		private static function prepareOverallSeriesForMessage(message:String, color:int):void
		{
			var series:ChartSeriesInfo = new ChartSeriesInfo();
			
			series.xValues = [];
			series.yValues = [];
			series.color = color;
			
			for each (var parameters:LogParameters in levelLog)
				if (parameters.message == message)
				{
					series.xValues.push(parameters.timeStamp);
					series.yValues.push(message);
				}
			
			overrallStatistics.push(series);
		}
		
		private static function prepareMoneyStatistics():Array
		{
			var series:ChartSeriesInfo = new ChartSeriesInfo();
			
			series.xValues = [];
			series.yValues = [];
			series.color = 0xFF0000;
			
			for each (var parameters:LogParameters in levelLog)
				if (parameters.message == LogMessages.MONEY_CHANGED)
				{
					series.xValues.push(parameters.timeStamp);
					series.yValues.push(parameters.moneyAvailableNewValue);
				}
			
			// remove the last point
			// since it is after the amount of money is reset
			series.xValues.length = series.xValues.length - 1;
			series.yValues.length = series.yValues.length - 1;
			
			addLastTimeStampForSeries(series);
			return [series];
		}
		
		private static function prepareDepthStatistics():Array
		{
			var series:ChartSeriesInfo = new ChartSeriesInfo();
			
			series.xValues = [0];
			series.yValues = [0];
			series.label = "enemy pass depth";
			series.color = 0x0000FF;
			
			for each (var parameters:LogParameters in levelLog)
				if (parameters.message == LogMessages.ENEMY_DESTROYED)
				{
					series.xValues.push(parameters.timeStamp);
					series.yValues.push(parameters.pathPercentagePassed);
				}
				else if (parameters.message == LogMessages.ENEMY_PASSED)
				{
					series.xValues.push(parameters.timeStamp);
					series.yValues.push(1);
				}
			
			addLastTimeStampForSeries(series);
			return [series];
		}
		
		private static function prepareUserOccupationStatistics():Array
		{
			var series:ChartSeriesInfo = new ChartSeriesInfo();
			
			series.xValues = [0];
			series.yValues = [0];
			series.label = "user tower occupation";
			series.color = 0x005500;
			
			for each (var parameters:LogParameters in levelLog)
				if (parameters.message == LogMessages.NUM_GROUND_UNITS_CHANGED)
				{
					series.xValues.push(parameters.timeStamp);
					series.yValues.push(parameters.userTilesOccupationPercentage);
				}
			
			addLastTimeStampForSeries(series);
			return [series];
		}
		
		private static function prepareUserTowerAccumulationStatistic():Array
		{
			var result:Array = [];
			result.push(prepareUserTowerAccumulationStatisticForClass(UserCannon, 0x005500, "cannon"));
			result.push(prepareUserTowerAccumulationStatisticForClass(UserMachineGunTower, 0xB58004, "m-gun"));
			result.push(prepareUserTowerAccumulationStatisticForClass(UserElectricTower, 0x0989F2, "shock tower"));
			result.push(prepareUserTowerAccumulationStatisticForClass(RepairCenter, 0xC00EDA, "repair center"));
			
			return result;
		}
		
		private static function prepareUserTowerAccumulationStatisticForClass(clazz:Class, color:int, label:String):ChartSeriesInfo
		{
			var series:ChartSeriesInfo = new ChartSeriesInfo();
			
			series.xValues = [0];
			series.yValues = [0];
			series.color = color;
			series.label = label;
			var count:int = 0;
			
			for each (var parameters:LogParameters in levelLog)
				if (parameters.message == LogMessages.NUM_GROUND_UNITS_CHANGED && parameters.item is clazz)
				{
					if (parameters.unitAdded)
						count++;
					else
						count--;
					
					series.xValues.push(parameters.timeStamp);
					series.yValues.push(count);
				}
			
			addLastTimeStampForSeries(series);
			return series;
		}
		
		private static function prepareWaveDifficultyStatistics():Array
		{
			var series:ChartSeriesInfo = new ChartSeriesInfo();
			
			series.xValues = [0];
			series.yValues = [0];
			series.label = "Wave difficulty: Nunits x AVG(armor) x AVG(speed) / interval";
			series.color = 0xFF0000;
			
			for each (var parameters:LogParameters in levelLog)
				if (parameters.message == LogMessages.WAVE_STARTED)
				{
					var diffs:Array = WaveComposer.calcWaveDifficulty(currentLevel, parameters.waveCount, parameters.numPaths);
					
					for each (var diff:Number in diffs)
					{
						series.xValues.push(parameters.timeStamp);
						series.yValues.push(diff);
					}
				}
			
			addLastTimeStampForSeries(series);
			return [series];
		}
		
		private static function addLastTimeStampForSeries(series:ChartSeriesInfo):void
		{
			var param:LogParameters = levelLog[levelLog.length - 1];
			
			if (!param)
				return;
			
			var lastYValue:Number = series.yValues[series.yValues.length - 1];
			
			series.xValues.push(param.timeStamp);
			series.yValues.push(lastYValue);
		}
		
		private static function levelPassedSuccessfully():Boolean
		{
			for each (var parameters:LogParameters in levelLog)
				if (parameters.message == LogMessages.LEVEL_FAILED)
					return false;
			
			return true;
		}
		
		/////////////////
		
		private static function getOverallStatistics():Array
		{
			overrallStatistics = overrallStatistics.reverse();
			return overrallStatistics;
		}
		
		private static function getMoneyStatistics():Array
		{
			return prepareMoneyStatistics();
		}
		
		private static function getPassDepthStatistics():Array
		{
			return prepareDepthStatistics();
		}
		
		private static function getUserOccupationStatistics():Array
		{
			return prepareUserOccupationStatistics();
		}
		
		private static function getUserTowerAccumulationStatistic():Array
		{
			return prepareUserTowerAccumulationStatistic();
		}
		
		private static function getWaveDifficultyStatistics():Array
		{
			return prepareWaveDifficultyStatistics();
		}
		
		public static function getStatInfoForLatestLevel():StatInfo
		{
			processLoggedMessages();
			
			var statInfo:StatInfo = new StatInfo();
			statInfo.moneyStatistics = getMoneyStatistics();
			statInfo.overallStatistics = getOverallStatistics();
			statInfo.passDepthStatistics = getPassDepthStatistics();
			statInfo.userOccupationStatistics = getUserOccupationStatistics();
			statInfo.userTowerAccumulationStatistics = getUserTowerAccumulationStatistic();
			statInfo.waveDifficultyStatistics = getWaveDifficultyStatistics();
			statInfo.levelPassedSuccessfully = levelPassedSuccessfully();
			statInfo.levelIndex = currentLevel;
			statInfo.livesLeft = GameBot.getNumLivesLeft();
			statInfo.livesTotal = GameBot.getNumLivesTotal();
			
			return statInfo;
		}
	}

}