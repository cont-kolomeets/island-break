/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.base.supportClasses
{
	import constants.WeaponContants;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	import supportClasses.WeaponType;
	import supportControls.progressBars.SectorProgressBar;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class WeaponIndicatorsVisualizer
	{
		public var weapon:Weapon = null;
		
		public var energyBar:Shape = new Shape();
		
		private var preferencesIndicator:Shape = new Shape();
		
		private var invincibilityShield:Shape = new Shape();
		
		private var buildingProgressBar:SectorProgressBar = new SectorProgressBar();
		
		/////////
		
		public function WeaponIndicatorsVisualizer()
		{
		}
		
		///////////
		
		//// energy bar
		
		public function updateEnergyBar(currentEnergy:Number, maxEnergy:Number):void
		{
			energyBar.visible = weapon.isPlaced;
			
			// default implementation
			energyBar.graphics.clear();
			energyBar.graphics.lineStyle(1, 0x555555);
			energyBar.graphics.drawRect(-10, -25, 20, 5);
			
			energyBar.graphics.lineStyle(0);
			energyBar.graphics.beginFill(0x00FF00);
			energyBar.graphics.drawRect(-10, -25, 20 * currentEnergy / maxEnergy, 5);
			
			energyBar.graphics.beginFill(0xAAAAAA);
			energyBar.graphics.drawRect(-10 + 20 * currentEnergy / maxEnergy, -25, 20 * (maxEnergy - currentEnergy) / maxEnergy, 5);
		}
		
		//// preference indicator
		
		public function updatePreferenceIndicator():void
		{
			if (weapon.contains(preferencesIndicator))
				weapon.removeChild(preferencesIndicator);
			
			preferencesIndicator.graphics.clear();
			var color:int = -1;
			
			if (weapon.preferenceDescriptor.preferredPathIndex == 0)
				color = 0xF84E4E;
			else if (weapon.preferenceDescriptor.preferredPathIndex == 1)
				color = 0x2864FF;
			else if (weapon.preferenceDescriptor.selectionTypePreference == WeaponPreferenceDescriptor.SELECTION_TYPE_AIR)
				color = 0x49EEFC;
			
			if (color == -1)
				return;
			
			preferencesIndicator.graphics.lineStyle(1, 0x222222);
			preferencesIndicator.graphics.beginFill(color, 1);
			preferencesIndicator.graphics.drawRect(-19, -25, 5, 5);
			
			weapon.addChild(preferencesIndicator);
		}
		
		//// building progress
		
		public function showBuildingProgress():void
		{
			// start the progress bar with the same time as the building timer
			buildingProgressBar.start(WeaponContants.DEFAULT_BUILDING_DELAY);
			
			weapon.addChild(buildingProgressBar);
		}
		
		public function removeBuildingProgress():void
		{
			if (weapon.contains(buildingProgressBar))
				weapon.removeChild(buildingProgressBar);
		}
		
		//------------------------------------------
		// frozen cap
		//------------------------------------------
		
		[Embed(source="F:/Island Defence/media/images/common images/frozen cap.png")]
		private static var frozenCapImage:Class;
		
		private var frozenCap:Bitmap;
		
		public function get isFrozen():Boolean
		{
			return frozenCap && weapon.contains(frozenCap);
		}
		
		public function addFrozenCap():void
		{
			// adding a frozen cap image
			if (!frozenCap)
			{
				frozenCap = new frozenCapImage() as Bitmap;
				frozenCap.x = -frozenCap.width / 2;
				frozenCap.y = -frozenCap.height / 2;
			}
			
			weapon.addChild(frozenCap);
		}
		
		public function removeFrozenCap():void
		{
			if (isFrozen)
				weapon.removeChild(frozenCap);
		}
		
		//------------------------------------------
		// Working with active enemy indicator
		//------------------------------------------
		
		[Embed(source="F:/Island Defence/media/images/common images/active enemy aim.png")]
		private static var aimImage:Class;
		
		private var aimBM:Bitmap;
		
		private var aimContainer:NSSprite;
		
		public function get isIndicatedAsAcitveEnemy():Boolean
		{
			return aimContainer && aimBM && weapon.contains(aimContainer);
		}
		
		// TO DO do not use bitmap filters
		public function showActiveEnemyIndicator(value:Boolean):void
		{
			// active enemy indicator is preferrable
			if (value && isIndicatedAsHovered)
				showHoveredOverIndicator(false);
			
			if (value)
			{
				if (!aimBM)
				{
					aimContainer = new NSSprite();
					aimBM = new aimImage() as Bitmap;
					aimBM.x = -aimBM.width / 2;
					aimBM.y = -aimBM.height / 2;
					aimBM.smoothing = true;
					aimContainer.addChild(aimBM);
				}
				
				weapon.addChild(aimContainer);
				AnimationEngine.globalAnimator.animateConstantBubbling([aimContainer], 300, NaN, 0.5);
			}
			else
			{
				if (aimContainer)
				{
					if (weapon.contains(aimContainer))
						weapon.removeChild(aimContainer);
					
					AnimationEngine.globalAnimator.stopAnimationForObject(aimContainer);
				}
			}
		}
		
		//------------------------------------------
		// Working with hovered indicator
		//------------------------------------------
		
		private var hoverContainer:Shape;
		
		private var isHovered:Boolean = false;
		
		public function get isIndicatedAsHovered():Boolean
		{
			return isHovered;
		}
		
		// TO DO do not use bitmap filters
		public function showHoveredOverIndicator(value:Boolean):void
		{
			if (value == isHovered || !weapon.isPlaced || !weapon.isBuilt)
				return;
			
			// active enemy indicator is preferrable
			if (value && isIndicatedAsAcitveEnemy)
				return;
			
			if (value)
			{
				if (!hoverContainer)
				{
					hoverContainer = new Shape();
					hoverContainer.graphics.lineStyle(2, weapon.currentInfo.weaponType == WeaponType.USER ? 0x4BE70A : 0xE10909);
					hoverContainer.graphics.moveTo(-20, -15);
					hoverContainer.graphics.lineTo(-20, -20);
					hoverContainer.graphics.lineTo(-15, -20);
					
					hoverContainer.graphics.moveTo(20, -15);
					hoverContainer.graphics.lineTo(20, -20);
					hoverContainer.graphics.lineTo(15, -20);
					
					hoverContainer.graphics.moveTo(20, 15);
					hoverContainer.graphics.lineTo(20, 20);
					hoverContainer.graphics.lineTo(15, 20);
					
					hoverContainer.graphics.moveTo(-20, 15);
					hoverContainer.graphics.lineTo(-20, 20);
					hoverContainer.graphics.lineTo(-15, 20);
				}
				
				weapon.addChild(hoverContainer);
				AnimationEngine.globalAnimator.animateConstantBubbling([hoverContainer], 300, NaN, 0.3);
				
				isHovered = true;
			}
			else
			{
				if (hoverContainer)
				{
					if (weapon.contains(hoverContainer))
						weapon.removeChild(hoverContainer);
					
					AnimationEngine.globalAnimator.stopAnimationForObject(hoverContainer);
					hoverContainer.scaleX = 1;
					hoverContainer.scaleY = 1;
				}
				
				isHovered = false;
			}
		}
		
		//------------------------------------------
		// Working with upgrade available indicator
		//------------------------------------------
		
		private var upgradeIndicatorDuraction:Number = 1000;
		
		private var upgradeIndicatorContanerEnabled:Shape = null;
		
		private var upgradeIndicatorContanerDisabled:Shape = null;
		
		private var updradeIndicatorShown:Boolean = false;
		
		private var updradeIndicatorShownEnabled:Boolean = false;
		
		private var containerArray:Array = null;
		
		private var lastLevelWhenShown:int = -1;
		
		private var upgradeIndicatorX:int = 17;
		
		private var upgradeIndicatorY:int = -20;
		
		public function configureUgradeAvailableIndicator(show:Boolean, enoughMoney:Boolean):void
		{
			if (show)
			{
				// prepare both
				if (!upgradeIndicatorContanerEnabled)
				{
					upgradeIndicatorContanerEnabled = new Shape();
					upgradeIndicatorContanerEnabled.cacheAsBitmap = true;
					upgradeIndicatorContanerEnabled.graphics.lineStyle(1, 0x1F4800);
					upgradeIndicatorContanerEnabled.graphics.beginFill(0x57CC00, 0.7);
					
					upgradeIndicatorContanerEnabled.graphics.moveTo(0, -5);
					upgradeIndicatorContanerEnabled.graphics.lineTo(4, 2);
					upgradeIndicatorContanerEnabled.graphics.lineTo(-4, 2);
					upgradeIndicatorContanerEnabled.graphics.lineTo(0, -5);
					
					upgradeIndicatorContanerEnabled.x = upgradeIndicatorX;
					upgradeIndicatorContanerEnabled.y = upgradeIndicatorY;
					
					containerArray = [upgradeIndicatorContanerEnabled];
				}
				
				if (!upgradeIndicatorContanerDisabled)
				{
					upgradeIndicatorContanerDisabled = new Shape();
					upgradeIndicatorContanerDisabled.cacheAsBitmap = true;
					upgradeIndicatorContanerDisabled.graphics.lineStyle(1, 0x570404);
					upgradeIndicatorContanerDisabled.graphics.beginFill(0xCB2121, 0.7);
					
					upgradeIndicatorContanerDisabled.graphics.moveTo(0, -5);
					upgradeIndicatorContanerDisabled.graphics.lineTo(4, 2);
					upgradeIndicatorContanerDisabled.graphics.lineTo(-4, 2);
					upgradeIndicatorContanerDisabled.graphics.lineTo(0, -5);
					
					upgradeIndicatorContanerDisabled.x = upgradeIndicatorX;
					upgradeIndicatorContanerDisabled.y = upgradeIndicatorY;
				}
				
				if (!updradeIndicatorShown || (lastLevelWhenShown != weapon.currentInfo.level))
				{
					weapon.addChild(upgradeIndicatorContanerEnabled);
					weapon.addChild(upgradeIndicatorContanerDisabled);
					
					lastLevelWhenShown = weapon.currentInfo.level;
				}
				
				if (enoughMoney)
				{
					upgradeIndicatorContanerEnabled.visible = true;
					upgradeIndicatorContanerDisabled.visible = false;
					
					if (!updradeIndicatorShownEnabled)
						AnimationEngine.globalAnimator.animateConstantWaving([upgradeIndicatorContanerEnabled], 300, NaN, 0.5);
					
					updradeIndicatorShownEnabled = true;
				}
				else
				{
					upgradeIndicatorContanerEnabled.visible = false;
					upgradeIndicatorContanerDisabled.visible = true;
					
					if (updradeIndicatorShownEnabled)
					{
						AnimationEngine.globalAnimator.stopAnimationForObject(upgradeIndicatorContanerEnabled);
						upgradeIndicatorContanerEnabled.y = upgradeIndicatorY;
					}
					
					updradeIndicatorShownEnabled = false;
				}
				
				updradeIndicatorShown = true;
			}
			else
			{
				if (updradeIndicatorShown && upgradeIndicatorContanerEnabled && weapon.contains(upgradeIndicatorContanerEnabled))
					weapon.removeChild(upgradeIndicatorContanerEnabled);
				
				if (updradeIndicatorShown && upgradeIndicatorContanerDisabled && weapon.contains(upgradeIndicatorContanerDisabled))
					weapon.removeChild(upgradeIndicatorContanerDisabled);
				
				if (updradeIndicatorShown && upgradeIndicatorContanerEnabled)
				{
					AnimationEngine.globalAnimator.stopAnimationForObject(upgradeIndicatorContanerEnabled);
					upgradeIndicatorContanerEnabled.y = upgradeIndicatorY;
				}
				
				updradeIndicatorShown = false;
			}
		}
		
		//------------------------------------------
		// Working with preferred target
		//------------------------------------------
		
		private var preferredTargetIndicator:Shape = null;
		
		private var isIndicatingAsPreferredTarget:Boolean = false;
		
		public function indicatesAsPreferredTarget():void
		{
			if (isIndicatingAsPreferredTarget)
				return;
			
			isIndicatingAsPreferredTarget = true;
			
			if (!preferredTargetIndicator)
			{
				preferredTargetIndicator = new Shape();
				preferredTargetIndicator.cacheAsBitmap = true;
				preferredTargetIndicator.graphics.lineStyle(2, 0xEC0000, 0.8);
				
				var curX:Number = 0;
				var curY:Number = 0;
				var size:Number = 4;
				var offset:Number = 15;
				
				preferredTargetIndicator.graphics.moveTo(curX, curY - offset);
				preferredTargetIndicator.graphics.lineTo(curX + size, curY - offset - size * 1.5);
				preferredTargetIndicator.graphics.lineTo(curX - size, curY - offset - size * 1.5);
				preferredTargetIndicator.graphics.lineTo(curX, curY - offset);
				
				preferredTargetIndicator.graphics.moveTo(curX, curY + offset);
				preferredTargetIndicator.graphics.lineTo(curX + size, curY + offset + size * 1.5);
				preferredTargetIndicator.graphics.lineTo(curX - size, curY + offset + size * 1.5);
				preferredTargetIndicator.graphics.lineTo(curX, curY + offset);
				
				preferredTargetIndicator.graphics.moveTo(curX - offset, curY);
				preferredTargetIndicator.graphics.lineTo(curX - offset - size * 1.5, curY - size);
				preferredTargetIndicator.graphics.lineTo(curX - offset - size * 1.5, curY + size);
				preferredTargetIndicator.graphics.lineTo(curX - offset, curY);
				
				preferredTargetIndicator.graphics.moveTo(curX + offset, curY);
				preferredTargetIndicator.graphics.lineTo(curX + offset + size * 1.5, curY - size);
				preferredTargetIndicator.graphics.lineTo(curX + offset + size * 1.5, curY + size);
				preferredTargetIndicator.graphics.lineTo(curX + offset, curY);
			}
			
			preferredTargetIndicator.visible = true;
			
			weapon.addChild(preferredTargetIndicator);
			
			AnimationEngine.globalAnimator.executeFunction(preferredTargetIndicatorHide, null, AnimationEngine.globalAnimator.currentTime + 100);
			AnimationEngine.globalAnimator.executeFunction(preferredTargetIndicatorShow, null, AnimationEngine.globalAnimator.currentTime + 200);
			AnimationEngine.globalAnimator.executeFunction(preferredTargetIndicatorHide, null, AnimationEngine.globalAnimator.currentTime + 300);
			AnimationEngine.globalAnimator.executeFunction(preferredTargetIndicatorShow, null, AnimationEngine.globalAnimator.currentTime + 400);
			AnimationEngine.globalAnimator.executeFunction(preferredTargetIndicatorRemove, null, AnimationEngine.globalAnimator.currentTime + 500);
		}
		
		private function preferredTargetIndicatorShow():void
		{
			preferredTargetIndicator.visible = true;
		}
		
		private function preferredTargetIndicatorHide():void
		{
			preferredTargetIndicator.visible = false;
		}
		
		private function preferredTargetIndicatorRemove():void
		{
			if (weapon.contains(preferredTargetIndicator))
				weapon.removeChild(preferredTargetIndicator);
			
			isIndicatingAsPreferredTarget = false;
		}
	
	}

}