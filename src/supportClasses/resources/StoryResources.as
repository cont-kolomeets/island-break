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
	public class StoryResources 
	{
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/story parts/story part 01.png")]
		private static var storyPart01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/story parts/story part 02.png")]
		private static var storyPart02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/story parts/story part 03.png")]
		private static var storyPart03Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/story parts/story part 04.png")]
		private static var storyPart04Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/encyclopedia panel/story parts/story part 05.png")]
		private static var storyPart05Image:Class;
		
		////////////////
		
		private static var storyImages:Array = null;
		
		public static function initialize():void
		{
			storyImages = [storyPart01Image, storyPart02Image, storyPart03Image, storyPart04Image, storyPart05Image];
		}
		
		public static function getStoryPartAt(imageIndex:int):Class
		{
			return storyImages[imageIndex];
		}
		
		public static function getNumImages():int
		{
			return storyImages.length;
		}
	}

}