package mortal.game.net.command.friend
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SFriendRecordMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * @date   2014-2-27 下午4:32:54
	 * @author dengwj
	 */	 
	public class FriendUpdateCommand extends BroadCastCall
	{
		public function FriendUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void{
			Log.debug("I have receive FriendUpdateCommand");
			var msg:SFriendRecordMsg = mb.messageBase as SFriendRecordMsg;
			NetDispatcher.dispatchCmd(ServerCommand.FriendUpdate, msg);
		}
	}
}