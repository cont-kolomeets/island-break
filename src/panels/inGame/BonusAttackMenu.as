/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import bot.GameBot;
	import constants.HotKeys;
	import constants.WeaponContants;
	import controllers.AchievementsController;
	import controllers.SoundController;
	import events.BonusAttackMenuEvent;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import infoObjects.gameInfo.DevelopmentInfo;
	import mainPack.DifficultyConfig;
	import mainPack.GameSettings;
	import mainPack.ModeSettings;
	import nslib.animation.EasingFunction;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.core.Globals;
	import nslib.interactableObjects.MovableObject;
	import nslib.utils.FontDescriptor;
	import nslib.utils.MouseUtil;
	import supportClasses.BombLauncher;
	import supportClasses.ISettingsObserver;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.SoundResources;
	import supportClasses.ToolTipSequencer;
	import supportControls.toolTips.HintToolTip;
	import supportControls.toolTips.InGameHintToolTip;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BonusAttackMenu extends NSSprite implements ISettingsObserver
	{
		//////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/bomb support aim.png")]
		private static var bombAimImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/air support aim.png")]
		private static var airAimImage:Class;
		
		////////
		
		public var weaponInfoBar:WeaponInfoBar = null;
		
		private var button1:BonusAttackMenuButton = new BonusAttackMenuButton(BonusAttackMenuButton.TYPE_BOMB_SUPPORT);
		
		private var button2:BonusAttackMenuButton = new BonusAttackMenuButton(BonusAttackMenuButton.TYPE_AIR_SUPPORT);
		
		private var bombSupportPointer:MovableObject = new MovableObject();
		
		private var airSupportPointer:MovableObject = new MovableObject();
		
		private var toolTipSequencer:ToolTipSequencer = new ToolTipSequencer();
		
		////////////
		
		private var pointerOffsetX:Number = -5;
		
		private var pointerOffsetY:Number = -5;
		
		/////////
		
		private var currentDevInfo:DevelopmentInfo = null;
		
		private var currentLevelMode:String = null;
		
		/////////
		
		public function BonusAttackMenu()
		{
			GameSettings.registerObserver(this);
			createPointers();
			createBonusItems();
			
			configureBot();
		}
		
		//////////
		
		// returns true if there is at least one active aim
		public function get panelIsBeingUsed():Boolean
		{
			return oneItemIsBeingUsed;
		}
		
		//////////
		
		private function createPointers():void
		{
			var bombPointer:Bitmap = new bombAimImage() as Bitmap;
			bombPointer.x = -bombPointer.width / 2 + pointerOffsetX;
			bombPointer.y = -bombPointer.height / 2 + pointerOffsetY;
			
			bombSupportPointer.addChild(bombPointer);
			
			/////
			
			var airPointer:Bitmap = new airAimImage() as Bitmap;
			airPointer.x = -airPointer.width / 2 + pointerOffsetX;
			airPointer.y = -airPointer.height / 2 + pointerOffsetY;
			
			airSupportPointer.addChild(airPointer);
		}
		
		private function createBonusItems():void
		{
			removeAllChildren();
			
			// updating the buttons
			// create buttons in blocked state.
			button1.createButtonForLevel(-1);
			button2.createButtonForLevel(-1);
			
			button2.x = 48;
			
			addChild(button1);
			addChild(button2);
			
			button1.addEventListener(MouseEvent.MOUSE_DOWN, button1_mouseDownHandler);
			button2.addEventListener(MouseEvent.MOUSE_DOWN, button2_mouseDownHandler);
			
			updateHitRadia();
		}
		
		///////////////////////
		
		//------------------------------------------
		// style settings
		//------------------------------------------
		
		///// bomb support 
		private var bombHitRadiusFillColor:int = 0xFF0000;
		
		private var bombHitRadiusFillAlpha:Number = 0.05;
		
		private var bombHitRadiusStrokeColor:int = 0xFF0000;
		
		private var bombHitRadiusStrokeAlpha:Number = 0.5;
		
		///// air support 
		private var airHitRadiusFillColor:int = 0x0000FF;
		
		private var airHitRadiusFillAlpha:Number = 0.05;
		
		private var airHitRadiusStrokeColor:int = 0x0000FF;
		
		private var airHitRadiusStrokeAlpha:Number = 0.5;
		
		/////////////
		
		private function updateHitRadia():void
		{
			if (button1.currentLevel > -1)
			{
				bombSupportPointer.graphics.clear();
				bombSupportPointer.graphics.lineStyle(1, bombHitRadiusStrokeColor, bombHitRadiusStrokeAlpha);
				bombSupportPointer.graphics.beginFill(bombHitRadiusFillColor, bombHitRadiusFillAlpha);
				bombSupportPointer.graphics.drawCircle(pointerOffsetX, pointerOffsetY, button1.weaponInfo.hitRadius);
			}
			
			if (button2.currentLevel > -1)
			{
				airSupportPointer.graphics.clear();
				airSupportPointer.graphics.lineStyle(1, airHitRadiusStrokeColor, airHitRadiusStrokeAlpha);
				airSupportPointer.graphics.beginFill(airHitRadiusFillColor, airHitRadiusFillAlpha);
				airSupportPointer.graphics.drawCircle(pointerOffsetX, pointerOffsetY, button2.weaponInfo.hitRadius);
			}
		}
		
		// updates supports for the current update levels
		public function updateButtons(devInfo:DevelopmentInfo, currentLevelMode:String):void
		{
			this.currentLevelMode = currentLevelMode;
			
			toolTipSequencer.clearSequence();
			
			currentDevInfo = devInfo;
			
			// updating the buttons
			button1.createButtonForLevel(currentDevInfo.bombSupportLevel);
			button2.createButtonForLevel(currentDevInfo.airSupportLevel);
			
			// if some supports are available we need to block them from clicking
			//button1.showBlockScreen();
			//button2.showBlockScreen();
			
			updateToolTips();
			
			updateHitRadia();
		}
		
		/////////////////////
		
		public function tryCheckForTooltipsForBombSupport():void
		{
			toolTipSequencer.clearSequence();
			
			if (currentDevInfo.bombSupportLevel > -1)
				button1.addEventListener(BonusAttackMenuButton.PROGRESS_COMPLETE, button1_progressCompleteHandler);
		}
		
		public function tryCheckForTooltipsForAirSupport():void
		{
			toolTipSequencer.clearSequence();
			
			if (currentDevInfo.airSupportLevel > -1)
				button2.addEventListener(BonusAttackMenuButton.PROGRESS_COMPLETE, button2_progressCompleteHandler);
		}
		
		private function button1_progressCompleteHandler(event:Event):void
		{
			button1.removeEventListener(BonusAttackMenuButton.PROGRESS_COMPLETE, button1_progressCompleteHandler);
			toolTipSequencer.registerStep(this, button1.getRect(Globals.topLevelApplication), new ToolTipInfo(this, new ToolTipSimpleContentDescriptor("NEW POWER!", ["Drop it over your enemies!"], null, new FontDescriptor(14, 0xF13030, FontResources.KOMTXTB)), ToolTipInfo.POSITION_TOP, false, 0, -80, 20, 0), HintToolTip, this.parent.parent);
		}
		
		private function button2_progressCompleteHandler(event:Event):void
		{
			button2.removeEventListener(BonusAttackMenuButton.PROGRESS_COMPLETE, button2_progressCompleteHandler);
			toolTipSequencer.registerStep(this, button2.getRect(Globals.topLevelApplication), new ToolTipInfo(this, new ToolTipSimpleContentDescriptor("NEW POWER!", ["Drag and drop to define a patrol area!"], null, new FontDescriptor(14, 0x0114FE, FontResources.KOMTXTB)), ToolTipInfo.POSITION_TOP, false, 60, -92, 80, 0), HintToolTip, this.parent.parent);
		}
		
		/////////////////////
		
		public function notifySettingsChanged(propertyName:String):void
		{
			if (propertyName == "enableTooltips")
				updateToolTips();
		}
		
		private function updateToolTips():void
		{
			// remove previous tooltips
			ToolTipService.removeAllTooltipsForComponent(button1);
			ToolTipService.removeAllTooltipsForComponent(button2);
			
			if (GameSettings.enableTooltips)
			{
				// adding new tooltips
				if (currentDevInfo.bombSupportLevel > -1)
					ToolTipService.setToolTip(button1, new ToolTipInfo(button1, new ToolTipSimpleContentDescriptor("Bomb support [" + HotKeys.BOMB_SUPPORT + "]", ["Drop a bomb on your enemies!", "Reload: " + int(WeaponContants.DEFAULT_BOMB_COOL_DOWN / 1000 * DifficultyConfig.currentBonusInfo.bombSupportCoolDownCoefficient) + " s."])), InGameHintToolTip);
				else
				{
					if (currentLevelMode == ModeSettings.MODE_NORMAL)
						ToolTipService.setToolTip(button1, new ToolTipInfo(button1, new ToolTipSimpleContentDescriptor("Locked Feature!", ["Earn stars and unlock new features in the 'Development Center'."])), InGameHintToolTip);
					else
						ToolTipService.setToolTip(button1, new ToolTipInfo(button1, new ToolTipSimpleContentDescriptor("Locked Feature!", ["Not allowed for this mode."])), InGameHintToolTip);
				}
				
				if (currentDevInfo.airSupportLevel > -1)
					ToolTipService.setToolTip(button2, new ToolTipInfo(button2, new ToolTipSimpleContentDescriptor("Air support [" + HotKeys.AIR_SUPPORT + "]", ["Call a plane to support your towers!", "Reload: " + int(WeaponContants.DEFAULT_AIR_SUPPORT_COOL_DOWN / 1000 * DifficultyConfig.currentBonusInfo.airSupportCoolDownCoefficient) + " s."])), InGameHintToolTip);
				else
				{
					if (currentLevelMode == ModeSettings.MODE_NORMAL)
						ToolTipService.setToolTip(button2, new ToolTipInfo(button2, new ToolTipSimpleContentDescriptor("Locked Feature!", ["Earn stars and unlock new features in the 'Development Center'."])), InGameHintToolTip);
					else
						ToolTipService.setToolTip(button2, new ToolTipInfo(button2, new ToolTipSimpleContentDescriptor("Locked Feature!", ["Not allowed for this mode."])), InGameHintToolTip);
				}
			}
		}
		
		public function notifyGameStarted():void
		{
			button1.restartProgress();
			button2.restartProgress();
		
			//button1.removeBlockScreen();
			//button2.removeBlockScreen();
		}
		
		/////////////////////
		
		public function supportIsBeingUsed():Boolean
		{
			return oneItemIsBeingUsed;
		}
		
		public function tryCallBombAttack():Boolean
		{
			if (button1.isBlocked || oneItemIsBeingUsed)
				return false;
			
			button1_mouseDownHandler(null);
			
			// if a user used the keyboard for the first time to call bombs
			toolTipSequencer.clearSequence();
			//if (toolTipSequencer.getComponentForCurrentStep() == button1)
			//	toolTipSequencer.completeCurrentStepAndGoToNextOne();
			
			return true;
		}
		
		public function tryCallAirSupport():Boolean
		{
			if (button2.isBlocked || oneItemIsBeingUsed)
				return false;
			
			button2_mouseDownHandler(null);
			
			// if a user used the keyboard for the first time to call air support
			toolTipSequencer.clearSequence();
			//if (toolTipSequencer.getComponentForCurrentStep() == button2)
			//	toolTipSequencer.completeCurrentStepAndGoToNextOne();
			
			return true;
		}
		
		// to prevent clicking on two buttons
		private var oneItemIsBeingUsed:Boolean = false;
		
		private function button1_mouseDownHandler(event:MouseEvent):void
		{
			if (button1.isBlocked || oneItemIsBeingUsed)
				return;
			
			oneItemIsBeingUsed = true;
			
			button1.showBlockScreen();
			
			bombSupportPointer.attachToCursor(true);
			bombSupportPointer.addMouseSensitivity();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_bombSupport_MouseUpHandler, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			
			Globals.topLevelApplication.addChild(bombSupportPointer);
			
			weaponInfoBar.showWarningMessage("Press ESC to cancel");
			//dispatchEvent(new Event(SUPPORT_AIMING_STARTED));
			
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_TAP);
		}
		
		///////////////////////////////////////
		
		private var explosionX:Number = 0;
		
		private var explosionY:Number = 0;
		
		private function stage_bombSupport_MouseUpHandler(event:MouseEvent):void
		{
			// prevent dropping bomb on menu
			if (MouseUtil.isMouseOver(this))
			{
				clearStage();
				return;
			}
			
			explosionX = event.stageX + pointerOffsetX;
			explosionY = event.stageY + pointerOffsetY;
			AnimationEngine.globalAnimator.animateBubbling([bombSupportPointer], 200, AnimationEngine.globalAnimator.currentTime, EasingFunction.decreaseLinear);
			AnimationEngine.globalAnimator.executeFunction(bombSupportPointerAnimationFinished, null, AnimationEngine.globalAnimator.currentTime + 200);
			
			AchievementsController.notifyBombDropped(explosionX, explosionY);
		
			//dispatchEvent(new Event(SUPPORT_CALLED));
		}
		
		private function bombSupportPointerAnimationFinished():void
		{
			clearStage();
			
			BombLauncher.launchBomb(explosionX, explosionY, button1.currentLevel);
			button1.restartProgress();
		}
		
		/////////////////////////////////////
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ESCAPE)
			{
				//dispatchEvent(new Event(SUPPORT_CANCELED));
				clearStage();
			}
		}
		
		////////////////////////
		
		private function button2_mouseDownHandler(event:MouseEvent):void
		{
			if (button2.isBlocked || oneItemIsBeingUsed)
				return;
			
			oneItemIsBeingUsed = true;
			
			button2.showBlockScreen();
			
			// calling air support
			airSupportPointer.attachToCursor(true);
			airSupportPointer.addMouseSensitivity();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_airSupport_MouseUpHandler, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			
			Globals.topLevelApplication.addChild(airSupportPointer);
			
			weaponInfoBar.showWarningMessage("Press ESC to cancel");
			//dispatchEvent(new Event(SUPPORT_AIMING_STARTED));
			
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_TAP);
		}
		
		///////////////////////////////////////
		
		private var airSupportDispatchLocationX:Number = 0;
		
		private var airSupportDispatchLocationY:Number = 0;
		
		private function stage_airSupport_MouseUpHandler(event:MouseEvent):void
		{
			// prevent dropping bomb on menu
			if (MouseUtil.isMouseOver(this))
			{
				clearStage();
				return;
			}
			
			airSupportDispatchLocationX = event.stageX + pointerOffsetX;
			airSupportDispatchLocationY = event.stageY + pointerOffsetY;
			AnimationEngine.globalAnimator.animateBubbling([airSupportPointer], 200, AnimationEngine.globalAnimator.currentTime, EasingFunction.decreaseLinear);
			AnimationEngine.globalAnimator.executeFunction(airSupportPointerAnimationFinished, null, AnimationEngine.globalAnimator.currentTime + 200);
		
			//dispatchEvent(new Event(SUPPORT_CALLED));
		}
		
		private function airSupportPointerAnimationFinished():void
		{
			clearStage();
			
			dispatchEvent(new BonusAttackMenuEvent(BonusAttackMenuEvent.LAUNCH_AIRCRAFT, airSupportDispatchLocationX, airSupportDispatchLocationY, button2.currentLevel));
			
			button2.restartProgress();
			
			AchievementsController.notifyAirSupportCalled(airSupportDispatchLocationX, airSupportDispatchLocationY);
		}
		
		////////////////////////
		
		private function clearStage():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_bombSupport_MouseUpHandler, true);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_airSupport_MouseUpHandler, true);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			
			if (Globals.topLevelApplication.contains(bombSupportPointer))
				Globals.topLevelApplication.removeChild(bombSupportPointer);
			
			if (Globals.topLevelApplication.contains(airSupportPointer))
				Globals.topLevelApplication.removeChild(airSupportPointer);
			
			bombSupportPointer.removeMouseSensitivity();
			airSupportPointer.removeMouseSensitivity();
			
			button1.removeBlockScreen();
			button2.removeBlockScreen();
			
			oneItemIsBeingUsed = false;
			
			weaponInfoBar.showWarningMessage(null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods: game bot
		//
		//--------------------------------------------------------------------------
		
		private function configureBot():void
		{
			GameBot.canDropBomb = function():Boolean
			{
				return (!button1.isBlocked && !oneItemIsBeingUsed)
			}
			
			GameBot.dropBombAt = function(xPosition:Number, yPosition:Number):void
			{
				if (button1.isBlocked || oneItemIsBeingUsed)
					return;
				
				oneItemIsBeingUsed = true;
				
				button1.showBlockScreen();
				
				clearStage();
				
				BombLauncher.launchBomb(xPosition, yPosition, button1.currentLevel);
				button1.restartProgress();
				
				AchievementsController.notifyBombDropped(xPosition, yPosition);
			}
			
			GameBot.dispatchAirSupportAt = function(xPosition:Number, yPosition:Number):void
			{
				if (button2.isBlocked || oneItemIsBeingUsed)
					return;
				
				oneItemIsBeingUsed = true;
				
				button2.showBlockScreen();
				
				clearStage();
				
				dispatchEvent(new BonusAttackMenuEvent(BonusAttackMenuEvent.LAUNCH_AIRCRAFT, xPosition, yPosition, button2.currentLevel));
				
				button2.restartProgress();
				
				AchievementsController.notifyAirSupportCalled(xPosition, yPosition);
			}
		}
	
	}

}