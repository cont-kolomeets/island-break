/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.AIPack.pathFollowing.pathOptimization
{
	import nslib.AIPack.grid.GridArray;
	import nslib.AIPack.grid.Location;
	import nslib.AIPack.pathFollowing.PathUtil;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class PatternIdentifier
	{
		private static const PATTERNS:Array = [];
		
		//////////////
		
		public function PatternIdentifier()
		{
			initializePatterns();
		}
		
		//////////////
		
		private function initializePatterns():void
		{
			// triangle patterns
			// horizontal
			var pattern1:PatternInfo = new PatternInfo();
			pattern1.pattern = [{x: 0, y: 0}, {x: 1, y: 1}, {x: 2, y: 0}];
			pattern1.moveInfos = [new MoveInfo(1, 1, 0)];
			
			var pattern2:PatternInfo = new PatternInfo();
			pattern2.pattern = [{x: 0, y: 0}, {x: 1, y: -1}, {x: 2, y: 0}];
			pattern2.moveInfos = [new MoveInfo(1, 1, 0)];
			
			// vertrical
			var pattern3:PatternInfo = new PatternInfo();
			pattern3.pattern = [{x: 0, y: 0}, {x: 1, y: 1}, {x: 0, y: 2}];
			pattern3.moveInfos = [new MoveInfo(1, 0, 1)];
			
			var pattern4:PatternInfo = new PatternInfo();
			pattern4.pattern = [{x: 0, y: 0}, {x: -1, y: 1}, {x: 0, y: 2}];
			pattern4.moveInfos = [new MoveInfo(1, 0, 1)];
			
			// short trapezoidal patterns
			// horizontal
			var pattern5:PatternInfo = new PatternInfo();
			pattern5.pattern = [{x: 0, y: 0}, {x: 1, y: 1}, {x: 2, y: 1}, {x: 3, y: 0}];
			pattern5.moveInfos = [new MoveInfo(1, 1, 0), new MoveInfo(2, 2, 0)];
			
			var pattern6:PatternInfo = new PatternInfo();
			pattern6.pattern = [{x: 0, y: 0}, {x: 1, y: -1}, {x: 2, y: -1}, {x: 3, y: 0}];
			pattern6.moveInfos = [new MoveInfo(1, 1, 0), new MoveInfo(2, 2, 0)];
			
			// vertrical
			var pattern7:PatternInfo = new PatternInfo();
			pattern7.pattern = [{x: 0, y: 0}, {x: 1, y: 1}, {x: 1, y: 2},{x: 0, y: 3}];
			pattern7.moveInfos = [new MoveInfo(1, 0, 1), new MoveInfo(2, 0, 2)];
			
			var pattern8:PatternInfo = new PatternInfo();
			pattern8.pattern = [{x: 0, y: 0}, {x: -1, y: 1}, {x: -1, y: 2}, {x: 0, y: 3}];
			pattern8.moveInfos = [new MoveInfo(1, 0, 1), new MoveInfo(2, 0, 2)];
			
			// long trapezoidal patterns
			// horizontal
			var pattern9:PatternInfo = new PatternInfo();
			pattern9.pattern = [{x: 0, y: 0}, {x: 1, y: 1}, {x: 2, y: 1}, {x: 3, y: 1}, {x: 4, y: 0}];
			pattern9.moveInfos = [new MoveInfo(1, 1, 0), new MoveInfo(2, 2, 0), new MoveInfo(3, 3, 0)];
			
			var pattern10:PatternInfo = new PatternInfo();
			pattern10.pattern = [{x: 0, y: 0}, {x: 1, y: -1}, {x: 2, y: -1}, {x: 3, y: -1}, {x: 4, y: 0}];
			pattern10.moveInfos = [new MoveInfo(1, 1, 0), new MoveInfo(2, 2, 0), new MoveInfo(3, 3, 0)];
			
			// vertrical
			var pattern11:PatternInfo = new PatternInfo();
			pattern11.pattern = [{x: 0, y: 0}, {x: 1, y: 1}, {x: 1, y: 2}, {x: 1, y: 3}, {x: 0, y: 4}];
			pattern11.moveInfos = [new MoveInfo(1, 0, 1), new MoveInfo(2, 0, 2), new MoveInfo(3, 0, 3)];
			
			var pattern12:PatternInfo = new PatternInfo();
			pattern12.pattern = [{x: 0, y: 0}, {x: -1, y: 1}, {x: -1, y: 2}, {x: -1, y: 3}, {x: 0, y: 4}];
			pattern12.moveInfos = [new MoveInfo(1, 0, 1), new MoveInfo(2, 0, 2), new MoveInfo(3, 0, 3)];
			
			// very long trapezoidal patterns (only once case considered)
			// horizontal
			var pattern13:PatternInfo = new PatternInfo();
			pattern13.pattern = [{x: 0, y: 0}, {x: 1, y: -1}, {x: 2, y: -1}, {x: 3, y: -1}, {x: 4, y: -1},{x: 5, y: -1}, {x: 6, y: 0}];
			pattern13.moveInfos = [new MoveInfo(1, 1, 0), new MoveInfo(2, 2, 0), new MoveInfo(3, 3, 0), new MoveInfo(4, 4, 0), new MoveInfo(5, 5, 0)];
			
			PATTERNS.push(pattern1);
			PATTERNS.push(pattern2);
			PATTERNS.push(pattern3);
			PATTERNS.push(pattern4);
			
			PATTERNS.push(pattern5);
			PATTERNS.push(pattern6);
			PATTERNS.push(pattern7);
			PATTERNS.push(pattern8);
			
			PATTERNS.push(pattern9);
			PATTERNS.push(pattern10);
			PATTERNS.push(pattern11);
			PATTERNS.push(pattern12);
			
			PATTERNS.push(pattern13);
		}
		
		public function performPatternBasedOptimization(path:Array, grid:GridArray):Array
		{
			var len:int = path.length;
			
			// checking custom pattern
			for each (var pattern:PatternInfo in PATTERNS)
				for (var i:int = 0; i < len; i++)
					checkPattern(pattern, i, path, grid);
			
			return path;
		}
		
		private function checkPattern(info:PatternInfo, firstIndex:int, path:Array, grid:GridArray):Boolean
		{
			// cycle through the pattern
			
			var offsetX:int = path[firstIndex].indexX;
			var offsetY:int = path[firstIndex].indexY;
			
			var len:int = info.pattern.length;
			
			var useReverse:Boolean = false;
			
			// check one direction and reverse
			for (var i:int = 0; i < len; i++)
			{
				var pathLocation:Location = path[firstIndex + i];
				var pathLocationReverse:Location = path[firstIndex - i];
				
				var normalDirectionPassed:Boolean = false;
				var reverseDirectionPassed:Boolean = false;
				
				if (pathLocation)
					normalDirectionPassed = Boolean(((pathLocation.indexX - offsetX) == info.pattern[i].x) && ((pathLocation.indexY - offsetY) == info.pattern[i].y))
				
				if (pathLocationReverse)
					reverseDirectionPassed = Boolean(((pathLocationReverse.indexX - offsetX) == info.pattern[i].x) && ((pathLocationReverse.indexY - offsetY) == info.pattern[i].y))
				
				if (!normalDirectionPassed && !reverseDirectionPassed)
					return false;
				
				useReverse = reverseDirectionPassed;
			}
			
			// if pattern identified
			
			// check if all moves are allowed
			// if pattern identified
			for each (var moveInfoTest:MoveInfo in info.moveInfos)
			{
				var locationToMoveToTest:Location = grid.getElementAtIndex(moveInfoTest.xTo + offsetX, moveInfoTest.yTo + offsetY);
				
				// cannot move to an occupied location
				if (!PathUtil.locationIsPassable(locationToMoveToTest))
					return false;
			}
			
			// after verification perform moving
			for each (var moveInfo:MoveInfo in info.moveInfos)
			{
				var locationToMoveTo:Location = grid.getElementAtIndex(moveInfo.xTo + offsetX, moveInfo.yTo + offsetY);
				var locationToMoveFrom:Location = path[firstIndex + moveInfo.nodeIndex * (useReverse ? -1 : 1)];
				
				var prevLocation:Location = null;
				var nextLocation:Location = null;
				
				if (useReverse)
				{
					path[firstIndex - moveInfo.nodeIndex] = locationToMoveTo;
					
					prevLocation = path[firstIndex - moveInfo.nodeIndex - 1];
					nextLocation = path[firstIndex - moveInfo.nodeIndex + 1];
				}
				else
				{
					path[firstIndex + moveInfo.nodeIndex] = locationToMoveTo;
					
					prevLocation = path[firstIndex + moveInfo.nodeIndex - 1];
					nextLocation = path[firstIndex + moveInfo.nodeIndex + 1];
				}
				
				// reassign paret-child relationship
				if (prevLocation.parent == locationToMoveFrom)
				{
					prevLocation.parent = locationToMoveTo;
					locationToMoveTo.parent = nextLocation;
				}
				else if (nextLocation.parent == locationToMoveFrom)
				{
					nextLocation.parent = locationToMoveTo;
					locationToMoveTo.parent = prevLocation;
				}
				
				locationToMoveFrom.parent = null;
			}
			
			return true;
		}
	}
}

class PatternInfo
{
	public var pattern:Array;
	
	public var moveInfos:Array;
}

class MoveInfo
{
	public var xTo:int;
	
	public var yTo:int;
	
	public var nodeIndex:int;
	
	public function MoveInfo(nodeIndex:int, xTo:int, yTo:int):void
	{
		this.nodeIndex = nodeIndex;
		this.xTo = xTo;
		this.yTo = yTo;
	}
}