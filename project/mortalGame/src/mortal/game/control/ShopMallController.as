package mortal.game.control
{
	import flash.events.Event;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.ShopProxy;
	import mortal.game.view.shopMall.ShopMallModule;
	import mortal.game.view.shopMall.data.ShopItemData;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class ShopMallController extends Controller
	{
		private var _shopMallModule:ShopMallModule;
		
		private var _shopProxy:ShopProxy;
		
		public function ShopMallController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_shopProxy = GameProxy.shop;
		}
		
		override protected function initView():IView
		{
			if (_shopMallModule == null)
			{
				_shopMallModule=new ShopMallModule();
				_shopMallModule.addEventListener(WindowEvent.SHOW, onWinShow);
				_shopMallModule.addEventListener(WindowEvent.CLOSE, onWinClose);
			}
			return _shopMallModule;
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.ShopMallInit,updateWindow);
			Dispatcher.addEventListener(EventName.BuyItem, buyItem);
		}
		
		private function onWinShow(e:Event):void
		{
			NetDispatcher.addCmdListener(ServerCommand.MoneyUpdate, updateMoney);
			NetDispatcher.addCmdListener(ServerCommand.PanicUndate, updatePanicList);
			
			Dispatcher.addEventListener(EventName.BuyPanicItem, buyPanicItem);
			Dispatcher.addEventListener(EventName.BuyPanicOpen, getPanicData);
			Dispatcher.addEventListener(EventName.BuyPanicClose, stopGetPanicData);
			
		}
		
		private function onWinClose(e:Event):void
		{
			stopGetPanicData();
			
			NetDispatcher.removeCmdListener(ServerCommand.MoneyUpdate, updateMoney);
			NetDispatcher.removeCmdListener(ServerCommand.PanicUndate, updatePanicList);
			
			Dispatcher.removeEventListener(EventName.BuyPanicItem, buyPanicItem);
			Dispatcher.removeEventListener(EventName.BuyPanicOpen, getPanicData);
			Dispatcher.removeEventListener(EventName.BuyPanicClose, stopGetPanicData);
		}
		
		private function updateWindow(data:DataEvent):void
		{
			updateMoney();
			setPropInfo();
			getPanicData();
		}
		
		private function getPanicData(data:DataEvent = null):void
		{
			_shopProxy.getPanicBuyConfig();
		}
		
		private function stopGetPanicData(data:DataEvent = null):void
		{
			_shopProxy.closePanicBuyPanel();
		}
		
		/**
		 * 购买物品 
		 * @param data
		 * 
		 */		
		private function buyItem(data:DataEvent):void
		{
			var shopPropData:ShopItemData = data.data as ShopItemData;
			_shopProxy.buy(0 ,shopPropData.tShopSell.shopCode,shopPropData.tShopSell.itemCode,shopPropData.num,1);
		}
		
		/**
		 * 载入商品数据 
		 * 
		 */		
		private function setPropInfo():void
		{
			_shopMallModule.setPropInfo();
		}
		
		/**
		 * 更新金钱 
		 * @param obj
		 * 
		 */		
		private function updateMoney(obj:Object = null):void
		{
			_shopMallModule.updateMoney();
		}
		
		/**
		 * 更新团购列表 
		 * @param obj
		 * 
		 */		
		private function updatePanicList(obj:Object = null):void
		{
			_shopMallModule.getPanicItems();
			_shopMallModule.updateLeftTime();
		}
		
		/**
		 * 购买团购物品 
		 * @param data
		 * 
		 */		
		private function buyPanicItem(data:DataEvent):void
		{
			var itemCode:int = data.data as int;
			_shopProxy.buyItem(itemCode);
		}
	}
}