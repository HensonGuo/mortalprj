package mortal.game.net.command.friend
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.SAttributeUpdate;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * @date   2014-3-4 下午5:47:51
	 * @author dengwj
	 */	 
	public class FriendInfoUpdateCommand extends BroadCastCall
	{
		public function FriendInfoUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void{
			Log.debug("I have receive FriendInfoUpdateCommand");
			var msg:SAttributeUpdate = mb.messageBase as SAttributeUpdate;
			NetDispatcher.dispatchCmd(ServerCommand.FriendInfoUpdate, msg);
		}
	}
}