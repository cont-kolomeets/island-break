package bot.ui
{
	import flash.display.Shape;
	import nslib.controls.Button;
	import nslib.controls.CustomTextField;
	import nslib.controls.supportClasses.LayoutConstants;
	import nslib.utils.AlignUtil;
	import nslib.utils.FontDescriptor;
	import supportClasses.ControlConfigurator;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ControlButton extends Button
	{
		protected var labelField:CustomTextField = new CustomTextField();
		
		public function ControlButton(label:String = "")
		{
			layout = LayoutConstants.NONE;
			
			var buttonUpImage:Shape = new Shape();
			buttonUpImage.graphics.lineStyle(2, 0);
			buttonUpImage.graphics.beginFill(0xDDDDDD);
			buttonUpImage.graphics.drawRoundRect(0, 0, 60, 25, 5, 5);
			
			var buttonDownImage:Shape = new Shape();
			buttonDownImage.graphics.lineStyle(2, 0);
			buttonDownImage.graphics.beginFill(0xCCCCCC);
			buttonDownImage.graphics.drawRoundRect(0, 0, 60, 25, 5, 5);
			
			ControlConfigurator.configureButton(this, buttonUpImage, null, buttonDownImage);
			
			refresh(true, true);
			
			labelField.fontDescriptor = new FontDescriptor(13, 0, FontResources.BOMBARD);
			labelField.text = label;
			
			AlignUtil.centerSimple(labelField, this);
			
			addChild(labelField);
		}
	
	}

}