package mortal.game.view.market.sale
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class MktBag extends GSprite
	{
		private var _bg:ScaleBitmap;
		private var _bgTitle:ScaleBitmap;
		private var _title:GBitmap;
		private var _list:GTileList;
		/**分页导航*/
		private var _pageTabBar:GTabBar;
		/**分页标题数据*/
		private var _bagPageData:Array;
		
		private var _spMoneys:MktMoneys;
		
		/** 选中效果 */
		private var _selectSp:ScaleBitmap;
		private var _selectItemData:ItemData;
		public function MktBag()
		{
			super();
			
			init();
		}
		
		private function init():void
		{
			_bagPageData = [{"label":"1","name":"page1"},{"label":"2","name":"page2"},{"label":"3","name":"page3"},{"label":"4","name":"page4"}]
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			_bg = UIFactory.bg(0,0,310,333,this);
			_bgTitle = UIFactory.bg(0,0,310,25,this,"RegionTitleBg");
			_title = UIFactory.bitmap(ImagesConst.market1,0,0,this);
			_title.x = (_bgTitle.width-_title.width)/2;
			_title.y = (_bgTitle.y+_bgTitle.height-_title.height)/2;
			
			//背包格子部分
			_list = UIFactory.tileList(4,27,305,305,this);
			_list.rowHeight = 43;
			_list.columnWidth = 43;
			_list.horizontalGap = 0;
			_list.verticalGap = 0;
			_list.setStyle("cellRenderer", MktBagItemRenderer);
			_list.rowCount = 7;
			_list.columnCount = 7;
			
			_selectSp = UIFactory.bg(0,0,45,45,_list,ImagesConst.selectFilter);
			_selectSp.visible = false;
			
			
			//分页 "PageBtn"
			_pageTabBar = UIFactory.gTabBar(2,333,_bagPageData,20,20,this,pageChangeHandler,"PageBtn");
			_pageTabBar.selectedIndex = 0;
			
			_spMoneys = UICompomentPool.getUICompoment(MktMoneys);
			_spMoneys.createDisposedChildren();
			_spMoneys.x = 40;
			_spMoneys.y = 355;
			addChild(_spMoneys);

			Dispatcher.addEventListener(EventName.MarketRemoveSaleItem,onRemoveSeekItem);
			_list.configEventListener(Event.CHANGE,listSelectChange);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		private function onRemoveSeekItem(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			this._selectItemData = null;
			if(_list)
			{
				_list.selectedIndex  = -1;
				listSelectChange(null);
			}
		}
		
		private function listSelectChange(e:Event):void
		{
			// TODO Auto Generated method stub
			if(_list.selectedIndex == -1)
			{
				setSelectSpPos(null);
				return;
			}
			
			var obj:Object = _list.selectedItem;
			var m:MktBagItemRenderer;
			if(obj is ItemData)
			{
				m = _list.itemToCellRenderer(obj) as MktBagItemRenderer;
				_selectItemData = obj as ItemData;
				Dispatcher.dispatchEvent(new DataEvent(EventName.MarketPushSaleItem,obj));
				setSelectSpPos(m);
			}
		}
		
		private function setSelectSpPos(m:MktBagItemRenderer):void
		{
			if(m != null)
			{
				_selectSp.x = m.x - 2;
				_selectSp.y = m.y - 2;
				_selectSp.visible = true;
				_list.addChild(_selectSp);
			}
			else
			{
				_selectSp.visible = false;
			}
		}
		
		protected function onAddToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFormStage);
			updateMktBag();
			
			NetDispatcher.addCmdListener(ServerCommand.BackpackDataChange, updateMktBag);
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemsChange, updateMktBag);
		}
		
		protected function onRemoveFormStage(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFormStage);
			NetDispatcher.removeCmdListener(ServerCommand.BackpackDataChange, updateMktBag);
			NetDispatcher.removeCmdListener(ServerCommand.BackPackItemsChange, updateMktBag);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_selectItemData = null;
			
			_bg.dispose(isReuse);
			_bgTitle.dispose(isReuse);
			_title.dispose(isReuse);
			_selectSp.dispose(isReuse);
			_list.dispose(isReuse);
			_pageTabBar.dispose(isReuse);
			_spMoneys.dispose(isReuse);
			
			
			_bg =  null;
			_bgTitle =  null;
			_title =  null;
			_selectSp =  null;
			_list =  null;
			_pageTabBar =  null;
			_spMoneys =  null;
		}
		
		private function pageChangeHandler(e:MuiEvent):void
		{
			updateMktBag();
			
			
			//还原选中
			_list.selectedIndex = -1;
			var data:ItemData;
			if(_selectItemData)
			for (var i:int = 0; i < _list.dataProvider.length; i++) 
			{
				data = _list.getItemAt(i) as ItemData;
				if(data && data.itemCode == _selectItemData.itemCode)
				{
					_list.selectedIndex = i;
					break;
				}
			}
			var m:MktBagItemRenderer;
			m = _list.itemToCellRenderer(data) as MktBagItemRenderer;
			setSelectSpPos(m);
		}
		
		public function updateMktBag(e:Object = null):void
		{
			_list.dataProvider = getDataProvider();
			_list.drawNow();
		}
		
		/**从缓存中获取物品数据**/
		private function getDataProvider():DataProvider
		{
			var dp:DataProvider = new DataProvider();
			var items:Array;
			var count:int = _list.rowCount * _list.columnCount;
			var startIndex:int = _pageTabBar.selectedIndex * count;
			var endIndex:int = startIndex + count;
			
			if (Cache.instance.pack.backPackCache && Cache.instance.pack.backPackCache.sbag)
			{
				items = Cache.instance.pack.backPackCache.getAllItemsCanSaleMarket();
			}
					
			for (var j:int = startIndex; j < endIndex; j++)
			{
				if(items && items[j])
				{
					dp.addItem(items[j]);
				}
				else
				{
					dp.addItem(new Object());
				}
			}
			return dp;
		}
	}
}