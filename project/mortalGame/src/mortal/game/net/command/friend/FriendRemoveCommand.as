package mortal.game.net.command.friend
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SFriendRemoveMsg;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * @date   2014-3-4 下午4:00:04
	 * @author dengwj
	 */	 
	public class FriendRemoveCommand extends BroadCastCall
	{
		public function FriendRemoveCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void{
			Log.debug("I have receive FriendRemoveCommand");
			var msg:SFriendRemoveMsg = mb.messageBase as SFriendRemoveMsg;
			NetDispatcher.dispatchCmd(ServerCommand.FriendDelete, msg);
		}
	}
}