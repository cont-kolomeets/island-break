/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.toolTips 
{
	import infoObjects.WeaponInfo;
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponInfoToolTipContentDescriptor 
	{
		public var weaponInfo:WeaponInfo;
		
		// indicates whether this tooltip show upgrade information
		public var isForNextLevel:Boolean;
		
		public function WeaponInfoToolTipContentDescriptor(weaponInfo:WeaponInfo, isForNextLevel:Boolean = false) 
		{
			this.weaponInfo = weaponInfo;
			this.isForNextLevel = isForNextLevel;
		}
		
	}

}