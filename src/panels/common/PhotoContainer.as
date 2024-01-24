/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.common
{
	import flash.display.Bitmap;
	import infoObjects.WeaponInfo;
	import nslib.controls.NSSprite;
	import nslib.utils.ImageUtil;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PhotoContainer extends NSSprite
	{
		[Embed(source="F:/Island Defence/media/images/common images/photo frame.png")]
		private static var photoFrameImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/photo jungle background.jpg")]
		private static var photoJungleBackgroundImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/photo sky background.jpg")]
		private static var photoSkyBackgroundImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/photo empty background.png")]
		private static var photoEmptyBackgroundImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/common images/photo in game background.png")]
		private static var photoInGameBackgroundImage:Class;
		
		////////////
		
		public var showEmptyBackground:Boolean = true;
		
		private var photoFrame:Bitmap = null;
		
		private var photoJungleBackground:Bitmap = null;
		
		private var photoSkyBackground:Bitmap = null;
		
		private var photoEmptyBackground:Bitmap = null;
		
		private var photoInGameBackground:Bitmap = null;
		
		/////////////
		
		public function PhotoContainer()
		{
			construct();
		}
		
		/////////////
		
		private function construct():void
		{
			photoFrame = new photoFrameImage() as Bitmap;
			photoFrame.smoothing = true;
			photoJungleBackground = new photoJungleBackgroundImage() as Bitmap;
			photoJungleBackground.smoothing = true;
			photoSkyBackground = new photoSkyBackgroundImage() as Bitmap;
			photoSkyBackground.smoothing = true;
			photoEmptyBackground = new photoEmptyBackgroundImage() as Bitmap;
			photoEmptyBackground.smoothing = true;
		}
		
		/////////////
		
		public function fillPhotoContainerWithBigImage(info:WeaponInfo):void
		{
			removeAllChildren();
			
			// adding frame
			photoFrame.x = -photoFrame.width / 2;
			photoFrame.y = -photoFrame.height / 2;
			addChild(photoFrame);
			
			// adding weapon image
			if (info && info.iconBig)
			{
				addBackgroundForInfo(info);
				createImageForInfo(info);
			}
			else if (showEmptyBackground)
			{
				// adding emptry background behind the frame
				photoEmptyBackground.x = -photoEmptyBackground.width / 2;
				photoEmptyBackground.y = -photoEmptyBackground.height / 2;
				addChildAt(photoEmptyBackground, 0);
			}
		}
		
		private function addBackgroundForInfo(info:WeaponInfo):void
		{
			var background:Bitmap = null;
			var offsetY:Number = generateOffsetYForInfo(info);
			
			// setting background
			if (info.weaponId == WeaponResources.USER_AIR_SUPPORT || info.weaponId == WeaponResources.ENEMY_PLANE || info.weaponId == WeaponResources.ENEMY_HELICOPTER || info.weaponId == WeaponResources.USER_BOMB_SUPPORT)
				background = photoSkyBackground;
			else
				background = photoJungleBackground;
			
			// adding background behind the frame
			background.x = -background.width / 2;
			background.y = -background.height / 2;
			addChildAt(background, 0);
		}
		
		private function createImageForInfo(info:WeaponInfo):void
		{
			var weaponImage:Bitmap = new info.iconBig() as Bitmap;
			weaponImage.smoothing = true;
			
			scaleImageForInfo(info, weaponImage);
			
			weaponImage.x = -weaponImage.width / 2;
			weaponImage.y = photoFrame.height / 2 - weaponImage.height - 60 + generateOffsetYForInfo(info);
			
			addChild(weaponImage);
		}
		
		// offset
		private function generateOffsetYForInfo(info:WeaponInfo):Number
		{
			var offsetY:Number = 10;
			
			if (info.weaponId == WeaponResources.USER_AIR_SUPPORT || info.weaponId == WeaponResources.ENEMY_PLANE)
				offsetY = -15;
			
			if (info.weaponId == WeaponResources.ENEMY_PLANE && info.level == 0)
				offsetY = -50;
			
			if (info.weaponId == WeaponResources.ENEMY_TANK && info.level == 0)
				offsetY = 30;
			
			return offsetY;
		}
		
		private function scaleImageForInfo(info:WeaponInfo, weaponImage:Bitmap):void
		{
			var dimentionToFit:Number = 150;
			var fitWidth:Boolean = true;
			
			if (info.weaponId == WeaponResources.USER_BOMB_SUPPORT && info.level == 0)
				fitWidth = false;
				
			if (info.weaponId == WeaponResources.ENEMY_MOBILE_VEHICLE && info.level == 0)
				dimentionToFit = 130;
				
			if (info.weaponId == WeaponResources.ENEMY_TANK && info.level == 1)
				dimentionToFit = 190;
			
			if (info.weaponId == WeaponResources.ENEMY_HELICOPTER && info.level == 1)
				dimentionToFit = 200;
			
			if (info.weaponId == WeaponResources.ENEMY_BOMBER_TANK)
				dimentionToFit = 180;
			
			if (info.weaponId == WeaponResources.ENEMY_INVISIBLE_TANK)
				dimentionToFit = 170;
				
			if (info.weaponId == WeaponResources.ENEMY_ENERGY_BALL)
				dimentionToFit = 180;
			
			if (fitWidth)
				ImageUtil.scaleToFitWidth(weaponImage, dimentionToFit, true);
			else
				ImageUtil.scaleToFitHeight(weaponImage, dimentionToFit, true);
		}
	
		public function fillPhotoContainerWithInGameImage(info:WeaponInfo):void
		{
			removeAllChildren();
			
			if (!info || !info.iconSmallInGame)
				return;
			
			// center content
			photoFrame.scaleX = 1;
			photoFrame.scaleY = 1;
			
			var weaponImage:Bitmap = new info.iconSmallInGame() as Bitmap;
			
			var scaleFactor:Number = weaponImage.width < ((photoFrame.width - 50) * 0.3) ? 0.3 : (0.3 * weaponImage.width / ((photoFrame.width - 50) * 0.3));
			
			// adding frame
			photoFrame.scaleX = scaleFactor;
			photoFrame.scaleY = scaleFactor;
			
			photoFrame.x = -photoFrame.width / 2;
			photoFrame.y = -photoFrame.height / 2;
			addChild(photoFrame);
			
			// adding weapon image
			var background:Bitmap = new photoInGameBackgroundImage() as Bitmap;
			background.smoothing = true;
			//background.graphics.beginFill(
			
			// adding background behind the frame
			var backgroundScaleFactor:Number = (photoFrame.width - 7) / background.width;
			background.scaleX = backgroundScaleFactor;
			background.scaleY = backgroundScaleFactor;
			
			background.x = -background.width / 2;
			background.y = -background.height / 2;
			addChildAt(background, 0);
			
			// adding image
			weaponImage.x = -weaponImage.width / 2;
			weaponImage.y = -weaponImage.height / 2;
			
			addChild(weaponImage);
		}
	
	}

}