/**
 * @date 2012-11-28 上午11:09:27
 * @author chenriji
 * 
 **/
package mortal.game.view.common.pageSelect
{
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GTileList;
	
	import fl.controls.ScrollPolicy;
	import fl.controls.listClasses.CellRenderer;
	import fl.data.DataProvider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.renderers.PageItemRenderer;
	
	/**
	 * * 带有一个页码选择器，一个GTileList, 默认的显示是物品PageItemRenderer,
	 * 可以自己定制pageSelector， 自定制GTileList， 切换页码将自动更新显示,
	 * 如果要相应点击item事件， 请自定义CellRender，或者在PageItemRenderer中添加
	 * 
	 */	
	public class PageSelectCenter extends Sprite
	{
		private var _pageSelecter:PageSelecter;
		private var _list:GTileList;
		private var _pageSize:int;
		private var _data:Array;
		private var _dataProvider:DataProvider;
		private var _isShowNull:Boolean;
		private var _nullValue:int;
		
		public function PageSelectCenter(pageSize:int=4, isShowNull:Boolean=false, nullValue:int=-1, cellRender:Object=null, pageSelecter:PageSelecter=null)
		{
			super();
			
			_pageSize = pageSize;
			_isShowNull = isShowNull;
			_nullValue = nullValue;
			
			initPageSelector(pageSelecter);
			
			initList(cellRender);
			
			_pageSelecter.addEventListener(Event.CHANGE, pageChangeHandler);
		}
		
		/**
		 * 更新数据 
		 * @param data
		 * 
		 */		
		public function updateData(data:Array):void
		{
			_data = data;
			if(data != null)
			{
				_pageSelecter.maxPage = Math.ceil(data.length/_pageSize);
			}
			_pageSelecter.currentPage = 1;
			pageChangeHandler(null);
		}

		public function get list():GTileList
		{
			return _list;
		}

		public function get pageSelecter():PageSelecter
		{
			return _pageSelecter;
		}
		
		/**
		 * 初始化页码选择器
		 */
		private function initPageSelector(pageSelecter:PageSelecter=null):void
		{
			if(pageSelecter != null)
			{
				_pageSelecter = pageSelecter;
				this.addChild(_pageSelecter);
				return;
			}
			_pageSelecter = new PageSelecter();
			this.addChild(_pageSelecter);
			_pageSelecter.mode = PageSelecter.SingleMode;
			_pageSelecter.move(42, 53);
			_pageSelecter.maxPage = 1;
			_pageSelecter.currentPage = 1;
		}
		
		/**
		 * 初始化显示列表
		 */
		private function initList(cellRender:Object):void
		{
			_list = UIFactory.tileList(0, 0, 160, 34, this);
			_list.direction = GBoxDirection.HORIZONTAL;
			_list.rowCount = 4;
			_list.columnWidth = 36;
			_list.horizontalGap = 4;
			_list.scrollPolicy = ScrollPolicy.OFF;
			if(cellRender == null)
			{
				_list.setStyle("cellRenderer", PageItemRenderer);
			}
			else
			{
				_list.setStyle("cellRenderer", cellRender);
			}
		}
		
		private function pageChangeHandler(evt:Event):void
		{
			if(_data == null)
			{
				return;
			}
			var curPage:int = _pageSelecter.currentPage;
			var sIndex:int = (curPage - 1) * _pageSize;
			
			var dataProvider:DataProvider = new DataProvider();
			for(var i:int = sIndex; i < sIndex + _pageSize; i++)
			{
				if(i >= _data.length)
				{
					if(_isShowNull)
					{
						dataProvider.addItem(_nullValue);
					}
				}
				else
				{
					dataProvider.addItem(_data[i]);
				}
			}
			
			_list.dataProvider = dataProvider;
			_list.drawNow();
		}
	}
}