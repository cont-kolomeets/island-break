/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package bot
{
	import infoObjects.gameInfo.DevelopmentInfo;
	import infoObjects.gameInfo.GameInfo;
	import infoObjects.WeaponInfo;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class DevelopmentCenterUpgrader
	{
				
		private static const upgradeStack:Array = 
		[
			{name:"electricTower",level:0},
			{name:"airSupport",level:0},
			{name:"bombSupport", level:0},
			
			{name:"cannon", level:1},
			
			{name:"machineGun",level:1},
			{name:"airSupport", level:1 },
			
			{name:"electricTower",level:1},
			{name:"repairCenter", level:0},
			
			{name:"cannon",level:2},
			{name:"bombSupport", level:1},
			
			{name:"machineGun", level:2},
			
			{name:"electricTower",level:2},
			{name:"bombSupport", level:2},
			
			{name:"airSupport", level:2},
			
			{name:"repairCenter",level:1},
			{name:"repairCenter",level:2},
		];
		
		public static function updateCurrentDevInfo():void
		{
			var gameInfo:GameInfo = GameBot.getCurrentGameInfo();
			var devInfo:DevelopmentInfo = gameInfo.developmentInfo;
					
				if (devInfo.allWeaponsDeveloded())
					return;
				
				for each(var stackObject:Object in upgradeStack)
				{
					var weaponInfo:WeaponInfo = WeaponResources.getWeaponInfoByIDAndLevel(String(stackObject.name), int(stackObject.level));
						
					if (!devInfo.levelIsDevelopedForWeapon(weaponInfo))
					{
						if (weaponInfo.developmentPrice > gameInfo.starsAvailable)
							return;
							
						devInfo.setLevelUpForWeapon(weaponInfo.weaponId);
						gameInfo.starsSpent += weaponInfo.developmentPrice;
					}
				}
		}
	}

}