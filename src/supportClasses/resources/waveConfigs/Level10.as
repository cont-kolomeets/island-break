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
	public class Level10 
	{
		
		public static const WAVES:Array =
		[
				//wave 1
				[
					// delay before the wave
					2000, 
					// delay after the wave
					15000, 
					// delay between units (for different paths)
					[4000, 3000], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					{ "name": "tank", "level": "1", "pathIndex": "0" },
					
					{ "name": "helicopter", "level": "1", "pathIndex": "1" },	
					{ "name": "factoryTank", "level": "0", "pathIndex": "1" },	
					{ "name": "factoryTank", "level": "0", "pathIndex": "1" },	
					{ "name": "factoryTank", "level": "0", "pathIndex": "1" },	
				],
				
				//wave 2
				[
					// delay before the wave
					30000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[3000, 3000], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "bomberTank", "level": "1", "pathIndex": "0" },
					{ "name": "bomberTank", "level": "1", "pathIndex": "0" },
					{ "name": "repairTank", "level": "0", "pathIndex": "0" },
					{ "name": "energyBall", "level": "1", "pathIndex": "0" },
					{ "name": "energyBall", "level": "1", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "1", "pathIndex": "0" },
					
					{ "name": "bomberTank", "level": "1", "pathIndex": "1" },	
					{ "name": "bomberTank", "level": "1", "pathIndex": "1" },	
					{ "name": "repairTank", "level": "0", "pathIndex": "1" },	
					{ "name": "energyBall", "level": "1", "pathIndex": "1" },	
					{ "name": "energyBall", "level": "1", "pathIndex": "1" },	
					{ "name": "walkingRobot", "level": "1", "pathIndex": "1" },	
				],
				
				//wave 3
				[
					// delay before the wave
					30000, 
					// delay after the wave
					20000, 
					// delay between units (for different paths)
					[4000, 4000], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "helicopter", "level": "1", "pathIndex": "0" },
					{ "name": "helicopter", "level": "1", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "2", "pathIndex": "0" },
					
					{ "name": "helicopter", "level": "1", "pathIndex": "1" },	
					{ "name": "helicopter", "level": "1", "pathIndex": "1" },	
					{ "name": "walkingRobot", "level": "2", "pathIndex": "1" },	
				],
				
				//wave 4
				[
					// delay before the wave
					30000, 
					// delay after the wave
					20000, 
					// delay between units (for different paths)
					[3000, 3000], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "plane", "level": "1", "pathIndex": "0" },
					{ "name": "plane", "level": "1", "pathIndex": "0" },
					{ "name": "factoryTank", "level": "0", "pathIndex": "0" },
					{ "name": "factoryTank", "level": "0", "pathIndex": "0" },
					{ "name": "factoryTank", "level": "0", "pathIndex": "0" },
					{ "name": "invisibleTank", "level": "1", "pathIndex": "0" },
					
					{ "name": "plane", "level": "1", "pathIndex": "1" },	
					{ "name": "plane", "level": "1", "pathIndex": "1" },	
					{ "name": "factoryTank", "level": "0", "pathIndex": "1" },	
					{ "name": "factoryTank", "level": "0", "pathIndex": "1" },	
					{ "name": "factoryTank", "level": "0", "pathIndex": "1" },	
					{ "name": "repairTank", "level": "0", "pathIndex": "1" },	
				],
				
				//wave 5
				[
					// delay before the wave
					20000, 
					// delay after the wave
					10000, 
					// delay between units (for different paths)
					[3000, 3000], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "bomberTank", "level": "1", "pathIndex": "0" },
					{ "name": "energyBall", "level": "1", "pathIndex": "0" },
					{ "name": "invisibleTank", "level": "1", "pathIndex": "0" },
					{ "name": "repairTank", "level": "0", "pathIndex": "0" },
					{ "name": "energyBall", "level": "1", "pathIndex": "0" },
					{ "name": "bomberTank", "level": "1", "pathIndex": "0" },
					
					{ "name": "bomberTank", "level": "1", "pathIndex": "1" },	
					{ "name": "energyBall", "level": "1", "pathIndex": "1" },	
					{ "name": "invisibleTank", "level": "1", "pathIndex": "1" },	
					{ "name": "repairTank", "level": "0", "pathIndex": "1" },	
					{ "name": "energyBall", "level": "1", "pathIndex": "1" },	
					{ "name": "bomberTank", "level": "1", "pathIndex": "1" },	
				],
				
				//wave 6
				[
					// delay before the wave
					20000, 
					// delay after the wave
					20000, 
					// delay between units (for different paths)
					[5000, 5000], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "walkingRobot", "level": "2", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "2", "pathIndex": "0" },
					{ "name": "repairTank", "level": "0", "pathIndex": "0" },
					{ "name": "invisibleTank", "level": "1", "pathIndex": "0" },
					{ "name": "repairTank", "level": "0", "pathIndex": "0" },
					
					{ "name": "walkingRobot", "level": "2", "pathIndex": "1" },	
					{ "name": "walkingRobot", "level": "2", "pathIndex": "1" },	
					{ "name": "repairTank", "level": "0", "pathIndex": "1" },	
					{ "name": "invisibleTank", "level": "1", "pathIndex": "1" },	
					{ "name": "repairTank", "level": "0", "pathIndex": "1" },	
				],
				
				//wave 7
				[
					// delay before the wave
					52000, 
					// delay after the wave
					10000, 
					// delay between units (for different paths)
					[3000, 3000], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "invisibleTank", "level": "1", "pathIndex": "0" },
					{ "name": "repairTank", "level": "0", "pathIndex": "0" },
					{ "name": "invisibleTank", "level": "1", "pathIndex": "0" },
					{ "name": "repairTank", "level": "0", "pathIndex": "0" },
					{ "name": "invisibleTank", "level": "1", "pathIndex": "0" },
					
					{ "name": "invisibleTank", "level": "1", "pathIndex": "1" },	
					{ "name": "repairTank", "level": "0", "pathIndex": "1" },	
					{ "name": "invisibleTank", "level": "1", "pathIndex": "1" },	
					{ "name": "repairTank", "level": "0", "pathIndex": "1" },	
					{ "name": "invisibleTank", "level": "1", "pathIndex": "1" },	
				],
				
				//wave 8
				[
					// delay before the wave
					35000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[700, 700], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
				],
				
				//wave 9
				[
					// delay before the wave
					20000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[500, 500], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					{ "name": "plane", "level": "2", "pathIndex": "0" },
					
					{ "name": "plane", "level": "0", "pathIndex": "1" },	
					{ "name": "plane", "level": "0", "pathIndex": "1" },	
					{ "name": "plane", "level": "0", "pathIndex": "1" },	
					{ "name": "plane", "level": "0", "pathIndex": "1" },	
					{ "name": "plane", "level": "0", "pathIndex": "1" },	
					{ "name": "plane", "level": "0", "pathIndex": "1" },	
					{ "name": "plane", "level": "0", "pathIndex": "1" },	
					{ "name": "plane", "level": "0", "pathIndex": "1" },	
					{ "name": "helicopter", "level": "0", "pathIndex": "1" },	
					{ "name": "helicopter", "level": "0", "pathIndex": "1" },	
					{ "name": "helicopter", "level": "0", "pathIndex": "1" },	
					{ "name": "helicopter", "level": "0", "pathIndex": "1" },	
					{ "name": "helicopter", "level": "0", "pathIndex": "1" },	
					{ "name": "helicopter", "level": "0", "pathIndex": "1" },	
					{ "name": "helicopter", "level": "0", "pathIndex": "1" },	
					{ "name": "helicopter", "level": "0", "pathIndex": "1" },	
				],
				
				//wave 10
				[
					// delay before the wave
					50000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[700, 700], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "0" },
					
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
					{ "name": "mobileVehicle", "level": "2", "pathIndex": "1" },	
				],
				
				//wave 11
				[
					// delay before the wave
					10000, 
					// delay after the wave
					2000, 
					// delay between units (for different paths)
					[8000, 8000], 
					// delay between units special
					[],
					// tipIndex
					-1,
					{ "name": "walkingRobot", "level": "2", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "2", "pathIndex": "0" },
					{ "name": "walkingRobot", "level": "2", "pathIndex": "0" },
					{ "name": "repairTank", "level": "0", "pathIndex": "0" },
					{ "name": "repairTank", "level": "0", "pathIndex": "0" },
					
					{ "name": "walkingRobot", "level": "2", "pathIndex": "1" },	
					{ "name": "walkingRobot", "level": "2", "pathIndex": "1" },	
					{ "name": "walkingRobot", "level": "2", "pathIndex": "1" },	
					{ "name": "repairTank", "level": "0", "pathIndex": "1" },	
					{ "name": "repairTank", "level": "0", "pathIndex": "1" },	
				],
		];
		
	}

}