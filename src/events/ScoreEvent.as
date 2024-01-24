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
	public class ScoreEvent extends Event
	{
		public static var SCORES_CHANGED:String = "scoresChanged";
		
		public var newValue:int = 0;
		
		public var scoresAdded:Boolean = false;
		
		public function ScoreEvent(type:String, newValue:int, scoresAdded:Boolean)
		{
			super(type);
			
			this.newValue = newValue;
			this.scoresAdded = scoresAdded;
		}
	
	}

}