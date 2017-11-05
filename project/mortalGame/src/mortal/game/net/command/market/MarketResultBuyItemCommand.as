package mortal.game.net.command.market
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.EMarketRecordType;
	import Message.Game.EMarketResult;
	import Message.Game.SMarketResult;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 市场购买、出售求购返回
	 * @author lizhaoning
	 */
	public class MarketResultBuyItemCommand extends BroadCastCall
	{
		public function MarketResultBuyItemCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			// TODO Auto Generated method stub
			super.call(mb);
			
			var marketResult:SMarketResult = mb.messageBase as SMarketResult;
			if(marketResult.result == EMarketResult._EMarketResultSuccess) 
			{
				MsgManager.showRollTipsMsg("操作成功");
				NetDispatcher.dispatchCmd(ServerCommand.MarketResultBuyItem,null);
			}
			else if(marketResult.result == EMarketResult._EMarketResultFail)  
			{
				MsgManager.showRollTipsMsg("操作失败");
			}
		}
	}
}