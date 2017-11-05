package mortal.game.control
{
	import Framework.Util.Exception;
	
	import Message.Game.EMarketRecordType;
	import Message.Game.SMarketItem;
	import Message.Game.SMoney;
	import Message.Public.EPrictUnit;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.Alert;
	
	import flash.events.Event;
	
	import mortal.common.TodayNotTipUtil;
	import mortal.common.error.ErrorCode;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.TodayNoTipsConst;
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.cache.MarketCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.MarketProxy;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.market.MarketModule;
	import mortal.game.view.market.MktModConfig;
	import mortal.game.view.market.alert.MktSaleQiugouAlert;
	import mortal.game.view.market.alert.MktTodayNoTipAlert;
	import mortal.game.view.market.myQiugou.MarketMyQiugouPanel;
	import mortal.game.view.market.myQiugou.MarketMySalePanel;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	/**
	 * 市场控制器
	 * @author lizhaoning
	 */
	public class MarketController extends Controller
	{
		private var _marketCache:MarketCache;
		private var _marketProxy:MarketProxy;
		private var _marketModule:MarketModule;
		
		
		private var _marketItemRecord:SMarketItem;
		public function MarketController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_marketCache = cache.market;
			_marketProxy = GameProxy.market;
		}
		
		override protected function initView():IView
		{
			if( _marketModule == null)
			{
				_marketModule = new MarketModule();
				_marketModule.addEventListener(WindowEvent.SHOW, onMarketShow);
				_marketModule.addEventListener(WindowEvent.CLOSE, onMarketClose);
			}
			return _marketModule;
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.MarketSearch,searchHandler);
			Dispatcher.addEventListener(EventName.MarketBuyMarketItem,buyHandler);
			Dispatcher.addEventListener(EventName.MarketSellItem2SeekBuy,saleSeekBuyHandler);
			Dispatcher.addEventListener(EventName.MarketClickQickBuy,clickQickBuyHandler);
		}
		
		protected function onMarketShow(event:Event):void
		{
			Dispatcher.addEventListener(EventName.MarketSale,saleHandler);
			Dispatcher.addEventListener(EventName.MarketQiugou,qiugouHandler);
			Dispatcher.addEventListener(EventName.MarketCancelSeekBuy,cancelSeekBuyHandler);
			Dispatcher.addEventListener(EventName.MarketCancelSell,cancelSellHandler);
			Dispatcher.addEventListener(EventName.MarketGetMyRecords,getMyRecordHandler);
			Dispatcher.addEventListener(EventName.MarketBroadcast,broadcastHandler);
			Dispatcher.addEventListener(EventName.MarketError,onErrorHandler);
		}
		
		
		protected function onMarketClose(event:Event):void
		{
			Dispatcher.removeEventListener(EventName.MarketSale,saleHandler);
			Dispatcher.removeEventListener(EventName.MarketQiugou,qiugouHandler);
			Dispatcher.removeEventListener(EventName.MarketCancelSeekBuy,cancelSeekBuyHandler);
			Dispatcher.removeEventListener(EventName.MarketCancelSell,cancelSellHandler);
			Dispatcher.removeEventListener(EventName.MarketGetMyRecords,getMyRecordHandler);
			Dispatcher.removeEventListener(EventName.MarketBroadcast,broadcastHandler);
			Dispatcher.removeEventListener(EventName.MarketError,onErrorHandler);
		}
		
		private function onErrorHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			var ex:Exception = e.data as Exception;
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(ex.code));
			if(ex.code == 36453)
			{
			}
			if(ex.code == 36454)  //记录已经失效
			{
				if(!MarketMyQiugouPanel.instance.isHide)
				{
					MarketMyQiugouPanel.instance.getDataFromServer();
				}
				if(!MarketMySalePanel.instance.isHide)
				{
					MarketMySalePanel.instance.getDataFromServer();
				}
				(view as MarketModule).refresh();
			}
		}
		
		private function qiugouHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			var obj:Object = e.data;
			_marketProxy.seekBuy(obj.code,obj.amount,obj.price,obj.unit,obj.time,obj.broadcast);
		}
		
		private function cancelSellHandler(e:DataEvent):void  //* 取消寄售
		{
			// TODO Auto Generated method stub
			var obj:Object = e.data;
			_marketProxy.cancelSell(obj.recordId);
		}
		
		private function cancelSeekBuyHandler(e:DataEvent):void  //* 取消求购
		{
			// TODO Auto Generated method stub
			var obj:Object = e.data;
			_marketProxy.cancelSeekBuy(obj.recordId);
		}
		
		private function saleHandler(e:DataEvent):void   //寄售
		{
			// TODO Auto Generated method stub
			var obj:Object = e.data;
			_marketProxy.sellItem(obj.code,obj.itemUid,obj.amount,obj.price,obj.unit,obj.time,obj.broadcast);
		}
		
		private function searchHandler(e:DataEvent):void   //搜索
		{
			// TODO Auto Generated method stub
			/*recordType : int , marketId : int , codes : Array , targetPage : int , 
			levelLower : int , levelUpper : int , color : int , career : int , 
			order : int , playerName : String*/
			
			var obj:Object = e.data;
			
			_marketProxy.search(obj.recordType, obj.marketId , obj.codes, obj.targetPage,obj.levelLower,obj.levelUpper,
				obj.color,obj.career,obj.order,obj.playerName);
		}
		
		private function clickQickBuyHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			NetDispatcher.addCmdListener(ServerCommand.MarketItemRecordUpdate,getMarketItemRecordBack);
			_marketProxy.getMarketRecordById(e.data as Number);
		}
		
		private function getMarketItemRecordBack(e:Object):void
		{
			// TODO Auto Generated method stub
			NetDispatcher.removeCmdListener(ServerCommand.MarketItemRecordUpdate,getMarketItemRecordBack);
			
			if(_marketCache.marketItemRecord == null || _marketCache.marketItemRecord.recordId == -1)
			{
				MsgManager.showRollTipsMsg("该物品已不存在");
				return ;
			}
			
			if(_marketCache.marketItemRecord.recordType == EMarketRecordType._EMarketRecordSell)
			{
				buyHandler(new DataEvent("",_marketCache.marketItemRecord));
			}
			else if(_marketCache.marketItemRecord.recordType == EMarketRecordType._EMarketRecordSeekBuy)
			{
				saleSeekBuyHandler(new DataEvent("",_marketCache.marketItemRecord));
			}
		}
		
		private function buyHandler(e:DataEvent):void  //购买
		{
			// TODO Auto Generated method stub
			_marketItemRecord = e.data as SMarketItem;
			var itemdata:ItemData = new ItemData(_marketItemRecord.code);
			
			if(!Cache.instance.role.enoughMoney(_marketItemRecord.sellUnit,_marketItemRecord.sellPrice))
			{
				MsgManager.showRollTipsMsg("所需货币不足");
				return ;
			}
			var str1:String  = "购买" + HTMLUtil.addColor(_marketItemRecord.amount.toString(),GlobalStyle.colorHuang);
			if(_marketItemRecord.code == EPrictUnit._EPriceUnitCoin ||
				_marketItemRecord.code == EPrictUnit._EPriceUnitGold)
			{
				str1 += GameDefConfig.instance.getEPrictNameAddColoer(_marketItemRecord.code,GlobalStyle.colorHuang);
			}
			else
			{
				str1 += "个"+ItemsUtil.getItemName(itemdata);
			}
			
			var str:String = str1 + "需要花费"+
				HTMLUtil.addColor(MktModConfig.getTotalPrice(_marketItemRecord),GlobalStyle.colorHuang)+
				GameDefConfig.instance.getEPrictNameAddColoer(_marketItemRecord.sellUnit)+"，确定购买吗？";
			
			var todayTipsType:String = "";
			if(_marketItemRecord.sellUnit == EPrictUnit._EPriceUnitCoin)
			{
				todayTipsType = TodayNoTipsConst.MarketBuyByCoin;
			}
			else if(_marketItemRecord.sellUnit == EPrictUnit._EPriceUnitGold)
			{
				todayTipsType = TodayNoTipsConst.MarketBuyByGold;
			}
			var obj:Object = {};
			obj.unit = _marketItemRecord.sellUnit;
			obj.str = "购买";
			Alert.extendObj = obj;
			TodayNotTipUtil.toDayNotTip(todayTipsType,onBuySelect,str,null,Alert.OK|Alert.CANCEL,null,null,null,0x4,MktTodayNoTipAlert);
			//Alert.show(str,null,Alert.OK|Alert.CANCEL,null,onBuySelect);
		}
		
		private function onBuySelect():void
		{
			_marketProxy.buyMarketItem(_marketItemRecord.recordId);
		}
		
		private function saleSeekBuyHandler(e:DataEvent):void  //出售求购
		{
			// TODO Auto Generated method stub
			var mktItem:SMarketItem = e.data as SMarketItem;
			var moneys:SMoney = Cache.instance.role.money;
			//出售的是钱
			if(mktItem.code == EPrictUnit._EPriceUnitCoin)
			{
				if(moneys.coin<10000)
				{
					MsgManager.showRollTipsMsg("货币不足");
					return ;
				}
			}
			else if(mktItem.code == EPrictUnit._EPriceUnitGold)
			{
				if(moneys.gold<1)
				{
					MsgManager.showRollTipsMsg("货币不足");
					return ;
				}
			}
			else  //出售的是物品
			{
				var itemData:ItemData = new ItemData(mktItem.code);
				if(itemData == null || Cache.instance.pack.backPackCache.getItemCountByCode(itemData,false)<=0)
				{
					MsgManager.showRollTipsMsg("身上无该物品");
					return ;
				}
			}
			
			//弹框
			Alert.alertWinRenderer = MktSaleQiugouAlert;
			var obj:Object = {};
			obj.marketItem = mktItem;
			Alert.extendObj = obj;
			Alert.show("",null,Alert.OK|Alert.CANCEL,null,onSaleSeekBuySelect);
		}
		private function onSaleSeekBuySelect(type:int,extendObj:Object):void
		{
			if(type == Alert.OK)
			{
				var marketItem:SMarketItem = extendObj.marketItem as SMarketItem;
				var uid:String = extendObj.uid;
				var amount:int = extendObj.amount;
				_marketProxy.sellItem2SeekBuy(marketItem.recordId,uid,amount);
			}
		}
		
		private function getMyRecordHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			var obj:Object = e.data;
			_marketProxy.getMyRecords(obj.recordType);
		}
		
		private function broadcastHandler(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			var obj:Object = e.data;
			_marketProxy.broadcastMarketRecord(obj.recordId);
		}
	}
}