/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.explosions
{
	import flash.events.Event;
	import nslib.controls.NSSprite;
	import nslib.effects.traceEffects.TracableObject;
	import nslib.effects.traceEffects.TraceController;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Explosion
	{
		public var explosionRingColor:int = 0xFF0000;
		
		public var ballCenterColor:int = 0xDAF516;
		
		public var ballRimColor:int = 0xD20000;
		
		public var fragmentCenterColor:int = 0xD7581C;
		
		public var fragmentRimColor:int = 0x6C503E;
		
		public var burnPitCenterColor:int = 0;
		
		public var burnPitRimColor:int = 0xAAAAAA;
		
		public var FragmentClass:Class = ExplosionFragment;
		
		protected var currentFragments:Array = [];
		
		private var container:NSSprite;
		
		private var traceController:TraceController;
		
		private var particles:Array = [];
		
		private var duration:int = 10; // number of frames;
		
		private var duractionCount:int = 0;
		
		private var fadingOut:Boolean = false;
		
		////////////////////////////////////////////////////////////////////////
		
		public function Explosion(container:NSSprite, traceController:TraceController)
		{
			this.container = container;
			this.traceController = traceController;
		}
		
		////////////////////////////////////////////////////////////////////////
		
		public function explode(x:int, y:int, strength:int = 5, fragmentsCoverRadius:Number = 200, showFireBalls:Boolean = true, showRing:Boolean = false, showFlyingFragments:Boolean = true):void
		{
			currentFragments = [];
			
			//adding flying fragments
			if (showFlyingFragments)
				for (var i:int = 0; i < strength * 3; i++)
				{
					var params:Object = new Object();
					params.radius = NSMath.min(strength * NSMath.random(), 3);
					params.x = x;
					params.y = y;
					
					if (fragment is ExplosionFragment)
					{
						ExplosionFragment(fragment).centerColor = fragmentCenterColor;
						ExplosionFragment(fragment).rimColor = fragmentRimColor;
					}
					
					var fragment:TracableObject = traceController.launchTracableObject(FragmentClass, params, x + fragmentsCoverRadius / 2 - fragmentsCoverRadius * NSMath.random(), y + fragmentsCoverRadius / 2 - fragmentsCoverRadius * NSMath.random(), 3 + 5 * NSMath.random(), BurnPit, {"radius": params.radius});
					currentFragments.push(fragment);
				}
			
			if (showRing)
			{
				var ringParams:Object = new Object();
				ringParams.ringColor = explosionRingColor;
				ringParams.x = x - 17;
				ringParams.y = y - 17;
				traceController.animateTracableObjectProperty(ExplosionRing, ringParams, "radius", 0, 100 + strength * 20, 400);
			}
			
			if (showFireBalls)
				for (var j:int = 0; j < strength; j++)
				{
					var fb:FireBall = new FireBall();
					fb.centerColor = ballCenterColor;
					fb.rimColor = ballRimColor;
					fb.growingSpeed = 1;
					fb.x = x + 10 - 20 * NSMath.random();
					fb.y = y + 10 - 20 * NSMath.random();
					
					container.addChild(fb);
					particles.push(fb);
				}
			
			container.addEventListener(Event.ENTER_FRAME, frameHandler);
			
			duractionCount = 0;
			fadingOut = false;
			
			var bpParams:Object = new Object();
			bpParams.radius = strength * 2;
			bpParams.x = x;
			bpParams.y = y;
			bpParams.centerColor = burnPitCenterColor;
			bpParams.rimColor = burnPitRimColor;
			
			traceController.putPermanentImage(BurnPit, bpParams);
		}
		
		private function frameHandler(event:Event):void
		{
			if (duractionCount > duration)
				fadingOut = true;
			
			update();
			
			if (duractionCount > duration * 2)
				clear();
			
			duractionCount++;
		}
		
		private function update():void
		{
			for each (var fb:FireBall in particles)
			{
				if (fadingOut)
				{
					fb.alpha *= fb.fadingMultiplier;
				}
				else
				{
					fb.radius += fb.growingSpeed;
					fb.update();
				}
			}
		}
		
		private function clear():void
		{
			container.removeEventListener(Event.ENTER_FRAME, frameHandler);
			
			for each (var fb:FireBall in particles)
				if (container.contains(fb))
					container.removeChild(fb);
		}
	
	}

}