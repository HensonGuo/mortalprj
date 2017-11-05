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
	 * 市场取消求购返回
	 * @author lizhaoning
	 */
	public class MarketCancelSeekBuyCommand extends BroadCastCall
	{
		public function MarketCancelSeekBuyCommand(type:Object)
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
					NetDispatcher.dispatchCmd(ServerCommand.MarketCancelSeekBuy,null);
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