/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.TextLine;
	import nslib.controls.events.ButtonEvent;
	import nslib.controls.supportClasses.LayoutConstants;
	import nslib.controls.supportClasses.PositionConstants;
	import nslib.sequencers.ImageSequencer;
	import nslib.utils.FontDescriptor;
	import nslib.utils.MouseUtil;
	import nslib.utils.TextUtil;
	
	[Event(name="buttonClick",type="alexlib.controls.events.ButtonEvent")]
	
	/**
	 * ...
	 * @author Alex
	 */
	public class Button extends LayoutContainer
	{
		// if this flag is true, then mouse events such as mouse out or mouse over
		// will be considered only by checking if the cursor hits the bounds of the button.
		public var considerOnlyBoundsForMouseEvents:Boolean = false;
		
		public var imagePosition:String = PositionConstants.LEFT;
		
		private var textField:TextLine = null;
		
		private var dummyShield:Shape = null;
		
		// flags
		
		private var isAddedToStage:Boolean = false;
		
		//////////////////////////////////////////////////
		
		public function Button(label:String = "", fontDescriptor:FontDescriptor = null)
		{
			mouseEnabled = true;
			mouseChildren = false;
			
			if (fontDescriptor)
				this.fontDescriptor = fontDescriptor;
			
			this.label = label;
			
			invalidateProperties();
			
			if (stage)
			{
				if (enabled)
					addListeners();
			}
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}
		
		private function addedToStageHandler(event:Event):void
		{
			isAddedToStage = true;
			
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false, 0, true);
			
			if (enabled)
				addListeners();
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			isAddedToStage = false;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, false);
			
			removeListeners();
			
			tryShowCorrectImage(imageNormal);
		}
		
		///////////////
		
		private var _enabled:Boolean = true;
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;
			
			if (_enabled)
				removeListeners();
			else
				addListeners();
			
			mouseEnabled = value;
			buttonMode = value;
			_enabled = value;
			
			if (!value)
				tryShowCorrectImage(_imageDisabled);
			else
				tryShowCorrectImage(imageNormal);
			
			invalidateProperties();
		}
		
		/////////////////////////////////////////////
		
		private var _smoothing:Boolean = false;
		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
			
			if (imageNormal)
				imageNormal.smoothing = value;
			
			if (_imageOver)
				_imageOver.smoothing = value;
			
			if (_imageDown)
				_imageDown.smoothing = value;
			
			if (_imageDisabled)
				_imageDisabled.smoothing = value;
		}
		
		/////////////////////////////////////////////
		
		private var _fontDescriptor:FontDescriptor = new FontDescriptor(20, 0xAAAAAA);
		
		public function get fontDescriptor():FontDescriptor
		{
			return _fontDescriptor;
		}
		
		public function set fontDescriptor(value:FontDescriptor):void
		{
			_fontDescriptor = value;
			
			label = _label;
		}
		
		/////////////////////////////////////////////
		
		private var _label:String = null;
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			if (value)
			{
				// need to change layout so we can add a dummy shield over the text field
				layout = LayoutConstants.NONE;
							
				_label = value;
				
				if (textField && contains(textField))
					removeChild(textField);
				
				textField = TextUtil.generateTextLine(value, fontDescriptor);
				textField.mouseEnabled = false;
				textField.mouseChildren = false;
				addChild(textField);
				
				if (dummyShield && contains(dummyShield))
					removeChild(dummyShield);
				
				if (!dummyShield)
					dummyShield = new Shape();
				
				refresh(true, true);
									
				dummyShield.graphics.clear();
				dummyShield.graphics.beginFill(0, 0.01);
				dummyShield.graphics.drawRect(0, 0, textField.width, textField.height);
				
				addChild(dummyShield);
				
				invalidateLayout();
			}
		}
		
		//////////////
		
		private var imageNormal:ImageSequencer = null;
		
		public function set image(value:*):void
		{
			if (!value)
				return;
			
			if (value is ImageSequencer)
			{
				if (imageNormal && contains(imageNormal))
					removeChild(imageNormal);
				
				imageNormal = value;
			}
			else
			{
				if (!imageNormal)
					imageNormal = new ImageSequencer();
				
				imageNormal.removeAllImages();
				imageNormal.addImage(value);
			}
			
			imageNormal.smoothing = smoothing;
			imageNormal.start();
			
			tryShowCorrectImage(imageNormal);
			
			invalidateLayout();
		}
		
		///////////////
		
		private var _imageOver:ImageSequencer = null;
		
		public function set imageOver(value:*):void
		{
			if (!value)
				return;
			
			if (value is ImageSequencer)
			{
				if (_imageOver && contains(_imageOver))
					removeChild(_imageOver);
				
				_imageOver = value;
			}
			else
			{
				if (!_imageOver)
					_imageOver = new ImageSequencer();
				
				_imageOver.removeAllImages();
				_imageOver.addImage(value);
			}
			
			_imageOver.smoothing = smoothing;
		}
		
		///////////////
		
		private var _imageDown:ImageSequencer = null;
		
		public function set imageDown(value:*):void
		{
			if (!value)
				return;
			
			if (value is ImageSequencer)
			{
				if (_imageDown && contains(_imageDown))
					removeChild(_imageDown);
				
				_imageDown = value;
			}
			else
			{
				if (!_imageDown)
					_imageDown = new ImageSequencer();
				
				_imageDown.removeAllImages();
				_imageDown.addImage(value);
			}
			
			_imageDown.smoothing = smoothing;
		}
		
		///////////////
		
		private var _imageDisabled:ImageSequencer = null;
		
		public function set imageDisabled(value:*):void
		{
			if (!value)
				return;
			
			if (value is ImageSequencer)
			{
				if (_imageDisabled && contains(_imageDisabled))
					removeChild(_imageDisabled);
				
				_imageDisabled = value;
			}
			else
			{
				if (!_imageDisabled)
					_imageDisabled = new ImageSequencer();
				
				_imageDisabled.removeAllImages();
				_imageDisabled.addImage(value);
			}
			
			_imageDisabled.smoothing = smoothing;
			
			if (!enabled)
				tryShowCorrectImage(_imageDisabled);
		}
		
		///////////////////////////////////////////
		
		private function addListeners():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver_Handler, false, 0, true);
			
			if (stage)
				stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
		}
		
		private function removeListeners():void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler, false);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, false);
			removeEventListener(MouseEvent.CLICK, clickHandler, false);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut_Handler, false);
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver_Handler, false);
			
			if (stage)
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
		}
		
		private function mouseDown_Handler(event:MouseEvent):void
		{
			tryShowCorrectImage(_imageDown);
		}
		
		private function mouseUp_Handler(event:MouseEvent):void
		{
			tryShowCorrectImage(_imageOver);
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			this.dispatchEvent(new ButtonEvent(ButtonEvent.BUTTON_CLICK));
		}
		
		private function mouseOver_Handler(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver_Handler, false);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, false, 0, true);
			addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut_Handler, false, 0, true);
			
			dispatchEvent(new ButtonEvent(ButtonEvent.BUTTON_MOUSE_OVER));
			
			tryShowCorrectImage(_imageOver);
		}
		
		private function mouseOut_Handler(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_Handler, false);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp_Handler, false);
			removeEventListener(MouseEvent.CLICK, clickHandler, false);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut_Handler);
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver_Handler, false, 0, true);
			
			if (considerOnlyBoundsForMouseEvents && MouseUtil.isMouseOver(this))
				tryShowCorrectImage(_imageOver);
			else
				tryShowCorrectImage(imageNormal);
		}
		
		private function stage_mouseMoveHandler(event:MouseEvent):void
		{
			if (considerOnlyBoundsForMouseEvents)
				if (!MouseUtil.isMouseOver(this))
					tryShowCorrectImage(imageNormal);
		}
		
		private var currentImage:* = null;
		
		private function tryShowCorrectImage(image:ImageSequencer):void
		{
			// if the button is disabled the disabled image should be shown
			if (!enabled)
				image = _imageDisabled;
			// if the button is removed after a click then the over image might be still shown
			// since there was no way to have the mouse out event.
			// For this reason we need to reset the image.
			else if (!isAddedToStage)
				image = imageNormal;
			
			// check if the requested image is available
			// if not use the normal image
			var imageToShow:ImageSequencer = image ? image : imageNormal;
			
			// do not need to do anything if the image is already in displayed
			if (image && currentImage == image)
				return;
			
			currentImage = imageToShow;
			
			if (!imageToShow)
				return;
			
			// first remove all images
			if (_imageDisabled && contains(_imageDisabled))
				removeChild(_imageDisabled);
			
			if (_imageDown && contains(_imageDown))
				removeChild(_imageDown);
			
			if (_imageOver && contains(_imageOver))
				removeChild(_imageOver);
			
			if (imageNormal && contains(imageNormal))
				removeChild(imageNormal);
			
			// then add the one we want
			if (imagePosition == PositionConstants.LEFT || imagePosition == PositionConstants.TOP)
				addChildAt(imageToShow, 0);
			else
				addChild(imageToShow);
		}
	
	}

}