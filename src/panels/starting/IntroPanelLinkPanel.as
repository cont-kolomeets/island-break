/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.starting
{
	import nslib.controls.Button;
	import supportClasses.ControlConfigurator;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class IntroPanelLinkPanel extends Button
	{
		public static const TYPE_SPONSOR:String = "sponsor";
		
		public static const TYPE_CREDITS:String = "credits";
		
		//////////
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/link frame L.png")]
		private static var linkFrameLImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/intro panel/link frame R.png")]
		private static var linkFrameRImage:Class;
		
		//////////
		
		private var type:String = null;
		
		//////////
		
		public function IntroPanelLinkPanel(type:String)
		{
			this.type = type;
			construct();
		}
		
		//////////
		
		private function construct():void
		{
			if (type == TYPE_SPONSOR)
				ControlConfigurator.configureButton(this, linkFrameLImage);
			else
				ControlConfigurator.configureButton(this, linkFrameRImage);
				
			refresh(true, true);
		}
	
	}

}