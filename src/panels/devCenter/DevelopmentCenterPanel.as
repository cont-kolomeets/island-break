/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.devCenter
{
	import constants.GamePlayConstants;
	import controllers.AchievementsController;
	import flash.display.Bitmap;
	import flash.events.Event;
	import infoObjects.gameInfo.DevelopmentInfo;
	import infoObjects.gameInfo.GameInfo;
	import nslib.controls.events.ButtonEvent;
	import panels.common.JungleFrameContainer;
	import panels.devCenter.events.UpgradeEvent;
	import panels.PanelBase;
	import tracker.GameTracker;
	import tracker.TrackingMessages;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class DevelopmentCenterPanel extends PanelBase
	{
		public static const DONE_CLICKED:String = "doneClicked";
		
		public static const CANCEL_CLICKED:String = "cancelClicked";
		
		//public static const UNDO_CLICKED:String = "undoClicked";
		
		//////////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/dev center/flask.png")]
		private static var flaskImage:Class;
		
		//////////////////////
		
		private var frame:JungleFrameContainer = new JungleFrameContainer("Development Center");
		
		private var columnContainer:ColumnContainer = new ColumnContainer();
		
		private var toolBar:DevCenterToolBar = new DevCenterToolBar();
		
		/////////
		
		// in case a user cancels the operation
		private var gameInfoMemo:GameInfo = null;
		
		private var currentGameInfo:GameInfo = null;
		
		//////////////////////
		
		public function DevelopmentCenterPanel()
		{
			constructPanel()
		}
		
		//////////////////////
		
		private function constructPanel():void
		{
			addChild(frame);
			
			var flask:Bitmap = new flaskImage() as Bitmap;
			
			flask.x = (frame.width - flask.width) / 2;
			flask.y = (frame.height - flask.height) / 2;
			addChild(flask);
			
			columnContainer.x = (frame.width - columnContainer.width) / 2;
			columnContainer.y = 80;
			addChild(columnContainer);
			
			toolBar.x = GamePlayConstants.STAGE_WIDTH - toolBar.width - 50;
			toolBar.y = GamePlayConstants.STAGE_HEIGHT - toolBar.height - 20;
			addChild(toolBar);
		}
		
		///////////////////
		
		override public function show():void
		{
			super.show();
			
			toolBar.buttonCancel.addEventListener(ButtonEvent.BUTTON_CLICK, buttonCancel_clickHandler);
			toolBar.buttonUndo.addEventListener(ButtonEvent.BUTTON_CLICK, buttonUndo_clickHandler);
			toolBar.buttonDone.addEventListener(ButtonEvent.BUTTON_CLICK, buttonDone_clickHandler);
			
			// listening to this event from any child
			columnContainer.addEventListener(UpgradeEvent.UPGRADED, columnContainer_upgradedHandler, true);
			
			GameTracker.api.customMsg(TrackingMessages.VISITED_DEV_CENTER);
		}
		
		override public function hide():void
		{
			super.hide();
			
			toolBar.buttonCancel.removeEventListener(ButtonEvent.BUTTON_CLICK, buttonCancel_clickHandler);
			toolBar.buttonUndo.removeEventListener(ButtonEvent.BUTTON_CLICK, buttonUndo_clickHandler);
			toolBar.buttonDone.removeEventListener(ButtonEvent.BUTTON_CLICK, buttonDone_clickHandler);
			
			columnContainer.removeEventListener(UpgradeEvent.UPGRADED, columnContainer_upgradedHandler, true);
		}
		
		//////////////////
		
		//////////////////
		
		private function buttonCancel_clickHandler(event:ButtonEvent):void
		{
			// cancel all changes
			currentGameInfo.starsSpent = gameInfoMemo.starsSpent;
			currentGameInfo.copyDevelopmentHistoryFromGameInfo(gameInfoMemo);
			
			dispatchEvent(new Event(CANCEL_CLICKED));
		}
		
		private function buttonUndo_clickHandler(event:ButtonEvent):void
		{
			// remove the lates state
			var lastDevState:DevelopmentInfo = currentGameInfo.undoLastStoredDevelopmentInfo();
			currentGameInfo.starsSpent -= lastDevState.priceForLastUpdate;
			
			// apply the prev state
			applyState();
		}
		
		private function buttonDone_clickHandler(event:ButtonEvent):void
		{
			// if some development was made
			if(currentGameInfo.undoForDevStatusAllowed())
				currentGameInfo.helpInfo.userMadeFirstDevelopmet = true;
			
			dispatchEvent(new Event(DONE_CLICKED));
			
			AchievementsController.notifyUserWeaponUpgradedInDevCenter();
		}
		
		//////////
		
		override public function applyPanelInfo(panelInfo:*):void
		{
			super.applyPanelInfo(panelInfo);
			
			currentGameInfo = GameInfo(panelInfo);
			// make a copy
			gameInfoMemo = GameInfo.fromObject(GameInfo.toObject(currentGameInfo));
			
			applyState();
		}
		
		private function applyState():void
		{
			columnContainer.applyState(currentGameInfo);
			toolBar.starsAvailable = currentGameInfo.starsAvailable;
			updateUndoButton();
		}
		
		private function updateUndoButton():void
		{
			toolBar.buttonUndo.enabled = currentGameInfo.undoForDevStatusAllowed();
		}
		
		//////////////
		
		private function columnContainer_upgradedHandler(event:UpgradeEvent):void
		{
			currentGameInfo.starsSpent += event.starsSpent;
			var newDevState:DevelopmentInfo = currentGameInfo.developmentInfoCopy;
			newDevState.setLevelUpForWeapon(event.weaponId);
			// remember this price so we can return it if undoing
			newDevState.priceForLastUpdate = event.starsSpent;
			currentGameInfo.applyNewDevelopmentInfo(newDevState);
			
			applyState();
		}
	
	}

}