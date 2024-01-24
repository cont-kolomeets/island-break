/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.objects
{
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import infoObjects.WeaponInfo;
	import nslib.interactableObjects.MovableObject;
	import supportClasses.resources.WeaponResources;
	import weapons.base.IGroundWeapon;
	import weapons.base.IPurchasableItem;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Obstacle extends MovableObject implements IPurchasableItem, IGroundWeapon
	{
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/barricade.png")]
		private static var obstacleImage:Class;
		
		/////////////////////////
		
		public var size:int = 10;
		
		public var weaponId:String = WeaponResources.USER_OBSTACLE;
		
		public var level:int = 0;
		
		private var buitTimer:Timer = new Timer(300, 1);
		
		private var imageHolder:Bitmap = null;
		
		///////////////////////////////////
		
		public function Obstacle()
		{
			super();
			drawObstacle();
		}
		
		////////////////////////////////////
		
		//----------------------------------
		//  isPlaced
		//----------------------------------
		
		private var _isPlaced:Boolean = false;
		
		public function get isPlaced():Boolean
		{
			return _isPlaced;
		}
		
		public function set isPlaced(value:Boolean):void
		{
			_isPlaced = value;
			
			if (value)
			{
				buitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, buildTimer_timerCompleteHandler);
				buitTimer.start();
			}
		}
		
		//----------------------------------
		//  isBuilt
		//----------------------------------	
		
		// indicates that the obstacle is built and ready
		private var _isBuilt:Boolean = false;
		
		public function get isBuilt():Boolean
		{
			return _isBuilt;
		}
		
		//----------------------------------
		//  currentInfo
		//----------------------------------
		
		public function get currentInfo():WeaponInfo
		{
			return WeaponResources.getWeaponInfoByIDAndLevel(weaponId, level);
		}
		
		//----------------------------------
		//  rect
		//----------------------------------
		
		private var _rect:Rectangle = new Rectangle(-15, -15, 30, 30);
				
		public function get rect():Rectangle 
		{
			return _rect;
		}
		
		//----------------------------------
		//  affordable
		//----------------------------------
		
		private var _affordable:Boolean = false;
		
		public function get affordable():Boolean
		{
			return _affordable;
		}
		
		public function set affordable(value:Boolean):void
		{
			_affordable = value;
			
			//mouseEnabled = value;
			//mouseChildren = value;
			
			if (value)
				addMouseSensitivity();
			else
				removeMouseSensitivity();
			
			alpha = value ? 1 : 0.5;
		}
		
		/////////////
		
		private function buildTimer_timerCompleteHandler(event:TimerEvent):void
		{
			buitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, buildTimer_timerCompleteHandler);
			_isBuilt = true;
		}
		
		////////////////////////////////////
		
		private function drawObstacle():void
		{
			imageHolder = new obstacleImage() as Bitmap;
			imageHolder.x = -imageHolder.width / 2;
			imageHolder.y = -imageHolder.height / 2;
			
			addChild(imageHolder);
		}
	
	}

}