/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package map
{
	import constants.GamePlayConstants;
	import constants.MapConstants;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import nslib.AIPack.grid.GridArray;
	import nslib.AIPack.grid.Location;
	import nslib.AIPack.grid.LocationConstants;
	import nslib.controls.CustomTextField;
	import nslib.controls.NSSprite;
	import nslib.utils.AlignUtil;
	import nslib.utils.FontDescriptor;
	import supportClasses.mapObjects.BirdFlightProgram;
	import supportClasses.resources.FontResources;
	import weapons.objects.Bridge;
	import weapons.objects.OneWayTeleport;
	import weapons.objects.Teleport;
	import weapons.objects.TrafficLight;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class Map
	{
		public var width:int = 0;
		
		public var height:int = 0;
		
		public var numberOfPaths:int = 1;
		
		// the angle of the gun in the resting position for user units.
		// by default this value is NaN and the resting angle is the same as that of the body.
		public var gunRestAngle:Number = NaN;
		
		// for maps with birds there should be a flight program specified.
		public var birdsFlightProgram:BirdFlightProgram = null;
		
		// if true enemies will appear as if flying out of a teleport
		public var enemyUnitsAppearFromPortal:Boolean = false;
		
		// if true enemies will disappear as if flying into a teleport
		public var enemyUnitsDisappearToPortal:Boolean = false;
		
		// images
		protected var levelImageClass:Class = null;
		
		protected var weaponPadClass:Class = null;
		
		protected var defaultObstacleClass:Class = null;
		
		// parameters
		protected var description:Array = null;
		
		protected var enemyEntrancePoints:Array = [];
		
		protected var enemyExitPoints:Array = [];
		
		protected var enemyEntranceLocations:Array = [];
		
		protected var enemyExitLocations:Array = [];
		
		protected var enemyInitialRotations:Array = [];
		
		protected var waveIndicatorPoints:Array = [];
		
		protected var waveIndicatorRotations:Array = [];
		
		protected var enemyEnterTeleports:Array = [];
		
		protected var enemyExitTeleports:Array = [];
		
		public var grid:GridArray = new GridArray();
		
		protected var bitmapData:BitmapData;
		
		//////////////////////////
		
		public function Map()
		{
			grid.gridResolution = MapConstants.MAP_GRID_RESOLUTION;
			grid.gridOffsetX = -grid.gridResolution / 4;
			grid.gridOffsetY = 0;
		}
		
		//////////////////////////
		
		protected function createDescription():void
		{
			// must be implemented in subclasses
		}
		
		public function getMapDescription():Array
		{
			return description;
		}
		
		public function placeAnimatedPartsGround(workingLayer:DisplayObjectContainer):void
		{
			// must be implemented in subclasses
		}
		
		public function placeAnimatedPartsSky(workingLayer:DisplayObjectContainer):void
		{
			// must be implemented in subclasses
		}
		
		public function getEnemyEntranceLocationForPathAt(pathIndex:int):Location
		{
			return enemyEntranceLocations[pathIndex];
		}
		
		public function getEnemyExitLocationForPathAt(pathIndex:int):Location
		{
			return enemyExitLocations[pathIndex];
		}
		
		public function getEnemyEntrancePointForPathAt(pathIndex:int):Point
		{
			return enemyEntrancePoints[pathIndex];
		}
		
		public function getEnemyExitPointForPathAt(pathIndex:int):Point
		{
			return enemyExitPoints[pathIndex];
		}
		
		public function getEnemyInitialRotationForPathAt(pathIndex:int):Number
		{
			return enemyInitialRotations[pathIndex];
		}
		
		public function getWaveIndicatorPointForPathAt(pathIndex:int):Point
		{
			return waveIndicatorPoints[pathIndex];
		}
		
		public function getWaveIndicatorRotationForPathAt(pathIndex:int):Number
		{
			return waveIndicatorRotations[pathIndex];
		}
		
		//////// generate objects on the map
		
		public function generateDamagableObjects():Array
		{
			// must be implemented in subclasses
			return [];
		}
		
		////////// constructing map
		
		protected function constructMap():void
		{
			createDescription();
			
			width = GamePlayConstants.STAGE_WIDTH;
			height = GamePlayConstants.STAGE_HEIGHT;
			
			constructGridForDescription();
		}
		
		private function constructGridForDescription():void
		{
			// reset parameters
			enemyEntrancePoints.length = 0;
			enemyExitPoints.length = 0;
			enemyEntranceLocations.length = 0;
			enemyExitLocations.length = 0;
			enemyInitialRotations.length = 0;
			waveIndicatorPoints.length = 0;
			waveIndicatorRotations.length = 0;
			
			grid.restictBounds = false;
			grid.clear();
			grid.createRandomGrid(-1, 17, -1, 12, 0);
			grid.restictBounds = true;
			
			applyFunctionToDescription("S0", createStartLocationsFunction);
			applyFunctionToDescription("S1", createStartLocationsFunction);
			applyFunctionToDescription("S2", createStartLocationsFunction);
			
			applyFunctionToDescription("E0", createEndLocationsFunction);
			applyFunctionToDescription("E1", createEndLocationsFunction);
			applyFunctionToDescription("E2", createEndLocationsFunction);
			
			applyFunctionToDescription("OW", setOnlyUserWeaponFunction);
			// check all possibilities
			applyFunctionToDescription("", setEmptyLocationsFunction);
			applyFunctionToDescription(" ", setEmptyLocationsFunction);
			applyFunctionToDescription("  ", setEmptyLocationsFunction);
			applyFunctionToDescription("aa", setEmptyLocationsFunction);
			applyFunctionToDescription("bb", setEmptyLocationsFunction);
			
			applyFunctionToDescription("cb", setUltimateObstaclesFunction);
			applyFunctionToDescription("DO", setUltimateObstaclesFunction);
		}
		
		public function applyCustomDescription(description:Array):void
		{
			if (description.length != 13 || description[0].length != 18)
				throw new Error("Attempt to create a map with unsupported resolution!");
			
			this.description = description;
			
			constructGridForDescription();
		}
		
		////////////////////////// functions
		
		private function applyFunctionToDescription(value:String, func:Function):void
		{
			var lenY:int = description.length;
			
			for (var indexY:int = 0; indexY < lenY; indexY++)
			{
				var array:Array = description[indexY] as Array;
				var lenX:int = array.length;
				
				for (var indexX:int = 0; indexX < lenX; indexX++)
					if (String(array[indexX]) == value)
						// need to take offset into consideration
						func(indexX + grid.indexXMin, indexY + grid.indexYMin);
			}
		}
		
		////////////////
		
		private var numPlacesForUserWeapon:int = -1;
		
		public function getNumPlacesForUserWeapon():int
		{
			if (numPlacesForUserWeapon != -1)
				return numPlacesForUserWeapon;
			
			var lenY:int = description.length;
			numPlacesForUserWeapon = 0;
			
			for (var indexY:int = 0; indexY < lenY; indexY++)
			{
				var array:Array = description[indexY] as Array;
				var lenX:int = array.length;
				
				for (var indexX:int = 0; indexX < lenX; indexX++)
					if (String(array[indexX]) == "OW")
						numPlacesForUserWeapon++;
			}
			
			return numPlacesForUserWeapon;
		}
		
		/////////////////
		
		private function setUltimateObstaclesFunction(indexX:int, indexY:int):void
		{
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			location.id = LocationConstants.OBSTACLE;
			location.filter = MapConstants.LOCATION_ULTIMATE_OBSTACLE_FILTER;
		}
		
		private function setOnlyUserWeaponFunction(indexX:int, indexY:int):void
		{
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			location.id = LocationConstants.OBSTACLE;
			location.filter = MapConstants.LOCATION_ONLY_USER_WEAPON_FREE_FILTER;
		}
		
		private function setEmptyLocationsFunction(indexX:int, indexY:int):void
		{
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			location.id = LocationConstants.EMPTY;
			location.filter = MapConstants.LOCATION_EMPTY_FILTER;
		}
		
		private function createStartLocationsFunction(indexX:int, indexY:int):void
		{
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			location.id = LocationConstants.OBSTACLE;
			location.filter = MapConstants.LOCATION_ULTIMATE_OBSTACLE_FILTER;
			
			enemyEntranceLocations.push(location);
			enemyEntrancePoints.push(new Point(location.x, location.y));
			
			var enemyRotation:Number = 0;
			
			if (indexX == grid.indexXMin)
				enemyRotation = 0;
			else if (indexX == grid.indexXMax)
				enemyRotation = Math.PI;
			else if (indexY == grid.indexYMin)
				enemyRotation = Math.PI / 2;
			else if (indexY == grid.indexYMax)
				enemyRotation = Math.PI * 3 / 2;
			
			enemyInitialRotations.push(enemyRotation);
			
			/// adding a wave indicator
			
			var waveIndicatorRotation:Number = 0;
			var waveIndicatorOffsetX:Number = 0;
			var waveIndicatorOffsetY:Number = 0;
			
			if (indexX == grid.indexXMin)
			{
				waveIndicatorOffsetX = 130;
				waveIndicatorRotation = Math.PI;
			}
			else if (indexX == grid.indexXMax)
			{
				waveIndicatorOffsetX = -130;
				waveIndicatorRotation = 0;
			}
			else if (indexY == grid.indexYMin)
			{
				waveIndicatorOffsetY = 130;
				waveIndicatorRotation = Math.PI * 3 / 2;
			}
			else if (indexY == grid.indexYMax)
			{
				waveIndicatorOffsetY = -130;
				waveIndicatorRotation = Math.PI / 2;
			}
			
			waveIndicatorPoints.push(new Point(location.x + waveIndicatorOffsetX, location.y + waveIndicatorOffsetY));
			
			waveIndicatorRotations.push(waveIndicatorRotation);
		}
		
		private function createEndLocationsFunction(indexX:int, indexY:int):void
		{
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			location.id = LocationConstants.OBSTACLE;
			location.filter = MapConstants.LOCATION_ULTIMATE_OBSTACLE_FILTER;
			
			enemyExitLocations.push(location);
			enemyExitPoints.push(new Point(location.x, location.y));
		}
		
		/// creating teleports
		
		private var colors:Array = [OneWayTeleport.COLOR_PINK, OneWayTeleport.COLOR_CYAN, OneWayTeleport.COLOR_VIOLET, OneWayTeleport.COLOR_BLUE];
		
		private var teleports:Array = [];
		
		private var lastTeleportCreated:Teleport = null;
		
		private var currentFirstPartLocation:Location = null;
		
		private var currentPairCount:int = 0;
		
		public function generateTeleports():Array
		{
			teleports.length = 0;
			currentPairCount = 0;
			
			applyFunctionToDescription("I0", createFirstPartTeleportFunction);
			applyFunctionToDescription("J0", createSecondPartTeleportFunction);
			
			applyFunctionToDescription("I1", createFirstPartTeleportFunction);
			applyFunctionToDescription("J1", createSecondPartTeleportFunction);
			
			applyFunctionToDescription("I2", createFirstPartTeleportFunction);
			applyFunctionToDescription("J2", createSecondPartTeleportFunction);
			
			applyFunctionToDescription("I3", createFirstPartTeleportFunction);
			applyFunctionToDescription("J3", createSecondPartTeleportFunction);
			
			return teleports;
		}
		
		private function createFirstPartTeleportFunction(indexX:int, indexY:int):void
		{
			var location:Location = createTeleport(indexX, indexY, colors[currentPairCount % 4]);
			currentFirstPartLocation = location;
		}
		
		private function createSecondPartTeleportFunction(indexX:int, indexY:int):void
		{
			var firstPart:Teleport = lastTeleportCreated;
			
			var location:Location = createTeleport(indexX, indexY, colors[currentPairCount % 4]);
			
			firstPart.oppositePort = lastTeleportCreated;
			
			currentFirstPartLocation.linkedLocation = location;
			location.linkedLocation = currentFirstPartLocation;
			
			currentPairCount++;
		}
		
		private function createTeleport(indexX:int, indexY:int, color:int):Location
		{
			var teleport:OneWayTeleport = new OneWayTeleport(color);
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			teleport.x = location.x;
			teleport.y = location.y;
			location.color = teleport.color;
			location.filter = MapConstants.LOCATION_ONLY_PATH_FILTER;
			
			teleports.push(teleport);
			
			lastTeleportCreated = teleport;
			
			return location;
		}
		
		//////////// creating bridges
		
		private var bridges:Array = [];
		
		public function generateBridges():Array
		{
			bridges.length = 0;
			applyFunctionToDescription("BH", createHorizontalBridgesFunction);
			applyFunctionToDescription("BV", createVerticalBridgesFunction);
			
			return bridges;
		}
		
		private function createHorizontalBridgesFunction(indexX:int, indexY:int):void
		{
			createBridgeFunction(indexX, indexY, Bridge.DIRECTION_HORIZONTAL);
		}
		
		private function createVerticalBridgesFunction(indexX:int, indexY:int):void
		{
			createBridgeFunction(indexX, indexY, Bridge.DIRECTION_VERTICAL);
		}
		
		private function createBridgeFunction(indexX:int, indexY:int, direction:String):void
		{
			var bridge:Bridge = new Bridge(direction);
			
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			bridge.x = location.x;
			bridge.y = location.y;
			
			location.crossPathingEnabled = true;
			location.filter = MapConstants.LOCATION_ONLY_PATH_FILTER;
			
			bridges.push(bridge);
		}
		
		//////////// creating traffic lights
		
		private var trafficLights:Array = [];
		
		public function generateTrafficLights():Array
		{
			trafficLights.length = 0;
			applyFunctionToDescription("TH", createHorizontalTrafficLightFunction);
			applyFunctionToDescription("TV", createVerticalTrafficLightFunction);
			
			return trafficLights;
		}
		
		private function createHorizontalTrafficLightFunction(indexX:int, indexY:int):void
		{
			createTrafficLightFunction(indexX, indexY, TrafficLight.DIRECTION_HORIZONTAL);
		}
		
		private function createVerticalTrafficLightFunction(indexX:int, indexY:int):void
		{
			createTrafficLightFunction(indexX, indexY, TrafficLight.DIRECTION_VERTICAL);
		}
		
		private function createTrafficLightFunction(indexX:int, indexY:int, direction:String):void
		{
			var trafficLight:TrafficLight = new TrafficLight(direction);
			
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			trafficLight.x = location.x;
			trafficLight.y = location.y;
			trafficLight.grid = this.grid;
			trafficLight.applyToGrid();
			
			location.crossPathingEnabled = false;
			location.filter = MapConstants.LOCATION_ONLY_PATH_FILTER;
			
			trafficLights.push(trafficLight);
		}
		
		//////// generating bitmap data
		
		public function generateBitmapData():BitmapData
		{
			bitmapData = new BitmapData(width, height, true, 0x00000000);
			
			addField();
			applyFunctionToDescription("OW", drawOnlyForWeaponsLocationsFunction);
			applyFunctionToDescription("DO", drawDefaultObstaclesFunction);
			return bitmapData;
		}
		
		private function addField():void
		{
			if (levelImageClass != null)
				bitmapData.draw(new levelImageClass() as Bitmap);
		}
		
		private var weaponPad:Bitmap = null;
		
		private function drawOnlyForWeaponsLocationsFunction(indexX:int, indexY:int):void
		{
			if (weaponPadClass == null)
				return;
			
			if (!weaponPad)
				weaponPad = new weaponPadClass() as Bitmap;
			
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.alphaMultiplier = 0.5;
			
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(location.x - weaponPad.width / 2, location.y - weaponPad.height / 2);
			bitmapData.draw(weaponPad, matrix, colorTransform);
		}
		
		private var defaultObstacle:Bitmap = null;
		
		private function drawDefaultObstaclesFunction(indexX:int, indexY:int):void
		{
			if (defaultObstacleClass == null)
				return;
			
			if (!defaultObstacle)
				defaultObstacle = new defaultObstacleClass() as Bitmap;
			
			var location:Location = grid.getElementAtIndex(indexX, indexY);
			
			var matrix:Matrix = new Matrix();
			matrix.translate(location.x - defaultObstacle.width / 2, location.y - defaultObstacle.height / 2);
			bitmapData.draw(defaultObstacle, matrix, null);
		}
		
		/////// under construction message
		
		protected function getUnderConstructionContainer():NSSprite
		{
			var label:CustomTextField = new CustomTextField("Under Construction", new FontDescriptor(50, 0, FontResources.BOMBARD));
			var sprite:NSSprite = new NSSprite();
			
			AlignUtil.centerWithinBounds(label, GamePlayConstants.STAGE_WIDTH, GamePlayConstants.STAGE_HEIGHT);
			
			sprite.addChild(label);
			
			return sprite;
		}
		
		/// teleports
		
		public function getEnemyEnterTeleports():Array
		{
			return enemyEnterTeleports;
		}
		
		public function getEnemyEnterTeleportForPathAt(pathIndex:int):OneWayTeleport
		{
			return enemyEnterTeleports[pathIndex];
		}
		
		public function getEnemyExitTeleports():Array
		{
			return enemyExitTeleports;
		}
		
		public function getEnemyExitTeleportForPathAt(pathIndex:int):OneWayTeleport
		{
			return enemyExitTeleports[pathIndex];
		}
	
	}

}