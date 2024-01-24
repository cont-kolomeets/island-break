/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TipInfo
	{
		public var index:int = -1;
		
		public var images:Array = null;
		
		public var type:String = null;
		
		//////////
		
		public function TipInfo(index:int, images:Array, type:String = "none")
		{
			this.index = index;
			this.images = images;
			this.type = type;
		}
	
	}

}