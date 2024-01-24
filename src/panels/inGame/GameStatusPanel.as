/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package panels.inGame
{
	import flash.display.Bitmap;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.FontDescriptor;
	import supportClasses.resources.FontResources;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class GameStatusPanel extends NSSprite
	{
		//////////
		
		[Embed(source="F:/Island Defence/media/images/panels/game status menu/menu base.png")]
		private static var menuBaseImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game status menu/lives.png")]
		private static var livesImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game status menu/money.png")]
		private static var moneyImage:Class;
		
		[Embed(source="F:/Island Defence/media/images/panels/game status menu/wave.png")]
		private static var waveImage:Class;
		
		///////////
		
		private var livesLabel:CustomTextField;
		
		private var moneyLabel:CustomTextField;
		
		private var waveLabel:CustomTextField;
		
		///////////
		
		public function GameStatusPanel()
		{
			construct();
		}
		
		///////////
		
		public function set lives(value:int):void
		{
			livesLabel.text = "" + value;
		}
		
		public function set money(value:int):void
		{
			moneyLabel.text = "" + value;
		}
		
		private var _currentWave:int = 0;
		
		private var _totalWaves:int = 0;
		
		public function set currentWave(value:int):void
		{
			_currentWave = value;
			updateWavesLabel();
		}
		
		public function set totalWaves(value:int):void
		{
			_totalWaves = value;
			updateWavesLabel();
		}
		
		private function updateWavesLabel():void
		{
			// convert the zero-based current wave value to a user-friendly one
			waveLabel.text = "wave " + (_currentWave + 1) + "/" + _totalWaves;
		}
		
		///////////
		
		private function construct():void
		{
			addChild(new menuBaseImage() as Bitmap);
			
			var lives:Bitmap = new livesImage() as Bitmap;
			var money:Bitmap = new moneyImage() as Bitmap;
			var wave:Bitmap = new waveImage() as Bitmap;
			
			lives.x = 15;
			lives.y = 6;
			
			money.x = 65;
			money.y = 6;
			
			wave.x = 22;
			wave.y = 27;
			
			addChild(lives);
			addChild(money);
			addChild(wave);
			
			livesLabel = new CustomTextField("10", new FontDescriptor(15, 0xFFFFFF, FontResources.BOMBARD));
			moneyLabel = new CustomTextField("50000", new FontDescriptor(15, 0xFFFFFF, FontResources.BOMBARD));
			waveLabel = new CustomTextField("wave 1/15", new FontDescriptor(15, 0xFFFFFF, FontResources.BOMBARD));
			
			livesLabel.x = 40;
			livesLabel.y = 9;
			
			moneyLabel.x = 90;
			moneyLabel.y = 9;
			
			waveLabel.x = 60;
			waveLabel.y = 35;
			
			addChild(livesLabel);
			addChild(moneyLabel);
			addChild(waveLabel);
		}
	}

}