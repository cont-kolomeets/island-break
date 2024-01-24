package nslib.utils
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class OptimizedArray
	{
		private var source:Array = [];
		
		private var NULL:Object = {};
		
		///////////
		
		public function OptimizedArray()
		{
		
		}
		
		////////////
		
		public function get length():int
		{
			return source.length;
		}
		
		public function get effectiveLength():int
		{
			var result:int = 0;
			var len:int = source.length;
			
			for (var i:int = 0; i < len; i++)
				if (source[i] != NULL)
					result++;
			
			return result;
		}
		
		public function getItemAt(index:int):*
		{
			var item:* = source[index];
			
			return item == NULL ? null : item;
		}
		
		public function removeItemAt(index:int):void
		{
			if (source.length <= index)
				return;
			
			source[index] = NULL;
		}
		
		public function addItem(item:*):void
		{
			var len:int = source.length;
			var placed:Boolean = false;
			
			for (var i:int = 0; i < len; i++)
				if (source[i] == NULL)
				{
					source[i] = item;
					placed = true;
					break;
				}
			
			if (!placed)
				source.push(item);
		}
		
		public function removeItem(item:*):void
		{
			var len:int = source.length;
			
			for (var i:int = 0; i < len; i++)
				if (source[i] == item)
				{
					source[i] = NULL;
					break;
				}
		}
		
		public function removeAll():void
		{
			source.length = 0;
		}
	
	}

}