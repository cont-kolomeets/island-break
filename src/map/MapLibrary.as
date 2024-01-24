/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package map
{
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public class MapLibrary
	{
		// abbreviations:
		// OP = only path
		// OW = only weapons
		// '  ' - empty
		// cb = completely blocked
		// DO - default obstacle
		// S(index) E(index) - start & end
		// I(index) J(index) - input & output for a teleport at index
		// T(index) H(index) - input & output for a cave at index
		// BV - bridge vertical
		// BH - bridge horizonal
		// TH - traffic light horizontal
		// TV - traffic light vertical
		
		/* Template:
		   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
		   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
		   localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
		   localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
		   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
		   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
		   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
		   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
		   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
		   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
		   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
		   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
		   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
		 */
		
		public static function getEmptyMap():Array
		{
			var localDescription:Array = [];
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap01():Array
		{
			var localDescription:Array = [];
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,E0,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,DO,  ,DO,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,OW,  ,OW,  ,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,OW,OW,  ,OW,OW,cb,cb,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,OW,  ,OW,  ,OW,  ,OW,  ,OW,  ,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,OW,OW,OW,OW,OW,OW,OW,OW,  ,OW,OW,cb,cb,cb,cb");
			localDescription.push("S0,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,OW,  ,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,cb,cb,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,OW,  ,OW,  ,OW,  ,OW,cb,OW,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap02():Array
		{
			var localDescription:Array = [];
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,E0,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,  ,DO,  ,DO,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,OW,  ,OW,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,OW,  ,OW,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,  ,  ,  ,  ,OW,  ,OW,  ,OW,  ,OW,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,OW,OW,OW,OW,OW,  ,OW,OW,OW,OW,OW,OW,DO,DO,DO,cb,cb");
			localDescription.push("cb,  ,OW,  ,  ,  ,  ,BH,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,S0");
			localDescription.push("cb,  ,OW,  ,OW,OW,OW,  ,OW,OW,OW,OW,OW,OW,DO,DO,DO,cb,cb");
			localDescription.push("cb,  ,OW,  ,OW,  ,OW,  ,OW,  ,OW,  ,OW,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,OW,  ,OW,OW,OW,  ,OW,OW,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,  ,OW,  ,  ,  ,  ,  ,OW,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb");
			localDescription.push("cb,cb,  ,  ,  ,  ,  ,  ,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,DO,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap03():Array
		{
			var localDescription:Array = [];
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,OW,OW,OW,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("E0,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,OW,OW,OW,OW,OW,OW,OW,  ,OW,cb,cb,cb,cb,cb");
			localDescription.push("E1,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,BV,  ,  ,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,OW,OW,cb,cb,cb,cb,cb,OW,  ,OW,OW,  ,cb,cb,cb");
			localDescription.push("S0,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb,cb,  ,OW,OW,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,OW,  ,OW,OW,OW,OW,OW,  ,OW,OW,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,OW,  ,  ,  ,  ,  ,  ,  ,OW,OW,  ,cb,cb,cb");
			localDescription.push("S1,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,OW,OW,cb,OW,OW,OW,OW,OW,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			
			/*localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,S0,cb,S1,cb,cb,cb,cb,cb,cb,cb");
			   localDescription.push("cb,cb,cb,cb,cb,  ,cb,cb,  ,  ,  ,cb,cb,cb,cb,cb,cb,cb");
			   localDescription.push("cb,cb,cb,  ,  ,  ,  ,OW,  ,  ,  ,OW,  ,  ,  ,  ,  ,cb");
			   localDescription.push("cb,cb,cb,  ,OW,OW,  ,OW,  ,  ,  ,OW,  ,OW,OW,  ,  ,cb");
			   localDescription.push("cb,  ,  ,  ,cb,OW,  ,OW,  ,  ,  ,OW,  ,OW,cb,  ,  ,cb");
			   localDescription.push("cb,  ,  ,  ,OW,OW,  ,OW,  ,  ,  ,OW,  ,OW,OW,  ,  ,cb");
			   localDescription.push("cb,  ,  ,  ,cb,OW,  ,OW,  ,  ,  ,OW,  ,OW,cb,  ,  ,cb");
			   localDescription.push("cb,  ,  ,  ,OW,OW,  ,OW,  ,  ,  ,OW,  ,OW,OW,  ,  ,cb");
			   localDescription.push("cb,  ,  ,  ,cb,OW,E0,OW,  ,  ,  ,OW,E1,OW,cb,  ,  ,cb");
			   localDescription.push("cb,  ,  ,  ,OW,OW,OW,  ,  ,  ,  ,  ,OW,OW,OW,  ,  ,cb");
			   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,OW,OW,OW,  ,  ,  ,  ,  ,cb,cb");
			   localDescription.push("cb,cb,cb,cb,cb,  ,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			 localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");*/
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap04():Array
		{
			var localDescription:Array = [];
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,OW,OW,OW,OW,cb,cb,cb,OW,OW,cb,cb,  ,  ,  ,  ,  ,S0");
			localDescription.push("E1,  ,  ,  ,  ,OW,OW,cb,cb,OW,OW,OW,OW,  ,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,  ,OW,  ,  ,  ,  ,  ,  ,BH,  ,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,  ,  ,  ,cb,cb,cb,OW,OW,  ,OW,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,OW,OW,OW,cb,cb,cb,cb,OW,  ,OW,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,  ,  ,  ,cb,cb,cb,cb,cb,  ,OW,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,  ,OW,  ,  ,  ,  ,  ,  ,  ,OW,  ,cb,cb,cb");
			localDescription.push("E0,  ,  ,  ,  ,OW,OW,cb,cb,OW,OW,cb,cb,cb,cb,  ,cb,cb,cb");
			localDescription.push("cb,cb,OW,OW,OW,OW,cb,cb,cb,OW,OW,cb,cb,cb,cb,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,S1,cb,cb,cb");
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap05():Array
		{
			var localDescription:Array = [];
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,S0,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,cb,cb,OW,OW,cb,OW,OW,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,cb,cb,cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,S1");
			localDescription.push("cb,cb,cb,  ,OW,cb,cb,cb,OW,  ,OW,cb,OW,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,OW,OW,OW,OW,OW,  ,OW,OW,cb,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,BH,  ,  ,  ,cb,  ,  ,  ,cb,cb");
			localDescription.push("cb,cb,cb,cb,OW,OW,OW,OW,OW,  ,OW,OW,  ,OW,  ,  ,  ,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,cb,OW,  ,OW,OW,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,OW,OW,OW,OW,OW,cb,cb,OW,  ,  ,  ,  ,  ,  ,E0");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,cb,cb,OW,OW,OW,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,  ,cb,cb,  ,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,E1,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap06():Array
		{
			var localDescription:Array = [];
			
			/*localDescription.push("cb,cb,cb,cb,S0,cb,cb,cb,cb,cb,cb,cb,cb,S1,cb,cb,cb,cb");
			   localDescription.push("cb,cb,cb,cb,aa,cb,cb,cb,cb,cb,cb,cb,cb,bb,cb,cb,cb,cb");
			   localDescription.push("cb,cb,cb,DO,aa,DO,  ,  ,  ,  ,  ,  ,DO,bb,DO,  ,  ,cb");
			   localDescription.push("cb,cb,cb,DO,aa,DO,  ,  ,  ,  ,  ,  ,DO,bb,DO,  ,  ,cb");
			   localDescription.push("cb,  ,  ,OW,aa,OW,  ,  ,  ,  ,  ,  ,OW,bb,OW,  ,  ,cb");
			   localDescription.push("cb,  ,  ,OW,aa,OW,  ,  ,  ,  ,  ,  ,OW,bb,OW,  ,  ,cb");
			   localDescription.push("cb,  ,cb,OW,aa,OW,OW,OW,OW,OW,OW,OW,OW,bb,OW,  ,  ,cb");
			   localDescription.push("E1,bb,bb,bb,BV,bb,bb,bb,bb,bb,bb,bb,bb,bb,OW,  ,  ,cb");
			   localDescription.push("cb,  ,cb,OW,aa,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,cb,  ,cb");
			   localDescription.push("cb,  ,  ,OW,aa,aa,aa,aa,aa,aa,aa,aa,aa,aa,aa,aa,aa,E0");
			   localDescription.push("cb,  ,  ,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,cb,cb,cb");
			   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			 localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");*/
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,E0,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,OW,OW,OW,OW,OW,cb,OW,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,OW,  ,cb,OW,OW,OW,OW,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("S0,  ,  ,  ,  ,  ,  ,OW,  ,  ,  ,  ,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,OW,  ,OW,OW,  ,cb,cb,  ,  ,  ,  ,E1");
			localDescription.push("S1,  ,  ,  ,  ,cb,cb,OW,  ,OW,OW,  ,OW,OW,  ,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,cb,OW,OW,  ,OW,OW,  ,OW,OW,  ,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,  ,  ,  ,  ,cb,cb,  ,  ,  ,  ,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,OW,OW,OW,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap07():Array
		{
			var localDescription:Array = [];
			/*
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,OW,OW,OW,OW,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,OW,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,OW,OW,OW,OW,OW,OW,OW,OW,OW,  ,OW,OW,cb,cb");
			localDescription.push("E0,  ,  ,BV,  ,  ,  ,  ,  ,  ,  ,  ,  ,BH,  ,  ,OW,cb");
			localDescription.push("cb,cb,OW,  ,OW,OW,OW,OW,OW,OW,OW,OW,OW,  ,OW,  ,OW,cb");
			localDescription.push("cb,cb,OW,  ,OW,  ,  ,  ,S0,S1,  ,  ,  ,  ,OW,  ,OW,cb");
			localDescription.push("cb,cb,OW,  ,OW,  ,OW,OW,OW,OW,OW,OW,OW,OW,OW,  ,OW,cb");
			localDescription.push("cb,cb,OW,  ,  ,BH,  ,  ,  ,  ,  ,  ,  ,  ,  ,BV,  ,E1");
			localDescription.push("cb,cb,cb,OW,OW,  ,OW,OW,OW,OW,OW,OW,OW,OW,OW,  ,cb,cb");
			localDescription.push("cb,cb,cb,cb,OW,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,OW,OW,OW,OW,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");*/
			
			
			   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			   localDescription.push("cb,cb,cb,cb,cb,cb,OW,OW,OW,OW,OW,OW,cb,cb,cb,cb,cb,cb,cb");
			   localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,  ,  ,  ,  ,E0");
			   localDescription.push("cb,cb,OW,  ,OW,cb,cb,cb,cb,OW,cb,cb,  ,OW,  ,OW,cb,cb,cb");
			   localDescription.push("cb,  ,OW,  ,OW,  ,  ,cb,cb,cb,cb,cb,  ,OW,  ,OW,cb,cb,cb");
			   localDescription.push("cb,  ,OW,  ,cb,cb,cb,cb,cb,cb,cb,cb,  ,cb,  ,OW,  ,cb,cb");
			   localDescription.push("cb,  ,OW,  ,cb,cb,  ,  ,S0,cb,S1,  ,  ,cb,  ,OW,  ,cb,cb");
			   localDescription.push("cb,  ,OW,  ,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,  ,OW,  ,cb,cb");
			   localDescription.push("cb,  ,OW,  ,  ,OW,  ,cb,cb,cb,cb,  ,  ,OW,  ,OW,  ,cb,cb");
			   localDescription.push("cb,  ,OW,OW,  ,OW,  ,cb,cb,OW,cb,cb,cb,OW,  ,OW,  ,cb,cb");
			   localDescription.push("cb,  ,  ,OW,  ,OW,  ,  ,  ,  ,  ,  ,  ,  ,  ,OW,cb,cb,cb");
			   localDescription.push("cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			   localDescription.push("cb,cb,cb,cb,E1,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			 
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap08():Array
		{
			var localDescription:Array = [];
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,S0,cb,S1,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,  ,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,  ,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,  ,  ,  ,cb,  ,  ,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,  ,cb,cb,OW,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,OW,  ,  ,  ,  ,  ,BV,  ,  ,  ,  ,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,OW,OW,OW,OW,OW,OW,  ,OW,OW,OW,OW,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb,OW,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,BH,  ,  ,E1");
			localDescription.push("cb,cb,cb,cb,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,OW,  ,cb,cb,cb");
			localDescription.push("E0,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap09():Array
		{
			var localDescription:Array = [];
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,  ,  ,OW,OW,OW,OW,  ,  ,cb,cb,  ,  ,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,  ,OW,  ,  ,  ,  ,OW,  ,  ,cb,  ,  ,cb,cb");
			localDescription.push("S0,  ,  ,  ,  ,cb,OW,  ,OW,OW,  ,OW,OW,  ,  ,cb,  ,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,OW,  ,  ,OW,OW,E1,OW,OW,OW,  ,cb,  ,cb,cb");
			localDescription.push("cb,  ,cb,  ,  ,  ,  ,cb,OW,OW,cb,  ,  ,  ,  ,cb,  ,cb,cb");
			localDescription.push("cb,  ,cb,  ,OW,OW,OW,E0,OW,OW,  ,  ,OW,OW,cb,cb,  ,cb,cb");
			localDescription.push("cb,  ,cb,  ,  ,OW,OW,  ,OW,OW,  ,OW,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,  ,cb,cb,  ,  ,OW,  ,  ,  ,  ,OW,  ,  ,  ,  ,  ,  ,S1");
			localDescription.push("cb,  ,  ,cb,cb,  ,  ,OW,OW,OW,OW,  ,  ,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
		
		public static function getMap10():Array
		{
			var localDescription:Array = [];
			
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,  ,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,OW,  ,OW,OW,OW,OW,OW,OW,OW,  ,cb,  ,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,OW,  ,OW,  ,  ,  ,  ,  ,OW,  ,cb,  ,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,OW,  ,OW,  ,  ,  ,OW,  ,OW,  ,cb,cb,cb,cb");
			localDescription.push("S0,  ,  ,  ,TV,cb,  ,OW,E0,  ,E1,OW,  ,cb,TV,  ,  ,  ,S1");
			localDescription.push("cb,cb,cb,cb,  ,OW,  ,OW,  ,  ,  ,OW,  ,OW,  ,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,  ,OW,  ,  ,  ,  ,  ,OW,  ,OW,  ,cb,  ,cb,cb");
			localDescription.push("cb,  ,  ,cb,  ,OW,OW,OW,OW,OW,OW,OW,  ,OW,  ,cb,  ,cb,cb");
			localDescription.push("cb,  ,  ,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
			
			var description:Array = [];
			var len:int = localDescription.length;
			
			for (var i:int = 0; i < len; i++)
				description.push(String(localDescription[i]).split(","));
			
			return description;
		}
	
	}

}

/*
   localDescription.push("cb,cb,cb,cb,cb,E0,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,OW,OW,  ,OW,OW,OW,OW,OW,OW,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,cb,OW,  ,  ,BV,  ,  ,  ,  ,  ,  ,OW,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,OW,  ,OW,  ,OW,OW,OW,OW,OW,  ,OW,  ,  ,  ,  ,cb");
   localDescription.push("E0,  ,OW,  ,OW,  ,OW,  ,  ,  ,OW,  ,OW,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,OW,  ,OW,  ,OW,OW,OW,OW,OW,  ,OW,OW,OW,OW,cb,cb");
   localDescription.push("cb,  ,OW,  ,  ,BH,  ,  ,  ,  ,  ,BH,  ,  ,  ,  ,  ,S0");
   localDescription.push("cb,  ,OW,OW,OW,  ,OW,OW,OW,OW,OW,  ,OW,OW,OW,OW,cb,cb");
   localDescription.push("cb,  ,  ,  ,OW,  ,OW,OW,OW,OW,OW,  ,OW,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,OW,  ,  ,  ,  ,  ,  ,  ,OW,  ,  ,  ,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");


   // level 2 candidate
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,E0,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,DO,  ,DO,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,  ,  ,  ,OW,  ,OW,  ,  ,  ,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,cb,cb,  ,  ,  ,OW,  ,OW,  ,  ,  ,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,  ,  ,OW,  ,OW,  ,OW,  ,OW,  ,  ,  ,  ,cb");
   localDescription.push("E0,  ,OW,OW,OW,OW,OW,  ,OW,OW,OW,OW,OW,OW,OW,DO,DO,cb");
   localDescription.push("cb,  ,OW,  ,  ,  ,  ,BH,  ,  ,  ,  ,  ,  ,  ,  ,  ,S0");
   localDescription.push("cb,  ,OW,  ,OW,OW,OW,  ,OW,OW,OW,OW,OW,OW,OW,DO,DO,cb");
   localDescription.push("cb,  ,OW,  ,OW,  ,OW,  ,OW,  ,OW,  ,OW,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,OW,  ,OW,OW,OW,  ,OW,OW,  ,  ,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,OW,  ,  ,  ,  ,  ,OW,  ,  ,  ,  ,  ,  ,  ,cb,cb");
   localDescription.push("cb,cb,DO,DO,DO,DO,DO,DO,DO,  ,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,DO,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");

   // level 3 candidate
   localDescription.push("cb,cb,cb,cb,cb,E0,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,DO,  ,DO,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,  ,OW,OW,OW,OW,OW,OW,OW,OW,  ,OW,DO,DO,DO,cb");
   localDescription.push("cb,cb,cb,  ,OW,  ,  ,  ,  ,  ,  ,  ,BH,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,OW,  ,OW,OW,OW,OW,OW,OW,  ,OW,DO,DO,DO,cb");
   localDescription.push("E0,  ,  ,  ,OW,  ,OW,  ,OW,OW,  ,OW,  ,OW,  ,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,OW,  ,OW,OW,  ,  ,OW,OW,  ,OW,  ,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,OW,  ,OW,  ,OW,OW,  ,OW,  ,OW,DO,  ,  ,S0");
   localDescription.push("cb,DO,DO,DO,OW,  ,OW,OW,OW,OW,OW,OW,  ,OW,  ,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,  ,BV,  ,  ,  ,  ,  ,  ,  ,OW,  ,  ,  ,cb");
   localDescription.push("cb,DO,DO,DO,OW,  ,OW,OW,OW,OW,OW,OW,OW,OW,  ,  ,cb,cb");
   localDescription.push("cb,cb,cb,cb,DO,  ,DO,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");

   // rejected
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,OW,OW,OW,cb");
   localDescription.push("cb,cb,cb,  ,  ,  ,  ,bb,bb,bb,bb,bb,bb,bb,bb,bb,bb,E1");
   localDescription.push("cb,DO,DO,OW,OW,OW,OW,bb,OW,OW,OW,OW,  ,OW,OW,OW,  ,cb");
   localDescription.push("S0,aa,aa,aa,aa,aa,aa,BV,aa,aa,aa,OW,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,  ,  ,OW,bb,OW,  ,aa,DO,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,DO,DO,OW,OW,OW,OW,bb,OW,OW,aa,OW,OW,OW,OW,DO,DO,cb");
   localDescription.push("cb,  ,  ,  ,  ,  ,  ,bb,bb,bb,BH,bb,bb,bb,bb,bb,bb,S1");
   localDescription.push("cb,DO,OW,OW,WO,OW,WO,OW,OW,OW,aa,OW,  ,  ,  ,  ,  ,cb");
   localDescription.push("E0,aa,aa,aa,aa,aa,aa,aa,aa,aa,aa,DO,  ,  ,  ,  ,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");



   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,OW,OW,OW,OW,  ,  ,  ,OW,OW,  ,cb,  ,  ,  ,  ,S0");
   localDescription.push("cb,cb,cb,  ,  ,OW,OW,cb,cb,OW,OW,cb,cb,  ,cb,cb,cb,cb");
   localDescription.push("cb,  ,cb,cb,cb,cb,OW,  ,  ,  ,  ,  ,  ,BH,  ,  ,cb,cb");
   localDescription.push("E0,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb,cb,  ,OW,  ,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,OW,OW,cb,  ,  ,  ,cb,  ,OW,  ,cb,cb");
   localDescription.push("E1,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb,cb,  ,OW,  ,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,OW,  ,  ,  ,  ,  ,  ,  ,OW,  ,cb,cb");
   localDescription.push("cb,  ,  ,  ,  ,OW,OW,cb,cb,OW,OW,cb,cb,cb,cb,  ,cb,cb");
   localDescription.push("cb,  ,OW,OW,OW,OW,  ,  ,  ,OW,OW,  ,  ,  ,cb,  ,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,  ,cb,cb,cb,cb,cb,cb,cb,cb,  ,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,S1,cb,cb");

   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,OW,OW,OW,OW,OW,OW,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,  ,  ,  ,E0");
   localDescription.push("cb,cb,OW,  ,OW,cb,cb,cb,cb,cb,cb,  ,cb,OW,  ,OW,cb,cb");
   localDescription.push("cb,  ,OW,  ,OW,  ,  ,cb,OW,OW,  ,  ,cb,OW,  ,OW,cb,cb");
   localDescription.push("E0,  ,OW,  ,OW,cb,cb,OW,cb,cb,OW,  ,cb,OW,  ,OW,  ,cb");
   localDescription.push("cb,  ,OW,  ,OW,cb,  ,  ,S0,S1,  ,  ,cb,OW,  ,OW,  ,cb");
   localDescription.push("cb,  ,OW,  ,OW,cb,  ,OW,cb,cb,OW,cb,cb,OW,  ,OW,  ,S0");
   localDescription.push("cb,  ,OW,  ,  ,cb,  ,cb,OW,OW,  ,  ,  ,OW,  ,OW,  ,cb");
   localDescription.push("cb,  ,OW,OW,  ,cb,  ,cb,cb,cb,cb,cb,cb,OW,  ,OW,  ,cb");
   localDescription.push("cb,  ,  ,cb,  ,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,OW,cb,cb");
   localDescription.push("cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,E1,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");


   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,OW,OW,OW,OW,OW,OW,  ,  ,OW,OW,OW,OW,OW,OW,OW,cb");
   localDescription.push("S0,  ,  ,  ,  ,  ,I0,OW,  ,  ,OW,I1,  ,  ,  ,  ,  ,S1");
   localDescription.push("cb,cb,OW,OW,OW,OW,OW,OW,  ,  ,OW,OW,OW,OW,OW,OW,OW,cb");
   localDescription.push("E0,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,cb,OW,OW,OW,OW,OW,OW,  ,  ,OW,OW,OW,OW,OW,OW,OW,cb");
   localDescription.push("E1,  ,  ,  ,  ,  ,J1,OW,  ,  ,OW,J0,  ,  ,  ,  ,  ,E0");
   localDescription.push("cb,cb,OW,OW,OW,OW,OW,OW,  ,  ,OW,OW,OW,OW,OW,OW,OW,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");



   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,  ,OW,OW,OW,OW,  ,  ,cb,cb,  ,  ,cb");
   localDescription.push("cb,cb,cb,cb,  ,  ,OW,  ,  ,  ,  ,OW,  ,  ,cb,  ,  ,cb");
   localDescription.push("S0,  ,  ,  ,  ,OW,OW,  ,OW,OW,  ,OW,OW,  ,  ,cb,  ,cb");
   localDescription.push("cb,cb,cb,cb,OW,OW,  ,  ,OW,OW,E0,OW,OW,OW,  ,cb,  ,cb");
   localDescription.push("cb,  ,cb,  ,  ,  ,  ,cb,OW,OW,cb,  ,  ,  ,  ,cb,  ,cb");
   localDescription.push("cb,  ,cb,  ,OW,OW,OW,E1,OW,OW,  ,  ,OW,OW,cb,cb,  ,cb");
   localDescription.push("cb,  ,cb,  ,  ,OW,OW,  ,OW,OW,  ,OW,OW,cb,cb,cb,cb,cb");
   localDescription.push("cb,  ,cb,cb,  ,  ,OW,  ,  ,  ,  ,OW,  ,  ,  ,  ,  ,S1");
   localDescription.push("cb,  ,  ,cb,cb,  ,  ,OW,OW,OW,OW,  ,  ,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,  ,  ,  ,  ,  ,  ,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");


   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,  ,cb");
   localDescription.push("cb,cb,cb,cb,  ,OW,  ,OW,OW,OW,OW,OW,OW,OW,  ,cb,  ,cb");
   localDescription.push("cb,cb,cb,cb,  ,OW,  ,OW,  ,  ,  ,  ,  ,OW,  ,cb,  ,cb");
   localDescription.push("cb,cb,cb,cb,  ,OW,  ,OW,  ,  ,  ,OW,  ,OW,  ,cb,cb,cb");
   localDescription.push("S0,  ,  ,  ,TV,OW,  ,OW,E0,  ,E1,OW,  ,OW,TV,  ,  ,S1");
   localDescription.push("cb,cb,cb,cb,  ,OW,  ,OW,  ,  ,  ,OW,  ,OW,  ,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,  ,OW,  ,  ,  ,  ,  ,OW,  ,OW,  ,cb,  ,cb");
   localDescription.push("cb,  ,  ,cb,  ,OW,OW,OW,OW,OW,OW,OW,  ,OW,  ,cb,  ,cb");
   localDescription.push("cb,  ,  ,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");

   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,S0,cb,S1,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,cb,cb,  ,  ,  ,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,  ,  ,  ,  ,OW,  ,  ,  ,OW,  ,  ,  ,  ,  ,cb");
   localDescription.push("cb,cb,cb,  ,OW,OW,  ,OW,  ,  ,  ,OW,  ,OW,OW,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,cb,OW,  ,OW,  ,  ,  ,OW,  ,OW,cb,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,OW,OW,  ,OW,  ,  ,  ,OW,  ,OW,OW,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,cb,OW,  ,OW,  ,  ,  ,OW,  ,OW,cb,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,OW,OW,  ,OW,  ,  ,  ,OW,  ,OW,OW,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,cb,OW,E0,OW,  ,  ,  ,OW,E1,OW,cb,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,OW,OW,OW,  ,  ,  ,  ,  ,OW,OW,OW,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,  ,  ,  ,  ,OW,OW,OW,  ,  ,  ,  ,  ,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");

   localDescription.push("cb,cb,cb,cb,cb,E0,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,cb,cb,cb,cb,cb,DO,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,DO,DO,DO,DO,  ,  ,cb");
   localDescription.push("cb,cb,cb,  ,  ,  ,  ,  ,  ,  ,  ,  ,OW,OW,DO,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,  ,  ,OW,OW,DO,DO,DO,DO,OW,OW,DO,  ,  ,cb");
   localDescription.push("E0,  ,  ,  ,  ,  ,OW,OW,DO,OW,OW,DO,DO,DO,DO,  ,  ,cb");
   localDescription.push("cb,  ,DO,DO,DO,DO,DO,DO,DO,OW,OW,  ,OW,OW,  ,  ,  ,cb");
   localDescription.push("cb,  ,DO,DO,OW,OW,  ,OW,DO,DO,DO,DO,DO,  ,  ,  ,  ,S0");
   localDescription.push("cb,  ,  ,DO,OW,OW,DO,DO,DO,  ,OW,OW,DO,OW,OW,  ,  ,cb");
   localDescription.push("cb,  ,  ,DO,DO,DO,DO,OW,OW,  ,OW,OW,DO,OW,OW,  ,  ,cb");
   localDescription.push("cb,  ,  ,  ,  ,  ,  ,OW,OW,  ,  ,  ,DO,DO,DO,DO,DO,cb");
   localDescription.push("cb,cb,cb,cb,cb,  ,  ,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");
   localDescription.push("cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb,cb");


 */