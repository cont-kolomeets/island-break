/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import nslib.controls.Button;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponSettingsPanelButton extends NSSprite
	{
		public static const TYPE_UPGRADE:String = "upgrade";
		
		public static const TYPE_REPAIR:String = "repair";
		
		public static const TYPE_SELL:String = "sell";
		
		//////////////////////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/upgrade normal.png")]
		private static var upgradeNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/upgrade over.png")]
		private static var upgradeOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/upgrade down.png")]
		private static var upgradeDownImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/upgrade disabled.png")]
		private static var upgradeDisabledImage:Class;
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/sell normal.png")]
		private static var sellNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/sell over.png")]
		private static var sellOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/sell down.png")]
		private static var sellDownImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/sell disabled.png")]
		private static var sellDisabledImage:Class;
		
		/////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/repair normal.png")]
		private static var repairNormalImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/repair over.png")]
		private static var repairOverImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/repair down.png")]
		private static var repairDownImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/repair disabled.png")]
		private static var repairDisabledImage:Class;
		
		///////////////
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/upgrade price panel.png")]
		private static var upgradePricePanelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/repair price panel.png")]
		private static var repairPricePanelImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/weapon menu/sell price panel.png")]
		private static var sellPricePanelImage:Class;
		
		////////////////////////
		
		public var button:Button = new Button();
		private var pricePanel:Bitmap;
		private var priceLabel:CustomTextField;
		
		//////////////////////////
		
		public function WeaponSettingsPanelButton(type:String)
		{
			constructButton(type);
		}
		
		//////////////////////////
		
		private var _price:String = null;
		
		public function get price():String
		{
			return _price;
		}
		
		public function get priceFormatted():String
		{
			return priceLabel.text;
		}
		
		public function set price(value:String):void
		{
			_price = value;
			priceLabel.text = value;
		}
		
		////////
		
		public function get enabled():Boolean
		{
			return button.enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			button.enabled = value;
			//mouseEnabled = value;
			//mouseChildren = value;
		}
		
		//////////////////////////
		
		private var panelShiftX:Number = 7;
		private var panelShiftY:Number = 42;
		private var labelPaddingTop:Number = 8;
		
		private function constructButton(type:String):void
		{
			switch (type)
			{
				case TYPE_UPGRADE: 
					ControlConfigurator.configureButton(button, upgradeNormalImage, upgradeOverImage, upgradeDownImage, upgradeDisabledImage);
					pricePanel = new upgradePricePanelImage() as Bitmap;
					break;
				case TYPE_REPAIR: 
					ControlConfigurator.configureButton(button, repairNormalImage, repairOverImage, repairDownImage, repairDisabledImage);
					pricePanel = new repairPricePanelImage() as Bitmap;
					break;
				case TYPE_SELL: 
					ControlConfigurator.configureButton(button, sellNormalImage, sellOverImage, sellDownImage, sellDisabledImage);
					pricePanel = new sellPricePanelImage() as Bitmap;
					break;
			}
			
			pricePanel.x = panelShiftX + 3;
			pricePanel.y = panelShiftY + 3;

			priceLabel = new CustomTextField(null, new FontDescriptor(14, 0xFFFFFF, FontResources.BOMBARD));
			priceLabel.textWidth = 45;
			priceLabel.alignCenter = true;
			priceLabel.x = panelShiftX;
			priceLabel.y = panelShiftY;
			priceLabel.paddingTop = labelPaddingTop;
			
			addChild(button);
			addChild(pricePanel);
			addChild(priceLabel);
			
			shiftContentToCenter(this);
		}
		
		private function shiftContentToCenter(sprite:NSSprite):void
		{
			var shiftX:Number = sprite.width / 2;
			var shiftY:Number = sprite.height / 2;
			
			for (var i:int = 0; i < sprite.numChildren; i++)
			{
				var child:DisplayObject = sprite.getChildAt(i);
				child.x -= shiftX;
				child.y -= shiftY;
			}
		}
	
	}

}