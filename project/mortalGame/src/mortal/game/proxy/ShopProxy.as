package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IPanicBuy_buyItem;
	import Message.Game.AMI_IPanicBuy_closePanicBuyPanel;
	import Message.Game.AMI_IPanicBuy_getPanicBuyConfig;
	import Message.Game.AMI_IShop_buy;
	import Message.Game.AMI_IShop_buyAndUse;
	import Message.Game.AMI_IShop_buyBack;
	import Message.Game.SPanicBuyMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.common.error.ErrorCode;
	import mortal.game.cache.Cache;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.shopMall.ShopCache;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;
	
	public class ShopProxy extends Proxy
	{
		private var _shopCache:ShopCache;
		
		public function ShopProxy()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_shopCache = this.cache.shop;
		}
		
		/**
		 * 购买物品 
		 * @param npcId
		 * @param shopCode
		 * @param itemCode
		 * @param amount
		 * @param priorityFlag
		 * 
		 */		
		public function buy(npcId:int, shopCode:int , itemCode:int, amount:int, priorityFlag:int):void
		{
			rmi.iShopPrx.buy_async(new AMI_IShop_buy(), npcId, shopCode, itemCode, amount, priorityFlag);
		}
		
		/**
		 * 购买并使用物品 
		 * @param npcId
		 * @param shopCode
		 * @param itemCode
		 * @param amount
		 * @param useAmount
		 * 
		 */		
		public function buyAndUse(npcId:int, shopCode:int , itemCode:int, amount:int, useAmount:int):void
		{
			rmi.iShopPrx.buyAndUse_async(new AMI_IShop_buyAndUse(), npcId, shopCode, itemCode, amount, useAmount);
		}
		
		/**
		 * 回购商品 
		 * @param arr
		 * 
		 */		
		public function buyBack(arr:Array):void
		{
			rmi.iShopPrx.buyBack_async(new AMI_IShop_buyBack(buyBackSuccess,buyBackFail),arr);
		}
		
		private function buyBackSuccess(e:AMI_IShop_buyBack):void
		{
			Log.debug("回购成功");
		}
		
		private function buyBackFail(e:Exception):void
		{
			Log.debug("回购失败");
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
		}
		
		
		
		//以下是抢购的接口===========================================================
		
		/**
		 * 获取抢购配置 
		 * 
		 */		
		public function getPanicBuyConfig():void
		{
			rmi.iPanicBuyPrx.getPanicBuyConfig_async(new AMI_IPanicBuy_getPanicBuyConfig(getConfigSuccess,getConfigFail));
		}
		
		private function getConfigSuccess(e:AMI_IPanicBuy_getPanicBuyConfig, sPanicBuyMsg:SPanicBuyMsg):void
		{
			Log.debug("获取配置成功");
			if(sPanicBuyMsg.type == 0)  //普通抢购
			{
				_shopCache.panicInfo = sPanicBuyMsg.panicBuyShop;
				_shopCache.updatePanicList( sPanicBuyMsg.panicBuyItems );
			}
			
			var cdData:CDData = Cache.instance.cd.registerCDData(CDDataType.backPackLock, "PanicCd", cdData) as CDData;
			cdData.totalTime = sPanicBuyMsg.panicBuyShop.leftSeconds*1000;
			cdData.startCoolDown();
			
			NetDispatcher.dispatchCmd(ServerCommand.PanicUndate,null);   //更新团购信息
		}
		
		private function getConfigFail(e:Exception):void
		{
			Log.debug("获取配置失败");
		}
		
		/**
		 * 关闭抢购窗口 
		 * 
		 */		
		public function closePanicBuyPanel():void
		{
			rmi.iPanicBuyPrx.closePanicBuyPanel_async(new AMI_IPanicBuy_closePanicBuyPanel());
		}
		
		/**
		 * 购买抢购物品 
		 * @param itemCode
		 * 
		 */		
		public function buyItem(itemCode:int):void
		{
			rmi.iPanicBuyPrx.buyItem_async(new AMI_IPanicBuy_buyItem(panicSuccess,panicFail),itemCode);
		}
		
		private function panicSuccess(e:AMI_IPanicBuy_buyItem):void
		{
			Log.debug("抢购成功");
		}
		
		private function panicFail(e:Exception):void
		{
			Log.debug("抢购失败");
			Log.debug(e.code,ErrorCode.getErrorStringByCode(e.code),e.message);
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
			
		}
	}
}