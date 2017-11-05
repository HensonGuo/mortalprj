package mortal.game.control
{
	import Message.Public.EBusinessOperation;
	import Message.Public.EPrictUnit;
	import Message.Public.SBusiness;
	import Message.Public.SBusinessInfo;
	import Message.Public.SEntityId;
	
	import flash.events.Event;
	
	import mortal.common.error.ErrorCode;
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.TradeCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.TradeProxy;
	import mortal.game.view.business.TradeIcon;
	import mortal.game.view.business.TradeModule;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	/**
	 * 交易，控制器
	 * @author lizhaoning
	 */
	public class TradeController extends Controller
	{
		private var _tradeCache:TradeCache;
		private var _tradeProxy:TradeProxy;
		private var _tradeModule:TradeModule;
		
		public function TradeController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_tradeCache = cache.trade;
			_tradeProxy = GameProxy.trade;
		}
		
		override protected function initView():IView
		{
			if( _tradeModule == null)
			{
				_tradeModule = new TradeModule();
				_tradeModule.addEventListener(WindowEvent.SHOW, onMarketShow);
				_tradeModule.addEventListener(WindowEvent.CLOSE, onMarketClose);
			}
			return _tradeModule;
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.TradeAcceptTrade,selfAcceptTrade);
			Dispatcher.addEventListener(EventName.TradeRejectTrade,selfRejectTrade);
			
			Dispatcher.addEventListener(EventName.TradeApplyToTarget,onApply);
			NetDispatcher.addCmdListener(ServerCommand.TradeUpdate, onTradeMsg);
		}
		
		protected function onMarketShow(event:Event):void
		{
			Dispatcher.addEventListener(EventName.TradeMyItemsChange,onMyTradeItemsChange);
			Dispatcher.addEventListener(EventName.TradeMyMoneysChange,onMyTradeMoneysChange);
			Dispatcher.addEventListener(EventName.TradeClickLock,onClickLock);
			Dispatcher.addEventListener(EventName.TradeClickTradeBtn,onClickTradeBtn);
			Dispatcher.addEventListener(EventName.TradeCancel,onClickTradeCancel);
		}
		
		protected function onMarketClose(event:Event):void
		{
			Dispatcher.removeEventListener(EventName.TradeMyItemsChange,onMyTradeItemsChange);
			Dispatcher.removeEventListener(EventName.TradeMyMoneysChange,onMyTradeMoneysChange);
			Dispatcher.removeEventListener(EventName.TradeClickLock,onClickLock);
			Dispatcher.removeEventListener(EventName.TradeClickTradeBtn,onClickTradeBtn);
			Dispatcher.removeEventListener(EventName.TradeCancel,onClickTradeCancel);
		}
		
		private function onMyTradeMoneysChange(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			_tradeProxy.updateMoney(_tradeCache.currentBusinessId,EPrictUnit.convert(e.data.unit),e.data.amount);
		}	
		
		private function onMyTradeItemsChange(e:DataEvent):void
		{
			//{uid:item.uid,amount:0}
			var amount:int = e.data.amount;
			var key:String = e.data.uid;
			
			if(amount > 0)  //表示增加一个物品
			{
				_tradeCache.usedItems[key] = amount;
			}
			else  //表示去掉一个物品
			{
				delete _tradeCache.usedItems[key];
			}
			
			_tradeProxy.updateItem(_tradeCache.currentBusinessId,key,amount);
			Dispatcher.dispatchEvent(new DataEvent(EventName.Trade_StatusChange));
		}
		
		private function onApply(e:DataEvent):void  //我向别人发出申请
		{
			// TODO Auto Generated method stub
			_tradeProxy.doApply(e.data as SEntityId);
		}
		
		private function selfRejectTrade(e:DataEvent):void  //我点击拒绝交易
		{
			// TODO Auto Generated method stub
			_tradeProxy.doOperation(EBusinessOperation._EBusinessOperationReject, e.data as String);
		}
		
		private function selfAcceptTrade(e:DataEvent):void //我点击同意交易
		{
			// TODO Auto Generated method stub
			_tradeProxy.doOperation(EBusinessOperation._EBusinessOperationAgree, e.data as String);
		}	
		
		private function onClickTradeBtn(e:DataEvent):void   //点击交易面板的交易按钮
		{
			_tradeProxy.doOperation(EBusinessOperation._EBusinessOperationConfirm,_tradeCache.currentBusinessId);
		}
		
		private function onClickLock(e:DataEvent):void
		{
			_tradeProxy.doOperation(EBusinessOperation._EBusinessOperationLock,_tradeCache.currentBusinessId);
		}	
		
		/** 自己取消交易 */
		private function onClickTradeCancel(e:DataEvent):void
		{
			_tradeProxy.doOperation(EBusinessOperation._EBusinessOperationCancel,_tradeCache.currentBusinessId);
			clearAtTradeEnd();
		}
		
		
		/** 服务器过来的数据 */
		private function onTradeMsg(e:Object):void
		{
			// TODO Auto Generated method stub
			var mb:SBusiness = e.messageBase as SBusiness;
			var targetTradeInfo:SBusinessInfo = _tradeCache.getTargetSBusinessInfo(mb);
			switch(mb.operation.__value)
			{
				//更新交易物品
				case EBusinessOperation._EBusinessOperationUpdateItem:
					_tradeModule.lock1 = false;
					_tradeModule.lock2 = false;
					_tradeModule.updateTargetItem(targetTradeInfo.items);
					break;
				
				//更新交易金额
				case EBusinessOperation._EBusinessOperationUpdateMoney:
					_tradeModule.lock1 = false;
					_tradeModule.lock2 = false;
					_tradeModule.updateTargetMoneys(targetTradeInfo.gold, targetTradeInfo.coin);
					break;
				//交易锁定
				case EBusinessOperation._EBusinessOperationLock:
					_tradeModule.lock1 = true;
					break;
				//交易确认
				case EBusinessOperation._EBusinessOperationConfirm:
					onTargetTradeComfirm(mb);
					break;
				
				//交易取消
				case EBusinessOperation._EBusinessOperationCancel:
					onTargetTradeCancel(mb);
					break;
				
				//交易完成
				case EBusinessOperation._EBusinessOperationEnd:
					onTradeEnd(mb);
					break;
				
				//同意交易
				case EBusinessOperation._EBusinessOperationAgree:
					onAgreeToTrade(mb);
					break;
				//收到交易申请
				case EBusinessOperation._EBusinessOperationApply:
					onTradeApply(mb,targetTradeInfo);
					break;
				
				//交易错误信息
				case EBusinessOperation._EBusinessOperationError:
					MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(mb.error.code));
					break;
				
				case EBusinessOperation._EBusinessOperationReject:
					MsgManager.showRollTipsMsg(mb.fromInfo.name+"拒绝了你的交易请求");
					break;
			}
			
		}
		
		/**
		 * 目标交易确认 
		 * @param data
		 */		
		private function onTargetTradeComfirm(data:SBusiness):void
		{
//			MsgManager.showRollTipsMsg(Language.getString(41001));
		}
		
		/**
		 * 目标交易取消 
		 * @param data
		 */		
		private function onTargetTradeCancel(data:SBusiness):void
		{
			clearAtTradeEnd();
			MsgManager.showRollTipsMsg("交易已被取消");
		}
		
		/**
		 * 交易完成
		 * @param data
		 */		
		private function onTradeEnd(data:SBusiness):void
		{
			clearAtTradeEnd();
			MsgManager.showRollTipsMsg("交易成功");
		}
		
		/**
		 * 交易中断（完成）时，清除cache里面的物品列表 
		 */		
		private function clearAtTradeEnd():void
		{
			if(GameController.pack.isViewShow)    //关闭背包
			{
				GameController.pack.view.hide();
			}
			if(this.isViewShow)  //关闭交易面板
			{
				this.view.hide();
			}
			_tradeCache.isTrading = false;
			Dispatcher.dispatchEvent(new DataEvent(EventName.Trade_StatusChange));
		}
		
		/**
		 * 收到交易申请 
		 * @param data
		 */		
		private function onTradeApply(data:SBusiness ,targetTradeInfo:SBusinessInfo):void
		{
			if(SystemSetting.instance.isRefuseTrade.bValue ||   //设置了拒绝交易
				cache.friend.isBlackList(targetTradeInfo.entityId))    //黑名单玩家
			{
				//直接拒绝交易
				_tradeProxy.doOperation(EBusinessOperation._EBusinessOperationReject, data.businessId);
				return;
			}
			
			_tradeCache.addToRequest(data);
			TradeIcon.instance.show();
		}
		
		/**
		 * 开始交易   
		 * @param data
		 */		
		private function onAgreeToTrade(data:SBusiness):void
		{
			_tradeCache.currentSbusiness = data;
			
			//打开交易和背包
			LayerManager.windowLayer.tweenCenterWindow(this.view,GameController.pack.view);
			cache.trade.isTrading = true;
			Dispatcher.dispatchEvent(new DataEvent(EventName.Trade_StatusChange));
		}
		
	}
}