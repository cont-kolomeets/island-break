/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects 
{
	import weapons.base.IGroundWeapon;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponStoreInfo 
	{
		public var item:IGroundWeapon;
		
		public var price:String;
		
		public var affordable:Boolean;
		
		public function WeaponStoreInfo(item:IGroundWeapon, price:String, affordable:Boolean) 
		{
			this.item = item;
			this.price = price;
			this.affordable = affordable;
		}
		
	}

}