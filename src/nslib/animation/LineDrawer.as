/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.animation
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import nslib.animation.events.AnimationEvent;
    

	//--------------------------------------------------------------------------
	//
	//  Events
	//
	//--------------------------------------------------------------------------
	
	/**
     * LineDrawer component provides methods to draw a line. You should first specify a line parameters calling the function drawLine(...).
	 * To start drawing call the funciton play();
     */
    public class LineDrawer extends Sprite
    {
        //--------------------------------------------------------------------------
        //
        //  Instance variables
        //
        //--------------------------------------------------------------------------

		/**
		 * Color of a line. 
		 */
        public var lineColor:int = 0;

		/**
		 * Thickness of a line. 
		 */
		public var lineThickness:int = 1;

        private var line:Shape = new Shape();

        private var completedPercent:Number = 0;

        private var deltaPercent:Number = 0;

        private var deltaX:Number = 0;

        private var deltaY:Number = 0;

        private var curX:Number = 0;

        private var curY:Number = 0;

        private var xFrom:Number = 0;

        private var yFrom:Number = 0;

        private var xTo:Number = 0;

        private var yTo:Number = 0;

        private var drawLineImmediately:Boolean = false;

        //--------------------------------------------------------------------------
        //
        //  Constructor
        //
        //--------------------------------------------------------------------------

		/**
		 * Creates an instance of LineDrawer class. 
		 * 
		 */
        public function LineDrawer()
        {
            super();
            this.addChild(line);
        }

        //--------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------

		/**
		 * Sets parameters for a line to be drawn. 
		 * @param xFrom xFrom.
		 * @param yFrom yFrom.
		 * @param xTo xTo.
		 * @param yTo yTo.
		 * @param duration Duration of animation. If zero, a line will be drawn immediately after the play() function is called.
		 * 
		 */
        public function drawLine(xFrom:Number, yFrom:Number, xTo:Number, yTo:Number, duration:Number):void
        {
            var nFrames:int = int(duration * stage.frameRate / 1000);

            this.xFrom = xFrom;
            this.yFrom = yFrom;
            this.xTo = xTo;
            this.yTo = yTo;

            if (duration == 0)
                drawLineImmediately = true;
            else
            {
                completedPercent = 0;
                deltaPercent = 1 / nFrames;
                deltaX = (xTo - xFrom) / nFrames;
                deltaY = (yTo - yFrom) / nFrames;

                curX = xFrom;
                curY = yFrom;
            }

            line.graphics.lineStyle(lineThickness, lineColor);
        }

		/**
		 * Starts drawing a line with specified parameters. 
		 * 
		 */
        public function play():void
        {
            addEventListener(Event.ENTER_FRAME, frameListener);
        }

        private function frameListener(event:Event):void
        {
            if (drawLineImmediately)
                line.graphics.drawRect(xFrom, yFrom, xTo - xFrom, yTo - yFrom);
            else
            {
                line.graphics.drawRect(curX, curY, deltaX, deltaY);

                curX += deltaX;
                curY += deltaY;
            }

            completedPercent += deltaPercent;
            if (completedPercent > 0.999)
                complete();
        }

        private function complete():void
        {
            removeEventListener(Event.ENTER_FRAME, frameListener);
            dispatchEvent(new AnimationEvent(AnimationEvent.DRAWING_COMPLETE));
        }

    }
}
