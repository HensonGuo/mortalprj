package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IMarket_broadcastMarketRecord;
	import Message.Game.AMI_IMarket_buyMarketItem;
	import Message.Game.AMI_IMarket_cancelSeekBuy;
	import Message.Game.AMI_IMarket_cancelSell;
	import Message.Game.AMI_IMarket_getMarketRecordById;
	import Message.Game.AMI_IMarket_getMyRecords;
	import Message.Game.AMI_IMarket_search;
	import Message.Game.AMI_IMarket_seekBuy;
	import Message.Game.AMI_IMarket_sellItem;
	import Message.Game.AMI_IMarket_sellItem2SeekBuy;
	import Message.Game.SMarketItem;
	
	import mortal.common.error.ErrorCode;
	import mortal.game.cache.MarketCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class MarketProxy extends Proxy
	{
		private var _marketCache:MarketCache;
		
		public function MarketProxy()
		{
			super();
			init()
		}
		
		private function init():void
		{
			_marketCache = this.cache.market;
		}
		
		/**
		* 搜索
		* @param recordType 市场记录类型（EMarketRecordType）
		* @param marketId tMarket.marketId
		* @param codes 物品code数组
		* @param targetPage 目标页
		* @param levelLower 搜索等级下限
		* @param levelUpper 搜索等级上限
		* @param color 颜色限制
		* @param career 职业限制
		* @param order	排序类型（EMarketOrder）
		* @param playerName 玩家名称限制
		* @return 通过ECmdGateMarketSearch返回
		*/
		public function search( recordType : int , marketId : int , codes : Array , targetPage : int , 
								levelLower : int , levelUpper : int , color : int , career : int , 
								order : int , playerName : String ):void
		{
			
			rmi.iMartketPrx.search_async(new AMI_IMarket_search(), recordType, marketId , codes  , 
				targetPage, levelLower , levelUpper  , color  , 
				career , order , playerName );
		}
		
		
		/**
		* 获得我的挂售清单
		* @return 通过ECmdGateMarketGetMySells / ECmdGateMarketGetMySeekBuys返回
		*/
		public function getMyRecords(recordType : int):void
		{
			rmi.iMartketPrx.getMyRecords_async(new AMI_IMarket_getMyRecords(),recordType);
		}
		
		/**
		* 购买
		* @param recordId 市场记录id
		* @return 通过ECmdGateMarketResultBuyItem返回
		*/
		public function buyMarketItem(recordId:Number):void
		{
			rmi.iMartketPrx.buyMarketItem_async(new AMI_IMarket_buyMarketItem(null,expectionFun),recordId);
		}
		
		/**
		* 上架
		* @param code	编码(itemCode或者货币对应枚举值)
		* @paran itemUid 物品Uid
		* @param amount 数量
		* @param price 售价(总价)
		* @param unit 出售单位
		* @param time 挂售时间
		* @param broadcast 是否广播
		* @return 通过ECmdGateMarketResultSellItem返回
		*/
		public function sellItem( code : int , itemUid : String , amount : int , price : int , 
								  unit : int , time : int , broadcast : Boolean ):void
		{
			rmi.iMartketPrx.sellItem_async(new AMI_IMarket_sellItem(),code, itemUid, amount, price, unit,  time,  broadcast);
		}
		
		/**
		* 下架
		* @param recordId 市场记录id
		* @return 通过ECmdGateMarketSearchCancelSell / ECmdGateMarketCancelSeekBuy返回
		*/
		public function cancelSell( recordId:Number ):void
		{
			rmi.iMartketPrx.cancelSell_async(new AMI_IMarket_cancelSell(null,expectionFun),recordId);
		}
		
		/**
		* 出售求购
		* @param recordId 市场记录id
		* @param uid 物品uid
		* @param amount 数量
		* @return 通过ECmdGateMarketResultBuyItem返回
		 */
		public function sellItem2SeekBuy(recordId : Number , uid : String , amount : int ):void
		{
			rmi.iMartketPrx.sellItem2SeekBuy_async(new AMI_IMarket_sellItem2SeekBuy(null,expectionFun),recordId, uid, amount);
		}
		
		/**
		 * * 求购
		 * @param code	编码(itemCode或者货币对应枚举值)
		 * @param amount 数量
		 * @param price	售价(总价)
		 * @param unit	货币类型
		 * @param time	求购时间
		 * @param broadcast 是否广播
		 * @return 通过ECmdGateMarketResultSellItem返回
		 */
		public function seekBuy(code : int , amount : int , price : int ,
								unit : int , time : int , broadcast : Boolean ):void
		{
			rmi.iMartketPrx.seekBuy_async(new AMI_IMarket_seekBuy(),code, amount , price, unit, time , broadcast );
		}
		
		/**
		 * 取消求购
		 * @param recordId 市场记录id
		 * @return 通过ECmdGateMarketSearchCancelSell / ECmdGateMarketCancelSeekBuy返回
		 */
		public function cancelSeekBuy( recordId : Number ):void
		{
			rmi.iMartketPrx.cancelSeekBuy_async(new AMI_IMarket_cancelSeekBuy, recordId);
		}
		
		/**
		* 广播
		* @param recordId 市场记录id
		*/
		public function broadcastMarketRecord( recordId : Number ):void
		{
			rmi.iMartketPrx.broadcastMarketRecord_async(new AMI_IMarket_broadcastMarketRecord(null,expectionFun),recordId);
		}
		
		
		/**
		* 获取市场记录
		* @param recordId 市场记录id
		* @return item 记录
		*/
		public function getMarketRecordById( recordId : Number ):void
		{
			rmi.iMartketPrx.getMarketRecordById_async(new AMI_IMarket_getMarketRecordById(getMarketRecoredSucced),recordId);
		}
		private function getMarketRecoredSucced(e:AMI_IMarket_getMarketRecordById,item:SMarketItem):void
		{
			_marketCache.marketItemRecord = item;
			NetDispatcher.dispatchCmd(ServerCommand.MarketItemRecordUpdate,item);
		}
		
		private function expectionFun(e:Exception):void
		{
			// TODO Auto Generated method stub
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketError,e));
		}
	}
}