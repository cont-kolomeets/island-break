/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.devCenter.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UpgradeEvent extends Event
	{
		public static const UPGRADED:String = "upgraded";
		
		// Number of stars spent during upgrade.
		public var starsSpent:int = 0;
		
		// Id of upgraded weapon.
		public var weaponId:String = null;
		
		public function UpgradeEvent(type:String, starsSpent:int, weaponId:String)
		{
			super(type);
			
			this.starsSpent = starsSpent;
			this.weaponId = weaponId;
		}
	
		override public function clone():flash.events.Event 
		{
			return new UpgradeEvent(UPGRADED, starsSpent, weaponId);
		}
	}

}