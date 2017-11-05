/**
 *为了修改滚动条宽度而加 
 */
package com.mui.controls.scrollBarResizable 
{
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.events.FocusEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import fl.controls.TextArea;
	import fl.events.ScrollEvent;
	import fl.controls.ScrollPolicy;
	import fl.controls.ScrollBarDirection;
	import fl.managers.IFocusManager;
	
	import com.mui.controls.scrollBarResizable.ResizableScrollBar;
	import flash.utils.getQualifiedClassName;

	public class ScrollBarResizableTextArea extends TextArea {

		//从TextArea拷贝过来的样式
		protected static const SCROLL_BAR_STYLES:Object = {
												downArrowDisabledSkin:"downArrowDisabledSkin",
												downArrowDownSkin:"downArrowUpSkin",
												downArrowOverSkin:"downArrowOverSkin",
												downArrowUpSkin:"downArrowUpSkin",
												upArrowDisabledSkin:"upArrowDisabledSkin",
												upArrowDownSkin:"upArrowDownSkin",
												upArrowOverSkin:"upArrowOverSkin",
												upArrowUpSkin:"upArrowUpSkin",
												thumbDisabledSkin:"thumbDisabledSkin",
												thumbDownSkin:"thumbUpSkin",
												thumbOverSkin:"thumbOverSkin",
												thumbUpSkin:"thumbUpSkin",
												thumbIcon:"thumbIcon",
												trackDisabledSkin:"trackDisabledSkin",
												trackDownSkin:"trackDownSkin",
												trackOverSkin:"trackOverSkin",
												trackUpSkin:"trackUpSkin",
												repeatDelay:"repeatDelay",
												repeatInterval:"repeatInterval"
												};
											
											
		public function ScrollBarResizableTextArea() {
			// constructor code
			super();
		}
		
		override protected function configUI():void{
			//从UIComponent拷贝过来的代码
			isLivePreview = checkLivePreview();
			var r:Number = rotation;
			rotation = 0;
			var w:Number = super.width;
			var h:Number = super.height;
			super.scaleX = super.scaleY = 1;
			setSize(w,h);
			move(super.x,super.y);
			rotation = r;
			startWidth = w;
			startHeight = h;
			if (numChildren > 0) {
				removeChildAt(0);
			}			
			
			//从TextArea拷贝过来的代码并作适当修改
			tabChildren = true;

			textField = new TextField();
			addChild(textField);
			updateTextFieldType();
			
			_verticalScrollBar = new ResizableUIScrollBar();
			_verticalScrollBar.name = "V";
			_verticalScrollBar.visible = false;
			_verticalScrollBar.focusEnabled = false;
			copyStylesToChild(_verticalScrollBar, SCROLL_BAR_STYLES);
			_verticalScrollBar.addEventListener(ScrollEvent.SCROLL,handleScroll,false,0,true);
			addChild(_verticalScrollBar);
			
			_horizontalScrollBar = new ResizableUIScrollBar();
			_horizontalScrollBar.name = "H";
			_horizontalScrollBar.visible = false;
			_horizontalScrollBar.focusEnabled = false;
			_horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;
			copyStylesToChild(_horizontalScrollBar, SCROLL_BAR_STYLES);
			_horizontalScrollBar.addEventListener(ScrollEvent.SCROLL,handleScroll,false,0,true);
			addChild(_horizontalScrollBar);
			
			textField.addEventListener(TextEvent.TEXT_INPUT, handleTextInput, false, 0, true);
			textField.addEventListener(Event.CHANGE, handleChange, false, 0, true);
			textField.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true);
			
			_horizontalScrollBar.scrollTarget = textField;
			_verticalScrollBar.scrollTarget = textField;
			addEventListener(MouseEvent.MOUSE_WHEEL, handleWheel, false, 0, true);
			
		}
		
		public function setScrollBarSize(__width:Number):void{
			horizontalScrollBar.setSize(__width,height);
			verticalScrollBar.setSize(__width,height);
			draw();
		}
		
		override protected function drawLayout():void {
			super.drawLayout();
		}
		
		override protected function focusOutHandler(event:FocusEvent):void {
			//从TextArea拷贝过来的代码并作适当修改
			var fm:IFocusManager = focusManager;
			if (fm) {
				fm.defaultButtonEnabled = true;
			}
			//setSelection(0, 0);
			super.focusOutHandler(event);
			
			if(editable) {
				setIMEMode(false);
			}
		}
		
	}
	
}
