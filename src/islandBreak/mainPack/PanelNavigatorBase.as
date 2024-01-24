/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package islandBreak.mainPack
{
	import config.NavigateConfig;
	import flash.events.Event;
	import nslib.controls.NSSprite;
	import panels.PanelBase;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PanelNavigatorBase extends NSSprite
	{
		//////////////////////////////////////
		
		private var panelsHash:Object = {};
		
		private var stepsHash:Object = {};
		
		/////////////////////////
		
		public function PanelNavigator()
		{
	
			registerPanels();
			parseConfig();
		}
		
		//////////////////////////////////////
		
		protected function registerPanels():void
		{
		}
		
		private function registerPanel(panel:PanelBase, panelID:String):void
		{
			panel.panelID = panelID;
			panelsHash[panelID] = panel;
		}
		
		private function parseConfig():void
		{
			var steps:XMLList = NavigateConfig.navigationConfig.step;
			
			for each (var step:XML in steps)
			{
				var stepInfo:StepInfo = new StepInfo();
				stepInfo.id = String(step.@id);
				stepInfo.name = String(step.@name);
				
				if (step.actions != undefined)
				{
					var actions:XMLList = step.actions.action;
					
					if (actions)
						for each (var action:XML in actions)
						{
							var actionInfo:ActionInfo = new ActionInfo();
							actionInfo.panelID = action.@panelID;
							actionInfo.effect = action.@effect;
							if (action.@addHandlers != undefined)
								actionInfo.addHandlers = String(action.@addHandlers).split(";");
							
							if (!stepInfo.actions)
								stepInfo.actions = [];
							
							stepInfo.actions.push(actionInfo);
						}
				}
				
				if (step.events != undefined)
				{
					var events:XMLList = step.events.event;
					
					if (events)
						for each (var event:XML in events)
						{
							var eventInfo:EventInfo = new EventInfo();
							eventInfo.type = event.@type;
							eventInfo.toStep = event.@toStep;
							
							if (!stepInfo.events)
								stepInfo.events = [];
							
							stepInfo.events.push(eventInfo);
						}
				}
				
				stepsHash[stepInfo.name] = stepInfo;
			}
		}
		
		private var currentStep:StepInfo = null;
		
		public function getCurrentStep():StepInfo
		{
			return currentStep;
		}
		
		public function startInitialStep():void
		{
			navigateToStepByName("initial");
		}
		
		private function navigateToStepByName(stepName:String):void
		{
			var stepInfo:StepInfo = stepsHash[stepName];
			if (stepInfo)
				navigateToStep(stepInfo);
		}
		
		private function navigateToStep(stepInfo:StepInfo):void
		{
			currentStep = stepInfo;
			
			// collecting panelIDs of panel to be shown
			// so we do not hide them in vain
			var panelsToShowHash:Object = {};
			var action:ActionInfo = null;
			
			if (stepInfo.actions)
				for each (action in stepInfo.actions)
					if (action.effect == "show")
						panelsToShowHash[action.panelID] = action.panelID;
			
			// collection panels to remove
			var panelsToRemove:Array = [];
			var panel:PanelBase = null;
			
			for (var i:int = 0; i < numChildren; i++)
			{
				panel = getChildAt(i) as PanelBase;
				if (panel)
				{
					// we need to remove listeners anyway
					panel.removeAllNavigationListeners();
					
					if (panelsToShowHash[panel.panelID] == undefined)
						panelsToRemove.push(panel);
				}
				
			}
			
			// removing panels
			for each (panel in panelsToRemove)
			{
				panel.removeAllNavigationListeners();
				panel.hide();
				removeChild(panel);
			}
			
			if (stepInfo.actions)
				for each (action in stepInfo.actions)
				{
					panel = panelsHash[action.panelID];
					
					if (action.effect == "show")
					{
						// do not need to add and show a panel if it's already displayed.
						if (!contains(panel))
						{
							addChild(panel);
							panel.show();
						}
						
						if (action.addHandlers)
							for each (var handlerType:String in action.addHandlers)
								panel.addEventListener(handlerType, universalHandler);
					}
				}
		}
		
		private function universalHandler(event:Event):void
		{
			if (currentStep.events)
				for each (var eventInfo:EventInfo in currentStep.events)
					if (event.type == eventInfo.type)
						navigateToStepByName(eventInfo.toStep);
		}

}

class StepInfo
{
	public var id:String = null;
	
	public var name:String = null;
	
	public var events:Array = null;
	
	public var actions:Array = null;
}

class ActionInfo
{
	public var panelID:String = null;
	
	public var effect:String = null;
	
	public var addHandlers:Array = null;
}

class EventInfo
{
	public var type:String = null;
	
	public var toStep:String = null;
}