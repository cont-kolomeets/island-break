/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import nslib.controls.supportClasses.ToolTipInfo;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ToolTipBase extends NSSprite
	{
		// in some rare cases a tooltip has to be shown when mouse is over one component, but relatively to another one
		// In such cases, host will be the component to show tooltip relatively to, and sensitivityContainer is the component
		// sensitive to mouse motions.
		public var sensitivityContainer:DisplayObject = null;
		
		// content
		protected var toolTipContent:IToolTipContent = null;
		
		private var contentClass:Class = ToolTipBaseContent;
		
		////////////////////
		
		public function ToolTipBase(contentClass:Class = null)
		{
			super();
			
			if (contentClass)
				this.contentClass = contentClass;
			
			toolTipContent = new contentClass() as IToolTipContent;
			
			addChild(toolTipContent as DisplayObject);
		}
		
		////////////////
		
		private var _toolTipInfo:ToolTipInfo;
		
		public function get toolTipInfo():ToolTipInfo
		{
			return _toolTipInfo;
		}
		
		public function set toolTipInfo(value:ToolTipInfo):void
		{
			_toolTipInfo = value;
			
			host = value.host;
			// filling content
			toolTipContent.contentDescriptor = value.contentDescriptor;
			
			applySmartPositioning();
		}
		
		// positions tooltip according to it's content.
		protected function applySmartPositioning():void
		{
			if (!toolTipInfo.autoPositioning)
				return;
			
			toolTipInfo.bodyOffsetX = 0;
			toolTipInfo.bodyOffsetY = 0;
			toolTipInfo.tipOffsetX = 0;
			toolTipInfo.tipOffsetY = 0;
		}
		
		//////////////
		
		private var _host:DisplayObject = null;
		
		public function get host():DisplayObject
		{
			return _host;
		}
		
		public function set host(value:DisplayObject):void
		{
			_host = value;
		}
		
		//////////////
		
		private var _toolTipLayer:NSSprite = null;
		
		public function get toolTipLayer():NSSprite
		{
			return _toolTipLayer;
		}
		
		public function set toolTipLayer(value:NSSprite):void
		{
			_toolTipLayer = value;
		}
		
		///////////////////
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			// the best position might be calculated after several trials, but
			// final drawing should happen only once after repositioning
			drawToolTip();
		}
		
		// override this method to draw your own tooltip shape
		protected function drawToolTip():void
		{
		
		}
		
		///////////////////
		
		public function setNewPrefferablePosition(position:String, forceApply:Boolean = false):void
		{
			if (forceApply || toolTipInfo.prefferablePosition != position)
			{
				toolTipInfo.prefferablePosition = position;
				applySmartPositioning();
				invalidateProperties();
			}
		}
		
		///////////////////
		
		// positions the tooltip taking into account the current offsets
		// and the stage bounds. If necessary, changes the position
		public function positionRelativeToComponent():void
		{
			if (!toolTipLayer)
				return;
			
			var hostLocation:Point = host.localToGlobal(new Point(toolTipInfo.bodyOffsetX, toolTipInfo.bodyOffsetY));
			var toolTipLocation:Point = toolTipLayer.globalToLocal(hostLocation);
			
			x = toolTipLocation.x;
			y = toolTipLocation.y;
		}
	}

}