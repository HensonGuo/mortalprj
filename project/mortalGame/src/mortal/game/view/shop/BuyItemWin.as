package mortal.game.view.shop
{
	import Message.Game.SMoney;
	import Message.Public.EPrictUnit;
	
	import com.gengine.global.Global;
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GNumericStepper;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.SmallWindow;
	import mortal.game.cache.Cache;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.NumInput;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.shopMall.data.ShopItemData;
	import mortal.mvc.core.NetDispatcher;

	public class BuyItemWin extends SmallWindow
	{
		private var _shopItem:BaseItem;
		
		private var _itemName:GTextFiled;
		
		private var _price:GTextFiled;
		
		private var _totalPrice:GTextFiled;
		
		private var _notEnougthMoney:GTextFiled;
		
		private var _ownMoney:GTextFiled;
		
		private var _capcity:GTextFiled;
		
		private var _btnBuy:GLoadingButton;
		
		private var _numInput:GNumericStepper;
		
		private var _moneyIcon:GBitmap;
		
		private var _totalMoneyIcon:GBitmap;
		
		private var _ownMoneyIcon:GBitmap;
		
		private static var _shopItemData:ShopItemData;
		
		private static var _npcId:int;
		
		private static var _instance:BuyItemWin;
		
		public function BuyItemWin()
		{
			if( _instance != null )
			{
				throw new Error(" BulkUseWin 单例 ");
			}
			this.isHideDispose = false;
		}
		
		public static function get instance():BuyItemWin
		{
			if(_instance == null)
			{
				_instance = new BuyItemWin();
			}
			
			return _instance;
		}
		
		public static function showWin(shopItemData:ShopItemData,npcId:int):void
		{
			_shopItemData = shopItemData;
			_npcId = npcId;
			
			if(_instance == null)
			{
				_instance = new BuyItemWin();
			}
			
			_instance.titleHeight = 25;
			_instance.setSize(270,210);
			_instance.title = Language.getString(30030);
			_instance.show();
			_instance.setInfo();
		}
		
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.ShopItemBg,26,46,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30075),109,68,40,24,this));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30078),109,122,60,24,this,GlobalStyle.textFormatHuang));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30077),45,195,60,24,this,GlobalStyle.textFormatItemGreen));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30076),45,175,60,24,this,GlobalStyle.textFormatItemGreen));
			
			_shopItem = UICompomentPool.getUICompoment(BaseItem);
			_shopItem.createDisposedChildren();
			_shopItem.setSize(62,62);
			_shopItem.move(32,51);
			_shopItem.isDragAble = _shopItem.isDropAble = false;
			this.addChild(_shopItem);
			
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.size = 15;
			_itemName = UIFactory.gTextField("",109,44,150,25,this,tf,true);
			
			tf = GlobalStyle.textFormatBai;
			tf.align = AlignMode.RIGHT;
			_price = UIFactory.gTextField("",140,69,51,20,this,tf,true);
			
			tf = GlobalStyle.textFormatHuang;
			tf.align = AlignMode.RIGHT;
			_totalPrice = UIFactory.gTextField("",140,123,51,20,this,tf,true);
			
			_notEnougthMoney = UIFactory.gTextField("",210,123,80,20,this,GlobalStyle.textFormatHong);
			
			tf = GlobalStyle.textFormatItemGreen;
			tf.align = AlignMode.RIGHT;
			_ownMoney = UIFactory.gTextField("",100,175,60,20,this,tf,true);
			
		
			_capcity = UIFactory.gTextField("",115,195,60,20,this,tf,true);
			
			_btnBuy = UIFactory.gLoadingButton(ResFileConst.ShopBuy,211,97,49,23,this);
			_btnBuy.drawNow();
			_btnBuy.configEventListener(MouseEvent.CLICK,clickHandler);
				
			_moneyIcon = UIFactory.gBitmap("",190,72,this);
			
			_totalMoneyIcon = UIFactory.gBitmap("",190,125,this);
			
			_ownMoneyIcon = UIFactory.gBitmap("",160,179,this);
			
//			_numInput = UIFactory.numInput(110,98,this,1,99);
//			_numInput.height = 20;

			tf = GlobalStyle.textFormatBai;
			tf.align = TextFormatAlign.CENTER;
			_numInput = UIFactory.gNumericStepper(112,98,50,20,this,99,1,"NumericStepper",tf,GNumericStepper.SetMaxAndMinNum);
			_numInput.value = 1;
			_numInput.configEventListener(Event.CHANGE,changeNum);
			
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_shopItem.dispose(isReuse);
			_itemName.dispose(isReuse);
			_price.dispose(isReuse);
			_totalPrice.dispose(isReuse);
			_ownMoney.dispose(isReuse);
			_capcity.dispose(isReuse);
			_btnBuy.dispose(isReuse);
			_numInput.dispose(isReuse);
			_moneyIcon.dispose(isReuse);
			_totalMoneyIcon.dispose(isReuse);
			_ownMoneyIcon.dispose(isReuse);
			_notEnougthMoney.dispose(isReuse);
			
			_shopItem = null;
			_itemName = null;
			_price = null;
			_totalPrice = null;
			_ownMoney = null;
			_capcity = null;
			_btnBuy = null;
			_numInput = null;
			_moneyIcon = null;
			_totalMoneyIcon = null;
			_ownMoneyIcon = null;
			_notEnougthMoney = null;
			
		}
		
		override protected function configParams():void
		{
			super.configParams();
			
			blurTop = 10;
			paddingBottom = 50;
		}
		
		private function setMoneyInfo(data:Object = null):void
		{
			var type:int = ShopConfig.instance.getShopById(_shopItemData.tShopSell.shopCode).unit;
		    var money:SMoney = Cache.instance.role.money;
			var num:int;
			switch(type)
			{
				case EPrictUnit._EPriceUnitCoin:
					num = money.coin;
					break;
				case EPrictUnit._EPriceUnitCoinBind:
					num = money.coinBind;
					break;
				case EPrictUnit._EPriceUnitGold:
					num = money.gold;
					break;
				case EPrictUnit._EPriceUnitGoldBind:
					num = money.goldBind;
					break;
			}
			_ownMoney.text = num.toString();
			changeNum();
		}
		
		private function getMoneyIcon():BitmapData
		{
			var type:int = ShopConfig.instance.getShopById(_shopItemData.tShopSell.shopCode).unit;
			var bmd:BitmapData = GlobalClass.getBitmapData(GameDefConfig.instance.getMoneyIcon(type));
		    return bmd;
		}
		
		private function setInfo():void
		{
			_shopItem.itemData = new ItemData(_shopItemData.tShopSell.itemCode);
			_itemName.htmlText = ItemsUtil.getItemName(_shopItem.itemData);
			_price.text = _shopItemData.tShopSell.price.toString();
			_totalPrice.text = _shopItemData.tShopSell.price.toString();
			updateCapcity();
			setMoneyInfo();
			_ownMoneyIcon.bitmapData = _totalMoneyIcon.bitmapData = _moneyIcon.bitmapData = getMoneyIcon();
			
			if(_shopItemData.tShopSell.activeOffer != 0)   //有活动价的时候显示特价
			{
				_price.text = _shopItemData.tShopSell.activeOffer.toString();
			}
			else
			{
				_price.text = _shopItemData.tShopSell.offer.toString();
			}
			_numInput.value = 1;
			changeNum();
		}
		
		private function changeNum(e:Event = null):void
		{
			_totalPrice.text = String(int(_price.text) * _numInput.value);
			var tf:GTextFormat;
            if(int(_totalPrice.text) > int(_ownMoney.text))
			{
				tf = GlobalStyle.textFormatHong;
				tf.align = AlignMode.RIGHT;
				_totalPrice.setTextFormat(tf);
				_notEnougthMoney.text = Language.getString(30079);
			}
			else
			{
				tf = GlobalStyle.textFormatHuang;
				tf.align = AlignMode.RIGHT;
				_totalPrice.setTextFormat(tf);
				_notEnougthMoney.text = "";
			}
		}
		
		
		
		private function clickHandler(e:MouseEvent):void
		{
			if(e.target == _btnBuy)
			{
				var num:int = _numInput.value;
				if (num > 0)
				{
					if(int(_totalPrice.text) > int(_ownMoney.text))
					{
						MsgManager.showRollTipsMsg("货币不足");
						return;
					}
					GameProxy.shop.buy(_npcId,_shopItemData.tShopSell.shopCode,_shopItemData.tShopSell.itemCode,num,1);
				}
			}
		}
		
		private function updateCapcity(data:Object = null):void
		{
			_capcity.text = String(Cache.instance.pack.backPackCache.capacity - Cache.instance.pack.backPackCache.itemLength) + "个";
		}
		
		override public function show(x:int=0, y:int=0):void
		{
			super.show();
			NetDispatcher.addCmdListener(ServerCommand.MoneyUpdate,setMoneyInfo);
			NetDispatcher.addCmdListener(ServerCommand.UpdateCapacity,updateCapcity);
		}
		
		override public function hide():void
		{
			super.hide();
			NetDispatcher.removeCmdListener(ServerCommand.MoneyUpdate,setMoneyInfo);
			NetDispatcher.removeCmdListener(ServerCommand.UpdateCapacity,updateCapcity);
		}
		
	}
}