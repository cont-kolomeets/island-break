/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package weapons.enemy
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import supportClasses.resources.WeaponResources;
	import weapons.base.PlaneBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EnemyPlane extends PlaneBase
	{
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/plane 01.png")]
		private static var plane01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/speed plane 01.png")]
		private static var speedPlane01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/tiny plane 01.png")]
		private static var tinyPlane01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/helicopter 01.png")]
		private static var helicopter01Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/heavy helicopter 01.png")]
		private static var helicopter02Image:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/helicopter rotator.png")]
		private static var helicopterRotatorImage:Class;
		
		/////////// shadows
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/plane 01 shadow.png")]
		private static var plane01ShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/speed plane 01 shadow.png")]
		private static var speedPlane01ShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/tiny plane 01 shadow.png")]
		private static var tinyPlane01ShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/helicopter 01 shadow.png")]
		private static var helicopter01ShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/heavy helicopter 01 shadow.png")]
		private static var helicopter02ShadowImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/enemy weapon/aircrafts/helicopter rotator shadow.png")]
		private static var helicopterRotatorShadowImage:Class;
		
		///////////////
		
		public function EnemyPlane(level:int = 0)
		{
			super(WeaponResources.ENEMY_PLANE, level);
		}
		
		///////////////
		
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
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
			
			traceOffsetX = 0;
			traceOffsetY = 8;
			
			prepareTrace();
			
			addChild(shadowContainer);
			addChild(body);
			addChild(energyBar);
			addChild(flightBar);
			
			updateEnergyBar();
			updateFlightBar();
		}
		
		///////////////
		
		override protected function drawWeaponLevel1():void
		{
			// in case this object is returned for reuse
			removeAllChildren();
			
			body.removeAllChildren();
			
			//implementing boundaries rectangle
			rect = new Rectangle(-15, -15, 30, 30);
			
			shadowContainer.removeAllChildren();
			var shadowImage:Bitmap = new speedPlane01ShadowImage() as Bitmap;
			shadowImage.rotation = 90;
			shadowImage.x = shadowImage.width / 2;
			shadowImage.y = -shadowImage.height / 2;
			shadowImage.smoothing = true;
			shadowContainer.addChild(shadowImage);
			
			//body
			var bodyImage:Bitmap = new speedPlane01Image() as Bitmap;
			bodyImage.rotation = 90;
			bodyImage.x = bodyImage.width / 2;
			bodyImage.y = -bodyImage.height / 2;
			bodyImage.smoothing = true;
			body.addChild(bodyImage);
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
			
			missileShootingOffsetX = 5;
			missileShootingOffsetY = 10;
			
			traceOffsetX = 0;
			traceOffsetY = 8;
			
			prepareTrace();
			
			addChild(shadowContainer);
			addChild(body);
			addChild(energyBar);
			addChild(flightBar);
			
			updateEnergyBar();
			updateFlightBar();
		}
		
		///////////////
		
		override protected function drawWeaponLevel2():void
		{
			// in case this object is returned for reuse
			removeAllChildren();
			
			body.removeAllChildren();
			
			//implementing boundaries rectangle
			rect = new Rectangle(-10, -10, 20, 20);
			
			shadowContainer.removeAllChildren();
			var shadowImage:Bitmap = new tinyPlane01ShadowImage() as Bitmap;
			shadowImage.rotation = 90;
			shadowImage.x = shadowImage.width / 2;
			shadowImage.y = -shadowImage.height / 2;
			shadowImage.smoothing = true;
			shadowContainer.addChild(shadowImage);
			
			//body
			var bodyImage:Bitmap = new tinyPlane01Image() as Bitmap;
			bodyImage.rotation = 90;
			bodyImage.x = bodyImage.width / 2;
			bodyImage.y = -bodyImage.height / 2;
			bodyImage.smoothing = true;
			body.addChild(bodyImage);
			
			shootingOffsetX = 0;
			shootingOffsetY = 0;
			
			traceOffsetX = -5;
			traceOffsetY = 1;
			
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