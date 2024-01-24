/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.statistics
{
	import constants.GamePlayConstants;
	import controllers.StatisticsController;
	import flash.events.Event;
	import nslib.controls.ButtonBar;
	import nslib.controls.CategoryChart;
	import nslib.controls.ChartBase;
	import nslib.controls.events.ButtonBarEvent;
	import nslib.controls.LineChart;
	import panels.PanelBase;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class StatisticsPanel extends PanelBase
	{
		public static const CLOSE_CLICKED:String = "closeClicked";
		
		/////////////////
		
		private var overallChart:CategoryChart = new CategoryChart();
		
		/////
		
		private var moneyChart:LineChart = new LineChart();
		
		private var zeroUnityChart:LineChart = new LineChart();
		
		private var userTowerAccumulationChart:LineChart = new LineChart();
		
		private var waveDifficultyChart:LineChart = new LineChart();
		
		//////////
		
		private var pageButtonBar:ButtonBar = new ButtonBar();
		
		private var charts:Array = null;
		
		//////////////////
		
		public function StatisticsPanel()
		{
			construct();
		}
		
		//////////////////
		
		private function construct():void
		{
			mouseEnabled = true;
			
			graphics.beginFill(0xF4F4F4);
			graphics.drawRect(0, 0, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			
			pageButtonBar.buttonClass = PageButton;
			pageButtonBar.dataProvider = [{label: "Overall"}, {label: "Money"}, {label: "Other"}, {label: "Towers"}, {label: "Diffic"}, {label: "Close"}];
			pageButtonBar.x = 30;
			pageButtonBar.y = GamePlayConstants.STAGE_HEIGHT - 30;
			
			overallChart.chartWidth = GamePlayConstants.STAGE_WIDTH - 110;
			overallChart.chartHeight = GamePlayConstants.STAGE_HEIGHT - 70;
			overallChart.x = 100;
			overallChart.y = GamePlayConstants.STAGE_HEIGHT - 60;
			
			configureLineChart(moneyChart);
			configureLineChart(zeroUnityChart);
			configureLineChart(userTowerAccumulationChart);
			configureLineChart(waveDifficultyChart);
			
			addChild(pageButtonBar);
			addChild(overallChart);
			addChild(moneyChart);
			addChild(zeroUnityChart);
			addChild(userTowerAccumulationChart);
			addChild(waveDifficultyChart);
			
			charts = [overallChart, moneyChart, zeroUnityChart, userTowerAccumulationChart, waveDifficultyChart];
		}
		
		private function configureLineChart(chart:LineChart):void
		{
			chart.chartWidth = GamePlayConstants.STAGE_WIDTH - 60;
			chart.chartHeight = GamePlayConstants.STAGE_HEIGHT - 70;
			chart.x = 50;
			chart.y = GamePlayConstants.STAGE_HEIGHT - 60;
			chart.visible = false;
		}
		
		override public function show():void
		{
			super.show();
			
			pageButtonBar.selectedIndex = 0;
			resetVisibility();
			overallChart.visible = true;
			
			applyDataOnShow();
			
			pageButtonBar.addEventListener(ButtonBarEvent.INDEX_CHANGED, pageButtonBar_indexChangedHandler);
		}
		
		override public function hide():void
		{
			super.hide();
			
			pageButtonBar.removeEventListener(ButtonBarEvent.INDEX_CHANGED, pageButtonBar_indexChangedHandler);
		}
		
		private function resetVisibility():void
		{
			for each (var chart:ChartBase in charts)
				chart.visible = false;
		}
		
		private function pageButtonBar_indexChangedHandler(event:ButtonBarEvent):void
		{
			resetVisibility();
			
			if (event.newIndex == (pageButtonBar.dataProvider.length - 1))
				dispatchEvent(new Event(CLOSE_CLICKED));
			else
				ChartBase(charts[event.newIndex]).visible = true;
		}
		
		private function applyDataOnShow():void
		{
			var statInfo:StatInfo = StatisticsController.getStatInfoForLatestLevel();
			
			applyStatInfo(statInfo);
		}
		
		public function applyStatInfo(statInfo:StatInfo):void
		{
			overallChart.dataProvider = statInfo.overallStatistics;
			moneyChart.dataProvider = statInfo.moneyStatistics;
			
			var zeroUnityData:Array = statInfo.passDepthStatistics;
			zeroUnityData = zeroUnityData.concat(statInfo.userOccupationStatistics);
			zeroUnityChart.dataProvider = zeroUnityData;
			
			userTowerAccumulationChart.dataProvider = statInfo.userTowerAccumulationStatistics;
			
			waveDifficultyChart.dataProvider = statInfo.waveDifficultyStatistics;
		}
	}

}