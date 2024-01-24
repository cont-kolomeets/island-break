/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import nslib.utils.UIDUtil;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class NSSprite extends Sprite
	{
		public var uniqueKey:String = UIDUtil.generateUniqueID();
		
		public var id:String;
		
		private var propertiesAreValidFlag:Boolean = true;
		
		///////////////////////
		
		public function NSSprite()
		{
			super();
			
			// to increase performance this value is set to false.
			mouseEnabled = false;
			tabEnabled = false;
			tabChildren = false;
			
			invalidateProperties();
		}
		
		/////////////////////
		
		// returns true if properties have not been invalidated.
		public function get propertiesAreValid():Boolean
		{
			return propertiesAreValidFlag;
		}
		
		/////////////////////
		
		public function removeAllChildren():void
		{
			while (numChildren > 0)
				removeChildAt(0);
		}
		
		////////////////////
		
		public function invalidateProperties():void
		{
			if (!propertiesAreValidFlag)
				return;
			
			propertiesAreValidFlag = false;
			
			requestDelayedCommit();
		}
		
		protected function requestDelayedCommit():void
		{
			if (!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME, frameListener);
		}
		
		private function frameListener(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, frameListener);
			
			performDelayedCommit();
		}
		
		protected function performDelayedCommit():void
		{
			if (!propertiesAreValidFlag)
				commitProperties();
		}
		
		protected function commitProperties():void
		{
			propertiesAreValidFlag = true;
		}
		
		////////////
		
		/*override public function addChild(child:DisplayObject):flash.display.DisplayObject 
		{
			var child:DisplayObject = super.addChild(child);
			
			if (child is NSSprite)
				NSSprite(child).addedToStage();
			
			return child;
		}
		
		protected function addedToStage():void
		{
			var len:int = numChildren;
			
			for (var i:int = 0; i < len; i++)
			{
				var child:DisplayObject = getChildAt(i);
				
				if (child is NSSprite)
					NSSprite(child).addedToStage();
			}
		}
		
		protected function removedFromStage():void
		{
			var len:int = numChildren;
			
			for (var i:int = 0; i < len; i++)
			{
				var child:DisplayObject = getChildAt(i);
				
				if (child is NSSprite)
					NSSprite(child).removedFromStage();
			}
		}*/
	}

}