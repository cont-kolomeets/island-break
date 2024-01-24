/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.gameFinished 
{
	import flash.events.Event;
	import nslib.controls.NSSprite;
	import nslib.core.Globals;
	import nslib.effects.fireWorks.BatchFireWork;
	import nslib.effects.fireWorks.FireWork;
	import nslib.effects.fireWorks.FireWorkParticle;
	import nslib.utils.FontDescriptor;
	import panels.common.MessageNotifier;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameFinishedScreen extends NSSprite 
	{
		private var messageNotifier:MessageNotifier = new MessageNotifier();
		
		private var batchFirework:BatchFireWork = new BatchFireWork();
		
		public function GameFinishedScreen() 
		{
			construct();
		}
		
		private function construct():void
		{
			messageNotifier.workingLayer = Globals.topLevelApplication;
		}
		
		public function congratulateUser():void
		{
			messageNotifier.stayDuration = 6000;
			messageNotifier.showScreenNotification("Congratulations!!!", new FontDescriptor(40, 0xFFFF00, FontResources.YARDSALE));
			
			var prototype:FireWork = new FireWork();
			prototype.particleType = FireWorkParticle.TYPE_STAR;
			prototype.particleRadius = 6;
			batchFirework.workingLayer = Globals.topLevelApplication;
			batchFirework.startFirework(prototype, 50, 0xFFFF00, 1000, 500);
			
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHanlder);
		}
		
		private function removedFromStageHanlder(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHanlder);
			batchFirework.stop();
		}
		
	}

}