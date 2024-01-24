/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.news 
{
	import infoObjects.WeaponInfo;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import panels.common.PhotoContainer;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class NewEnemyInfoContent extends NSSprite 
	{
		public var animationEngine:AnimationEngine = null;
		
		public var textHeight:Number = 230;
		
		private var photoContainer:PhotoContainer = new PhotoContainer();
		
		private var contentTextField:CustomTextField = new CustomTextField();
		
		///////// parameters for animation
		
		public var rotationDuration:Number = 400;
		
		public var textFadingInDuration:Number = 200;
		
		/////////
		
		public function NewEnemyInfoContent() 
		{
			super();
		}
		
		//////////
		
		public function constructForInfo(info:WeaponInfo, photoRotationTimeOffset:int = 350, textAppearingTimeOffset:int = 1000):void
		{
			removeAllChildren();
			
			// adding photo of the enemy
			photoContainer.fillPhotoContainerWithBigImage(info);
			photoContainer.rotation = -10;
			photoContainer.x = 50;
			photoContainer.y = 163;
			
			addChild(photoContainer);
			// preparing for animation
			photoContainer.alpha = 0;
			
			// adding description
			contentTextField.text = null;
			
			contentTextField.x = 180;
			contentTextField.y = 50;
			contentTextField.textWidth = 270;
			contentTextField.appendText(info.name, new FontDescriptor(30, 0xFE6741, FontResources.KOMTXTB));
			contentTextField.caretToNextLine(15);
			contentTextField.appendMultiLinedText(info.generalDescription, new FontDescriptor(18, 0x404142, FontResources.KOMTXTB));
			
			var len:int = info.descriptiveParamters.length;
			
			contentTextField.caretToNextLine(0);
			
			for (var i:int = 0; i < len; i++)
			{
				contentTextField.appendMultiLinedText("- " + info.descriptiveParamters[i], new FontDescriptor(20, 0xC92901, FontResources.KOMTXTB), 20);
			}
			
			addChild(contentTextField);
			
			textHeight = Math.max(220, contentTextField.height + 60);
			
			// preparing for animation
			contentTextField.alpha = 0;
			
			// configuring animation

			animationEngine.animateProperty(photoContainer, "alpha", 0, 1, NaN, 300, animationEngine.currentTime + photoRotationTimeOffset);
			animationEngine.rotateObjects(photoContainer, photoContainer.rotation - 360, photoContainer.rotation, NaN, rotationDuration, animationEngine.currentTime + photoRotationTimeOffset);
			animationEngine.scaleObjects(photoContainer, 2, 2, 1, 1, 500, animationEngine.currentTime + photoRotationTimeOffset);
			
			// showing description
			animationEngine.animateProperty(contentTextField, "alpha", 0, 1, NaN, textFadingInDuration, animationEngine.currentTime + textAppearingTimeOffset);
		}
		
	}

}