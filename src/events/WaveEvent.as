/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WaveEvent extends Event
	{
		public static const DEPLOY_ENEMY:String = "deployEnemy";
		
		public static const WAVE_STARTED:String = "waveStarted";
				
		public static const WAVE_COMPLETED:String = "waveCompleted";
		
		public static const LEVEL_COMPLETED:String = "levelCompleted";
		
		public var pathIndex:int = 0;
		
		public function WaveEvent(type:String, pathIndex:int = 0)
		{
			super(type);
			
			this.pathIndex = pathIndex;
		}
	
	}

}