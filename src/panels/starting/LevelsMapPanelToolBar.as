/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import mainPack.GameSettings;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportControls.toolTips.HintToolTip;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class LevelsMapPanelToolBar extends NSSprite
	{
		//////
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button dev center normal.png")]
		private static var buttonDevCenterNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button dev center over.png")]
		private static var buttonDevCenterOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button dev center down.png")]
		private static var buttonDevCenterDownImage:Class;
		
		//////
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button encyclopedia normal.png")]
		private static var buttonEncyclopediaNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button encyclopedia over.png")]
		private static var buttonEncyclopediaOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button encyclopedia down.png")]
		private static var buttonEncyclopediaDownImage:Class;
		
		//////
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button achievements normal.png")]
		private static var buttonAchievementsNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button achievements over.png")]
		private static var buttonAchievementsOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button achievements down.png")]
		private static var buttonAchievementsDownImage:Class;
		
		//////
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button back normal.png")]
		private static var buttonBackNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button back over.png")]
		private static var buttonBackOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/map/button back down.png")]
		private static var buttonBackDownImage:Class;
		
		//////////////////
		
		// creating buttons
		public var devCenterButton:Button = new Button();
		
		public var encyclopediaButton:Button = new Button();
		
		public var achievementsButton:Button = new Button();
		
		public var backButton:Button = new Button();
		
		public var upgradeAvailableButton:UpgradeAvailableButton = new UpgradeAvailableButton();
		
		///// flags
		
		private var showingFirstAvaiableToolTipFlag:Boolean = false;
		
		//////////////////
		
		public function LevelsMapPanelToolBar()
		{
			construct();
		}
		
		//////////////////
		
		private function construct():void
		{
			backButton.x = 5;
			backButton.y = 75;
			ControlConfigurator.configureButton(backButton, buttonBackNormalImage, buttonBackOverImage, buttonBackDownImage)
			addChild(backButton);
			
			devCenterButton.x = 260;
			devCenterButton.y = 0;
			devCenterButton.considerOnlyBoundsForMouseEvents = true;
			ControlConfigurator.configureButton(devCenterButton, buttonDevCenterNormalImage, buttonDevCenterOverImage, buttonDevCenterDownImage);
			
			upgradeAvailableButton.x = 340;
			upgradeAvailableButton.y = 50;
			upgradeAvailableButton.visible = false;
			
			encyclopediaButton.x = 380;
			encyclopediaButton.y = 0;
			ControlConfigurator.configureButton(encyclopediaButton, buttonEncyclopediaNormalImage, buttonEncyclopediaOverImage, buttonEncyclopediaDownImage);
			
			achievementsButton.x = 500;
			achievementsButton.y = 4;
			ControlConfigurator.configureButton(achievementsButton, buttonAchievementsNormalImage, buttonAchievementsOverImage, buttonAchievementsDownImage);
			
			addChild(devCenterButton);
			addChild(encyclopediaButton);
			addChild(achievementsButton);
			addChild(upgradeAvailableButton);
		}
		
		public function startAnimation():void
		{
			AnimationEngine.globalAnimator.animateProperty([backButton, devCenterButton, encyclopediaButton, achievementsButton], "alpha", 0, 1, NaN, 550, AnimationEngine.globalAnimator.currentTime);
			
			var offset:Number = -50;
			setMouseEnabled(false);
			
			AnimationEngine.globalAnimator.moveObjects(backButton, backButton.x, backButton.y - offset, backButton.x, backButton.y, 500, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.moveObjects(devCenterButton, devCenterButton.x, devCenterButton.y - offset, devCenterButton.x, devCenterButton.y, 500, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.moveObjects(encyclopediaButton, encyclopediaButton.x, encyclopediaButton.y - offset, encyclopediaButton.x, encyclopediaButton.y, 500, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.moveObjects(achievementsButton, achievementsButton.x, achievementsButton.y - offset, achievementsButton.x, achievementsButton.y, 500, AnimationEngine.globalAnimator.currentTime);
			AnimationEngine.globalAnimator.executeFunction(setMouseEnabled, [true], AnimationEngine.globalAnimator.currentTime + 550);
		}
		
		public function notifyNewUpgradesAvailable(showFirstAvailableToolTip:Boolean = false, numStarsAvailable:int = -1):void
		{
			upgradeAvailableButton.visible = true;
			AnimationEngine.globalAnimator.animateProperty(upgradeAvailableButton, "alpha", 0, 1, NaN, 500);
			AnimationEngine.globalAnimator.animateConstantWaving([upgradeAvailableButton], 300, NaN, 1);
			
			
			if (!showFirstAvailableToolTip)
				ToolTipService.setToolTip(upgradeAvailableButton, new ToolTipInfo(upgradeAvailableButton, new ToolTipSimpleContentDescriptor("NEW UPGRADES AVAILABLE!", null, null, new FontDescriptor(14, 0x2722FF, FontResources.KOMTXTB))), HintToolTip);
			else
			{
				// show first updates available tooltip

				showingFirstAvaiableToolTipFlag = true;
				ToolTipService.removeAllTooltipsForComponent(devCenterButton);
				var starsCorrectEnding:String = numStarsAvailable > 1 ? " STARS!" : " STAR!";
				var tooltip:* = ToolTipService.setTooltipWaitingForClick(devCenterButton, new ToolTipInfo(devCenterButton, new ToolTipSimpleContentDescriptor("YOU HAVE EARNED " + numStarsAvailable + starsCorrectEnding, ["Make some upgrades in the 'Development Center'!"], null, new FontDescriptor(14, 0x2722FF, FontResources.KOMTXTB))), HintToolTip, this.parent);
				AnimationEngine.globalAnimator.animateConstantBubbling([tooltip], 500, AnimationEngine.globalAnimator.currentTime, 0.1);
			}
		}
		
		private function setMouseEnabled(value:Boolean):void
		{
			backButton.mouseEnabled = value;
			devCenterButton.mouseEnabled = value;
			encyclopediaButton.mouseEnabled = value;
			achievementsButton.mouseEnabled = value;
		}
		
		public function showTooltips():void
		{
			// setting tooltips
			if (GameSettings.enableTooltips)
			{
				var desc1:ToolTipSimpleContentDescriptor = new ToolTipSimpleContentDescriptor("Development Center", ["Visit to develop new types of weapon."], null, new FontDescriptor(12, 0xF13030, FontResources.YARDSALE));
				var desc2:ToolTipSimpleContentDescriptor = new ToolTipSimpleContentDescriptor("Encyclopedia", ["Find out more about the game."], null, new FontDescriptor(12, 0xF13030, FontResources.YARDSALE));
				var desc3:ToolTipSimpleContentDescriptor = new ToolTipSimpleContentDescriptor("Achievements", ["See a list of your achievements."], null, new FontDescriptor(12, 0xF13030, FontResources.YARDSALE));
				
				if (!showingFirstAvaiableToolTipFlag)
					ToolTipService.setToolTip(devCenterButton, new ToolTipInfo(devCenterButton, desc1), HintToolTip);
				
				ToolTipService.setToolTip(encyclopediaButton, new ToolTipInfo(encyclopediaButton, desc2), HintToolTip);
				ToolTipService.setToolTip(achievementsButton, new ToolTipInfo(achievementsButton, desc3), HintToolTip);
			}
			else
				hideToolTips();
		}
		
		public function hideToolTips():void
		{
			// stopping animation for the first available tooltip if some exists
			var tooltip:* = ToolTipService.getToolTipAssignedForComponent(devCenterButton);
			AnimationEngine.globalAnimator.stopAnimationForObject(tooltip);
			showingFirstAvaiableToolTipFlag = false;
			
			ToolTipService.removeAllTooltipsForComponent(devCenterButton);
			ToolTipService.removeAllTooltipsForComponent(encyclopediaButton);
			ToolTipService.removeAllTooltipsForComponent(achievementsButton);
			
			AnimationEngine.globalAnimator.stopAnimationForObject(upgradeAvailableButton);
			ToolTipService.removeAllTooltipsForComponent(upgradeAvailableButton);
			upgradeAvailableButton.visible = false;
		
		}
	
	}

}