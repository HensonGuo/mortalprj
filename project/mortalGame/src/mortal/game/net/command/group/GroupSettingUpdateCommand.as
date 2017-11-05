package mortal.game.net.command.group
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.SGroupSetting;
	
	import com.gengine.debug.Log;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class GroupSettingUpdateCommand extends BroadCastCall
	{
		public function GroupSettingUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive GroupSettingUpdateCommand");
			
			var msg:SGroupSetting = mb.messageBase as SGroupSetting;
			
			_cache.group.groupName = msg.name;
			_cache.group.memberInvite = msg.memberInvite;
			_cache.group.autoEnter = msg.autoEnter;
			
			NetDispatcher.dispatchCmd(ServerCommand.GroupSettingUpdate,null);   //更新队伍设置信息
		    
			if(_cache.group.memberInvite && !_cache.group.isCaptain)  //当队伍设置改为队员可邀请时
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.GetNearPlayer));
			}
		}
	}
}