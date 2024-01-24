/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.base.supportClasses
{
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponPreferenceDescriptor
	{
		public static const SELECTION_PARAMETER_ANY:String = "parameterAny";
		
		//// unit parameters (armor and distance)
		
		// will select a unit with the highest armor.
		public static const SELECTION_PARAMETER_STRONGEST:String = "strongest";
		
		// will select a unit with the lowest armor.
		public static const SELECTION_PARAMETER_WEAKEST:String = "weakest";
		
		// will select the closest unit within a hit radius.
		public static const SELECTION_PARAMETER_CLOSEST:String = "closest";
		
		// will select the furthest unit within a hit radius.
		public static const SELECTION_PARAMETER_FURTHERST:String = "furtherst";
		
		///// unit type (ground/air/any)
		
		// will select mostly ground type
		public static const SELECTION_TYPE_GROUND:String = "ground";
		
		public static const SELECTION_TYPE_AIR:String = "air";
		
		public static const SELECTION_TYPE_ANY:String = "typeAny";
		
		///////////
		
		public var hostWeapon:Weapon = null;
		
		//////////
		
		public function WeaponPreferenceDescriptor(selectionParameterPreference:String = "parameterAny", selectionTypePreference:String = "typeAny", preferredPathIndex:int = -1)
		{
			this.selectionParameterPreference = selectionParameterPreference;
			this.selectionTypePreference = selectionTypePreference;
			this.preferredPathIndex = preferredPathIndex;
		}
		
		//////////
		
		private var _preferredPathIndex:int = -1;
		
		public function get preferredPathIndex():int
		{
			return _preferredPathIndex;
		}
		
		public function set preferredPathIndex(value:int):void
		{
			_preferredPathIndex = value;
			
			if (hostWeapon)
				hostWeapon.notifyPreferencesChanged();
		}
		
		///////////
		
		private var _selectionParameterPreference:String = SELECTION_PARAMETER_ANY;
		
		public function get selectionParameterPreference():String
		{
			return _selectionParameterPreference;
		}
		
		public function set selectionParameterPreference(value:String):void
		{
			_selectionParameterPreference = value;
			
			if (hostWeapon)
				hostWeapon.notifyPreferencesChanged();
		}
		
		///////////
		
		private var _selectionTypePreference:String = SELECTION_TYPE_ANY;
		
		public function get selectionTypePreference():String
		{
			return _selectionTypePreference;
		}
		
		public function set selectionTypePreference(value:String):void
		{
			_selectionTypePreference = value;
			
			if (hostWeapon)
				hostWeapon.notifyPreferencesChanged();
		}
	}

}