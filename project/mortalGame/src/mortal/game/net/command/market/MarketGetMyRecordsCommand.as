package mortal.game.net.command.market
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.EMarketRecordType;
	import Message.Game.SSeqMarketItem;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 获得我的挂售清单 返回
	 * @author lizhaoning
	 */
	public class MarketGetMyRecordsCommand extends BroadCastCall
	{
		public function MarketGetMyRecordsCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			// TODO Auto Generated method stub
			super.call(mb);
			
			var marketItem:SSeqMarketItem = mb.messageBase as SSeqMarketItem;
			if(marketItem.recordType == EMarketRecordType._EMarketRecordSeekBuy)  //我的求购
			{
				Cache.instance.market.updateMySeekBuyMarketItemVec(marketItem);
				NetDispatcher.dispatchCmd(ServerCommand.MarketGetMySeekBuysBack,marketItem);
			}
			else if(marketItem.recordType == EMarketRecordType._EMarketRecordSell)  //我的寄售
			{
				Cache.instance.market.updateMySaleMarketItemVec(marketItem);
				NetDispatcher.dispatchCmd(ServerCommand.MarketGetMySellsBack,marketItem);
			}
		}
	}
}