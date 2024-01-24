/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.ammo.missiles
{
	import constants.WeaponContants;
	import islandBreak.controllers.WeaponController;
	import events.WeaponEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import nslib.AIPack.targetFollowing.TargetFollower;
	import nslib.core.IReusable;
	import nslib.timers.AdvancedTimer;
	import nslib.timers.events.AdvancedTimerEvent;
	import weapons.base.IWeapon;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Missile extends TargetFollower implements IReusable
	{
		[Embed(source="F:/Island Defence/media/images/weapon/common weapon/missile 03.png")]
		private static var missile01Image:Class;
		
		////////////////////////
		
		public var hitPower:Number = WeaponContants.DEFAULT_MISSILE_HIT_POWER;
		
		///////////
		
		private var lifetimeTimer:AdvancedTimer = new AdvancedTimer(5000, 1);
		
		////////////////////////
		
		public function Missile()
		{
			motionSpeed = 10;
			rotationSpeed = 0.1;
			rotationAcceleration = 0.5;
			accuarcy = 10;
			
			drawMissile();
		}
		
		////////////////////////
		
		//----------------------------------
		//  hitObject
		//----------------------------------
		
		public function get hitObject():IWeapon
		{
			return super.target as IWeapon;
		}
		
		public function set hitObject(value:IWeapon):void
		{
			super.target = DisplayObject(value);
		}
		
		//----------------------------------
		//  lifetime
		//----------------------------------
		
		public function get lifetime():Number
		{
			return lifetimeTimer.delay;
		}
		
		public function set lifetime(value:Number):void
		{
			lifetimeTimer.delay;
		}
		
		//----------------------------------
		//  poolID
		//----------------------------------
		
		private var _poolID:String = "none";
		
		public function get poolID():String
		{
			return _poolID;
		}
		
		public function set poolID(value:String):void
		{
			_poolID = value;
		}
		
		////////////////////////
		
		public function prepareForPooling():void
		{
			if (isActive)
				throw new Error("Attempt to pool active Missle object!");
				
			hitPower = WeaponContants.DEFAULT_MISSILE_HIT_POWER;
		}
		
		public function prepareForReuse():void
		{
			if (isActive)
				throw new Error("Attempt to reuse active Missle object!");
		}
		
		////////////////////////
		
		override public function activate():void
		{
			super.activate();
			
			lifetimeTimer.addEventListener(AdvancedTimerEvent.TIMER_COMPLETED, lifetimeTimer_timerCompletedHandler);
			lifetimeTimer.start();
		}
		
		/////////////////
		
		private function lifetimeTimer_timerCompletedHandler(event:AdvancedTimerEvent):void
		{
			lifetimeTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, lifetimeTimer_timerCompletedHandler);
			dispatchEvent(new WeaponEvent(WeaponEvent.DESTROYED));
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			
			lifetimeTimer.removeEventListener(AdvancedTimerEvent.TIMER_COMPLETED, lifetimeTimer_timerCompletedHandler);
			lifetimeTimer.stop();
		}
		
		/////////////////////
		
		override protected function tryReachTarget():void
		{
			super.tryReachTarget();
			
			if (hitsTarget())
				dispatchEvent(new WeaponEvent(WeaponEvent.TARGET_REACHED));
			
			leaveTrace();
		}
		
		private function hitsTarget():Boolean
		{
			return ((Math.abs(hitObject.x - x) < (hitObject.rect.width / 2)) && (Math.abs(hitObject.y - y) < (hitObject.rect.height / 2)))
		}
		
		/////////////////////////
		
		private var traceBitmapData:BitmapData = null;
		
		private function prepareTrace():void
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0, 0.7);
			shape.graphics.drawCircle(2, 2, 2);
			
			traceBitmapData = new BitmapData(4, 4, true, 0x000000);
			traceBitmapData.draw(shape);
		}
		
		private function leaveTrace():void
		{
			WeaponController.putImageForFadingAt(x - 15 * currentCosA -2, y - 15 * currentSinA -2, traceBitmapData);
		}
		
		//////////////////////////
		
		private function drawMissile():void
		{
			//body
			var body:Bitmap = new missile01Image() as Bitmap;
			body.x = body.height / 2;
			body.y = -body.width / 2;
			body.rotation = 90;
			addChild(body);
			
			prepareTrace();
		}
	
	}

}