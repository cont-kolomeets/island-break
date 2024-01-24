/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package
{
	import constants.GamePlayConstants;
	import controllers.SoundController;
	import controllers.WaveGenerator;
	import islandBreak.controllers.WeaponController;
	import flash.display.Shape;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mainPack.GameSettings;
	import nslib.animation.engines.AnimationEngine;
	import nslib.controls.Button;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.FPSMonitor;
	import nslib.controls.MouseCursorPositionMonitor;
	import nslib.controls.NSSprite;
	import nslib.controls.supportClasses.ToolTipService;
	import nslib.core.Globals;
	import nslib.core.NSFramework;
	import nslib.utils.GlobalTrace;
	import nslib.utils.GlobalTraceField;
	import panels.inGame.GameStage;
	import supportClasses.resources.AchievementResources;
	import supportClasses.resources.SoundResources;
	import supportClasses.resources.TipResources;
	import supportClasses.resources.WeaponResources;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class TestClass extends NSSprite
	{
		//[Embed(source="F:/Island Defence/media/someSWF.swf")]
		//private static var someSWF:Class;
		
		private var button1:Button = new Button("Start");
		private var button2:Button = new Button("Stop");
		
		private var globalTraceField:GlobalTraceField = new GlobalTraceField();
		
		public function TestClass()
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			init();
		}
		
		private function init():void
		{
			//addChild(new TheMiner());
			
			NSFramework.initialize(this);
			Globals.toolTipLayer = new NSSprite();
			ToolTipService.toolTipLayer = Globals.toolTipLayer;
			
			// stage settings
			stage.frameRate = GamePlayConstants.GAME_NORMAL_FRAME_RATE;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// initialize configs
			GameSettings.intialize();
			WeaponResources.initialize();
			AchievementResources.initialize();
			TipResources.initialize();
			WaveGenerator.initialize();
			
			GameSettings.stage = stage;
			
			button1.x = 50;
			button1.y = 250;
			button1.buttonMode = true;
			button1.addEventListener(ButtonEvent.BUTTON_CLICK, start);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			
			addChild(button1);
			
			button2.x = 50;
			button2.y = 300;
			button2.buttonMode = true;
			button2.addEventListener(ButtonEvent.BUTTON_CLICK, stop);
			
			addChild(button2);
			
			constructAdditionalThings();
		}
		
		private var testSprite:NSSprite = new NSSprite();
		
		private var parts:Array = [];
		
		private function frameListener(event:Event):void
		{
		
		}
		
		private function start(event:ButtonEvent):void
		{
		
		}
		
		private function stage_mouseMoveHandler(event:MouseEvent):void
		{
			SoundController.instance.playSound(SoundResources.SOUND_BUTTON_HOVER);
		}
		
		private function stop(event:ButtonEvent):void
		{
		}
		
		private function constructAdditionalThings():void
		{
			GlobalTrace.field = globalTraceField;
			GlobalTrace.mainApp = this;
			
			var cursorMonitor:MouseCursorPositionMonitor = new MouseCursorPositionMonitor();
			cursorMonitor.y = stage.stageHeight - 20;
			cursorMonitor.color = 0xDDDDDD;
			//addChild(cursorMonitor);
			
			var fpsMonitor:FPSMonitor = new FPSMonitor();
			fpsMonitor.y = stage.stageHeight - 40;
			fpsMonitor.showFPS = true;
			//addChild(fpsMonitor);
			
			globalTraceField.x = 50; // stage.stageWidth - 400;
			globalTraceField.y = 0; //stage.stageHeight - 300;
			addChild(globalTraceField);
		
			//GlobalTrace.monitorProperty(ObjectsPoolUtil, "profile");
		}
	
	}

}