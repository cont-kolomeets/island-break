/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package config
{
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class NavigateConfig
	{
		//////////////////
		
		public static const STEP_INITIAL:String = "initial";
		
		public static const STEP_SHOW_CREDITS_PANEL:String = "showCreditsPanel";
		
		public static const STEP_SHOW_SLOTS_PANEL:String = "showSlotsPanel";
		
		public static const STEP_SHOW_LEVELS_MAP_PANEL:String = "showLevelsMapPanel";
		
		public static const STEP_SHOW_LEVEL_INFO_PANEL:String = "showLevelInfoPanel";
		
		public static const STEP_SHOW_GAME_STAGE:String = "showGameStage";
		
		public static const STEP_SHOW_DEVELOPMENT_CENTER:String = "showDevelopmentCenter";
		
		public static const STEP_SHOW_ACHIEVEMENTS_CENTER:String = "showAchievementsCenter";
		
		public static const STEP_SHOW_ENCYCLOPEDIA_START_PAGE:String = "showEncyclopediaStartPage";
		
		///////////////////
		
		public static const navigationConfig:XML =
			
			<steps>
				<step id="0" name="initial">
					<actions>
						<action panelID="introPanel" effect="show" addHandlers="startClicked;creditsClicked"/>
					</actions>
					<events>
						<event type="startClicked" toStep="showSlotsPanel"/>
						<event type="creditsClicked" toStep="showCreditsPanel"/>
					</events>
				</step>
				
				<step id="1" name="showCreditsPanel">
					<actions>
						<action panelID="introPanel" effect="show"/>
						<action panelID="creditsPanel" effect="show" addHandlers="closeClicked"/>
					</actions>
					<events>
						<event type="closeClicked" toStep="initial"/>
					</events>
				</step>
				
				<step id="2" name="showSlotsPanel">
					<actions>
						<action panelID="introPanel" effect="show"/>
						<action panelID="slotsPanel" effect="show" addHandlers="selected;closeClicked"/>
					</actions>
					<events>
						<event type="selected" toStep="showLevelsMapPanel"/>
						<event type="closeClicked" toStep="initial"/>
					</events>
				</step>
				
				<step id="3" name="showLevelsMapPanel">
					<actions>
						<action panelID="levelsMapPanel" effect="show" addHandlers="backSelected;encyclopediaSelected;devCenterSelected;achievementsSelected;selected"/>
					</actions>
					<events>
						<event type="backSelected" toStep="showSlotsPanel"/>
						<event type="encyclopediaSelected" toStep="showEncyclopediaStartPage"/>
						<event type="devCenterSelected" toStep="showDevelopmentCenter"/>
						<event type="achievementsSelected" toStep="showAchievementsCenter"/>
						<event type="selected" toStep="showLevelInfoPanel"/>
					</events>
				</step>
				
				<step id="4" name="showLevelInfoPanel">
					<actions>
						<action panelID="levelsMapPanel" effect="show"/>
						<action panelID="levelInfoPanel" effect="show" addHandlers="toBattleClicked;closeClicked"/>
					</actions>
					<events>
						<event type="toBattleClicked" toStep="showGameStage"/>
						<event type="closeClicked" toStep="showLevelsMapPanel"/>
					</events>
				</step>
				
				
				<step id="5" name="showGameStage">
					<actions>
						<action panelID="gameStage" effect="show"/>
					</actions>
					<events>
						<event type="none" toStep="none"/>
						<event type="none" toStep="none"/>
					</events>
				</step>
				
				
				<step id="6" name="showDevelopmentCenter">
					<actions>
						<action panelID="devCenterPanel" effect="show" addHandlers="doneClicked;cancelClicked"/>
					</actions>
					<events>
						<event type="doneClicked" toStep="showLevelsMapPanel"/>
						<event type="cancelClicked" toStep="showLevelsMapPanel"/>
					</events>
				</step>
				
				<step id="7" name="showAchievementsCenter">
					<actions>
						<action panelID="achievementsPanel" effect="show" addHandlers="backClicked"/>
					</actions>
					<events>
						<event type="backClicked" toStep="showLevelsMapPanel"/>
					</events>
				</step>
				
				<step id="8" name="showEncyclopediaStartPage">
					<actions>
						<action panelID="encyclopediaPanel" effect="show" addHandlers="backClicked"/>
					</actions>
					<events>
						<event type="backClicked" toStep="showLevelsMapPanel"/>
					</events>
				</step>
			
			</steps>;
	
	}

}