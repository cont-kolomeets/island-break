/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.news
{
	import controllers.SoundController;
	import flash.events.Event;
	import infoObjects.WeaponInfo;
	import nslib.animation.engines.AnimationEngine;
	import nslib.core.Globals;
	import panels.PanelBase;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.TipResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class InfoPopUpPanel extends PanelBase
	{
		public static const PANEL_CLOSED:String = "panelClosed";
		
		///////////////////////
		
		private var newsContainer:NewsContainer = new NewsContainer();
		
		private var newEnemyInfoContent:NewEnemyInfoContent = new NewEnemyInfoContent();
		
		//private var specialInfoField:CustomTextField = new CustomTextField();
		
		//////////
		
		private var ae:AnimationEngine = null;// new AnimationEngine();
		
		//private var deltaTime:DeltaTime = null;
		
		///////////////////////
		
		public function InfoPopUpPanel()
		{
			configurePanel();
		}
		
		///////////////////////
		
		private function configurePanel():void
		{
			blockScreenFillAlpha = 0.7;
			enableBlockScreen = true;
			
			ae = AnimationEngine.generateIndependentInstance(this);
			
			newEnemyInfoContent.animationEngine = ae;
			newsContainer.animationEngine = ae;
			
			addChild(newsContainer);
		}
		
		/////// showing infos for enemies and tips
		
		public function showInfoForEnemyWeapon(info:WeaponInfo):void
		{
			addToStage();
			
			newEnemyInfoContent.constructForInfo(info, 350, 1000);
			newsContainer.openForNewEnemy(newEnemyInfoContent, info.specialNotificationWhenFirstAppearing);
		}
		
		public function showInfoForTip(tipIndex:int):void
		{
			addToStage();
			
			newsContainer.openForTip(TipResources.getTipInfoAt(tipIndex));
		}
		
		/////// Add/remove from stage
		
		private function addToStage():void
		{
			SoundController.instance.playSound(SoundResources.SOUND_WINDOW_SLIDE);
			SoundController.instance.playSound(SoundResources.SOUND_PAPER_TIP_OPEN, 1, 100);
			
			show();
			showBlockScreen();
			Globals.topLevelApplication.addChild(this);
			newsContainer.addEventListener(NewsContainer.VIEWING_COMPLETED, newsContainer_viewingCompletedHandler);
		}
		
		private function newsContainer_viewingCompletedHandler(event:Event):void
		{
			removeFromStage();
		}
		
		private function removeFromStage():void
		{
			hide();
			hideBlockScreen();
			Globals.topLevelApplication.removeChild(this);
			newsContainer.notifyClosed();
			newsContainer.removeEventListener(NewsContainer.VIEWING_COMPLETED, newsContainer_viewingCompletedHandler);
			dispatchEvent(new Event(PANEL_CLOSED));
			
			SoundController.instance.playSound(SoundResources.SOUND_WINDOW_SLIDE);
		}
		
		override protected function showBlockScreen():void
		{
			if (enableBlockScreen)
				addChildAt(blockScreen, 0);
		}
		
		override protected function hideBlockScreen():void
		{
			if (contains(blockScreen))
				removeChild(blockScreen);
		}
	
	}

}

//specialInfoField.alpha = 0;

/*if (info.specialNotificationWhenFirstAppearing)
   {
   // adding special info
   specialInfoField.text = null;
   specialInfoField.y = 400;
   specialInfoField.textWidth = 300;
   specialInfoField.appendMultiLinedText(info.specialNotificationWhenFirstAppearing, new FontDescriptor(25, 0xFEFFFB, FontResources.BOMBARD));
   addChild(specialInfoField);

   // centering field
   specialInfoField.x = (GamePlayConstants.STAGE_WIDTH.width - specialInfoField.width) / 2;

   ae.animateProperty([specialInfoField], "alpha", 0, 1, NaN, 200, ae.currentTime + 1000);
 }*/