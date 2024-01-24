/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.encyclopedia
{
	import flash.display.Bitmap;
	import infoObjects.WeaponInfo;
	import mainPack.GameSettings;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipInfo;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.controls.supportClasses.ToolTipSimpleContentDescriptor;
	import nslib.utils.FontDescriptor;
	import nslib.utils.ImageUtil;
	import supportClasses.resources.FontResources;
	import supportClasses.resources.WeaponResources;
	import supportControls.toolTips.InGameHintToolTip;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class UnitPropertiesContainer extends NSSprite
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
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/range.png")]
		private static var rangeImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/hp.png")]
		private static var hpImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/weapon/weapon properties/missileShootDelay.png")]
		private static var missileShootDelayImage:Class;
		
		/////////////////
		
		private var armorBM:Bitmap = new armorImage() as Bitmap;
		
		private var hitPowerBM:Bitmap = new hitPowerImage() as Bitmap;
		
		private var reloadBM:Bitmap = new reloadImage() as Bitmap;
		
		private var speedBM:Bitmap = new speedImage() as Bitmap;
		
		private var shockPowerBM:Bitmap = new shockPowerImage() as Bitmap;
		
		private var repairPowerBM:Bitmap = new repairPowerImage() as Bitmap;
		
		private var rangeBM:Bitmap = new rangeImage() as Bitmap;
		
		private var hpBM:Bitmap = new hpImage() as Bitmap;
		
		private var missileShootDelayBM:Bitmap = new missileShootDelayImage() as Bitmap;
		
		//////
		
		private var numColumns:int = 2;
		
		private var containers:Array = [];
		
		/////////////////
		
		public function UnitPropertiesContainer()
		{
			prescaleImages();
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
			ImageUtil.scaleToFitWidth(image, 22);
		}
		
		////////////////
		
		private var rowCount:int = 0;
		private var columnCount:int = 0;
		
		public function showInfoForWeapon(weaponInfo:WeaponInfo):void
		{
			// reseting flags
			rowCount = 0;
			columnCount = 0;
			
			clearContainers();
			removeAllChildren();
			
			if (!weaponInfo)
				return;
			
			if (weaponInfo.armorDescription)
				addContainer(createDescriptionContainer(hpBM, weaponInfo.armorDescription, "Health Points", "Amount of damage the unit can withstand."));
			
			if (weaponInfo.hitThresholdDescription)
				addContainer(createDescriptionContainer(armorBM, weaponInfo.hitThresholdDescription, "Armor Rating", "Armor reduces physical damage."));
			
			if (weaponInfo.speedDescription)
				addContainer(createDescriptionContainer(speedBM, weaponInfo.speedDescription, "Speed", "How quick the unit moves."));
			
			// these two are mutually exclusive
			if (weaponInfo.repairPowerDescription)
				addContainer(createDescriptionContainer(repairPowerBM, weaponInfo.repairPowerDescription, "Repair Rating", "Ability to repair damaged units."));
			else if (weaponInfo.hitPowerDescription)
			{
				var twoValues:Boolean = weaponInfo.hitPowerDescription.indexOf("/") != -1;
				addContainer(createDescriptionContainer(hitPowerBM, weaponInfo.hitPowerDescription, "Physical Damage", twoValues ? "Amount of damage dealt by attack (bullet/missiles)." : "Amount of damage dealt by attack."));
			}
			
			if (weaponInfo.shockPowerDescription)
				addContainer(createDescriptionContainer(shockPowerBM, weaponInfo.shockPowerDescription, "Electric Damage", "Amount of damage dealt by electric attack."));
			
			if (weaponInfo.shootDelayDescription)
			{
				var isElectric:Boolean = (weaponInfo.weaponId == WeaponResources.USER_ELECTRIC_TOWER || weaponInfo.weaponId == WeaponResources.ENEMY_ENERGY_BALL);
				addContainer(createDescriptionContainer(reloadBM, weaponInfo.shootDelayDescription, isElectric ? "Reload" : "Bullet Reload", isElectric ? "Time between electric attacks." : "Time between bullet attacks."));
			}
			
			if (weaponInfo.missileShootDelayDescription)
				addContainer(createDescriptionContainer(missileShootDelayBM, weaponInfo.missileShootDelayDescription, "Missile Reload", "Time between missile attacks."));
			
			if (weaponInfo.weaponId != WeaponResources.ENEMY_HELICOPTER && weaponInfo.weaponId != WeaponResources.ENEMY_PLANE && weaponInfo.weaponId != WeaponResources.USER_AIR_SUPPORT)
				if (weaponInfo.hitRadiusDescription)
				{
					if (weaponInfo.weaponId == WeaponResources.ENEMY_REPAIR_TANK)
						addContainer(createDescriptionContainer(rangeBM, weaponInfo.hitRadiusDescription, "Repair Range", "Range the unit can fix other damaged units within."));
					else
						addContainer(createDescriptionContainer(rangeBM, weaponInfo.hitRadiusDescription, weaponInfo.repairPowerDescription ? "Repair Range" : "Attack Range", weaponInfo.repairPowerDescription ? "Range the tower can fix damaged units within." : "How far the unit can attack."));
				}
		}
		
		private function createDescriptionContainer(image:Bitmap, text:String, toolTipHeader:String, toolTipBody:String):NSSprite
		{
			var container:NSSprite = new NSSprite();
			container.mouseEnabled = true;
			var textField:CustomTextField = new CustomTextField(text, new FontDescriptor(13, 0xFFFFFF, FontResources.BOMBARD));
			
			textField.x = image.width + 5;
			textField.y = 5;
			
			container.addChild(image);
			container.addChild(textField);
			
			containers.push(container);
			
			addToolTip(container, toolTipHeader, toolTipBody);
			
			return container;
		}
		
		private function addToolTip(container:NSSprite, toolTipHeader:String, toolTipBody:String):void
		{
			if (!GameSettings.enableTooltips)
				return;
			
			var ti:ToolTipInfo = new ToolTipInfo(container);
			var descriptor:ToolTipSimpleContentDescriptor = new ToolTipSimpleContentDescriptor(toolTipHeader, [toolTipBody]);
			ti.contentDescriptor = descriptor;
			ToolTipService.setToolTip(container, ti, InGameHintToolTip);
		}
		
		private function addContainer(container:NSSprite):void
		{
			container.x = rowCount * 105;
			container.y = columnCount * 27;
			
			if (++rowCount == numColumns)
			{
				rowCount = 0;
				columnCount++;
			}
			
			addChild(container);
		}
		
		private function clearContainers():void
		{
			for each (var container:NSSprite in containers)
				ToolTipService.removeAllTooltipsForComponent(container);
			
			containers.length = 0;
		}
	
	}

}