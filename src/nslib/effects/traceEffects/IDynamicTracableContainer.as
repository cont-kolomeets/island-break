package nslib.effects.traceEffects 
{
	import flash.display.Bitmap;
	import flash.events.IEventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public interface IDynamicTracableContainer extends IEventDispatcher
	{
		function applyTraceColorTransform():void;
		
		function applyFilter(filter:BitmapFilter):void;
		
		function getTracableBitMapsToDrawAtXY(xFrom:Number, yFrom:Number, xTo:Number, yTo:Number):Array;
		
		function getPermanentBitMapsToDrawAtXY(xFrom:Number, yFrom:Number, xTo:Number, yTo:Number):Array;
	}
	
}