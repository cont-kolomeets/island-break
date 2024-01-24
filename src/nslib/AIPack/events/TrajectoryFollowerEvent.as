/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TrajectoryFollowerEvent extends Event 
	{
		public static const REACHED_END_OF_PATH:String = "reachedEndOfPath";
		
		public function TrajectoryFollowerEvent(type:String) 
		{
			super(type);
		}
		
	}

}