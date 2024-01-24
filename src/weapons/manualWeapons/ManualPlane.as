package weapons.manualWeapons
{
	import events.WeaponEvent;
	import flash.display.InterpolationMethod;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import nslib.core.Globals;
	import nslib.timers.events.AdvancedTimerEvent;
	import weapons.base.IWeapon;
	import weapons.enemy.EnemyPlane;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ManualPlane extends EnemyPlane
	{
		
		public function ManualPlane(level:int = 0)
		{
			super(level)
		}
		
		override protected function performMovement():void
		{
			// no auto movement
		}
		
		override public function get isBusyRotatingForTarget():Boolean
		{
			return true;
		}
		
		/*override public function busyReloadingMissile():Boolean
		{
			return true;
		}*/
		
		override protected function fireAtTarget(target:Point):void
		{
			super.fireAtTarget(target);
		}
		
		override public function fireMissileAt(target:IWeapon):Boolean
		{
			return super.fireMissileAt(target);
		}
		
		override public function activate():void
		{
			super.activate();
			Globals.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			Globals.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		////////////////
		
		private var firePoint:Point = new Point();
		
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				updateCurrentSinCos();
				firePoint.x = x + (100 + motionSpeed * 100) * currentCosA;
				firePoint.y = y + (100 + motionSpeed * 100) * currentSinA;
				fireAtTarget(firePoint);
			}
		}
		
		override protected function workingDelayTimer_timerCompletedHandler(event:AdvancedTimerEvent):void
		{
			dispatchEvent(new WeaponEvent(WeaponEvent.OUT_OF_FUEL));
		}
		
		public function restoreFuel():void
		{
			workingDelayTimer.reset();
			workingDelayTimer.start();
		}
	
	}

}