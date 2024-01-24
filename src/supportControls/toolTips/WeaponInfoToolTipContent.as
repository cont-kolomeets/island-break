/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.toolTips
{
	import constants.HotKeys;
	import flash.display.Bitmap;
	import infoObjects.WeaponInfo;
	import nslib.controls.CustomTextField;
	import nslib.controls.IToolTipContent;
	import nslib.controls.LayoutContainer;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponInfoToolTipContent extends LayoutContainer implements IToolTipContent
	{
		protected var header:CustomTextField = new CustomTextField();
		
		protected var body:CustomTextField = new CustomTextField();
		
		protected var imageHolder:Bitmap = null;
		
		//////////////
		
		public function WeaponInfoToolTipContent()
		{
			configureLayout();
			configureStyling();
		}
		
		//////////////
		
		private var _contentDescriptor:WeaponInfoToolTipContentDescriptor = null;
		
		public function get contentDescriptor():Object
		{
			return _contentDescriptor;
		}
		
		public function set contentDescriptor(value:Object):void
		{
			if (!(value is WeaponInfoToolTipContentDescriptor))
				return;
			
			_contentDescriptor = value as WeaponInfoToolTipContentDescriptor;
			
			createToolTipFromDescriptor();
			
			// in case content changed its layout need to refresh this container
			refresh(false, true);
		}
		
		private function createToolTipFromDescriptor():void
		{
			var weaponInfo:WeaponInfo = _contentDescriptor.weaponInfo;
			
			// if upgrade, adding 'Next Level' label
			if (_contentDescriptor.isForNextLevel)
			{
				header.appendText("Next Level", new FontDescriptor(15, 0x57F73C, FontResources.YARDSALE), 0);
				header.caretToNextLine();
				header.appendMultiLinedText(weaponInfo.name, new FontDescriptor(16, 0xFFE840, FontResources.JUNEGULL));
			}
			// else just showing the name and the level
			else
			{
				header.appendMultiLinedText(weaponInfo.name, new FontDescriptor(16, 0xFFE840, FontResources.JUNEGULL));
				
				header.caretToNextLine(-5);
				
				var hotKey:String = HotKeys.getHotKeyForWeaponInfo(weaponInfo);
				if (hotKey)
					header.appendText("Hot key [" + hotKey + "]", new FontDescriptor(13, 0xF9EF73, FontResources.BOMBARD));
				
				header.caretToNextLine(5);
				
				if (weaponInfo.weaponId != WeaponResources.USER_OBSTACLE)
					header.appendMultiLinedText("level " + (weaponInfo.level + 1), new FontDescriptor(16, 0xFFFFFF, FontResources.KOMTXTB, "normal"));
			}
			
			body.text = weaponInfo.generalDescription;
			
			// adding some parameters
			body.caretToNextLine();
			
			var properties:Array = getPropertiesToShow();
			for each (var item:Object in properties)
			{
				body.appendText(String(item.name), new FontDescriptor(12, 0xF9EF73, FontResources.BOMBARD));
				body.caretForward(3);
				body.appendText(String(item.value), new FontDescriptor(12, 0xFFFFFF, FontResources.BOMBARD));
				body.caretToNextLine();
			}
			
			imageHolder = new weaponInfo.iconMiddle() as Bitmap;
			
			var container:NSSprite = new NSSprite();
			
			container.addChild(header);
			container.addChild(imageHolder);
			container.addChild(body);
			
			imageHolder.x = Math.max(100, (body.width - imageHolder.width + 3));
			body.y = Math.max(imageHolder.height, 65) + 3;
			
			addChild(container);
		}
		
		private function getPropertiesToShow():Array
		{
			var info:WeaponInfo = _contentDescriptor.weaponInfo;
			var properties:Array = [];
			
			if (info.weaponId == WeaponResources.USER_AIR_SUPPORT)
			{
				if (info.armorDescription)
					properties.push({name: "HP:", value: info.armorDescription});
				
				if (info.armorDescription)
					properties.push({name: "Physical Armor:", value: info.hitThresholdDescription});
			}
			
			if (info.hitPowerDescription)
				properties.push({name: "Damage:", value: info.hitPowerDescription});
			else if (info.shockPowerDescription)
				properties.push({name: "Damage:", value: info.shockPowerDescription});
			
			if (info.speedDescription)
				properties.push({name: "Speed:", value: info.speedDescription});
			else if (info.shootDelayDescription)
				properties.push({name: "Reload:", value: info.shootDelayDescription});
			
			if (info.weaponId == WeaponResources.USER_REPAIR_CENTER)
				properties.push({name: "Attack Range:", value: info.hitRadiusDescription});
			
			return properties;
		}
		
		//////////////////////////
		
		private function configureLayout():void
		{
			layout = "vertical";
			horizontalAlignment = "left";
			paddingTop = 5;
			paddingLeft = 5;
			paddingRight = 5;
			paddingBottom = 5;
		}
		
		/// styling
		
		private function configureStyling():void
		{
			header.fontDescriptor = new FontDescriptor(12, 0xFFFFFF, FontResources.YARDSALE);
			header.textWidth = 110;
			header.verticalGap = 2;
			
			body.fontDescriptor = new FontDescriptor(14, 0xFFFFFF, FontResources.BOMBARD);
			body.verticalGap = 2;
			body.paddingBottom = 5;
			body.textWidth = 195;
		}
	}

}