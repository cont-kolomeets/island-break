package islandBreak.mainPack
{
	import constants.GamePlayConstants;
	import events.WeaponEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import islandBreak.controllers.MissionItemsGenerator;
	import islandBreak.controllers.WeaponController;
	import islandBreak.supportClasses.resources.EnemyWeaponLocationConfig;
	import nslib.AIPack.events.TrajectoryFollowerEvent;
	import nslib.AIPack.pathFollowing.TrajectoryFollower;
	import nslib.core.Globals;
	import nslib.utils.NSMath;
	import supportClasses.WeaponType;
	import weapons.ammo.missiles.Missile;
	import weapons.base.AirCraft;
	import weapons.base.IWeapon;
	import weapons.base.PlaneBase;
	import weapons.base.supportClasses.WeaponUtil;
	import weapons.base.Weapon;
	import weapons.enemy.EnemyHelicopter;
	import weapons.enemy.EnemyPlane;
	import weapons.user.UserPlane;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ItemController
	{
		
		public var weaponController:WeaponController = null;
		
		//////////////
		
		public function ItemController()
		{
		
		}
		
		/////////////
		
		private var _navigator:PanelNavigator = null;
		
		public function get navigator():PanelNavigator
		{
			return _navigator;
		}
		
		public function set navigator(value:PanelNavigator):void
		{
			_navigator = value;
			
			// to process interactions with items
			navigator.gameStage.addEventListener(MouseEvent.MOUSE_MOVE, gameStage_mouseMoveHandler);
			navigator.gameStage.addEventListener(MouseEvent.MOUSE_DOWN, gameStage_mouseDownHandler);
			navigator.gameStage.addEventListener(MouseEvent.MOUSE_UP, gameStage_mouseUpHandler);
		
			// to place items back
			//Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		//////////////
		
		public function addItemsForMission(missionIndex:int):void
		{
			var newItems:Array = MissionItemsGenerator.generateItemsForMission(missionIndex);
			
			for each (var item:*in newItems)
				if (item is Weapon)
					addStaticWeaponToStage(item);
				else if (item is AirCraft)
					launchUserAircraft(item);
		}
		
		public function removeAllItems():void
		{
			// need to clear the game stage in a correct way
			// listeners from weapons should be removed
			var numItems:int = navigator.gameStage.groundItemLayer.registeredItems.length;
			
			for (var i:int = 0; i < numItems; i++)
			{
				var item:Weapon = navigator.gameStage.groundItemLayer.registeredItems.getItemAt(i);
				
				if (item)
				{
					removeWeapon(item);
					navigator.gameStage.groundItemLayer.unregisterItem(item);
				}
			}
			
			var numAirItems:int = navigator.gameStage.aircraftDynamicLayer.registeredItems.length;
			
			for (var j:int = 0; j < numAirItems; j++)
			{
				var airItem:* = navigator.gameStage.aircraftDynamicLayer.registeredItems.getItemAt(j);
				
				if (airItem)
					navigator.gameStage.aircraftDynamicLayer.unregisterItem(item);
				
				if (airItem is AirCraft)
					removeAircraft(AirCraft(airItem));
				else if (airItem is Missile)
					WeaponController.deactivateMissile(Missile(airItem), false);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handling user events
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------
		//  gameStage
		//--------------------------------
		
		private function gameStage_mouseDownHandler(event:MouseEvent):void
		{
		}
		
		private function gameStage_mouseUpHandler(event:MouseEvent):void
		{
		}
		
		private function gameStage_mouseMoveHandler(event:MouseEvent):void
		{
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with moving weapons
		//
		//--------------------------------------------------------------------------
		
		public function addHelper():void
		{
			var helper:EnemyPlane = new EnemyPlane(0);
			helper.anchor = new Point(EnemyWeaponLocationConfig.CONFIG[0][0].x, EnemyWeaponLocationConfig.CONFIG[0][0].y);
			
			helper.x = 400 * Math.random();
			helper.y = 400 * Math.random();
			
			addMovingItemToStage(helper);
		}
		
		public function addMovingItemToStage(item:IWeapon):void
		{
			// use separate settings for ground units and aircrafts
			if (item is Weapon)
			{
				Weapon(item).isMobile = true;
				Weapon(item).addEventListener(WeaponEvent.DESTROYED, weapon_destroyedHandler);
				Weapon(item).addEventListener(WeaponEvent.DAMAGED, weapon_damagedHandler);
				Weapon(item).addEventListener(TrajectoryFollowerEvent.REACHED_END_OF_PATH, weapon_reachedEndOfPathHandler);
				
				navigator.gameStage.groundItemLayer.registerItem(Weapon(item));
			}
			else if (item is AirCraft)
			{
				//AirCraft(item).anchor = new Point(GamePlayConstants.STAGE_WIDTH / 2 + 50 - NSMath.random() * 100, GamePlayConstants.STAGE_HEIGHT / 2 + 50 - NSMath.random() * 100);
				navigator.gameStage.aircraftDynamicLayer.registerItem(AirCraft(item));
				
				AirCraft(item).addEventListener(WeaponEvent.REMOVE, plane_removeHandler);
				AirCraft(item).addEventListener(WeaponEvent.DESTROYED, plane_destroyedHandler);
			}
			
			weaponController.registerEnemy(item);
			item.activate();
		
			// register enemy
		/*var activateEnemyFunction:Function = function():void
		   {
		   weaponController.registerEnemy(item);
		   if (item is Weapon)
		   weaponController.notifyEnemyAboutTrajectory(Weapon(item), mapController.trajectories);
		   item.activate();
		   }
		
		   // before we register enemy we need to check if it is supposed to appear via a teleport
		   if (!ignoreTeleports && mapController.currentMap.enemyUnitsAppearFromPortal)
		   {
		   var enterTeleport:OneWayTeleport = mapController.currentMap.getEnemyEnterTeleportForPathAt(item is Weapon ? Weapon(item).pathIndex : AirCraft(item).pathIndex);
		   enterTeleport.showAppearAnimationForWeapon(item, true, 300, activateEnemyFunction);
		   }
		   else
		 activateEnemyFunction();*/
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with static weapons
		//
		//--------------------------------------------------------------------------
		
		public function addStaticWeaponToStage(weapon:Weapon):void
		{
			weapon.interactionRectangle = WeaponUtil.staticInteractionRect;
			
			weapon.addEventListener(WeaponEvent.DESTROYED, weapon_destroyedHandler);
			weapon.addEventListener(WeaponEvent.PLACED, weapon_placedHandler);
			weapon.addEventListener(WeaponEvent.DAMAGED, weapon_damagedHandler);
			
			// configure the rest angle is some is specified
			//if (!isNaN(mapController.currentMap.gunRestAngle))
			//	weapon.gunRestAngle = mapController.currentMap.gunRestAngle;
			
			weapon.activate();
			
			weaponController.registerUserWeapon(weapon);
			
			weapon.removeMouseSensitivity();
			weapon.isPlaced = true;
			
			navigator.gameStage.groundItemLayer.registerItem(weapon);
		}
		
		public function removeWeapon(weapon:Weapon, destroyed:Boolean = false, escaped:Boolean = false):void
		{
			if (weapon.currentInfo.weaponType == WeaponType.USER)
			{
				weaponController.unregisterUserWeapon(weapon);
			}
			
			if (weapon.currentInfo.weaponType == WeaponType.ENEMY)
			{
				weaponController.unregisterEnemy(weapon);
				
				if (weaponController.isActiveEnemy(weapon))
					weaponController.setActiveEnemy(null);
				
					//if (destroyed)
					//	gameController.notifyEnemyDestroyed(weapon);
					//else if (escaped)
					//	gameController.notifyEnemyWeaponBrokeThrough(weapon);
			}
			
			navigator.gameStage.groundItemLayer.unregisterItem(weapon);
			
			weapon.deactivate();
			weapon.removeEventListener(WeaponEvent.DESTROYED, weapon_destroyedHandler);
			//weapon.removeEventListener(WeaponEvent.PLACED, weapon_placedHandler);
			weapon.removeEventListener(WeaponEvent.DAMAGED, weapon_damagedHandler);
			weapon.removeEventListener(TrajectoryFollowerEvent.REACHED_END_OF_PATH, weapon_reachedEndOfPathHandler);
			//weapon.removeEventListener(WeaponEvent.CREATE_PLANE_FROM_FACTORY, weapon_createPlaneFromFactoryHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handling weapon events
		//
		//--------------------------------------------------------------------------
		
		private function weapon_placedHandler(event:WeaponEvent):void
		{
			//SoundController.instance.playSound(SoundResources.SOUND_WEAPON_PLACING);
		}
		
		private function weapon_damagedHandler(event:WeaponEvent):void
		{
			//if (navigator.weaponSettingsPanel.isShown && navigator.weaponSettingsPanel.selectedItem == event.currentTarget)
			//	updateWeaponSettingsPanel();
		}
		
		private function weapon_destroyedHandler(event:WeaponEvent):void
		{
			var weapon:Weapon = event.currentTarget as Weapon;
			
			if (!weapon)
				return;
			
			//SoundController.instance.playSound(SoundResources.SOUND_EXPLOSION_01);
			
			WeaponController.putNormalExplosion(weapon.x, weapon.y);
			
			removeWeapon(weapon, true);
		}
		
		private function weapon_reachedEndOfPathHandler(event:TrajectoryFollowerEvent):void
		{
			var weapon:Weapon = event.currentTarget as Weapon;
			
			if (!weapon)
				return;
			
			var enemyRemoveFunction:Function = function():void
			{
				removeWeapon(weapon, false, true);
			}
			
			/*// if there are any exit exitTeleport
			   if (weapon.currentInfo.weaponType == WeaponType.ENEMY && mapController.currentMap.enemyUnitsDisappearToPortal)
			   {
			   weaponController.unregisterEnemy(weapon);
			
			   if (weaponController.isActiveEnemy(weapon))
			   weaponController.setActiveEnemy(null);
			
			   var exitTeleport:OneWayTeleport = mapController.currentMap.getEnemyExitTeleportForPathAt(weapon.pathIndex);
			
			   exitTeleport.showDisappearAnimationForWeapon(weapon, true, enemyRemoveFunction);
			   }
			 else*/
			enemyRemoveFunction();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with aircrafts
		//
		//--------------------------------------------------------------------------
		
		public function launchUserAircraft(plane:UserPlane):void
		{
			plane.activate();
			navigator.gameStage.aircraftDynamicLayer.registerItem(plane);
			
			plane.addEventListener(WeaponEvent.REMOVE, plane_removeHandler);
			plane.addEventListener(WeaponEvent.DESTROYED, plane_destroyedHandler);
			
			weaponController.registerUserWeapon(plane);
		
			//SoundController.instance.playSound(SoundResources.SOUND_AIRCRAFT_LOCATED);
		}
		
		private function plane_removeHandler(event:WeaponEvent):void
		{
			var plane:AirCraft = event.currentTarget as AirCraft;
			
			removeAircraft(event.currentTarget as AirCraft, false, true);
		}
		
		private function plane_destroyedHandler(event:WeaponEvent):void
		{
			var plane:PlaneBase = event.currentTarget as PlaneBase;
			
			//SoundController.instance.playSound(SoundResources.SOUND_EXPLOSION_01, 0.8);
			
			WeaponController.putNormalExplosion(plane.x, plane.y);
			
			removeAircraft(plane, true);
		}
		
		public function removeAircraft(plane:AirCraft, destroyed:Boolean = false, escaped:Boolean = false):void
		{
			plane.removeEventListener(WeaponEvent.REMOVE, plane_removeHandler);
			plane.removeEventListener(WeaponEvent.DESTROYED, plane_destroyedHandler);
			
			plane.deactivate();
			
			navigator.gameStage.aircraftDynamicLayer.unregisterItem(plane);
			
			if (plane.currentInfo.weaponType == WeaponType.USER)
			{
				weaponController.unregisterUserWeapon(plane);
			}
			else
			{
				weaponController.unregisterEnemy(plane);
				
					//if (destroyed)
					//	gameController.notifyEnemyDestroyed(plane);
					////else if (escaped)
					//gameController.notifyEnemyWeaponBrokeThrough(plane);
			}
		
			//if (plane is EnemyHelicopter)
			//	SoundController.instance.notifyHelicopterRemovedFromStage();
		}
	}

}