package mortal.game.view.shopMall.view
{
	import Message.DB.Tables.TShop;
	import Message.Public.EPrictUnit;
	
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GNumericStepper;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.ItemStyleConst;
	import mortal.game.view.shopMall.data.ShopItemData;
	import mortal.mvc.core.Dispatcher;
	
	public class GoodsCellRenderer extends GCellRenderer
	{
		private var _shopItem:ShopSellItem;
		
		private var _yuanjia:GTextFiled;
		
		private var _xianjia:GTextFiled;
		
		private var _propName:GTextFiled;
		
		private var _listPrice:GTextFiled;
		
		private var _price:GTextFiled;
		
		private var _buyBtn:GLoadingButton;
		
		private var _deleteLine:GBitmap;
		
		private var _sideIcon:GBitmap;    //新品或热卖标志
		
		private var _listPriceIcon:GBitmap;   //现价图标
		
		private var _priceIcon:GBitmap;  //原价图标
		
		private var _numericStepper:GNumericStepper;//调节数量组件
		
		
		public function GoodsCellRenderer()
		{
			super();
			this.setSize(175,104);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.bg(0,0,216,102,this,ImagesConst.GoodsBg));
			this.pushUIToDisposeVec(UIFactory.bg(0,22,215,1,this,ImagesConst.SplitLine));
//			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.ShopItemBg,6,26,this));
			
			var tm:GTextFormat = GlobalStyle.textFormatPutong;
			
			tm.align = TextFormatAlign.CENTER;
			_listPrice = UIFactory.gTextField("",145,27,60,25,this,tm,true);
			_yuanjia = UIFactory.gTextField(Language.getString(30060),85,27,60,25,this,tm,true);
			_listPriceIcon = UIFactory.gBitmap("",190,32,this);
			_deleteLine = UIFactory.gBitmap(ImagesConst.deleteLine,163,32,this);
			
			
			tm = GlobalStyle.textFormatBai;
			tm.align = TextFormatAlign.CENTER;
			_price = UIFactory.gTextField("",145,50,60,25,this,tm,true);
			_xianjia = UIFactory.gTextField(Language.getString(30061),85,50,60,25,this,tm,true);
			_priceIcon = UIFactory.gBitmap("",190,55,this);
			
			_propName = UIFactory.gTextField("",58,1,100,25,this,tm,true);
			
			_shopItem = UICompomentPool.getUICompoment(ShopSellItem);
			_shopItem.x = 11;
			_shopItem.y = 26;
			_shopItem.setItemStyle(ItemStyleConst.Big,ImagesConst.ShopItemBg,6,6);
			this.addChild(_shopItem);
			
			_sideIcon = UIFactory.gBitmap("",0,0,this);
			
			_buyBtn = UIFactory.gLoadingButton(ResFileConst.ShopBuy,164,74,49,23,this);
			_buyBtn.drawNow();
			_buyBtn.configEventListener(MouseEvent.CLICK,clickHandler);
			
			tm.align = AlignMode.CENTER;
			_numericStepper = UIFactory.gNumericStepper(100,74,42,20,this,99,1,"NumericStepper",tm);
			_numericStepper.value = 1;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_listPrice.dispose(isReuse);
			_price.dispose(isReuse);
			_shopItem.dispose(isReuse);
			_buyBtn.dispose(isReuse);
			_propName.dispose(isReuse);
			_numericStepper.dispose(isReuse);
			_sideIcon.dispose(isReuse);
			_listPriceIcon.dispose(isReuse);
			_priceIcon.dispose(isReuse);
			_deleteLine.dispose(isReuse);
			_yuanjia.dispose(isReuse);
			_xianjia.dispose(isReuse);
			
			_listPrice = null;
			_price = null;
			_shopItem = null;
			_buyBtn = null;
			_propName = null;
			_numericStepper = null;
			_sideIcon = null;
			_listPriceIcon = null;
			_priceIcon = null;
			_deleteLine = null;
			_yuanjia = null;
			_xianjia = null;
			
			super.disposeImpl(isReuse);
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			if(e.target == _buyBtn)
			{
				_shopItem.shopPropData.num = _numericStepper.value;
				Dispatcher.dispatchEvent(new DataEvent(EventName.BuyItem , _shopItem.shopPropData));
			}
		}
		
		private function setSideIcon(type:int):void
		{
			var url:String;
			_sideIcon.visible = true;
			switch(type)
			{
				case 1:
					url = ImagesConst.ShopNewItem;break;
				case 2:
					url = ImagesConst.SopHot;break;
				case 3:
					url = ImagesConst.ShopOffer;break;
				default:
					_sideIcon.visible = false;return;
			}
			
			_sideIcon.bitmapData = GlobalClass.getBitmapData(url);
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
			_listPriceIcon.bitmapData = _priceIcon.bitmapData = GlobalClass.getBitmapData(url);
		}
		
		override public function set data(arg0:Object):void
		{
			if(_shopItem.shopPropData == arg0.data as ShopItemData)
			{
				return;
			}
			
			_shopItem.shopPropData = arg0.data as ShopItemData;
			
			var tshop:TShop = ShopConfig.instance.getShopById(_shopItem.shopPropData.tShopSell.shopCode) as TShop;
			var tm:TextFormat;
			
			setSideIcon( _shopItem.shopPropData.tShopSell.label);
			setMoneyIcon(tshop.unit);
			_numericStepper.value = 1;
			
			if(_shopItem.shopPropData.tShopSell.price == _shopItem.shopPropData.tShopSell.offer)  //有折扣的时候显示折扣
			{
				_listPrice.visible = _yuanjia.visible  = _listPriceIcon.visible = _deleteLine.visible = false;
				_price.y = 41;
				_xianjia.y = 41;
				_priceIcon.y = 46;
			}
			else
			{
				_listPrice.text = _shopItem.shopPropData.tShopSell.price.toString();
				_listPrice.visible = _yuanjia.visible = _listPriceIcon.visible = _deleteLine.visible = true;
				_price.y = 50;
				_xianjia.y = 50;
				_priceIcon.y = 55;
			}
			
			if(_shopItem.shopPropData.tShopSell.activeOffer != 0)   //有活动价的时候显示特价
			{
				tm = GlobalStyle.textFormatItemGreen;
				tm.align = TextFormatAlign.CENTER;
				_xianjia.defaultTextFormat = tm;
				_price.defaultTextFormat = tm;
				_xianjia.text = Language.getString(30072);
				_price.text = _shopItem.shopPropData.tShopSell.activeOffer.toString();
				
			}
			else   
			{
				tm = GlobalStyle.textFormatBai;
				tm.align = TextFormatAlign.CENTER;
				_xianjia.defaultTextFormat = tm;
				_price.defaultTextFormat = tm;
				_xianjia.text = Language.getString(30061);
				_price.text = _shopItem.shopPropData.tShopSell.offer.toString();
			}
			_propName.htmlText = ItemsUtil.getItemName(_shopItem.itemData);
			
		}
	}
}