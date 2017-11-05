package mortal.game.view.shopMall
{
	import Message.DB.Tables.TShopSell;
	import Message.Game.SMoney;
	
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.SWFInfo;
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GImageButtonTabBar;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.BaseWindow;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.common.util.MoneyUtil;
	import mortal.game.view.pack.CanDropTabBar;
	import mortal.game.view.shopMall.view.HotBuyPanel;
	import mortal.game.view.shopMall.view.ShopCommonPanel;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class ShopMallModule extends Window
	{
		//数据
		
		/**当前bar*/
		private var _currentBar:String;
		
		//显示对象
		
		/**背景框*/
		private var _shopBg:ScaleBitmap;
		
		/**分组导航*/
		private var _tabBar:GImageButtonTabBar;
		
		/**分页导航*/
		private var _pageSelecter:PageSelecter;
		
		/**充值*/
		private var _rechargeBtn:GButton;
		
		/**热卖面板*/
		private var _hotBuyPanel:HotBuyPanel;  
		
		/**其他面板商品*/
		private var _goodsPanel:ShopCommonPanel;
		
		/**绑定金币*/
		private var _goldBindText:GTextFiled;
		
		/**金币*/
		private var _goldText:GTextFiled;
		
		/**绑定元宝*/
		private var _bmpYuanbao:GBitmap;
		
		/**元宝*/
		private var _bmpYuanbaoBind:GBitmap;
		
		/**当前页面*/
		private var _currentPanel:ShopCommonPanel;
		
		private var _sp:GBitmap;
		
		
		public function ShopMallModule($layer:ILayer=null)
		{
			super();
			init();
		}
		
		private function init():void
		{
			setSize(767,581);
			this.mouseEnabled = false;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_sp = UIFactory.gBitmap("",-395,-45,this);
			
			_goldText = UIFactory.gTextField("",85,538,50,20,this,GlobalStyle.textFormatHuang,true);
			_goldBindText = UIFactory.gTextField("",167,538,50,20,this,GlobalStyle.textFormatHuang,true);
			
			_bmpYuanbao = UIFactory.gBitmap(ImagesConst.Yuanbao,68,543,this);
			_bmpYuanbaoBind = UIFactory.gBitmap(ImagesConst.Yuanbao_bind,148,543,this);
			
			_rechargeBtn = UIFactory.gButton(Language.getString(30066),640,536,66,22,this);
			
			var fm:GTextFormat = GlobalStyle.textFormatBai;
			fm.align = AlignMode.CENTER;
			_pageSelecter = UIFactory.pageSelecter(330,540,this,PageSelecter.CompleteMode);
			_pageSelecter.setbgStlye(ImagesConst.ComboBg , fm);
			_pageSelecter.maxPage = 3;
			_pageSelecter.currentPage = 1;
			_pageSelecter.pageTextBoxSize = 50;
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			var tabData:Array = [
				{name:"button0",styleName:"Shop1"},
				{name:"button1",styleName:"Shop2"},
				{name:"button2",styleName:"Shop3"},
				{name:"button3",styleName:"Shop4"},
				{name:"button4",styleName:"Shop5"},
				{name:"button5",styleName:"Shop6"},
				{name:"button6",styleName:"Shop7"}
			];
			
			_tabBar = UICompomentPool.getUICompoment(GImageButtonTabBar);
			_tabBar.x = 41;
			_tabBar.y = 43;
			_tabBar.horizontalGap=-4;
			_tabBar.buttonWidth = 76;
			_tabBar.buttonHeight = 53;
			_tabBar.dataProvider = tabData;
			this.addChild(_tabBar);
			
			LoaderManager.instance.load("Wumen" + ".swf", resGotHandler);
			
			LoaderHelp.addResCallBack(ResFileConst.shopMall, showSkin);
			
		}
		
		
		private function resGotHandler(info:SWFInfo):void
		{
			if(_disposed)
			{
				return;
			}
			_sp.bitmapData = info.bitmapData;
			
		}
		
		private function showSkin():void
		{
			_shopBg = UIFactory.bg(0,0,this.width,this.height,null,ImagesConst.ShopMallBg);
			this.addChildAt(_shopBg,1);
			
			this.pushUIToDisposeVec(UIFactory.bg(39,95,690,437,this,ImagesConst.RoleInfoBg));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30067),545,537,100,22,this,GlobalStyle.textFormatPutong));
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.ShopTitle,232,-13,this));
			
			addHotBuyPanel();
			
			_currentPanel = _hotBuyPanel;
			_currentBar = "button1";
			
			_tabBar.configEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE, tabBarChangeHandler);
			_tabBar.selectedIndex = 0;
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.ShopMallInit));  //界面初始化完成后才更新数据
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_shopBg.dispose(isReuse);
			_goldBindText.dispose(isReuse);
			_goldText.dispose(isReuse);
			_bmpYuanbao.dispose(isReuse);
			_bmpYuanbaoBind.dispose(isReuse);
			_rechargeBtn.dispose(isReuse);
			_pageSelecter.dispose(isReuse);
			
			if(_hotBuyPanel)
			{
				_hotBuyPanel.dispose(isReuse);
				_hotBuyPanel = null;
			}
	
			if(_goodsPanel)
			{
				_goodsPanel.dispose(isReuse);
				_goodsPanel = null;
			}
			
			if(_sp != null)
			{
				_sp.dispose(isReuse);
				_sp = null;
			}
			
			if(_tabBar)
			{
				_tabBar.dispose(isReuse);
				_tabBar = null;
			}
			
			_shopBg = null;
			_goldBindText = null;
			_goldText = null;
			_bmpYuanbao = null;
			_bmpYuanbaoBind = null;
			_rechargeBtn = null;
			_pageSelecter = null;
		
			
			super.disposeImpl(isReuse);
		}
		
		override protected function updateBtnSize():void
		{
			if( _closeBtn )
			{
				_closeBtn.x = this.width - _closeBtn.width - 20;
				_closeBtn.y = 10;
			}
		}
		
		private function addHotBuyPanel():HotBuyPanel
		{
			if(_hotBuyPanel == null || _hotBuyPanel.parent == null)
			{
				_hotBuyPanel = UICompomentPool.getUICompoment(HotBuyPanel);
				_hotBuyPanel.createDisposedChildren();
				_hotBuyPanel.x = 45;
				_hotBuyPanel.y = 101;
			}
//			_hotBuyPanel = UICompomentPool.getUICompoment(HotBuyPanel);
//			_hotBuyPanel.x = 45;
//			_hotBuyPanel.y = 101;
			this.addChild(_hotBuyPanel);
			_hotBuyPanel.getItemsByTabAndPage(_currentBar);
			return _hotBuyPanel;
		}
		
		private function addGoodsList():ShopCommonPanel
		{
			_goodsPanel = UICompomentPool.getUICompoment(ShopCommonPanel);
			_goodsPanel.x = 46;
			_goodsPanel.y = 102;
			this.addChild(_goodsPanel);
			_goodsPanel.getItemsByTabAndPage(_currentBar);
			return _goodsPanel;
		}
		
		
		private function onPageChange(e:Event):void
		{
			_currentPanel.getItemsByTabAndPage(_currentBar,_pageSelecter.currentPage);
		}
		
		private function getItemsList(tab:String):Vector.<TShopSell>
		{
			switch(tab)
			{
				case "button1":
					return ShopConfig.instance.hotBuyList;break;
				case "button2":
					return ShopConfig.instance.usuallyList;break;
				case "button3":
					return ShopConfig.instance.paterialList;break;
				case "button4":
					return ShopConfig.instance.petList;break;
				case "button5":
					return ShopConfig.instance.medList;break;
				case "button6":
					return ShopConfig.instance.vipList;break;
				case "button7":
					return ShopConfig.instance.preferentialList;break;
				default:
					return null;
					
			}
		}
		
		
		private function tabBarChangeHandler(e:MuiEvent=null):void
		{
			var name:String = "button" + (_tabBar.selectedIndex + 1);
			var changePanel:ShopCommonPanel;
			_currentBar = name;
			if(name == "button1")
			{
				changePanel = addHotBuyPanel();
				_pageSelecter.maxPage = Math.ceil(ShopConfig.instance.hotBuyList.length/4);
				Dispatcher.dispatchEvent(new DataEvent(EventName.BuyPanicOpen));
			}
			else
			{
				changePanel = addGoodsList();
				_pageSelecter.maxPage = Math.ceil(getItemsList(_currentBar).length/12);
				Dispatcher.dispatchEvent(new DataEvent(EventName.BuyPanicClose));
			}
			_pageSelecter.currentPage = 1;
			
			if(changePanel)
			{
				if(_currentPanel && _currentPanel != changePanel && _currentPanel.parent)
				{
//					removeChild(_currentPanel);
					_currentPanel.dispose(true);
				}
				_currentPanel = changePanel;
			}
		}
		
		public function setPropInfo(page:int = 1):void
		{
			if(_hotBuyPanel)
			{
				_hotBuyPanel.getItemsByTabAndPage(_currentBar,_pageSelecter.currentPage);
			}
	
		}
		
		public function updateMoney():void
		{
			var smoney:SMoney=Cache.instance.role.money;
			setGoldAmount(smoney.gold);
			setGoldBindAmount(smoney.goldBind);
		}
		
		public function setGoldAmount(value:int):void
		{
			var txt:String = MoneyUtil.getCoinHtml(value);
			if(txt == _goldText.htmlText)
			{
				return;
			}
			_goldText.htmlText = txt;
		}
		
		public function setGoldBindAmount(value:int):void
		{
			var txt:String = MoneyUtil.getCoinHtml(value);
			if(txt == _goldBindText.htmlText)
			{
				return;
			}
			_goldBindText.htmlText = txt;
		}
		
		public function getPanicItems():void
		{
			if(_hotBuyPanel)
			{
				_hotBuyPanel.getPanicItems();
			}
		
		}
		
		public function updateLeftTime():void
		{
			if(_hotBuyPanel)
			{
				_hotBuyPanel.updateLeftTime();
			}
		
		}
	}
}