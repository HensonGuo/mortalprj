package mortal.game.net.command.friend
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SFriendInfoMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * @date   2014-3-4 上午11:49:20
	 * @author dengwj
	 */	 
	public class FriendOnlineOfflineCommand extends BroadCastCall
	{
		public function FriendOnlineOfflineCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void{
			Log.debug("I have receive FriendOnlineOfflineCommand");
			var msg:SFriendInfoMsg = mb.messageBase as SFriendInfoMsg;
			NetDispatcher.dispatchCmd(ServerCommand.FriendOnlineStatus, msg);
		}
	}
}