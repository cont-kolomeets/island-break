/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package controllers
{
	import constants.GamePlayConstants;
	import controllers.BossController;
	import controllers.SoundController;
	import islandBreak.controllers.WeaponController;
	import events.WeaponEvent;
	import flash.geom.Point;
	import mainPack.GameControllerItemManager;
	import mainPack.GameSettings;
	import mainPack.PanelNavigator;
	import nslib.animation.engines.AnimationEngine;
	import nslib.animation.engines.LoopAnimator;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.controls.ToolTipBase;
	import nslib.core.Globals;
	import nslib.utils.FontDescriptor;
	import nslib.utils.NSMath;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.SoundResources;
	import supportControls.toolTips.HintToolTip;
	import weapons.enemy.EnemyHelicopter;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class BossController
	{
		public var navigator:PanelNavigator;
		public var itemController:GameControllerItemManager;
		public var weaponController:WeaponController;
		
		private var bossCallback:Function = null;
		private var bombardLooper:LoopAnimator = new LoopAnimator();
		
		/////////////
		
		private const bossIntroPhrases:Array = ["HA HA HA!!!\nTHIS ISLAND WILL\nBE MINE!!!", "STOP ME\nIF YOU CAN!\nHA HA HA HA!!!"];
		private const bossMessages:Array = ["HA HA HA!!!\nYOU WILL NEVER\nSTOP ME!!!", "I AM\nUNBEATABLE!!!", "YOU ARE ON\nTHE WAY TO DESTRUCTION!", "TREMBLE\nBEFORE ME!!!", "YOU HAVE NO\nCHANCE TO SURVIVE!!!", "FACE YOUR DESTINY!!!", "THERE IS NO\nHOPE FOR YOU!!!", "YOU WILL BE\nMY SLAVE!!!\nHA HA HA!!!"];
		private const bossHalfDefeatPhrase:String = "NO!!!!!\nBUT IT'S NOT\nOVER.....";
		private var bossMessageField:CustomTextField = new CustomTextField(null, new FontDescriptor(14, 0, FontResources.KOMTXTB));
		
		/////////////
		
		private var blockingScreen:NSSprite = null;
		
		private var boss:EnemyHelicopter = null;
		
		////////////
		
		public function BossController()
		{
		}
		
		////////////
		
		public function showBossForTheFirstTime(callback:Function):void
		{
			removeBoss();
			
			bossCallback = callback;
			
			initiateBoss();
			forbidAutoMotion();
			
			boss.currentInfo.isMissileSupport = false;
			boss.shootDelay = 10000;
			
			addBlockScreen();
			
			// start bombarding the stage
			//AnimationEngine.globalAnimator.animateProperty(SoundController.instance, "musicVolume", SoundController.instance.musicVolume, SoundController.instance.musicVolume / 10, NaN, 1000);
			bombardLooper.start();
			bombardLooper.registerFunctionToExecute(bombardGameStage, null, 700);
			
			// phrase 1
			bringBossToTalk(bossIntroPhrases[0], 5000, 4000, false, false, true);
			
			// phrase 2
			AnimationEngine.globalAnimator.executeFunction(bringBossToTalk, [bossIntroPhrases[1], 100, 4000, false, true, true], AnimationEngine.globalAnimator.currentTime + 9000);
			
			// start shooting missiles
			AnimationEngine.globalAnimator.executeFunction(activateMissiles, null, AnimationEngine.globalAnimator.currentTime + 11000);
			
			// restore music
			//AnimationEngine.globalAnimator.animateProperty(SoundController.instance, "musicVolume", SoundController.instance.musicVolume, GameSettings.musicLevel, NaN, 2000, AnimationEngine.globalAnimator.currentTime + 15000);
			
			// remove the boss from the stage
			AnimationEngine.globalAnimator.executeFunction(bossRemoved, null, AnimationEngine.globalAnimator.currentTime + 17000);
		}
		
		private function initiateBoss(armor:Number = 20):void
		{
			boss = new EnemyHelicopter(2);
			boss.x = -100;
			boss.y = GamePlayConstants.STAGE_HEIGHT / 2;
			boss.anchor = new Point(GamePlayConstants.STAGE_WIDTH / 2, GamePlayConstants.STAGE_HEIGHT / 2);
			boss.workingTimeDelay = 1000000;
			boss.setArmor(armor);
			
			navigator.gameStage.aircraftLayer.addChild(boss);
			
			boss.activate();
			
			weaponController.registerEnemy(boss);
			AnimationEngine.globalAnimator.animateConstantBubbling([boss], 2000, NaN, 1, "bossController.animateConstantBubbling");
			
			SoundController.instance.notifyHelicopterAddedToStage();
			
			//SoundController.instance.playSound(SoundResources.SOUND_FINAL_WAVE_STARTED);
			SoundController.instance.playMusicTrack(SoundResources.MUSIC_BOSS);
			
			navigator.gameStage.showBossIsComingNotification();
		}
		
		private function allowAutoMotion():void
		{
			boss.motionSpeed = boss.currentInfo.motionSpeed;
			boss.rotationSpeed = boss.currentInfo.rotationSpeed;
			boss.resetNavigation();
		}
		
		private function forbidAutoMotion(forbidRotation:Boolean = true):void
		{
			boss.motionSpeed = 0;
			if (forbidRotation)
				boss.rotationSpeed = 0;
			
			boss.resetNavigation();
		}
		
		private function addBlockScreen():void
		{
			if (!blockingScreen)
			{
				blockingScreen = new NSSprite();
				blockingScreen.mouseEnabled = true;
				blockingScreen.graphics.clear();
				blockingScreen.graphics.beginFill(0, 0.1);
				blockingScreen.graphics.drawRect(0, 0, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			}
			
			Globals.topLevelApplication.addChild(blockingScreen);
			AnimationEngine.globalAnimator.animateProperty(blockingScreen, "alpha", 0.1, 1, NaN, 1000);
		}
		
		private function bombardGameStage():void
		{
			WeaponController.putNormalExplosion(Math.random() * GamePlayConstants.STAGE_WIDTH, Math.random() * GamePlayConstants.STAGE_HEIGHT, 0.5);
		}
		
		private function activateMissiles():void
		{
			boss.currentInfo.isMissileSupport = true;
			boss.missileShootDelay = 200;
		}
		
		private function bossRemoved():void
		{
			bombardLooper.clear();
			
			if (blockingScreen)
			{
				if (Globals.topLevelApplication.contains(blockingScreen))
					Globals.topLevelApplication.removeChild(blockingScreen);
				
				blockingScreen = null;
			}
			
			removeBoss();
		}
		
		public function removeBoss(callbackDelay:Number = 0, executeCallback:Boolean = true):void
		{
			if (!boss)
				return;
			
			speechLooper.clear();
			
			interruptTalking();
			// without exclusions
			AnimationEngine.globalAnimator.stopAnimationForObject(boss);
			//AnimationEngine.globalAnimator.stopAnimationForObject(SoundController.instance);
			
			boss.removeEventListener(WeaponEvent.REMOVE, boss_removeHandler);
			boss.removeEventListener(WeaponEvent.DESTROYED, boss_destroyedHandler);
			
			//SoundController.instance.musicVolume = GameSettings.musicLevel;
			
			itemController.removeAircraft(boss, false, false);
			
			boss.currentInfo.isMissileSupport = true;
			boss = null;
			
			if (executeCallback && bossCallback != null)
				AnimationEngine.globalAnimator.executeFunction(bossCallback, null, AnimationEngine.globalAnimator.currentTime + callbackDelay);
			
			AnimationEngine.globalAnimator.executeFunction(finalizeRemovingAfterDelay, null, AnimationEngine.globalAnimator.currentTime + callbackDelay);
		}
		
		private function finalizeRemovingAfterDelay():void
		{
			bombardLooper.clear();
		}
		
		//////////////////// For battle
		
		private var isFinalBattleFlag:Boolean = false;
		
		private var bossIsDestroyedFlag:Boolean = false;
		
		private var speechLooper:LoopAnimator = new LoopAnimator();
		
		public function showBossForBattle(callback:Function, isFinalBattle:Boolean = false):void
		{
			this.isFinalBattleFlag = isFinalBattle;
			bossIsDestroyedFlag = false;
			removeBoss();
			
			bossCallback = callback;
			
			initiateBoss(isFinalBattle ? 50 : 20);
			
			boss.addEventListener(WeaponEvent.REMOVE, boss_removeHandler);
			boss.addEventListener(WeaponEvent.DESTROYED, boss_destroyedHandler);
			
			speechLooper.start();
			speechLooper.registerFunctionToExecute(makeBossTalk, null, 30000, 0);
		
			//AnimationEngine.globalAnimator.animateProperty(SoundController.instance, "musicVolume", SoundController.instance.musicVolume, SoundController.instance.musicVolume / 10, NaN, 1000);
		}
		
		private var speechIteration:int = 1;
		
		private function makeBossTalk():void
		{
			bringBossToTalk(bossMessages[speechIteration % bossMessages.length], 8000, 5000, true);
			speechIteration++;
		}
		
		private function boss_removeHandler(event:WeaponEvent):void
		{
			removeBoss();
		}
		
		private function boss_destroyedHandler(event:WeaponEvent):void
		{
			if (bossIsDestroyedFlag)
				return;
			
			if (isFinalBattleFlag)
			{
				AchievementsController.notifyBossDestroyed();
				
				for (var i:int = 0; i < 20; i++)
					bombardGameStage();
				
				bombardLooper.registerFunctionToExecute(bombardGameStage, null, 700);
				bombardLooper.start(true);
				
				AnimationEngine.globalAnimator.executeOnNextFrame(WeaponController.putDevastatingExplosion, [boss.x, boss.y, 30]);
				removeBoss(5000);
			}
			else
			{
				bossIsDestroyedFlag = true;
				bombardLooper.registerFunctionToExecute(bombardGameStage, null, 700);
				bombardLooper.start(true);
				
				speechLooper.clear();
				
				bringBossToTalk(bossHalfDefeatPhrase, 5000, 6000, false, true, false, true);
				AnimationEngine.globalAnimator.executeFunction(bossRemoved, null, AnimationEngine.globalAnimator.currentTime + 14000);
			}
		}
		
		/////////// Talking
		
		private const SHOW_TIP_FUNC_ID:String = "showTooltipForBoss";
		private const HIDE_TIP_FUNC_ID:String = "removeTooltipForBoss";
		
		private function interruptTalking(allowMotion:Boolean = false, stopCurrentAnimation:Boolean = true):void
		{
			if (stopCurrentAnimation)
				AnimationEngine.globalAnimator.stopAnimationForObject(boss, ["bossController.animateConstantBubbling"]);
			
			AnimationEngine.globalAnimator.stopExecutingFunctionByID(SHOW_TIP_FUNC_ID);
			AnimationEngine.globalAnimator.stopExecutingFunctionByID(HIDE_TIP_FUNC_ID);
			AnimationEngine.globalAnimator.removeFunctionFromNextFrame(updateToolTip);
			
			ToolTipService.removeAllTooltipsForComponent(boss);
			if (navigator.gameStage.contains(bossMessageField))
				navigator.gameStage.removeChild(bossMessageField);
			
			if (allowMotion)
				allowAutoMotion();
		}
		
		private function bringBossToTalk(message:String, moveTime:Number = 5000, toolTipShowTime:Number = 6000, allowMotionWhenFinished:Boolean = false, removeFromStage:Boolean = false, moveToCenter:Boolean = false, removeAsDestroyed:Boolean = false):void
		{
			var newX:Number = GamePlayConstants.STAGE_WIDTH / 2;
			var newY:Number = GamePlayConstants.STAGE_HEIGHT / 2;
			
			if (!moveToCenter)
			{
				newX -= 100 * (1 - 2 * Math.random());
				newY -= 70 * (1 - 2 * Math.random());
				
				if (Math.abs(newX - boss.x) < 50)
					newX = (boss.x < GamePlayConstants.STAGE_WIDTH / 2) ? (boss.x + 50) : (boss.x - 50);
				
				if (Math.abs(newY - boss.y) < 50)
					newY = (boss.y < GamePlayConstants.STAGE_HEIGHT / 2) ? (boss.y + 50) : (boss.y - 50)
			}
			
			interruptTalking();
			forbidAutoMotion();
			AnimationEngine.globalAnimator.moveObjects(boss, boss.x, boss.y, newX, newY, moveTime); // , NaN, EasingFunction.easeInOutSine);
			
			var dx:Number = newX - boss.x;
			var dy:Number = newY - boss.y;
			var goalAngle:Number = NSMath.atan2Rad(dy, dx);
			
			AnimationEngine.globalAnimator.executeFunction(showTooltipForBoss, [message], AnimationEngine.globalAnimator.currentTime + moveTime, SHOW_TIP_FUNC_ID);
			AnimationEngine.globalAnimator.executeFunction(interruptTalking, [allowMotionWhenFinished, !removeAsDestroyed && !removeFromStage], AnimationEngine.globalAnimator.currentTime + moveTime + toolTipShowTime, HIDE_TIP_FUNC_ID);
			
			if (removeFromStage)
				AnimationEngine.globalAnimator.moveObjects(boss, newX, newY, GamePlayConstants.STAGE_WIDTH + 100, GamePlayConstants.STAGE_HEIGHT / 2, 3000, AnimationEngine.globalAnimator.currentTime + moveTime + toolTipShowTime + 500);
			
			if (removeAsDestroyed)
				AnimationEngine.globalAnimator.animateProperty(boss, "bodyAngle", boss.bodyAngle, 100, NaN, 20000);
			else
			{
				AnimationEngine.globalAnimator.animateProperty(boss, "bodyAngle", boss.bodyAngle, goalAngle, NaN, moveTime / 3);
				AnimationEngine.globalAnimator.animateProperty(boss, "bodyAngle", goalAngle, 0, NaN, moveTime / 3, AnimationEngine.globalAnimator.currentTime + moveTime * 2 / 3);
			}
		}
		
		private function showTooltipForBoss(message:String):void
		{
			AnimationEngine.globalAnimator.executeOnNextFrame(updateToolTip, [message, 0]);
		}
		
		private function updateToolTip(message:String, iteration:int):void
		{
			if (!ToolTipService.getToolTipAssignedForComponent(boss))
			{
				navigator.gameStage.addChild(bossMessageField);
				
				var toolTip:ToolTipBase = ToolTipService.setTooltipWaitingForClick(boss, new ToolTipInfo(boss, new ToolTipSimpleContentDescriptor("BOSS:", [message], null, new FontDescriptor(14, 0xF13030, FontResources.KOMTXTB), new FontDescriptor(14, 0xFEEBAB, FontResources.KOMTXTB))), HintToolTip, navigator.gameStage.menuLayer);
				
				var globalPoint:Point = HintToolTip(toolTip).getContent().body.localToGlobal(new Point(0, 0));
				
				bossMessageField.textWidth = 130;
				bossMessageField.x = globalPoint.x;
				bossMessageField.y = globalPoint.y;
			}
			
			bossMessageField.text = message.substr(0, iteration);
			
			iteration++;
			
			if (iteration < message.length)
				AnimationEngine.globalAnimator.executeOnNextFrame(updateToolTip, [message, iteration]);
		}
	}

}