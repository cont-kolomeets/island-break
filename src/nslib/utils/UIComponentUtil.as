/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	
	/**
	 * UI utilities class.
	 */
	public class UIComponentUtil
	{
		
		/**
		 * Finds parent component in UI hierarhy with specified class.
		 */
		public static function findParent(component:DisplayObject, parentClass:Class):*
		{
			if (!component)
				return null;
			
			var object:DisplayObject = component;
			var parentFound:Boolean = object is parentClass;
			while (!parentFound && object)
			{
				object = object.parent;
				parentFound = object is parentClass;
			}
			
			return object;
		}
		
		/**
		 * Checks if component has specified part in UI hierarhy.
		 **/
		public static function isParent(component:DisplayObject, parent:DisplayObjectContainer):Boolean
		{
			if (component != null)
			{
				if (component == parent)
				{
					return true;
				}
				else if (component.parent != null)
				{
					return isParent(component.parent as DisplayObject, parent);
				}
			}
			
			return false;
		}
		
		/**
		 * Find child component in UI hierarhy by Class.
		 **/
		public static function findChild(component:DisplayObjectContainer, childClass:Class):*
		{
			var result:DisplayObject = null;
			
			if (component != null)
			{
				if (component is childClass)
				{
					result = component;
				}
				else if (component.numChildren > 0)
				{
					for (var index:int = 0; index < component.numChildren; index++)
					{
						var child:DisplayObjectContainer = component.getChildAt(index) as DisplayObjectContainer;
						
						result = findChild(child, childClass);
						
						if (result)
						{
							break;
						}
					}
				}
			}
			
			return result;
		}
		
		/**
		 * Recursively checks all elements in display list where component is
		 * added. Returns true if all elements are visible, false otherwise.
		 */
		public static function isVisible(component:DisplayObject):Boolean
		{
			if (!component)
				return false;
			
			var object:DisplayObject = component;
			var visible:Boolean = object.visible;
			while (visible && object.parent)
			{
				object = object.parent;
				visible = object.visible;
			}
			
			return visible;
		}
		
		/**
		 * Checks that component is completely (all corners) within stage.
		 */
		public static function isWithinStage(c:DisplayObject):Boolean
		{
			if (!c)
				return false;
			
			var tl:Point = c.localToGlobal(new Point(0, 0));
			var br:Point = c.localToGlobal(new Point(c.width, c.height));
			
			//are we off the left or top of stage?
			if (tl.x < 0 || tl.y < 0)
				return false;
			
			var stage:Stage = c.stage;
			
			//off the right or bottom of stage?
			if (br.x > stage.width || br.y > stage.height)
				return false;
			
			return true;
		}
		
		public static function getAllChildren(container:DisplayObjectContainer, recursive:Boolean = false):Array
		{
			var children:Array = [];
			
			getAllChildrenInternal(container, recursive, children);
			
			return children;
		}
		
		private static function getAllChildrenInternal(container:DisplayObjectContainer, recursive:Boolean = false, arrayToPopulate:Array = null):void
		{
			var len:int = container.numChildren;
			
			for (var i:int = 0; i < len; i++)
			{
				var child:DisplayObject = container.getChildAt(i);
				
				arrayToPopulate.push(child);
				
				if (recursive && (child is DisplayObjectContainer))
					getAllChildrenInternal(child as DisplayObjectContainer, true, arrayToPopulate);
			}
		}
	}
}