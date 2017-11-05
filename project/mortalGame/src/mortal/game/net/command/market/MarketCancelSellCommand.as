package mortal.game.net.command.market
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.EMarketResult;
	import Message.Game.SMarketResult;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 市场取消寄售返回
	 * @author lizhaoning
	 */
	public class MarketCancelSellCommand extends BroadCastCall
	{
		public function MarketCancelSellCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			// TODO Auto Generated method stub
			super.call(mb);
			
			var sResult:SMarketResult = mb.messageBase as SMarketResult;
			if(sResult)
			{
				if(sResult.result == EMarketResult._EMarketResultSuccess)
				{
					NetDispatcher.dispatchCmd(ServerCommand.MarketSearchCancelSell,null);
					MsgManager.showRollTipsMsg("操作成功");
				}
				else if(sResult.result == EMarketResult._EMarketResultFail)
				{
					MsgManager.showRollTipsMsg("操作失败");
				}
			}
		}
	}
}