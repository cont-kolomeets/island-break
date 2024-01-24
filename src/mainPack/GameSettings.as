/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package mainPack
{
	import controllers.SoundController;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.net.SharedObject;
	import nslib.utils.ArrayList;
	import supportClasses.ISettingsObserver;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * GameSettingsInfo contains information about game settings, such
	 * as sound level, music level, quality level and other.
	 */
	public class GameSettings
	{
		//--------------------------------------------------------------------------
		//
		//  Methods: observers notification
		//
		//--------------------------------------------------------------------------
		
		private static var observers:ArrayList = new ArrayList();
		
		public static function registerObserver(observer:ISettingsObserver):void
		{
			if (!observers.contains(observer))
				observers.addItem(observer);
		}
		
		public static function unregisterObserver(observer:ISettingsObserver):void
		{
			observers.removeItem(observer);
		}
		
		private static function notifyObservers(propertyName:String):void
		{
			for each (var observer:ISettingsObserver in observers.source)
				observer.notifySettingsChanged(propertyName);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: objects manipulated by settings
		//
		//--------------------------------------------------------------------------
		
		private static var _stage:Stage = null;
		
		static public function get stage():Stage
		{
			return _stage;
		}
		
		static public function set stage(value:Stage):void
		{
			_stage = value;
			
			updateStage();
		}
		
		private static function updateStage():void
		{
			if (stage)
				stage.quality = qualityLevel;
		}
		
		//////////
		
		private static var _soundController:SoundController = null;
		
		static public function get soundController():SoundController
		{
			return _soundController;
		}
		
		static public function set soundController(value:SoundController):void
		{
			_soundController = value;
			
			updateSoundController();
		}
		
		private static function updateSoundController():void
		{
			if (soundController)
			{
				soundController.musicVolume = musicOn ? musicLevel : 0;
				soundController.soundVolume = soundOn ? soundLevel : 0;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: settings
		//
		//--------------------------------------------------------------------------
		
		//////////////
		
		private static var _musicLevel:Number = 0.5;
		
		static public function get musicLevel():Number
		{
			return _musicLevel;
		}
		
		static public function set musicLevel(value:Number):void
		{
			_musicLevel = value;
			
			updateSoundController();
			notifyObservers("musicLevel");
		}
		
		///////////////
		
		private static var _soundLevel:Number = 0.5;
		
		static public function get soundLevel():Number
		{
			return _soundLevel;
		}
		
		static public function set soundLevel(value:Number):void
		{
			_soundLevel = value;
			
			updateSoundController();
			notifyObservers("soundLevel");
		}
		
		////////////////
		
		private static var _musicOn:Boolean = true;
		
		static public function get musicOn():Boolean
		{
			return _musicOn;
		}
		
		static public function set musicOn(value:Boolean):void
		{
			_musicOn = value;
			
			updateSoundController();
			notifyObservers("musicOn");
		}
		
		////////////////
		
		private static var _soundOn:Boolean = true;
		
		static public function get soundOn():Boolean
		{
			return _soundOn;
		}
		
		static public function set soundOn(value:Boolean):void
		{
			_soundOn = value;
			
			updateSoundController();
			notifyObservers("soundOn");
		}
		
		////////////////
		
		private static var _enableTooltips:Boolean = true;
		
		static public function get enableTooltips():Boolean
		{
			return _enableTooltips;
		}
		
		static public function set enableTooltips(value:Boolean):void
		{
			_enableTooltips = value;
			
			notifyObservers("enableTooltips");
		}
		
		////////////////
		
		private static var _enableAutopause:Boolean = true;
		
		static public function get enableAutopause():Boolean
		{
			return _enableAutopause;
		}
		
		static public function set enableAutopause(value:Boolean):void
		{
			_enableAutopause = value;
			
			notifyObservers("enableAutopause");
		}
		
		////////////////
		
		private static var _qualityLevel:String = StageQuality.BEST;
		
		static public function get qualityLevel():String
		{
			return _qualityLevel;
		}
		
		static public function set qualityLevel(value:String):void
		{
			_qualityLevel = value;
			
			updateStage();
			notifyObservers("qualityLevel");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: working with shared objects (reading/writing)
		//
		//--------------------------------------------------------------------------
		
		private static var sharedObject:SharedObject = SharedObject.getLocal("islandDefence.gameSettings");
		
		// this method should be called on application start. It loads settings from sharedObject if available.
		public static function intialize():void
		{
			readSharedObject();
		}
		
		public static function saveChagnes():void
		{
			updateSharedObject();
		}
		
		private static function readSharedObject():void
		{
			if (sharedObject.data["musicOn"] != undefined)
				_musicOn = Boolean(sharedObject.data["musicOn"]);
			
			if (sharedObject.data["soundOn"] != undefined)
				_soundOn = Boolean(sharedObject.data["soundOn"]);
			
			if (sharedObject.data["enableTooltips"] != undefined)
				_enableTooltips = Boolean(sharedObject.data["enableTooltips"]);
				
			if (sharedObject.data["enableAutopause"] != undefined)
				_enableAutopause = Boolean(sharedObject.data["enableAutopause"]);
			
			if (sharedObject.data["musicLevel"] != undefined)
				_musicLevel = Number(sharedObject.data["musicLevel"]);
			
			if (sharedObject.data["soundLevel"] != undefined)
				_soundLevel = Number(sharedObject.data["soundLevel"]);
			
			if (sharedObject.data["qualityLevel"] != undefined)
				_qualityLevel = String(sharedObject.data["qualityLevel"]);
		}
		
		private static function updateSharedObject():void
		{
			sharedObject.data["musicOn"] = musicOn;
			sharedObject.data["soundOn"] = soundOn;
			sharedObject.data["enableTooltips"] = enableTooltips;
			sharedObject.data["enableAutopause"] = enableAutopause;
			sharedObject.data["musicLevel"] = musicLevel;
			sharedObject.data["soundLevel"] = soundLevel;
			sharedObject.data["qualityLevel"] = qualityLevel;
		}
	}

}