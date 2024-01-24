/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponEvent extends Event 
	{
		public static const DESTROYED:String = "destroyed";
		
		public static const REMOVE:String = "remove";
		
		public static const PLACED:String = "placed";
		
		public static const OUT_OF_FUEL:String = "outOfFuel";
		
		public static const BUILDING_COMPLETE:String = "buildingComplete";
		
		public static const FIRE:String = "fire";
		
		public static const DAMAGED:String = "damaged";
		
		public static const ELECTRILIZED:String = "electrilized";
		
		public static const UPGRADED:String = "upgraded";
		
		public static const REPAIRED:String = "repaired";
		
		public static const TARGET_REACHED:String = "targetReached";
		
		public static const CREATE_PLANE_FROM_FACTORY:String = "createPlaneFromFactory";
		
		public function WeaponEvent(type:String) 
		{
			super(type);
		}
		
	}

}