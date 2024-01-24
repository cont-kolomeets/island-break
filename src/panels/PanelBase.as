/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels
{
	import constants.GamePlayConstants;
	import events.PanelEvent;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PanelBase extends NSSprite
	{
		public var panelID:String = null;
		
		// info object passed to a panel
		protected var panelInfo:* = null;
		
		// allows a panel to have its own block screen
		protected var blockScreen:NSSprite = new NSSprite();
		
		protected var blockScreenFillAlpha:Number = 0.2;
		
		///////////////////
		
		public function PanelBase()
		{
			super();
		}
		
		//////////////////
		
		private var _enableBlockScreen:Boolean = false;
		
		public function get enableBlockScreen():Boolean
		{
			return _enableBlockScreen;
		}
		/*
		 * Indicates whether a block screen should be added to the background.
		 **/
		public function set enableBlockScreen(value:Boolean):void
		{
			_enableBlockScreen = value;
			
			if (value)
				drawBlockScreen();
			else if (contains(blockScreen))
				removeChild(blockScreen);
		}
		
		////////////
		
		// this value becomes true when the show() method is called, and false when
		// the hide() method is called.
		private var _isShown:Boolean = false;
		
		public function get isShown():Boolean
		{
			return _isShown;
		}
		
		//////////////////
		
		/*
		 * This method must be called every time a panel is displayed on the screen.
		 **/
		public function show():void
		{
			_isShown = true;
			dispatchEvent(new PanelEvent(PanelEvent.SHOW));
			dispatchEvent(new PanelEvent(PanelEvent.REQUEST_INFOS));
		}
		
		/*
		 * This method must be called every time a panel is removed from the screen.
		 **/
		public function hide():void
		{
			_isShown = false;
			dispatchEvent(new PanelEvent(PanelEvent.READY_TO_BE_REMOVED));
		}
		
		// Call this method to apply a specific panel info to update a panels content.
		public function applyPanelInfo(panelInfo:*):void
		{
			this.panelInfo = panelInfo;
		}
		
		// override this method to customize the blockscreen.
		protected function drawBlockScreen():void
		{
			// to prefent tooltips from hidden components
			blockScreen.mouseEnabled = true;
			blockScreen.graphics.clear();
			blockScreen.graphics.beginFill(0x000000, blockScreenFillAlpha);
			blockScreen.graphics.drawRect(0, 0, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			addChildAt(blockScreen, 0);
		}
		
		protected function showBlockScreen():void
		{
			if (enableBlockScreen)
				addChildAt(blockScreen, 0);
				
			blockScreen.visible = true;
			AnimationEngine.globalAnimator.animateProperty(blockScreen, "alpha", 0, 1, NaN, 300, NaN);
		}
		
		protected function hideBlockScreen():void
		{
			if (contains(blockScreen))
				removeChild(blockScreen);
				
			blockScreen.visible = false;
		}
		
		/////////////////////
		
		private var navigationListenersHash:Object = { };
		
		public function addNavigationListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			var info:NavigationListenerInfo = new NavigationListenerInfo();
			info.type = type;
			info.listener = listener;
			info.useCapture = useCapture;
			
			navigationListenersHash[type + String(useCapture ? 1 : 0)] = info;
		}
		
		public function removeAllNavigationListeners():void
		{
			for (var id:String in navigationListenersHash)
			{
				var info:NavigationListenerInfo = navigationListenersHash[id];
				removeEventListener(info.type, info.listener, info.useCapture);
			}
		}
	}

}

class NavigationListenerInfo
{
	public var type:String = null;
	
	public var listener:Function = null;
	
	public var useCapture:Boolean = false;
}