/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.achievementsCenter
{
	import flash.display.Bitmap;
	import infoObjects.gameInfo.AchievementInfo;
	import infoObjects.gameInfo.GameInfo;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import panels.common.PaperTitle;
	import supportClasses.resources.AchievementResources;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MultiPerposedNotificationContainer extends NSSprite
	{
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/achievement container enabled green.png")]
		private static var containerEnabledGreenImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/achievement container enabled orange.png")]
		private static var containerEnabledOrangeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/achievement container disabled.png")]
		private static var containerDisabledImage:Class;
		
		//////////
		
		private var containerEnabledGreen:Bitmap = new containerEnabledGreenImage() as Bitmap;
		
		private var containerEnabledOrange:Bitmap = new containerEnabledOrangeImage() as Bitmap;
		
		private var containerDisabled:Bitmap = new containerDisabledImage() as Bitmap;
		
		private var icon:Bitmap;
		
		//////// for new achievemnt notification
		
		private var paperTitle:PaperTitle = new PaperTitle();
		
		private var newAchievemntTitleField:CustomTextField = new CustomTextField();
		
		private var gameSavedTitleField:CustomTextField = new CustomTextField();
		
		/////// for general description
		
		private var titleField:CustomTextField = new CustomTextField();
		
		private var descriptionField:CustomTextField = new CustomTextField();
		
		private var progressField:CustomTextField = new CustomTextField();
		
		//////////
		
		public function MultiPerposedNotificationContainer()
		{
			construct();
		}
		
		/////////
		
		private function construct():void
		{
			addChild(containerDisabled);
			addChild(containerEnabledGreen);
			addChild(containerEnabledOrange);
			
			containerEnabledGreen.smoothing = true;
			containerEnabledOrange.smoothing = true;
			
			addChild(paperTitle);
			paperTitle.y = -11;
			paperTitle.x = 62;
			paperTitle.autoCenter = false;
			paperTitle.setTitleText("Achievement", 15);
			paperTitle.visible = false;
			
			newAchievemntTitleField.x = 80;
			newAchievemntTitleField.y = 30;
			newAchievemntTitleField.fontDescriptor = new FontDescriptor(23, 0xFBA439, FontResources.YARDSALE);
			newAchievemntTitleField.visible = false;
			
			gameSavedTitleField.x = 44;
			gameSavedTitleField.y = 22;
			gameSavedTitleField.fontDescriptor = new FontDescriptor(32, 0xFCBC6D, FontResources.YARDSALE);
			gameSavedTitleField.visible = false;
			
			titleField.x = 80;
			titleField.y = 10;
			titleField.fontDescriptor = new FontDescriptor(20, 0xFFFFFF, FontResources.YARDSALE);
			
			descriptionField.x = 80;
			descriptionField.y = 30;
			descriptionField.textWidth = 150;
			descriptionField.fontDescriptor = new FontDescriptor(16, 0xFFFFFF, FontResources.BOMBARD);
			
			progressField.x = 240;
			progressField.y = 39;
			progressField.textWidth = 50;
			progressField.fontDescriptor = new FontDescriptor(15, 0xFFFFFF, FontResources.BOMBARD);
			
			addChild(gameSavedTitleField);
			addChild(newAchievemntTitleField);
			addChild(titleField);
			addChild(descriptionField);
			addChild(progressField);
		}
		
		/////////
		
		public function showNewAchievemntNotification(info:AchievementInfo):void
		{
			createIcon(info, true);
			
			newAchievemntTitleField.text = info.name;
			
			containerDisabled.visible = false;
			containerEnabledOrange.visible = false;
			containerEnabledGreen.visible = true;
			
			paperTitle.visible = true;
			newAchievemntTitleField.visible = true;
			titleField.visible = false;
			descriptionField.visible = false;
			progressField.visible = false;
			gameSavedTitleField.visible = false;
		}
		
		public function buildFromAchievementInfo(info:AchievementInfo, gameInfo:GameInfo):void
		{
			createIcon(info, true);
			
			titleField.text = info.name;
			descriptionField.text = info.description;
			
			tryDisplayProgress(info, gameInfo);
			
			descriptionField.y = (descriptionField.numLines == 1) ? 39 : 30;
			
			containerDisabled.visible = !info.achieved;
			containerEnabledGreen.visible = false;
			containerEnabledOrange.visible = info.achieved;
			
			paperTitle.visible = false;
			newAchievemntTitleField.visible = false;
			gameSavedTitleField.visible = false;
			titleField.visible = true;
			descriptionField.visible = true;
		}
		
		private function tryDisplayProgress(info:AchievementInfo, gameInfo:GameInfo):void
		{
			var progress:Number = NaN;
			
			if (info.type == AchievementInfo.TYPE_ACCUMULATIVE)
				progress = info.currentValue / info.goalValue;
			
			if (info.name == AchievementResources.NAME_UNSTOPPABLE)
				progress = gameInfo.numLevelsPassed / info.goalValue;
			else if (info.name == AchievementResources.NAME_TRIUMPHAL)
				progress = gameInfo.numLevelsPassed / info.goalValue;
			else if (info.name == AchievementResources.NAME_SUCCESSFUL)
				progress = gameInfo.totalStarsEarned / info.goalValue;
			else if (info.name == AchievementResources.NAME_HI_TECH)
				progress = gameInfo.developmentInfo.getOverallDevelopmentProgress();
			
			if (!isNaN(progress))
			{
				progressField.visible = true;
				progressField.text = int(Math.min(1, progress) * 100) + "%";
			}
		}
		
		private function createIcon(info:AchievementInfo, smoothing:Boolean = false):void
		{
			// removing an icon first
			if (icon && contains(icon))
				removeChild(icon);
			
			icon = null;
			
			if (info.achieved && info.iconEnabled)
				icon = new info.iconEnabled() as Bitmap;
			else if (!info.achieved && info.iconDisabled)
				icon = new info.iconDisabled() as Bitmap;
			
			if (icon)
			{
				icon.width = 50;
				icon.height = 50;
				icon.x = 25;
				icon.y = 12;
				icon.smoothing = smoothing;
				addChild(icon);
			}
		}
		
		// showing game saved notification
		public function showGameSavedNotification():void
		{
			showCustomNotification("Game Saved");
		}
		
		public function showCustomNotification(text:String, fontDescriptor:FontDescriptor = null):void
		{
			// removing an icon first
			if (icon && contains(icon))
				removeChild(icon);
			
			if (fontDescriptor)
				gameSavedTitleField.fontDescriptor = fontDescriptor;
			
			gameSavedTitleField.text = text;
			
			containerDisabled.visible = false;
			containerEnabledOrange.visible = false;
			containerEnabledGreen.visible = true;
			
			gameSavedTitleField.visible = true;
			
			paperTitle.visible = false;
			newAchievemntTitleField.visible = false;
			titleField.visible = false;
			descriptionField.visible = false;
			progressField.visible = false;
		}
	
	}

}