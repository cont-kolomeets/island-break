/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package supportControls.toolTips
{
	import infoObjects.WaveInfo;
	import nslib.controls.CustomTextField;
	import nslib.controls.IToolTipContent;
	import nslib.controls.LayoutContainer;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class WaveToolTipContent extends LayoutContainer implements IToolTipContent
	{
		protected var header:CustomTextField = new CustomTextField();
		
		protected var body:CustomTextField = new CustomTextField();
		
		/////////////////////////////
		
		public function WaveToolTipContent()
		{
			configureLayout();
			configureStyling();
		}
		
		//////////////
		
		private var _contentDescriptor:WaveInfo = null;
		
		public function get contentDescriptor():Object
		{
			return _contentDescriptor;
		}
		
		public function set contentDescriptor(value:Object):void
		{
			if (!(value is WaveInfo))
				return;
			
			_contentDescriptor = value as WaveInfo;
			
			createToolTipFromDescriptor();
			
			// in case content changed its layout need to refresh this container
			refresh(false, true);
		}
		
		private function createToolTipFromDescriptor():void
		{
			header.fontDescriptor = new FontDescriptor(14, 0xFFE840, FontResources.JUNEGULL);
			header.text = "Wave " + (_contentDescriptor.waveCount + 1);
			addChild(header);
			
			var len:int = _contentDescriptor.getNumUnits();
			for (var i:int = 0; i < len; i++)
			{
				var item:WaveToolTipContentItem = new WaveToolTipContentItem();
				item.constructFromInfo(_contentDescriptor.getInfoForUnitAt(i), _contentDescriptor.getCountForUnitAt(i));
				addChild(item);
			}
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
			verticalGap = 5;
		}
		
		/// styling
		
		private function configureStyling():void
		{
			header.fontDescriptor = new FontDescriptor(12, 0xFFFFFF, FontResources.YARDSALE);
			header.textWidth = 120;
			header.verticalGap = 2;
			header.paddingBottom = 7;
		}
	}

}