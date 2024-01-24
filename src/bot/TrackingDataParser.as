/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package bot
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import tracker.TrackingMessages;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class TrackingDataParser extends EventDispatcher
	{
		public static const DATA_PARSED:String = "dataParsed";
		
		private var parsedData:Array = [];
		
		private var currentLevelIndex:int = 0;
		
		/////////
		
		public function TrackingDataParser()
		{
		
		}
		
		//////////
		
		public function getNextDataObject():TrackingActionInfo
		{
			if (parsedData.length == 0)
				return null;
			
			return parsedData.shift();
		}
		
		//////////
		
		private var fileRef:FileReference = new FileReference();
		
		public function parseDataFileForLevel(levelIndex:int):void
		{
			currentLevelIndex = levelIndex;
			parsedData.length = 0;
			
			fileRef.browse();
			
			fileRef.addEventListener(Event.SELECT, fileRef_selectHandler);
		}
		
		private function fileRef_selectHandler(event:Event):void
		{
			fileRef.removeEventListener(Event.SELECT, fileRef_selectHandler);
			
			fileRef.addEventListener(Event.COMPLETE, fileRef_completeHandler);
			fileRef.load();
		}
		
		private function fileRef_completeHandler(event:Event):void
		{
			fileRef.removeEventListener(Event.COMPLETE, fileRef_completeHandler);
			
			var loadedData:String = fileRef.data.toString();
			tryParseLoadedString(loadedData);
			
			dispatchEvent(new Event(DATA_PARSED));
		}
		
		private function tryParseLoadedString(loadedData:String):void
		{
			var lines:Array = loadedData.split("\n");
			// remove the description line
			lines.shift();
			
			var levelFound:Boolean = false;
			var startingTime:int = 0;
			
			for each (var line:String in lines)
			{
				var infoObj:TrackingActionInfo = parseLine(line, startingTime);
				if (!infoObj)
					continue;
				
				if (infoObj.action == TrackingMessages.BEGIN_LEVEL && infoObj.level == currentLevelIndex)
				{
					if (levelFound)
						break;
					
					levelFound = true;
					startingTime = infoObj.time;
				}
				// filter for current level
				if (levelFound && infoObj.level == currentLevelIndex)
					parsedData.push(infoObj);
			}
		}
		
		private function parseLine(line:String, startingTime:int):TrackingActionInfo
		{
			if (!line || line.length == 0)
				return null;
			
			var infoObj:TrackingActionInfo = new TrackingActionInfo();
			
			var parts:Array = line.split(",");
			infoObj.time = parseTime(parts[3]) - startingTime;
			infoObj.action = parts[4];
			infoObj.subaction = parts[5];
			infoObj.score = parts[6];
			infoObj.level = parts[7];
			
			var message:String = "";
			for (var i:int = 9; i < parts.length; i++)
				message += parts[i] + ",";
			
			// remove "",
			if (message.lastIndexOf("\"") != -1)
				message = message.substr(1, message.length - 3);
			
			// and parse message
			infoObj.message = message;
			
			var messageParts:Array = infoObj.message.split(":");
			infoObj.messageBase = messageParts[0];
			
			if (messageParts[1])
				infoObj.messageParameters = String(messageParts[1]).split(",");
			
			return infoObj;
		}
		
		// from 0:00:45 to milliseconds
		private function parseTime(time:String):int
		{
			var parts:Array = time.split(":");
			
			return 1000 * (int(parts[0]) * 3600 + int(parts[1]) * 60 + int(parts[2]));
		}
	}

}