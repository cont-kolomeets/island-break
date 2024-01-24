/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package tracker 
{
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class TrackingMessages 
	{
		// global points:
		
		public static const BEGIN_TRACKING:String = "begin_app";
		public static const BEGIN_GAME:String = "begin_game";
		public static const END_GAME:String = "end_game";
		public static const BEGIN_LEVEL:String = "begin_level";
		public static const END_LEVEL:String = "end_level";
		public static const GAME_INTERRUPTED:String = "game interrupted";
		
		public static const LEVEL_PAUSED:String = "level paused";
		public static const LEVEL_RESUMED:String = "level resumed";
		
		public static const SLOT_SELECTED:String = "slot selected";
		
		public static const ERROR:String = "error";
		
		public static const VISITED_CREDITS:String = "visited credits";
		public static const VISITED_DEV_CENTER:String = "visited development center";
		public static const VISITED_ECNYCLOPEDIA:String = "visited encyclopedia";
		public static const VISITED_ACHIEVEMENTS:String = "visited achievements";
		public static const OPENED_LEVEL_INFO:String = "opened level info";
		public static const OPENED_SETTINGS_PANEL:String = "opened settings panel";
		
		// in-level massages
		
		public static const LEVEL_ACCELERATION_ON:String = "acceleration on";
		public static const LEVEL_ACCELERATION_OFF:String = "acceleration off";
		public static const LEVEL_COMPLETED:String = "level completed";
		public static const LEVEL_FAILED:String = "level failed";
		
		public static const WAVE_CALLED_EARLIER:String = "wave called earlier";
		public static const WAVE_STARTED_ITSELF:String = "wave started itself";
		
		public static const TOWER_PLACED:String = "tower placed";
		public static const TOWER_UPGRADED:String = "tower upgraded";
		public static const TOWER_SOLD:String = "tower sold";
		public static const TOWER_REPAIRED:String = "tower repaired";
		public static const TOWER_DESTROYED:String = "tower destroyed";
		
		public static const ENEMY_DESTROYED:String = "enemy destroyed";
		public static const ENEMY_PASSED:String = "enemy passed";
		
		public static const BOMB_DROPPED:String = "bomb dropped";
		public static const AIR_SUPPORT_CALLED:String = "air support called";
	}

}