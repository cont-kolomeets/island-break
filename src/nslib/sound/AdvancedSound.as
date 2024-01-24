/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.sound 
{
	import nslib.utils.UIDUtil;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AdvancedSound extends Sound 
	{
		public var uniqueKey:String = UIDUtil.generateUniqueID();
		
		public function AdvancedSound(stream:URLRequest = null, context:SoundLoaderContext = null) 
		{
			super(stream, context);
		}
		
	}

}