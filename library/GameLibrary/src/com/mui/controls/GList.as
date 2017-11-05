package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.mui.controls.scrollBarResizable.ScrollBarResizableList;
	import com.mui.core.IFrUI;
	import com.mui.core.IFrUIContainer;
	import com.mui.skins.SkinManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.List;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class GList extends List implements IFrUI//ScrollBarResizableList
	{
		
		public const CLASSNAME:String = "List";
		
		private var _verticalGap:Number = 0;
		
		public function GList()
		{
			super();
			_styleName = CLASSNAME;
		}
		
		public function set verticalGap(value:Number):void
		{
			if ( _verticalGap == value )
				return;
			_verticalGap = value;
			invalidate();
			drawNow();
		}
		
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		
		final override protected function configUI():void
		{
			//不在这里初始化background,因为要在drawBackground函数中设置
			super.configUI();
			createChildren();
		}
		
		private var _styleName:String;
		
		public function get styleName():String
		{
			return _styleName;
		}
		
		private var _isStyleChange:Boolean = false;
		public function set styleName( value:String ):void
		{
			if( _styleName != value )
			{
				_styleName = value;
				invalidate(InvalidationType.STYLES);
				_isStyleChange = true;
			}
		}
		
		public function getCellRenderer(skin:Object):ICellRenderer
		{
			if(skin is Class)
			{
				var skinInst:DisplayObject = UICompomentPool.getUICompoment(skin as Class) as DisplayObject;
				if(skinInst is IFrUIContainer)
				{
					(skinInst as IFrUIContainer).createDisposedChildren();
				}
				return skinInst as ICellRenderer;
			}
			return getDisplayObjectInstance(skin) as ICellRenderer;
		}
		
		public function disposeRender():void
		{
			if(_dataProvider)
			{
				_dataProvider.removeAll();
			}
			var renderer:ICellRenderer;
			while (activeCellRenderers.length > 0) 
			{
				renderer = activeCellRenderers.pop();
				removeRenderEventListener(renderer as Sprite);
				if(renderer is IDispose)
				{
					(renderer as IDispose).dispose();
				}
				else
				{
					list.removeChild(renderer as DisplayObject);
				}
			}
			while(availableCellRenderers.length > 0)
			{
				renderer = availableCellRenderers.pop();
				removeRenderEventListener(renderer as Sprite);
				if(renderer is IDispose)
				{
					(renderer as IDispose).dispose();
				}
				else
				{
					if((renderer as DisplayObject).parent)
					{
						(renderer as DisplayObject).parent.removeChild((renderer as DisplayObject));
					}
				}
			}
		}
		
		protected function removeRenderEventListener(rendererSprite:Sprite):void
		{
			if(!rendererSprite)
			{
				return;
			}
			rendererSprite.removeEventListener(MouseEvent.CLICK,handleCellRendererClick,false);
			rendererSprite.removeEventListener(MouseEvent.ROLL_OVER,handleCellRendererMouseEvent,false);
			rendererSprite.removeEventListener(MouseEvent.ROLL_OUT,handleCellRendererMouseEvent,false);
			rendererSprite.removeEventListener(Event.CHANGE,handleCellRendererChange,false);
			rendererSprite.doubleClickEnabled = false;
			rendererSprite.removeEventListener(MouseEvent.DOUBLE_CLICK,handleCellRendererDoubleClick,false);
		}
		
		final override protected function draw():void
		{
			//样式发生了改变
			if (isInvalid(InvalidationType.STYLES)) 
			{
				updateStyle();
			}
			// 数据发生改变
			if (isInvalid(InvalidationType.DATA)) 
			{
				updateDate();
			}
			
			if( isInvalid(InvalidationType.SIZE) )
			{
				updateSize();
			}
			//布局发生改变
			if (isInvalid(InvalidationType.SIZE,InvalidationType.SELECTED,InvalidationType.DATA)) 
			{
				updateDisplayList();
			}
			
			var contentH:Number = rowHeight*length + verticalGap*length-1;
			var contentHeightChanged:Boolean = (contentHeight != contentH);
			contentHeight = contentH;
			
			if (isInvalid(InvalidationType.STYLES)) {
				setStyles();
				drawBackground();
				// drawLayout is expensive, so only do it if padding has changed:
				if (contentPadding != getStyleValue("contentPadding")) {
					invalidate(InvalidationType.SIZE,false);
				}
				// redrawing all the cell renderers is even more expensive, so we really only want to do it if necessary:
				if (_cellRenderer != getStyleValue("cellRenderer")) {
					// remove all the existing renderers:
					_invalidateList();
					_cellRenderer = getStyleValue("cellRenderer");
				}
			}
			if (isInvalid(InvalidationType.SIZE, InvalidationType.STATE) || contentHeightChanged) {
				drawLayout();
			}
			
			if (isInvalid(InvalidationType.RENDERER_STYLES)) {
				updateRendererStyles();	
			}
			
			if (isInvalid(InvalidationType.STYLES,InvalidationType.SIZE,InvalidationType.DATA,InvalidationType.SCROLL,InvalidationType.SELECTED)) {
				drawList();
			}
			
			// Call drawNow on nested components to get around problems with nested render events:
			updateChildren();
			
			// Not calling super.draw, because we're handling everything here. Instead we'll just call validate();
			validate();
		}
		
		override protected function drawList():void {
			// List is very environmentally friendly, it reuses existing 
			// renderers for old data, and recycles old renderers for new data.
			
			var rowH:Number = rowHeight + verticalGap;
			
			// set horizontal scroll:
			listHolder.x = listHolder.y = contentPadding;
			
			var rect:Rectangle = listHolder.scrollRect;
			rect.x = _horizontalScrollPosition;
			
			// set pixel scroll:
			rect.y = Math.floor(_verticalScrollPosition)%rowH;
			listHolder.scrollRect = rect;
			
			listHolder.cacheAsBitmap = useBitmapScrolling;
			
			// figure out what we have to render:
			var startIndex:uint = Math.floor(_verticalScrollPosition/rowH);
			var endIndex:uint = Math.min(length,startIndex + rowCount+1);
			
			
			// these vars get reused in different loops:
			var i:uint;
			var item:Object;
			var renderer:ICellRenderer;
			
			// create a dictionary for looking up the new "displayed" items:
			var itemHash:Dictionary = renderedItems = new Dictionary(true);
			for (i=startIndex; i<endIndex; i++) {
				itemHash[_dataProvider.getItemAt(i)] = true;
			}
			
			// find cell renderers that are still active, and make those that aren't active available:
			var itemToRendererHash:Dictionary = new Dictionary(true);
			while (activeCellRenderers.length > 0) {
				renderer = activeCellRenderers.pop() as ICellRenderer;
				item = renderer.data;
				if (itemHash[item] == null || invalidItems[item] == true) {
					availableCellRenderers.push(renderer);
				} else {
					itemToRendererHash[item] = renderer;
					// prevent problems with duplicate objects:
					invalidItems[item] = true;
				}
				list.removeChild(renderer as DisplayObject);
			}
			invalidItems = new Dictionary(true);
			
			// draw cell renderers:
			for (i=startIndex; i<endIndex; i++) {
				var reused:Boolean = false;
				item = _dataProvider.getItemAt(i);
				if (itemToRendererHash[item] != null) {
					// existing renderer for this item we can reuse:
					
					reused = true;
					renderer = itemToRendererHash[item];
					delete(itemToRendererHash[item]);
				} else if (availableCellRenderers.length > 0) {
					
					// recycle an old renderer:
					renderer = availableCellRenderers.pop() as ICellRenderer;
				} else {
					
					// out of renderers, create a new one:
					//					renderer = getDisplayObjectInstance(getStyleValue("cellRenderer")) as ICellRenderer;
					renderer = getCellRenderer(getStyleValue("cellRenderer"));
					var rendererSprite:Sprite = renderer as Sprite;
					if (rendererSprite != null) {
						rendererSprite.addEventListener(MouseEvent.CLICK,handleCellRendererClick,false,0,true);
						rendererSprite.addEventListener(MouseEvent.ROLL_OVER,handleCellRendererMouseEvent,false,0,true);
						rendererSprite.addEventListener(MouseEvent.ROLL_OUT,handleCellRendererMouseEvent,false,0,true);
						rendererSprite.addEventListener(Event.CHANGE,handleCellRendererChange,false,0,true);
						rendererSprite.doubleClickEnabled = true;
						rendererSprite.addEventListener(MouseEvent.DOUBLE_CLICK,handleCellRendererDoubleClick,false,0,true);
						
						if (rendererSprite["setStyle"] != null) {
							for (var n:String in rendererStyles) {
								rendererSprite["setStyle"](n, rendererStyles[n])
							}
						}
					}
				}
				list.addChild(renderer as Sprite);
				activeCellRenderers.push(renderer);
				
				renderer.x = 0;
				renderer.y = rowH*(i-startIndex);
				renderer.setSize(availableWidth+_maxHorizontalScrollPosition,rowHeight);
				
				var label:String = itemToLabel(item);
				
				var icon:Object = null;
				if (_iconFunction != null) {
					icon = _iconFunction(item);
				} else if (_iconField != null) {
					if(item.hasOwnProperty(_iconField))
					{
						icon = item[_iconField];
					}
				}
				
				if (!reused) {
					renderer.data = item;
				}
				renderer.listData = new ListData(label,icon,this,i,i,0);
				renderer.selected = (_selectedIndices.indexOf(i) != -1);
				
				// force an immediate draw (because render event will not be called on the renderer):
				if (renderer is UIComponent) {
					(renderer as UIComponent).drawNow();
				}
			}
		}
		
		override public function itemToLabel(item:Object):String 
		{
			if (_labelFunction != null) 
			{
				return String(_labelFunction(item));
			} 
			else  
			{
				if( _labelField == null || item == null ) return "";
				if(item.hasOwnProperty(_labelField))
				{
					return (item[_labelField]!=null) ? String(item[_labelField]) : "";
				}
				return "";
			}
		}
		
		/**
		 * 创建组件的子对象 
		 * 
		 */
		protected function createChildren():void
		{
			
		}
		/**
		 * 样式发生改变时候更新 
		 * 
		 */
		protected function updateStyle():void
		{
			
		}
		
		protected function updateSize():void
		{
			
		}
		
		/**
		 *  
		 * 
		 */
		protected function updateDate():void
		{
			
		}
		
		protected function updateDisplayList():void
		{
			
		}
		
		public function configEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			ObjEventListerTool.addObjEvent(this,type,listener,useCapture);
			addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			ObjEventListerTool.removeObjEvent(this,type,listener,useCapture);
			super.removeEventListener(type,listener,useCapture);
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			disposeRender();
			renderedItems = new Dictionary(true);
			invalidItems = new Dictionary(true);
			_horizontalScrollPosition = 0;
			_verticalScrollPosition = 0;
			ObjEventListerTool.delObjEvent(this);
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			if(isReuse)
			{
				UICompomentPool.disposeUICompoment(this);
			}
		}
	}
}