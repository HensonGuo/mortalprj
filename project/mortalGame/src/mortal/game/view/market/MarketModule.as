package mortal.game.view.market
{
	import Message.Game.SMoney;
	
	import com.mui.controls.GTabBar;
	import com.mui.events.MuiEvent;
	
	import extend.language.Language;
	
	import mortal.common.display.LoaderHelp;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.market.buyAndQiugou.MarketBuyPanel;
	import mortal.game.view.market.qiugou.MarketQiugouPanel;
	import mortal.game.view.market.sale.MarketSalePanel;
	import mortal.mvc.interfaces.ILayer;
	
	/**
	 * 市场模块
	 * @author lizhaoning
	 */
	public class MarketModule extends BaseWindow
	{
		/** 物品购买 */
		private var _buyPanel:MarketBuyPanel;
		/**我要寄售*/
		private var _salePanel:MarketSalePanel;
		/**我要求购*/
		private var _qiugouPanel:MarketQiugouPanel;
		
		/**分组导航*/
		private var _tabBar:GTabBar;
		private var _tabData:Array;
		public function MarketModule($layer:ILayer=null)
		{
			super($layer);
			MktModConfig.createData();
			init();
		}
		
		public function init():void
		{
			setSize(688,520);
			title = Language.getArray(50500);
			//titleIcon = ImagesConst.PackIcon;
			this.titleHeight = 60;
			
			_tabData = Language.getArray(50501);
		}
		
		private var _isResCompl:Boolean = false;
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			LoaderHelp.addResCallBack(ResFileConst.market, showSkin);
		}
		
		private function showSkin():void
		{
			_isResCompl = true;
			
			//updateView();
			//导航 
			_tabBar = UIFactory.gTabBar(15,37,_tabData,88,26,this,tabBarChangeHandler);
			
			//默认选中1
			_tabBar.selectedIndex = 0;
			tabBarChangeHandler(null);
		}
		
		//private function updateView():void
		//{
//			if(_isResCompl && _marketData != null)
//			{
//				//
//			}
		//}
		
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			_tabBar.dispose(isReuse);
			_tabBar = null;
			
			disposeTabPanel([0,1,2,3],isReuse);
		}
		
		public function refresh():void
		{
			if(!this.stage)
			{
				return;
			}
			
			switch(_tabBar.selectedIndex)
			{
				case 0:
				case 1:
				{
					_buyPanel.search();
					break;
				}
			}
		}
		
		/**
		 * 释放标签面板 
		 * @param arr 需要释放的标签页的index数组  0-4
		 * @param isReuse
		 */
		private function disposeTabPanel(arr:Array,isReuse:Boolean = true):void
		{
			for (var i:int = 0; i < arr.length; i++) 
			{
				if(_buyPanel && (arr[i]==0 || arr[i]==1))
				{
					_buyPanel.dispose(isReuse);
					_buyPanel = null;
				}
				if(_salePanel && arr[i]==2)
				{
					_salePanel.dispose(isReuse);
					_salePanel = null;
				}
				if(_qiugouPanel && arr[i]==3)
				{
					_qiugouPanel.dispose(isReuse);
					_qiugouPanel = null;
				}
			}
		}
		
		private function tabBarChangeHandler(e:MuiEvent = null):void
		{
			if(_buyPanel)
			{
				_buyPanel.visible = false;
			}
			if(_salePanel)
			{
				_salePanel.visible = false;
			}
			if(_qiugouPanel)
			{
				_qiugouPanel.visible = false;
			}
			
			switch(_tabBar.selectedIndex)
			{
				case 0:
				{
					if(_buyPanel == null)
					{
						_buyPanel = UIFactory.getUICompoment(MarketBuyPanel,0,0,this);
					}
					_buyPanel.visible = true;
					disposeTabPanel([2,3]);
					_buyPanel.buyOrQiugou = 1;
					break;
				}
				case 1:
				{
					if(_buyPanel == null)
					{
						_buyPanel = UIFactory.getUICompoment(MarketBuyPanel,0,0,this);
					}
					_buyPanel.visible = true;
					disposeTabPanel([2,3]);
					_buyPanel.buyOrQiugou = 2;
					break;
				}
				case 2:
				{
					if(_salePanel == null)
					{
						_salePanel = UIFactory.getUICompoment(MarketSalePanel,0,0,this);
					}
					disposeTabPanel([0,1,3]);
					_salePanel.visible = true;
					break;
				}
				case 3:
				{
					if(_qiugouPanel == null)
					{
						_qiugouPanel = UIFactory.getUICompoment(MarketQiugouPanel,0,0,this);
					}
					disposeTabPanel([0,1,2]);
					_qiugouPanel.visible = true;
					break;
				}
			}
			
		}
		
	}
}