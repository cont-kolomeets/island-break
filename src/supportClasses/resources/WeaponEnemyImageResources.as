/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses.resources
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponEnemyImageResources
	{
		//------------------------------------------
		// images: small
		//------------------------------------------
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/bike.png")]
		private static var mobileVehicle01SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/car.png")]
		private static var mobileVehicle02SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/triball.png")]
		private static var mobileVehicle03SmallImage:Class;
		
		///////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/tank 01.png")]
		private static var tank01SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/tank 02.png")]
		private static var tank02SmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/light fighter.png")]
		private static var palne01SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/speedy bombardier.png")]
		private static var palne02SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/tiny swifter.png")]
		private static var palne03SmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/light helicopter.png")]
		private static var helicopter01SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/heavy helicopter.png")]
		private static var helicopter02SmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/energy ball 01.png")]
		private static var energyBall01SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/energy ball 02.png")]
		private static var energyBall02SmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/chicken.png")]
		private static var walkingRobot01SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/mastadont.png")]
		private static var walkingRobot02SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/turtle.png")]
		private static var walkingRobot03SmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/invisible tank 01.png")]
		private static var invisibleTank01SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/invisible tank 02.png")]
		private static var invisibleTank02SmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/light bomber.png")]
		private static var bomberTank01SmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/heavy bomber.png")]
		private static var bomberTank02SmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/plane factory.png")]
		private static var factoryTank01SmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs small/repair tank.png")]
		private static var repairTank01SmallImage:Class;
		
		///////////
		
		public static function getSmallImageById(id:int):Class
		{
			switch (id)
			{
				case 0: 
					return mobileVehicle01SmallImage;
				case 1: 
					return mobileVehicle02SmallImage;
				case 2: 
					return mobileVehicle03SmallImage;
				
				case 3: 
					return tank01SmallImage;
				case 4: 
					return tank02SmallImage;
				
				case 5: 
					return palne01SmallImage;
				case 6: 
					return palne02SmallImage;
				case 7: 
					return palne03SmallImage;
				
				case 8: 
					return helicopter01SmallImage;
				case 9: 
					return helicopter02SmallImage;
				
				case 10: 
					return energyBall01SmallImage;
				case 11: 
					return energyBall02SmallImage;
				
				case 12: 
					return walkingRobot01SmallImage;
				case 13: 
					return walkingRobot02SmallImage;
				case 14: 
					return walkingRobot03SmallImage;
				
				case 15: 
					return invisibleTank01SmallImage;
				case 16: 
					return invisibleTank02SmallImage;
				
				case 17: 
					return bomberTank01SmallImage;
				case 18: 
					return bomberTank02SmallImage;
				
				case 19: 
					return factoryTank01SmallImage;
				
				case 20: 
					return repairTank01SmallImage;
			
			}
			
			return null;
		}
		
		//------------------------------------------
		// images: big
		//------------------------------------------
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/bike.png")]
		private static var mobileVehicle01BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/car.png")]
		private static var mobileVehicle02BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/triball.png")]
		private static var mobileVehicle03BigImage:Class;
		
		///////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/tank 01.png")]
		private static var tank01BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/tank 02.png")]
		private static var tank02BigImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/light fighter.png")]
		private static var palne01BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/speedy bombardier.png")]
		private static var palne02BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/tiny swifter.png")]
		private static var palne03BigImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/light helicopter.png")]
		private static var helicopter01BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/heavy helicopter.png")]
		private static var helicopter02BigImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/energy ball 01.png")]
		private static var energyBall01BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/energy ball 02.png")]
		private static var energyBall02BigImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/chicken.png")]
		private static var walkingRobot01BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/mastadont.png")]
		private static var walkingRobot02BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/turtle.png")]
		private static var walkingRobot03BigImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/invisible tank 01.png")]
		private static var invisibleTank01BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/invisible tank 02.png")]
		private static var invisibleTank02BigImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/light bomber.png")]
		private static var bomberTank01BigImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/heavy bomber.png")]
		private static var bomberTank02BigImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/plane factory.png")]
		private static var factoryTank01BigImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon thumbs big/repair tank.png")]
		private static var repairTank01BigImage:Class;
		
		///////////
		
		public static function getBigImageById(id:int):Class
		{
			switch (id)
			{
				case 0: 
					return mobileVehicle01BigImage;
				case 1: 
					return mobileVehicle02BigImage;
				case 2: 
					return mobileVehicle03BigImage;
				
				case 3: 
					return tank01BigImage;
				case 4: 
					return tank02BigImage;
				
				case 5: 
					return palne01BigImage;
				case 6: 
					return palne02BigImage;
				case 7: 
					return palne03BigImage;
				
				case 8: 
					return helicopter01BigImage;
				case 9: 
					return helicopter02BigImage;
				
				case 10: 
					return energyBall01BigImage;
				case 11: 
					return energyBall02BigImage;
				
				case 12: 
					return walkingRobot01BigImage;
				case 13: 
					return walkingRobot02BigImage;
				case 14: 
					return walkingRobot03BigImage;
				
				case 15: 
					return invisibleTank01BigImage;
				case 16: 
					return invisibleTank02BigImage;
				
				case 17: 
					return bomberTank01BigImage;
				case 18: 
					return bomberTank02BigImage;
				
				case 19: 
					return factoryTank01BigImage;
				
				case 20: 
					return repairTank01BigImage;
			
			}
			
			return null;
		}
		
		//------------------------------------------
		// images: small in-game images
		//------------------------------------------
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/bike.png")]
		private static var mobileVehicle01InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/car.png")]
		private static var mobileVehicle02InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/triball.png")]
		private static var mobileVehicle03InGameSmallImage:Class;
		
		///////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/tank 01.png")]
		private static var tank01InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/tank 02.png")]
		private static var tank02InGameSmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/light fighter.png")]
		private static var palne01InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/speedy bombardier.png")]
		private static var palne02InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/tiny swifter.png")]
		private static var palne03InGameSmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/light helicopter.png")]
		private static var helicopter01InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/heavy helicopter.png")]
		private static var helicopter02InGameSmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/energy ball 01.png")]
		private static var energyBall01InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/energy ball 02.png")]
		private static var energyBall02InGameSmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/chicken.png")]
		private static var walkingRobot01InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/mastadont.png")]
		private static var walkingRobot02InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/turtle.png")]
		private static var walkingRobot03InGameSmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/invisible tank 01.png")]
		private static var invisibleTank01InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/invisible tank 02.png")]
		private static var invisibleTank02InGameSmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/light bomber.png")]
		private static var bomberTank01InGameSmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/heavy bomber.png")]
		private static var bomberTank02InGameSmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/plane factory.png")]
		private static var factoryTank01InGameSmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon in game thumbs small/repair tank.png")]
		private static var repairTank01InGameSmallImage:Class;
		
		///////////
		
		public static function getSmallInGameImageById(id:int):Class
		{
			switch (id)
			{
				case 0: 
					return mobileVehicle01InGameSmallImage;
				case 1: 
					return mobileVehicle02InGameSmallImage;
				case 2: 
					return mobileVehicle03InGameSmallImage;
				
				case 3: 
					return tank01InGameSmallImage;
				case 4: 
					return tank02InGameSmallImage;
				
				case 5: 
					return palne01InGameSmallImage;
				case 6: 
					return palne02InGameSmallImage;
				case 7: 
					return palne03InGameSmallImage;
				
				case 8: 
					return helicopter01InGameSmallImage;
				case 9: 
					return helicopter02InGameSmallImage;
				
				case 10: 
					return energyBall01InGameSmallImage;
				case 11: 
					return energyBall02InGameSmallImage;
				
				case 12: 
					return walkingRobot01InGameSmallImage;
				case 13: 
					return walkingRobot02InGameSmallImage;
				case 14: 
					return walkingRobot03InGameSmallImage;
				
				case 15: 
					return invisibleTank01InGameSmallImage;
				case 16: 
					return invisibleTank02InGameSmallImage;
				
				case 17: 
					return bomberTank01InGameSmallImage;
				case 18: 
					return bomberTank02InGameSmallImage;
				
				case 19: 
					return factoryTank01InGameSmallImage;
				
				case 20: 
					return repairTank01InGameSmallImage;
			
			}
			
			return null;
		}
		
		
		//------------------------------------------
		// images: small gray images
		//------------------------------------------
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/bike.png")]
		private static var mobileVehicle01GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/car.png")]
		private static var mobileVehicle02GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/triball.png")]
		private static var mobileVehicle03GraySmallImage:Class;
		
		///////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/tank 01.png")]
		private static var tank01GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/tank 02.png")]
		private static var tank02GraySmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/light fighter.png")]
		private static var palne01GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/speedy bombardier.png")]
		private static var palne02GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/tiny swifter.png")]
		private static var palne03GraySmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/light helicopter.png")]
		private static var helicopter01GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/heavy helicopter.png")]
		private static var helicopter02GraySmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/energy ball 01.png")]
		private static var energyBall01GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/energy ball 02.png")]
		private static var energyBall02GraySmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/chicken.png")]
		private static var walkingRobot01GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/mastadont.png")]
		private static var walkingRobot02GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/turtle.png")]
		private static var walkingRobot03GraySmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/invisible tank 01.png")]
		private static var invisibleTank01GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/invisible tank 02.png")]
		private static var invisibleTank02GraySmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/light bomber.png")]
		private static var bomberTank01GraySmallImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/heavy bomber.png")]
		private static var bomberTank02GraySmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/plane factory.png")]
		private static var factoryTank01GraySmallImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon gray thumbs small/repair tank.png")]
		private static var repairTank01GraySmallImage:Class;
		
		///////////
		
		public static function getSmallImageForDisabledStateById(id:int):Class
		{
			switch (id)
			{
				case 0: 
					return mobileVehicle01GraySmallImage;
				case 1: 
					return mobileVehicle02GraySmallImage;
				case 2: 
					return mobileVehicle03GraySmallImage;
				
				case 3: 
					return tank01GraySmallImage;
				case 4: 
					return tank02GraySmallImage;
				
				case 5: 
					return palne01GraySmallImage;
				case 6: 
					return palne02GraySmallImage;
				case 7: 
					return palne03GraySmallImage;
				
				case 8: 
					return helicopter01GraySmallImage;
				case 9: 
					return helicopter02GraySmallImage;
				
				case 10: 
					return energyBall01GraySmallImage;
				case 11: 
					return energyBall02GraySmallImage;
				
				case 12: 
					return walkingRobot01GraySmallImage;
				case 13: 
					return walkingRobot02GraySmallImage;
				case 14: 
					return walkingRobot03GraySmallImage;
				
				case 15: 
					return invisibleTank01GraySmallImage;
				case 16: 
					return invisibleTank02GraySmallImage;
				
				case 17: 
					return bomberTank01GraySmallImage;
				case 18: 
					return bomberTank02GraySmallImage;
				
				case 19: 
					return factoryTank01GraySmallImage;
				
				case 20: 
					return repairTank01GraySmallImage;
			
			}
			
			return null;
		}
		
	
	}

}