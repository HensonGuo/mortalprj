package mortal.game.net.command.lottery
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EPublicCommand;
	import Message.Public.SLotteryHistory;
	
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class LotteryCommand extends BroadCastCall
	{
		public function LotteryCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			switch(mb.messageHead.command)
			{
				case EPublicCommand._ECmdPublicLotteryHistorys:
					var historys:Array = mb.messageBase as Array;
					Cache.instance.lottery.syncRecordList(historys);
					NetDispatcher.dispatchCmd(ServerCommand.Lottery_Record_Update, null);
					break;
				case EPublicCommand._ECmdPublicLotteryHistoryAdd:
					var record:SLotteryHistory = mb.messageBase as SLotteryHistory;
					Cache.instance.lottery.addRecord(record);
					NetDispatcher.dispatchCmd(ServerCommand.Lottery_Record_Update, null);
					break;
			}
		}
	}
}