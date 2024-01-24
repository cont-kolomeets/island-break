/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.sequences 
{
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class DustSequence 
	{
		[Embed(source="F:/Island Defence/media/images/Sequences/Dust/1.png")]
		private static var image01:Class;
		
		[Embed(source="F:/Island Defence/media/images/Sequences/Dust/2.png")]
		private static var image02:Class;
		
		[Embed(source="F:/Island Defence/media/images/Sequences/Dust/3.png")]
		private static var image03:Class;
		
		[Embed(source="F:/Island Defence/media/images/Sequences/Dust/4.png")]
		private static var image04:Class;
		
		[Embed(source="F:/Island Defence/media/images/Sequences/Dust/5.png")]
		private static var image05:Class;
		
		[Embed(source="F:/Island Defence/media/images/Sequences/Dust/6.png")]
		private static var image06:Class;
		
		public static function get images():Array
		{
			return [
			image01,
			image02,
			image03,
			image04,
			image05,
			image06
			];
		}
		
	}

}