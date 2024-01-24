/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import nslib.sound.event.SoundManagerEvent;
	import nslib.utils.ArrayList;
	
	/**
	 * ...
	 * @author Alex
	 */
	public class SoundManager extends EventDispatcher
	{
		public var path:String = "C:/sounds/";
		public var ext:String = ".mp3";
		public var allowSimultaniousPlaying:Boolean = false;
		public var maxPlayDuration:Number = NaN;
		
		///////////////////////////////////////////////
		
		public function SoundManager()
		{
		}
		
		///////////////////////////////////////////////
		
		private var lastChannel:SoundChannel = null;
		
		public function get soundPlayPosition():Number
		{
			return lastChannel ? lastChannel.position : 0;
		}
		
		///////////
		
		private var playingSoundsCount:int = 0;
		
		public function get isPlaying():Boolean
		{
			return (soundStack.length > 0) || (playingSoundsCount > 0);
		}
		
		///////////////////////////////////////////////
		
		public function playSoundEmbedded(sound:Class, volume:Number = 1):void
		{
			if (allowSimultaniousPlaying)
				playSoundIndependently(sound, volume)
			//else
			//	loadSoundForStack(sound, volume);
		}
		
		public function playSound(soundName:String, volume:Number = 1):void
		{
			if (allowSimultaniousPlaying)
				playSoundIndependently(soundName, volume)
			else
				loadSoundForStack(soundName, volume);
		}
		
		public function sayPhrase(phrase:String, volume:Number = 1):void
		{
			var array:Array = smartSplit(phrase);
			
			for each (var s:String in array)
				loadSoundForStack(s, volume);
		}
		
		private function smartSplit(s:String):Array
		{
			var line:String = "";
			var readingNumber:Boolean = false;
			
			var array:Array = s.split("");
			var result:Array = [];
			var tempArray:Array;
			var tempLine:String;
			
			for each (var letter:String in array)
			{
				if (isNumber(letter))
				{
					if (!readingNumber)
					{
						readingNumber = true;
						line = "";
					}
					line += letter;
				}
				else
				{
					if (line.length > 0)
					{
						tempArray = smartNumberSplit(line);
						for each (tempLine in tempArray)
							result.push(tempLine);
						line = "";
					}
					
					result.push(filter(letter));
					
					readingNumber = false;
				}
			}
			
			if (line.length > 0)
			{
				tempArray = smartNumberSplit(line);
				for each (tempLine in tempArray)
					result.push(tempLine);
				line = "";
			}
			
			return result;
		}
		
		private function smartNumberSplit(s:String):Array
		{
			
			var n:Number = Number(s);
			var result:Array = [];
			
			if ((n - Math.floor(n)) == 0)
			{
				return readInt(n);
			}
			else
			{
				
				var pointPos:int = s.indexOf(".");
				
				var beforePoint:Array = readInt(int(n));
				var afterPoint:Array = readInt(Math.round((n - Math.floor(n)) * Math.pow(10, (s.length - pointPos - 1))), (s.length - pointPos - 1));
				
				var line:String = "";
				
				for each (line in beforePoint)
				{
					result.push(line);
				}
				result.push("whole");
				
				for each (line in afterPoint)
				{
					result.push(line);
				}
				if (afterPoint.length == 1)
					result.push("tenth");
				
				if (afterPoint.length == 2)
					result.push("hundredth");
				
				if (afterPoint.length == 3)
					result.push("thousandth");
			}
			
			return result;
		
		}
		
		private function readInt(n:int, digits:int = 0):Array
		{
			if (n == 0)
				return ["" + 0];
			
			var result:Array = [];
			
			var a:int = n / 100;
			var b:int = (n - a * 100) / 10;
			var c:int = (n - a * 100 - b * 10);
			
			if ((n - a * 100) < 20)
			{
				c = (n - a * 100);
				b = 0;
			}
			
			if (a > 0)
				result.push("" + a * 100);
			else if (digits == 3)
				result.push("");
			
			if (b > 0)
				result.push("" + b * 10);
			else if (digits > 1)
				result.push("");
			
			if (c > 0)
				result.push("" + c);
			
			return result;
		}
		
		private function isNumber(s:String):Boolean
		{
			switch (s)
			{
				case "0": 
					return true;
				case "1": 
					return true;
				case "2": 
					return true;
				case "3": 
					return true;
				case "4": 
					return true;
				case "5": 
					return true;
				case "6": 
					return true;
				case "7": 
					return true;
				case "8": 
					return true;
				case "9": 
					return true;
				case ".": 
					return true;
				case ",": 
					return true;
			}
			
			return false;
		}
		
		private function filter(s:String):String
		{
			switch (s)
			{
				case "*": 
					return "mul";
				case "/": 
					return "div";
				case ":": 
					return "div";
				case "^": 
					return "powN";
				case "(": 
					return "bra";
				case ")": 
					return "ket";
			}
			return s;
		}
		
		/////////////////////////////////////////
		// Sequential playing
		/////////////////////////////////////////
		
		private var soundStack:ArrayList = new ArrayList();
		
		private var loadedHash:Array = [];
		
		private var volumeHash:Array = [];
		
		private var avaiForNext:Boolean = true;
		
		private var currentPosition:int = 0;
		
		private var delayTimer:Timer = new Timer(100, 1);
		
		private function loadSoundForStack(soundName:String, volume:Number):void
		{
			var sound:Sound = new Sound();
			sound.addEventListener(Event.COMPLETE, loadComplete);
			sound.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			sound.load(new URLRequest(path + soundName + ext));
			
			soundStack.addItem(sound);
			volumeHash["" + (soundStack.length - 1)] = volume;
		}
		
		private function loadComplete(event:Event):void
		{
			var localSound:Sound = event.target as Sound;
			localSound.removeEventListener(Event.COMPLETE, loadComplete);
			localSound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
			loadedHash[soundStack.getItemIndex(localSound)] = "loaded";
			
			checkStack();
		}
		
		public function checkStack():void
		{
			if (avaiForNext && loadedHash["" + currentPosition])
			{
				avaiForNext = false;
				
				var soundChannel:SoundChannel = Sound(soundStack.getItemAt(currentPosition)).play();
				lastChannel = soundChannel;
				
				var st:SoundTransform = new SoundTransform();
				st.volume = volumeHash["" + currentPosition];
				
				soundChannel.soundTransform = st;
				
				if (isNaN(maxPlayDuration))
					soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
				else
				{
					delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, delayTimer_timerCompleteHandler);
					delayTimer.delay = maxPlayDuration;
					delayTimer.reset();
					delayTimer.start();
				}
				
				soundStack.setItemAt(null, currentPosition);
				
				currentPosition++;
			}
			else if (avaiForNext && currentPosition >= soundStack.length)
			{
				soundStack.removeAll();
				currentPosition = 0;
				loadedHash = [];
				volumeHash = [];
				
				dispatchEvent(new SoundManagerEvent(SoundManagerEvent.ALL_SOUNDS_FINISHED_PLAYING));
			}
		}
		
		private function delayTimer_timerCompleteHandler(event:TimerEvent):void
		{
			delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, delayTimer_timerCompleteHandler);
			avaiForNext = true;
			checkStack();
		}
		
		private function soundCompleteListener(event:Event):void
		{
			var soundChannel:SoundChannel = event.target as SoundChannel;
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteListener);
			avaiForNext = true;
			checkStack();
		}
		
		private function errorHandler(error:IOErrorEvent):void
		{
			var localSound:Sound = error.target as Sound;
			localSound.removeEventListener(Event.COMPLETE, loadComplete);
			localSound.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			avaiForNext = true;
			checkStack();
			
			trace("Sound file not found");
		}
		
		/////////////////////////////////////////
		// Simultanious playing
		/////////////////////////////////////////
		
		private function playSoundIndependently(soundObject:*, volume:Number):void
		{
			var indepSound:Sound;
			
			if (soundObject is String)
			{
				indepSound = new AdvancedSound();
				indepSound.addEventListener(Event.COMPLETE, indepSound_loadComplete);
				indepSound.addEventListener(IOErrorEvent.IO_ERROR, indepSound_errorHandler);
				indepSound.load(new URLRequest(path + String(soundObject) + ext));
				
				volumeHash[AdvancedSound(indepSound).uniqueKey] = volume;
			}
			else if (soundObject is Class)
			{
				indepSound = new soundObject();
				playingSoundsCount++;
				var indepSoundChannel:SoundChannel = indepSound.play();
				lastChannel = indepSoundChannel;
				indepSoundChannel.addEventListener(Event.SOUND_COMPLETE, indep_soundCompleteListener);
				
				indepSoundChannel.soundTransform = new SoundTransform(volume);
			}
		}
		
		private function indepSound_loadComplete(event:Event):void
		{
			var indepSound:AdvancedSound = event.target as AdvancedSound;
			indepSound.removeEventListener(Event.COMPLETE, indepSound_loadComplete);
			indepSound.removeEventListener(IOErrorEvent.IO_ERROR, indepSound_errorHandler);
			
			playingSoundsCount++;
			var indepSoundChannel:SoundChannel = indepSound.play();
			lastChannel = indepSoundChannel;
			indepSoundChannel.addEventListener(Event.SOUND_COMPLETE, indep_soundCompleteListener);
			indepSoundChannel.soundTransform = new SoundTransform(volumeHash[indepSound.uniqueKey]);
		}
		
		private function indep_soundCompleteListener(event:Event):void
		{
			var indepSoundChannel:SoundChannel = event.target as SoundChannel;
			indepSoundChannel.removeEventListener(Event.SOUND_COMPLETE, indep_soundCompleteListener);
			
			playingSoundsCount = Math.max(--playingSoundsCount, 0);
			
			if (playingSoundsCount == 0)
				dispatchEvent(new SoundManagerEvent(SoundManagerEvent.ALL_SOUNDS_FINISHED_PLAYING));
		}
		
		private function indepSound_errorHandler(error:IOErrorEvent):void
		{
			var indepSound:Sound = error.target as Sound;
			indepSound.removeEventListener(Event.COMPLETE, indepSound_loadComplete);
			indepSound.removeEventListener(IOErrorEvent.IO_ERROR, indepSound_errorHandler);
			playingSoundsCount = Math.max(--playingSoundsCount, 0);
			
			if (playingSoundsCount == 0)
				dispatchEvent(new SoundManagerEvent(SoundManagerEvent.ALL_SOUNDS_FINISHED_PLAYING));
			
			trace("Sound file not found");
		}
	
	}

}