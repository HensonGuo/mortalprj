package mortal.game.view.shopMall.view
{
	import Message.DB.Tables.TShop;
	import Message.DB.Tables.TShopSell;
	import Message.Game.SPanicBuyItemMsg;
	import Message.Public.EPrictUnit;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ConfigCenter;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.configBase.ConfigConst;
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.shopMall.data.ShopItemData;
	import mortal.game.view.shopMall.data.ShopPanicData;
	import mortal.mvc.core.Dispatcher;
	
	public class PanicItemCellRenderer extends GCellRenderer
	{
		private var _propItem:ShopPanicItem;
		
		private var _propName:GTextFiled;
		
		private var _listPrice:GTextFiled;
		
		private var _price:GTextFiled;
		
		private var _limitNum:GTextFiled;   //限购个数
		
		private var _leftNum:GTextFiled;   //剩余数量
		
		private var _buyBtn:GLoadingButton;
		
		private var _moneyIcon:GBitmap;   //现价图标
		
		private var _listPriceIcon:GBitmap;  //原价图标
		
		public function PanicItemCellRenderer()
		{
			super();
			this.setSize(175,104);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.bg(0,0,216,108,this,ImagesConst.GoodsBg));
			this.pushUIToDisposeVec(UIFactory.bg(0,22,215,1,this,ImagesConst.SplitLine));
			
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30060),85,43,60,25,this,GlobalStyle.textFormatPutong,true));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30061),85,61,60,25,this,GlobalStyle.textFormatBai,true));
			
			_moneyIcon = UIFactory.gBitmap("",190,48,this);
			_listPriceIcon = UIFactory.gBitmap("",190,65,this);
			
			var tm:TextFormat = GlobalStyle.textFormatPutong;
			
			tm.align = TextFormatAlign.CENTER;
			_listPrice = UIFactory.gTextField("",145,43,60,25,this,tm,true);
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.deleteLine,163,50,this));
			
			tm = GlobalStyle.textFormatBai;
			tm.align = TextFormatAlign.CENTER;
			_price = UIFactory.gTextField("",145,61,60,25,this,tm,true);
			
			tm  = GlobalStyle.textFormatChen; 
			tm.align = TextFormatAlign.CENTER;
			_propName = UIFactory.gTextField("",68,1,80,25,this,tm,true);
			
			tm  = GlobalStyle.textFormatHuang; 
			tm.align = TextFormatAlign.LEFT;
			_limitNum = UIFactory.gTextField("",84,26,80,25,this,tm,true);
			_leftNum = UIFactory.gTextField("",138,26,80,25,this,tm,true);
			
			_propItem = UICompomentPool.getUICompoment(ShopPanicItem);
			_propItem.x = 11;
			_propItem.y = 28;
			_propItem.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,6,6);
			this.addChild(_propItem);
			
			_buyBtn = UIFactory.gLoadingButton(ResFileConst.ShopBuy,164,81,49,23,this);
			_buyBtn.drawNow();
			_buyBtn.configEventListener(MouseEvent.CLICK,clickHandler);
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_listPrice.dispose(isReuse);
			_price.dispose(isReuse);
			_propItem.dispose(isReuse);
			_buyBtn.dispose(isReuse);
			_propName.dispose(isReuse);
			_leftNum.dispose(isReuse);
			_limitNum.dispose(isReuse);
			_moneyIcon.dispose(isReuse);
			_listPriceIcon.dispose(isReuse);
			
			_listPrice = null;
			_price = null;
			_propItem = null;
			_buyBtn = null;
			_propName = null;
			_leftNum = null;
			_limitNum = null;
			_moneyIcon = null;
			_listPriceIcon = null;
			
			super.disposeImpl(isReuse);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.BuyPanicItem , this._propItem.shopPropData.tShopPanic.itemCode));
		}
		
		private function setMoneyIcon(type:int):void
		{
			var url:String;
			switch(type)
			{
				case EPrictUnit._EPriceUnitCoin:
					url = ImagesConst.Jinbi;break;
				case EPrictUnit._EPriceUnitCoinBind:
					url = ImagesConst.Jinbi_bind;break;
				case EPrictUnit._EPriceUnitGold:
					url = ImagesConst.Yuanbao;break;
				case EPrictUnit._EPriceUnitGoldBind:
					url = ImagesConst.Yuanbao_bind;break;
			}
			_moneyIcon.bitmapData = _listPriceIcon.bitmapData = GlobalClass.getBitmapData(url);
		}
		
		override public function set data(arg0:Object):void
		{
			_propItem.shopPropData = arg0.data as ShopPanicData;
			
//			setMoneyIcon(tshop.unit);
			setMoneyIcon(3);  //后面加上配置表
			
			_listPrice.text = ShopConfig.instance.getPanicShopSellInfoByKey(_propItem.shopPropData.tShopPanic.code + "_" + _propItem.shopPropData.sPanicBuyItem.index).price.toString();
			_price.text = _propItem.shopPropData.sPanicBuyItem.discount.toString();
			_propName.htmlText = ItemsUtil.getItemName(_propItem.itemData);
			_limitNum.text = Language.getStringByParam(30069,Cache.instance.shop.getLimitNumByKey( _propItem.shopPropData.tShopPanic.code + "_" +  _propItem.shopPropData.tShopPanic.index));
			_leftNum.text = Language.getStringByParam(30070, _propItem.shopPropData.sPanicBuyItem.leftAmount.toString());
			
		}
	}
}