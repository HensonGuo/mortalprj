/**
 * @date 2011-3-28 下午05:34:58
 * @author  wangyang
 * 
 */  
package com.mui.controls.scrollBarResizable
{
	import fl.containers.ScrollPane;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import fl.events.ScrollEvent;
	import fl.controls.ScrollPolicy;
	import fl.controls.ScrollBarDirection;
	
	import com.mui.controls.scrollBarResizable.ResizableScrollBar;
	public class ScrollBarResizableScrollPane extends ScrollPane
	{
		//从BaseScrollPane拷贝过来的样式
		protected static const SCROLL_BAR_STYLES:Object = {
			upArrowDisabledSkin: "upArrowDisabledSkin",
			upArrowDownSkin:"upArrowDownSkin",
			upArrowOverSkin:"upArrowOverSkin",
			upArrowUpSkin:"upArrowUpSkin",
			downArrowDisabledSkin:"downArrowDisabledSkin",
			downArrowDownSkin:"downArrowUpSkin",
			downArrowOverSkin:"downArrowOverSkin",
			downArrowUpSkin:"downArrowUpSkin",
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
		
		public function ScrollBarResizableScrollPane()
		{
			super();
		}
		
		/**
		 * 设置滚动条的宽度 
		 * @param __width
		 * 
		 */		
		
		public function setScrollBarSize(__width:Number):void
		{
			_horizontalScrollBar.setSize(__width,height);
			_verticalScrollBar.setSize(__width,height);
			draw();
		}
		
		
		override protected function configUI():void
		{
			
			//从UIComponent复制过来的代码
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
			
			//从BaseScrollPane复制过来的代码并将ScrollBar改成ResizableScrollBarScrollBar
			//contentScrollRect is not actually used by BaseScrollPane, only by subclasses.
			contentScrollRect = new Rectangle(0,0,85,85);
			
			// set up vertical scroll bar:
			_verticalScrollBar = new ResizableScrollBar();
			_verticalScrollBar.addEventListener(ScrollEvent.SCROLL,handleScroll,false,0,true);
			_verticalScrollBar.visible = false;
			_verticalScrollBar.lineScrollSize = defaultLineScrollSize;
			
			
			addChild(_verticalScrollBar);
			copyStylesToChild(_verticalScrollBar,SCROLL_BAR_STYLES);
			_verticalScrollBar.setSize(19,height);
			_verticalScrollBar.drawNow();
			
			// set up horizontal scroll bar:
			_horizontalScrollBar = new ResizableScrollBar();
			_horizontalScrollBar.direction = ScrollBarDirection.HORIZONTAL;
			_horizontalScrollBar.addEventListener(ScrollEvent.SCROLL,handleScroll,false,0,true);
			_horizontalScrollBar.visible = false;
			_horizontalScrollBar.lineScrollSize = defaultLineScrollSize;
			
			addChild(_horizontalScrollBar);
			copyStylesToChild(_horizontalScrollBar,SCROLL_BAR_STYLES);
			_horizontalScrollBar.setSize(19,height);
			_horizontalScrollBar.drawNow();
			
			// Create the disabled overlay
			disabledOverlay = new Shape();
			var g:Graphics = disabledOverlay.graphics;
			g.beginFill(0xFFFFFF);
			width=100;
			height=100;
			g.drawRect(0,0,width,height);
			g.endFill();
			
			addEventListener(MouseEvent.MOUSE_WHEEL,handleWheel,false,0,true);
			
			//从ScrollPane复制过来的代码
			contentClip = new Sprite();
			addChild(contentClip);
			contentClip.scrollRect = contentScrollRect; 
			_horizontalScrollPolicy = ScrollPolicy.AUTO;
			_verticalScrollPolicy = ScrollPolicy.AUTO;
		}
		
		override protected function drawLayout():void 
		{
			//从ScrollPane复制过来的代码
			contentScrollRect = contentClip.scrollRect;
			contentScrollRect.width = availableWidth;
			contentScrollRect.height = availableHeight;
			
			contentClip.cacheAsBitmap = useBitmapScrolling;
			contentClip.scrollRect = contentScrollRect;
			contentClip.x = contentClip.y = contentPadding;
			//从BaseScrollPane复制过来的代码并作适当修改
			calculateAvailableSize();
			calculateContentWidth();
			//return;
			background.width = width;
			background.height = height;
			
			if (vScrollBar) {
				_verticalScrollBar.visible = true;
				_verticalScrollBar.x = width - _verticalScrollBar.width - contentPadding;
				_verticalScrollBar.y = contentPadding;
				_verticalScrollBar.height = availableHeight;
			} else {
				_verticalScrollBar.visible = false;
			}
			
			_verticalScrollBar.setScrollProperties(availableHeight, 0, contentHeight - availableHeight, verticalPageScrollSize);
			setVerticalScrollPosition(_verticalScrollBar.scrollPosition, false);
			
			if (hScrollBar) {
				_horizontalScrollBar.visible = true;
				_horizontalScrollBar.x = contentPadding;
				_horizontalScrollBar.y = height - _horizontalScrollBar.width - contentPadding;
				_horizontalScrollBar.width = availableWidth;
			} else {
				_horizontalScrollBar.visible = false;
			}
			
			_horizontalScrollBar.setScrollProperties(availableWidth, 0, (useFixedHorizontalScrolling) ? _maxHorizontalScrollPosition : contentWidth - availableWidth, horizontalPageScrollSize);
			setHorizontalScrollPosition(_horizontalScrollBar.scrollPosition, false);
			
			drawDisabledOverlay();
			
			contentScrollRect = contentClip.scrollRect;
			contentScrollRect.width = availableWidth;
			contentScrollRect.height = availableHeight;
			
			contentClip.cacheAsBitmap = useBitmapScrolling;
			contentClip.scrollRect = contentScrollRect;
			contentClip.x = contentClip.y = contentPadding;
		
		}
		

		
		override protected function calculateAvailableSize():void
		{
			//从BaseScrollPane复制过来的代码并作适当修改
			var scrollBarWidth:Number = 0;
			scrollBarWidth = _verticalScrollBar.width;
			var padding:Number = contentPadding = Number(getStyleValue("contentPadding"));
			
			// figure out which scrollbars we need
			var availHeight:Number = height-2*padding - vOffset;
			vScrollBar = (_verticalScrollPolicy == ScrollPolicy.ON) || (_verticalScrollPolicy == ScrollPolicy.AUTO && contentHeight > availHeight);
			var availWidth:Number = width - (vScrollBar ? scrollBarWidth : 0) - 2 * padding;
			var maxHScroll:Number = (useFixedHorizontalScrolling) ? _maxHorizontalScrollPosition : contentWidth - availWidth;
			hScrollBar = (_horizontalScrollPolicy == ScrollPolicy.ON) || (_horizontalScrollPolicy == ScrollPolicy.AUTO && maxHScroll > 0);
			if (hScrollBar) { availHeight -= scrollBarWidth; }
			// catch the edge case of the horizontal scroll bar necessitating a vertical one:
			if (hScrollBar && !vScrollBar && _verticalScrollPolicy == ScrollPolicy.AUTO && contentHeight > availHeight) {
				vScrollBar = true;
				availWidth -= scrollBarWidth;
			}
			availableHeight = availHeight + vOffset;
			availableWidth = availWidth;
			
		}
		
	}
	
}
