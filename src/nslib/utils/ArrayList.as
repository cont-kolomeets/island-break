/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class ArrayList
	{
		// for optimization (now we can operate using only 2 instances!)
		//private var newArray:Array = [];
		
		public var source:Array = null;
		
		// lock your array list if you want to track operations that change the source
		// if you try to change the source with locked set as true, an error will be thrown.
		public var locked:Boolean = false;
		
		///////////////////
		
		public function ArrayList(source:Array = null)
		{
			this.source = source ? source : [];
		}
		
		//////////////////
		
		public function get length():int
		{
			return source.length;
		}
		
		public function set length(value:int):void
		{
			source.length = value;
		}
		
		/////////////////
		
		public function getItemAt(index:int):Object
		{
			return source[index];
		}
		
		public function setItemAt(item:*, index:int):void
		{
			if (locked)
				throw new Error("Method setItemAt() was called for a locked ArrayList!");
			
			source[index] = item;
		}
		
		public function removeItemAt(index:int):Object
		{
			if (locked)
				throw new Error("Method removeItemAt() was called for a locked ArrayList!");
				
			var removedObject:Object = null;
			
			if (index == 0)
				return source.shift();
			else if (index == (this.length - 1))
				return source.pop();
			
			// newArray is an empty array
			var result:Array =  [];// newArray;
			
			for (var i:int = 0; i < source.length; i++)
				if (i != index)
					result.push(source[i]);
				else
					removedObject = source[i];
			
			//newArray = source;
			//newArray.length = 0;
			
			source = result;
			
			return removedObject;
		}
		
		public function removeItem(item:*):void
		{
			if (locked)
				throw new Error("Method removeItem() was called for a locked ArrayList!");
				
			if (!contains(item))
				return;
			
			// newArray is an empty array
			var result:Array = [];// newArray;
			
			for (var i:int = 0; i < source.length; i++)
				if (item != source[i])
					result.push(source[i]);
			
			//newArray = source;
			//newArray.length = 0;
			
			source = result;
		}
		
		public function addItem(item:*, unique:Boolean = true):void
		{
			if (locked)
				throw new Error("Method addItem() was called for a locked ArrayList!");
				
			if (!unique || !contains(item))
				source.push(item);
		}
		
		public function addFromArray(array:Array):void
		{
			if (locked)
				throw new Error("Method addFromArray() was called for a locked ArrayList!");
				
			if (!array)
				return;
			
			for each (var item:*in array)
				addItem(item);
		}
		
		public function addItemAt(item:*, index:int, keepUnique:Boolean = true):void
		{
			if (locked)
				throw new Error("Method addItemAt() was called for a locked ArrayList!");
				
			if (keepUnique && contains(item))
				removeItem(item);
			
			// newArray is an empty array
			var result:Array = [];// newArray;
			
			if (index > source.length)
				index = source.length;
			
			var pushed:Boolean = false;
			
			for (var i:int = 0; i <= source.length; i++)
				if (i == index)
				{
					pushed = true;
					result.push(item);
				}
				else
					result.push(source[(pushed ? (i - 1) : i)]);
			
			//newArray = source;
			//newArray.length = 0;
			
			source = result;
		}
		
		public function removeItems(itemsToRemove:Array):void
		{
			if (locked)
				throw new Error("Method removeItems() was called for a locked ArrayList!");
				
			for each (var item:*in itemsToRemove)
				removeItem(item);
		}
		
		public function removeAll():void
		{
			if (locked)
				throw new Error("Method removeAll() was called for a locked ArrayList!");
				
			source.length = 0;
		}
		
		public function contains(item:*):Boolean
		{
			return Boolean(source.lastIndexOf(item) != -1);
		}
		
		public function toString():String
		{
			return String(source);
		}
		
		public function getItemIndex(item:*):int
		{
			for (var i:int = 0; i < source.length; i++)
				if (item == source[i])
					return i;
			
			return -1;
		}
	
	}

}