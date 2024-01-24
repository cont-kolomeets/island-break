/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.display.DisplayObject;
	import nslib.controls.events.LayoutEvent;
	import nslib.controls.supportClasses.LayoutConstants;
	import nslib.controls.supportClasses.PositionConstants;
	import nslib.utils.NSMath;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class LayoutContainer extends NSSprite
	{
		private var layoutIsValidFlag:Boolean = true;
		
		////////////////////////////////////
		
		public function LayoutContainer()
		{
			super();
			invalidateLayout();
		}
		
		/////////////////////////////////////
		
		private var _layout:String = LayoutConstants.HORIZONTAL;
		private var _verticalAlignment:String = PositionConstants.MIDDLE;
		private var _horizontalAlignment:String = PositionConstants.CENTER;
		
		private var _paddingLeft:Number = 0;
		private var _paddingRight:Number = 0;
		private var _paddingTop:Number = 0;
		private var _paddingBottom:Number = 0;
		private var _horizontalGap:Number = 5;
		private var _verticalGap:Number = 5;
		
		public function get verticalAlignment():String
		{
			return _verticalAlignment;
		}
		
		public function set verticalAlignment(value:String):void
		{
			_verticalAlignment = value;
			invalidateLayout();
		}
		
		public function get horizontalAlignment():String
		{
			return _horizontalAlignment;
		}
		
		public function set horizontalAlignment(value:String):void
		{
			_horizontalAlignment = value;
			invalidateLayout();
		}
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
			invalidateLayout();
		}
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
			invalidateLayout();
		}
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
			invalidateLayout();
		}
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
			invalidateLayout();
		}
		
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}
		
		public function set horizontalGap(value:Number):void
		{
			_horizontalGap = value;
			invalidateLayout();
		}
		
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		
		public function set verticalGap(value:Number):void
		{
			_verticalGap = value;
			invalidateLayout();
		}
		
		public function get layout():String
		{
			return _layout;
		}
		
		public function set layout(value:String):void
		{
			_layout = value;
			invalidateLayout();
		}
		
		/////////////////////////////////////
		
		// when settings width from outside the value
		// is stored in the containerWidth property.
		// This property holds the desired width for the container.
		private var containerWidth:Number = 0;
		
		// but in reality the width of the content might
		// be bigger than the desired width, so this value
		// is calculated based on the content's width
		// and it is returned as the current width so
		// other layout containers can place this one considering
		// the width of its content, but not the desired width.
		private var layoutWidth:Number = 0;
		
		override public function get width():Number
		{
			return layoutWidth;
		}
		
		override public function set width(value:Number):void
		{
			containerWidth = value;
			invalidateLayout();
		}
		
		/////////
		
		private var containerHeight:Number = 0;
		private var layoutHeight:Number = 0;
		
		override public function get height():Number
		{
			return layoutHeight;
		}
		
		override public function set height(value:Number):void
		{
			containerHeight = value;
			invalidateLayout();
		}
		
		////////////////////////////////////
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var obj:DisplayObject = super.addChildAt(child, index);
			
			obj.addEventListener(LayoutEvent.LAYOUT_INVALIDATED, child_layoutInvalidatedHandler);
			
			invalidateLayout();
			
			return obj;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			var obj:DisplayObject = super.addChild(child);
			
			obj.addEventListener(LayoutEvent.LAYOUT_INVALIDATED, child_layoutInvalidatedHandler);
			
			invalidateLayout();
			
			return obj;
		}
		
		override public function removeChild(child:DisplayObject):flash.display.DisplayObject
		{
			var obj:DisplayObject = super.removeChild(child);
			
			obj.removeEventListener(LayoutEvent.LAYOUT_INVALIDATED, child_layoutInvalidatedHandler);
			invalidateLayout();
			
			return obj;
		}
		
		override public function removeChildAt(index:int):flash.display.DisplayObject
		{
			var obj:DisplayObject = super.removeChildAt(index);
			
			obj.removeEventListener(LayoutEvent.LAYOUT_INVALIDATED, child_layoutInvalidatedHandler);
			invalidateLayout();
			
			return obj;
		}
		
		private function child_layoutInvalidatedHandler(event:LayoutEvent):void
		{
			invalidateLayout();
		}
		
		//////////////
		
		/**
		 * Forces update of the layout if necessary.
		 * @param	force If true, the content  will
		 * be refreshed regardless of necessarity of it.
		 * @param	refreshChildren If true for all children will
		 * be called the refresh() method with
		 * force property set to the same value as here, and
		 * refreshChildren property set to true.
		 */
		public function refresh(force:Boolean = false, refreshChildren:Boolean = false):void
		{
			// we first need children to refresh their layouts
			// so the parent will fit its layout based
			// on the updated sizes of its children.
			if (refreshChildren)
				for (var i:int = 0; i < numChildren; i++)
				{
					var child:LayoutContainer = getChildAt(i) as LayoutContainer;
					if (child)
						child.refresh(force, true);
				}
			
			// new when all children's layouts are updated its time for the
			// parents layout.
			// this operation needs to be performed only if the layout is dirty
			if (!layoutIsValidFlag || force)
				updateLayout();
		
			//if (!propertiesAreValid || force)
			//	commitProperties();
		}
		
		private var child:DisplayObject;
		private var i:int;
		private var accumulatedWidth:Number = 0;
		private var accumulatedHeight:Number = 0;
		
		protected function updateLayout():void
		{
			// horizontal allign
			
			accumulatedWidth = 0;
			accumulatedHeight = 0;
			
			if (numChildren == 0)
			{
				layoutIsValidFlag = true;
				return;
			}
			
			if (layout == LayoutConstants.NONE)
			{
				prepareNullLayout();
			}
			else if (layout == LayoutConstants.HORIZONTAL)
			{
				
				if (horizontalAlignment == PositionConstants.CENTER)
					allignHorCenter();
				else if (horizontalAlignment == PositionConstants.RIGHT)
					allignHorRight();
				else
					allignHorLeft();
				
				if (verticalAlignment == PositionConstants.MIDDLE)
					allignHorMiddle();
				else if (verticalAlignment == PositionConstants.BOTTOM)
					allignHorBottom();
				else
					allignHorTop();
			}
			else if (layout == LayoutConstants.VERTICAL)
			{
				
				if (horizontalAlignment == PositionConstants.CENTER)
					allignVertCenter();
				else if (horizontalAlignment == PositionConstants.RIGHT)
					allignVertRight();
				else
					allignVertLeft();
				
				if (verticalAlignment == PositionConstants.MIDDLE)
					allignVertMiddle();
				else if (verticalAlignment == PositionConstants.BOTTOM)
					allignVertBottom();
				else
					allignVertTop();
			}
			
			layoutWidth = NSMath.max(containerWidth, accumulatedWidth);
			layoutHeight = NSMath.max(containerHeight, accumulatedHeight);
			
			layoutIsValidFlag = true;
			
			dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_CHANGED));
		}
		
		private function prepareNullLayout():void
		{
			var minX:Number = Number.POSITIVE_INFINITY;
			var maxX:Number = Number.NEGATIVE_INFINITY;
			var minY:Number = Number.POSITIVE_INFINITY;
			var maxY:Number = Number.NEGATIVE_INFINITY;
			
			for (i = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				
				minX = Math.min(minX, child.x);
				minY = Math.min(minY, child.y);
				
				maxX = Math.max(maxX, child.x + child.width);
				maxY = Math.max(maxY, child.y + child.height);
			}
			
			accumulatedWidth = maxX - minX;
			accumulatedHeight = maxY - minY;
		}
		
		private function allignHorLeft():void
		{
			accumulatedWidth = paddingLeft;
			
			for (i = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.x = accumulatedWidth;
				
				accumulatedWidth += child.width + horizontalGap;
				
				if (i == (numChildren - 1))
					accumulatedWidth += paddingRight - horizontalGap;
			}
		}
		
		private function allignHorCenter():void
		{
			var childrenOverallWidth:Number = 0;
			
			for (i = 0; i < numChildren; i++)
				childrenOverallWidth += getChildAt(i).width + horizontalGap;
			
			childrenOverallWidth -= horizontalGap;
			
			if (containerWidth <= (paddingLeft + childrenOverallWidth + paddingRight))
			{
				allignHorLeft();
				return;
			}
			
			var offset:Number = (containerWidth - childrenOverallWidth) / 2;
			
			///////
			
			accumulatedWidth = offset;
			
			for (i = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.x = accumulatedWidth;
				
				accumulatedWidth += child.width + horizontalGap;
				
				if (i == (numChildren - 1))
					accumulatedWidth += offset - horizontalGap;
			}
		}
		
		private function allignHorRight():void
		{
			var childrenOverallWidth:Number = 0;
			
			for (i = 0; i < numChildren; i++)
				childrenOverallWidth += getChildAt(i).width + horizontalGap;
			
			childrenOverallWidth -= horizontalGap;
			
			if (containerWidth <= (paddingLeft + childrenOverallWidth + paddingRight))
			{
				allignHorLeft();
				return;
			}
			
			var offset:Number = containerWidth - childrenOverallWidth - paddingRight;
			
			///////
			
			accumulatedWidth = offset;
			
			for (i = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.x = accumulatedWidth;
				
				accumulatedWidth += child.width + horizontalGap;
				
				if (i == (numChildren - 1))
					accumulatedWidth += paddingRight - horizontalGap;
			}
		}
		
		/////////////////////
		
		private function allignHorTop():void
		{
			for (i = 0; i < numChildren; i++)
				getChildAt(i).y = paddingTop;
			
			accumulatedHeight = paddingTop + calcMaxHeight() + paddingBottom;
		}
		
		private function allignHorBottom():void
		{
			accumulatedHeight = paddingTop + calcMaxHeight() + paddingBottom;
			
			accumulatedHeight = NSMath.max(accumulatedHeight, containerHeight);
			
			for (i = 0; i < numChildren; i++)
				getChildAt(i).y = accumulatedHeight - paddingBottom - getChildAt(i).height;
		}
		
		private function allignHorMiddle():void
		{
			accumulatedHeight = paddingTop + calcMaxHeight() + paddingBottom;
			
			accumulatedHeight = NSMath.max(accumulatedHeight, containerHeight);
			
			for (i = 0; i < numChildren; i++)
				getChildAt(i).y = (accumulatedHeight - getChildAt(i).height) / 2;
		}
		
		/////////////////////////////////////////
		
		private function allignVertLeft():void
		{
			for (i = 0; i < numChildren; i++)
				getChildAt(i).x = paddingLeft;
			
			accumulatedWidth = paddingLeft + calcMaxWidth() + paddingRight;
		}
		
		private function allignVertRight():void
		{
			accumulatedWidth = paddingLeft + calcMaxWidth() + paddingRight;
			
			accumulatedWidth = NSMath.max(accumulatedWidth, containerWidth);
			
			for (i = 0; i < numChildren; i++)
				getChildAt(i).x = accumulatedWidth - paddingRight - getChildAt(i).width;
		}
		
		private function allignVertCenter():void
		{
			accumulatedWidth = paddingLeft + calcMaxWidth() + paddingRight;
			
			accumulatedWidth = NSMath.max(accumulatedWidth, containerWidth);
			
			for (i = 0; i < numChildren; i++)
				getChildAt(i).x = (accumulatedWidth - getChildAt(i).width) / 2;
		}
		
		/////////
		
		private function allignVertTop():void
		{
			accumulatedHeight = paddingTop;
			
			for (i = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.y = accumulatedHeight;
				
				accumulatedHeight += child.height + verticalGap;
				
				if (i == (numChildren - 1))
					accumulatedHeight += paddingBottom - verticalGap;
			}
		}
		
		private function allignVertMiddle():void
		{
			var childrenOverallHeight:Number = 0;
			
			for (i = 0; i < numChildren; i++)
				childrenOverallHeight += getChildAt(i).height + verticalGap;
			
			childrenOverallHeight -= verticalGap;
			
			if (containerHeight <= (paddingTop + childrenOverallHeight + paddingBottom))
			{
				allignVertTop();
				return;
			}
			
			var offset:Number = (containerHeight - childrenOverallHeight) / 2;
			
			///////
			
			accumulatedHeight = offset;
			
			for (i = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.y = accumulatedHeight;
				
				accumulatedHeight += child.height + verticalGap;
				
				if (i == (numChildren - 1))
					accumulatedHeight += offset - verticalGap;
			}
		}
		
		private function allignVertBottom():void
		{
			var childrenOverallHeight:Number = 0;
			
			for (i = 0; i < numChildren; i++)
				childrenOverallHeight += getChildAt(i).height + verticalGap;
			
			childrenOverallHeight -= verticalGap;
			
			if (containerHeight <= (paddingTop + childrenOverallHeight + paddingBottom))
			{
				allignVertTop();
				return;
			}
			
			var offset:Number = containerHeight - childrenOverallHeight - paddingBottom;
			
			///////
			
			accumulatedHeight = offset;
			
			for (i = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.y = accumulatedHeight;
				
				accumulatedHeight += child.height + verticalGap;
				
				if (i == (numChildren - 1))
					accumulatedHeight += paddingBottom - verticalGap;
			}
		}
		
		/////////////////////////
		
		private function calcMaxHeight():Number
		{
			var maxHeight:Number = 0;
			for (i = 0; i < numChildren; i++)
				maxHeight = NSMath.max(getChildAt(i).height, maxHeight);
			
			return maxHeight;
		}
		
		private function calcMaxWidth():Number
		{
			var maxWidth:Number = 0;
			for (i = 0; i < numChildren; i++)
				maxWidth = NSMath.max(getChildAt(i).width, maxWidth);
			
			return maxWidth;
		}
		
		//////////////////////////////
		
		public function invalidateLayout():void
		{
			if (!layoutIsValidFlag)
				return;
			
			layoutIsValidFlag = false;
			
			requestDelayedCommit();
			
			dispatchEvent(new LayoutEvent(LayoutEvent.LAYOUT_INVALIDATED));
		}
		
		override protected function performDelayedCommit():void
		{
			// here we need to updating the layout
			// staring from the very inner layout containers.
			// for this reason we need to find the most outer layout container
			// and just call refresh() method with refreshChildren flag set to true.
			var mostOutterContainer:LayoutContainer = getOuterLayoutContainerForComponent(this);
			mostOutterContainer.refresh(false, true);
			
			super.performDelayedCommit();
		}
		
		// considers only direct relations between layout container.
		private function getOuterLayoutContainerForComponent(container:LayoutContainer):LayoutContainer
		{
			if (container.parent is LayoutContainer)
				return getOuterLayoutContainerForComponent(container.parent as LayoutContainer);
			else
				return container;
		}
	}

}