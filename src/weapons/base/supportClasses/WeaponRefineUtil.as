/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.base.supportClasses
{
	import weapons.base.AirCraft;
	import weapons.base.IGroundWeapon;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponRefineUtil
	{
		// for optimization
		private static const filteredUnits:Array = [];
		
		public static function findMostPreferrableTargetForWeapon(weapon:Weapon, targets:Array, getRandomEnemyFromRefinedOnes:Boolean = false, optimizeEnemySelection:Boolean = false):IWeapon
		{
			if (targets.length == 0)
				return null;
			
			filteredUnits.length = 0;
			var selectionType:String = weapon.preferenceDescriptor.selectionTypePreference;
			var selectionParameter:String = weapon.preferenceDescriptor.selectionParameterPreference;
			var lastReachableUnit:IWeapon = null;
			
			for each (var enemy:IWeapon in targets)
			{
				// check only for active and reachable units
				if (WeaponUtil.weaponCanHitTarget(weapon, enemy))
				{
					// if this enemy is preferred and can be hit
					// return it right away
					if (weapon.preferredHitObject == enemy)
						return enemy;
					
					// checking for conditions
					lastReachableUnit = enemy;
					
					var match:Boolean = true;
					
					// check for path index
					// if path index specified that means flying enemies should be ignored
					match = ((weapon.preferenceDescriptor.preferredPathIndex == -1) || (enemy is Weapon && Weapon(enemy).pathIndex == weapon.preferenceDescriptor.preferredPathIndex))
					
					// check for selected type
					if (match && selectionType != WeaponPreferenceDescriptor.SELECTION_TYPE_ANY)
						match = (((selectionType == WeaponPreferenceDescriptor.SELECTION_TYPE_AIR) && (enemy is AirCraft)) || ((selectionType == WeaponPreferenceDescriptor.SELECTION_TYPE_GROUND) && (enemy is IGroundWeapon)));
					
					if (match)
						filteredUnits.push(enemy);
				}
				//else
					// if this enemy was assigned as preferred but cannot be possibly hit
					// just clear it
					//if (weapon.preferredHitObject == enemy)
					//	weapon.preferredHitObject = null;
			}
			
			// if the current preferred enemy (if any assigend) did not match the conditions
			// just clear the reference
			//weapon.preferredHitObject = null;
			
			// if no units match conditions then select at least one
			if (filteredUnits.length == 0 && lastReachableUnit)
				return lastReachableUnit;
			
			if (filteredUnits.length == 0)
				return null;
			
			// need to sort to find the most sutable unit
			/*if (selectionParameter != WeaponPreferenceDescriptor.SELECTION_PARAMETER_ANY)
			   {
			   if (selectionParameter == WeaponPreferenceDescriptor.SELECTION_PARAMETER_STRONGEST || selectionParameter == WeaponPreferenceDescriptor.SELECTION_PARAMETER_WEAKEST)
			   {
			   filteredUnits.sortOn("armor");
			
			   return WeaponPreferenceDescriptor.SELECTION_PARAMETER_STRONGEST ? filteredUnits[filteredUnits.length - 1] : filteredUnits[0];
			   }
			
			   if (selectionParameter == WeaponPreferenceDescriptor.SELECTION_PARAMETER_CLOSEST || selectionParameter == WeaponPreferenceDescriptor.SELECTION_PARAMETER_FURTHERST)
			   {
			   filteredUnits.sort(function(unit1:IWeapon, unit2:IWeapon):int
			   {
			   var d1:Number = Math.abs(weapon.x - unit1.x) + Math.abs(weapon.y - unit1.y);
			   var d2:Number = Math.abs(weapon.x - unit2.x) + Math.abs(weapon.y - unit2.y);
			
			   return (d1 == d2) ? 0 : ((d1 < d2) ? -1 : 1);
			   });
			
			   return WeaponPreferenceDescriptor.SELECTION_PARAMETER_FURTHERST ? filteredUnits[filteredUnits.length - 1] : filteredUnits[0];
			   }
			 }*/
			
			// if getRandomEnemyFromRefinedOnes is true
			// just take a random enemy.
			if (getRandomEnemyFromRefinedOnes)
				return filteredUnits[Math.round(Math.random() * (filteredUnits.length - 1))];
			
			// now we need to make the unit persist on the current target.
			if (weapon.hitObject)
				for each (enemy in filteredUnits)
					if (weapon.hitObject == enemy)
						return enemy;
			
			// if the previously followed enemy is not available any more
			// check for the optimization flag
			// this takes some extra calculations
			if (optimizeEnemySelection)
			{
				var optimalEnemy:IWeapon = null;
				var minDist:Number = Number.POSITIVE_INFINITY;
				
				for each (enemy in filteredUnits)
				{
					var dx:Number = enemy.x - weapon.x;
					var dy:Number = enemy.y - weapon.y;
					
					var dist:Number = Math.sqrt(dx * dx + dy * dy);
					
					if (dist < minDist)
					{
						minDist = dist;
						optimalEnemy = enemy;
					}
				}
				
				if (optimalEnemy)
					return optimalEnemy;
			}
			
			// otherwise just return the last in the array
			return filteredUnits[filteredUnits.length - 1];
		}
	}
}