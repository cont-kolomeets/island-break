/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.user
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import mainPack.DifficultyConfig;
	import supportClasses.resources.WeaponResources;
	import weapons.base.PlaneBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UserPlane extends PlaneBase
	{
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/planes/plane 01.png")]
		private static var plane01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/planes/plane 02.png")]
		private static var plane02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/planes/plane 03.png")]
		private static var plane03Image:Class;
		
		/////////// shadows
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/planes/plane 01 shadow.png")]
		private static var plane01ShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/planes/plane 02 shadow.png")]
		private static var plane02ShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/user weapon/planes/plane 03 shadow.png")]
		private static var plane03ShadowImage:Class;
		
		///////////////////
		
		public function UserPlane(level:int = 0)
		{
			super(WeaponResources.USER_AIR_SUPPORT, level);
			
			//workingDelayTimer.delay = workingDelayTimer.delay * DifficultyConfig.currentBonusInfo.airSupportWorkingTimeCoefficient;
		}
		
		//------------------------------------------------------------------------------
		//
		// Drawing levels
		//
		//------------------------------------------------------------------------------
		
		override protected function drawWeaponLevel0():void
		{
			// in case this object is returned for reuse
			removeAllChildren();
			
			body.removeAllChildren();
			
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			shadowContainer.removeAllChildren();
			var shadowImage:Bitmap = new plane01ShadowImage() as Bitmap;
			shadowImage.rotation = 90;
			shadowImage.x = shadowImage.width / 2;
			shadowImage.y = -shadowImage.height / 2;
			shadowImage.smoothing = true;
			shadowContainer.addChild(shadowImage);
			
			//body
			var bodyImage:Bitmap = new plane01Image() as Bitmap;
			bodyImage.rotation = 90;
			bodyImage.x = bodyImage.width / 2;
			bodyImage.y = -bodyImage.height / 2;
			bodyImage.smoothing = true;
			body.addChild(bodyImage);
			
			shootingOffsetX = 20;
			shootingOffsetY = 10;
			
			prepareTrace();
			
			addChild(shadowContainer);
			addChild(body);
			addChild(energyBar);
			addChild(flightBar);
			
			updateEnergyBar();
			updateFlightBar();
		}
		
		override protected function drawWeaponLevel1():void
		{
			// in case this object is returned for reuse
			removeAllChildren();
			
			body.removeAllChildren();
			
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			shadowContainer.removeAllChildren();
			var shadowImage:Bitmap = new plane02ShadowImage() as Bitmap;
			shadowImage.rotation = 90;
			shadowImage.x = shadowImage.width / 2;
			shadowImage.y = -shadowImage.height / 2;
			shadowImage.smoothing = true;
			shadowContainer.addChild(shadowImage);
			
			//body
			var bodyImage:Bitmap = new plane02Image() as Bitmap;
			bodyImage.rotation = 90;
			bodyImage.x = bodyImage.width / 2;
			bodyImage.y = -bodyImage.height / 2;
			bodyImage.smoothing = true;
			body.addChild(bodyImage);
			
			missileShootingOffsetX = 5;
			missileShootingOffsetY = 15;
			
			prepareTrace();
			
			addChild(shadowContainer);
			addChild(body);
			addChild(energyBar);
			addChild(flightBar);
			
			updateEnergyBar();
			updateFlightBar();
		}
		
		override protected function drawWeaponLevel2():void
		{
			// in case this object is returned for reuse
			removeAllChildren();
			
			body.removeAllChildren();
			
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			shadowContainer.removeAllChildren();
			var shadowImage:Bitmap = new plane03ShadowImage() as Bitmap;
			shadowImage.rotation = 90;
			shadowImage.x = shadowImage.width / 2;
			shadowImage.y = -shadowImage.height / 2;
			shadowImage.smoothing = true;
			shadowContainer.addChild(shadowImage);
			
			//body
			var bodyImage:Bitmap = new plane03Image() as Bitmap;
			bodyImage.rotation = 90;
			bodyImage.x = bodyImage.width / 2;
			bodyImage.y = -bodyImage.height / 2;
			bodyImage.smoothing = true;
			body.addChild(bodyImage);
			
			missileShootingOffsetX = 5;
			missileShootingOffsetY = 15;
			
			prepareTrace();
			
			addChild(shadowContainer);
			addChild(body);
			addChild(energyBar);
			addChild(flightBar);
			
			updateEnergyBar();
			updateFlightBar();
		}
	
	}

}