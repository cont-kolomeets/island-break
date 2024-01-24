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
	public class Level03 
	{
		public static const WAVES:Array =
		
		//level 3 (learning to handle 2 paths)
			[
				//wave 1 (warm up)
				[
					// delay before the wave
					2000, 
					// delay after the wave
					10000, 
					// delay between units (for different paths)
					[5000, 2000], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "tank", "level": "0", "pathIndex": "0" },
					{ "name": "tank", "level": "0", "pathIndex": "0" },
					{ "name": "tank", "level": "0", "pathIndex": "0" },
					
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },	
					//{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },	
				],
				
				//wave 2 (recall the prev level)
				[
					// delay before the wave
					15000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[3000, 2000], 
					// delay between units special
					[1500],
					// tipIndex
					-1,
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0", "pathIndex": "0" },
					{ "name": "tank", "level": "0", "pathIndex": "0" },
					{ "name": "tank", "level": "0", "pathIndex": "0" },
					{ "name": "tank", "level": "0", "pathIndex": "0" },
					
					{ "name": "mobileVehicle", "level": "1", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "1", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
				],
				
				//wave 3
				[
					// delay before the wave
					15000, 
					// delay after the wave
					15000, 
					// delay between units (for different paths)
					[4000, 4000],
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "walkingRobot", "level": "0", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "0" },
					{ "name": "tank", "level": "0", "pathIndex": "0" },
					
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1" },
					{ "name": "tank", "level": "0", "pathIndex": "1" },
				],
				
				//wave 4 (fast wave)
				[
					// delay before the wave
					10000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[2000, 2000],
					// delay between units special
					[1000],
					// tipIndex
					-1,
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "0" },
					
					{ "name": "mobileVehicle", "level": "1", "pathIndex": "1", "specialDelayIndex":"0" }, 
					{ "name": "mobileVehicle", "level": "1", "pathIndex": "1", "specialDelayIndex":"0" },
					{ "name": "mobileVehicle", "level": "1", "pathIndex": "1", "specialDelayIndex":"0" },
					{ "name": "mobileVehicle", "level": "1", "pathIndex": "1", "specialDelayIndex":"0" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1" },
				],
				
				//wave 5 (new unit: heavy tank)
				[
					// delay before the wave
					20000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[10000, 10000],
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					
					{ "name": "tank", "level": "1", "pathIndex": "1" },
					{ "name": "tank", "level": "1", "pathIndex": "1" },
				],
				
				//wave 6
				[
					// delay before the wave
					40000, 
					// delay after the wave
					5000, 
					// delay between units (for different paths)
					[4000, 4000],
					// delay between units special
					[3000, 2500],
					// tipIndex
					-1,
					{ "name": "tank", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					//{ "name": "tank", "level": "1", "pathIndex": "0" },
					
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1", "specialDelayIndex":"1" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1", "specialDelayIndex":"1" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1", "specialDelayIndex":"1" },
					{ "name": "tank", "level": "0", "pathIndex": "1" },
					{ "name": "tank", "level": "0", "pathIndex": "1" },
					{ "name": "tank", "level": "0", "pathIndex": "1" },
					{ "name": "tank", "level": "1", "pathIndex": "1" },
					//{ "name": "tank", "level": "1", "pathIndex": "1" },
				],
				
				//wave 7
				[
					// delay before the wave
					30000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[10000, 10000],
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "walkingRobot", "level": "1", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "0" },
					
					{ "name": "walkingRobot", "level": "1", "pathIndex": "1" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "1" },
				],
				
				//wave 8
				[
					// delay before the wave
					30000, 
					// delay after the wave
					20000, 
					// delay between units (for different paths)
					[4000, 4000],
					// delay between units special
					[3000, 2000],
					// tipIndex
					-1,
					{ "name": "tank", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1", "specialDelayIndex":"1" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1", "specialDelayIndex":"1" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1", "specialDelayIndex":"1" },
					{ "name": "walkingRobot", "level": "0", "pathIndex": "1", "specialDelayIndex":"1" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "1" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "1" },
					{ "name": "tank", "level": "1", "pathIndex": "1" },
				],
				
				//wave 9 (money wave)
				[
					// delay before the wave
					15000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[1500, 1500],
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "0" },
					
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
					{ "name": "mobileVehicle", "level": "0", "pathIndex": "1" },
				],
				
				//wave 10 (very heavy wave)
				[
					// delay before the wave
					10000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[4000, 4000],
					// delay between units special
					[2500],
					// tipIndex
					-1,
					{ "name": "tank", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0", "pathIndex": "0", "specialDelayIndex":"0" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					
					{ "name": "tank", "level": "0", "pathIndex": "1", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0", "pathIndex": "1", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0", "pathIndex": "1", "specialDelayIndex":"0" },
					{ "name": "tank", "level": "0", "pathIndex": "1", "specialDelayIndex":"0" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "1" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "1" },
					{ "name": "tank", "level": "1", "pathIndex": "1" },
					{ "name": "tank", "level": "1", "pathIndex": "1" },
					{ "name": "tank", "level": "1", "pathIndex": "1" },
					{ "name": "tank", "level": "1", "pathIndex": "1" },
				],
			]
		
	}

}