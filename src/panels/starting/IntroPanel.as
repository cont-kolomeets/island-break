/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import constants.GamePlayConstants;
	import controllers.SoundController;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.CustomTextField;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import panels.PanelBase;
	import panels.starting.SoundControlPanel;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.SoundResources;
	import supportClasses.SponsorInfoGenerator;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * Has: the face image, a title, and a "Start Button".
	 * Takes as info: nothing.
	 */
	public class IntroPanel extends PanelBase
	{
		public static const START_CLICKED:String = "startClicked";
		
		public static const CREDITS_CLICKED:String = "creditsClicked";
		
		/////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/base.jpg")]
		private static var baseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/game title.png")]
		private static var gameTitleImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/palms.png")]
		private static var palmsImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/tank left.png")]
		private static var leftTankImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/tank right.png")]
		private static var rightTankImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/rocket left.png")]
		private static var leftRocketImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/rocket right.png")]
		private static var rightRocketImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/aim.png")]
		private static var aimImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/plane.png")]
		private static var planeImage:Class;
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/play button normal.png")]
		private static var playButtonNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/play button over.png")]
		private static var playButtonOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/play button down.png")]
		private static var playButtonDownImage:Class;
		
		///////////////////
		
		// animated parts
		private var whiteScreen:Shape = new Shape();
		
		private var gameTitle:Bitmap = new gameTitleImage() as Bitmap;
		private var gameTitleContainer:NSSprite = new NSSprite();
		private var palms:Bitmap = new palmsImage() as Bitmap;
		private var palmsContainer:NSSprite = new NSSprite();
		private var leftTank:Bitmap = new leftTankImage() as Bitmap;
		private var rightTank:Bitmap = new rightTankImage() as Bitmap;
		private var leftRocket:Bitmap = new leftRocketImage() as Bitmap;
		private var rightRocket:Bitmap = new rightRocketImage() as Bitmap;
		private var aim:Bitmap = new aimImage() as Bitmap;
		private var plane:Bitmap = new planeImage() as Bitmap;
		
		// interactable parts
		private var playButton:Button = new Button();
		private var soundController:SoundControlPanel = new SoundControlPanel();
		private var sponsorPanel:IntroPanelLinkPanel = new IntroPanelLinkPanel(IntroPanelLinkPanel.TYPE_SPONSOR);
		private var creditsPanel:IntroPanelLinkPanel = new IntroPanelLinkPanel(IntroPanelLinkPanel.TYPE_CREDITS);
		
		/// flags
		
		private var animationShownOnce:Boolean = false;
		
		///////////////////
		
		public function IntroPanel()
		{
			construct();
		}
		
		//////////////
		
		private function construct():void
		{
			addChild(new baseImage() as Bitmap);
			
			ControlConfigurator.configureButton(playButton, playButtonNormalImage, playButtonOverImage, playButtonDownImage);
			
			soundController.x = 10;
			soundController.y = 3;
			
			whiteScreen.graphics.beginFill(0xFFFFFF);
			whiteScreen.graphics.drawRect(0, 0, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			
			addChild(soundController);
			
			var versionLabel:CustomTextField = new CustomTextField("v." + GamePlayConstants.GAME_VERSION, new FontDescriptor(10, 0xAAAAAA, FontResources.BOMBARD));
			versionLabel.x = 1;
			versionLabel.y = GamePlayConstants.STAGE_HEIGHT - versionLabel.height - 2;
			addChild(versionLabel);
		}
		
		//////////////////
		
		override public function show():void
		{
			super.show();
			
			if (!animationShownOnce)
				startAnimation();
			else
				AnimationEngine.globalAnimator.animateConstantWaving([playButton], 1000, NaN, 0.1);
			
			animationShownOnce = true;
			
			soundController.update();
			playButton.addEventListener(ButtonEvent.BUTTON_CLICK, playButton_clickHandler, false);
			sponsorPanel.addEventListener(ButtonEvent.BUTTON_CLICK, sponsorButton_clickHandler, false);
			creditsPanel.addEventListener(ButtonEvent.BUTTON_CLICK, creditsButton_clickHandler, false);
		}
		
		override public function hide():void
		{
			super.hide();
			playButton.removeEventListener(ButtonEvent.BUTTON_CLICK, playButton_clickHandler, false);
			sponsorPanel.removeEventListener(ButtonEvent.BUTTON_CLICK, sponsorButton_clickHandler, false);
			creditsPanel.removeEventListener(ButtonEvent.BUTTON_CLICK, creditsButton_clickHandler, false);
			
			AnimationEngine.globalAnimator.stopAnimationForObject(playButton);
		}
		
		/////////////
		
		private function startAnimation():void
		{
			prepareComponentsForAnimation();
			
			// step 0: showing pamls
			// step 1: stap the title
			// step 2: after crash stick out tanks, rockets and drop the play button
			// step 3: slide out credits and sponsor panel
			
			var playButtonAnimationOffset:Number = 200;
			var transitionDuration:Number = 300;
			var backTransitionDuration1:Number = 150;
			var backTransitionDuration2:Number = 200;
			
			var timeB0:Number = 100;
			var time0:Number = 1100;
			var time1:Number = 1500;
			var time2:Number = 2200;
			var time3:Number = 3100;
			
			// removing white screen
			AnimationEngine.globalAnimator.animateProperty(whiteScreen, "alpha", 1, 0, NaN, 1000, AnimationEngine.globalAnimator.currentTime + timeB0);
			AnimationEngine.globalAnimator.removeFromParent(whiteScreen, this, AnimationEngine.globalAnimator.currentTime + timeB0 + 1000);
			
			// step 0
			AnimationEngine.globalAnimator.animateProperty(palmsContainer, "alpha", 0, 1, NaN, 100, AnimationEngine.globalAnimator.currentTime + time0);
			AnimationEngine.globalAnimator.scaleObjects(palmsContainer, 1.1, 1.1, 0.97, 0.97, 150, AnimationEngine.globalAnimator.currentTime + time0);
			AnimationEngine.globalAnimator.scaleObjects(palmsContainer, 0.97, 0.97, 1, 1, 150, AnimationEngine.globalAnimator.currentTime + time0 + 150); // back animation
			
			// step 1
			AnimationEngine.globalAnimator.animateProperty(gameTitleContainer, "alpha", 0, 1, NaN, 200, AnimationEngine.globalAnimator.currentTime + time1);
			AnimationEngine.globalAnimator.scaleObjects(gameTitleContainer, 2.2, 2.2, 0.95, 0.95, transitionDuration, AnimationEngine.globalAnimator.currentTime + time1);
			AnimationEngine.globalAnimator.scaleObjects(gameTitleContainer, 0.95, 0.95, 1, 1, backTransitionDuration1, AnimationEngine.globalAnimator.currentTime + time1 + transitionDuration); // back animation
			SoundController.instance.playSound(SoundResources.SOUND_ROBOT_WALKING_03, 1, time1 + transitionDuration - 300);
			
			// step 2
			AnimationEngine.globalAnimator.animateProperty([leftRocket, leftTank, rightRocket, rightTank, aim, plane], "alpha", 0, 1, NaN, 0, AnimationEngine.globalAnimator.currentTime + time2);
			
			// left rocket
			AnimationEngine.globalAnimator.moveObjects(leftRocket, leftRocket.x + 30, leftRocket.y + 30, leftRocket.x - 20, leftRocket.y - 20, transitionDuration, AnimationEngine.globalAnimator.currentTime + time2);
			AnimationEngine.globalAnimator.moveObjects(leftRocket, leftRocket.x - 20, leftRocket.y - 20, leftRocket.x, leftRocket.y, backTransitionDuration2, AnimationEngine.globalAnimator.currentTime + time2 + transitionDuration); // back animation
			
			// left tank
			AnimationEngine.globalAnimator.moveObjects(leftTank, leftTank.x + 30, leftTank.y, leftTank.x - 20, leftTank.y, transitionDuration, AnimationEngine.globalAnimator.currentTime + time2);
			AnimationEngine.globalAnimator.moveObjects(leftTank, leftTank.x - 20, leftTank.y, leftTank.x, leftTank.y, backTransitionDuration2, AnimationEngine.globalAnimator.currentTime + time2 + transitionDuration); // back animation
			
			// right rocket
			AnimationEngine.globalAnimator.moveObjects(rightRocket, rightRocket.x - 30, rightRocket.y + 30, rightRocket.x + 20, rightRocket.y - 20, transitionDuration, AnimationEngine.globalAnimator.currentTime + time2);
			AnimationEngine.globalAnimator.moveObjects(rightRocket, rightRocket.x + 20, rightRocket.y - 20, rightRocket.x, rightRocket.y, backTransitionDuration2, AnimationEngine.globalAnimator.currentTime + time2 + transitionDuration); // back animation
			
			// right tank
			AnimationEngine.globalAnimator.moveObjects(rightTank, rightTank.x - 30, rightTank.y, rightTank.x + 20, rightTank.y, transitionDuration, AnimationEngine.globalAnimator.currentTime + time2);
			AnimationEngine.globalAnimator.moveObjects(rightTank, rightTank.x + 20, rightTank.y, rightTank.x, rightTank.y, backTransitionDuration2, AnimationEngine.globalAnimator.currentTime + time2 + transitionDuration); // back animation
			
			// plane
			AnimationEngine.globalAnimator.moveObjects(plane, plane.x - plane.width, plane.y - plane.height, plane.x, plane.y, transitionDuration, AnimationEngine.globalAnimator.currentTime + time2);
			SoundController.instance.playSound(SoundResources.SOUND_MISSILE_LAUNCH, 0.5, time2 - 300);
			
			// playButton
			AnimationEngine.globalAnimator.animateProperty(playButton, "alpha", 0, 1, NaN, 0, AnimationEngine.globalAnimator.currentTime + time2 + playButtonAnimationOffset);
			AnimationEngine.globalAnimator.moveObjects(playButton, playButton.x, playButton.y - 80, playButton.x, playButton.y + 10, transitionDuration, AnimationEngine.globalAnimator.currentTime + time2 + backTransitionDuration2);
			AnimationEngine.globalAnimator.moveObjects(playButton, playButton.x, playButton.y + 10, playButton.x, playButton.y, backTransitionDuration2, AnimationEngine.globalAnimator.currentTime + time2 + playButtonAnimationOffset + transitionDuration); // back animation
			AnimationEngine.globalAnimator.animateConstantWaving([playButton], 1000, AnimationEngine.globalAnimator.currentTime + time2 + playButtonAnimationOffset + transitionDuration + backTransitionDuration2, 0.1);
			
			// step 3
			AnimationEngine.globalAnimator.animateProperty([sponsorPanel, creditsPanel], "alpha", 0, 1, NaN, 0, AnimationEngine.globalAnimator.currentTime + time3);
			AnimationEngine.globalAnimator.moveObjects(sponsorPanel, sponsorPanel.x - sponsorPanel.width, sponsorPanel.y, sponsorPanel.x + 20, sponsorPanel.y, transitionDuration, AnimationEngine.globalAnimator.currentTime + time3);
			AnimationEngine.globalAnimator.moveObjects(sponsorPanel, sponsorPanel.x + 20, sponsorPanel.y, sponsorPanel.x, sponsorPanel.y, backTransitionDuration2, AnimationEngine.globalAnimator.currentTime + time3 + transitionDuration); // back animation
			
			AnimationEngine.globalAnimator.moveObjects(creditsPanel, creditsPanel.x + creditsPanel.width, creditsPanel.y, creditsPanel.x - 20, creditsPanel.y, transitionDuration, AnimationEngine.globalAnimator.currentTime + time3);
			AnimationEngine.globalAnimator.moveObjects(creditsPanel, creditsPanel.x - 20, creditsPanel.y, creditsPanel.x, creditsPanel.y, backTransitionDuration2, AnimationEngine.globalAnimator.currentTime + time3 + transitionDuration); // back animation	
			SoundController.instance.playSound(SoundResources.SOUND_WINDOW_SLIDE, 1, time3 - 300);
		}
		
		private function prepareComponentsForAnimation():void
		{
			// perform initial positioning
			// and prepare for animation
			leftRocket.x = 129;
			leftRocket.y = 67;
			leftRocket.alpha = 0;
			
			leftTank.x = 98;
			leftTank.y = 156;
			leftTank.alpha = 0;
			
			rightRocket.x = 389;
			rightRocket.y = 70;
			rightRocket.alpha = 0;
			
			rightTank.x = 492;
			rightTank.y = 153;
			rightTank.alpha = 0;
			
			palms.x = -palms.width / 2;
			palms.y = -palms.height / 2;
			palms.smoothing = true;
			palmsContainer.addChild(palms);
			
			palmsContainer.x = 110 + palms.width / 2;
			palmsContainer.y = 47 + palms.height / 2;
			palmsContainer.scaleX = 1.1;
			palmsContainer.scaleY = 1.1;
			palmsContainer.alpha = 0;
			
			aim.x = 416;
			aim.y = 228;
			aim.alpha = 0;
			
			gameTitle.x = -gameTitle.width / 2;
			gameTitle.y = -gameTitle.height / 2;
			gameTitle.smoothing = true;
			gameTitleContainer.addChild(gameTitle);
			
			gameTitleContainer.x = 182 + gameTitle.width / 2;
			gameTitleContainer.y = 133 + gameTitle.height / 2;
			gameTitleContainer.alpha = 0;
			
			plane.x = 170;
			plane.alpha = 0;
			
			sponsorPanel.x = 0;
			sponsorPanel.y = 400;
			sponsorPanel.alpha = 0;
			
			creditsPanel.x = GamePlayConstants.STAGE_WIDTH - creditsPanel.width;
			creditsPanel.y = 400;
			creditsPanel.alpha = 0;
			
			playButton.x = 267;
			playButton.y = 320;
			playButton.alpha = 0;
			
			whiteScreen.alpha = 1;
			
			addChild(leftRocket);
			addChild(rightRocket);
			addChild(leftTank);
			addChild(rightTank);
			addChild(playButton);
			addChild(palmsContainer);
			addChild(aim);
			addChild(gameTitleContainer);
			addChild(plane);
			addChild(sponsorPanel);
			addChild(creditsPanel);
			addChild(whiteScreen);
		}
		
		/////////////
		
		private function playButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(START_CLICKED));
		}
		
		private function creditsButton_clickHandler(event:ButtonEvent):void
		{
			dispatchEvent(new Event(CREDITS_CLICKED));
		}
		
		private function sponsorButton_clickHandler(event:ButtonEvent):void
		{
			SponsorInfoGenerator.navigateToSponsor();
		}
	}

}