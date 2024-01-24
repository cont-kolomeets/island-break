/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package constants 
{
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class MapConstants 
	{
		// resolution of a grid on a map.
		public static const MAP_GRID_RESOLUTION:int = 45;
		
		public static const LOCATION_EMPTY_FILTER:String = "emptyLocation";
		
		public static const LOCATION_ULTIMATE_OBSTACLE_FILTER:String = "ultimateObstacle";
		
		// indicates that a location is only for passing not for placing objects on
		public static const LOCATION_ONLY_PATH_FILTER:String = "onlyPath";
		
		public static const LOCATION_ONLY_USER_WEAPON_FREE_FILTER:String = "onlyUserWeaponFree";
		
		public static const LOCATION_ONLY_USER_WEAPON_OCCUPIED_FILTER:String = "onlyUserWeaponOccupied";
		
		public static const LOCATION_ONLY_BARRICADE_OCCUPIED_FILTER:String = "onlyBarricadeOccupied";
	}
	
	// combinations
	// empty - LOCATION_EMPTY_FILTER
	// absolute obstacle - LOCATION_ULTIMATE_OBSTACLE_FILTER
	// only for path (bridges and teleports) - LOCATION_ONLY_PATH_FILTER
	
	// only for user weapon free - LOCATION_ONLY_USER_WEAPON_FREE_FILTER
	// only for user weapon occupied - LOCATION_ONLY_USER_WEAPON_OCCUPIED_FILTER
	
	// only for barricade occupied - LOCATION_ONLY_BARRICADE_OCCUPIED_FILTER

}