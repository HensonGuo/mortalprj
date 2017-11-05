package mortal.game.net.command.friend
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SFriendApplyMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;

	/**
	 * 申请好友回执
	 * @date   2014-2-24 上午11:33:01
	 * @author dengwj
	 */	 
	public class FriendApplyCommand extends BroadCastCall
	{
		public function FriendApplyCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void{
			Log.debug("I have receive FriendApplyCommand");
			var msg:SFriendApplyMsg = mb.messageBase as SFriendApplyMsg;
			NetDispatcher.dispatchCmd(ServerCommand.FriendApplyRemind, msg.apply);
		}
	}
}