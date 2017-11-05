package mortal.game.net.command.group
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.SEntityId;
	import Message.Public.SGroup;
	import Message.Public.SGroupPlayer;
	
	import com.gengine.debug.Log;
	
	import extend.language.Language;
	
	import mortal.game.cache.Cache;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;
	
	public class GroupInfoCommand extends BroadCastCall
	{
		public function GroupInfoCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive GroupInfoCommand");
			var msg:SGroup = mb.messageBase as SGroup;
			
			var oldCaptainId:SEntityId = _cache.group.captain;
			var oldGroupData:Array = _cache.group.players;
			var newGroupData:Array = msg.players;
			
			_cache.group.captain = msg.captainId;
			_cache.group.groupId = msg.groupId;
			_cache.group.players = msg.players;
			_cache.group.groupName = msg.name;
			_cache.group.memberInvite = msg.memberInvite;
			_cache.group.autoEnter = msg.autoEnter;
			
//			NetDispatcher.dispatchCmd(ServerCommand.GroupPlayerInfoChange,_cache.group.players);   //更新队伍信息
		
			if(oldGroupData.length == 0)  //显示进入队伍
			{
				MsgManager.showRollTipsMsg(Language.getString(30241));
				//清空邀请列表
				if(_cache.group.inviteList.length)
				{
					_cache.group.inviteList = [];
					NetDispatcher.dispatchCmd(ServerCommand.GroupInvite,null);
				}

			}  
			else if(msg.captainId.id == _cache.role.entityInfo.entityId.id && oldCaptainId.id != _cache.role.entityInfo.entityId.id) 
			{
				MsgManager.showRollTipsMsg(Language.getString(30247));  //被任命为队长
				
			}
			else if(msg.captainId.id != _cache.role.entityInfo.entityId.id && oldCaptainId.id == _cache.role.entityInfo.entityId.id) 
			{
				//转移自己的队长位置后清空申请列表
				_cache.group.applyList = [];   
				NetDispatcher.dispatchCmd(ServerCommand.GroupApply,null);
			}
		
//			if(oldGroupData.length == 5 && newGroupData.length <=4)   //假如队伍从满员变成不满员,则更新附近玩家信息
//			{
//				NetDispatcher.dispatchCmd(ServerCommand.GetNearPlayer,null);
//			}
			
			if(oldCaptainId == null || oldCaptainId.id != msg.captainId.id)
			{
				NetDispatcher.dispatchCmd(ServerCommand.CaptainChange,null);
			}
			
			
			//用于显示谁加入或退出队伍的信息
			var i:int = 0;
			var j:int = 0;
			var player:SGroupPlayer;
			var oldPlayer:SGroupPlayer;
			var exist:Boolean = false;
			if(newGroupData.length > oldGroupData.length)   //队员增加
			{
				for(i = 0; i < newGroupData.length; i++)
				{
					player = newGroupData[i] as SGroupPlayer;
					exist = false;
					for(j = 0; j < oldGroupData.length; j++)
					{
						oldPlayer = oldGroupData[j] as SGroupPlayer;
						if(player.player.entityId.id == oldPlayer.player.entityId.id)
						{
							exist = true;
//							oldGroupData.splice(j,1);
						}
					}
					if(!exist)
					{
						if(player.player.name != Cache.instance.role.playerInfo.name)  //不是自己加入
						{
							MsgManager.showRollTipsMsg(Language.getStringByParam(30242,player.player.name));
							
							if(_cache.group.isCaptain && newGroupData.length == 5)
							{
								NetDispatcher.dispatchCmd(ServerCommand.GetNearPlayer,null);
							}
						}
					}
				}
			}
			else  //队员减少
			{
				for(i = 0; i < oldGroupData.length; i++)
				{
					player = oldGroupData[i] as SGroupPlayer;
					exist = false;
					for(j = 0; j < newGroupData.length; j++)
					{
						oldPlayer = newGroupData[j] as SGroupPlayer;
						if(player.player.entityId.id == oldPlayer.player.entityId.id)
						{
							exist = true;
//							newGroupData.splice(j,1);
						}
					}
					if(!exist)
					{
						if(player.player.name != _cache.role.playerInfo.name)   //不是自己离开
						{
							MsgManager.showRollTipsMsg(Language.getStringByParam(30245,player.player.name));
							
							NetDispatcher.dispatchCmd(ServerCommand.TeamMateLeft,player.player.entityId);
							
							if(_cache.group.isCaptain)
							{
								NetDispatcher.dispatchCmd(ServerCommand.GetNearPlayer,null);
							}
						}
					}
				}
			}
			
			NetDispatcher.dispatchCmd(ServerCommand.GroupPlayerInfoChange,_cache.group.players);   //更新队伍信息
			
		}
	}
}