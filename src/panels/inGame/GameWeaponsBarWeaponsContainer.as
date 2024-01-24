/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import constants.GamePlayConstants;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.EventDispatcher;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import infoObjects.WeaponStoreInfo;
	import mainPack.GameSettings;
	import mainPack.ModeSettings;
	import nslib.animation.engines.AnimationEngine;
	import nslib.animation.events.AnimationEvent;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.interactableObjects.MovableObject;
	import nslib.utils.ArrayList;
	import nslib.utils.FontDescriptor;
	import nslib.utils.NameUtil;
	import supportClasses.ISettingsObserver;
	import supportClasses.resources.FontResources;
	import supportControls.toolTips.InGameHintToolTip;
	import supportControls.toolTips.WeaponInfoToolTip;
	import supportControls.toolTips.WeaponInfoToolTipContentDescriptor;
	import weapons.base.IGroundWeapon;
	import weapons.base.IPurchasableItem;
	import weapons.objects.Obstacle;
	import weapons.repairCenter.RepairCenter;
	import weapons.user.UserElectricTower;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameWeaponsBarWeaponsContainer extends NSSprite implements ISettingsObserver
	{
		
		[Embed(source="F:/Island Defence/media/images/panels/game control menu/unknown weapon.png")]
		private static var unknownWeaponImage:Class;
		/////////////
		
		public var allowObstacles:Boolean = false;
		
		// container to display prices
		private var pricesContainer:NSSprite = new NSSprite();
		
		private var electricTowerEmptyImage:NSSprite = new NSSprite();
		
		private var repairCenterEmptyImage:NSSprite = new NSSprite();
		
		private var placedItems:ArrayList = new ArrayList();
		
		// for optimization purposes
		private var priceLabelsStorage:Array = [];
		
		private var highlightRects:Array = [];
		
		// item moving back to the menu	
		private var pendingItem:IGroundWeapon = null;
		
		// item a user is currently interracting with		
		private var draggedItem:IGroundWeapon = null;
		
		////////////
		
		public function GameWeaponsBarWeaponsContainer()
		{
			GameSettings.registerObserver(this);
			construct();
		}
		
		////////////
		
		private function construct():void
		{
			pricesContainer.y = 20;
			addChild(pricesContainer);
			
			electricTowerEmptyImage.addChild(new unknownWeaponImage() as Bitmap);
			electricTowerEmptyImage.mouseEnabled = true;
			repairCenterEmptyImage.addChild(new unknownWeaponImage() as Bitmap);
			repairCenterEmptyImage.mouseEnabled = true;
			
			updateToolTips();
			
			for (var i:int = 0; i < 5; i++)
			{
				var priceLabel:CustomTextField = new CustomTextField(null, new FontDescriptor(13, 0xFFFFFF, FontResources.JUNEGULL));
				priceLabel.textWidth = 45;
				priceLabel.alignCenter = false;
				priceLabelsStorage.push(priceLabel);
			}
		}
		
		private function createHighlightRects():void
		{
			createRectForItem("Obstacle");
			createRectForItem("UserCannon");
			createRectForItem("UserMachineGunTower");
			createRectForItem("UserElectricTower");
			createRectForItem("RepairCenter");
		}
		
		private function createRectForItem(className:String):void
		{
			var rectShape:Shape = new Shape();
			rectShape.graphics.lineStyle(4, 0xF2FF09, 0.7);
			rectShape.graphics.drawRect(-20, -20, 40, 40);
			
			var snapPoint:Point = this.globalToLocal(getProperLocationForItem(className));
			rectShape.x = snapPoint.x;
			rectShape.y = snapPoint.y;
			
			this.addChild(rectShape);
			
			highlightRects.push(rectShape);
		}
		
		private function updateToolTips():void
		{
			if (GameSettings.enableTooltips)
			{
				var descriptor:ToolTipSimpleContentDescriptor = new ToolTipSimpleContentDescriptor("Locked Tower!", ["Earn stars and unlock new towers in the 'Development Center'."]);
				ToolTipService.setToolTip(electricTowerEmptyImage, new ToolTipInfo(electricTowerEmptyImage, descriptor), InGameHintToolTip);
				ToolTipService.setToolTip(repairCenterEmptyImage, new ToolTipInfo(repairCenterEmptyImage, descriptor), InGameHintToolTip);
			}
			else
			{
				ToolTipService.removeAllTooltipsForComponent(electricTowerEmptyImage);
				ToolTipService.removeAllTooltipsForComponent(repairCenterEmptyImage);
			}
			
			for each (var item:NSSprite in placedItems.source)
			{
				if (GameSettings.enableTooltips)
				{
					var tti:ToolTipInfo = new ToolTipInfo(item, new WeaponInfoToolTipContentDescriptor(IGroundWeapon(item).currentInfo, false));
					ToolTipService.setToolTip(item, tti, WeaponInfoToolTip);
				}
				else
					ToolTipService.removeAllTooltipsForComponent(item);
			}
		}
		
		public function notifySettingsChanged(propertyName:String):void
		{
			if (propertyName == "enableTooltips")
				updateToolTips();
		}
		
		public function notifyLevelWasReset():void
		{
			placedItems.removeAll();
		}
		
		public function applyStoreInfos(storeInfos:Array, gameIsRunning:Boolean, currentLevelMode:String):void
		{
			pricesContainer.removeAllChildren();
			
			var priceLabel:CustomTextField = null;
			
			// flags for extra weapons
			var electricTowerAdded:Boolean = false;
			var repairCenterAdded:Boolean = false;
			
			for each (var alreadyPlacedItem:IGroundWeapon in placedItems.source)
				if (alreadyPlacedItem is UserElectricTower)
					electricTowerAdded = true;
				else if (alreadyPlacedItem is RepairCenter)
					repairCenterAdded = true;
			
			for (var i:int = 0; i < storeInfos.length; i++)
			{
				var info:WeaponStoreInfo = storeInfos[i];
				
				if (!allowObstacles && info.item is Obstacle)
					continue;
				
				// add price label
				priceLabel = createPriceLabel("" + info.price, i);
				
				priceLabel.x = getProperLocationForItem(info.item).x - this.x - pricesContainer.x - priceLabel.width / 2;
				priceLabel.y = 24;
				
				pricesContainer.addChild(priceLabel);
				
				// set affordability
				
				if (draggedItem != info.item && info.item is IPurchasableItem)
				{
					var affordablePrevValue:Boolean = IPurchasableItem(info.item).affordable;
					IPurchasableItem(info.item).affordable = info.affordable && !((info.item is Obstacle) && gameIsRunning);
					
					if (!(info.item is Obstacle) && !affordablePrevValue && affordablePrevValue != IPurchasableItem(info.item).affordable && placedItems.contains(info.item))
					{
						//var shape:Shape = Shape(highlightRects[i]);
						//this.addChildAt(shape, 0);
						DisplayObject(info.item).filters = [new GlowFilter(0xFD8F3E, 1, 10, 10, 3)];
						
						var hideFunction:Function = function(highlightedItem:DisplayObject):void
						{
							highlightedItem.filters = null;
							//if(parent.contains(shape))
							//	parent.removeChild(shape);
						}
						
						AnimationEngine.globalAnimator.executeFunction(hideFunction, [info.item], AnimationEngine.globalAnimator.currentTime + 1000);
					}
					
					if (!IPurchasableItem(info.item).affordable && (DisplayObject(info.item).filters != null || DisplayObject(info.item).filters.length == 0))
						DisplayObject(info.item).filters = null;
					
					if (!affordablePrevValue && affordablePrevValue != IPurchasableItem(info.item).affordable && info.item is Obstacle)
						setToolTipAfterDelay(info.item);
				}
				
				if (draggedItem == info.item || placedItems.contains(info.item))
				{
					if (draggedItem is UserElectricTower)
						electricTowerAdded = true;
					else if (draggedItem is RepairCenter)
						repairCenterAdded = true;
					
					continue;
				}
				
				placeItemToMenu(info.item);
				
				// checking flags
				if (info.item is UserElectricTower)
					electricTowerAdded = true;
				
				if (info.item is RepairCenter)
					repairCenterAdded = true;
			}
			
			// empty images should be shown only in the normal mode
			if (currentLevelMode == ModeSettings.MODE_NORMAL)
			{
				//adding an empty image for weapons that are not upgraded yet
				if (!electricTowerAdded)
					addEmptyImageForItem("UserElectricTower");
				
				if (!repairCenterAdded)
					addEmptyImageForItem("RepairCenter");
			}
		}
		
		private function addEmptyImageForItem(className:String):void
		{
			var locationForItem:Point = getProperLocationForItem(className);
			
			var emptyImage:NSSprite = null;
			var index:int = 0;
			
			if (className == "UserElectricTower")
			{
				index = 3;
				emptyImage = electricTowerEmptyImage;
			}
			else if (className == "RepairCenter")
			{
				index = 4;
				emptyImage = repairCenterEmptyImage;
			}
			
			emptyImage.x = locationForItem.x - this.x - pricesContainer.x - emptyImage.width / 2;
			emptyImage.y = -10;
			pricesContainer.addChild(emptyImage);
			
			var priceLabel:CustomTextField = createPriceLabel("-", index);
			priceLabel.x = locationForItem.x - this.x - pricesContainer.x - priceLabel.width / 2;
			priceLabel.y = 24;
			pricesContainer.addChild(priceLabel);
		}
		
		private function createPriceLabel(text:String, index:int):CustomTextField
		{
			var priceLabel:CustomTextField = priceLabelsStorage[index];
			priceLabel.text = text;
			
			return priceLabel;
		}
		
		private var interactionWithMenuIsAllowedFlag:Boolean = true;
		
		public function interactionWithMenuIsAllowed():Boolean
		{
			return interactionWithMenuIsAllowedFlag;
		}
		
		// places an item for sale to the correct position.
		public function placeItemToMenu(item:IGroundWeapon, useFlyingAnimation:Boolean = false, useBubbleAnimation:Boolean = false):void
		{
			var snapBackPoint:Point = getProperLocationForItem(item);
			pendingItem = item;
			
			if (item == draggedItem)
				draggedItem = null;
			
			interactionWithMenuIsAllowedFlag = false;
			
			if (useFlyingAnimation)
			{
				// temporarely remove mouse sensitivity
				if (item is MovableObject)
					MovableObject(item).removeMouseSensitivity();
				
				EventDispatcher(item).addEventListener(AnimationEvent.ANIMATION_ROUTINE_COMPLETED_FOR_THIS_OBJECT, item_animationCompletedHandler);
				AnimationEngine.globalAnimator.moveObjects(item, item.x, item.y, snapBackPoint.x, snapBackPoint.y, 200, AnimationEngine.globalAnimator.currentTime);
			}
			else
			{
				item.x = snapBackPoint.x;
				item.y = snapBackPoint.y;
				setToolTipAfterDelay(item);
			}
		}
		
		private function item_animationCompletedHandler(event:AnimationEvent):void
		{
			// restore mouse sensitivity
			if (event.currentTarget is MovableObject)
				MovableObject(event.currentTarget).addMouseSensitivity();
			
			event.currentTarget.removeEventListener(AnimationEvent.ANIMATION_ROUTINE_COMPLETED_FOR_THIS_OBJECT, item_animationCompletedHandler);
			
			setToolTipAfterDelay(event.currentTarget as IGroundWeapon);
		}
		
		private function setToolTipAfterDelay(item:IGroundWeapon):void
		{
			// if the pendingItem was reset just return
			if (item != pendingItem)
				return;
			
			interactionWithMenuIsAllowedFlag = true;
			
			pendingItem = null;
			
			placedItems.addItem(item);
			
			if (GameSettings.enableTooltips && !item.isPlaced)
			{
				if (item is Obstacle && !Obstacle(item).affordable)
				{
					var descriptor:ToolTipSimpleContentDescriptor = new ToolTipSimpleContentDescriptor("Not Available!", ["Barrikades can be constructed only before you start the battle!"]);
					ToolTipService.setToolTip(item as DisplayObject, new ToolTipInfo(item as DisplayObject, descriptor), InGameHintToolTip);
				}
				else
				{
					var tti:ToolTipInfo = new ToolTipInfo(item as DisplayObject, new WeaponInfoToolTipContentDescriptor(IGroundWeapon(item).currentInfo, false));
					ToolTipService.setToolTip(item as DisplayObject, tti, WeaponInfoToolTip);
				}
			}
		}
		
		public function notifyItemIsTaken(item:IGroundWeapon):void
		{
			if (item == pendingItem)
				pendingItem = null;
			
			draggedItem = item;
			
			ToolTipService.removeAllTooltipsForComponent(item as NSSprite);
			placedItems.removeItem(item);
		}
		
		// relatevely to the global (0, 0) point
		private function getProperLocationForItem(item:*):Point
		{
			var location:Point = new Point(0, 0);
			
			var className:String = NameUtil.getTruncatedClassName(item);
			
			if (className == "Obstacle")
			{
				location.x = 490;
				location.y = GamePlayConstants.STAGE_HEIGHT - 35;
			}
			
			if (className == "UserCannon")
			{
				location.x = 535;
				location.y = GamePlayConstants.STAGE_HEIGHT - 35;
			}
			
			if (className == "UserMachineGunTower")
			{
				location.x = 580;
				location.y = GamePlayConstants.STAGE_HEIGHT - 35;
			}
			
			if (className == "UserElectricTower")
			{
				location.x = 625;
				location.y = GamePlayConstants.STAGE_HEIGHT - 35;
			}
			
			if (className == "RepairCenter")
			{
				location.x = 670;
				location.y = GamePlayConstants.STAGE_HEIGHT - 35;
			}
			
			return location;
		}
	
	}

}