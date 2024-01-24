/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.effects.traceEffects 
{
	import flash.display.BitmapData;
	import flash.events.IEventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 * ITracableContainer supports drawing of tracable objects.
	 * It has traceBitmapData to draw moving objects (like bullets or fireballs)
	 * and permanentBitmapData to draw permanent things (like holes or burn pits).
	 */
	public interface ITracableContainer extends IEventDispatcher
	{
		function get traceBitmapData():BitmapData;
		
		function get traceRect():Rectangle;
		
		function get traceColorTransform():ColorTransform;
		
		function get permanentBitmapData():BitmapData;
		
		function get permanentBitmapDataColorTransform():ColorTransform;
	}
	
}