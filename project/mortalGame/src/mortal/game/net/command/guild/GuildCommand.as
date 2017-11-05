package mortal.game.net.command.guild
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EPublicCommand;
	import Message.Game.EOperOption;
	import Message.Game.SGuildApplyNum;
	import Message.Game.SGuildInfo;
	import Message.Game.SGuildLeaderImpeach;
	import Message.Game.SGuildMember;
	import Message.Game.SJoinGuildInfo;
	import Message.Game.SMiniGuildInfo;
	import Message.Game.SPlayerGuildInfo;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SMiniPlayer;
	
	import mortal.game.cache.Cache;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.mvc.core.NetDispatcher;
	
	public class GuildCommand extends BroadCastCall
	{
		public function GuildCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			switch(mb.messageHead.command)
			{
				//公会邀请
				case EPublicCommand._ECmdPublicGuildInvite:
					if(SystemSetting.instance.isRefuseBeAddToGuild.bValue)  //系统设置中是否拒绝邀请入队
					{
						return;
					}
					var inviteInfo:SMiniGuildInfo = mb.messageBase as SMiniGuildInfo;
					Cache.instance.guild.cacheInviteInfo(inviteInfo);
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_INVITE, null);
					break;
				//公会弹劾
				case EPublicCommand._ECmdPublicGuildImpeach:
					var impeachInfo:SGuildLeaderImpeach = mb.messageBase as SGuildLeaderImpeach;
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_IMPEACH, impeachInfo);
					break;
				//弹劾结束
				case EPublicCommand._ECmdPublicGuildLeaderImpeachEnd:
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_IMPEACH_END, null);
					break;
				//申请人数同步
				case EPublicCommand._ECmdPublicGuildApplyNum:
					var num:int = (mb.messageBase as SGuildApplyNum).num;
					Cache.instance.guild.selfGuildInfo.applyNum = num;
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE,null);
					break;
				//新成员加入
				case EPublicCommand._ECmdPublicGuildNewMember:
					var newMemberInfo:SGuildMember = mb.messageBase as SGuildMember;
					Cache.instance.guild.selfGuildInfo.addMember(newMemberInfo);
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_NEW_MEMBER_ADD, null);
					break;
				//公会更新
				case EPublicCommand._ECmdPublicGuildAttributeUpdate:
					var attribute:SGuildInfo = mb.messageBase as SGuildInfo;
					Cache.instance.guild.selfGuildInfo.syncBaseInfo(attribute);
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE, null);
					break;
				//自身信息更新
				case EPublicCommand._ECmdPublicPlayerGuildInfoUpdate:
					var playerGuildInfo:SPlayerGuildInfo = mb.messageBase as SPlayerGuildInfo;
					Cache.instance.guild.selfGuildInfo.selfInfo = playerGuildInfo;
					Cache.instance.guild.selfGuildInfo.setGuildID(playerGuildInfo.guildId);
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE, null);
					break;
				//成员更新
				case EPublicCommand._ECmdPublicGuildMemberInfoUpdate:
					var memberInfo:SGuildMember = mb.messageBase as SGuildMember;
					Cache.instance.guild.selfGuildInfo.updateMember(memberInfo);
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE, null);
					break;
				//踢出成员
				case EPublicCommand._ECmdPublicGuildKickOut:
					var kickOutMemberInfo:SMiniPlayer = mb.messageBase as SMiniPlayer;
					if (kickOutMemberInfo.entityId.id == Cache.instance.role.entityInfo.entityId.id)
					{
						Cache.instance.guild.selfGuildInfo.exitGuild();
						MsgManager.showRollTipsMsg("您被踢出了公会！");
						NetDispatcher.dispatchCmd(ServerCommand.GUILD_EXIT, null);
					}
					else
					{
						Cache.instance.guild.selfGuildInfo.removeMember(kickOutMemberInfo.entityId.id);
						NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE, null);
					}
					break;
				//退出公会
				case EPublicCommand._ECmdPublicPlayerExitGuild:
					var exitMemberInfo:SMiniPlayer = mb.messageBase as SMiniPlayer;
					if (Cache.instance.guild.selfGuildInfo == null)
						return;
					Cache.instance.guild.selfGuildInfo.removeMember(exitMemberInfo.entityId.id);
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE, null);
					break;
				//自己加入公会
				case EPublicCommand._ECmdPublicJoinGuildResult:
					var jionInfo:SJoinGuildInfo = mb.messageBase as SJoinGuildInfo;
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_SELF_JION_SUCCESS, jionInfo);
					break;
				//解散公会
				case EPublicCommand._ECmdPublicDisbandGuild:
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_DISBAND, null);
					break;
				//创建分会
				case EPublicCommand._ECmdPublicCreateBranchGuild:
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_BRANCH_CREATE, null);
					break;
				//警告成员数
				case EPublicCommand._ECmdPublicWarningMemberNum:
					num = (mb.messageBase as SGuildApplyNum).num;
					Cache.instance.guild.selfGuildInfo.warnMemberNum = num;
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE, null);
					break;
				//优秀成员数
				case EPublicCommand._ECmdPublicExcellentMemberNum:
					num = (mb.messageBase as SGuildApplyNum).num;
					Cache.instance.guild.selfGuildInfo.goodMemberNum = num;
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE, null);
					break;
				//邀请创建公会
				case EPublicCommand._ECmdPublicInviteCreateGuild:
					var inviteCreateInfo:SMiniGuildInfo = mb.messageBase as SMiniGuildInfo;
					NetDispatcher.dispatchCmd(ServerCommand.GUILD_CREATE_INVITE, inviteCreateInfo);
					break;
				case EPublicCommand._ECmdPublicCreateBranchGuild:
					//do nothing
					break;
				case EPublicCommand._ECmdPublicInviteCreateSuccess:
					break;
				case EPublicCommand._ECmdPublicInviteCreateFail:
					break;
			}
		}
		
	}
}