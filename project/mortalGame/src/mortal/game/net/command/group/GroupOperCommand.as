package mortal.game.net.command.group
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.EGroupOperType;
	import Message.Public.SGroupOper;
	
	import com.gengine.debug.Log;
	
	import extend.language.Language;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.view.group.GroupIcon;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.mvc.core.NetDispatcher;
	
	public class GroupOperCommand extends BroadCastCall
	{
		public function GroupOperCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive GroupOperCommand");
			var msg:SGroupOper = mb.messageBase as SGroupOper;
			var type:int = msg.type;
			switch(type)
			{
				case EGroupOperType._EGroupOperTypeApply:   //申请
					_cache.group.addApplyList(msg);
					NetDispatcher.dispatchCmd(ServerCommand.GroupApply,null);
					if(!_cache.group.autoEnter)  //自动加入
					{
						GroupIcon.tabIndex = 3;
						GroupIcon.instance.show();
					}
					break;
				case EGroupOperType._EGroupOperTypeInvite:    //邀请
					if(SystemSetting.instance.isRefuseBeAddToGroup.bValue)  //系统设置中是否拒绝邀请入队
					{
						return;
					}
					_cache.group.addInviteList(msg);
					NetDispatcher.dispatchCmd(ServerCommand.GroupInvite,null);
					GroupIcon.tabIndex = 4;
					GroupIcon.instance.show();
					break;
				case EGroupOperType._EGroupOperTypeRejectApply:
					MsgManager.showRollTipsMsg(msg.fromPlayer.name + Language.getString(30251));
					break;
				case EGroupOperType._EGroupOperTypeRejectInvite:
					MsgManager.showRollTipsMsg(msg.fromPlayer.name + Language.getString(30252));
					break;
				default:
					break;
			}
		}
	}
}