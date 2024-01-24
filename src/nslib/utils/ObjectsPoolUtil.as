/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	import flash.utils.getQualifiedClassName;
	
	public class ObjectsPoolUtil
	{
		private static var hash:Object = {};
		
		public static function get profile():String
		{
			var result:String = "Objects Pool: \n";
			
			for (var id:String in hash)
			{
				var bundle:PoolBundle = hash[id];
				var array:Array = id.split("::");
				var className:String = array[array.length - 1];
				result += "Class: " + className + ", used: " + bundle.getNumberOfUsedObjects() + ", free: " + bundle.getNumberOfFreeObjects() + "\n";
			}
			
			return result;
		}
		
		// Prepares instances for faster access in the future.
		public static function prepareInstances(numInstances:int, cls:Class, parameters:Object = null, poolID:String = null):void
		{
			var instances:Array = [];
			
			for (var i:int = 0; i < numInstances; i++)
				instances.push(takeObject(cls, parameters, poolID));
			
			for each (var instance:*in instances)
				returnObject(instance);
		}
		
		public static function takeObjectOnlyIfExists(cls:Class, parameters:Object = null, poolID:String = null):*
		{
			var className:String = getQualifiedClassName(cls);
			var bundle:PoolBundle = hash[className];
			
			if (!bundle)
				return null;
			
			if (bundle.hasFreeObject(poolID))
				return takeObject(cls, parameters, poolID);
			
			return null;
		}
		
		public static function takeObject(cls:Class, parameters:Object = null, poolID:String = null):*
		{
			var className:String = getQualifiedClassName(cls);
			var bundle:PoolBundle = hash[className];
			
			var freeObject:* = null;
			
			if (bundle)
			{
				freeObject = bundle.getUnusedObject(poolID);
			}
			else
			{
				bundle = new PoolBundle();
				bundle.cls = cls;
				freeObject = bundle.getUnusedObject(poolID);
				
				hash[className] = bundle;
			}
			
			if (parameters)
				applyParameters(freeObject, parameters);
			
			return freeObject;
		}
		
		public static function returnObject(object:*, force:Boolean = false, cls:Class = null):void
		{
			var className:String = getQualifiedClassName(object);
			var bundle:PoolBundle = hash[className];
			
			if (bundle)
				bundle.returnObject(object);
			else if (force)
			{
				if (!cls)
					throw new Error("Cannot create a new bundle without the Class specified");
				
				bundle = new PoolBundle();
				bundle.cls = cls;
				bundle.returnObject(object);
				
				hash[className] = bundle;
			}
		}
		
		private static function applyParameters(object:*, parameters:Object):void
		{
			for (var id:String in parameters)
			{
				object[id] = parameters[id];
			}
		}
		
		public static function clear():void
		{
			hash = {};
		}
	}
}
import nslib.core.IReusable;

class PoolBundle
{
	public static const NULL:Object = {};
	
	public var cls:Class;
	
	private var usedObjects:Array = [];
	
	private var freeObjects:Array = [];
	
	public function PoolBundle()
	{
	}
	
	public function getUnusedObject(poolID:String = null):*
	{
		var freeObject:* = findAndTakeFreeObject(poolID);
		
		if (freeObject == null)
		{
			freeObject = new cls();
			
			// assign poolID
			if ((freeObject is IReusable) && poolID)
				IReusable(freeObject).poolID = poolID;
		}
		
		pushObjectToArray(usedObjects, freeObject);
		
		if (freeObject is IReusable)
			IReusable(freeObject).prepareForReuse();
		
		return freeObject;
	}
	
	public function returnObject(object:*):void
	{
		if (object is IReusable)
			IReusable(object).prepareForPooling();
		
		if (object)
		{
			removeObjectFromArray(usedObjects, object);
			pushObjectToArray(freeObjects, object);
		}
	}
	
	public function hasFreeObject(poolID:String = null):Boolean
	{
		var len:int = freeObjects.length;
		for (var i:int = 0; i < len; i++)
		{
			if (freeObjects[i] != NULL)
			{
				var freeObject:* = freeObjects[i];
				
				// filtering by poolID
				if (poolID && (freeObject is IReusable) && IReusable(freeObject).poolID != poolID)
					continue;
				
				return true;
			}
		}
		
		return false;
	}
	
	private function findAndTakeFreeObject(poolID:String = null):*
	{
		var len:int = freeObjects.length;
		for (var i:int = 0; i < len; i++)
		{
			if (freeObjects[i] != NULL)
			{
				var freeObject:* = freeObjects[i];
				
				// filtering by poolID
				if (poolID && (freeObject is IReusable) && IReusable(freeObject).poolID != poolID)
					continue;
				
				freeObjects[i] = NULL;
				return freeObject;
			}
		}
		
		return null;
	}
	
	private function arrayContainsObject(array:Array, object:*):Boolean
	{
		return array.lastIndexOf(object) != -1;
	}
	
	private function pushObjectToArray(array:Array, object:*):void
	{
		var len:int = array.length;
		if (len == 0)
		{
			array.push(object);
			return;
		}
		
		if (arrayContainsObject(array, object))
			return;
		
		for (var i:int = 0; i < len; i++)
		{
			if (array[i] == NULL)
			{
				array[i] = object;
				return;
			}
		}
		
		array.push(object);
	}
	
	private function removeObjectFromArray(array:Array, object:*):void
	{
		var len:int = array.length;
		if (len == 0)
			return;
		
		for (var i:int = 0; i < len; i++)
		{
			if (array[i] == object)
			{
				array[i] = NULL;
				return;
			}
		}
	}
	
	public function getNumberOfFreeObjects():int
	{
		var result:int = 0;
		var len:int = freeObjects.length;
		if (len == 0)
			return result;
		
		for (var i:int = 0; i < len; i++)
			if (freeObjects[i] != NULL)
				result++;
		
		return result;
	}
	
	public function getNumberOfUsedObjects():int
	{
		var result:int = 0;
		var len:int = usedObjects.length;
		if (len == 0)
			return result;
		
		for (var i:int = 0; i < len; i++)
			if (usedObjects[i] != NULL)
				result++;
		
		return result;
	}
}
