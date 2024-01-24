/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import flash.display.Shape;
	import nslib.controls.NSSprite;
	import weapons.base.Weapon;
	import weapons.repairCenter.RepairCenter;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponHitRadiusVisualizer extends NSSprite
	{
		private var hitRadiusShape:Shape = new Shape();
		
		//------------------------------------------
		// style settings
		//------------------------------------------
		
		///// current 
		private var currentHitRadiusShapeFillColorDefault:int = 0x00FF00;
		
		private var currentHitRadiusShapeFillColorRepairCenter:int = 0x882BD5;
		
		private var currentHitRadiusShapeFillAlpha:Number = 0.15;
		
		private var currentHitRadiusShapeStrokeColorDefault:int = 0x00FF00;
		
		private var currentHitRadiusShapeStrokeColorRepairCenter:int = 0x882BD5;
		
		private var currentHitRadiusShapeStrokeAlpha:Number = 0.5;
		
		////// next
		
		private var nextHitRadiusShapeFillColor:int = 0x16B3F5;
		
		private var nextHitRadiusShapeFillAlpha:Number = 0.2;
		
		private var nextHitRadiusShapeStrokeColor:int = 0x16B3F5;
		
		private var nextHitRadiusShapeStrokeAlpha:Number = 0.5;
		
		//////
		
		private var currentlySelectedWeapon:Weapon = null;
		
		////////////////////////////
		
		public function WeaponHitRadiusVisualizer()
		{
			super();
		}
		
		//------------------------------------------------------------------------------
		//
		// Working with radius
		//
		//------------------------------------------------------------------------------
		
		//------------------------------------------
		// methods
		//------------------------------------------
		
		public function getWeaponWhichHitRadiusIsShowing():Weapon
		{
			return currentlySelectedWeapon;
		}
		
		public function showHitRadiusForWeapon(weapon:Weapon):void
		{
			currentlySelectedWeapon = weapon;
						
			drawHitRadiusShape(weapon.hitRadius);
			hitRadiusShape.x = weapon.x;
			hitRadiusShape.y = weapon.y;
			addChild(hitRadiusShape);
		}
		
		public function updateHitRadiusPositionForWeapon(weapon:Weapon):void
		{
			currentlySelectedWeapon = weapon;
						
			hitRadiusShape.x = weapon.x;
			hitRadiusShape.y = weapon.y;
		}
		
		private function drawHitRadiusShape(currentRadius:Number, nextRadius:Number = NaN):void
		{
			hitRadiusShape.graphics.clear();
			
			if (!isNaN(nextRadius))
			{
				hitRadiusShape.graphics.lineStyle(1, nextHitRadiusShapeStrokeColor, nextHitRadiusShapeStrokeAlpha);
				hitRadiusShape.graphics.beginFill(nextHitRadiusShapeFillColor, nextHitRadiusShapeFillAlpha);
				hitRadiusShape.graphics.drawCircle(0, 0, nextRadius);
			}
			
			hitRadiusShape.graphics.lineStyle(1, (currentlySelectedWeapon is RepairCenter) ? currentHitRadiusShapeStrokeColorRepairCenter : currentHitRadiusShapeStrokeColorDefault, currentHitRadiusShapeStrokeAlpha);
			hitRadiusShape.graphics.beginFill((currentlySelectedWeapon is RepairCenter) ? currentHitRadiusShapeFillColorRepairCenter : currentHitRadiusShapeFillColorDefault, currentHitRadiusShapeFillAlpha);
			hitRadiusShape.graphics.drawCircle(0, 0, currentRadius);
		}
		
		public function hideHitRadiusForCurrentWeapon():void
		{
			if (contains(hitRadiusShape))
				removeChild(hitRadiusShape);
			
			currentlySelectedWeapon = null;
		}
		
		public function showHitRadiusForWeaponNextLevel(weapon:Weapon):void
		{
			hideHitRadiusForCurrentWeapon();
			
			if (!weapon.nextInfo)
			{
				showHitRadiusForWeapon(weapon);
				return;
			}
			
			currentlySelectedWeapon = weapon;
						
			drawHitRadiusShape(weapon.currentInfo.hitRadius, weapon.nextInfo.hitRadius);
			hitRadiusShape.x = weapon.x;
			hitRadiusShape.y = weapon.y;
			addChild(hitRadiusShape);
		}
	
	}

}