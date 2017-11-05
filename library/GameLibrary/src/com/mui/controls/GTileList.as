package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.gengine.utils.ArrayUtil;
	import com.mui.controls.scrollBarResizable.ScrollBarResizableTileList;
	import com.mui.core.IFrUI;
	import com.mui.core.IFrUIContainer;
	import com.mui.skins.SkinManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.ScrollBarDirection;
	import fl.controls.TileList;
	import fl.controls.listClasses.ICellRenderer;
	import fl.controls.listClasses.ListData;
	import fl.controls.listClasses.TileListData;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.sampler.getGetterInvocationCount;
	import flash.utils.Dictionary;
	
	public class GTileList extends TileList implements IFrUI
	{
		private var _verticalGap:Number = 0;
		private var _horizontalGap:Number = 0;
		private var _arrVGap:Array;
		private var _arrHGap:Array;
		
		public var isCanSelect:Boolean = true;
		
		
		public function GTileList()
		{
			super();
			//			_iconField = null;
			//			_labelField = null;
		}
		
		public function set horizontalGap(value:Number):void
		{
			_horizontalGap = value;
		}
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}
		
		public function set verticalGap(value:Number):void
		{
			_verticalGap = value;
		}
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		
		/**
		 * 设置某一行的行距， 从0开始表示第一个行距
		 * @param gapIndex
		 * @param value
		 * 
		 */		
		public function setVerticalGapAt(gapIndex:int, value:Number):void
		{
			if(_arrVGap == null)
			{
				_arrVGap = [];
			}
			_arrVGap[gapIndex] = value;
		}
		
		/**
		 * 设置某一列的间距， 从0开始第一个列距
		 * @param gapIndex
		 * @param value
		 * 
		 */		
		public function setHorizontalGapAt(gapIndex:int, value:Number):void
		{
			if(_arrHGap == null)
			{
				_arrHGap = [];
			}
			_arrHGap[gapIndex] = value;
		}
		
		private function getTotalGap(row:int, gapData:Array, generalGap:int):int
		{
			var res:int = 0;
			if(gapData == null)
			{
				return row * generalGap;
			}
			for(var i:int = 0; i < row; i++)
			{
				if(gapData[i] == null)
				{
					res += generalGap;
				}
				else
				{
					res += int(gapData[i]);
				}
			}
			return res;
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
		
		final override protected function draw():void
		{
			//样式发生了改变
			if (isInvalid(InvalidationType.STYLES)) 
			{
				if( _isStyleChange )
				{
					SkinManager.setComponentStyle(this,_styleName);
					_isStyleChange = false;
				}
			}
			_isDraw = true;
			super.draw();
			_isDraw = false;
		}
		
		private var _isUseFixed:Boolean = false;
		/**
		 * 设置是否使用修正： false使用原本有bug的计算行数、列数规则， true可以修正 
		 * @param value
		 * 
		 */		
		public function set useFixed(value:Boolean):void
		{
			_isUseFixed = value;
		}
		
		override protected function drawList():void 
		{
			// these vars get reused in different loops:
			var i:uint;
			var itemIndex:uint;
			var item:Object;
			var renderer:ICellRenderer;
			var rows:uint = rowCount;    //可见的行数
			var cols:uint = columnCount;   //可见的排数
			var colW:Number = columnWidth;
			var rowH:Number = rowHeight;
			var baseCol:Number = 0;
			var baseRow:Number = 0;
			var col:uint;
			var row:uint;
			
			listHolder.x = listHolder.y = contentPadding;
			
			// set horizontal scroll:
			contentScrollRect = listHolder.scrollRect;
			contentScrollRect.x = Math.floor(_horizontalScrollPosition)%colW;
			
			// set pixel scroll:
			contentScrollRect.y = Math.floor(_verticalScrollPosition)%rowH;
			listHolder.scrollRect = contentScrollRect;
			
			listHolder.cacheAsBitmap = useBitmapScrolling;
			
			// figure out what we have to render, and where:
			var items:Array = [];
			if (_scrollDirection == ScrollBarDirection.HORIZONTAL) {
				// horizontal scrolling is trickier if we want to keep tiles going left to right, then top to bottom.
				// we can use availableWidth / availableHeight from BaseScrollPane here, because we've just called drawLayout, so we know they are accurate.
				var fullCols:uint = availableWidth/colW<<0;
				if(_isUseFixed)
				{
					fullCols = (availableWidth + horizontalGap)/(colW + horizontalGap)<<0
				}
				var rowLength:uint = Math.max(fullCols,Math.ceil(length/rows));
				baseCol = _horizontalScrollPosition/colW<<0;
				if(_isUseFixed)
				{
					baseCol = (_horizontalScrollPosition)/(colW + horizontalGap)<<0;
				}
				cols = Math.max(fullCols,Math.min(rowLength-baseCol,cols+1));//(horizontalScrollBar.visible ? 1 : -1))); // need to draw an extra two cols for scrolling.
				//rowLength = Math.max(cols-(horizontalScrollBar.visible ? -1 : 0),rowLength);
				for (row=0; row<rows; row++) {
					for (col=0; col<cols; col++) {
						itemIndex = row*rowLength+baseCol+col;
						if (itemIndex >= length) { break; }
						items.push(itemIndex);
					}
				}
			} else {
				rows++; // need to draw an extra row for scrolling.
				baseRow = _verticalScrollPosition/rowH<<0;
				if(_isUseFixed)
				{
					baseRow = _verticalScrollPosition/(rowH + verticalGap)<<0;
				}
				var startIndex:uint = Math.floor(baseRow*cols);
				var endIndex:uint = Math.min(length,startIndex+rows*cols);
				for (i=startIndex; i<endIndex; i++) {
					items.push(i);
				}
			}
			
			// create a dictionary for looking up the new "displayed" items:
			var itemHash:Dictionary = renderedItems = new Dictionary(true);
			for each (itemIndex in items) {
				itemHash[_dataProvider.getItemAt(itemIndex)] = true;    //储存需要显示的render
			}
			
			// find cell renderers that are still active, and make those that aren't active available:
			var itemToRendererHash:Dictionary = new Dictionary(true);    //重用对象
			while (activeCellRenderers.length > 0) {
				renderer = activeCellRenderers.pop();
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
			invalidItems = new Dictionary(true);    //无效的item
			
			i = 0; // count of items placed.
			// draw cell renderers:
			for each (itemIndex in items) {
				col = i%cols;
				row = i/cols<<0;
				
				var reused:Boolean = false;
				item = _dataProvider.getItemAt(itemIndex);
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
					renderer = getCellRenderer(getStyleValue("cellRenderer"));
					var rendererSprite:Sprite = renderer as Sprite;
					if (rendererSprite != null) {
						rendererSprite.addEventListener(MouseEvent.CLICK,handleCellRendererClick,false,0,true);
						rendererSprite.addEventListener(MouseEvent.ROLL_OVER,handleCellRendererMouseEvent,false,0,true);
						rendererSprite.addEventListener(MouseEvent.ROLL_OUT,handleCellRendererMouseEvent,false,0,true);
						rendererSprite.addEventListener(Event.CHANGE,handleCellRendererChange,false,0,true);
						rendererSprite.doubleClickEnabled = true;
						rendererSprite.addEventListener(MouseEvent.DOUBLE_CLICK,handleCellRendererDoubleClick,false,0,true);
						
						if (rendererSprite.hasOwnProperty("setStyle")) {
							for (var n:String in rendererStyles) {
								rendererSprite["setStyle"](n, rendererStyles[n])
							}
						}
					}
				}
				list.addChild(renderer as Sprite);
				activeCellRenderers.push(renderer);
				
				renderer.y = rowH*row + getTotalGap(row, _arrVGap, _verticalGap);
				renderer.x = colW*col + getTotalGap(col, _arrHGap, _horizontalGap);
				renderer.setSize(columnWidth,rowHeight);
				
				var label:String = itemToLabel(item);
				
				var icon:Object = null;
				if (_iconFunction != null) {
					icon = _iconFunction(item);
				} else if (_iconField != null && item && item.hasOwnProperty( _iconField )) {
					icon = item[_iconField];
				}
				
				var source:Object = null;
				if (_sourceFunction != null) {
					source = _sourceFunction(item);	
				} else if (_sourceField != null && item && item.hasOwnProperty( _sourceField ) ) {
					source = item[_sourceField];
				}
				
				if (!reused) {
					renderer.data = item;
				}
				
				renderer.listData = new TileListData(label,icon,source,this,itemIndex,baseRow+row,baseCol+col) as ListData;
				
				renderer.selected = (_selectedIndices.indexOf(itemIndex) != -1);
				
				// force an immediate draw (because render event will not be called on the renderer):
				if (renderer is UIComponent) {
					var rendererUIC:UIComponent = renderer as UIComponent;
					rendererUIC.drawNow();
				}
				i++;
			}
		}
		
		protected function getCellRenderer(skin:Object):ICellRenderer
		{
			if(skin is Class)
			{
//				var skinInst:ICellRenderer = new skin() as ICellRenderer;
				var skinInst:DisplayObject = UICompomentPool.getUICompoment(skin as Class) as DisplayObject;
				if(skinInst is IFrUIContainer)
				{
					(skinInst as IFrUIContainer).createDisposedChildren();
				}
				return skinInst as ICellRenderer;
			}
			return getDisplayObjectInstance(skin) as ICellRenderer;
		}
		
		/**
		 * 为了解决物品闪的问题而添加（add by wyang) 
		 * 如果直接设置dataprovider，即使数据完全一样，都会先清掉再填充的，所以改用replace的方式
		 * @param arg0 
		 * 
		 */		
		
		override public function set dataProvider(arg0:DataProvider):void
		{		
			if(super.dataProvider)
			{
				var vlen:int = Math.max(super.dataProvider.length,  arg0.length);
				for(var i:int = 0; i < vlen; i++)
				{
					if(i > (super.dataProvider.length - 1) && i <= (arg0.length - 1))
					{
						super.dataProvider.addItemAt(arg0.getItemAt(i), i);
					}
					else if(i > (arg0.length - 1))
					{
						super.dataProvider.removeItemAt(arg0.length);
					}
					else
					{
						var vItemOld:Object = this.dataProvider.getItemAt(i);
						var vItemNew:Object = arg0.getItemAt(i);
						super.dataProvider.replaceItemAt(vItemNew, i);
						//this.replaceItemAt(vItemNew, i);
						invalidateItemAt(i);
					}	
				}
			}
			else
			{
				super.dataProvider = arg0;
			}
			
		}
		
		override public function itemToLabel(item:Object):String {
			if (_labelFunction != null) {
				return String(_labelFunction(item));
			} else {
				if (_labelField == null || item == null || item.hasOwnProperty(_labelField) == false) { return ""; }
				return String(item[_labelField]);
			}
		}
		
		private var _isDraw:Boolean = false;
		override protected function _invalidateList():void
		{
			if( _isDraw )
			{
				super._invalidateList();
			}
			else
			{
				for (var i:int = 0; i < _dataProvider.length; i++) 
				{
					invalidateItem(_dataProvider.getItemAt(i));
				}
				invalidate(InvalidationType.DATA);
			}
		}
		
		override protected function keyDownHandler(arg0:KeyboardEvent):void
		{
			
		}
		override protected function keyUpHandler(arg0:KeyboardEvent):void
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
		
//		public function dispose(isReuse:Boolean=true):void
//		{
//			return;
//			//			var i:int;
//			//			var obj:Object;
//			//			/** 清理cellRenderer */
//			//			for(i = 0;i < dataProvider.length;i++)
//			//			{
//			//				obj = this.itemToCellRenderer(this.dataProvider.getItemAt(0));
//			//				if(obj is IDispose)
//			//				{
//			//					(obj as IDispose).dispose();
//			//				}
//			//			}
//			
//			ObjEventListerTool.delObjEvent(this);
//			
//			/** 清理子对象 */
//			//			var childrenLength:int = this.numChildren;
//			//			var o:DisplayObject;
//			//			for(i = childrenLength - 1;i>=0;i-- )
//			//			{
//			//				o = this.getChildAt(i);
//			//				if(o is IDispose)
//			//				{
//			//					this.removeChild(o);
//			//					(o as IDispose).dispose(isReuse);
//			//				}
//			//			}
//			if(this.parent)
//			{
//				this.parent.removeChild(this);
//			}
//			if(isReuse)
//			{
//				UICompomentPool.disposeUICompoment(this);
//			}
//		}
		
		
		public function disposeRender():void
		{
			if(_dataProvider)
			{
				_dataProvider.removeAll();
			}
			var renderer:ICellRenderer;
//			var arryTotal:Array = ArrayUtil.add(activeCellRenderers,availableCellRenderers);
//			while (arryTotal.length > 0) 
//			{
//				renderer = arryTotal.pop();
//				removeRenderEventListener(renderer as Sprite);
//				if(renderer is IDispose)
//				{
//					(renderer as IDispose).dispose();
//				}
//				else
//				{
//					if((renderer as DisplayObject).parent)
//					{
//						(renderer as DisplayObject).parent.removeChild((renderer as DisplayObject));
//					}
//				}
//			}
//			activeCellRenderers = new Array();
//			availableCellRenderers = new Array();
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
		
		override protected function handleCellRendererClick(event:MouseEvent):void 
		{
			if(!isCanSelect)
			{
				return;
			}
			else
			{
				super.handleCellRendererClick(event);
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
		
		public function dispose(isReuse:Boolean=true):void
		{
			disposeRender();
			renderedItems = new Dictionary(true);
			invalidItems = new Dictionary(true);
			_horizontalScrollPosition = 0;
			_verticalScrollPosition = 0;
			ObjEventListerTool.delObjEvent(this);
			isCanSelect = true;
			this.mouseEnabled = true;
			this.mouseChildren = true;
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