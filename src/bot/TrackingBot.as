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
	import mainPack.GameSettings;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.core.Globals;
	import panels.settings.LabeledSliderContainer;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TrackingBot
	{
		private static var trakingDataParser:TrackingDataParser = new TrackingDataParser();
		private static var balanceController:WeaponBalanceController = new WeaponBalanceController();
		private static var geometryController:GeometryController = new GeometryController();
		private static var botUIPanel:GameBotUIPanel = new GameBotUIPanel();
		
		//////////////
		
		public static const INITIAL_SPEED_MODE_ACCELERATION:int = 49;
		public static const MAX_SPEED_MODE_ACCELERATION:int = 99;
		public static const SUPER_SPEED_MODE_ACCELERATION:int = 2000;
		private static const INITAL_UI_ACCELERATION:int = 3;
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
		private static var currentTime:int = 0;
		private static var pendingAction:TrackingActionInfo = null;
		private static var accelerationFactor:Number = 1;
		
		public static function startBotForCurrentLevel(showInUI:Boolean = true, callback:Function = null):void
		{
			_isPlaying = true;
			currentTime = 0;
			pendingAction = null;
			accelerationFactor = 1;
			
			callBackOnStop = callback;
			balanceController.reset();
			geometryController.balanceController = balanceController;
			geometryController.reset();
			GameBot.resetLevel();
			GameSettings.enableAutopause = false;
			
			trakingDataParser.addEventListener(TrackingDataParser.DATA_PARSED, trakingDataParser_dataParsedHandler);
			trakingDataParser.parseDataFileForLevel(GameBot.getCurrentLevelIndex());
			
			if (showInUI)
			{
				lockScreen();
				GameBot.accelerateGame(INITAL_UI_ACCELERATION);
				SoundController.instance.enableSound = false;
				wasStartedInUIMode = true;
			}
			else
			{
				SoundController.instance.enableSound = false;
				wasStartedInUIMode = false;
			}
		}
		
		private static function trakingDataParser_dataParsedHandler(event:Event):void
		{
			trakingDataParser.removeEventListener(TrackingDataParser.DATA_PARSED, trakingDataParser_dataParsedHandler);
			
			DeltaTime.globalDeltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
		}
		
		public static function stopBotForCurrentLevel():void
		{
			DeltaTime.globalDeltaTimeCounter.removeEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
			
			if (wasStartedInUIMode)
			{
				SoundController.instance.enableSound = true;
				unlockScreen();
			}
			else
			{
				SoundController.instance.enableSound = true;
			}
			
			_isPlaying = false;
		}
		
		private static function frameListener(event:DeltaTimeEvent):void
		{
			/*
			currentTime += event.lastDeltaTime / accelerationFactor;
			
			//for (var i:int = 0; i < 10; i++)
			//	tryBuildItems();
			if (pendingAction && pendingAction.time > currentTime)
				return;
			else if (pendingAction)
				performAction(pendingAction);
			
			//GameBot.startGame();
			while (true)
			{
				pendingAction = trakingDataParser.getNextDataObject();
				
				if (!pendingAction || pendingAction.time > currentTime)
					return;
				else
					performAction(pendingAction);
			}*/
		}
		
		/*private static function performAction(action:TrackingActionInfo):void
		{
			if (!action)
				return;
			
			var weapon:IWeapon = null;
			var x:Number;
			var y:Number;
			
			switch (action.messageBase)
			{
				case TrackingMessages.LEVEL_PAUSED: 
					//GameBot.pauseGame();
					break;
				case TrackingMessages.LEVEL_RESUMED: 
					//GameBot.resumeGame();
					break;
				case TrackingMessages.LEVEL_ACCELERATION_ON: 
					accelerationFactor = action.messageParameters[0] ? action.messageParameters[0] : 1;
					break;
				case TrackingMessages.LEVEL_ACCELERATION_OFF: 
					accelerationFactor = 1;
					break;
				case TrackingMessages.WAVE_STARTED_ITSELF: 
					GameBot.startWaveEarly();
					break;
				case TrackingMessages.WAVE_CALLED_EARLIER: 
					GameBot.startWaveEarly();
					break;
				case TrackingMessages.TOWER_PLACED: 
					var affordableTowers:Array = GameBot.getAffordableTowers();
					var id:String = action.messageParameters[0].split(" ")[0];
					var level:int = action.messageParameters[0].split(" ")[1];
					x = action.messageParameters[1];
					y = action.messageParameters[2];
					
					for each (var item:*in affordableTowers)
						if (item is Weapon)
							if (item.currentInfo.weaponId == id && item.currentInfo.level == level)
							{
								GameBot.takeItemFromTheMenu(item);
								GameBot.placeTowerAt(item, x, y);
								break;
							}
					
					break;
				case TrackingMessages.TOWER_UPGRADED: 
					x = action.messageParameters[1];
					y = action.messageParameters[2];
					weapon = getTowerFromCoordinates(x, y);
					
					if (weapon)
						GameBot.upgradeTower(weapon);
					
					break;
				case TrackingMessages.TOWER_SOLD: 
					x = action.messageParameters[1];
					y = action.messageParameters[2];
					weapon = getTowerFromCoordinates(x, y);
					
					if (weapon)
						GameBot.sellTower(weapon);
					
					break;
				case TrackingMessages.TOWER_REPAIRED: 
					x = action.messageParameters[1];
					y = action.messageParameters[2];
					weapon = getTowerFromCoordinates(x, y);
					
					if (weapon)
						GameBot.repairTower(weapon);
					
					break;
				case TrackingMessages.BOMB_DROPPED: 
					x = action.messageParameters[0];
					y = action.messageParameters[1];
					GameBot.dropBombAt(int(x), int(y));
					
					break;
				
				case TrackingMessages.AIR_SUPPORT_CALLED: 
					x = action.messageParameters[0];
					y = action.messageParameters[1];
					//GameBot.dispatchAirSupportAt(int(x), int(y));
					GameBot.dispatchAirSupportAt(Globals.stage.stageWidth / 2, Globals.stage.stageHeight / 2);
					
					break;
			}
		}
		
		private static function getTowerFromCoordinates(x:Number, y:Number):IWeapon
		{
			for each (var weapon:IWeapon in WeaponController.instance.userUnits.source)
				if (weapon is Weapon && int(weapon.x) == int(x) && int(weapon.y) == int(y))
					return weapon;
			
			return null;
		}*/
		
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