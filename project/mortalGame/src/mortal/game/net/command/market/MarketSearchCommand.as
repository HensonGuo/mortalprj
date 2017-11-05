package mortal.game.net.command.market
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SSeqMarketItem;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 市场搜索
	 * @author lizhaoning
	 */
	public class MarketSearchCommand extends BroadCastCall
	{
		public function MarketSearchCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			// TODO Auto Generated method stub
			super.call(mb);
			
			var marketItem:SSeqMarketItem = mb.messageBase as SSeqMarketItem;
			if(marketItem)
			{
				Cache.instance.market.marketItemObj = marketItem;
				NetDispatcher.dispatchCmd(ServerCommand.MarketSearchBack,marketItem);
			}
		}
	}
}