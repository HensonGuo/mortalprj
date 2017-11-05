/**
 * @date 2011-3-14 下午06:54:08
 * @author  hexiaoming
 * 
 */
package mortal.game.net.command.chat
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SChatMsg;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class ChatMessageCommand extends BroadCastCall
	{
		public function ChatMessageCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			super.call(mb);
			var chatMessage:SChatMsg = mb.messageBase as SChatMsg;
			NetDispatcher.dispatchCmd(ServerCommand.ChatMessageUpdate,chatMessage);
		}
	}
}