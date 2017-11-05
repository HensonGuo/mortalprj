package mortal.game.net.command.group
{
	import Framework.MQ.MessageBlock;
	
	import com.gengine.debug.Log;
	
	import extend.language.Language;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class GroupLeftCommand extends BroadCastCall
	{
		public function GroupLeftCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive GroupLeftCommand");
			
			_cache.group.disbanGroup();
			MsgManager.showRollTipsMsg(Language.getString(30246));
			NetDispatcher.dispatchCmd(ServerCommand.GroupPlayerInfoChange,_cache.group.players);
			NetDispatcher.dispatchCmd(ServerCommand.CaptainChange,null);
//			if(_cache.group.applyList.length)
//			{
//				_cache.group.applyList = [];
//				NetDispatcher.dispatchCmd(ServerCommand.GroupApply,null);
//			}
		}
	}
}