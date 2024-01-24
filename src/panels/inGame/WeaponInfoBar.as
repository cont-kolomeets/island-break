/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import flash.display.Bitmap;
	import flash.filters.GlowFilter;
	import infoObjects.WeaponInfo;
	import nslib.controls.CustomTextField;
	import nslib.controls.LayoutContainer;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.WeaponResources;
	import supportClasses.WeaponType;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WeaponInfoBar extends LayoutContainer
	{
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/armor.png")]
		private static var armorImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/hit power.png")]
		private static var hitPowerImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/reload.png")]
		private static var reloadImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/speed.png")]
		private static var speedImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/shock power.png")]
		private static var shockPowerImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/repair power.png")]
		private static var repairPowerImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/hp.png")]
		private static var hpImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/missileShootDelay.png")]
		private static var missileShootDelayImage:Class;
		
		/////////////////////
		
		private var armorBM:Bitmap;
		
		private var hitPowerBM:Bitmap;
		
		private var reloadBM:Bitmap;
		
		private var speedBM:Bitmap;
		
		private var shockPowerBM:Bitmap;
		
		private var repairPowerBM:Bitmap;
		
		private var hpBM:Bitmap;
		
		private var missileShootDelayBM:Bitmap;
		
		//////
		
		private var normalMessageLabel:CustomTextField;
		
		private var warningMessageLabel:CustomTextField;
		
		private var nameLabel:CustomTextField;
		
		private var label1:CustomTextField;
		
		private var label2:CustomTextField;
		
		private var label3:CustomTextField;
		
		private var label4:CustomTextField;
		
		/// flags
		
		private var keepWarningMessage:Boolean = false;
		
		/////////////////////
		
		public function WeaponInfoBar()
		{
			construct();
		}
		
		private function construct():void
		{
			paddingLeft = 5;
			horizontalGap = 10;
			verticalAlignment = "top";
			
			hpBM = new hpImage() as Bitmap;
			armorBM = new armorImage() as Bitmap;
			hitPowerBM = new hitPowerImage() as Bitmap;
			reloadBM = new reloadImage() as Bitmap;
			missileShootDelayBM = new missileShootDelayImage() as Bitmap;
			speedBM = new speedImage() as Bitmap;
			shockPowerBM = new shockPowerImage() as Bitmap;
			repairPowerBM = new repairPowerImage() as Bitmap;
			
			prescaleImages();
			
			// creating labels
			normalMessageLabel = new CustomTextField(null, new FontDescriptor(13, 0xDCFE96, FontResources.BOMBARD));
			normalMessageLabel.paddingTop = 5;
			
			warningMessageLabel = new CustomTextField(null, new FontDescriptor(15, 0xEC595C, FontResources.BOMBARD));
			warningMessageLabel.filters = [new GlowFilter(0xFF0000, 0.5)];
			warningMessageLabel.paddingTop = 2;
			
			nameLabel = new CustomTextField("Name:", new FontDescriptor(13, 0xFFFFFF, FontResources.BOMBARD));
			nameLabel.paddingTop = 5;
			label1 = new CustomTextField("10-15", new FontDescriptor(12, 0xFFFFFF, FontResources.BOMBARD));
			label1.paddingTop = 5;
			label2 = new CustomTextField("10-15", new FontDescriptor(12, 0xFFFFFF, FontResources.BOMBARD));
			label2.paddingTop = 5;
			label3 = new CustomTextField("10-15", new FontDescriptor(12, 0xFFFFFF, FontResources.BOMBARD));
			label3.paddingTop = 5;
			label4 = new CustomTextField("10-15", new FontDescriptor(12, 0xFFFFFF, FontResources.BOMBARD));
			label4.paddingTop = 5;
		}
		
		private function prescaleImages():void
		{
			scaleImage(armorBM);
			scaleImage(hitPowerBM);
			scaleImage(reloadBM);
			scaleImage(speedBM);
			scaleImage(shockPowerBM);
			scaleImage(repairPowerBM);
			scaleImage(hpBM);
			scaleImage(missileShootDelayBM);
		}
		
		private function scaleImage(image:Bitmap):void
		{
			image.smoothing = true;
			image.width = image.width * 25 / image.height;
			image.height = 25;
		}
		
		////////////////
		
		private var currentInfo:WeaponInfo = null;
		
		// shows information for a weapon.
		public function applyWeaponInfo(info:WeaponInfo):void
		{
			if (keepWarningMessage && warningMessageLabel.text != null)
				return;
			
			// optimization	
			if (currentInfo && info && currentInfo.weaponId == info.weaponId && currentInfo.level == info.level)
				return;
			
			currentInfo = info;
			
			removeAllChildren();
			
			if (!info)
				return;
			
			if (info.name)
			{
				nameLabel.text = info.name + ":";
				addChild(nameLabel);
			}
			
			// adding only the description for an obstacle
			if (info.weaponId == WeaponResources.USER_OBSTACLE)
			{
				label1.text = info.generalDescription;
				addChild(label1);
				return;
			}
			
			if (info.weaponType == WeaponType.ENEMY)
			{
				// show hp
				if (info.armorDescription)
				{
					addChild(hpBM);
					label1.text = info.armorDescription;
					addChild(label1);
				}
				
				// show armor
				if (info.hitThresholdDescription)
				{
					addChild(armorBM);
					label2.text = info.hitThresholdDescription;
					addChild(label2);
				}
			}
			
			// show repair power
			// or hit power
			// or shock power
			if (info.repairPowerDescription)
			{
				addChild(repairPowerBM);
				label3.text = info.repairPowerDescription;
				addChild(label3);
			}
			else if (info.hitPowerDescription)
			{
				addChild(hitPowerBM);
				label3.text = info.hitPowerDescription;
				addChild(label3);
			}
			else if (info.shockPowerDescription)
			{
				addChild(shockPowerBM);
				label3.text = info.shockPowerDescription;
				addChild(label3);
			}
			
			// show no more than 3 labels
			if (contains(label1) && contains(label2) && contains(label3))
				return;
			
			// show spped
			// or bullet shoot delay
			// or misslies shoot delay
			if (info.speedDescription)
			{
				addChild(speedBM);
				label4.text = info.speedDescription;
				addChild(label4);
			}
			else if (info.shootDelayDescription)
			{
				addChild(reloadBM);
				label4.text = info.shootDelayDescription;
				addChild(label4);
			}
			else if (info.missileShootDelayDescription)
			{
				addChild(missileShootDelayBM);
				label4.text = info.missileShootDelayDescription;
				addChild(label4);
			}
		}
		
		// shows message in the info bar.
		public function showNormalMessage(message:String):void
		{
			if (keepWarningMessage && warningMessageLabel.text != null)
				return;
			
			removeAllChildren();
			
			if (!message)
				return;
			
			normalMessageLabel.text = message;
			addChild(normalMessageLabel);
		}
		
		// shows warning message in the info bar.
		public function showWarningMessage(message:String, keepShown:Boolean = true):void
		{
			removeAllChildren();
			
			keepWarningMessage = Boolean(keepShown && message != null);
			
			if (!message)
				return;
			
			warningMessageLabel.text = message;
			addChild(warningMessageLabel);
		}
	}

}