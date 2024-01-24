package islandBreak.controllers
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import islandBreak.constants.GamePlayConstants;
	import islandBreak.constants.MapConstants;
	import nslib.controls.NSSprite;
	import nslib.utils.OptimizedArray;
	import weapons.base.IWeapon;
	import weapons.base.Weapon;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ItemDynamicPlacer extends NSSprite
	{
		public var registeredItems:OptimizedArray = new OptimizedArray();
		
		public var addFunction:Function = null;
		
		public var removeFunction:Function = null;
		
		private var screenRect:Rectangle = new Rectangle(0, 0, GamePlayConstants.STAGE_WIDTH + MapConstants.EXPANSION, GamePlayConstants.STAGE_HEIGHT + MapConstants.EXPANSION);
		
		/////////////
		
		public function ItemDynamicPlacer()
		{
		}
		
		//////////////
		
		public function reset():void
		{
			removeAllChildren();
			registeredItems.removeAll();
		}
		
		public function registerItem(item:*):void
		{
			registeredItems.addItem(item);
		}
		
		public function unregisterItem(item:*, forceRemove:Boolean = true):void
		{
			registeredItems.removeItem(item);
			
			if (forceRemove && contains(item as DisplayObject))
				removeChild(item);
		}
		
		private function itemShouldBeShown(item:*):Boolean
		{
			screenRect.x = -this.x - MapConstants.EXPANSION / 2;
			screenRect.y = -this.y - MapConstants.EXPANSION / 2;
			
			return screenRect.contains(item.x, item.y);
		}
		
		public function updateItems():void
		{
			var len:int = registeredItems.length;
			
			for (var i:int = 0; i < len; i++)
			{
				var item:* = registeredItems.getItemAt(i);
				
				if (item)
				{
					if (itemShouldBeShown(item))
					{
						if (!contains(item as DisplayObject))
						{
							addChild(item as DisplayObject);
							
							if (addFunction != null)
								addFunction(item);
						}
					}
					else
					{
						if (contains(item as DisplayObject))
						{
							if (removeFunction != null)
								removeFunction(item);
							
							removeChild(item as DisplayObject);
						}
					}
				}
			}
		}
	
	}

}