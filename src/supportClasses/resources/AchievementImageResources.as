/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AchievementImageResources
	{
		////////////// Enabled images
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/king of skyes.png")]
		private static var kingOfSkyesEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/teleporter.png")]
		private static var teleporterEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/successful.png")]
		private static var successfulEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/bomber.png")]
		private static var bomberEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/builder.png")]
		private static var builderEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/constructor.png")]
		private static var constructorEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/destructor.png")]
		private static var destructorEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/obliterator.png")]
		private static var obliteratorEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/hi tech.png")]
		private static var hiTechEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/unbeatable.png")]
		private static var unbeatableEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/defender.png")]
		private static var defenderEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/iron shield.png")]
		private static var ironShieldEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/victorious.png")]
		private static var victoriousEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/unstoppable.png")]
		private static var unstoppableEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/triumphal.png")]
		private static var triumphalEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/impatient.png")]
		private static var impatientEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/businessman.png")]
		private static var businessmanEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/magnat.png")]
		private static var magnatEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/perfectionist.png")]
		private static var perfectionistEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/ice.png")]
		private static var iceEnabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards enabled/boss.png")]
		private static var bossEnabledImage:Class;
		
		public static function getIconEnabledByName(name:String):Class
		{
			switch (name)
			{
				case AchievementResources.NAME_BOMBER: 
					return bomberEnabledImage;
				
				case AchievementResources.NAME_BUSINESSMAN: 
					return businessmanEnabledImage;
				
				case AchievementResources.NAME_BUILDER: 
					return builderEnabledImage;
				
				case AchievementResources.NAME_CONSTRUCTOR: 
					return constructorEnabledImage;
				
				case AchievementResources.NAME_DEFENDER: 
					return defenderEnabledImage;
				
				case AchievementResources.NAME_DESTRUCTOR: 
					return destructorEnabledImage;
				
				case AchievementResources.NAME_HI_TECH: 
					return hiTechEnabledImage;
				
				case AchievementResources.NAME_IMPATIENT: 
					return impatientEnabledImage;
				
				case AchievementResources.NAME_IRON_SHIELD: 
					return ironShieldEnabledImage;
				
				case AchievementResources.NAME_KING_OF_SKYES: 
					return kingOfSkyesEnabledImage;
				
				case AchievementResources.NAME_MAGNAT: 
					return magnatEnabledImage;
				
				case AchievementResources.NAME_OBLITERATOR: 
					return obliteratorEnabledImage;
				
				case AchievementResources.NAME_SUCCESSFUL: 
					return successfulEnabledImage;
				
				case AchievementResources.NAME_TELEPORTER: 
					return teleporterEnabledImage;
				
				case AchievementResources.NAME_TRIUMPHAL: 
					return triumphalEnabledImage;
				
				case AchievementResources.NAME_UNBEATABLE: 
					return unbeatableEnabledImage;
				
				case AchievementResources.NAME_UNSTOPPABLE: 
					return unstoppableEnabledImage;
				
				case AchievementResources.NAME_VICTORIOUS: 
					return victoriousEnabledImage;
				
				case AchievementResources.NAME_PERFECTIONIST: 
					return perfectionistEnabledImage;
				
				case AchievementResources.NAME_ICE: 
					return iceEnabledImage;
					
				case AchievementResources.NAME_BOSS: 
					return bossEnabledImage;
			}
			
			return null;
		}
		
		////////////// Disabled images
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/king of skyes.png")]
		private static var kingOfSkyesDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/teleporter.png")]
		private static var teleporterDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/successful.png")]
		private static var successfulDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/bomber.png")]
		private static var bomberDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/builder.png")]
		private static var builderDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/constructor.png")]
		private static var constructorDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/destructor.png")]
		private static var destructorDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/obliterator.png")]
		private static var obliteratorDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/hi tech.png")]
		private static var hiTechDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/unbeatable.png")]
		private static var unbeatableDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/defender.png")]
		private static var defenderDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/iron shield.png")]
		private static var ironShieldDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/victorious.png")]
		private static var victoriousDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/unstoppable.png")]
		private static var unstoppableDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/triumphal.png")]
		private static var triumphalDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/impatient.png")]
		private static var impatientDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/businessman.png")]
		private static var businessmanDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/magnat.png")]
		private static var magnatDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/perfectionist.png")]
		private static var perfectionistDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/ice.png")]
		private static var iceDisabledImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/achievements panel/rewards disabled/boss.png")]
		private static var bossDisabledImage:Class;
		
		public static function getIconDisabledByName(name:String):Class
		{
			switch (name)
			{
				case AchievementResources.NAME_BOMBER: 
					return bomberDisabledImage;
				
				case AchievementResources.NAME_BUSINESSMAN: 
					return businessmanDisabledImage;
				
				case AchievementResources.NAME_BUILDER: 
					return builderDisabledImage;
				
				case AchievementResources.NAME_CONSTRUCTOR: 
					return constructorDisabledImage;
				
				case AchievementResources.NAME_DEFENDER: 
					return defenderDisabledImage;
				
				case AchievementResources.NAME_DESTRUCTOR: 
					return destructorDisabledImage;
				
				case AchievementResources.NAME_HI_TECH: 
					return hiTechDisabledImage;
				
				case AchievementResources.NAME_IMPATIENT: 
					return impatientDisabledImage;
				
				case AchievementResources.NAME_IRON_SHIELD: 
					return ironShieldDisabledImage;
				
				case AchievementResources.NAME_KING_OF_SKYES: 
					return kingOfSkyesDisabledImage;
				
				case AchievementResources.NAME_MAGNAT: 
					return magnatDisabledImage;
				
				case AchievementResources.NAME_OBLITERATOR: 
					return obliteratorDisabledImage;
				
				case AchievementResources.NAME_SUCCESSFUL: 
					return successfulDisabledImage;
				
				case AchievementResources.NAME_TELEPORTER: 
					return teleporterDisabledImage;
				
				case AchievementResources.NAME_TRIUMPHAL: 
					return triumphalDisabledImage;
				
				case AchievementResources.NAME_UNBEATABLE: 
					return unbeatableDisabledImage;
				
				case AchievementResources.NAME_UNSTOPPABLE: 
					return unstoppableDisabledImage;
				
				case AchievementResources.NAME_VICTORIOUS: 
					return victoriousDisabledImage;
				
				case AchievementResources.NAME_PERFECTIONIST: 
					return perfectionistDisabledImage;
				
				case AchievementResources.NAME_ICE: 
					return iceDisabledImage;
					
				case AchievementResources.NAME_BOSS: 
					return bossDisabledImage;
			}
			
			return null;
		}
	
	}

}