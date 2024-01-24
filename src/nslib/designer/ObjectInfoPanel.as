package nslib.designer
{
	import flash.display.DisplayObject;
	import nslib.controls.CustomTextField;
	import nslib.controls.LayoutContainer;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.LayoutConstants;
	import nslib.utils.FontDescriptor;
	import nslib.utils.NameUtil;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ObjectInfoPanel extends NSSprite
	{
		private var nameField:CustomTextField = new CustomTextField("name", new FontDescriptor(15, 0xFFFFFF));
		private var xyField:CustomTextField = new CustomTextField("x: 100, y: 200", new FontDescriptor(15));
		private var dimField:CustomTextField = new CustomTextField("W: 100, H: 200", new FontDescriptor(15));
		private var rotField:CustomTextField = new CustomTextField("Rot: 200", new FontDescriptor(15));
		private var scaleField:CustomTextField = new CustomTextField("SX: 1.0, SY: 1.0", new FontDescriptor(15));
		private var alphaField:CustomTextField = new CustomTextField("alpha: 1.0", new FontDescriptor(15));
		private var modeField:CustomTextField = new CustomTextField("Mode: move", new FontDescriptor(15, 0x400080));
		
		private var layoutContainer:LayoutContainer = new LayoutContainer();
		
		////////////////
		
		public function ObjectInfoPanel()
		{
			construct();
		}
		
		////////////////
		
		private function construct():void
		{
			layoutContainer.layout = LayoutConstants.VERTICAL;
			layoutContainer.horizontalAlignment = "left";
			
			layoutContainer.addChild(nameField);
			layoutContainer.addChild(xyField);
			layoutContainer.addChild(dimField);
			layoutContainer.addChild(rotField);
			layoutContainer.addChild(scaleField);
			layoutContainer.addChild(alphaField);
			layoutContainer.addChild(modeField);
			layoutContainer.refresh(true);
			
			addChild(layoutContainer);
			
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.beginFill(0x00FF40, 0.5);
			graphics.drawRect(-5, -5, this.width + 5, this.height + 10);
		}
		
		public function showInfoForObject(object:DisplayObject, mode:String):void
		{
			nameField.text = NameUtil.getTruncatedClassName(object);
			xyField.text = "x: " + int(object.x) + ", y: " + int(object.y);
			dimField.text =  "W: " + int(object.width) + ", H: " + int(object.height);
			rotField.text = "Rot: " + object.rotation.toFixed(1);
			scaleField.text = "SX: " + object.scaleX.toFixed(1) + ", SY: " + object.scaleY.toFixed(1);
			alphaField.text = "alpha: " + object.alpha.toFixed(2);
			modeField.text = "Mode: " + mode;
		}
	
	}

}