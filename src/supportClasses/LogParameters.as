/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportClasses 
{
	import weapons.base.IWeapon;
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class LogParameters 
	{
		public var message:String = null;
		
		public var x:int = 0;
		
		public var y:int = 0;
		
		public var currentLevel:int = 0;
		
		public var oldLevel:int = 0;
		
		public var newLevel:int = 0;
		
		public var moneyChanged:Boolean = false;
		
		public var moneyAvailableNewValue:int = 0;
		
		public var damagePercentage:Number = 0; // 0 - 1
		
		public var pathPercentagePassed:Number = 0; // 0 - 1
		
		public var timeStamp:int = 0;
		
		public var item:IWeapon = null;
		
		public var totalNumOfTilesForUserWeapon:int = 0;
		
		public var userTilesOccupationPercentage:Number = 0; // 0 - 1;
		
		public var unitAdded:Boolean = false;
		
		public var waveCount:int = 0;
		
		public var numPaths:int = 0;
		
		public function LogParameters(message:String) 
		{
			this.message = message;
		}
		
	}

}