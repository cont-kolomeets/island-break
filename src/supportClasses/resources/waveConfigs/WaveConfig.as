/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources.waveConfigs 
{
	import supportClasses.resources.waveConfigs.hardMode.Level01Hard;
	import supportClasses.resources.waveConfigs.unrealMode.Level01Unreal;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WaveConfig 
	{
		// index, staring from which you need to take unit descriptions for waves
		public static const WAVE_OBJECTS_SHIFT:int = 5;
		
		public static const DELAY_BEFORE_WAVE_INDEX:int = 0;
		
		public static const DELAY_AFTER_WAVE_INDEX:int = 1;
		
		// this will be used for all units in a wave, to which a special index is not specified 
		public static const DELAY_BETWEEN_UNITS_INDEX_NORMAL:int = 2;
		
		public static const DELAY_BETWEEN_UNITS_INDEX_SPECIAL:int = 3;
		
		public static const TIP_INDEX_INDEX:int = 4;
		
		public static const WAVES:Array = 
		[
			Level01.WAVES,
			Level02.WAVES,
			Level03.WAVES,
			Level04.WAVES,
			Level05.WAVES,
			Level06.WAVES,
			Level07.WAVES,
			Level08.WAVES,
			Level09.WAVES,
			Level10.WAVES
		]
		
		public static const WAVES_HARD:Array = 
		[
			Level01Hard.WAVES,
			/*Level02.WAVES,
			Level03.WAVES,
			Level04.WAVES,
			Level05.WAVES,
			Level06.WAVES,
			Level07.WAVES,
			Level08.WAVES,
			Level09.WAVES,
			Level10.WAVES,*/
		]
		
		public static const WAVES_UNREAL:Array = 
		[
			Level01Unreal.WAVES,
			/*Level02.WAVES,
			Level03.WAVES,
			Level04.WAVES,
			Level05.WAVES,
			Level06.WAVES,
			Level07.WAVES,
			Level08.WAVES,
			Level09.WAVES,
			Level10.WAVES,*/
		]
	}
}