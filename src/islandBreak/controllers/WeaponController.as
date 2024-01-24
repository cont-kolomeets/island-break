/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package islandBreak.controllers
{
	import bot.GameBot;
	import constants.WeaponContants;
	import events.TeleportEvent;
	import events.WeaponEvent;
	import flash.display.BitmapData;
	import flash.events.Event;
	import islandBreak.dynamicMap.DynamicTracableLayer;
	import islandBreak.mainPack.DifficultyConfig;
	import nslib.AIPack.pathFollowing.TrafficController;
	import nslib.AIPack.pathFollowing.TrajectoryFollower;
	import nslib.animation.DeltaTime;
	import nslib.animation.events.DeltaTimeEvent;
	import nslib.effects.events.TracableObjectEvent;
	import nslib.effects.explosions.BurnPit;
	import nslib.effects.traceEffects.DynamicTraceController;
	import nslib.effects.traceEffects.TracableObject;
	import nslib.effects.traceEffects.TraceController;
	import nslib.utils.ArrayList;
	import nslib.utils.ObjectsPoolUtil;
	import islandBreak.panels.GameStage;
	import supportClasses.BulletType;
	import supportClasses.resources.SoundResources;
	import supportClasses.WeaponType;
	import weapons.ammo.bullets.AbstractBullet;
	import weapons.ammo.bullets.CannonBullet;
	import weapons.ammo.bullets.ElectricBullet;
	import weapons.ammo.bullets.IBullet;
	import weapons.ammo.bullets.MachineGunBullet;
	import weapons.ammo.cannonBalls.CannonBall;
	import weapons.ammo.explosions.DevastatingSequencedExplosion;
	import weapons.ammo.explosions.SequencedExplosion;
	import weapons.ammo.lightnings.SequencedLightning;
	import weapons.ammo.missiles.Missile;
	import weapons.base.AirCraft;
	import weapons.base.IWeapon;
	import weapons.base.supportClasses.WeaponUtil;
	import weapons.base.supportClasses.WeaponRefineUtil;
	import weapons.base.Weapon;
	import weapons.enemy.EnemyEnergyBall;
	import weapons.enemy.EnemyHelicopter;
	import weapons.enemy.EnemyInvisibleTank;
	import weapons.enemy.EnemyMobileVehicle;
	import weapons.enemy.EnemyRepairTank;
	import weapons.objects.Bridge;
	import weapons.objects.Teleport;
	import weapons.repairCenter.RepairCenter;
	import weapons.user.UserElectricTower;
	import weapons.user.UserMachineGunTower;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponController
	{
		public static var instance:WeaponController = null;
		
		public static var traceController:DynamicTraceController;
		
		public static var gameStage:GameStage;
		
		private static var bullets:ArrayList = new ArrayList();
		
		public static function launchBullet(bulletClass:Class, bulletParams:Object, goalX:Number, goalY:Number, flyDuration:Number):void
		{
			var bullet:TracableObject = traceController.launchTracableObject(bulletClass, bulletParams, goalX, goalY, flyDuration, BurnPit, {"radius": bulletParams.radius});
			bullets.addItem(bullet);
			bullet.addEventListener(TracableObjectEvent.READY_TO_BE_REMOVED, bullet_removeHandler);
		}
		
		private static function bullet_removeHandler(event:TracableObjectEvent):void
		{
			var bullet:AbstractBullet = event.currentTarget as AbstractBullet;
			bullet.removeEventListener(TracableObjectEvent.READY_TO_BE_REMOVED, bullet_removeHandler);
			bullets.removeItem(bullet);
		}
		
		public static function launchMissile(params:Object, missileHitPowerMultiplier:Number = 1):void
		{
			var missile:Missile = ObjectsPoolUtil.takeObject(Missile, params);
			
			gameStage.aircraftDynamicLayer.registerItem(missile);
			missile.activate();
			
			if (missile.hitPower != WeaponContants.DEFAULT_MISSILE_HIT_POWER)
				throw new Error("New taken missle hitPower is not default!");
			
			missile.hitPower = missile.hitPower * missileHitPowerMultiplier;
			
			missile.addEventListener(WeaponEvent.TARGET_REACHED, missile_targetReachedHandler);
			missile.addEventListener(WeaponEvent.DESTROYED, missile_destroyedHandler);
			
			SoundController.instance.playSound(SoundResources.SOUND_MISSILE_LAUNCH, 0.5);
		}
		
		private static function missile_targetReachedHandler(event:WeaponEvent):void
		{
			var missile:Missile = event.currentTarget as Missile;
			var hitFactor:Number = 1;
			
			//if (missile.hitObject.currentInfo.weaponType == WeaponType.ENEMY && DifficultyConfig.currentBonusInfo.dealingDoubleDamageProbabilityForMissiles > 0)
			//	hitFactor = (Math.random() > (1 - DifficultyConfig.currentBonusInfo.dealingDoubleDamageProbabilityForMissiles)) ? 2 : 1;
			
			missile.hitObject.applyDamage(missile.hitPower * hitFactor);
			deactivateMissile(missile);
		}
		
		private static function missile_destroyedHandler(event:WeaponEvent):void
		{
			var missile:Missile = event.currentTarget as Missile;
			deactivateMissile(missile);
		}
		
		public static function deactivateMissile(missile:Missile, showExplosion:Boolean = true):void
		{
			missile.removeEventListener(WeaponEvent.TARGET_REACHED, missile_targetReachedHandler);
			missile.removeEventListener(WeaponEvent.DESTROYED, missile_destroyedHandler);
			
			gameStage.aircraftDynamicLayer.unregisterItem(missile);
			
			missile.deactivate();
			
			if (showExplosion)
				putNormalExplosion(missile.x, missile.y, 0.3);
			
			ObjectsPoolUtil.returnObject(missile);
		}
		
		public static function putImageForFadingAt(x:int, y:int, bitmapData:BitmapData):void
		{
			if (GameBot.supressUI)
				return;
			
			traceController.putImageForFadingAt(x, y, bitmapData);
		}
		
		public static function putLightning(x1:Number, y1:Number, x2:Number, y2:Number, color:int = -1):void
		{
			if (GameBot.supressUI)
				return;
			
			var lightning:SequencedLightning = new SequencedLightning(gameStage.groundItemLayer);
			
			if (color == -1)
				color = SequencedLightning.COLOR_BLUE;
			
			lightning.drawFrequentLightning(x1, y1, x2, y2, color);
		}
		
		public static function registerFlyingBullet(bullet:AbstractBullet):void
		{
			bullets.addItem(bullet);
			bullet.addEventListener(TracableObjectEvent.READY_TO_BE_REMOVED, bullet_removeHandler);
		}
		
		////////// explosions
		
		private static var runningExplosions:ArrayList = new ArrayList();
		
		public static function putNormalExplosion(x:int, y:int, soundVolume:Number = 0.8):void
		{
			if (GameBot.supressUI)
				return;
			
			var explosion:SequencedExplosion = new SequencedExplosion(gameStage.groundItemLayer, traceController);
			explosion.addEventListener(SequencedExplosion.EXPLOSION_FINISHED, explosion_finishedHandler);
			explosion.explode(x, y);
			runningExplosions.addItem(explosion);
			
			SoundController.instance.playSound(SoundResources.SOUND_EXPLOSION_01, soundVolume);
		}
		
		public static function putDevastatingExplosion(x:int, y:int, strength:int = 5):void
		{
			var explosion:DevastatingSequencedExplosion = new DevastatingSequencedExplosion(gameStage.groundItemLayer, traceController);
			explosion.addEventListener(SequencedExplosion.EXPLOSION_FINISHED, explosion_finishedHandler);
			explosion.explode(x, y, strength);
			runningExplosions.addItem(explosion);
			
			SoundController.instance.playSound(SoundResources.SOUND_EXPLOSION_02, 0.5);
		}
		
		private static function explosion_finishedHandler(event:Event):void
		{
			var explosion:SequencedExplosion = event.currentTarget as SequencedExplosion;
			runningExplosions.removeItem(explosion);
		}
		
		private static function clearAllExplosions():void
		{
			var wasLocked:Boolean = runningExplosions.locked;
			runningExplosions.locked = true;
			
			for each (var explosion:SequencedExplosion in runningExplosions.source)
			{
				explosion.removeEventListener(SequencedExplosion.EXPLOSION_FINISHED, explosion_finishedHandler);
				explosion.stopImmediately();
			}
			
			runningExplosions.locked = wasLocked;
			runningExplosions.removeAll();
		}
		
		public static function launchCannonBall(fromX:Number, fromY:Number, toX:Number, toY:Number, duration:Number, params:Object):void
		{
			params.container = gameStage.groundItemLayer;
			
			var cannonBall:CannonBall = ObjectsPoolUtil.takeObject(CannonBall, params);
			
			cannonBall.addEventListener(CannonBall.LAUNCH_COMPLETED, cannonBall_launchCompletedHandler);
			cannonBall.launchBall(fromX, fromY, toX, toY, duration);
			
			SoundController.instance.playSound(SoundResources.SOUND_CANNON_BALL_LAUNCHED);
		}
		
		private static function cannonBall_launchCompletedHandler(event:Event):void
		{
			var cannonBall:CannonBall = event.currentTarget as CannonBall;
			cannonBall.removeEventListener(CannonBall.LAUNCH_COMPLETED, cannonBall_launchCompletedHandler);
			
			instance.checkBullet(cannonBall);
			
			ObjectsPoolUtil.returnObject(cannonBall);
		}
		
		///////////////////////////////////////////////////
		
		public var userUnits:ArrayList = new ArrayList();
		
		private var userUnitsToAdd:Array = [];
		
		private var userUnitsToRemove:Array = [];
		
		public var enemies:ArrayList = new ArrayList();
		
		private var enemiesToAdd:Array = [];
		
		private var enemiesToRemove:Array = [];
		
		public var teleports:ArrayList = new ArrayList();
		
		public var bridges:ArrayList = new ArrayList();
		
		private var activeEnemies:ArrayList = new ArrayList();
		
		private var trafficController:TrafficController;
		
		//////////////////////////////////////////////////
		
		public function WeaponController(gameStage:GameStage)
		{
			instance = this;
			WeaponController.gameStage = gameStage;
			traceController = new DynamicTraceController(gameStage);
			trafficController = new TrafficController();
			trafficController.allowOverlap = false;
			trafficController.startTrafficControl();
			
			DeltaTime.globalDeltaTimeCounter.addEventListener(DeltaTimeEvent.DELTA_TIME_AQUIRED, frameListener);
		}
		
		///////////////////////////////////////////////////
		
		public function reset():void
		{
			traceController.reset();
			userUnits.removeAll();
			enemies.removeAll();
			bullets.removeAll();
			teleports.removeAll();
			bridges.removeAll();
			
			// clear all running explosions
			clearAllExplosions();
		}
		
		private function frameListener(event:DeltaTimeEvent):void
		{
			checkUserWeaponHitArea();
			checkEnemiesHitArea();
			checkBullets();
			checkTeleportsForEnemyUnits();
			checkBridgesForEnemyUnits();
			checkEnemyUnitsForInvisibility();
			checkEnemyUnitsForRepair();
		}
		
		private function checkPendingWeapons():void
		{
			var item:* = null;
			
			if (userUnitsToAdd.length > 0)
			{
				for each (item in userUnitsToAdd)
					registerUserWeapon(item);
				
				userUnitsToAdd.length = 0;
			}
			
			if (userUnitsToRemove.length > 0)
			{
				for each (item in userUnitsToRemove)
					unregisterUserWeapon(item);
				
				userUnitsToRemove.length = 0;
			}
			
			if (enemiesToAdd.length > 0)
			{
				for each (item in enemiesToAdd)
					registerEnemy(item);
				
				enemiesToAdd.length = 0;
			}
			
			if (enemiesToRemove.length > 0)
			{
				for each (item in enemiesToRemove)
					unregisterEnemy(item);
				
				enemiesToRemove.length = 0;
			}
		}
		
		private var userUnitsLocations:Array = [];
		private var enemyUnitsLocations:Array = [];
		
		private function checkUserWeaponHitArea():void
		{
			userUnitsLocations.length = 0;
			
			var wasLocked:Boolean = userUnits.locked;
			userUnits.locked = true;
			
			for each (var userWeapon:IWeapon in userUnits.source)
			{
				// collecting locations for enemy aircrafts					
				userUnitsLocations.push(userWeapon.currentLocation);
				
				// take each repair center and try to heal all user weapons within its reach target
				if (userWeapon is RepairCenter)
				{
					checkRepairCenter(userWeapon as RepairCenter);
					continue;
				}
				
				// provide additional targets for aircrafts
				if (userWeapon is AirCraft)
					AirCraft(userWeapon).additionalHitTargets = enemyUnitsLocations;
				
				if (activeEnemies.getItemAt(0))
					checkItemsForAttack(userWeapon, activeEnemies);
				
				// it's reasonable to check for attack only if a unit is ready to shoot
				if (!userWeapon.isBusyRotatingForTarget || (userWeapon.currentInfo.isMissileSupport && !userWeapon.busyReloadingMissile()))
					checkItemsForAttack(userWeapon, enemies, true);
				
				// if nothing was found and the weapon is not rotating for target
				// just let it come to it's initial state
				if (!userWeapon.isBusyRotatingForTarget)
					userWeapon.noHitTargetsFound();
			}
			
			userUnits.locked = wasLocked;
		}
		
		private function checkEnemiesHitArea():void
		{
			enemyUnitsLocations.length = 0;
			
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			for each (var enemy:IWeapon in enemies.source)
			{
				// do not add enemies that are currently invisible
				if (!enemy.isActingInvisible)
					enemyUnitsLocations.push(enemy.currentLocation);
				
				// provide additional targets for aircrafts
				if (enemy is AirCraft)
					AirCraft(enemy).additionalHitTargets = userUnitsLocations;
				
				// it's reasonable to check for attack only if a unit is ready to shoot
				if (!enemy.isBusyRotatingForTarget || (enemy.currentInfo.isMissileSupport && !enemy.busyReloadingMissile()))
					checkItemsForAttack(enemy, userUnits);
				
				if (!enemy.isBusyRotatingForTarget)
					enemy.noHitTargetsFound();
			}
			
			enemies.locked = wasLocked;
		}
		
		private function checkItemsForAttack(weapon:IWeapon, targets:ArrayList, refineTargets:Boolean = false):void
		{
			// if a weapon cannot shoot just leave
			if (!weapon.currentInfo.isAmmoSupport && !weapon.currentInfo.isMissileSupport)
				return;
			
			// electric towers should not persist on one enemy but rather hit all avaialble enemies randomly
			// should not be applied to the 0 level, since it should rotate its gun
			// Boss should hit randoml as well
			var getRandomTarget:Boolean = (weapon is UserElectricTower && weapon.currentInfo.level > 0) || (weapon is EnemyHelicopter && weapon.currentInfo.level == 2);
			
			if (refineTargets && (weapon is Weapon))
			{
				// need to optimize enemy selection for machine gun towers
				// they select the closest enemy, and it helps when dealing with planes and fast units
				var optimizeEnemySelection:Boolean = weapon is UserMachineGunTower;
				var refinedTarget:IWeapon = WeaponRefineUtil.findMostPreferrableTargetForWeapon(weapon as Weapon, targets.source, getRandomTarget, optimizeEnemySelection);
				
				if (refinedTarget)
					checkRefinedTarget(weapon, refinedTarget);
			}
			else
			{
				var wasLocked:Boolean = targets.locked;
				targets.locked = true;
				
				if (getRandomTarget)
				{
					var numOfAttemps:int = targets.length;
					
					// try to take a random target
					for (var i:int = 0; i < numOfAttemps; i++)
						if (checkRefinedTarget(weapon, targets.source[Math.round(Math.random() * (targets.source.length - 1))]))
							break;
				}
				else
					for each (var target:IWeapon in targets.source)
						if (checkRefinedTarget(weapon, target))
							break;
				
				targets.locked = wasLocked;
			}
		}
		
		private function checkRefinedTarget(weapon:IWeapon, target:IWeapon):Boolean
		{
			var targetForMissileApproved:Boolean = false;
			
			if (WeaponUtil.weaponCanHitTarget(weapon, target))
			{
				// launching a missile if available
				if (weapon.currentInfo.isMissileSupport && !weapon.busyReloadingMissile())
					targetForMissileApproved = weapon.fireMissileAt(target);
				
				// firing a bullet
				if (!weapon.isBusyRotatingForTarget)
				{
					weapon.hitTarget = target.currentLocation;
					weapon.hitObject = target;
					weapon.rotateForTarget();
					return true;
				}
			}
			
			return targetForMissileApproved;
		}
		
		// optimization
		private const bulletsToRemove:Array = [];
		
		private function checkBullets():void
		{
			bulletsToRemove.length = 0;
			
			var wasLocked:Boolean = bullets.locked;
			bullets.locked = true;
			
			for each (var bullet:IBullet in bullets.source)
			{
				if (checkBullet(bullet))
				{
					bulletsToRemove.push(bullet);
					checkPendingWeapons();
				}
			}
			
			bullets.locked = wasLocked;
			
			for each (var bulletToRemove:IBullet in bulletsToRemove)
			{
				bullets.removeItem(bulletToRemove);
				
				if (bulletToRemove is AbstractBullet)
					traceController.stopTracingForLaunchedObject(AbstractBullet(bulletToRemove));
			}
		}
		
		// returns true if the bullet hit the target
		private function checkBullet(bullet:IBullet):Boolean
		{
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			// process user bullets
			if (bullet.type == BulletType.USER)
				for each (var enemy:IWeapon in enemies.source)
					if (enemy.rect.contains(bullet.x - enemy.x, bullet.y - enemy.y))
					{
						// enemy planes are not hit by explosions
						if (bullet is CannonBullet && CannonBullet(bullet).isFromExplosion && enemy is AirCraft)
							continue;
						
						// apply physical damage
						if (!(bullet is ElectricBullet))
							enemy.applyDamage(bullet.hitPower);
						
						if (bullet is MachineGunBullet)
							SoundController.instance.playSound(SoundResources.SOUND_WEAPON_DAMAGING_FROM_BULLET, 0.3);
						else if (bullet is CannonBullet)
							SoundController.instance.playSound(SoundResources.SOUND_WEAPON_DAMAGING_FROM_CANNON, 0.5);
						
						// shock can be applied only to ground units
						// if the enemy unit has an ability to freeze, the the user unit will be temporarily paralized
						if ((bullet is ElectricBullet) && (enemy is Weapon))
							Weapon(enemy).applyElectricShock(bullet.hitPower, ElectricBullet(bullet).electrolizingDuration, ElectricBullet(bullet).freezingBullet);
						
						if (bullet is AbstractBullet)
							AbstractBullet(bullet).stop();
						
						enemies.locked = wasLocked;
						return true;
					}
			
			enemies.locked = wasLocked;
			
			wasLocked = userUnits.locked;
			userUnits.locked = true;
			
			// process enemy bullets
			if (bullet.type == BulletType.ENEMY)
			{
				for each (var userWeapon:IWeapon in userUnits.source)
					if (userWeapon.rect.contains(bullet.x - userWeapon.x, bullet.y - userWeapon.y))
					{
						userWeapon.applyDamage(bullet.hitPower);
						
						// shock can be applied only to ground units
						// if the enemy unit has an ability to freeze, the the user unit will be temporarily paralized
						// User electric towers are not frozen
						// already frozen towers are not refrozen
						if ((bullet is ElectricBullet) && (userWeapon is Weapon))
							// prevent refreezing and freezing electric towers
							if (!ElectricBullet(bullet).freezingBullet || (!Weapon(userWeapon).isFrozen && !(userWeapon is UserElectricTower)))
								Weapon(userWeapon).applyElectricShock(bullet.hitPower, ElectricBullet(bullet).electrolizingDuration, ElectricBullet(bullet).freezingBullet);
						
						if (bullet is AbstractBullet)
							AbstractBullet(bullet).stop();
						
						userUnits.locked = wasLocked;
						return true;
					}
			}
			
			userUnits.locked = wasLocked;
			
			return false;
		}
		
		//////////////////////////////
		/// Checking invisibility
		//////////////////////////////
		
		private var invisibleUnitsHash:Object = {};
		
		private function checkEnemyUnitsForInvisibility():void
		{
			invisibleUnitsHash = {};
			
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			for each (var enemy:IWeapon in enemies.source)
				if (enemy.currentInfo.canMakeInvisible)
					tryMakeEnemyUnitsAroundInvisible(enemy);
			
			enemies.locked = wasLocked;
			
			// restore visibility for units that are outside the reach radius
			restoreVisibility();
		}
		
		private function restoreVisibility():void
		{
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			for each (var enemy:IWeapon in enemies.source)
				if ((enemy is Weapon) && invisibleUnitsHash[Weapon(enemy).uniqueKey] == undefined && !enemy.currentInfo.canBecomeInvisible)
					enemy.isActingInvisible = false;
			
			enemies.locked = wasLocked;
		}
		
		private function tryMakeEnemyUnitsAroundInvisible(invisibleEnemy:IWeapon):void
		{
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			for each (var enemy:IWeapon in enemies.source)
				// this is not applicable to energy balls
				if (enemy != invisibleEnemy && !(enemy is EnemyEnergyBall) && !(enemy is EnemyInvisibleTank) && (enemy is Weapon) && WeaponUtil.isReachable(invisibleEnemy, enemy))
				{
					enemy.isActingInvisible = true;
					invisibleUnitsHash[Weapon(enemy).uniqueKey] = enemy;
					
					if (invisibleEnemy is EnemyInvisibleTank)
						EnemyInvisibleTank(invisibleEnemy).notifyConcealing(enemy);
				}
			
			enemies.locked = wasLocked;
		}
		
		//////////////////////////////
		/// Checking enemy repair
		//////////////////////////////
		
		private function checkEnemyUnitsForRepair():void
		{
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			for each (var enemy:IWeapon in enemies.source)
				if (enemy.currentInfo.canRepairUnits)
					tryReapairUnitsAround(enemy);
			
			enemies.locked = wasLocked;
		}
		
		private function tryReapairUnitsAround(repairEnemyUnit:IWeapon):void
		{
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			for each (var enemy:IWeapon in enemies.source)
				if (enemy != repairEnemyUnit && (enemy is Weapon) && WeaponUtil.isReachable(repairEnemyUnit, enemy) && Weapon(enemy).getDamagePercentage() > 0)
				{
					Weapon(enemy).repair(repairEnemyUnit.currentInfo.hitPower);
					
					if (repairEnemyUnit is EnemyRepairTank)
						EnemyRepairTank(repairEnemyUnit).notifyRepairing(IWeapon(enemy));
				}
			
			enemies.locked = wasLocked;
		}
		
		//////////////////////////////
		/// Checking repair centers
		//////////////////////////////
		
		private function checkRepairCenter(repairCenter:RepairCenter):void
		{
			var targetFound:Boolean = false;
			
			var wasLocked:Boolean = userUnits.locked;
			userUnits.locked = true;
			
			// take each repair center and try to heal all user weapons within its reach target
			for each (var userWeapon:IWeapon in userUnits.source)
				// healing only applies to the ground units
				// center doesn't heal itself, need another center for that
				if (!(userWeapon is AirCraft) && (userWeapon != repairCenter))
				{
					if (Weapon(userWeapon).getDamagePercentage() > 0 && WeaponUtil.isReachable(repairCenter, userWeapon))
					{
						Weapon(userWeapon).repair(repairCenter.currentInfo.hitPower);
						targetFound = true;
					}
				}
			
			userUnits.locked = wasLocked;
			
			if (targetFound)
				repairCenter.notifyRepairing();
		}
		
		//////////////////////////////
		/// Checking teleports
		//////////////////////////////
		
		private var teleportingEnemiesHash:Object = {};
		
		private function checkTeleportsForEnemyUnits():void
		{
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			for each (var teleport:Teleport in teleports.source)
				for each (var enemy:IWeapon in enemies.source)
					// only ground units can be teleported
					if (enemy is Weapon && teleportingEnemiesHash[Weapon(enemy).uniqueKey] == undefined)
						// only use teleports which have an opposite port
						if (teleport.oppositePort && teleport.rect.contains(enemy.x - teleport.x, enemy.y - teleport.y))
						{
							teleportingEnemiesHash[Weapon(enemy).uniqueKey] = enemy;
							
							trafficController.unregisterTrajectoryFollower(Weapon(enemy));
							teleport.addEventListener(TeleportEvent.DISAPPEAR_ANIMATION_COMPLETED, teleport_disappearAnimationCompletedHandler);
							teleport.showDisappearAnimationForWeapon(Weapon(enemy));
							//AchievementsController.notifyEmemyUnitTeleported();
						}
			
			enemies.locked = wasLocked;
		}
		
		private function teleport_disappearAnimationCompletedHandler(event:TeleportEvent):void
		{
			var teleport:Teleport = event.currentTarget as Teleport;
			
			teleport.removeEventListener(TeleportEvent.DISAPPEAR_ANIMATION_COMPLETED, teleport_disappearAnimationCompletedHandler);
			
			teleport.oppositePort.addEventListener(TeleportEvent.APPEAR_ANIMATION_COMPLETED, teleport_appearAnimationCompletedHandler);
			teleport.oppositePort.showAppearAnimationForWeapon(event.weapon);
		}
		
		private function teleport_appearAnimationCompletedHandler(event:TeleportEvent):void
		{
			var teleport:Teleport = event.currentTarget as Teleport;
			
			teleport.removeEventListener(TeleportEvent.APPEAR_ANIMATION_COMPLETED, teleport_appearAnimationCompletedHandler);
			
			//event.weapon.skipToNextPoint();
			trafficController.registerTrajectoryFollower(event.weapon as Weapon);
			notifyEnemyAboutTrajectory(event.weapon as Weapon, trajectories);
			
			delete teleportingEnemiesHash[Weapon(event.weapon).uniqueKey];
		}
		
		//////////////////////////////
		/// Registering bridges
		//////////////////////////////
		
		private var enemiesPassingBridgeHash:Object = {};
		
		private function checkBridgesForEnemyUnits():void
		{
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			for each (var bridge:Bridge in bridges.source)
				for each (var enemy:IWeapon in enemies.source)
					// only ground units can be checked for passing a bridge
					// the unit and the bride must have the same parent container
					if (enemy is Weapon && bridge.parent == Weapon(enemy).parent)
					{
						// checking for intersection of a unit with a bridge
						if (bridge.rect.contains(enemy.x - bridge.x, enemy.y - bridge.y))
						{
							// the unit is not already passing the bridge
							if (enemiesPassingBridgeHash[Weapon(enemy).uniqueKey + bridge.uniqueKey] == undefined)
							{
								var bridgeIndex:int = bridge.parent.getChildIndex(bridge);
								var moveToIndex:int = 0;
								
								if (bridge.weaponShouldGoUnder(Weapon(enemy), false))
								{
									// moving the unit under the bridge
									moveToIndex = bridgeIndex;
									Weapon(enemy).parent.addChildAt(Weapon(enemy), moveToIndex);
									trafficController.placeTrajectoryFollowerOnBottomOverlay(Weapon(enemy));
								}
								else
								{
									/*// moving the unit over the bridge and trajectory layer
									   if (bridge.parent == gameStage.childrenLayer)
									   moveToIndex = gameStage.getIndexToPlaceWeaponOverBridge();
									   else
									   throw new Error("Bride is not a child of gameStage.childrenLayer!");
									
									 Weapon(enemy).parent.addChildAt(Weapon(enemy), moveToIndex);*/
									
									// move the unit on top
									// In case a fast unit hovers over another unit on the bridge
									// this will allow the fast one to be higher.
									Weapon(enemy).parent.addChild(Weapon(enemy));
									
									trafficController.placeTrajectoryFollowerOnTopOverlay(Weapon(enemy));
									
									Weapon(enemy).registerBridgeToMoveOver(bridge);
								}
								
								// remember that the unit is passing the bridge
								enemiesPassingBridgeHash[Weapon(enemy).uniqueKey + bridge.uniqueKey] = enemy;
							}
						}
						// if the unit is outside the bridge,
						// but it just passed it
						else if (enemiesPassingBridgeHash[Weapon(enemy).uniqueKey + bridge.uniqueKey] != undefined)
						{
							// move the unit on top
							Weapon(enemy).parent.addChild(Weapon(enemy));
							
							Weapon(enemy).unregisterBridgeToMoveOver();
							
							// remove it from hash
							delete enemiesPassingBridgeHash[Weapon(enemy).uniqueKey + bridge.uniqueKey];
							trafficController.removeOverlayRestrictions(Weapon(enemy));
						}
					}
			
			enemies.locked = wasLocked;
		}
		
		//////////////////////////////
		/// Registering weapons
		//////////////////////////////
		
		public function registerUserWeapon(weapon:IWeapon):void
		{
			if (userUnits.locked)
				userUnitsToAdd.push(weapon);
			else
				userUnits.addItem(weapon);
		}
		
		public function unregisterUserWeapon(weapon:IWeapon):void
		{
			if (userUnits.locked)
				userUnitsToRemove.push(weapon);
			else
				userUnits.removeItem(weapon);
		}
		
		public function registerEnemy(enemy:IWeapon):void
		{
			if (enemies.locked)
				enemiesToAdd.push(enemy);
			else
			{
				enemies.addItem(enemy);
				
				// tripads and energy balls are not restricted by traffic since they hover over the ground.
				var allowOverlap:Boolean = enemy is EnemyEnergyBall || (enemy is EnemyMobileVehicle && EnemyMobileVehicle(enemy).currentInfo.level == 2);
				
				if (enemy is TrajectoryFollower)
					trafficController.registerTrajectoryFollower(TrajectoryFollower(enemy), allowOverlap);
			}
		}
		
		public function unregisterEnemy(enemy:IWeapon):void
		{
			if (enemies.locked)
				enemiesToRemove.push(enemy);
			else
			{
				enemies.removeItem(enemy);
				
				if (enemy is TrajectoryFollower)
					trafficController.unregisterTrajectoryFollower(TrajectoryFollower(enemy));
			}
		}
		
		////////
		
		public function registerTeleport(teleport:Teleport):void
		{
			teleports.addItem(teleport);
		}
		
		public function unregisterTeleport(teleport:Teleport):void
		{
			teleports.removeItem(teleport);
		}
		
		////////
		
		public function registerBridge(bridge:Bridge):void
		{
			bridges.addItem(bridge);
		}
		
		public function unregisterBridge(bridge:Bridge):void
		{
			bridges.removeItem(bridge);
		}
		
		////////////////
		
		// remember last trajectories
		private var trajectories:Array = null;
		
		public function notifyAllEnemiesAboutTrajectory(trajectories:Array):void
		{
			if (!trajectories || trajectories.length == 0)
				return;
			
			this.trajectories = trajectories;
			
			var wasLocked:Boolean = enemies.locked;
			enemies.locked = true;
			
			// only ground units should be notified
			for each (var enemy:IWeapon in enemies.source)
				if (enemy is Weapon)
					Weapon(enemy).trajectory = trajectories[Weapon(enemy).pathIndex];
			
			enemies.locked = wasLocked;
		}
		
		public function notifyEnemyAboutTrajectory(enemy:Weapon, trajectories:Array):void
		{
			if (!trajectories || trajectories.length == 0)
				return;
			
			this.trajectories = trajectories;
			
			enemy.trajectory = trajectories[enemy.pathIndex];
		}
		
		////// working with active enemies
		
		public function isActiveEnemy(enemy:Weapon):Boolean
		{
			return (enemy == activeEnemies.getItemAt(0));
		}
		
		public function setActiveEnemy(enemy:Weapon):void
		{
			if (activeEnemies.getItemAt(0))
				Weapon(activeEnemies.getItemAt(0)).showActiveEnemyIndicator(false);
			
			activeEnemies.removeAll();
			
			if (enemy)
			{
				activeEnemies.addItem(enemy);
				Weapon(enemy).showActiveEnemyIndicator(true);
			}
		}
	}

}