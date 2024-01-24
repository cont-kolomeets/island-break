/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.common
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PaperTitle extends PaperWithTextBase
	{
		[Embed(source="F:/Island Defence/media/images/common images/big frame title paper.png")]
		private static var titlePaperImage:Class;
		
		////////
		
		public function PaperTitle(title:String = null, fontSize:int = -1)
		{
			super(title, fontSize);
			
			imageClass = titlePaperImage;
		}
	}

}