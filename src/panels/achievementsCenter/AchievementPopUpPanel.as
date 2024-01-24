/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.achievementsCenter
{
	import constants.GamePlayConstants;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import infoObjects.gameInfo.AchievementInfo;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AchievementPopUpPanel extends NSSprite
	{
		// dispatched when a notification is about to be shown
		// (sometimes it happen after releasing popups)
		public static const NOTIFICATION_STARTED:String = "notificationStarted";
		
		// dispatched when all notifications have been displayed
		public static const NOTIFICATION_COMPLETED:String = "notificationCompleted";
		
		private static const GAME_SAVED_OBJECT:Object = new Object();
		
		////////
		
		private var panel:MultiPerposedNotificationContainer = new MultiPerposedNotificationContainer();
		
		private var stack:Array = [];
		
		private var delayTimer:Timer = new Timer(1000, 1);
		
		// flags
		
		private var isBusy:Boolean = false;
		
		private var isHoldingPopups:Boolean = false;
		
		/////////////////
		
		public function AchievementPopUpPanel()
		{
		}
		
		//////////////////
		
		// adds to stack
		public function showPanelForInfo(info:AchievementInfo):void
		{
			queueTask(info);
		}
		
		// adds to stack
		public function showGameSavedNotification():void
		{
			queueTask(GAME_SAVED_OBJECT);
		}
		
		private function queueTask(object:Object):void
		{
			stack.push(object);
			
			// check stack after delay
			if (!delayTimer.running)
			{
				delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayTimer_timerCompleteHandler);
				delayTimer.reset();
				delayTimer.start();
			}
		}
		
		private function delayTimer_timerCompleteHandler(event:TimerEvent):void
		{
			delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, delayTimer_timerCompleteHandler);
			
			checkStack();
		}
		
		private function checkStack():void
		{
			if (isBusy || isHoldingPopups)
				return;
			
			if (stack.length == 0)
			{
				dispatchEvent(new Event(NOTIFICATION_COMPLETED));
				return;
			}
			
			isBusy = true;
			
			removeAllChildren();
			
			var taskObject:Object = stack.shift();
			
			if (taskObject is AchievementInfo)
				panel.showNewAchievemntNotification(taskObject as AchievementInfo);
			else if (taskObject == GAME_SAVED_OBJECT)
				panel.showGameSavedNotification();
			
			panel.scaleX = 0.8;
			panel.scaleY = 0.8;
			panel.x = (GamePlayConstants.STAGE_WIDTH - panel.width) / 2;
			addChild(panel);
			
			panel.alpha = 1;
			panel.y = -panel.height;
			
			AnimationEngine.globalAnimator.executeFunction(dispatchNotificationStartedEvent, null, AnimationEngine.globalAnimator.currentTime + 1000);
			AnimationEngine.globalAnimator.moveObjects(panel, panel.x, -panel.height, panel.x, 10, 300, AnimationEngine.globalAnimator.currentTime + 1000);
			AnimationEngine.globalAnimator.animateProperty(panel, "alpha", 1, 0, NaN, 500, AnimationEngine.globalAnimator.currentTime + 4000);
			AnimationEngine.globalAnimator.executeFunction(animationFinished, null, AnimationEngine.globalAnimator.currentTime + 5000);
		}
		
		private function dispatchNotificationStartedEvent():void
		{
			dispatchEvent(new Event(NOTIFICATION_STARTED));
		}
		
		private function animationFinished():void
		{
			isBusy = false;
			checkStack();
		}
		
		// Notifies to wait until the notifyReleasePopUps method is called.
		public function notifyHoldPopUps():void
		{
			isHoldingPopups = true;
		}
		
		public function notifyReleasePopUps():void
		{
			isHoldingPopups = false;
			checkStack();
		}
	}

}