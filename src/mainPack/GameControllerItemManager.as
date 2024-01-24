/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package mainPack
{
	import bot.GameBot;
	import config.NavigateConfig;
	import constants.GamePlayConstants;
	import controllers.AchievementsController;
	import controllers.BossController;
	import controllers.GameInfoController;
	import controllers.MapController;
	import controllers.ScoreController;
	import controllers.SoundController;
	import controllers.StatisticsController;
	import controllers.WaveGenerator;
	import islandBreak.controllers.WeaponController;
	import controllers.WeaponStoreController;
	import events.ScoreEvent;
	import events.WeaponEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import infoObjects.panelInfos.WeaponSettingsPanelInfo;
	import infoObjects.WeaponStoreInfo;
	import nslib.AIPack.events.TrajectoryFollowerEvent;
	import nslib.animation.engines.AnimationEngine;
	import nslib.animation.engines.LoopAnimator;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.core.Globals;
	import nslib.interactableObjects.events.MoveEvent;
	import nslib.interactableObjects.MovableObject;
	import nslib.utils.FontDescriptor;
	import nslib.utils.NSMath;
	import supportClasses.LogParameters;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.LogMessages;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.WeaponResources;
	import supportClasses.WeaponType;
	import supportControls.toolTips.HintToolTip;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	import weapons.ammo.missiles.Missile;
	import weapons.base.AirCraft;
	import weapons.base.IGroundWeapon;
	import weapons.base.IPurchasableItem;
	import weapons.base.IWeapon;
	import weapons.base.PlaneBase;
	import weapons.base.supportClasses.WeaponUtil;
	import weapons.base.Weapon;
	import weapons.enemy.EnemyHelicopter;
	import weapons.enemy.EnemyPlane;
	import weapons.enemy.EnemyPlaneFactory;
	import weapons.objects.Obstacle;
	import weapons.objects.OneWayTeleport;
	import weapons.user.UserPlane;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameControllerItemManager
	{
		//--------------------------------------------------------------------------
		//
		//  Instance variables
		//
		//--------------------------------------------------------------------------
		
		public var gameController:GameController = null;
		
		public var mapController:MapController = null;
		
		public var weaponController:WeaponController = null;
		
		public var weaponStoreController:WeaponStoreController = null;
		
		public var gameInfoController:GameInfoController = null;
		
		public var progressBarController:GameControllerProgressBarManager;
		
		/////////// flags
		
		// the item currently being dragged by a user.
		private var itemBeingDragged:DisplayObject = null;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function GameControllerItemManager()
		{
			configureBot();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties: getters and setters
		//
		//--------------------------------------------------------------------------
		
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
			Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		private var _scoreController:ScoreController = null;
		
		public function get scoreController():ScoreController
		{
			return _scoreController;
		}
		
		public function set scoreController(value:ScoreController):void
		{
			_scoreController = value;
			
			_scoreController.addEventListener(ScoreEvent.SCORES_CHANGED, scoreController_scoresChangedHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Main operations
		//
		//--------------------------------------------------------------------------
		
		public function fillMissingItemsInMenu():void
		{
			var newItems:Array = weaponStoreController.createMissingItemsForSale();
			
			for each (var item:*in newItems)
				if (item is Weapon)
				{
					var weapon:Weapon = Weapon(item);
					
					weapon.interactionRectangle = WeaponUtil.staticInteractionRect;
					
					weapon.addEventListener(WeaponEvent.DESTROYED, weapon_destroyedHandler);
					weapon.addEventListener(WeaponEvent.PLACED, weapon_placedHandler);
					weapon.addEventListener(WeaponEvent.DAMAGED, weapon_damagedHandler);
					
					// configure the rest angle is some is specified
					if (!isNaN(mapController.currentMap.gunRestAngle))
						weapon.gunRestAngle = mapController.currentMap.gunRestAngle;
					
					navigator.gameStage.menuLayer.addChild(weapon);
				}
				else if (item is Obstacle)
				{
					var obstacle:Obstacle = Obstacle(item);
					
					obstacle.interactionRectangle = WeaponUtil.staticInteractionRect;
					
					obstacle.addEventListener(MoveEvent.MOVED, obstacle_movedHandler);
					
					navigator.gameStage.menuLayer.addChild(obstacle);
				}
		}
		
		public function removeAllItems():void
		{
			// need to clear the game stage in a correct way
			// listeners from weapons should be removed
			while (navigator.gameStage.childrenLayer.numChildren > 0)
			{
				var item:* = navigator.gameStage.childrenLayer.getChildAt(0);
				
				if (item is Weapon)
					removeWeapon(Weapon(item));
				else if (item is Obstacle)
					removeObstacle(Obstacle(item));
				else
					navigator.gameStage.childrenLayer.removeChildAt(0);
			}
			
			// removing all aircraft
			while (navigator.gameStage.aircraftLayer.numChildren > 0)
			{
				var aircraft:* = navigator.gameStage.aircraftLayer.getChildAt(0);
				
				if (aircraft is AirCraft)
					removeAircraft(AirCraft(aircraft));
				else if (aircraft is Missile)
					WeaponController.deactivateMissile(Missile(aircraft), false);
				else
					navigator.gameStage.aircraftLayer.removeChildAt(0);
			}
			
			// just in case remove any boss from the stage
			bossController.removeBoss(0, false);
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
			// check for menu items
			var itemUnderCursor:IGroundWeapon = WeaponUtil.tryFindItemOnLayerAt(event.stageX, event.stageY, navigator.gameStage.menuLayer);
			
			// try process items from menu
			if (itemUnderCursor && itemUnderCursor.currentInfo.weaponType == WeaponType.USER && !itemUnderCursor.isPlaced)
				processMouseDownOnItem(itemUnderCursor);
			else
			{
				var isOverMenu:Boolean = navigator.gameControlPanel.mouseIsOverControlPanel() || navigator.gameControlPanel.bonusAttackIsBeingUsed();
				// otherwise just start selecting
				
				if (!isOverMenu)
					navigator.gameStage.startSelectionForAdvancedTargeting();
			}
		}
		
		private function gameStage_mouseUpHandler(event:MouseEvent):void
		{
			// if an item that is currently being dragged is released
			if (itemBeingDragged)
			{
				dropItemAt(event.stageX, event.stageY);
			}
			else
			{
				var menuClicked:Boolean = navigator.gameControlPanel.mouseIsOverControlPanel() || navigator.gameControlPanel.bonusAttackIsBeingUsed() || progressBarController.mouseIsOverProgressBar();
				
				if (menuClicked)
					return;
				
				var clickedItem:IGroundWeapon = WeaponUtil.tryFindItemOnLayerAt(event.stageX, event.stageY, navigator.gameStage.childrenLayer);
				
				// if a user is not interacting with the menu
				// and if no item was clicked
				if (clickedItem)
				{
					if ((clickedItem.currentInfo.weaponType != WeaponType.ENEMY || !(clickedItem == navigator.gameStage.getLastTargetedEnemy())) && !navigator.gameStage.isSelectingUsingAdvancedTargeting())
						tryProcessClickOverItem(clickedItem)
				}
				// if there is no last targeted enemy that means that mouse up event was not due to a target selection
				else if (navigator.gameStage.getLastTargetedEnemy() == null && !navigator.gameStage.isSelectingUsingAdvancedTargeting())
					weaponController.setActiveEnemy(null);
			}
		}
		
		private function dropItemAt(x:Number, y:Number):void
		{
			if (!itemBeingDragged)
				return;
			
			if (itemBeingDragged is Weapon)
				trySettleWeaponAt(Weapon(itemBeingDragged), x, y);
			else if (itemBeingDragged is Obstacle)
				trySettleObstacleAt(Obstacle(itemBeingDragged), x, y);
			
			ToolTipService.removeAllTooltipsForComponent(itemBeingDragged);
			
			setItemBeingDragged(null);
		}
		
		private var lastHoveredItem:IWeapon = null;
		
		private function gameStage_mouseMoveHandler(event:MouseEvent):void
		{
			if (itemBeingDragged)
			{
				updateValidationForItemBeingDragged();
				return;
			}
			
			var hoveredItemFound:Boolean = false;
			
			// try to find an item, over which a click may have possibly happened
			hoveredItemFound = checkItemsForHoveringOnLayer(navigator.gameStage.childrenLayer, event.stageX, event.stageY);
			// check the user items in the menu
			if (!hoveredItemFound)
				hoveredItemFound = checkItemsForHoveringOnLayer(navigator.gameStage.menuLayer, event.stageX, event.stageY);
			
			navigator.gameStage.notifyEnemyIsHovered(hoveredItemFound && lastHoveredItem.currentInfo.weaponType == WeaponType.ENEMY);
			
			// if no items detected
			if (!hoveredItemFound)
			{
				lastHoveredItem = null;
				navigator.gameControlPanel.applyWeaponInfo(null);
			}
		}
		
		private function updateValidationForItemBeingDragged():void
		{
			if (itemBeingDragged)
			{
				// update validation for dragged item
				mapController.checkIfValidItemToPlaceAt(itemBeingDragged as Weapon, itemBeingDragged.x, itemBeingDragged.y);
				
				// update position for the hit radius after the weapon has been moved
				navigator.gameStage.updateHitRadiusPositionForWeapon(itemBeingDragged as Weapon);
			}
		}
		
		private function checkItemsForHoveringOnLayer(layer:DisplayObjectContainer, mouseX:Number, mouseY:Number):Boolean
		{
			var hoveredItemFound:Boolean = false;
			
			var len:int = layer.numChildren;
			
			for (var i:int = 0; i < len; i++)
			{
				var child:* = layer.getChildAt(i);
				
				if (child is Weapon)
				{
					if (hoveredItemFound)
					{
						Weapon(child).showHoveredOverIndicator(false);
						continue;
					}
					
					if (WeaponUtil.interactionDetected(child, mouseX, mouseY))
					{
						hoveredItemFound = true;
						navigator.gameControlPanel.applyWeaponInfo(Weapon(child).currentInfo);
						
						if (!(child == lastHoveredItem))
						{
							lastHoveredItem = child;
							Weapon(child).showHoveredOverIndicator(true);
							SoundController.instance.playSound(SoundResources.SOUND_BUTTON_HOVER);
						}
					}
					else
						Weapon(child).showHoveredOverIndicator(false);
				}
			}
			
			return hoveredItemFound;
		}
		
		//--------------------------------
		//  stage
		//--------------------------------
		
		//--------------------------------
		//  Here we processs the keyboard event
		//--------------------------------
		
		private var suppressKeyboard:Boolean = true;
		
		public function forbidUserInteraction():void
		{
			suppressKeyboard = true;
			
			navigator.hideWeaponSettingsPanel();
			
			if (itemBeingDragged)
				cancelItemBeingDragged();
				
			navigator.gameStage.clearSelection();
		}
		
		public function allowUserInteraction():void
		{
			suppressKeyboard = false;
		}
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ESCAPE)
				navigator.hideWeaponSettingsPanel();
			
			if ((event.keyCode == Keyboard.ESCAPE) && itemBeingDragged)
				cancelItemBeingDragged();
			
			if (suppressKeyboard)
				return;
			
			if (!navigator.gameControlPanel.interactionWithMenuIsAllowed() || navigator.gameControlPanel.supportIsBeingUsed())
				return;
			
			// try call support
			if (navigator.getCurrentStep() && navigator.getCurrentStep().name == NavigateConfig.STEP_SHOW_GAME_STAGE && !gameController.globalTimeIsPaused())
			{
				if (!itemBeingDragged && gameController.gameIsRunning)
				{
					if (event.keyCode == Keyboard.Q)
						navigator.gameControlPanel.tryCallBombAttack();
					else if (event.keyCode == Keyboard.W)
						navigator.gameControlPanel.tryCallAirSupport();
				}
				
				// hot keys for building towers
				if (event.keyCode == Keyboard.NUMBER_1 || event.keyCode == Keyboard.NUMPAD_1)
					tryToTakeTowerUsingHotKey(WeaponResources.USER_CANNON);
				else if (event.keyCode == Keyboard.NUMBER_2 || event.keyCode == Keyboard.NUMPAD_2)
					tryToTakeTowerUsingHotKey(WeaponResources.USER_MACHINE_GUN);
				else if (event.keyCode == Keyboard.NUMBER_3 || event.keyCode == Keyboard.NUMPAD_3)
					tryToTakeTowerUsingHotKey(WeaponResources.USER_ELECTRIC_TOWER);
				else if (event.keyCode == Keyboard.NUMBER_4 || event.keyCode == Keyboard.NUMPAD_4)
					tryToTakeTowerUsingHotKey(WeaponResources.USER_REPAIR_CENTER);
			}
		}
		
		private function setItemBeingDragged(item:DisplayObject):void
		{
			if (itemBeingDragged is MovableObject && item == null)
				MovableObject(itemBeingDragged).detachFromCursor();
			
			itemBeingDragged = item;
			
			if (item)
				navigator.gameControlPanel.showWarningMessage("Press ESC to cancel");
			else
				navigator.gameControlPanel.showWarningMessage(null);
		}
		
		private function cancelItemBeingDragged(returnItemImmediately:Boolean = false):void
		{
			if (!itemBeingDragged)
				return;
			
			if (itemBeingDragged is Weapon)
				returnWeaponToMenu(Weapon(itemBeingDragged), returnItemImmediately);
			else if (itemBeingDragged is Obstacle)
				returnObstacleToMenu(Obstacle(itemBeingDragged), returnItemImmediately);
			
			setItemBeingDragged(null);
		}
		
		private function tryToTakeTowerUsingHotKey(weaponId:String):void
		{
			if (itemBeingDragged)
				cancelItemBeingDragged(true);
			
			var storeInfos:Array = weaponStoreController.generateStoreInfos();
			var itemToTake:Weapon = null;
			
			for each (var info:WeaponStoreInfo in storeInfos)
				if (info.item && info.affordable && info.item.currentInfo.weaponId == weaponId)
				{
					itemToTake = info.item as Weapon;
					break;
				}
			
			if (itemToTake)
			{
				// imitate mouse behaviour
				itemToTake.attachToCursor(true);
				processMouseDownOnItem(itemToTake);
				updateValidationForItemBeingDragged();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Notification
		//
		//--------------------------------------------------------------------------
		
		public function notifyGameStopped():void
		{
			if (itemBeingDragged)
			{
				if (itemBeingDragged is Weapon)
					returnWeaponToMenu(Weapon(itemBeingDragged));
				else if (itemBeingDragged is Obstacle)
					returnObstacleToMenu(Obstacle(itemBeingDragged));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Adding enemy to stage
		//
		//--------------------------------------------------------------------------
		
		public function addEnemyToStage(enemy:IWeapon, ignoreTeleports:Boolean = false):void
		{
			// use separate settings for ground units and aircrafts
			if (enemy is Weapon)
			{
				Weapon(enemy).isMobile = true;
				Weapon(enemy).addEventListener(WeaponEvent.DESTROYED, weapon_destroyedHandler);
				Weapon(enemy).addEventListener(WeaponEvent.DAMAGED, weapon_damagedHandler);
				Weapon(enemy).addEventListener(TrajectoryFollowerEvent.REACHED_END_OF_PATH, weapon_reachedEndOfPathHandler);
				
				if (enemy is EnemyPlaneFactory)
					Weapon(enemy).addEventListener(WeaponEvent.CREATE_PLANE_FROM_FACTORY, weapon_createPlaneFromFactoryHandler);
				
				navigator.gameStage.childrenLayer.addChild(Weapon(enemy));
				
			}
			else if (enemy is AirCraft)
			{
				AirCraft(enemy).anchor = new Point(GamePlayConstants.STAGE_WIDTH / 2 + 50 - NSMath.random() * 100, GamePlayConstants.STAGE_HEIGHT / 2 + 50 - NSMath.random() * 100);
				navigator.gameStage.aircraftLayer.addChild(AirCraft(enemy));
				
				AirCraft(enemy).addEventListener(WeaponEvent.REMOVE, plane_removeHandler);
				AirCraft(enemy).addEventListener(WeaponEvent.DESTROYED, plane_destroyedHandler);
				
				if (enemy is EnemyHelicopter)
					SoundController.instance.notifyHelicopterAddedToStage();
			}
			
			// register enemy
			var activateEnemyFunction:Function = function():void
			{
				weaponController.registerEnemy(enemy);
				if (enemy is Weapon)
					weaponController.notifyEnemyAboutTrajectory(Weapon(enemy), mapController.trajectories);
				enemy.activate();
			}
			
			// before we register enemy we need to check if it is supposed to appear via a teleport
			if (!ignoreTeleports && mapController.currentMap.enemyUnitsAppearFromPortal)
			{
				var enterTeleport:OneWayTeleport = mapController.currentMap.getEnemyEnterTeleportForPathAt(enemy is Weapon ? Weapon(enemy).pathIndex : AirCraft(enemy).pathIndex);
				enterTeleport.showAppearAnimationForWeapon(enemy, true, 300, activateEnemyFunction);
			}
			else
				activateEnemyFunction();
			
			if (StatisticsController.allowStatiscits)
			{
				var param:LogParameters = new LogParameters(LogMessages.ENEMY_ENTERED);
				param.item = enemy;
				StatisticsController.logMessage(param);
			}
			
			gameInfoController.gameInfo.helpInfo.notifyEnemyAppearedOnStage(enemy.currentInfo);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with user weapons
		//
		//--------------------------------------------------------------------------
		
		public function trySettleWeaponAt(weapon:Weapon, x:int, y:int):void
		{
			if (mapController.isLegitimatePosition(weapon, x, y))
			{
				var snapPoint:Point = mapController.getSnapPoint(x, y);
				
				AnimationEngine.globalAnimator.moveObjects(weapon, weapon.x, weapon.y, snapPoint.x, snapPoint.y, 200, AnimationEngine.globalAnimator.currentTime);
				
				weapon.activate();
				
				weaponController.registerUserWeapon(weapon);
				
				weapon.removeMouseSensitivity();
				weapon.isPlaced = true;
				
				// while dragging the hit radius was shown, but now we need to hide it
				navigator.gameStage.hideHitRadiusForCurrentWeapon();
				
				// notify map controller that the spot is occupied by a user weapon
				mapController.assignSpot(snapPoint.x, snapPoint.y);
				mapController.clearValidation();
				
				// working with other parameters
				scoreController.cutScoresForBuying(weapon);
				
				weaponStoreController.notifyAboutTakenItem(weapon);
				fillMissingItemsInMenu();
				
				gameController.notifyNeedUpdateParameters();
				
				AchievementsController.notifyTowerPlaced(weapon);
				
				if (StatisticsController.allowStatiscits)
				{
					var param:LogParameters = new LogParameters(LogMessages.TOWER_PLACED);
					param.item = weapon;
					param.totalNumOfTilesForUserWeapon = mapController.currentMap.getNumPlacesForUserWeapon();
					StatisticsController.logMessage(param);
				}
				
				GameTracker.api.customMsg(TrackingMessages.TOWER_PLACED + ":" + weapon.currentInfo.weaponId + " " + weapon.currentInfo.level + "," + snapPoint.x + "," + snapPoint.y);
				
				navigator.gameStage.childrenLayer.addChild(weapon);
			}
			else
				returnWeaponToMenu(weapon);
		}
		
		public function returnWeaponToMenu(weapon:Weapon, returnItemImmediately:Boolean = false):void
		{
			weapon.releaseMouse();
			
			mapController.clearValidation();
			mapController.visualizeTrajectories();
			navigator.gameControlPanel.placeItemToMenu(weapon, !returnItemImmediately);
			
			// while dragging the hit radius was shown, but now we need to hide it
			navigator.gameStage.hideHitRadiusForCurrentWeapon();
		}
		
		public function removeWeapon(weapon:Weapon, destroyed:Boolean = false, escaped:Boolean = false):void
		{
			if (weapon.currentInfo.weaponType == WeaponType.USER)
			{
				weaponController.unregisterUserWeapon(weapon);
				
				// clear stop so other user weapons can be placed there
				mapController.clearSpot(weapon.x, weapon.y);
				// since weapons do not block path, no need for recalculation of trajectories
				//mapController.generateTrajectories();
				
				//if (!gameIsRunning)
				//mapController.visualizeTrajectories();
				
				//weaponController.notifyAllEnemiesAboutTrajectory(mapController.trajectories);
				
				// hide the settings panel for the removed weapon
				if (navigator.weaponSettingsPanel.isShown && navigator.weaponSettingsPanel.selectedItem == weapon)
					navigator.hideWeaponSettingsPanel();
				
				GameBot.notifyUserWeaponRemoved(weapon);
			}
			
			if (weapon.currentInfo.weaponType == WeaponType.ENEMY)
			{
				weaponController.unregisterEnemy(weapon);
				
				if (weaponController.isActiveEnemy(weapon))
					weaponController.setActiveEnemy(null);
				
				if (destroyed)
					gameController.notifyEnemyDestroyed(weapon);
				else if (escaped)
					gameController.notifyEnemyWeaponBrokeThrough(weapon);
			}
			
			if (navigator.gameStage.childrenLayer.contains(weapon))
				navigator.gameStage.childrenLayer.removeChild(weapon);
			
			weapon.deactivate();
			weapon.removeEventListener(WeaponEvent.DESTROYED, weapon_destroyedHandler);
			weapon.removeEventListener(WeaponEvent.PLACED, weapon_placedHandler);
			weapon.removeEventListener(WeaponEvent.DAMAGED, weapon_damagedHandler);
			weapon.removeEventListener(TrajectoryFollowerEvent.REACHED_END_OF_PATH, weapon_reachedEndOfPathHandler);
			weapon.removeEventListener(WeaponEvent.CREATE_PLANE_FROM_FACTORY, weapon_createPlaneFromFactoryHandler);
			
			// hiding hit radius if some is shown
			if (navigator.gameStage.getWeaponWhichHitRadiusIsShowing() == weapon)
				navigator.gameStage.hideHitRadiusForCurrentWeapon();
		
			// Only enemies are returned for reuse
			//if (weapon.weaponType == WeaponType.ENEMY)
			//ObjectsPoolUtil.returnObject(weapon);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handling weapon events
		//
		//--------------------------------------------------------------------------
		
		private function weapon_placedHandler(event:WeaponEvent):void
		{
			SoundController.instance.playSound(SoundResources.SOUND_WEAPON_PLACING);
		}
		
		private function weapon_damagedHandler(event:WeaponEvent):void
		{
			if (navigator.weaponSettingsPanel.isShown && navigator.weaponSettingsPanel.selectedItem == event.currentTarget)
				updateWeaponSettingsPanel();
		}
		
		private function weapon_destroyedHandler(event:WeaponEvent):void
		{
			var weapon:Weapon = event.currentTarget as Weapon;
			
			if (!weapon)
				return;
			
			//SoundController.instance.playSound(SoundResources.SOUND_EXPLOSION_01);
			
			if (weapon.currentInfo.weaponType == WeaponType.USER)
			{
				if (StatisticsController.allowStatiscits)
				{
					var param:LogParameters = new LogParameters(LogMessages.TOWER_DESTROYED);
					param.item = weapon;
					param.totalNumOfTilesForUserWeapon = mapController.currentMap.getNumPlacesForUserWeapon();
					StatisticsController.logMessage(param);
				}
				
				GameTracker.api.customMsg(TrackingMessages.TOWER_DESTROYED + ":" + weapon.currentInfo.weaponId + " " + weapon.currentInfo.level + "," + weapon.x + "," + weapon.y);
			}
			
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
			
			// if there are any exit exitTeleport
			if (weapon.currentInfo.weaponType == WeaponType.ENEMY && mapController.currentMap.enemyUnitsDisappearToPortal)
			{
				weaponController.unregisterEnemy(weapon);
				
				if (weaponController.isActiveEnemy(weapon))
					weaponController.setActiveEnemy(null);
				
				var exitTeleport:OneWayTeleport = mapController.currentMap.getEnemyExitTeleportForPathAt(weapon.pathIndex);
				
				exitTeleport.showDisappearAnimationForWeapon(weapon, true, enemyRemoveFunction);
			}
			else
				enemyRemoveFunction();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with obstacles
		//
		//--------------------------------------------------------------------------
		
		public function trySettleObstacleAt(obstacle:Obstacle, x:int, y:int):void
		{
			if (mapController.isLegitimatePosition(obstacle, x, y))
			{
				var snapPoint:Point = mapController.getSnapPoint(x, y);
				
				AnimationEngine.globalAnimator.moveObjects(obstacle, obstacle.x, obstacle.y, snapPoint.x, snapPoint.y, 200, AnimationEngine.globalAnimator.currentTime);
				
				obstacle.removeEventListener(MoveEvent.MOVED, obstacle_movedHandler);
				
				obstacle.removeMouseSensitivity();
				obstacle.isPlaced = true;
				
				SoundController.instance.playSound(SoundResources.SOUND_WEAPON_PLACING);
				
				// working with map
				var trajectoriesNeedRecalc:Boolean = mapController.spotIsOverAnyTrajectory(snapPoint.x, snapPoint.y);
				
				mapController.assignSpot(snapPoint.x, snapPoint.y);
				mapController.clearValidation();
				
				if (trajectoriesNeedRecalc)
				{
					mapController.applyLatestTestTrajectories();
					weaponController.notifyAllEnemiesAboutTrajectory(mapController.trajectories);
				}
				
				// need to visualize actual trajectories instead of the test ones.
				mapController.visualizeTrajectories();
				
				// updating other parameters
				scoreController.cutScoresForBuying(obstacle);
				
				weaponStoreController.notifyAboutTakenItem(obstacle);
				fillMissingItemsInMenu();
				
				gameController.notifyNeedUpdateParameters();
				
				navigator.gameStage.childrenLayer.addChild(obstacle);
			}
			else
				returnObstacleToMenu(obstacle);
		}
		
		public function returnObstacleToMenu(obstacle:Obstacle, returnItemImmediately:Boolean = false):void
		{
			obstacle.releaseMouse();
			
			mapController.clearValidation();
			mapController.visualizeTrajectories();
			navigator.gameControlPanel.placeItemToMenu(obstacle, !returnItemImmediately);
		}
		
		public function removeObstacle(obstacle:Obstacle):void
		{
			mapController.clearSpot(obstacle.x, obstacle.y);
			mapController.generateTrajectories();
			
			if (!gameController.gameIsRunning)
				mapController.visualizeTrajectories();
			
			weaponController.notifyAllEnemiesAboutTrajectory(mapController.trajectories);
			
			if (navigator.gameStage.childrenLayer.contains(obstacle))
				navigator.gameStage.childrenLayer.removeChild(obstacle);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handling objstacles events
		//
		//--------------------------------------------------------------------------
		
		private function obstacle_movedHandler(event:MoveEvent):void
		{
			mapController.checkIfValidItemToPlaceAt(event.currentTarget as Obstacle, event.newX, event.newY);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Interaction with items
		//
		//--------------------------------------------------------------------------
		
		public function tryProcessClickOverItem(item:IGroundWeapon):void
		{
			if ((item is Weapon) && Weapon(item).currentInfo.weaponType == WeaponType.ENEMY)
			{
				weaponController.setActiveEnemy(Weapon(item));
				SoundController.instance.playSound(SoundResources.SOUND_ACTIVE_ENEMY_SELECTION);
				return;
			}
			
			// do not show a menu when support is used
			if (item.isBuilt && !navigator.gameControlPanel.mouseIsOverControlPanel() && !navigator.gameControlPanel.bonusAttackIsBeingUsed())
			{
				navigator.showWeaponSettingsPanel(generateWeaponSettingsPanelInfoForItem(item));
				navigator.gameControlPanel.applyWeaponInfo(item.currentInfo);
				
				SoundController.instance.playSound(SoundResources.SOUND_BUTTON_TAP);
			}
		}
		
		////// for optimization purposes we use the same info
		private var weaponSettingsPanelInfo:WeaponSettingsPanelInfo = new WeaponSettingsPanelInfo(0, 0, 0, 0, 0, 0, null, null);
		
		public function generateWeaponSettingsPanelInfoForItem(item:IGroundWeapon):WeaponSettingsPanelInfo
		{
			// configure info
			weaponSettingsPanelInfo.x = item.x;
			weaponSettingsPanelInfo.y = item.y;
			weaponSettingsPanelInfo.priceToRepair = scoreController.getRepairPriceForItem(item, false);
			weaponSettingsPanelInfo.priceToUpgrade = scoreController.getUpgradePriceForItem(item, false);
			weaponSettingsPanelInfo.priceToSell = scoreController.getSellPriceForItem(item);
			weaponSettingsPanelInfo.totalScores = scoreController.scores;
			weaponSettingsPanelInfo.selectedItem = item;
			weaponSettingsPanelInfo.developmentInfo = gameInfoController.gameInfo.developmentInfo;
			weaponSettingsPanelInfo.numPaths = mapController.currentMap.numberOfPaths;
			weaponSettingsPanelInfo.currentLevelHasAircrafts = WaveGenerator.levelHasAircrafts(gameController.currentLevel);
			
			return weaponSettingsPanelInfo;
		}
		
		private function updateWeaponSettingsPanel():void
		{
			navigator.updateWeaponSettingsPanel(generateWeaponSettingsPanelInfoForItem(navigator.weaponSettingsPanel.selectedItem));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Handling common item events
		//
		//--------------------------------------------------------------------------
		
		private function processMouseDownOnItem(item:*):void
		{
			if (itemBeingDragged == item || (item is IPurchasableItem && !IPurchasableItem(item).affordable))
				return;
			
			// forbid any interaction during the animation
			if (navigator.gameControlPanel.interactionWithMenuIsAllowed())
			{
				setItemBeingDragged(item);
				navigator.gameControlPanel.notifyItemIsTaken(item);
				navigator.hideWeaponSettingsPanel();
				
				// if we just started dragging a new weapon from the menu
				// we need to show the hit radius for it
				if ((item is Weapon) && !Weapon(item).isPlaced)
				{
					var weapon:Weapon = item as Weapon;
					
					// showing the hit radius to help a user decide where is the best location
					navigator.gameStage.showHitRadiusForWeapon(weapon);
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with aircrafts
		//
		//--------------------------------------------------------------------------
		
		private function weapon_createPlaneFromFactoryHandler(event:WeaponEvent):void
		{
			var factoryTank:EnemyPlaneFactory = event.currentTarget as EnemyPlaneFactory;
			
			// create a tiny plane
			var enemy:IWeapon = new EnemyPlane(2);
			enemy.x = factoryTank.x;
			enemy.y = factoryTank.y;
			enemy.bodyAngle = NSMath.random() * NSMath.PI * 2;
			
			addEnemyToStage(enemy, true);
			
			SoundController.instance.playSound(SoundResources.SOUND_WEAPON_ACTIVATION_03, 0.3);
		}
		
		public function launchUserAircraft(x:Number, y:Number, level:int):void
		{
			var plane:UserPlane = new UserPlane(level);
			plane.x = -100;
			plane.y = -100;
			plane.activate();
			plane.anchor = new Point(x, y);
			navigator.gameStage.aircraftLayer.addChild(plane);
			
			plane.addEventListener(WeaponEvent.REMOVE, plane_removeHandler);
			plane.addEventListener(WeaponEvent.DESTROYED, plane_destroyedHandler);
			
			weaponController.registerUserWeapon(plane);
			
			SoundController.instance.playSound(SoundResources.SOUND_AIRCRAFT_LOCATED);
		}
		
		private function plane_removeHandler(event:WeaponEvent):void
		{
			var plane:AirCraft = event.currentTarget as AirCraft;
			
			removeAircraft(event.currentTarget as AirCraft, false, true);
		}
		
		private function plane_destroyedHandler(event:WeaponEvent):void
		{
			var plane:PlaneBase = event.currentTarget as PlaneBase;
			
			SoundController.instance.playSound(SoundResources.SOUND_EXPLOSION_01, 0.8);
			
			WeaponController.putNormalExplosion(plane.x, plane.y);
			
			removeAircraft(plane, true);
		}
		
		public function removeAircraft(plane:AirCraft, destroyed:Boolean = false, escaped:Boolean = false):void
		{
			plane.removeEventListener(WeaponEvent.REMOVE, plane_removeHandler);
			plane.removeEventListener(WeaponEvent.DESTROYED, plane_destroyedHandler);
			
			plane.deactivate();
			
			if (navigator.gameStage.aircraftLayer.contains(plane))
				navigator.gameStage.aircraftLayer.removeChild(plane);
			
			if (plane.currentInfo.weaponType == WeaponType.USER)
			{
				weaponController.unregisterUserWeapon(plane);
			}
			else
			{
				weaponController.unregisterEnemy(plane);
				
				if (destroyed)
					gameController.notifyEnemyDestroyed(plane);
				else if (escaped)
					gameController.notifyEnemyWeaponBrokeThrough(plane);
			}
			
			if (plane is EnemyHelicopter)
				SoundController.instance.notifyHelicopterRemovedFromStage();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Menu operations
		//
		//--------------------------------------------------------------------------
		
		public function repairItem(item:*):void
		{
			var scoresToCut:int = scoreController.getRepairPriceForItem(item);
			
			if (item is Weapon)
				Weapon(item).repair();
			
			scoreController.scores -= scoresToCut;
			
			gameController.notifyNeedUpdateParameters();
			
			SoundController.instance.playSound(SoundResources.SOUND_WEAPON_REPAIRING);
			
			if (StatisticsController.allowStatiscits)
				StatisticsController.logMessage(new LogParameters(LogMessages.TOWER_REPAIRED));
			
			GameTracker.api.customMsg(TrackingMessages.TOWER_REPAIRED + ":" + item.currentInfo.weaponId + " " + item.currentInfo.level + "," + item.x + "," + item.y);
		}
		
		public function upgradeItem(item:*):void
		{
			var scoresToCut:int = scoreController.getUpgradePriceForItem(item);
			
			if (item is Weapon)
				Weapon(item).upgradeToNextLevel();
			
			scoreController.scores -= scoresToCut;
			
			gameController.notifyNeedUpdateParameters();
			
			SoundController.instance.playSound(SoundResources.SOUND_WEAPON_UPGRADING);
			
			if (StatisticsController.allowStatiscits)
			{
				var param:LogParameters = new LogParameters(LogMessages.TOWER_UPGRADED);
				param.item = item;
				StatisticsController.logMessage(param);
			}
			
			GameTracker.api.customMsg(TrackingMessages.TOWER_UPGRADED + ":" + item.currentInfo.weaponId + " " + item.currentInfo.level + "," + item.x + "," + item.y);
		}
		
		public function sellItem(item:*):void
		{
			if (item is Weapon)
				removeWeapon(Weapon(item));
			else if (item is Obstacle)
				removeObstacle(Obstacle(item));
			
			scoreController.addScoresAfterSellingItem(item);
			
			gameController.notifyNeedUpdateParameters();
			
			SoundController.instance.playSound(SoundResources.SOUND_WEAPON_SELLING);
			
			if (StatisticsController.allowStatiscits)
			{
				var param:LogParameters = new LogParameters(LogMessages.TOWER_SOLD);
				param.item = item;
				param.totalNumOfTilesForUserWeapon = mapController.currentMap.getNumPlacesForUserWeapon();
				StatisticsController.logMessage(param);
			}
			
			GameTracker.api.customMsg(TrackingMessages.TOWER_SOLD + ":" + item.currentInfo.weaponId + " " + item.currentInfo.level + "," + item.x + "," + item.y);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods:
		//
		//--------------------------------------------------------------------------
		
		private function scoreController_scoresChangedHandler(event:ScoreEvent):void
		{
			var wasLocked:Boolean = weaponController.userUnits.locked;
			weaponController.userUnits.locked = true;
			for each (var unit:IWeapon in weaponController.userUnits.source)
				if (unit is Weapon)
				{
					Weapon(unit).configureUgradeAvailableIndicator(gameInfoController.gameInfo.developmentInfo.levelIsDevelopedForWeapon(Weapon(unit).nextInfo), unit.currentInfo.upgradePrice <= event.newValue);
				}
			weaponController.userUnits.locked = wasLocked;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Working with the boss
		//
		//--------------------------------------------------------------------------
		
		private var bossController:BossController = new BossController();
		
		public function showBoss(callback:Function):void
		{
			bossController.navigator = navigator;
			bossController.itemController = this;
			bossController.weaponController = weaponController;
			
			if (gameController.currentLevel == 0)
			{
				forbidUserInteraction();
				bossController.showBossForTheFirstTime(callback);
			}
			else if (gameController.currentLevel == 4)
				bossController.showBossForBattle(callback, false);
			else if (gameController.currentLevel == 9)
				bossController.showBossForBattle(callback, true);
			else
				callback();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: game bot
		//
		//--------------------------------------------------------------------------
		
		private function configureBot():void
		{
			GameBot.getAffordableTowers = function():Array
			{
				var result:Array = [];
				var storeInfos:Array = weaponStoreController.generateStoreInfos();
				
				for each (var storeInfo:WeaponStoreInfo in storeInfos)
					if (storeInfo.affordable)
						result.push(storeInfo.item);
				
				return result;
			}
			
			GameBot.takeItemFromTheMenu = function(item:Weapon):void
			{
				processMouseDownOnItem(item);
			}
			
			GameBot.placeTowerAt = function(item:Weapon, x:Number, y:Number):void
			{
				trySettleWeaponAt(item, x, y);
				setItemBeingDragged(null);
			}
			
			GameBot.repairTower = repairItem;
			
			GameBot.sellTower = sellItem;
			
			GameBot.getEnemyUnits = function():Array
			{
				return weaponController.enemies.source;
			}
			
			GameBot.canUpgradeTower = function(item:Weapon):Boolean
			{
				var upgradeAllowedByDevelopmentCenter:Boolean = gameInfoController.gameInfo.developmentInfo.levelIsDevelopedForWeapon(item.nextInfo);
				return upgradeAllowedByDevelopmentCenter && (scoreController.scores >= item.currentInfo.upgradePrice) && (item.currentInfo.upgradePrice > 0);
			}
			
			GameBot.upgradeTower = upgradeItem;
			
			GameBot.setActiveEnemy = function(item:Weapon):void
			{
				weaponController.setActiveEnemy(item);
			}
			
			GameBot.getEnemies = function():Array
			{
				return weaponController.enemies.source;
			}
		}
	
	}

}