/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import events.WaveEvent;
	import flash.events.EventDispatcher;
	import infoObjects.WaveInfo;
	import mainPack.ModeSettings;
	import map.Map;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	import nslib.utils.ArrayList;
	import nslib.utils.NSMath;
	import weapons.base.AirCraft;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WaveController extends EventDispatcher
	{
		public var createdUnitsCount:int = 0;
		public var createdUnitsCountPath1:int = 0;
		public var createdUnitsCountPath2:int = 0;
		
		// this one is for internal use
		private var waveCount:int = -1;
		
		private var requestedUnitsNumber:int = 0;
		
		private var currentLevel:int = 0;
		
		private var currentLevelMode:String = ModeSettings.MODE_NORMAL;
		
		// zero-base index of the current wave
		private var actualWaveCount:int = -1;
		
		public function WaveController()
		{
		}
		
		public function reset():void
		{
			waveCount = -1;
			actualWaveCount = -1;
			stopNow();
		}
		
		public function getCurrentWaveCount():int
		{
			return waveCount;
		}
		
		public function currentWaveIsLast():Boolean
		{
			var wavesTotal:int = WaveGenerator.getNumberOfWavesForLevel(currentLevel, currentLevelMode);
			
			return Boolean((wavesTotal - waveCount) == 1);
		}
		
		public function setCurrentConfigurations(level:int, levelMode:String):void
		{
			currentLevel = level;
			currentLevelMode = levelMode;
		}
		
		public function createNextWave():void
		{
			actualWaveCount++;
			
			prepareEnemyStacks();
			prepareTimerForNextWave();
		}
		
		////////////////////
		
		private var timers:ArrayList = new ArrayList();
		
		private var waveCompletedDelayTimer:AdvancedTimer = new AdvancedTimer(100, 1);
		
		private function prepareTimerForNextWave():void
		{
			waveCompletedDelayTimer.reset();
			disposeTimers();
			
			var numPaths:int = enemyStacks.length;
			
			for (var p:int = 0; p < numPaths; p++)
			{
				var delayTimer:AdvancedTimer = new AdvancedTimer(getCurrentBeforeWaveDelay(), 1);
				
				delayTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, delayTimer_completeHandler);
				delayTimer.reset();
				delayTimer.start();
				
				timers.addItemAt(delayTimer, p);
			}
		}
		
		private function disposeTimers():void
		{
			var wasLocked:Boolean = timers.locked;
			timers.locked = true;
			for each (var delayTimer:AdvancedTimer in timers.source)
			{
				delayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, delayTimer_completeHandler);
				delayTimer.reset();
			}
			timers.locked = wasLocked;
			
			timers.removeAll();
		}
		
		private function getPathIndexForTimer(delayTimer:AdvancedTimer):int
		{
			return timers.getItemIndex(delayTimer);
		}
		
		private var enemyStacks:Array = null;
		
		private function prepareEnemyStacks():void
		{
			enemyStacks = [];
			var totalStack:ArrayList = WaveGenerator.generateEnemyStack(currentLevel, actualWaveCount, currentLevelMode);
			
			createdUnitsCount = 0;
			createdUnitsCountPath1 = 0;
			createdUnitsCountPath2 = 0;
			requestedUnitsNumber = totalStack.length;
			
			for each (var item:IWeapon in totalStack.source)
			{
				var pathIndex:int = 0;
				if ((item is Weapon) && (Weapon(item).pathIndex != -1))
					pathIndex = Weapon(item).pathIndex;
				else if ((item is AirCraft) && (AirCraft(item).pathIndex != -1))
					pathIndex = AirCraft(item).pathIndex;
				
				if (!enemyStacks[pathIndex])
					enemyStacks[pathIndex] = [];
				
				(enemyStacks[pathIndex] as Array).push(item);
			}
		}
		
		private function unitForPathAtAvailable(pathIndex:int):Boolean
		{
			return Boolean(enemyStacks[pathIndex] && (enemyStacks[pathIndex] as Array).length > 0)
		}
		
		////////////////////
		
		public function getCurrentBeforeWaveDelay():Number
		{
			return WaveGenerator.getBeforeWaveDelay(currentLevel, actualWaveCount, currentLevelMode);
		}
		
		public function getCurrentAfterWaveDelay():Number
		{
			return WaveGenerator.getAfterWaveDelay(currentLevel, actualWaveCount, currentLevelMode);
		}
		
		public function getCurrentWaveInfoForPathAt(pathIndex:int):WaveInfo
		{
			return WaveGenerator.getWaveInfoForPathAt(currentLevel, NSMath.max(0, actualWaveCount), currentLevelMode, pathIndex);
		}
		
		private function delayTimer_completeHandler(event:AdvancedTimerEvent):void
		{
			var delayTimer:AdvancedTimer = event.currentTarget as AdvancedTimer;
			
			if (createdUnitsCount == 0)
			{
				waveCount++;
				dispatchEvent(new WaveEvent(WaveEvent.WAVE_STARTED));
			}
			
			if (createdUnitsCount >= requestedUnitsNumber)
			{
				disposeTimers();
				
				if (waveCount >= (WaveGenerator.getNumberOfWavesForLevel(currentLevel, currentLevelMode) - 1))
					dispatchLevelCompletedEvent();
				else
				{
					waveCompletedDelayTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, dispatchWaveCompletedEventAfterDelay);
					waveCompletedDelayTimer.delay = getCurrentAfterWaveDelay();
					waveCompletedDelayTimer.reset();
					waveCompletedDelayTimer.start();
				}
				
				return;
			}
			
			var pathIndex:int = getPathIndexForTimer(delayTimer);
			
			if (!unitForPathAtAvailable(pathIndex))
				return;
			
			var newDelay:Number = WaveGenerator.getSpecialDelayForEnemyUnit(currentLevel, actualWaveCount, pathIndex, pathIndex == 0 ? createdUnitsCountPath1 : createdUnitsCountPath2, currentLevelMode);
			
			if (pathIndex == 0)
				createdUnitsCountPath1++;
			else if (pathIndex == 1)
				createdUnitsCountPath2++;
				
			delayTimer.delay = !isNaN(newDelay) ? newDelay : WaveGenerator.getInteravalBetweenEnemyUtinsForPathAt(currentLevel, actualWaveCount, pathIndex, currentLevelMode);
			delayTimer.reset();
			delayTimer.start();
			
			createdUnitsCount++;
			dispatchEvent(new WaveEvent(WaveEvent.DEPLOY_ENEMY, pathIndex));
		}
		
		private function dispatchWaveCompletedEventAfterDelay(event:AdvancedTimerEvent):void
		{
			waveCompletedDelayTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, dispatchWaveCompletedEventAfterDelay);
			dispatchEvent(new WaveEvent(WaveEvent.WAVE_COMPLETED));
		}
		
		private function dispatchLevelCompletedEvent():void
		{
			dispatchEvent(new WaveEvent(WaveEvent.LEVEL_COMPLETED));
		}
		
		public function startWaveImmediately():void
		{
			if (timers.length > 0 && timers.getItemAt(0).running)
			{
				var wasLocked:Boolean = timers.locked;
				timers.locked = true;
				for each (var delayTimer:AdvancedTimer in timers.source)
				{
					delayTimer.reset();
					// emulate timer completion
					delayTimer.dispatchEvent(new AdvancedTimerEvent(AdvancedTimerEvent.TIMER_COMPLETED));
				}
				timers.locked = wasLocked;
			}
		}
		
		public function stopNow():void
		{
			disposeTimers();
			
			waveCompletedDelayTimer.reset();
		}
		
		public function getNextUnitForPathAt(currentMap:Map, pathIndex:int):IWeapon
		{
			var enemy:IWeapon = IWeapon((enemyStacks[pathIndex] as Array).shift());
			
			enemy.x = currentMap.getEnemyEntrancePointForPathAt(pathIndex).x;
			enemy.y = currentMap.getEnemyEntrancePointForPathAt(pathIndex).y;
			enemy.bodyAngle = currentMap.getEnemyInitialRotationForPathAt(pathIndex);
			
			return enemy;
		}
		
		public function getNewEnemyInfosForCurrentWave():Array
		{
			return WaveGenerator.getInfosForNewEnemies(currentLevel, actualWaveCount);
		}
		
		public function currentWaveHasTip():Boolean
		{
			return Boolean(WaveGenerator.getTipIndexForWave(currentLevel, actualWaveCount, currentLevelMode) != -1);
		}
		
		public function getTipIndexForCurrentWave():int
		{
			return WaveGenerator.getTipIndexForWave(currentLevel, actualWaveCount, currentLevelMode);
		}
	
	}

}