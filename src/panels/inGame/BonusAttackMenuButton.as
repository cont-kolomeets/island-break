/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import constants.WeaponContants;
	import controllers.SoundController;
	import flash.display.Bitmap;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import infoObjects.WeaponInfo;
	import mainPack.DifficultyConfig;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.events.ProgressBarEvent;
	import nslib.controls.NSSprite;
	import nslib.utils.ImageUtil;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.WeaponResources;
	import supportControls.progressBars.RectangleProgressBar;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class BonusAttackMenuButton extends NSSprite
	{
		public static const PROGRESS_COMPLETE:String = "progressComplete";
		
		public static const TYPE_AIR_SUPPORT:String = "airSupport";
		
		public static const TYPE_BOMB_SUPPORT:String = "bombSupport";
		
		////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/support button base.png")]
		private static var supportButtonBaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/support button base highlighted.png")]
		private static var supportButtonBaseHighlightedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/support button base closed.png")]
		private static var supportButtonBaseClosedImage:Class;
		
		////////////////
		
		public var currentLevel:int = 0;
		
		/// position constants
		
		private const highlightBGPosition:int = 0;
		
		private const iconPosition:int = 1;
		
		private const blockScreenPosition:int = 2;
		
		private const progressBarPosition:int = 3;
		
		private const framePosition:int = 4;
		
		///
		
		private var progressBar:RectangleProgressBar = new RectangleProgressBar();
		
		private var baseBM:Bitmap = new supportButtonBaseImage();
		
		private var baseHighlightedBM:Bitmap = new supportButtonBaseHighlightedImage();
		
		private var baseClosedBM:Bitmap = new supportButtonBaseClosedImage();
		
		// screen to indiate that the support is currently used (after a click and
		// before setting a location)
		private var screen:Shape = new Shape();
		
		// when an item is ready this will highlight it
		private var highlightBackground:Shape = new Shape();
		
		private var type:String = null;
		
		private var delay:Number = 0;
		
		// if the button was just reset is stays disabled until the progress starts.
		private var justReset:Boolean = false;
		
		////////////////
		
		public function BonusAttackMenuButton(type:String)
		{
			super();
			
			mouseEnabled = true;
			mouseChildren = false;
			
			this.type = type;
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
		}
		
		///////////////
		
		// returns true if the button is not available now for some reasons
		public function get isBlocked():Boolean
		{
			return ((currentLevel == -1) || progressBar.running || screen.visible || justReset);
		}
		
		/////////////
		
		public function get weaponInfo():WeaponInfo
		{
			var weaponId:String = (type == TYPE_AIR_SUPPORT) ? WeaponResources.USER_AIR_SUPPORT : WeaponResources.USER_BOMB_SUPPORT;
			return WeaponResources.getWeaponInfoByIDAndLevel(weaponId, currentLevel);
		}
		
		////////////////
		
		// if you set -1, a gray image will be displayed
		public function createButtonForLevel(level:int = -1):void
		{
			if (DifficultyConfig.currentBonusInfo)
				delay = (type == TYPE_AIR_SUPPORT) ? (WeaponContants.DEFAULT_AIR_SUPPORT_COOL_DOWN * DifficultyConfig.currentBonusInfo.airSupportCoolDownCoefficient) : (WeaponContants.DEFAULT_BOMB_COOL_DOWN * DifficultyConfig.currentBonusInfo.bombSupportCoolDownCoefficient);
			
			currentLevel = level;
			disableInteractability();
			
			justReset = true;
			
			removeAllChildren();
			
			if (level == -1)
				addChild(baseClosedBM);
			else
			{
				// adding highlight background
				var matrix:Matrix = new Matrix();
				matrix.createGradientBox(60, 60, 0, 0, 0);
				
				highlightBackground.cacheAsBitmap = true;
				highlightBackground.graphics.clear();
				highlightBackground.graphics.beginGradientFill(GradientType.RADIAL, [0xFFFFFF, type == TYPE_BOMB_SUPPORT ? 0x9C0A0A : 0x007EAE], [1, 1], null, matrix);
				highlightBackground.graphics.drawRect(12, 12, 36, 38);
				
				addChild(highlightBackground);
				
				// adding icon
				var icon:Bitmap = null;
				icon = new weaponInfo.iconSmall() as Bitmap;
				icon.smoothing = true;
				
				var widthToFit:Number = 40;
				
				// adjusting for specific weapon types
				if (weaponInfo.weaponId == WeaponResources.USER_BOMB_SUPPORT && weaponInfo.level == 0)
					widthToFit = 36;
				
				ImageUtil.scaleToFitWidth(icon, widthToFit);
				
				// centering the icon
				icon.x = (baseBM.width - icon.width) / 2;
				icon.y = (baseBM.height - icon.height) / 2;
				
				addChild(icon);
				
				//adding screen
				screen.graphics.clear();
				screen.graphics.beginFill(0, 0.5);
				screen.graphics.drawRect(12, 12, 36, 38);
				
				screen.visible = false;
				addChild(screen);
				
				// adding progress bar
				progressBar.barWidth = 36;
				progressBar.barHeight = 38;
				progressBar.x = 12;
				progressBar.y = 12;
				
				addChild(progressBar);
				
				// adding frames
				baseBM.visible = true;
				addChild(baseBM);
				
				baseHighlightedBM.visible = false;
				addChild(baseHighlightedBM);
			}
			
			// need to reset the progress bar after configuring
			progressBar.reset();
		}
		
		private function disableInteractability():void
		{
			//highlightBackground.visible = false;
			//mouseEnabled = false;
			buttonMode = false;
		}
		
		private function updateButtonInteractability():void
		{
			//highlightBackground.visible = !isBlocked;
			//mouseEnabled = !isBlocked;
			buttonMode = !isBlocked;
		}
		
		public function reset():void
		{
			progressBar.reset();
			
			justReset = true;
			
			updateButtonInteractability();
		}
		
		public function restartProgress():void
		{
			progressBar.reset();
			
			if (currentLevel == -1)
				return;
			
			progressBar.start(delay);
			
			justReset = false;
			
			progressBar.addEventListener(ProgressBarEvent.PROGRESS_COMPLETE, progressBar_progressCompleteHandler);
			
			updateButtonInteractability();
		}
		
		private function progressBar_progressCompleteHandler(event:ProgressBarEvent):void
		{
			progressBar.removeEventListener(ProgressBarEvent.PROGRESS_COMPLETE, progressBar_progressCompleteHandler);
			
			SoundController.instance.playSound(SoundResources.SOUND_SUPPORT_READY);
			
			// switching images
			baseBM.visible = false;
			baseHighlightedBM.visible = true;
			
			AnimationEngine.globalAnimator.executeFunction(placeIconBack, null, AnimationEngine.globalAnimator.currentTime + 1000);
			
			updateButtonInteractability();
			
			if (hasEventListener(PROGRESS_COMPLETE))
				dispatchEvent(new Event(PROGRESS_COMPLETE));
		}
		
		private function placeIconBack():void
		{
			// switching images back
			baseBM.visible = true;
			baseHighlightedBM.visible = false;
		}
		
		private function mouseOverHandler(event:MouseEvent):void
		{
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_HOVER);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			progressBar.reset();
		}
		
		//////////////////
		
		public function showBlockScreen():void
		{
			// no reason to block the button if there is nothing in it
			screen.visible = true;
			
			updateButtonInteractability();
		}
		
		public function removeBlockScreen():void
		{
			screen.visible = false;
			
			updateButtonInteractability();
		}
	}

}