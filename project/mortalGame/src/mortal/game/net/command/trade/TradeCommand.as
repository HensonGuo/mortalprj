package mortal.game.net.command.trade
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EPublicCommand;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class TradeCommand extends BroadCastCall
	{
		public function TradeCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			// TODO Auto Generated method stub
			super.call(mb);
			
			switch(mb.messageHead.command)
			{
				case EPublicCommand._ECmdPublicBusiness:
					NetDispatcher.dispatchCmd(ServerCommand.TradeUpdate,mb);
					break;
				
				case EPublicCommand._ECmdPublicBusinessApplySuccessful:
					MsgManager.showRollTipsMsg("已向对方发起交易请求");
					break;
			}
		}
	}
}