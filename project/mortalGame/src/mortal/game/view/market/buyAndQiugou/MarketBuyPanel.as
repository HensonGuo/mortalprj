package mortal.game.view.market.buyAndQiugou
{
	import Message.Game.EMarketOrder;
	import Message.Game.EMarketRecordType;
	import Message.Game.SMarketItem;
	import Message.Game.SMoney;
	
	import com.gengine.debug.Log;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.GCatogeryList.GCatogeryList;
	import mortal.game.cache.Cache;
	import mortal.game.cache.MarketCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.TextInputList;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.common.util.MoneyUtil;
	import mortal.game.view.market.MktModConfig;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	import mx.utils.StringUtil;
	
	/**
	 * 市场，购买、求购主界面
	 * @author lizhaoning
	 */
	public class MarketBuyPanel extends GSprite
	{
		//上部分
		private var _topPartContainer:GSprite;
		private var _txtSearch:TextInputList;
		private var _btnMagnifier:GLoadingButton;
		private var _comboLevel:GComboBox;
		private var _comboColor:GComboBox;
		private var _comboCareer:GComboBox;
		private var _btnSearch:GButton;
		private var _btnReset:GButton;
		
		//左边部分
		private var _leftPartContainer:GSprite;
		private var _bgLeft:ScaleBitmap;
		private var _leftList:GCatogeryList;
		private var _bgMoney:ScaleBitmap;
		private var _txtMyGlod:GTextFiled;
		private var _txtMyCoin:GTextFiled;
		private var _txtNumGlod:GTextFiled;
		private var _txtNumCoin:GTextFiled;
		private var _bmpGlod:GBitmap;
		private var _bmpCoin:GBitmap;
		
		
		//右边部分
		private var _rightPartContainer:GSprite;
		private var _bgRight:ScaleBitmap;
		private var _buyList:MktBuyList;
		private var _qiugouList:MktQiugouList;
		private var _pageSelect:PageSelecter;
		
		
		protected var _tfBai:GTextFormat;
		protected var _tfHuang:GTextFormat;
		
		/** 1、市场购买  2、市场求购 */
		private var _buyOrQiugou:int = 0;
		
		public function MarketBuyPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			_tfBai = GlobalStyle.textFormatBai;
			_tfBai.align = TextFormatAlign.LEFT;
			_tfHuang = GlobalStyle.textFormatJiang;
			_tfHuang.align = TextFormatAlign.RIGHT;
			
			addLeftPart();
			addTopPart();
			addRightPart();
			
			NetDispatcher.addCmdListener(ServerCommand.MarketSearchBack,searchBack);
			NetDispatcher.addCmdListener(ServerCommand.MarketResultBuyItem,buyItemBack);
			Dispatcher.addEventListener(EventName.MarketClickSortUp,sort);
			Dispatcher.addEventListener(EventName.MarketClickSortDown,sort);
			Dispatcher.addEventListener(EventName.MarketSearchClickName,clickItemName);
			Dispatcher.addEventListener(EventName.MarketClickType,clickItemNameMarketType);
		}
		
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			searchConditions = null;
			
			NetDispatcher.removeCmdListener(ServerCommand.MarketSearchBack,searchBack);
			NetDispatcher.removeCmdListener(ServerCommand.MarketResultBuyItem,buyItemBack);
			Dispatcher.removeEventListener(EventName.MarketClickSortUp,sort);
			Dispatcher.removeEventListener(EventName.MarketClickSortDown,sort);
			Dispatcher.removeEventListener(EventName.MarketSearchClickName,clickItemName);
			
			removeLeftPar(isReuse);
			removeTopPar(isReuse);
			removeRightPar(isReuse);
		}
		
		private function addTopPart():void
		{
			_topPartContainer = UIFactory.getUICompoment(GSprite,15,60,this); 
			
			_txtSearch = UIFactory.getUICompoment(TextInputList,5,7,_topPartContainer); 
			_txtSearch._textInput.textField.width -= 25;
			_txtSearch.init(onSearchTxtChange);
			_btnMagnifier = UIFactory.gLoadingButton(ResFileConst.SearchBtn,_txtSearch.x+_txtSearch._textInput.width-21,_txtSearch.y+2,19,19,_topPartContainer);
			_comboLevel = UIFactory.gComboBox(232,7,98,22,null,_topPartContainer);
			_comboLevel.dataProvider = MktModConfig.dpLevel.clone();
			_comboColor = UIFactory.gComboBox(338,7,98,22,null,_topPartContainer);
			_comboColor.dataProvider = MktModConfig.dpColor.clone();
			_comboCareer = UIFactory.gComboBox(442,7,98,22,null,_topPartContainer);
			_comboCareer.dataProvider = MktModConfig.dpCareer.clone();
			
			_btnSearch = UIFactory.gButton("搜索",550,7,55,22,_topPartContainer);
			_btnReset = UIFactory.gButton("重置",605,7,55,22,_topPartContainer);
			
			_btnMagnifier.configEventListener(MouseEvent.CLICK,clickHandler);
			_btnSearch.configEventListener(MouseEvent.CLICK,clickHandler);
			_btnReset.configEventListener(MouseEvent.CLICK,clickHandler);
			
			reset();
		}
		
		private function removeTopPar(isReuse:Boolean):void
		{
			_txtSearch.dispose(isReuse);
			_btnMagnifier.dispose(isReuse);
			_comboLevel.dispose(isReuse);
			_comboColor.dispose(isReuse);
			_comboCareer.dispose(isReuse);
			_btnSearch.dispose(isReuse);
			_btnReset.dispose(isReuse);
			_topPartContainer.dispose(isReuse);
			
			_txtSearch = null;
			_btnMagnifier = null;
			_comboLevel = null;
			_comboColor = null;
			_comboCareer = null;
			_btnSearch = null;
			_btnReset = null;
			_topPartContainer = null;
		}
		
		private function addLeftPart():void
		{
			_leftPartContainer = UIFactory.getUICompoment(GSprite,15,92,this);
			
			_bgLeft = UIFactory.bg(0,0,190,414,_leftPartContainer);
			
			_leftList = new GCatogeryList(175, 355);
			_leftList.x = 8;
			_leftList.y = 4;
			_leftList.tileList.direction = GBoxDirection.VERTICAL;
			_leftList.tileList.columnWidth = 175;
			_leftList.tileList.columnCount = 1;
			//_leftList.tileList.horizontalGap = 4;
			_leftList.headGap = 0;
			_leftPartContainer.addChild(_leftList);
			
			_bgMoney = UIFactory.bg(0,355,180,50,_leftPartContainer,ImagesConst.TextBg);
			_txtMyGlod = UIFactory.textField("我的元宝:",14,361,70,20,_leftPartContainer,_tfBai);
			_txtMyCoin = UIFactory.textField("我的铜钱:",14,380,70,20,_leftPartContainer,_tfBai);
			_txtNumGlod = UIFactory.textField("99999",74,361,70,20,_leftPartContainer,_tfHuang);
			_txtNumCoin = UIFactory.textField("1000",74,380,70,20,_leftPartContainer,_tfHuang);
			
			_bmpGlod = UIFactory.bitmap(ImagesConst.Yuanbao,145,366,_leftPartContainer);
			_bmpCoin = UIFactory.bitmap(ImagesConst.Jinbi,145,382,_leftPartContainer);
			
			
			//Dispatcher.addEventListener(EventName.MarketSearch, clickLeftListTypeHandler);
			NetDispatcher.addCmdListener(ServerCommand.MoneyUpdate, updateMoney);
			
			initLeftList();
			updateMoney();
		}
		
		private function removeLeftPar(isReuse:Boolean):void
		{
			//Dispatcher.removeEventListener(EventName.MarketSearch, clickLeftListTypeHandler);
			NetDispatcher.removeCmdListener(ServerCommand.MoneyUpdate, updateMoney);
			
			_bgLeft.dispose(isReuse);
			_leftList.dispose(isReuse);
			_bgMoney.dispose(isReuse);
			_txtMyGlod.dispose(isReuse);
			_txtMyCoin.dispose(isReuse);
			_txtNumGlod.dispose(isReuse);
			_txtNumCoin.dispose(isReuse);
			_bmpGlod.dispose(isReuse);
			_bmpCoin.dispose(isReuse);
			_leftPartContainer.dispose(isReuse);
			
			_bgLeft = null;
			_leftList = null;
			_bgMoney = null;
			_txtMyGlod = null;
			_txtMyCoin = null;
			_txtNumGlod = null;
			_txtNumCoin = null;
			_bmpGlod = null;
			_bmpCoin = null;
			_leftPartContainer = null;
		}
		
		private function addRightPart():void
		{
			_rightPartContainer = UIFactory.getUICompoment(GSprite,205,92,this);
			
			_bgRight = UIFactory.bg(0,0,474,414,_rightPartContainer);
			
			_pageSelect = UIFactory.pageSelecter(174,385,_rightPartContainer,PageSelecter.CompleteMode);
			_pageSelect.setbgStlye(ImagesConst.ComboBg,new GTextFormat);
			_pageSelect.maxPage = 1;
			_pageSelect.pageTextBoxSize = 36;
			_pageSelect.configEventListener(Event.CHANGE,onPageChange);
		}
		
		private function removeRightPar(isReuse:Boolean):void
		{
			_bgRight.dispose(isReuse);
			_pageSelect.dispose(isReuse);
			if(_qiugouList)
			{
				_qiugouList.dispose(isReuse);
				_qiugouList.visible = true;
				_qiugouList = null;
			}
			if(_buyList)
			{
				_buyList.dispose(isReuse);
				_buyList.visible = true;
				_buyList = null;
			}
			_rightPartContainer.dispose(isReuse);
			
			_bgRight = null;
			_pageSelect = null;
			_rightPartContainer = null;
		}
		
		public function initLeftList():void
		{
			var arr:Array = MktModConfig.arrItemType;
			
			_leftList.createHeads(MktCatogeryHead, arr, 175, 23);
			_leftList.setCellRender(0, MktCatogeryRenderer, true);
			_leftList.setCellHeight(0, 21, true);
			
			for (var j:int = 0; j < MktModConfig.arrItemType.length; j++) 
			{
				_leftList.setDataProvider(j,MktModConfig.getdpItemType2(j+1));
			}
		}
		
		private function onSearchTxtChange():void
		{
			if(_txtSearch._textInput.text.length >= 2)
			{
				_txtSearch.updateDataProvider(getTxtListDp());
			}
		}
		private function clickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(e.currentTarget == _btnMagnifier)
			{
//				if(StringUtil.isWhitespace(this._txtSearch._textInput.text) == false)
				searchByName();
			}
			else if(e.currentTarget == _btnSearch)
			{
				searchByConditions();
			}
			else if(e.currentTarget == _btnReset)
			{
				reset();
			}
		}
		
		/** 点击重置按钮的时候调用 */
		private function reset():void
		{
			_comboLevel.selectedIndex = 0;
			_comboColor.selectedIndex = 0;
			_comboCareer.selectedIndex = 0;
			_leftList.unexpandAllItem();
		}
		
		/** 切换标签的时候调用 */
		public function resetAll():void
		{
			reset();
			this._pageSelect.currentPage = 1;
		}
		
		private function onPageChange(e:Event):void  //翻页
		{
			searchConditions.targetPage = this._pageSelect.currentPage;
			search();
		}
		
		private function sort(e:DataEvent):void
		{
			if(e.type == EventName.MarketClickSortUp)
			{
				if(buyOrQiugou == 1)
					searchConditions.order = EMarketOrder._EMarketOrderUnitPriceAsc;
				else
					searchConditions.order = EMarketOrder._EMarketOrderAsc;
			}
			else if(e.type == EventName.MarketClickSortDown)
			{
				if(buyOrQiugou == 1)
					searchConditions.order = EMarketOrder._EMarketOrderUnitPriceDesc;
				else
					searchConditions.order = EMarketOrder._EMarketOrderDesc;
			}
			else
			{
				return;
			}
			search();
		}
		
		/** 点击物品名字搜索 */
		private function clickItemName(e:DataEvent):void
		{
			var mktItem:SMarketItem = e.data as SMarketItem;
			if(mktItem != null)
			{
				searchByName([mktItem.code]);
			}
		}
		/** 点击左边道具分类列表 */
		private function clickItemNameMarketType(e:DataEvent):void
		{
			//var data:Object = e.data;
			searchByItemType(e.data.tMarket.marketId);
		}
		
		/** 名字 搜索  */
		private function searchByName(codes:Array = null):void
		{
			var obj:Object = {};
			obj.recordType = marketRecordType;
			obj.marketId = -1;
			
			if(codes == null)
			{
				if(_txtSearch.selectdata == null)
				{
					MsgManager.showRollTipsMsg("请输入正确的道具名字");
					return ;
				}
				obj.codes = [(_txtSearch.selectdata as ItemInfo).code];
			}
			else
			{
				obj.codes = codes;
			}
			
			obj.targetPage = 1;
			obj.levelLower = this._comboLevel.getItemAt(0).min;
			obj.levelUpper = this._comboLevel.getItemAt(0).max;
			obj.color = this._comboColor.getItemAt(0).color;
			obj.career = this._comboCareer.getItemAt(0).career;
			obj.order = EMarketOrder._EMarketOrderNormal;
			
			searchConditions = obj;
			search();
		}
		
		/** 按物品类型搜索 */
		private function searchByItemType(marketId:int = -1):void
		{
			var obj:Object = {};
			obj.recordType = marketRecordType;
			if(marketId != -1)
			{
				obj.marketId = marketId;
			}
			else
			{
				if(this._leftList.tileList.dataProvider.length>0 && this._leftList.tileList.selectedItem)
				{
					obj.marketId = this._leftList.tileList.selectedItem.tMarket.marketId;
				}
				else
				{
					obj.marketId = -1;
				}
			}
			
			
			obj.codes = new Array();
			obj.targetPage = 1;
			obj.levelLower = this._comboLevel.getItemAt(0).min;
			obj.levelUpper = this._comboLevel.getItemAt(0).max;
			obj.color = this._comboColor.getItemAt(0).color;
			obj.career = this._comboCareer.getItemAt(0).career;
			obj.order = EMarketOrder._EMarketOrderNormal;
			
			searchConditions = obj;
			search();
		}
		
		/** 按条件 搜索  */
		private function searchByConditions():void
		{
			var obj:Object = {};
			
			/*recordType : int , marketId : int , codes : Array , targetPage : int , 
			levelLower : int , levelUpper : int , color : int , career : int , 
			order : int , playerName : String */
			
			obj.recordType = marketRecordType;
			obj.marketId = -1;
			obj.codes = new Array();
			obj.targetPage = 1;
			obj.levelLower = this._comboLevel.selectedItem.min;
			obj.levelUpper = this._comboLevel.selectedItem.max;
			obj.color = this._comboColor.selectedItem.color;
			obj.career = this._comboCareer.selectedItem.career;
			obj.order = EMarketOrder._EMarketOrderNormal;
			obj.playerName = "";
			
			searchConditions = obj;
			search();
		}
		
		private var searchConditions:Object;
		public function search():void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketSearch,searchConditions));
		}
		
		
		private function buyItemBack(e:Object):void
		{
			// TODO Auto Generated method stub
			search();
		}
		private function searchBack(e:Object):void
		{
			// TODO Auto Generated method stub
			updateList();
		}
		
		private function updateList():void
		{
			if(Cache.instance.market.marketItemObj.marketItems.length==0)
			{
				MsgManager.showRollTipsMsg("不存在符合条件的信息");
			}
			if(buyOrQiugou  == 1  && Cache.instance.market.marketItemObj.recordType == EMarketRecordType._EMarketRecordSell)
			{
				
				this._buyList.update();
			}
			else  if(buyOrQiugou  == 2  && Cache.instance.market.marketItemObj.recordType == EMarketRecordType._EMarketRecordSeekBuy)
			{
				this._qiugouList.update();
			}
			this._pageSelect.currentPage = Cache.instance.market.marketItemObj.targetPage;
			this._pageSelect.maxPage = Cache.instance.market.marketItemObj.totalPage;
		}
		
		/**
		 *更新金钱
		 * @param obj
		 */
		private function updateMoney(obj:Object = null):void
		{
			var smoney:SMoney=Cache.instance.role.money;
			_txtNumCoin.htmlText = MoneyUtil.getCoinHtml(smoney.coin);
			_txtNumGlod.htmlText = MoneyUtil.getCoinHtml(smoney.gold);
		}
		
		private function get marketRecordType():int
		{
			if(buyOrQiugou  == 1)
			{
				return EMarketRecordType._EMarketRecordSell;
			}
			else if(buyOrQiugou  == 2)
			{
				return EMarketRecordType._EMarketRecordSeekBuy;
			}
			return 0;
		}
		
		/**
		 * 1、市场购买  2、市场求购 
		 */
		public function get buyOrQiugou():int
		{
			return _buyOrQiugou;
		}
		
		/**
		 * @private
		 */
		public function set buyOrQiugou(value:int):void
		{
			_buyOrQiugou = value;
			
			resetAll();
			
			if(buyOrQiugou == 1)
			{
				if(_qiugouList)
				{
					_qiugouList.visible = false;
				}
				
				if(_buyList  == null)
				{
					_buyList = UIFactory.getUICompoment(MktBuyList,0,0,_rightPartContainer);
				}
				_buyList.visible = true;
				_rightPartContainer.addChild(_buyList);
				Log.debug("-----_buyList",_buyList.mouseEnabled,_buyList.mouseChildren);
			}
			else if(buyOrQiugou == 2)
			{
				if(_buyList)
				{
					_buyList.visible  = false;
				}
				
				if(_qiugouList  == null)
				{
					_qiugouList = UIFactory.getUICompoment(MktQiugouList,0,0,_rightPartContainer);
				}
				_qiugouList.visible = true;
				_rightPartContainer.addChild(_qiugouList);
				Log.debug("-----_qiugouList",_qiugouList.mouseEnabled,_qiugouList.mouseChildren);
			}
			
			searchByConditions();
		}
		
		private function getTxtListDp():DataProvider
		{
			var arr:Array = MarketCache.searchByName(_txtSearch._textInput.text);
			
			return new DataProvider(arr);
		}
	}
}