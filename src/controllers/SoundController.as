/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import mainPack.GameSettings;
	import nslib.animation.engines.AnimationEngine;
	import nslib.sound.SoundCollectionManager;
	import nslib.sound.SoundLooper;
	import supportClasses.resources.SoundResources;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class SoundController
	{
		public static var instance:SoundController = new SoundController();
		
		//////////////////////////////////////////////////
		
		public var enableSound:Boolean = true;
		
		private var globalSoundTransform:SoundTransform = new SoundTransform();
		
		private var soundHash:Object = {};
		
		private var localAnimationEngine:AnimationEngine = null;
		
		//////////
		
		public function SoundController()
		{
			// assigning this object so it can be changed using GameSettings
			GameSettings.soundController = this;
			
			localAnimationEngine = AnimationEngine.generateIndependentInstance();
			
			createHash();
		}
		
		//////////
		
		private var _musicVolume:Number = 1;
		
		public function get musicVolume():Number
		{
			return _musicVolume;
		}
		
		public function set musicVolume(value:Number):void
		{
			_musicVolume = value;
			
			if (currentLooper)
				currentLooper.volume = value;
		}
		
		//////////
		
		private var _soundVolume:Number = 1;
		
		public function get soundVolume():Number
		{
			return _soundVolume;
		}
		
		public function set soundVolume(value:Number):void
		{
			_soundVolume = value;
			
			if (soundHash[SoundResources.SOUND_HELICOPTER])
				SoundLooper(soundHash[SoundResources.SOUND_HELICOPTER]).volume = value;
		}
		
		/////////
		
		private var _currentTrackName:String = null;
		
		public function get currentTrackName():String
		{
			return _currentTrackName;
		}
		
		//////////
		
		private function createHash():void
		{
			// music
			soundHash[SoundResources.MUSIC_INTRO] = new SoundLooper(SoundResources.musicIntro, 1000);
			soundHash[SoundResources.MUSIC_BEFORE_BATTLE] = new SoundLooper(SoundResources.musicBeforeBattle, 1000);
			soundHash[SoundResources.MUSIC_IN_BATTLE] = new SoundLooper(SoundResources.musicInBattle, 1000);
			soundHash[SoundResources.MUSIC_BOSS] = new SoundLooper(SoundResources.musicBoss, 100);
			soundHash[SoundResources.MUSIC_LEVEL_COMPLETED] = new SoundResources.musicLevelCompleted() as Sound;
			soundHash[SoundResources.MUSIC_MISSION_FAILED] = new SoundResources.musicMissionFailed() as Sound;
			
			// button interaction
			soundHash[SoundResources.SOUND_BUTTON_HOVER] = new SoundCollectionManager(SoundResources.soundButtonHover, 1);
			soundHash[SoundResources.SOUND_BUTTON_TAP] = new SoundCollectionManager(SoundResources.soundButtonTap, 2);
			soundHash[SoundResources.SOUND_BUTTON_POP] = new SoundCollectionManager(SoundResources.soundButtonPop, 2);
			
			// gameplay
			soundHash[SoundResources.SOUND_ENEMY_BROKE_THROUHG] = new SoundResources.soundEnemyBrokeThrough() as Sound;
			soundHash[SoundResources.SOUND_NEW_WAVE_STARTED] = new SoundResources.soundNewWaveStarted() as Sound;
			soundHash[SoundResources.SOUND_FINAL_WAVE_STARTED] = new SoundResources.soundFinalWaveStarted() as Sound;
			soundHash[SoundResources.SOUND_SUPPORT_READY] = new SoundResources.soundSupportReady() as Sound;
			soundHash[SoundResources.SOUND_WINDOW_SLIDE] = new SoundResources.soundWindowSlide() as Sound;
			soundHash[SoundResources.SOUND_PAPER_TIP_OPEN] = new SoundResources.soundPaperTipOpen() as Sound;
			soundHash[SoundResources.SOUND_PAPER_TIP_PAGE_TURN] = new SoundResources.soundPaperTipPageTurn() as Sound;
			soundHash[SoundResources.SOUND_PAPER_TIP_CLOSE] = new SoundResources.soundPaperTipClose() as Sound;
			soundHash[SoundResources.SOUND_THUNDER] = new SoundResources.soundThunder() as Sound;
			
			// shooting
			soundHash[SoundResources.SOUND_CANNON_BALL_LAUNCHED] = new SoundCollectionManager(SoundResources.soundCannonBallLaunch, 2);
			soundHash[SoundResources.SOUND_CANNON_SHOOT_01] = new SoundCollectionManager(SoundResources.soundCannonShoot01, 2);
			soundHash[SoundResources.SOUND_CANNON_SHOOT_02] = new SoundCollectionManager(SoundResources.soundCannonShoot02, 2);
			soundHash[SoundResources.SOUND_EXPLOSION_01] = new SoundCollectionManager(SoundResources.soundExplosion01, 2);
			soundHash[SoundResources.SOUND_EXPLOSION_02] = new SoundCollectionManager(SoundResources.soundExplosion02, 2);
			soundHash[SoundResources.SOUND_GROUND_HIT] = new SoundCollectionManager(SoundResources.soundGroundHit, 2);
			//soundHash[SoundResources.SOUND_MACHINE_GUN_FAST_SEQUENCE] = new SoundCollectionManager(SoundResources.soundMachineGunFastSequence, 1);
			soundHash[SoundResources.SOUND_MACHINE_GUN_AVERAGE_SEQUENCE] = new SoundCollectionManager(SoundResources.soundMachineGunAverageSequence, 1);
			soundHash[SoundResources.SOUND_MACHINE_GUN_SLOW_SEQUENCE] = new SoundCollectionManager(SoundResources.soundMachineGunSlowSequence, 1);
			soundHash[SoundResources.SOUND_MISSILE_LAUNCH] = new SoundCollectionManager(SoundResources.soundMissileLauch, 2);
			soundHash[SoundResources.SOUND_SHOCK_SINGLE_01] = new SoundCollectionManager(SoundResources.soundShockSingle01, 2);
			//soundHash[SoundResources.SOUND_SHOCK_SINGLE_02] = new SoundCollectionManager(SoundResources.soundShockSingle02, 2);
			soundHash[SoundResources.SOUND_WEAPON_DAMAGING_FROM_BULLET] = new SoundCollectionManager(SoundResources.soundWeaponDamagingFromBullet, 2);
			soundHash[SoundResources.SOUND_WEAPON_DAMAGING_FROM_CANNON] = new SoundCollectionManager(SoundResources.soundWeaponDamagingFromCannon, 2);
			
			// weapon actions
			soundHash[SoundResources.SOUND_ACTIVE_ENEMY_SELECTION] = new SoundResources.soundActiveEnemySelection() as Sound;
			soundHash[SoundResources.SOUND_AIRCRAFT_LOCATED] = new SoundResources.soundActiveEnemySelection() as Sound;
			//soundHash[SoundResources.SOUND_PLANE_FLYING_IN_01] = new SoundResources.soundPlaneFlyingIn01() as Sound;
			//soundHash[SoundResources.SOUND_PLANE_FLYING_IN_02] = new SoundResources.soundPlaneFlyingIn02() as Sound;
			soundHash[SoundResources.SOUND_WEAPON_PLACING] = new SoundResources.soundWeaponPlacing() as Sound;
			soundHash[SoundResources.SOUND_WEAPON_REPAIRING] = new SoundResources.soundWeaponRepairing() as Sound;
			soundHash[SoundResources.SOUND_WEAPON_SELLING] = new SoundResources.soundWeaponSelling() as Sound;
			soundHash[SoundResources.SOUND_WEAPON_UPGRADING] = new SoundResources.soundWeaponUpgrading() as Sound;
			
			soundHash[SoundResources.SOUND_ELECTRIC_BALL_01] = new SoundCollectionManager(SoundResources.soundElectricBall01, 1);
			//soundHash[SoundResources.SOUND_ELECTRIC_BALL_02] = new SoundCollectionManager(SoundResources.soundElectricBall02, 1);
			soundHash[SoundResources.SOUND_HELICOPTER] = new SoundLooper(SoundResources.soundHelicopter, 0);
			soundHash[SoundResources.SOUND_ROBOT_WALKING_01] = new SoundCollectionManager(SoundResources.soundRobotWalking01, 4);
			soundHash[SoundResources.SOUND_ROBOT_WALKING_02] = new SoundCollectionManager(SoundResources.soundRobotWalking02, 2);
			soundHash[SoundResources.SOUND_ROBOT_WALKING_03] = new SoundCollectionManager(SoundResources.soundRobotWalking03, 2);
			soundHash[SoundResources.SOUND_WEAPON_ACTIVATION_01] = new SoundCollectionManager(SoundResources.soundWeaponActivation01, 2);
			soundHash[SoundResources.SOUND_WEAPON_ACTIVATION_02] = new SoundCollectionManager(SoundResources.soundWeaponActivation02, 2);
			soundHash[SoundResources.SOUND_WEAPON_ACTIVATION_03] = new SoundCollectionManager(SoundResources.soundWeaponActivation03, 2);
			soundHash[SoundResources.SOUND_WEAPON_FREEZING] = new SoundCollectionManager(SoundResources.soundWeaponFreezing, 2);
		}
		
		public function playSound(soundName:String, relativeVolume:Number = 1, delay:Number = 0):void
		{
			if (!enableSound)
				return;
			
			if (delay == 0)
				doPlaySound(soundName, relativeVolume);
			else
				localAnimationEngine.executeFunction(doPlaySound, [soundName, relativeVolume], localAnimationEngine.currentTime + delay);
		}
		
		private function doPlaySound(soundName:String, relativeVolume:Number = 1):void
		{
			var finalVolume:Number = soundVolume * relativeVolume;
			
			if (finalVolume < 0 || finalVolume > 1)
			{
				GameTracker.api.customMsg(TrackingMessages.ERROR + ":" + finalVolume + " value is out of range. SoundController: 170");
				finalVolume = Math.max(0, Math.min(1, finalVolume));
			}
			
			if (soundHash[soundName] is SoundCollectionManager)
			{
				SoundCollectionManager(soundHash[soundName]).requestPlaySound(finalVolume);
			}
			else
			{
				var soundChannel:SoundChannel = Sound(soundHash[soundName]).play();
				
				// sound channel may not be available
				if (soundChannel)
				{
					globalSoundTransform.volume = finalVolume;
					soundChannel.soundTransform = globalSoundTransform;
				}
			}
		}
		
		private var currentLooper:SoundLooper = null;
		
		public function playMusicTrack(trackName:String, mergeDuration:Number = 1000):void
		{
			if (!enableSound)
				return;
			
			if (currentLooper)
			{
				if (_currentTrackName == trackName)
					currentLooper.stopImmediately();
				else
					currentLooper.stopWhileFadingOut(true, mergeDuration);
			}
			
			_currentTrackName = trackName;
			
			if (soundHash[trackName] is SoundLooper)
			{
				currentLooper = SoundLooper(soundHash[trackName]);
				currentLooper.play(musicVolume);
			}
			else
			{
				var soundChannel:SoundChannel = Sound(soundHash[trackName]).play();
				
				// channel may not be available
				if (soundChannel)
				{
					globalSoundTransform.volume = musicVolume;
					soundChannel.soundTransform = globalSoundTransform;
				}
			}
		}
		
		/////////////
		
		private var helicopterCount:int = 0;
		
		public function notifyHelicopterAddedToStage():void
		{
			if (helicopterCount == 0)
			{
				helicopterCount++;
				SoundLooper(soundHash[SoundResources.SOUND_HELICOPTER]).play(soundVolume);
			}
		}
		
		public function notifyHelicopterRemovedFromStage():void
		{
			if (--helicopterCount == 0)
				SoundLooper(soundHash[SoundResources.SOUND_HELICOPTER]).stopImmediately();
		}
	}

}