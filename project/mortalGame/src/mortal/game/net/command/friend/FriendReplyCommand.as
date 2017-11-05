package mortal.game.net.command.friend
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SFriendReplyMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 好友申请的回执
	 * @date   2014-2-27 下午2:36:35
	 * @author dengwj
	 */	 
	public class FriendReplyCommand extends BroadCastCall
	{
		public function FriendReplyCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void{
			Log.debug("I have receive FriendReplyCommand");
			var msg:SFriendReplyMsg = mb.messageBase as SFriendReplyMsg;
			NetDispatcher.dispatchCmd(ServerCommand.FriendApplyReply, msg);
		}
	}
}