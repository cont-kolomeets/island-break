/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources
{
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class LevelsInfoResources
	{
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 01 thumb.jpg")]
		public static var levelThumb01:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 01 thumb big.jpg")]
		public static var levelThumb01Big:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 02 thumb.jpg")]
		public static var levelThumb02:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 02 thumb big.jpg")]
		public static var levelThumb02Big:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 03 thumb.jpg")]
		public static var levelThumb03:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 03 thumb big.jpg")]
		public static var levelThumb03Big:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 04 thumb.jpg")]
		public static var levelThumb04:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 04 thumb big.jpg")]
		public static var levelThumb04Big:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 05 thumb.jpg")]
		public static var levelThumb05:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 05 thumb big.jpg")]
		public static var levelThumb05Big:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 06 thumb.jpg")]
		public static var levelThumb06:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 06 thumb big.jpg")]
		public static var levelThumb06Big:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 07 thumb.jpg")]
		public static var levelThumb07:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 07 thumb big.jpg")]
		public static var levelThumb07Big:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 08 thumb.jpg")]
		public static var levelThumb08:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 08 thumb big.jpg")]
		public static var levelThumb08Big:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 09 thumb.jpg")]
		public static var levelThumb09:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 09 thumb big.jpg")]
		public static var levelThumb09Big:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 10 thumb.jpg")]
		public static var levelThumb10:Class;
		
		[Embed(source="F:/Island Defence/media/images/levels thumbs/level 10 thumb big.jpg")]
		public static var levelThumb10Big:Class;
		
		////////////////
		
		public static function getLevelImageClassByIndex(index:int, big:Boolean = false):Class
		{
			switch (index)
			{
				case 0: 
					return big ? levelThumb01Big : levelThumb01;
				case 1: 
					return big ? levelThumb02Big : levelThumb02;
				case 2: 
					return big ? levelThumb03Big : levelThumb03;
				case 3: 
					return big ? levelThumb04Big : levelThumb04;
				case 4: 
					return big ? levelThumb05Big : levelThumb05;
				case 5: 
					return big ? levelThumb06Big : levelThumb06;
				case 6: 
					return big ? levelThumb07Big : levelThumb07;
				case 7: 
					return big ? levelThumb08Big : levelThumb08;
				case 8: 
					return big ? levelThumb09Big : levelThumb09;
				case 9: 
					return big ? levelThumb10Big : levelThumb10;
			}
			
			return null;
		}
		
		public static function getLevelImageBitmapByIndex(index:int, big:Boolean = false):Bitmap
		{
			var clazz:Class = getLevelImageClassByIndex(index, big);
			
			if (clazz)
			{
				var value:* = new clazz();
				return new Bitmap(value.bitmapData);
			}
			
			return null;
		}
		
		/////////////// descriptions
		
		public static function getLevelNameByIndex(index:int):String
		{
			switch (index)
			{
				case 0: 
					return "Sandy Beach";
				case 1: 
					return "Oak Woods";
				case 2: 
					return "Dead Swamps";
				case 3: 
					return "Blue Lagoon";
				case 4: 
					return "Magic Woods";
				case 5: 
					return "Rain Forest";
				case 6: 
					return "Bottomless Crack";
				case 7: 
					return "Peak";
				case 8: 
					return "Cannibals Village";
				case 9: 
					return "Enemy Camp";
			}
			
			return null;
		}
		
		public static function getLevelDescriptionByIndex(index:int):String
		{
			switch (index)
			{
				case 0: 
					return "The enemy has dispatched his forces and landed on the beach. His first attack is going to be quite weak. It will allow you to learn the necessary basics of the game and get prepared for the upcoming battles. Good luck!";
				case 1: 
					return "The enemy is relentless! He has pushed his more advanced forces deeper into the island, and is heading toward the mountains with diamond mines. Your objective is to stop him before he seizes the precious resources. Good luck!";
				case 2: 
					return "Dead swamps are quite a spooky place to walk through. That's why the enemy is going to try to pass there to remain unseen by island dwellers. You have no choice but to handle him there. To battle!";
				case 3: 
					return "Once again the enemy has dispatched his forces on the sea shore. However, this time the battle is going to be much fiercer! Beware of hostile aircrafts and distribute your forces wisely!";
				case 4: 
					return "Strange things happen here all the time as a result of the enormous electromagnetic fields generated by frozen magma deep underground. The enemy took advantage of it and dispatched his electric units. Use electric towers to handle them!";
				case 5: 
					return "It's constantly raining here. As reported by our secret agents, the enemy is going to use units with the ability to build a strong electromagnetic shield preventing all non-electric towers from detecting them. Use electric towers to remove the shield!";
				case 6: 
					return "This crack was formed as a result of a great earthquake about 1000 years ago. The enemy managed to build an underground base there and is trying to hide. Do not let him get deeper underground, or you might not be able to find him again in theses endless caves. Hurry up!";
				case 7: 
					return "It's quite snowy up here. It was reported that the enemy located a radio station on the peak to communicate with the base, and is going to call support. Your objective is to obliterate all hostile forces and cut the radio connection.";
				case 8: 
					return "One should know that it's better to avoid these savages. Eliminate all the hostile units in this village. The end is near, victory is almost ours!";
				case 9: 
					return "Finally, you got to the very heart of your enemies forces. The enemy has dispatched his elite waves. Let's show him who is the boss of this island!";
			}
			
			return null;
		}
	
	}

}