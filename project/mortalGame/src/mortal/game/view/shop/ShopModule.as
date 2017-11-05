package mortal.game.view.shop
{
	import Message.DB.Tables.TShopSell;
	import Message.Game.SBuyBackItem;
	
	import com.gengine.utils.HTMLUtil;
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTileList;
	import com.mui.events.MuiEvent;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.CursorManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.npc.data.NpcFunctionData;
	import mortal.game.view.shopMall.data.ShopItemData;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class ShopModule extends BaseWindow
	{
		//数据
		private var _shopTabData:Array;
		
		private var _shopCode:int;
		
		private var _npcId:int;
		
		private var _showIndex:int = 10; //一页显示多少个物品
		
		//显示对象
		/**导航*/
		private var _tabBar:GTabBar;
		
		/**分页导航*/
		private var _pageSelecter:PageSelecter;
		
		/**商品列表*/
		private var _shopItemPanel:GTileList;
		
		/**回购列表*/
		private var _buyBackPanel:GTileList;
		
		private var _btnFix:GButton;
		
		private var _btnFixAll:GButton;
		
		private var _btnBuy:GButton;
		
		private var _btnSell:GButton;
		
		
		public function ShopModule($layer:ILayer=null)
		{
			super($layer);
			this.setSize(335,500);
		}
		
		override protected function updateWindowCenterSize(  ):void
		{
			if( _windowCenter )
			{
				var w:Number = this.width - paddingLeft-paddingRight;
				var h:Number = this.height -paddingBottom-_titleHeight - 25;
				_windowCenter.setSize(w,h);
				_windowCenter.x = paddingLeft;
				_windowCenter.y = _titleHeight + 25;
			}
			
			if (_windowCenter2)
			{
				_windowCenter2.x = _windowCenter.x + 4;
				_windowCenter2.y = _windowCenter.y + 5;
				_windowCenter2.width = _windowCenter.width - 10;
				_windowCenter2.height = _windowCenter.height - 10;
			}
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.bg(16,67,312,345,this,ImagesConst.WindowCenterB2));
			
			this.pushUIToDisposeVec(UIFactory.bg(16,378,312,72,this,ImagesConst.WindowCenterB2));
			
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30080),22,378,220,20,this,null,true));
			
			creatBuyBackItemBg();
			
			_tabBar = UIFactory.gTabBar(10,33,_shopTabData,72,25,this,tabBarChangeHandler);
			
			_shopItemPanel = UIFactory.tileList(24,74,300,270,this);
			_shopItemPanel.columnWidth = 145;
			_shopItemPanel.rowHeight = 50;
			_shopItemPanel.horizontalGap = 5;
			_shopItemPanel.verticalGap = 5;
			_shopItemPanel.setStyle("cellRenderer", ShopCellRenderer);
			
			_buyBackPanel = UIFactory.tileList(17,397,310,45,this);
			_buyBackPanel.columnWidth = 41;
			_buyBackPanel.rowHeight = 41;
			_buyBackPanel.horizontalGap = 10;
			_buyBackPanel.verticalGap = 10;
			_buyBackPanel.setStyle("cellRenderer", BuyBackCellRenderer);
			
			var fm:GTextFormat = GlobalStyle.textFormatBai;
			fm.align = AlignMode.CENTER;
			_pageSelecter = UIFactory.pageSelecter(118,348,this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg,fm);
			_pageSelecter.pageTextBoxSize = 50;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			_btnFix = UIFactory.gButton(Language.getString(30073),21,460,71,22,this);
			
			_btnFixAll = UIFactory.gButton(Language.getString(30074),101,460,71,22,this);
			
			_btnBuy = UIFactory.gButton(Language.getString(30068),227,460,41,22,this);
			
			_btnSell = UIFactory.gButton(Language.getString(30003),277,460,41,22,this);
		
			this.configEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_tabBar.dispose(isReuse);
			_shopItemPanel.dispose(isReuse);
			_pageSelecter.dispose(isReuse);
			_btnFix.dispose(isReuse);
			_btnFixAll.dispose(isReuse);
			_btnBuy.dispose(isReuse);
			_btnSell.dispose(isReuse);
			
			_tabBar = null;
			_shopItemPanel = null;
			_pageSelecter = null;
			_btnFix = null;
			_btnFixAll = null;
			_btnBuy = null;
			_btnSell = null;
			super.disposeImpl(isReuse);
		}
		
		private function creatBuyBackItemBg():void
		{
			for(var i:int ; i < 6 ; i++)
			{
				this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.PackItemBg,51*i + 22,402,this));
			}
		
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var targetGButton:GButton = e.target as GButton;
			
			switch(targetGButton)
			{
				case _btnBuy:
					CursorManager.currentCurSorType = CursorManager.BUY;
					CursorManager.showCursor(CursorManager.BUY);
					break;
				case _btnSell:
					CursorManager.currentCurSorType = CursorManager.SELL;
					CursorManager.showCursor(CursorManager.NO_CURSOR);
					break;
			}
		}
		
		private function onPageChange(e:Event = null):void
		{
			_shopItemPanel.dataProvider = getShopDataProvider();
		}
		
		private function tabBarChangeHandler(e:MuiEvent = null):void
		{
			_shopCode = _shopTabData[_tabBar.selectedIndex].name;
			_pageSelecter.maxPage =  Math.ceil(ShopConfig.instance.getShopItemByCode(_shopCode).length/_showIndex);
			_pageSelecter.currentPage = 1;
			onPageChange();
		}
		
		private function getShopDataProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var items:Vector.<TShopSell> = ShopConfig.instance.getShopItemByCode(_shopCode);
			if(items)
			{
				var starIndex:int = _showIndex * (_pageSelecter.currentPage - 1);
				var endIndex:int;
				if(_showIndex * _pageSelecter.currentPage <= items.length)
				{
					endIndex = _showIndex * _pageSelecter.currentPage;
				}
				else
				{
					endIndex = items.length;
				}
				
				for(var i:int = starIndex ; i < endIndex ; i++)
				{
					var shopPropData:ShopItemData = new ShopItemData(items[i]);
					var obj:Object = {"data":shopPropData,"npcId":_npcId};
					dataProvider.addItem(obj);
				}
			}
			return dataProvider;
		}
		
		public function updateTabBar(npcFunctionData:NpcFunctionData):void
		{
			_shopCode = npcFunctionData.value;
			_npcId = npcFunctionData.npcId;
			_shopTabData = ShopConfig.instance.getShopTabByCode(_shopCode);
			_tabBar.dataProvider = _shopTabData;
			tabBarChangeHandler();
		}
		
		public function set shopCode(code:int):void
		{
			_shopCode = code;
		}
		
		public function get shopCode():int
		{
			return _shopCode;
		}
		
		public function updateBuyBackList():void
		{
			var arr:Array = Cache.instance.shop.buyBackList;
			var dataProvider:DataProvider = new DataProvider();
			var buyBackItem:SBuyBackItem;
			for(var i:int = 0 ; i < 6 ; i++)
			{
				buyBackItem = arr[i];
				var obj:Object = {"data":buyBackItem};
				dataProvider.addItem(obj);
			}
			_buyBackPanel.dataProvider = dataProvider;
		}
	}
}