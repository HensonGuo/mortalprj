package mortal.game.view.market.qiugou
{
	import Message.DB.Tables.TMarket;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.cache.MarketCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.resource.tableConfig.MarketConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.TextInputList;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.market.MktModConfig;
	import mortal.game.view.market.sale.MktBagItemRenderer;
	import mortal.game.view.market.sale.MktMoneys;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * 我要求购右边面板
	 * @author lizhaoning
	 */
	public class MktQiugouRtPanel extends GSprite
	{
		private var _bg:ScaleBitmap;
		private var _bgTitle1:ScaleBitmap;
		private var _title1:GBitmap;
		private var _list:GTileList;
		private var _pageSelect:PageSelecter;
		
		private var _bgTitle2:ScaleBitmap;
		private var _title2:GBitmap;
		
		private var _line:ScaleBitmap;
		
		private var _txtSearch:TextInputList;
		private var _btnMagnifier:GLoadingButton;
		private var _txtType1:GTextFiled;
		private var _comboType1:GComboBox;
		private var _comboColor:GComboBox;
		private var _comboType2:GComboBox;
		private var _comboCareer:GComboBox;
		private var _comboLevel:GComboBox;
		
		
		private var _btnSearch:GButton;
		private var _btnReset:GButton;
		
		private var _moneys:MktMoneys;
		
		private var _searchCondition:Object;
		
		/** 选中效果 */
		private var _selectSp:ScaleBitmap;
		private var _selectItemInfo:ItemInfo;
		private var _selectPage:int;
		public function MktQiugouRtPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			_bg = UIFactory.bg(0,0,310,335,this);
			_bgTitle1 = UIFactory.bg(0,0,310,25,this,"RegionTitleBg");
			_title1 = UIFactory.bitmap(ImagesConst.market4,0,0,this);
			_title1.x = (_bgTitle1.width-_title1.width)/2;
			_title1.y = _bgTitle1.y+(_bgTitle1.height-_title1.height)/2;
			
			
			_selectSp = UIFactory.bg(0,0,45,45,_list,ImagesConst.selectFilter);
			_selectSp.visible = false;
			
			_pageSelect = UIFactory.pageSelecter(93,116,this,PageSelecter.CompleteMode);
			_pageSelect.setbgStlye(ImagesConst.ComboBg,new GTextFormat);
			_pageSelect.maxPage = 1;
			_pageSelect.pageTextBoxSize = 36;
			_pageSelect.configEventListener(Event.CHANGE,onPageChange);
			
			//背包格子部分
			_list = UIFactory.tileList(4,27,310,90,this);
			_list.rowHeight = 43;
			_list.columnWidth = 43;
			_list.horizontalGap = 0;
			_list.verticalGap = 0;
			_list.setStyle("cellRenderer", MktBagItemRenderer);
			_list.rowCount = 2;
			_list.columnCount = 7;
			var arr:Array = [];
			for (var i:int = 0; i < _list.rowCount* _list.columnCount; i++) 
				arr.push(new Object());
			_list.dataProvider = new DataProvider(arr);
			
			_bgTitle2 = UIFactory.bg(0,140,310,25,this,"RegionTitleBg");
			_title2 = UIFactory.bitmap(ImagesConst.market3,0,0,this);
			_title2.x = (_bgTitle2.width-_title2.width)/2;
			_title2.y = _bgTitle2.y+(_bgTitle2.height-_title2.height)/2;
			
			_line = UIFactory.bg(0,200,_bg.width,1,this,ImagesConst.SplitLine);
			
			_txtSearch = UIFactory.getUICompoment(TextInputList,109,170,this); 
			_txtSearch._textInput.textField.width -= 25;
			_txtSearch.init(onSearchTxtChange);
			_btnMagnifier = UIFactory.gLoadingButton(ResFileConst.SearchBtn,_txtSearch.x+_txtSearch._textInput.width-21,_txtSearch.y+2,19,19,this);
			
			_comboType1 = UIFactory.gComboBox(45,213,100,20,null,this);
			var dp:DataProvider = MktModConfig.dpItemType1.clone();
			for (var j:int = 0; j < dp.length; j++)   //去掉 "铜币&元宝"
			{
				var obj:Object = dp.getItemAt(j);
				if(obj.label == "铜币&元宝")
				{
					dp.removeItemAt(j);
				}
			}
			_comboType1.dataProvider = dp;
			_comboType1.selectedIndex = 0;
			
			_comboType2 = UIFactory.gComboBox(45,242,100,20,null,this);
			resetComboType2();
			
			_comboColor = UIFactory.gComboBox(200,213,100,20,null,this);
			_comboColor.dataProvider = MktModConfig.dpColor.clone();
			_comboCareer = UIFactory.gComboBox(200,242,100,20,null,this);
			_comboCareer.dataProvider = MktModConfig.dpCareer.clone();
			autoSelectMyCareer();//自动选择自己的职业
			_comboLevel = UIFactory.gComboBox(45,271,100,20,null,this);
			_comboLevel.dataProvider = MktModConfig.dpLevel.clone();
			
			pushUIToDisposeVec(UIFactory.textField("精确查找：",45,170,68,22,this, GlobalStyle.textFormatAnjin));
			pushUIToDisposeVec(UIFactory.textField("类型：",7,213,40,22,this, GlobalStyle.textFormatAnjin));
			pushUIToDisposeVec(UIFactory.textField("颜色：",163,213,40,22,this, GlobalStyle.textFormatAnjin));
			pushUIToDisposeVec(UIFactory.textField("种类：",7,242,40,22,this, GlobalStyle.textFormatAnjin));
			pushUIToDisposeVec(UIFactory.textField("职业：",163,242,40,22,this, GlobalStyle.textFormatAnjin));
			pushUIToDisposeVec(UIFactory.textField("等级：",7,271,40,22,this, GlobalStyle.textFormatAnjin));
			
			_btnSearch = UIFactory.gButton("搜索",90,304,55,22,this);
			_btnReset = UIFactory.gButton("重置",168,304,55,22,this);
			
			_moneys = UICompomentPool.getUICompoment(MktMoneys);
			_moneys.createDisposedChildren();
			_moneys.x = 40; 
			_moneys.y = 355;
			addChild(_moneys);
			
			//事件监听
			Dispatcher.addEventListener(EventName.MarketRemoveSeekItem,onRemoveSeekItem);
			
			_comboType1.configEventListener(Event.CHANGE,onComboboxChange);
			_comboType2.configEventListener(Event.CHANGE,onComboboxChange);
			_comboLevel.configEventListener(Event.CHANGE,onComboboxChange);
			_comboColor.configEventListener(Event.CHANGE,onComboboxChange);
			_comboCareer.configEventListener(Event.CHANGE,onComboboxChange);
			_btnMagnifier.configEventListener(MouseEvent.CLICK,clickHandler);
			_btnSearch.configEventListener(MouseEvent.CLICK,clickHandler);
			_btnReset.configEventListener(MouseEvent.CLICK,clickHandler);
			_list.configEventListener(Event.CHANGE,listSelectChange);
		}
		
		private function onRemoveSeekItem(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			this._selectItemInfo = null;
			_list.selectedIndex  = -1;
			listSelectChange(null);
		}
		
		private function listSelectChange(e:Event):void
		{
			if(_list.selectedIndex == -1)
			{
				setSelectSpPos(null);
				return;
			}
			
			var obj:Object = _list.selectedItem;
			var m:MktBagItemRenderer;
			if(obj is ItemInfo)
			{
				m = _list.itemToCellRenderer(obj) as MktBagItemRenderer;
				_selectItemInfo = obj as ItemInfo;
				_selectPage = _pageSelect.currentPage;
				Dispatcher.dispatchEvent(new DataEvent(EventName.MarketPushSeekItem,obj));
			}
			setSelectSpPos(m);
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
		
		/** 自动选择自己职业 */
		private function autoSelectMyCareer():void
		{
			var dp:DataProvider = _comboCareer.dataProvider;
			for (var i:int = 0; i < dp.length; i++) 
			{
				var obj:Object = dp.getItemAt(i);
				if(obj.career == Cache.instance.role.entityInfo.career)
				{
					_comboCareer.selectedIndex = i;
					return;
				}
			}
			
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(e.currentTarget == _btnMagnifier)
			{
				if(_txtSearch._textInput.text.length < 2)
				{
					MsgManager.showRollTipsMsg("请输入两个以上关键字");
					return;
				}
				
				this._list.dataProvider = getDataProvider(1);
			}
			else if(e.currentTarget == _btnSearch)
			{
				this._list.dataProvider = getDataProvider(2);
			}
			else if(e.currentTarget == _btnReset)
			{
				_comboLevel.selectedIndex = 0;
				_comboColor.selectedIndex = 0;
				_comboCareer.selectedIndex = 0;
				_comboType1.selectedIndex = 0;
				resetComboType2();
			}
		}
		
		
		/** 搜索条件  */
		public function get searchCondition():Object
		{
			if(_searchCondition == null)
			{
				_searchCondition = {};
			}
			
			if(_comboColor.selectedItem.type != 0)
				_searchCondition.color =  _comboColor.selectedItem.color;
			else
				delete _searchCondition.color;
			
			if(_comboCareer.selectedItem.type != 0)
				_searchCondition.career = _comboCareer.selectedItem.career;
			else 
				delete _searchCondition.career;
				
			if(_comboLevel.selectedItem.type != 0)
			{
				_searchCondition.minLevel = _comboLevel.selectedItem.min;
				_searchCondition.maxLevel = _comboLevel.selectedItem.max;
			}
			else 
			{
				delete _searchCondition.minLevel;
				delete _searchCondition.maxLevel;
			}
			
			//物品类型
			var tmarket:TMarket = _comboType2.selectedItem.tMarket;
			_searchCondition.typeArr = MarketConfig.decodeItemType(tmarket);
			
			
			return _searchCondition;
		}
		
		private function onSearchTxtChange():void
		{
			if(_txtSearch._textInput.text.length >= 2)
			{
				_txtSearch.updateDataProvider(getTxtListDp());
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_selectItemInfo = null;
			
			_bg.dispose(isReuse);
			_bgTitle1.dispose(isReuse);
			_title1.dispose(isReuse);
			_selectSp.dispose(isReuse);
			_list.dispose(isReuse);
			_pageSelect.dispose(isReuse);
			_bgTitle2.dispose(isReuse);
			_title2.dispose(isReuse);
			_line.dispose(isReuse);
			_txtSearch.dispose(isReuse);
			_btnMagnifier.dispose(isReuse);
			_comboType1.dispose(isReuse);
			_comboColor.dispose(isReuse);
			_comboType2.dispose(isReuse);
			_comboCareer.dispose(isReuse);
			_comboLevel.dispose(isReuse);
			_btnSearch.dispose(isReuse);
			_btnReset.dispose(isReuse);
			_moneys.dispose(isReuse);
			
			
			_bg = null;
			_bgTitle1 = null;
			_title1 = null;
			_selectSp = null;
			_list = null;
			_pageSelect = null;
			_bgTitle2 = null;
			_title2 = null;
			_line = null;
			_txtSearch = null;
			_btnMagnifier = null;
			_txtType1 = null;
			_comboType1 = null;
			_comboColor = null;
			_comboType2 = null;
			_comboCareer = null;
			_comboLevel = null;
			_btnSearch = null;
			_btnReset = null;
			_moneys = null;
			
		}
		
		
		private function onPageChange(e:Event):void  //翻页
		{
			this._list.dataProvider = getDataProvider(0);
			this._list.drawNow();
			
			//还原选中
			_list.selectedIndex = -1;
			var data:ItemInfo;
			if(_selectItemInfo  && _pageSelect.currentPage == _selectPage)
			for (var i:int = 0; i < _list.dataProvider.length; i++) 
			{
				data = _list.getItemAt(i) as ItemInfo;
				if(data && data === _selectItemInfo)
				{
					_list.selectedIndex = i;
					break;
				}
			}
			var m:MktBagItemRenderer;
			m = _list.itemToCellRenderer(data) as MktBagItemRenderer;
			setSelectSpPos(m);
		}
		
		private function onComboboxChange(e:Event):void
		{
			var obj:Object;
			if(e.currentTarget == _comboType1)  //选了大类型要重置小类型
			{
				obj = _comboType1.selectedItem;
				resetComboType2();
			}
			this._list.dataProvider = getDataProvider(2);
		}
		
		/** 重置小类 */
		private function resetComboType2():void
		{
			_comboType2.dataProvider = MktModConfig.getdpItemType2(_comboType1.selectedItem.type);
			_comboType2.selectedIndex = 0;
		}
		
		private var _itemArr:Array;
		/**
		 * @param param 0、不重新搜索  1、名字搜索   2、条件搜索
		 */
		private function getDataProvider(param:int):DataProvider
		{
			var dp:DataProvider = new DataProvider();
			
			var arr:Array;
			if(param == 0)
			{
				arr = _itemArr;
			}
			else if(param == 1)
			{
				arr = MarketCache.searchByName(_txtSearch._textInput.text);
				_itemArr = arr;
			}
			else if(param == 2)
			{
				arr = MarketCache.searchByCondition(searchCondition);
				_itemArr = arr;
			}
			
			var count:int = _list.rowCount * _list.columnCount;
			var startIndex:int = (_pageSelect.currentPage-1) * count;
			var endIndex:int = startIndex + count;
			
			for (var j:int = startIndex; j < endIndex; j++)
			{
				if(arr && arr[j])
				{
					dp.addItem(arr[j]);
				}
				else
				{
					dp.addItem(new Object());
				}
			}
			
			if(arr.length==0)
			{
				MsgManager.showRollTipsMsg("不存在符合条件的信息");
			}
			
			this._pageSelect.maxPage = Math.ceil(arr.length/count);
			this._pageSelect.currentPage = Math.ceil((startIndex+1)/count);
			
			return dp;
		}
		
		private function getTxtListDp():DataProvider
		{
			var arr:Array = MarketCache.searchByName(_txtSearch._textInput.text);
			
			if(arr.length==0)
			{
				MsgManager.showRollTipsMsg("不存在符合条件的信息");
			}
			return new DataProvider(arr);
		}
	}
}