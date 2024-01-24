/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources.waveConfigs 
{
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class Level01 
	{
		
			public static const WAVES:Array =
			
			// learning basics
			// how to play
			// how to build towers and barrikades
			// how to control the game
			// units:
			// basic unarmored unit - trike
			// armored unit - tank
			[
				//wave 1 (first impression) news: new enemy
				[
					// delay before the wave
					2000, 
					// delay after the wave
					4000, 
					// delay between units (for different paths)
					[4000], 
					// delay between units special
					[], 
					// tipIndex
					-1,
					{ "name": "mobileVehicle", "level": "0"},
					{ "name": "mobileVehicle", "level": "0"},
					{ "name": "mobileVehicle", "level": "0"},
				],
				//wave 2 (learning: distance can shrink)
				[
					// delay before the wave
					15000, 
					// delay after the wave
					3000, 
					// delay between units (for different paths)
					[3000], 
					// delay between units special
					[], 
					// tipIndex
					-1,
					{ "name": "mobileVehicle", "level": "0" },
					{ "name": "mobileVehicle", "level": "0" },
					{ "name": "mobileVehicle", "level": "0" },
					{ "name": "mobileVehicle", "level": "0" },
					{ "name": "mobileVehicle", "level": "0" },
					{ "name": "mobileVehicle", "level": "0" },
					{ "name": "mobileVehicle", "level": "0" },
				],
				//wave 3 (learning enemy can be armored) news: new enemy, tip forced: use cannons
				[
					// delay before the wave
					15000, 
					// delay after the wave
					5000, 
					// delay between units (for different paths)
					[10000], 
					// delay between units special
					[], 
					// tipIndex
					1,
					{ "name": "tank", "level": "0" },
					{ "name": "tank", "level": "0" },
					{ "name": "tank", "level": "0" },
				],
				//wave 4 (mixed wave)
				[
					// delay before the wave
					25000, 
					// delay after the wave
					10000, 
					// delay between units (for different paths)
					[4500], 
					// delay between units special
					[2000], 
					// tipIndex
					2, // active enemy
					{ "name": "mobileVehicle", "level": "0", "specialDelayIndex":"0" },
					{ "name": "mobileVehicle", "level": "0", "specialDelayIndex":"0" },
					{ "name": "mobileVehicle", "level": "0", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0" },
					{ "name": "tank", "level": "0" },
					{ "name": "tank", "level": "0" },
					{ "name": "tank", "level": "0" },
				],
				//wave 5 (harder mixed wave)
				[
					// delay before the wave
					15000, 
					// delay after the wave
					0, 
					// delay between units (for different paths)
					[4000], 
					// delay between units special
					[1500], 
					// tipIndex
					3, // hot keys
					{ "name": "mobileVehicle", "level": "0", "specialDelayIndex":"0" },
					{ "name": "mobileVehicle", "level": "0", "specialDelayIndex":"0" },
					{ "name": "mobileVehicle", "level": "0", "specialDelayIndex":"0" },
					{ "name": "mobileVehicle", "level": "0", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0" },
					{ "name": "tank", "level": "0" },
					{ "name": "tank", "level": "0" },
					{ "name": "tank", "level": "0" },
					{ "name": "tank", "level": "0" },
				]
			]
		
	}

}