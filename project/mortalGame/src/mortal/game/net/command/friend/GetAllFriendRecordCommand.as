package mortal.game.net.command.friend
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SFriendRecord;
	import Message.Game.SeqSFriendRecordMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * @date   2014-3-21 上午11:53:59
	 * @author dengwj
	 */	 
	public class GetAllFriendRecordCommand extends BroadCastCall
	{
		public function GetAllFriendRecordCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void{
			Log.debug("I have receive GetAllFriendRecordCommand");
			var msg:SeqSFriendRecordMsg = mb.messageBase as SeqSFriendRecordMsg;
			NetDispatcher.dispatchCmd(ServerCommand.GetAllFriendRecords, msg.records);
		}
	}
}