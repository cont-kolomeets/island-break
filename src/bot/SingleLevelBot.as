/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package bot
{
	import bot.ui.GameBotUIPanel;
	import controllers.SoundController;
	import flash.events.Event;
	import flash.geom.Point;
	import mainPack.GameSettings;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.core.Globals;
	import panels.settings.LabeledSliderContainer;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	import weapons.enemy.EnemyEnergyBall;
	import weapons.enemy.EnemyInvisibleTank;
	import weapons.enemy.EnemyRepairTank;
	import weapons.objects.Obstacle;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class SingleLevelBot
	{
		private static var balanceController:WeaponBalanceController = new WeaponBalanceController();
		private static var geometryController:GeometryController = new GeometryController();
		private static var botUIPanel:GameBotUIPanel = new GameBotUIPanel();
		
		//////////////
		
		public static const INITIAL_SPEED_MODE_ACCELERATION:int = 49;
		public static const MAX_SPEED_MODE_ACCELERATION:int = 99;
		public static const SUPER_SPEED_MODE_ACCELERATION:int = 2000;
		private static const INITAL_UI_ACCELERATION:int = 10;
		private static const MAX_UI_ACCELERATION:int = 49;
		
		//public static var speedModeAcceleration:int = INITIAL_SPEED_MODE_ACCELERATION;
		
		private static var _isPlaying:Boolean = false;
		
		public static function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		private static var soundVolumeMemo:Number = 0;
		private static var wasStartedInUIMode:Boolean = false;
		private static var callBackOnStop:Function = null;
		
		public static function startBotForCurrentLevel(showInUI:Boolean = true, callback:Function = null):void
		{
			_isPlaying = true;
			
			callBackOnStop = callback;
			balanceController.reset();
			geometryController.balanceController = balanceController;
			geometryController.reset();
			GameBot.resetLevel();
			
			for (var i:int = 0; i < 10; i++)
				tryBuildItems();
			
			GameBot.startGame();
			GameSettings.enableAutopause = false;
			
			if (showInUI)
			{
				lockScreen();
				GameBot.accelerateGame(INITAL_UI_ACCELERATION);
				//soundVolumeMemo = SoundController.instance.soundVolume;
				//SoundController.instance.soundVolume = 0;
				SoundController.instance.enableSound = false;
				wasStartedInUIMode = true;
			}
			else
			{
				//GameBot.accelerateGame(speedModeAcceleration);
				SoundController.instance.enableSound = false;
				wasStartedInUIMode = false;
			}
			
			DeltaTime.globalDeltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
		}
		
		public static function stopBotForCurrentLevel():void
		{
			DeltaTime.globalDeltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
			
			if (wasStartedInUIMode)
			{
				//SoundController.instance.soundVolume = soundVolumeMemo;
				SoundController.instance.enableSound = true;
				unlockScreen();
			}
			else
			{
				SoundController.instance.enableSound = true;
			}
			
			if (callBackOnStop != null)
				callBackOnStop();
				
			_isPlaying = false;
		}
		
		private static function tryBuildItems():void
		{
			var counter:int = 0;
			
			while (canPlaceWeapons())
			{
				if (counter++ > 10)
					break;
				
				if (geometryController.upgradeSomeUnitIfNecessary())
					return;
				
				if (geometryController.isPendingUpgrade())
					return;
				
				var item:Weapon = balanceController.recommendNextItemToPlace(GameBot.getAffordableTowers());
				
				if (item)
				{
					GameBot.takeItemFromTheMenu(item);
					
					var point:Point = geometryController.recommentPointToPlaceItemAt(item);
					
					if (point)
					{
						GameBot.placeTowerAt(item, point.x, point.y);
						balanceController.notifyItemPlaced(item);
						geometryController.notifyItemPlaced();
					}
				}
			}
		}
		
		private static function canPlaceWeapons():Boolean
		{
			var items:Array = GameBot.getAffordableTowers();
			
			var onlyObstacle:Boolean = items.length == 1 && items[0] is Obstacle;
			
			return items.length > 0 && !onlyObstacle;
		}
		
		public static function notifyUserWeaponRemoved(item:Weapon):void
		{
			balanceController.notifyItemRemoved(item);
		}
		
		public function notifyWaveStarted():void
		{
		
		}
		
		private static var botActionDelay:Number = 0;
		private static var actionIndex:int = 0;
		
		private static function frameListener(event:DeltaTimeEvent):void
		{
			botActionDelay += event.lastDeltaTime;
			
			if (botActionDelay >= 3000)
			{
				botActionDelay = 0;
				
				switch (actionIndex)
				{
					case 0: 
						tryBuildItems();
						break;
					case 1: 
						repairItems();
						break;
					case 2: 
						tryCallSupport();
						break;
					case 3: 
						trySetActiveEnemy();
						break;
				}
				
				if (++actionIndex > 3)
					actionIndex = 0;
			}
		}
		
		private static const ALLOWED_REPAIR_PERCENTAGE:Number = 0.3;
		
		private static function repairItems():void
		{
			var numFixedItems:int = 0;
			var numAllowedItemsToFix:int = balanceController.placedItems.length * ALLOWED_REPAIR_PERCENTAGE;
			
			for each (var item:Weapon in balanceController.placedItems.source)
				if (item.getDamagePercentage() > 0.5)
				{
					GameBot.repairTower(item);
					if (++numFixedItems == numAllowedItemsToFix)
						return;
				}
		}
		
		private static function tryCallSupport():void
		{
			GameBot.dispatchAirSupportAt(Globals.stage.stageWidth / 2, Globals.stage.stageHeight / 2);
			
			if (GameBot.canDropBomb())
			{
				// find the strongest unit
				var enemy:IWeapon = findStrongestGroundEnemyUnit();
				
				if (enemy)
					GameBot.dropBombAt(enemy.x, enemy.y);
			}
		}
		
		private static function findStrongestGroundEnemyUnit():IWeapon
		{
			var strongestEnemy:IWeapon = null;
			
			for each (var enemy:IWeapon in GameBot.getEnemyUnits())
				if (enemy is Weapon && !(enemy is EnemyEnergyBall))
				{
					// these two have higher priority
					if (enemy is EnemyInvisibleTank && enemy is EnemyRepairTank)
					{
						strongestEnemy = enemy;
						break;
					}
					
					if (!strongestEnemy)
						strongestEnemy = enemy;
					else if (enemy.currentInfo.armor > strongestEnemy.currentInfo.armor)
						strongestEnemy = enemy;
				}
			
			return strongestEnemy;
		}
		
		private static function trySetActiveEnemy():void
		{
			// priority:
			// 1. inivisible tank 1st level
			// 2. repair tank
			var enemies:Array = GameBot.getEnemies();
			var activeEnemy:IWeapon = null;
			
			for each (var item:IWeapon in enemies)
				if (item is EnemyInvisibleTank && EnemyInvisibleTank(item).currentInfo.level == 1)
				{
					activeEnemy = item;
					break;
				}
			
			if (!activeEnemy)
				for each (item in enemies)
					if (item is EnemyRepairTank)
					{
						activeEnemy = item;
						break;
					}
			
			if (activeEnemy)
				GameBot.setActiveEnemy(activeEnemy);
		}
		
		/////////////
		
		private static function lockScreen():void
		{
			Globals.stage.addChild(botUIPanel);
			
			botUIPanel.speedSlider.labelFunction = function(value:Number):String
			{
				return "" + int(1 + value * MAX_UI_ACCELERATION);
			}
			
			botUIPanel.speedSlider.sliderValue = INITAL_UI_ACCELERATION / MAX_UI_ACCELERATION;
			
			botUIPanel.speedSlider.addEventListener(LabeledSliderContainer.PARAMETERS_CHANGED, speedSlider_valueChangedHandler);
		}
		
		private static function unlockScreen():void
		{
			if (Globals.stage.contains(botUIPanel))
				Globals.stage.removeChild(botUIPanel);
			
			botUIPanel.speedSlider.removeEventListener(LabeledSliderContainer.PARAMETERS_CHANGED, speedSlider_valueChangedHandler);
		}
		
		private static function speedSlider_valueChangedHandler(event:Event):void
		{
			GameBot.accelerateGame(1 + int(botUIPanel.speedSlider.sliderValue * MAX_UI_ACCELERATION));
		}
	}

}