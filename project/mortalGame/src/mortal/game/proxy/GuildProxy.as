package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IGuild_antiImpeach;
	import Message.Game.AMI_IGuild_applyGuild;
	import Message.Game.AMI_IGuild_applyPlayersGuild;
	import Message.Game.AMI_IGuild_cancelApply;
	import Message.Game.AMI_IGuild_changeGuildPurpose;
	import Message.Game.AMI_IGuild_changePlayerGuildData;
	import Message.Game.AMI_IGuild_changeYYQQ;
	import Message.Game.AMI_IGuild_createBranchGuild;
	import Message.Game.AMI_IGuild_createGuild;
	import Message.Game.AMI_IGuild_dealApply;
	import Message.Game.AMI_IGuild_dealInvite;
	import Message.Game.AMI_IGuild_disbandGuild;
	import Message.Game.AMI_IGuild_exitGuild;
	import Message.Game.AMI_IGuild_getApplyList;
	import Message.Game.AMI_IGuild_getExcellentMemberList;
	import Message.Game.AMI_IGuild_getGuildInfo;
	import Message.Game.AMI_IGuild_getGuildList;
	import Message.Game.AMI_IGuild_getGuildPlayerInfo;
	import Message.Game.AMI_IGuild_getWarningMemberList;
	import Message.Game.AMI_IGuild_guildRecruit;
	import Message.Game.AMI_IGuild_impeachGuildLeader;
	import Message.Game.AMI_IGuild_invitePlayer;
	import Message.Game.AMI_IGuild_memberOper;
	import Message.Game.AMI_IGuild_searchGuilds;
	import Message.Game.AMI_IGuild_setExcellentCondition;
	import Message.Game.AMI_IGuild_setWarningCondition;
	import Message.Game.AMI_IGuild_updateGuild;
	import Message.Game.AMI_IGuild_updateGuildName;
	import Message.Game.AMI_IGuild_updatePlayerGuildData;
	import Message.Game.EApplyGuildType;
	import Message.Game.ECreate;
	import Message.Game.EGuildPosition;
	import Message.Game.EInviteMode;
	import Message.Game.EOperOption;
	import Message.Game.EUpgradeGuildType;
	import Message.Game.SGuildInfo;
	import Message.Game.SGuildMember;
	import Message.Public.EEntityAttribute;
	import Message.Public.EUpdateType;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.GameDefConfig;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;
	
	public class GuildProxy extends Proxy
	{
		public function GuildProxy()
		{
			super();
		}
		
		/*
		* 创建公会
		* @param playerId 创建者ID(客户端传0）
		* @param mode 创建模式(1-花费创建 0-免费创建)
		* @param name 公会名
		* @param purpose 宗旨
		* @exception
		*/
		public function createGuild(mode:int, name:String, purpose:String):void
		{
			rmi.iGuild.createGuild_async(new AMI_IGuild_createGuild(createGuildSuccess, createGuildFail), 0, new ECreate(mode), name, purpose);
		}
		
		private function createGuildSuccess(e:AMI_IGuild_createGuild, guildID:int):void
		{
			cache.guild.selfGuildInfo.setGuildID(guildID);
			MsgManager.showRollTipsMsg("创建公会成功");
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_CREATE,null);
		}
		
		private function createGuildFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("创建公会失败");
		}
		
		
		
		
		/*
		* 创建分会
		* @exception
		*/
		public function createBranchGuild():void
		{
			rmi.iGuild.createBranchGuild_async(new AMI_IGuild_createBranchGuild(createBranchGuildSuccess, createBranchGuildFail));
		}
		
		private function createBranchGuildSuccess(e:AMI_IGuild_createBranchGuild):void
		{
			MsgManager.showRollTipsMsg("创建分会成功");
			cache.guild.selfGuildInfo.onCreateBranch();
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_BRANCH_CREATE,null);
		}
		
		private function createBranchGuildFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("创建分会失败");
		}
		
		
		
		
		/*
		* 解散公会
		*/
		public function disbandGuild():void
		{
			rmi.iGuild.disbandGuild_async(new AMI_IGuild_disbandGuild(disbandGuildSuccess, disbandGuildFail));
		}
		
		private function disbandGuildSuccess(e:AMI_IGuild_disbandGuild):void
		{
			cache.guild.selfGuildInfo.disbandGuild();
			MsgManager.showRollTipsMsg("成功解散公会");
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_DISBAND,null);
		}
		
		private function disbandGuildFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("解散公会失败");
		}
		
		
		
		
		
		/*
		* 修改仙盟名称
		* @param newGuildName	新的仙盟名称
		* @exception
		*/
		public function changeGuildName(newGuildName:String):void
		{
			rmi.iGuild.updateGuildName_async(new AMI_IGuild_updateGuildName(changeGuildNameSuccess, changeGuildNameFail), newGuildName);
		}
		
		private function changeGuildNameSuccess(e:AMI_IGuild_updateGuildName):void
		{
			MsgManager.showRollTipsMsg("成功修改公会名称");
			cache.guild.selfGuildInfo.baseInfo.guildName = e.userObject.newGuildName;
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE,null);
		}
		
		private function changeGuildNameFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("修改公会名称失败");
		}
		
		
		
		
		
		/*
		* 修改公会宗旨
		* @param playerId 玩家id（客户端传0)
		* @param purpose 宗旨
		* @exception
		*/
		private var _purpose:String = null;
		
		public function changeGuildPurpose(purpose:String):void
		{
			_purpose = purpose;
			rmi.iGuild.changeGuildPurpose_async(new AMI_IGuild_changeGuildPurpose(changeGuildPurposeSuccess, changeGuildPurposeFail), 0, purpose);
		}
		
		private function changeGuildPurposeSuccess(e:AMI_IGuild_changeGuildPurpose):void
		{
			MsgManager.showRollTipsMsg("成功修改公会宗旨");
			cache.guild.selfGuildInfo.baseInfo.purpose = _purpose;
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE,null);
		}
		
		private function changeGuildPurposeFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("修改公会宗旨失败");
		}
		
		
		
		
		
		
		/*
		* 修改YY/QQ群号码
		* @param option        修改选项(EOperOptionYY-YY EOperOptionQQ-QQ)
		* @param number        QQ群/语音群号
		* @exception
		*/
		public function changeYYQQ(operType:int, numStr:String):void
		{
			rmi.iGuild.changeYYQQ_async(new AMI_IGuild_changeYYQQ(changeYYQQSuccess, changeYYQQFail), new EOperOption(operType), numStr);
		}
		
		private function changeYYQQSuccess(e:AMI_IGuild_changeYYQQ):void
		{
			if ((e.userObject.option as EOperOption).__value == EOperOption._EOperOptionQQ)
			{
				
				MsgManager.showRollTipsMsg("成功修改公会QQ");
				cache.guild.selfGuildInfo.baseInfo.QQ = e.userObject.string;
			}
			else
			{
				MsgManager.showRollTipsMsg("成功修改公会YY");
				cache.guild.selfGuildInfo.baseInfo.YY = e.userObject.string;
			}
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE,null);
		}
		
		private function changeYYQQFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("修改失败");
		}
		
		
		
		
		
		
		/*
		* 获取公会信息
		* @param guildId 公会id
		* @param
		*/
		public function getGuildInfo(guildID:int):void
		{
			rmi.iGuild.getGuildInfo_async(new AMI_IGuild_getGuildInfo(getGuildInfoSuccess, getGuildInfoFail), guildID);
		}
		
		private function getGuildInfoSuccess(e:AMI_IGuild_getGuildInfo, guildInfo:SGuildInfo):void
		{
			if (guildInfo.guildId == cache.guild.selfGuildInfo.guildID)
			{
				cache.guild.selfGuildInfo.syncBaseInfo(guildInfo);
			}
			else
			{
				cache.guild.otherGuildInfo = guildInfo;
			}
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE,null);
		}
		
		private function getGuildInfoFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("获取公会信息失败");
		}
		
		
		
		
		
		/*
		* 搜索公会
		* @param camp 阵营(所有用0)
		* @param guildName 公会名
		* @return myRank 排名
		* @return totalNum 符合条件的所有公会数
		* @return guilds 公会信息
		* @exception
		*/
		private var _searchStartIndex:int;
		
		public function searchGuilds(camp:int, guildName:String, startIdx:int, isFull:Boolean):void
		{
			_searchStartIndex = startIdx;
			rmi.iGuild.searchGuilds_async(new AMI_IGuild_searchGuilds(searchGuildsSuccess, searchGuildsFail), camp, guildName, startIdx, isFull)
		}
		
		private function searchGuildsSuccess(e:AMI_IGuild_searchGuilds, myRank:int, totalNum:int, guilds:Array):void
		{
			cache.guild.syncList(_searchStartIndex, totalNum, guilds);
			if (cache.guild.selfGuildInfo.selfHasJoinGuild)
			{
				cache.guild.selfGuildInfo.baseInfo.rank = myRank;
			}
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_LIST_UPDATE,null);
		}
		
		private function searchGuildsFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("没有搜到对应的帮会哦");
		}
		
		
		
		
		
		
		/*
		* 申请公会
		* @param playerId 玩家ID(客户端传0)
		* @param guildId 公会ID
		* @param type    申请工会类型
		* @exception
		*/
		private var _applyType:int = 0;
		
		public function applyGuild(guildId:int, type:int):void
		{
			_applyType = type;
			rmi.iGuild.applyGuild_async(new AMI_IGuild_applyGuild(applyGuildSuccess, applyGuildFail), 0, guildId, new EApplyGuildType(type));
		}
		
		private function applyGuildSuccess(e:AMI_IGuild_applyGuild):void
		{
			if (_applyType == EApplyGuildType._EApplyGuild)
			{
				MsgManager.showRollTipsMsg("已申请，请耐心等候");
			}
			else if (_applyType == EApplyGuildType._EApplyBranchGuild)
			{
				MsgManager.showRollTipsMsg("主动申请进入");
			}
		}
		
		private function applyGuildFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("已申请过该公会");
		}
		
		
		
		
		
		
		/*
		* 申请加入玩家的公会
		* @param playerId 目标玩家id
		* @exception
		*/
		public function applyPlayersGuild(playerID:int):void
		{
			rmi.iGuild.applyPlayersGuild_async(new AMI_IGuild_applyPlayersGuild(applyPlayersGuildSuccess, applyPlayersGuildFail), playerID);
		}
		
		private function applyPlayersGuildSuccess(e:AMI_IGuild_applyPlayersGuild):void
		{
			MsgManager.showRollTipsMsg("申请成功");
		}
		
		private function applyPlayersGuildFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("申请失败");
		}
		
		
		
		
		
		
		
		/*
		* 取消申请
		* @param guildId 公会ID
		* @exception
		*/
		public function cancelApply(guildID:int):void
		{
			rmi.iGuild.cancelApply_async(new AMI_IGuild_cancelApply(cancelApplySuccess, cancelApplyFail), guildID);
		}
		
		private function cancelApplySuccess(e:AMI_IGuild_cancelApply):void
		{
			MsgManager.showRollTipsMsg("处理成功");
		}
		
		private function cancelApplyFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("处理失败");
		}
		
		
		
		
		
		
		
		/*
		* 处理申请
		* @param fromPlayerId 处理者(客户端传0)
		* @param toPlayerId 被处理者(传0表示所有申请者)
		* @param oper 是否同意
		* @exception
		*/
		public function dealApply(targetPlayerId:int, oper:Boolean):void
		{
			rmi.iGuild.dealApply_async(new AMI_IGuild_dealApply(dealApplySuccess, dealApplyFail), 0, targetPlayerId, oper);
		}
		
		private function dealApplySuccess(e:AMI_IGuild_dealApply, playerIDs:Array):void
		{
			for (var i:int = 0; i < playerIDs.length; i++)
			{
				cache.guild.selfGuildInfo.removeApplyMember(playerIDs[i]);
			}
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_APPLY_LIST_UPDATE,null);
			MsgManager.showRollTipsMsg("处理成功");
		}
		
		private function dealApplyFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("处理失败");
		}
		
		
		
		
		
		/*
		* 邀请玩家加入公会
		* @param fromPlayerId 邀请者id(客户端传0)
		* @param toPlayerId 被邀请者id
		*/
		public function invitePlayer(targetPlayerId:int, mode:int):void
		{
			rmi.iGuild.invitePlayer_async(new AMI_IGuild_invitePlayer(invitePlayerSuccess, invitePlayerFail), 0, targetPlayerId, new EInviteMode(mode));
		}
		
		private function invitePlayerSuccess(e:AMI_IGuild_invitePlayer):void
		{
			MsgManager.showRollTipsMsg("邀请成功");
		}
		
		private function invitePlayerFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("邀请失败");
		}
		
		
		
		
		
		
		/*
		* 处理邀请
		* @param playerId 处理者(客户端传0)
		* @param guildId 仙盟id
		* @param oper 是否同意
		* @exception
		*/
		private var _dealInviteGuildID:int;
		
		public function dealInvite(guildID:int, oper:Boolean, mode:int):void
		{
			_dealInviteGuildID = guildID;
			rmi.iGuild.dealInvite_async(new AMI_IGuild_dealInvite(dealInviteSuccess, dealInviteFail), 0, guildID, oper, new EInviteMode(mode));
		}
		
		private function dealInviteSuccess(e:AMI_IGuild_dealInvite):void
		{
			cache.guild.removeInviteInfo(_dealInviteGuildID);
			MsgManager.showRollTipsMsg("处理成功");
		}
		
		private function dealInviteFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("处理失败");
		}
		
		
		
		
		
		
		/*
		* 成员操作
		* @param fromPlayerId 操作者(客户端传0)
		* @param toPlayerId 被操作者
		* @param position 目标职位(EPositionNotMember 开除)
		* @exception
		*/
		private var _oprateID:int;
		private var _pos:int;
		
		public function operationMember(targetPlayerId:int, pos:int):void
		{
			_oprateID = targetPlayerId;
			_pos = pos;
			rmi.iGuild.memberOper_async(new AMI_IGuild_memberOper(operationMemberSuccess, operationMemberFail), 0, targetPlayerId, new EGuildPosition(pos));
		}
		
		private function operationMemberSuccess(e:AMI_IGuild_memberOper):void
		{
			cache.guild.selfGuildInfo.changeMemberPosition(_oprateID, _pos);
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_MEMBERS_UPDATE,null);
			var member:SGuildMember = cache.guild.selfGuildInfo.getMemberById(_oprateID);
			
			if (_pos == EGuildPosition._EGuildNotMember)
			{
				MsgManager.showRollTipsMsg("您成功将" + member.miniPlayer.name + "踢出公会！");
			}
			else
			{
				var positionName:String = GameDefConfig.instance.getItem("EGuildPostion", _pos).text;
				MsgManager.showRollTipsMsg("您成功任命" + member.miniPlayer.name + "为" + positionName);
			}
		}
		
		private function operationMemberFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("处理失败");
		}
		
		
		
		
		
		
		/*
		* 查看公会申请列表
		* @param guildId 公会ID
		* @param guildApplys 公会申请列表
		* @exception
		*/
		public function getApplyList(guildID:int):void
		{
			rmi.iGuild.getApplyList_async(new AMI_IGuild_getApplyList(getApplyListSuccess, getApplyListFail), guildID);
		}
		
		private function getApplyListSuccess(e:AMI_IGuild_getApplyList, guildApplys:Array):void
		{
			cache.guild.selfGuildInfo.applyMemberList = guildApplys;
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_APPLY_LIST_UPDATE,null);
		}
		
		private function getApplyListFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("没有申请数据");
		}
		
		
		
		
		
		
		/*
		* 获取公会玩家信息
		* @param guildId 公会ID(客户端传0)
		* @param guildPlayers 公会玩家信息
		*/
		public function getGuildMemberList(guildID:int):void
		{
			rmi.iGuild.getGuildPlayerInfo_async(new AMI_IGuild_getGuildPlayerInfo(getGuildAllPlayerInfoSuccess, getGuildAllPlayerInfoFail), guildID);
		}
		
		private function getGuildAllPlayerInfoSuccess(e:AMI_IGuild_getGuildPlayerInfo, guildPlayers:Array):void
		{
			cache.guild.selfGuildInfo.syncMemberList(guildPlayers);
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_MEMBERS_UPDATE,null);
		}
		
		private function getGuildAllPlayerInfoFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("无成员数据");
		}
		
		
		
		
		
		
		/*
		* 公会升级
		* @exception
		*/
		public function levelUpGuild(type:int):void
		{
			rmi.iGuild.updateGuild_async(new AMI_IGuild_updateGuild(levelUpGuildSuccess, levelUpGuildFail), new EUpgradeGuildType(type));
		}
		
		private function levelUpGuildSuccess(e:AMI_IGuild_updateGuild):void
		{
			//升级成功后服务端会推送升级成功
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_INFO_UPDATE,null);
		}
		
		private function levelUpGuildFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("升级失败");
		}
		
		
		
		
		
		
		/*
		* 弹劾盟主（主动弹劾）
		* @param result 弹劾结果（1成功，0失败）
		* @exception
		*/
		public function impeachGuildLeader():void
		{
			rmi.iGuild.impeachGuildLeader_async(new AMI_IGuild_impeachGuildLeader(impeachGuildLeaderSuccess));
		}
		
		private function impeachGuildLeaderSuccess(e:AMI_IGuild_impeachGuildLeader, result:Boolean):void
		{
			if (result)
			{
				MsgManager.showRollTipsMsg("发起弹劾成功");
			}
			else
			{
				MsgManager.showRollTipsMsg("发起弹劾失败");
			}
		}
		
		
		
		
		
		/*
		* 反驳弹劾
		* @param result 弹劾结果
		* @exception
		*/
		public function antiImpeach():void
		{
			rmi.iGuild.antiImpeach_async(new AMI_IGuild_antiImpeach(antiImpeachSuccess, antiImpeachFail));
		}
		
		private function antiImpeachSuccess(e:AMI_IGuild_antiImpeach):void
		{
			MsgManager.showRollTipsMsg("反驳弹劾成功");
		}
		
		private function antiImpeachFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("反驳弹劾失败");
		}
		
		
		
		
		
		/*
		* 退出工会
		* @param playerId 玩家id
		* @exception
		*/
		public function exitGuild():void
		{
			rmi.iGuild.exitGuild_async(new AMI_IGuild_exitGuild(exitGuildSuccess), 0);
		}
		
		private function exitGuildSuccess(e:AMI_IGuild_exitGuild, result:Boolean):void
		{
			if (result)
			{
				cache.guild.selfGuildInfo.exitGuild();
				MsgManager.showRollTipsMsg("退出公会成功");
				NetDispatcher.dispatchCmd(ServerCommand.GUILD_EXIT,null);
			}
			else
			{
				MsgManager.showRollTipsMsg("退出公会失败");
			}
		}
		
		
		
		
		
		
		/*
		* 工会列表请求
		* @param playerId 玩家id
		* @param startIndex 下标
		* @param guilds     工会信息
		* @param outCount   息
		* @exception
		*/
		public function getGuildList(startIndex:int):void
		{
			rmi.iGuild.getGuildList_async(new AMI_IGuild_getGuildList(getGuildListSuccess, getGuildListFail), 0, startIndex);
		}
		
		private function getGuildListSuccess(e:AMI_IGuild_getGuildList,  myRank:int, guilds:Array, outStartIndex:int, outCount:int):void
		{
			if (cache.guild.selfGuildInfo.selfHasJoinGuild)
			{
				cache.guild.selfGuildInfo.baseInfo.rank = myRank;
			}
			cache.guild.syncList(outStartIndex, outCount, guilds);
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_LIST_UPDATE,null);
		}
		
		private function getGuildListFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg("获取公会列表失败");
		}
		
		
		
		
		/*
		* 警告成员列表请求
		* @param playerId		填0
		* @param warningMembers 警告成员列表 
		* @exception
		*/
		public function getWarningMemberList():void
		{
			rmi.iGuild.getWarningMemberList_async(new AMI_IGuild_getWarningMemberList(getWarningMemberListSuccess, getWarningMemberListFail), 0);
		}
		
		private function getWarningMemberListSuccess(e:AMI_IGuild_getWarningMemberList, warningMembers:Array):void
		{
			cache.guild.selfGuildInfo.warnMemberList = warningMembers;
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_WARN_OR_GOOD_LIST_UPDATE,null);
		}
		
		private function getWarningMemberListFail(e:AMI_IGuild_getWarningMemberList):void
		{
			MsgManager.showRollTipsMsg("获取失败");
		}
		
		
		
		
		
		/*
		* 设置警告成员筛选条件
		* @param playerId		  填0
		* @param days			  离线天数
		* @param activity		  活跃度
		* @param chatTimes        群发言次数
		* @param contributionWeek 周贡献
		* @exception
		*/
		public function setWarningCondition(playerId:int, days:int, activity:int, chatTimes:int, contributionWeek:int):void
		{
			rmi.iGuild.setWarningCondition_async(new AMI_IGuild_setWarningCondition(setWarningConditionSuccess, setWarningConditionFail), 0, days, activity, chatTimes, contributionWeek);
		}
		
		public function setWarningConditionSuccess(e:AMI_IGuild_setWarningCondition):void
		{
			MsgManager.showRollTipsMsg("设置成功");
		}
		
		public function setWarningConditionFail(e:AMI_IGuild_setWarningCondition):void
		{
			MsgManager.showRollTipsMsg("设置失败");
		}
		
		
		
		
		
		
		/*
		* 优秀成员列表请求
		* @param playerId		  填0
		* @param excellentMembers 优秀成员列表 
		* @exception
		*/
		public function getGoodMemberList():void
		{
			rmi.iGuild.getExcellentMemberList_async(new AMI_IGuild_getExcellentMemberList(getGoodMemberListSuccess, getGoodMemberListFail), 0);
		}
		
		private function getGoodMemberListSuccess(e:AMI_IGuild_getExcellentMemberList, excellentMembers:Array):void
		{
			cache.guild.selfGuildInfo.goodMemberList = excellentMembers;
			NetDispatcher.dispatchCmd(ServerCommand.GUILD_WARN_OR_GOOD_LIST_UPDATE,null);
		}
		
		private function getGoodMemberListFail(e:AMI_IGuild_getExcellentMemberList):void
		{
			MsgManager.showRollTipsMsg("获取失败");
		}
		
		
		
		
		
		/*
		* 设置优秀成员筛选条件
		* @param playerId		  填0
		* @param days			  离线天数
		* @param levelRank		  等级排名
		* @param chatTimes        群发言次数
		* @param contributionWeek 周贡献
		* @exception
		*/
		public function setGoodCondition(playerId:int, days:int, chatTimes:int, contributionWeek:int, levelRank:int):void
		{
			rmi.iGuild.setExcellentCondition_async(new AMI_IGuild_setExcellentCondition(setGoodConditionSuccess, setGoodConditionFail), 
				0, days, chatTimes, contributionWeek, levelRank);
		}
		
		public function setGoodConditionSuccess(e:AMI_IGuild_setExcellentCondition):void
		{
			MsgManager.showRollTipsMsg("设置成功");
		}
		
		public function setGoodConditionFail(e:AMI_IGuild_setExcellentCondition):void
		{
			MsgManager.showRollTipsMsg("设置失败");
		}
		
		
		/*
		* 公会招募
		*/
		public function recruit():void
		{
			rmi.iGuild.guildRecruit_async(new AMI_IGuild_guildRecruit());
		}
		
	}
}