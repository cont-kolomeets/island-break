/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.achievementsCenter
{
	import flash.display.DisplayObject;
	import infoObjects.gameInfo.AchievementInfo;
	import infoObjects.gameInfo.GameInfo;
	import nslib.controls.NSSprite;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class AchievementsCenterPager extends NSSprite
	{
		/////////////////
		
		private var verticalGap:int = 30;
		
		private var horisontalGap:int = 30;
		
		private var columnsPerPage:int = 2;
		
		private var itemsPerColumn:int = 4;
		
		private var pages:Array = [];
		
		private var currentPageIndex:int = 0;
		
		/////////////////
		
		public function AchievementsCenterPager()
		{
		
		}
		
		/////////////////
		
		/// building
		
		public function displayAchievements(gameInfo:GameInfo):void
		{
			splitItemsToPages(gameInfo);
			showPageAt(currentPageIndex);
		}
		
		private function splitItemsToPages(gameInfo:GameInfo):void
		{
			pages.length = 0;
			// holds containers for one page
			var page:Array = null;
			var toNextPage:Boolean = true;
			var rowCount:int = 0;
			var columnCount:int = 0;
			
			for each (var info:AchievementInfo in gameInfo.achievementInfos)
			{
				var container:MultiPerposedNotificationContainer = new MultiPerposedNotificationContainer();
				container.buildFromAchievementInfo(info, gameInfo);
				
				if (toNextPage)
				{
					// reseting parameters
					toNextPage = false;
					rowCount = 0;
					columnCount = 0;
					page = [];
				}
				
				page.push(container);
				
				if (++rowCount == itemsPerColumn)
				{
					rowCount = 0;
					if (++columnCount == columnsPerPage)
					{
						toNextPage = true;
						pages.push(page);
					}
				}
			}
			
			// adding the last page anyway
			pages.push(page);
		}
		
		private function showItemsForPage(index:int):void
		{
			var page:Array = pages[index] as Array;
			var rowCount:int = 0;
			var columnCount:int = 0;
			
			removeAllChildren();
			
			for each(var item:DisplayObject in page)
			{
				item.x = columnCount * 300;
				item.y = rowCount * 85;
				
				addChild(item);
			
				if (++rowCount == itemsPerColumn)
				{
					rowCount = 0;
					columnCount++;
				}
			}
		}
		
		/// navigation
		
		public function toNextPage():void
		{
			showPageAt(++currentPageIndex);
		}
		
		public function toPreviousPage():void
		{
			showPageAt(--currentPageIndex);
		}
		
		public function showPageAt(index:int):void
		{
			currentPageIndex = Math.min(Math.max(0, index), (pages.length - 1));
			showItemsForPage(currentPageIndex);
		}
	
	}

}