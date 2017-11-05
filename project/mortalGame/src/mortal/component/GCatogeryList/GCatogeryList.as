/**
 * 2014-2-14
 * @author chenriji
 **/
package mortal.component.GCatogeryList
{
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TweenMax;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	
	import fl.controls.listClasses.CellRenderer;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import mortal.common.DisplayUtil;
	import mortal.common.display.BitmapDataConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	
	public class GCatogeryList extends GSprite
	{
		private var _headContainer:GSprite;
		private var _pane:GScrollPane;
		private var _content:GSprite;
		
		private var _list:GTileList;
		
		private var _topPoint:GBitmap;
		private var _downPoint:GBitmap;
		
		private var _heads:Array;
		
		// 当前选择的item
		private var _selectedItem:ICatogeryListHead;
		
		// 属性
		private var _myWidth:int;
		private var _myHeight:int;
		
		private var _tweening:Boolean = false;
		
		////////////////////////////////////////////////////  head 之间的间距
		private var _headGap:int = 1;
		
		private var _nullDataProvider:DataProvider = new DataProvider();
		
		public function GCatogeryList($width:int, $height:int)
		{
			_myWidth = $width;
			_myHeight = $height;
			super();
			
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		public function get headGap():int
		{
			return _headGap;
		}

		public function set headGap(value:int):void
		{
			_headGap = value;
		}

		public function createHeads(render:Class, datas:Array, headWidth:int, headHeight:int):void
		{
			_heads = [];
			for(var i:int = 0; i < datas.length; i++)
			{
				var head:ICatogeryListHead = new render() as ICatogeryListHead;
				head.index = i;
				head.setSize(headWidth, headHeight);
				head.updateData(datas[i]);
				head.y = (headHeight + _headGap) * i;
				_headContainer.addChild(head as DisplayObject);
				_heads[i] = head;
				
				GSprite(head).configEventListener(MouseEvent.CLICK, clickHeadItemHandler);
			}
		}
		
		private function clickHeadItemHandler(evt:MouseEvent):void
		{
			var target:ICatogeryListHead = evt.currentTarget as ICatogeryListHead;
			if(target.isExpanding)
			{
				unexpandItem(target.index);
			}
			else
			{
				expandItem(target.index);
			}
		}
		
		public function setDataProvider(index:int, data:DataProvider):void
		{
			var item:ICatogeryListHead = _heads[index];
			if(item == null)
			{
				return;
			}
			item.dataProvider = data;
			
		}
		
		public function setCellRender(index:int, cellrender:Class, isAllTheSame:Boolean=false):void
		{
			var item:ICatogeryListHead;
			if(isAllTheSame)
			{
				for(var i:int = 0; i < _heads.length; i++)
				{
					item = _heads[i];
					item.cellRender = cellrender;
				}
			}
			else
			{
				item = _heads[index];
				if(item == null)
				{
					return;
				}
				item.cellRender = cellrender;
			}
			
		}
		
		public function setCellHeight(index:int, cellHeight:int, isAllTheSame:Boolean=false):void
		{
			var item:ICatogeryListHead;
			if(isAllTheSame)
			{
				for(var i:int = 0; i < _heads.length; i++)
				{
					item = _heads[i];
					item.cellHeight = cellHeight;
				}
			}
			else
			{
				item = _heads[index];
				if(item == null)
				{
					return;
				}
				item.cellHeight = cellHeight;
			}
		}
		
		
		/**
		 * 展开某一项 
		 * @param index
		 * 
		 */		
		public function expandItem(index:int):void
		{
			if(index >= _heads.length || _tweening)
			{
				return;
			}
			if(_selectedItem != null)
			{
				_selectedItem.unexpand();
			}
			_selectedItem = _heads[index] as ICatogeryListHead;
			_selectedItem.expand();
//			_list.setStyle("skin", new Bitmap());
			_list.setStyle("cellRenderer", _selectedItem.cellRender);
			_list.dataProvider = _selectedItem.dataProvider;
			_list.selectedIndex = -1;
			
			
			// 布局好上面的一个点、list、下面的一个点的位置， 就开始tweening
			var htop:int = DisplayObject(_selectedItem).height * (index + 1);
			var hList:int = _selectedItem.dataProvider.length * (_selectedItem.cellHeight);
			var hDown:int = DisplayObject(_selectedItem).height * (_heads.length - index - 1);
			_list.rowHeight = _selectedItem.cellHeight;
			
			
			
			// 设置好list的高度， 使得list没有滚动条
			_list.y = htop;
			_list.height = hList;
			_topPoint.y = 0;
			_content.addChild(_topPoint);
			_downPoint.y = _list.y + _list.height + hDown;
			
//			_list.scrollRect = new Rectangle(20, 20, 180, 200);
			
			
			_list.drawNow();
			
			// 开始tween////////////////////////////////////////////////////////////////////////////
			
			var item:DisplayObject;
			var targetY:int;
			// 1. 往上tween的
			for(var i:int = 0; i <= index; i++)
			{
				item = _heads[i] as DisplayObject;
				targetY = i*(item.height + _headGap);
				if(Math.abs(item.y - targetY) < 2)
				{
					continue;
				}
				TweenMax.to(item, 0.2, {"y":targetY});
				_tweening = true;
			}
			
			// 2. 往下面的
			var minHeight:int = Math.min(_myHeight, htop + hList + hDown + 2);
			for(; i < _heads.length; i++)
			{
				item = _heads[i] as DisplayObject;
				targetY = minHeight - (_heads.length - i) * (item.height + _headGap);
				if(Math.abs(item.y - targetY) < 2)
				{
					continue;
				}
				TweenMax.to(item, 0.2, {"y":targetY});
				_tweening = true;
			}
			
			var tweenTime:int = 250;
			if(_tweening)
			{
				tweenTime = 10;
			}
			_tweening = true;
			setTimeout(expandCompleted, tweenTime);
			_pane.verticalScrollPosition = 0;
		}
		private function expandCompleted():void
		{
			_tweening = false;
			_pane.source = _content;
			_pane.drawNow();
		}
		
		
		/**
		 * 收缩某项 
		 * @param index
		 * 
		 */		
		public function unexpandItem(index:int):void
		{
			if(index >= _heads.length || _tweening)
			{
				return;
			}

			var item:ICatogeryListHead = _heads[index];
			item.unexpand();
			
			_list.dataProvider = _nullDataProvider;
			_list.drawNow();
			_topPoint.y = 0;
			_list.y = 0;
			_downPoint.y = 0;
			_pane.source = _topPoint;
			
			_tweening = true;
			
			// 2. 往下面的
			for(var i:int = index + 1; i < _heads.length; i++)
			{
				var head:DisplayObject = _heads[i] as DisplayObject;
				var yy:int = i * (head.height + _headGap);
				TweenMax.to(head, 0.2, {"y":yy});
			}
			
			setTimeout(unExpandCompleted, 250);
			
			_selectedItem = null;
		}
		private function unExpandCompleted():void
		{
			_tweening = false;
//			_pane.source = _topPoint;
			_pane.drawNow();
		}
		
		/**
		 * 收缩全部项
		 */		
		public function unexpandAllItem():void
		{
			if(_selectedItem != null)
			{
				unexpandItem(_selectedItem.index);
			}
			this._list.selectedIndex = -1;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_pane = UIFactory.gScrollPanel(0, 2, _myWidth, _myHeight - 4, this);
			
			_headContainer = ObjectPool.getObject(GSprite);
			this.addChild(_headContainer);
			
			_content = new GSprite();
			_pane.source = _content;
			
			_topPoint = UIFactory.gBitmap(ImagesConst.SplitLine, 0, 0, _content);
			_topPoint.visible = false;
			_list = UIFactory.tileList(0, 0, _myWidth, _myHeight, _content);
			_list.columnWidth = _myWidth;
			_downPoint = UIFactory.gBitmap(ImagesConst.SplitLine, 0, 0, _content);
			_downPoint.visible = false;
			
		}
		
		public function get tileList():GTileList
		{
			return _list;
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);

			if(_heads != null)
			{
				for each(var item:DisplayObject in _heads)
				{
					DisplayUtil.removeMe(item);
				}
			}
			_heads = null;
			
			_headContainer.dispose(isReuse);
			_headContainer = null;
			
			_pane.dispose(isReuse);
			_pane = null;
			
			_content.dispose(isReuse);
			_content = null;
			
			_list.dispose(isReuse);
			_list = null;
			
			_selectedItem = null;
			
			_tweening = false;
			
			_topPoint.dispose(isReuse);
			_topPoint = null;
			_downPoint.dispose(isReuse);
			_downPoint = null;
		}
	}
}