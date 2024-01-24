/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	[Event(name="loadComplete", type="flash.events.Event")]
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class FileHelper extends EventDispatcher
	{
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		public var loadedData:String;
		private var fileReference:FileReference;
		private var lastFileName:String = "project.uml";
		private var busy:Boolean = false;
		
		public function FileHelper()
		{
		}
		
		public function saveToFileAfterBrowsing(data:*):void
		{
			fileReference = new FileReference();
			fileReference.save(data, lastFileName);
			fileReference.addEventListener(Event.COMPLETE, onComplete);
			fileReference.addEventListener(Event.CANCEL, onCancel);
			busy = true;
		}
		
		public function isBusy():Boolean
		{
			return busy;
		}
		
		public function loadFileAfterBrowsing(description:String = "", extensions:String = "*"):void
		{
			var fd:String = description;
			var fe:String = extensions;
			var ff:FileFilter = new FileFilter(fd, fe);
			
			fileReference = new FileReference();
			fileReference.addEventListener(Event.SELECT, onFileSelect);
			fileReference.addEventListener(Event.CANCEL, onCancel);
			fileReference.addEventListener(Event.COMPLETE, onFileLoadComplete);
			fileReference.browse([ff]);
			
			busy = true;
		}
		
		private function onCancel(event:Event):void
		{
			fileReference.removeEventListener(Event.CANCEL, onCancel);
			busy = false;
		}
		
		private function onComplete(event:Event):void
		{
			fileReference.removeEventListener(Event.COMPLETE, onComplete);
			lastFileName = fileReference.name;
			busy = false;
		}
		
		private function onFileSelect(event:Event):void
		{
			fileReference.load();
			fileReference.removeEventListener(Event.SELECT, onFileSelect);
			busy = false;
		}
		
		private function onFileLoadComplete(event:Event):void
		{
			fileReference.removeEventListener(Event.COMPLETE, onFileLoadComplete);
			
			var ba:ByteArray = event.currentTarget.data as ByteArray;
			loadedData = ba.toString();
			lastFileName = fileReference.name;
			
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
		public function readFromFileDirectly(path:String):void
		{
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, directLoader_completeHandler);
			loader.load(new URLRequest(path));
		}
		
		private function directLoader_completeHandler(event:Event):void
		{
			loadedData = event.currentTarget.data;
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
	}

}