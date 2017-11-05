package mortal.game.net.command.group
{
	import Framework.MQ.MessageBlock;
	
	import com.gengine.debug.Log;
	
	import extend.language.Language;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class GroupKickOutCommand extends BroadCastCall
	{
		public function GroupKickOutCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive GroupKickOutCommand");
			_cache.group.disbanGroup();
			
			NetDispatcher.dispatchCmd(ServerCommand.GroupPlayerInfoChange,_cache.group.players);
			NetDispatcher.dispatchCmd(ServerCommand.CaptainChange,null);
			MsgManager.showRollTipsMsg(Language.getString(30244));
		}
	}
}