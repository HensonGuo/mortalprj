package mortal.game.net.command.group
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.SSeqGroup;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class GetGroupInfosBackCommand extends BroadCastCall
	{
		public function GetGroupInfosBackCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive GetGroupInfosBackCommand");
			var msg:SSeqGroup = mb.messageBase as SSeqGroup;
			
			_cache.group.nearTeamList = msg.groups;
			
			NetDispatcher.dispatchCmd(ServerCommand.GetNearTeam,null);
		}
	}
}