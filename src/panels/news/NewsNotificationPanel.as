/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.news
{
	import events.NewsEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import infoObjects.WeaponInfo;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.NSSprite;
	import panels.news.InfoPopUpPanel;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class NewsNotificationPanel extends NSSprite
	{
		public static const PAUSE_GAME_FOR_READING:String = "pauseGameForReading";
		
		public static const RESUME_GAME_AFTER_READING:String = "resumeGameAfterReading";
		
		////////////////////////////////////////
		
		private var toolBar:NewsNotificationToolBar = new NewsNotificationToolBar();
		
		private var infoPopUpPanel:InfoPopUpPanel = new InfoPopUpPanel();
		
		//////////
		
		private var newEnemiesStack:Array = [];
		
		private var tipsStack:Array = [];
		
		private var currentInfo:WeaponInfo = null;
		
		private var currentTipIndex:int = -1;
		
		private var delayTimer:Timer = new Timer(1000, 1);
		
		private var enemyButtonIsAlreadyShownFlag:Boolean = false;
		
		private var tipButtonIsAlreadyShownFlag:Boolean = false;
		
		private var needShowGuideToolTipForEnemyFlag:Boolean = false;
		
		private var needShowGuideToolTipForTipFlag:Boolean = false;
		
		////////////////////////////////////////
		
		public function NewsNotificationPanel()
		{
			configurePanel();
		}
		
		private function configurePanel():void
		{
			addChild(toolBar);
			
			toolBar.updateButtonsPositions();
		}
		
		// resets everything to initial state
		public function toInitialState():void
		{
			enemyButtonIsAlreadyShownFlag = false;
			tipButtonIsAlreadyShownFlag = false;
			needShowGuideToolTipForEnemyFlag = false;
			needShowGuideToolTipForTipFlag = false;
			newEnemiesStack.length = 0;
			tipsStack.length = 0;
			currentInfo = null;
			currentTipIndex = -1;
			toolBar.clearToolBar();
		}
		
		// shows an icon which a user can click and get more information about an enemy
		// stack them if more than one enemy is waiting to be read about.
		public function notifyAboutNewEnemy(enemyInfo:WeaponInfo):void
		{
			newEnemiesStack.push(enemyInfo);
			checkEnemiesStack();
		}
		
		// Index in the TipResources file.
		public function notifyNeedShowTip(tipIndex:int):void
		{
			tipsStack.push(tipIndex);
			checkTipsStack();
		}
		
		public function notifyShowGuideToolTipsForFirstLevel():void
		{
			needShowGuideToolTipForEnemyFlag = true;
			needShowGuideToolTipForTipFlag = true;
		}
		
		private function checkEnemiesStack():void
		{
			if (newEnemiesStack.length == 0 || enemyButtonIsAlreadyShownFlag)
				return;
			
			enemyButtonIsAlreadyShownFlag = true;
			
			currentInfo = newEnemiesStack.shift() as WeaponInfo;
			showButtonForEnemy();
		}
		
		private function checkTipsStack():void
		{
			if (tipsStack.length == 0 || tipButtonIsAlreadyShownFlag)
				return;
			
			tipButtonIsAlreadyShownFlag = true;
			
			var taskObject:* = tipsStack.shift();
			
			currentTipIndex = int(taskObject);
			showButtonForTip();
		}
		
		private function showButtonForEnemy():void
		{
			toolBar.showButtonForEnemy(needShowGuideToolTipForEnemyFlag);
			toolBar.newEnemyButton.addEventListener(ButtonEvent.BUTTON_CLICK, newEnemyButton_clickHandler);
			
			needShowGuideToolTipForEnemyFlag = false;
		}
		
		private function showButtonForTip():void
		{
			toolBar.showButtonForTip(needShowGuideToolTipForTipFlag);
			toolBar.tipButton.addEventListener(ButtonEvent.BUTTON_CLICK, tipButton_clickHandler);
			
			needShowGuideToolTipForTipFlag = false;
		}
		
		private function newEnemyButton_clickHandler(event:ButtonEvent):void
		{
			toolBar.newEnemyButton.removeEventListener(ButtonEvent.BUTTON_CLICK, newEnemyButton_clickHandler);
			toolBar.clearNewEnemyButton();
			
			enemyButtonIsAlreadyShownFlag = false;
			
			dispatchEvent(new NewsEvent(NewsEvent.NEW_ENEMY_OPENED, currentInfo));
			dispatchEvent(new Event(PAUSE_GAME_FOR_READING));
			
			infoPopUpPanel.addEventListener(InfoPopUpPanel.PANEL_CLOSED, infoPopUpPanel_panelClosedHandler);
			
			infoPopUpPanel.showInfoForEnemyWeapon(currentInfo);
		}
		
		private function tipButton_clickHandler(event:ButtonEvent):void
		{
			toolBar.tipButton.removeEventListener(ButtonEvent.BUTTON_CLICK, tipButton_clickHandler);
			toolBar.clearTipButton();
			
			tipButtonIsAlreadyShownFlag = false;
			
			showTipAtIndex(currentTipIndex);
		}
		
		// shows tip immediately
		public function showTipAtIndex(tipIndex:int):void
		{
			dispatchEvent(new Event(PAUSE_GAME_FOR_READING));
			
			infoPopUpPanel.addEventListener(InfoPopUpPanel.PANEL_CLOSED, infoPopUpPanel_panelClosedHandler);
			
			infoPopUpPanel.showInfoForTip(tipIndex);
		}
		
		private function infoPopUpPanel_panelClosedHandler(event:Event):void
		{
			infoPopUpPanel.removeEventListener(InfoPopUpPanel.PANEL_CLOSED, infoPopUpPanel_panelClosedHandler);
			
			dispatchEvent(new Event(RESUME_GAME_AFTER_READING));
			
			// check for pending items after delay		
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayTimer_timerCompleteHandler);
			delayTimer.start();
		}
		
		private function delayTimer_timerCompleteHandler(event:TimerEvent):void
		{
			delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, delayTimer_timerCompleteHandler);
			
			// try checking all stacks
			checkEnemiesStack();
			checkTipsStack();
		}
	
	}

}