package mortal.game.view.guild
{
	import Message.DB.Tables.TGuildBranchTarget;
	import Message.DB.Tables.TGuildLevelTarget;
	import Message.Game.EApplyGuildType;
	import Message.Game.ECreate;
	import Message.Game.EGuildPosition;
	import Message.Game.EInviteMode;
	import Message.Game.EJoinGuildType;
	import Message.Game.EUpgradeGuildType;
	import Message.Game.SBranchGuildInfo;
	import Message.Game.SGuildLeaderImpeach;
	import Message.Game.SGuildMember;
	import Message.Game.SJoinGuildInfo;
	import Message.Game.SMiniGuildInfo;
	import Message.Public.EPrictUnit;
	import Message.Public.SMiniPlayer;
	
	import com.mui.controls.Alert;
	
	import flash.events.Event;
	
	import mortal.component.gconst.GuildConst;
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.cache.guild.GuildCache;
	import mortal.game.cache.guild.SelfGuildInfo;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.tableConfig.GuildBranchLevelUpTargetConfig;
	import mortal.game.resource.tableConfig.GuildLevelTargetConfig;
	import mortal.game.view.guild.otherpanel.GuildApplyListPanel;
	import mortal.game.view.guild.otherpanel.GuildCreatePanel;
	import mortal.game.view.guild.otherpanel.GuildListPanel;
	import mortal.game.view.guild.otherpanel.GuildWelcomePanel;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	
	public class GuildController extends Controller
	{
		public function GuildController()
		{
			super();
		}
		
		override protected function initServer():void
		{
			NetDispatcher.addCmdListener(ServerCommand.GUILD_CREATE, createGuildResponse);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_CREATE_INVITE, inviteCreateGuildResponse);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_BRANCH_CREATE, createBranchResponse);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_DISBAND, disbandGuildResponse);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_EXIT, exitGuildResponse);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_APPLY_LIST_UPDATE, applyListUpdate);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_INVITE, inviteResponse);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_IMPEACH, impeachResponse);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_NEW_MEMBER_ADD, newMemberAdd);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_LIST_UPDATE,guildListUpdate);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_SELF_JION_SUCCESS,selfJionSuccess);
			
			Dispatcher.addEventListener(EventName.GUILD_CREATE, createGuildRequest);
			Dispatcher.addEventListener(EventName.GUILD_CREATE_BRANCH, createBranchRequest);
			Dispatcher.addEventListener(EventName.GUILD_BRANCH_LEVEL_UP, levelUpBranchRequest);
			Dispatcher.addEventListener(EventName.GUILD_DISBAND, disbandGuildRequest);
			Dispatcher.addEventListener(EventName.GUILD_EXIT, exitGuildRequest);
			Dispatcher.addEventListener(EventName.GUILD_SEARCH, searchGuild);
			Dispatcher.addEventListener(EventName.GUILD_LIST_GET, getGuildList);
			Dispatcher.addEventListener(EventName.GUILD_APPLY_LIST_GET, getApplyList);
			Dispatcher.addEventListener(EventName.GUILD_APPLY, apply);
			Dispatcher.addEventListener(EventName.GUILD_APPLY_BY_ROLE, applyByRole);
			Dispatcher.addEventListener(EventName.GUILD_DEAL_APPLY, dealApply);
			Dispatcher.addEventListener(EventName.GUILD_INVITE, inviteRequest);
			Dispatcher.addEventListener(EventName.GUILD_DEAL_INVITE, dealInvite);
			Dispatcher.addEventListener(EventName.GUILD_PURPOSE_CHANGE, changeGuildPurpose);
			Dispatcher.addEventListener(EventName.GUILD_POSITION_OPRATE, oprateGuildPostion);
			Dispatcher.addEventListener(EventName.GUILD_RECRUIT, guildRecruit);
			Dispatcher.addEventListener(EventName.GUILD_IMPEACH_LEADER, impeachLeader);
			Dispatcher.addEventListener(EventName.GUILD_LEVEL_UP, levelUpGuild);
			Dispatcher.addEventListener(EventName.GUILD_KICK_OUT_MEMEBER, kickOutMember);
		}
		
		override protected function initView():IView
		{
			if (cache.guild.selfGuildInfo.selfHasJoinGuild)
			{
				if (!(_view is GuildModule))
				{
					_view = new GuildModule();
					_view.addEventListener(WindowEvent.SHOW,onViewShow);
					_view.addEventListener(WindowEvent.CLOSE,onViewHide);
					
					GameProxy.guild.getGuildInfo(cache.guild.selfGuildInfo.guildID);
					GameProxy.guild.getGuildMemberList(cache.guild.selfGuildInfo.guildID);
				}
			}
			else
			{
				return GuildListPanel.instance;
			}
			return _view;
		}
		
		protected function onViewShow(e:Event):void
		{
			//add cmdListener
			NetDispatcher.addCmdListener(ServerCommand.GUILD_INFO_UPDATE,guildUpdate);
			NetDispatcher.addCmdListener(ServerCommand.GUILD_MEMBERS_UPDATE,guildMemberListUpdate);
		}
		
		protected function onViewHide(e:Event):void
		{
			//remove cmdListener
			NetDispatcher.removeCmdListener(ServerCommand.GUILD_INFO_UPDATE,guildUpdate);
			NetDispatcher.removeCmdListener(ServerCommand.GUILD_MEMBERS_UPDATE,guildMemberListUpdate);
		}
		
		
		
		
		/**
		 * 请求创建公会
		 */
		private function createGuildRequest(e:DataEvent):void
		{
			if (cache.guild.selfGuildInfo.selfHasJoinGuild)
			{
				MsgManager.showRollTipsMsg("已经加入公会不能创建！");
				return;
			}
			if (cache.role.roleInfo.level < GuildConst.CreateGuildRequireLevel)
			{
				MsgManager.showRollTipsMsg("等级不够！");
				return;
			}
			var obj:Object = e.data;
			if (obj.type == ECreate._ECreateMoney)
			{
				var enoughMoney:Boolean = cache.role.enoughMoney(EPrictUnit._EPriceUnitGold, GuildConst.CreateGuildRequireCostGold);
				if (!enoughMoney)
				{
					MsgManager.showRollTipsMsg("元宝不足！");
					return;
				}
			}
			GameProxy.guild.createGuild(obj.type, obj.name, obj.purpose);
		}
		
		/**
		 * 创建公会
		 */
		private function createGuildResponse(obj:Object=null):void
		{
			GuildCreatePanel.instance.hide();
			initView().show();
		}
		
		/**
		 * 邀请创建
		 */
		private function inviteCreateGuildResponse(obj:Object=null):void
		{
			var guildInfo:SMiniGuildInfo = obj as SMiniGuildInfo;
			var createDesc:String = guildInfo.leaderName + "邀请您共建新公会，成为创建元老，需缴纳5000绑定铜钱的费用，是否同意?";
			var createCallback:Function = function (type:int):void
			{
				if(type == Alert.OK)
				{
					GameProxy.guild.dealInvite(guildInfo.guildId, true, EInviteMode._EInviteForCreateGuild);
				}
				else
				{
					GameProxy.guild.dealInvite(guildInfo.guildId, false, EInviteMode._EInviteForCreateGuild);
				}
			}
			Alert.show(createDesc, null, Alert.OK|Alert.CANCEL, null, createCallback);
		}
		
		
		
		
		/**
		 * 请求创建分会
		 */
		private function createBranchRequest(e:DataEvent):void
		{
			var branchTargetConfig:TGuildBranchTarget = GuildBranchLevelUpTargetConfig.instance.getInfoByTarget(1);
			var createCallback:Function = function (type:int):void
			{
				if(type == Alert.OK)
				{
					if (cache.guild.selfGuildInfo.baseInfo.level < branchTargetConfig.freeLevel)
					{
						if (!cache.role.enoughMoney(EPrictUnit._EPriceUnitGoldBind, branchTargetConfig.cost))
						{
							MsgManager.showRollTipsMsg("元宝不足！");
							return;
						}
						GameProxy.guild.createBranchGuild();
					}
					else
					{
						GameProxy.guild.createBranchGuild();
					}
				}
			};
				
			var createDesc:String;
			if (cache.guild.selfGuildInfo.baseInfo.level < branchTargetConfig.freeLevel)
			{
				createDesc = "您准备创建1级分会，增加" + branchTargetConfig.amount + "人数上限，需花费" + branchTargetConfig.cost + 
					"元宝，是否创建？"
			}
			else
			{
				createDesc = "您准备创建1级分会，增加" + branchTargetConfig.amount + "人数上限，是否创建？";
			}
				
			Alert.show(createDesc, null, Alert.OK|Alert.CANCEL, null, createCallback);
		}
		
		/**
		 * 请求升级分会
		 */
		private function levelUpBranchRequest(e:DataEvent):void
		{
			var targetLevel:int = cache.guild.selfGuildInfo.branchInfo.level + 1;
			var branchTargetConfig:TGuildBranchTarget = GuildBranchLevelUpTargetConfig.instance.getInfoByTarget(targetLevel);
			if (branchTargetConfig == null)
			{
				MsgManager.showRollTipsMsg("分会已达满级");
				return;
			}
			
			if (cache.guild.selfGuildInfo.baseInfo.level < branchTargetConfig.freeLevel)
			{
				if (!cache.role.enoughMoney(EPrictUnit._EPriceUnitGoldBind, branchTargetConfig.cost))
				{
					MsgManager.showRollTipsMsg("元宝不足！");
					return;
				}
				GameProxy.guild.levelUpGuild(EUpgradeGuildType._EUpgradeBranchGuild);
			}
			else
			{
				GameProxy.guild.levelUpGuild(EUpgradeGuildType._EUpgradeBranchGuild);
			}
		}
		
		/**
		 * 分会创建成功
		 */
		private function createBranchResponse(obj:Object=null):void
		{
			(_view as GuildModule).onCreateGuildBranch();
		}
		
		
		
		
		
		/**
		 * 请求解散公会
		 */
		private function disbandGuildRequest(e:DataEvent):void
		{
			var guildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
			if (!guildInfo.memberList.length >= GuildConst.CanDisbandGuildMembersLimit)
			{
				MsgManager.showRollTipsMsg("总会人数超过10人，不可解散");
				return;
			}
			var disbandCallback:Function = function(type:int):void
			{
				if(type == Alert.OK)
				{
					GameProxy.guild.disbandGuild();
				}
			}
			Alert.show("您准备解散" + guildInfo.baseInfo.guildName + "公会,解散后此公会将不复存在,是否确定?", null, Alert.OK|Alert.CANCEL, null, disbandCallback);
		}
		
		/**
		 * 解散公会
		 */
		private function disbandGuildResponse(obj:Object=null):void
		{
			_view.hide();
			_view = null;
		}
		
		
		
		
		
		/**
		 * 请求退出公会
		 */
		private function exitGuildRequest(e:DataEvent):void
		{
			var guildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
			if (guildInfo.selfInfo.position > 2)
			{
				MsgManager.showRollTipsMsg("您有公会重职，请卸任后再退出！");
				return;
			}
			var exitCallback:Function = function(type:int):void
			{
				if(type == Alert.OK)
				{
					GameProxy.guild.exitGuild();
				}
			}
			Alert.show("您选择退出" + guildInfo.baseInfo.guildName + "公会，" +
				"退出后公会贡献将扣除并只能携带80%进入新公会，是否确定？", null, Alert.OK|Alert.CANCEL, null, exitCallback);
			
		}
		
		/**
		 * 退出公会
		 */
		private function exitGuildResponse(obj:Object=null):void
		{
			if (_view == null)
				return;
			_view.hide();
			_view = null;
		}
		
		
		
		/**
		 * 公会弹劾
		 */
		private function impeachLeader(e:DataEvent):void
		{
			GameProxy.guild.impeachGuildLeader();
		}
		
		private function impeachResponse(obj:Object=null):void
		{
			var impeachInfo:SGuildLeaderImpeach = obj as SGuildLeaderImpeach;
		}
		
		
		
		
		/**
		 * 公会职位操作
		 */
		private function oprateGuildPostion(e:DataEvent):void
		{
			var targetID:int = e.data.targetID;
			var positon:int = e.data.position;
			GameProxy.guild.operationMember(targetID, positon);
		}
		
		/**
		 * 踢出成员
		 */
		private function kickOutMember(e:DataEvent):void
		{
			var targetID:int = int(e.data);
			var memberInfo:SGuildMember = Cache.instance.guild.selfGuildInfo.getMemberById(targetID);
			if (Cache.instance.guild.selfGuildInfo.selfInfo.position < memberInfo.position)
			{
				MsgManager.showRollTipsMsg("权限不够!");
				return;
			}
			if (memberInfo.totalContribution > 0)
			{
				var callback:Function = function(type:int):void
				{
					if(type == Alert.OK)
					{
						GameProxy.guild.operationMember(targetID, EGuildPosition._EGuildNotMember);
					}
				}
				Alert.show("踢出该成员将降低公会资源" + memberInfo.totalContribution + "公会，是否踢出？", null, Alert.OK|Alert.CANCEL, null, callback);
			}
			else
			{
				GameProxy.guild.operationMember(targetID, EGuildPosition._EGuildNotMember);
			}
		}
		
		/**
		 * 更改公会宗旨
		 */
		private function changeGuildPurpose(e:DataEvent):void
		{
			var purpose:String = String(e.data);
			if (purpose.length > GuildConst.MaxPurposeLength)
			{
				MsgManager.showRollTipsMsg("公会宗旨长度过长！");
				return;
			}
			GameProxy.guild.changeGuildPurpose(purpose);
		}
		
		/**
		 * 公会招募
		 */
		private function guildRecruit(e:DataEvent):void
		{
			GameProxy.guild.recruit();
		}
		
		/**
		 * 公会升级
		 */
		private function levelUpGuild(e:DataEvent):void
		{
			var targetLevel:int = cache.guild.selfGuildInfo.baseInfo.level + 1;
			var levelUpConfig:TGuildLevelTarget = GuildLevelTargetConfig.instance.getInfoByLevel(targetLevel);
			if (levelUpConfig == null)
			{
				MsgManager.showRollTipsMsg("公会已达满级");
				return;
			}
			if (cache.guild.selfGuildInfo.baseInfo.resource < levelUpConfig.upgradeResource)
			{
				MsgManager.showRollTipsMsg("公会资源不足");
				return;
			}
			GameProxy.guild.levelUpGuild(EUpgradeGuildType._EUpgradeGuild);
		}
		
		
		/**
		 * 搜索公会
		 */
		private function searchGuild(e:DataEvent):void
		{
			var obj:Object = e.data;
			GameProxy.guild.searchGuilds(obj.camp, obj.guildName, obj.startIdx, obj.isfull);
		}
		
		/**
		 * 获取公会列表
		 */
		private function getGuildList(e:DataEvent):void
		{
			var startIndex:int = int(e.data);
			GameProxy.guild.getGuildList(startIndex);
		}
		
		/**
		 * 公会列表更新 
		 */
		private function guildListUpdate(obj:Object=null):void
		{
			GuildListPanel.instance.update();
		}
		
		/**
		 * 公会更新 
		 */
		private function guildUpdate(e:DataEvent):void
		{
			(_view as GuildModule).update();
		}
		
		/**
		 * 公会成员更新 
		 */
		private function guildMemberListUpdate(e:DataEvent):void
		{
			(_view as GuildModule).update();
		}
		
		/**
		 * 公会新成员加入
		 */
		private function newMemberAdd(obj:Object=null):void
		{
			if (_view == null)
				return;
			(_view as GuildModule).update();
		}
		
		/**
		 * 自己成功加入公会
		 */
		private function selfJionSuccess(obj:Object=null):void
		{
			var joinInfo:SJoinGuildInfo = obj as SJoinGuildInfo;
			if (joinInfo.dealResult == 0)
			{
				MsgManager.showRollTipsMsg("您申请" + joinInfo.miniGuild.guildName + "公会被拒绝！");
				return;
			}
			switch(joinInfo.tpye.__value)
			{
				case EJoinGuildType._EApplyJoinGuild:
					MsgManager.showRollTipsMsg("您的申请通过，成功加入" + joinInfo.miniGuild.guildName + "公会！");
					break;
				case EJoinGuildType._EInviteJoinGuild:
					MsgManager.showRollTipsMsg("您被" + joinInfo.miniGuild.guildName + "邀请进入公会成功！");
					break;
			}
			cache.guild.selfGuildInfo.setGuildID(joinInfo.miniGuild.guildId);
			_view = initView();
			_view.show();
			GuildWelcomePanel.instance.show();
			GuildWelcomePanel.instance.setData(joinInfo.miniGuild);
		}
		
		
		
		/**
		 * 公会邀请响应
		 */
		private function inviteResponse(obj:Object=null):void
		{
			var dealInviteCallback:Function = function(type:int):void
			{
				if(type == Alert.OK)
				{
					GameProxy.guild.dealInvite(inviteInfo.guildId, true, EInviteMode._EInviteForJoinGuild);
				}
				else
				{
					GameProxy.guild.dealInvite(inviteInfo.guildId, false, EInviteMode._EInviteForJoinGuild);
				}
			};
			var inviteInfo:SMiniGuildInfo = cache.guild.inviteList[cache.guild.inviteList.length - 1];
			Alert.show(inviteInfo.guildName + "邀请您加入" + inviteInfo.guildName + "公会，是否同意？", null, Alert.OK|Alert.CANCEL, null, dealInviteCallback);
		}
		
		/**
		 * 处理邀请
		 */
		private function dealInvite(e:DataEvent):void
		{
			GameProxy.guild.dealInvite(e.data.guildId, e.data.agree, EInviteMode._EInviteForJoinGuild);
		}
		
		/**
		 * 发出邀请
		 */
		private function inviteRequest(e:DataEvent):void
		{
			var playerID:int = int(e.data);
			GameProxy.guild.invitePlayer(playerID, EInviteMode._EInviteForJoinGuild);
		}
		
		
		
		
		
		
		
		/**
		 * 请求申请公会
		 */
		private function apply(e:DataEvent):void
		{
			if (cache.guild.selfGuildInfo.selfHasJoinGuild)
			{
				MsgManager.showRollTipsMsg("您已加入过公会!");
				return;
			}
			if (cache.role.roleInfo.level < GuildConst.CreateGuildRequireLevel)
			{
				MsgManager.showRollTipsMsg("等级不足！");
				return;
			}
			var guildInfo:SMiniGuildInfo = e.data.guildInfo as SMiniGuildInfo;
			if (cache.role.roleEntityInfo.entityInfo.camp != guildInfo.camp)
			{
				MsgManager.showRollTipsMsg("不能加入不同阵营的公会!");
				return;
			}
			switch(e.data.type)
			{
				case EApplyGuildType._EApplyGuild:
					if (guildInfo.playerNum == guildInfo.maxPlayerNum)
					{
						MsgManager.showRollTipsMsg("此公会人数已满!");
						return;
					}
					break;
				case EApplyGuildType._EApplyBranchGuild:
					if (guildInfo.branch.length == 0)
					{
						MsgManager.showRollTipsMsg("此公会还未创建分会!");
						return;
					}
					var branchInfo:SBranchGuildInfo = guildInfo.branch[0];
					if (branchInfo.playerNum == branchInfo.maxPlayerNum)
					{
						MsgManager.showRollTipsMsg("分会人数已满!");
						return;
					}
					break;
			}
			GameProxy.guild.applyGuild(guildInfo.guildId, e.data.type);
		}
		
		/**
		 * 申请玩家公会
		 */
		private function applyByRole(e:DataEvent):void
		{
			var playerId:int = int(e.data);
			GameProxy.guild.applyPlayersGuild(playerId);
		}
		
		/**
		 * 请求处理公会申请 
		 */
		private function dealApply(e:DataEvent):void
		{
			if (e.data.agree == true && cache.guild.selfGuildInfo.memberListIsFull)
			{
				MsgManager.showRollTipsMsg("公会人数已满!");
				return;
			}
			var guildInfo:SelfGuildInfo = cache.guild.selfGuildInfo;
			var handAll:Boolean = e.data.handleAll;
			if (!handAll)
			{
				GameProxy.guild.dealApply(e.data.playerID, e.data.agree);
			}
			else
			{
				//全部同意或拒绝 玩家ID传0
				GameProxy.guild.dealApply(0, e.data.agree);
			}
		}
		
		/**
		 * 请求获取申请列表
		 */
		private function getApplyList(e:DataEvent):void
		{
			GameProxy.guild.getApplyList(cache.guild.selfGuildInfo.guildID);
		}
		
		/**
		 * 公会申请列表更新
		 */
		private function applyListUpdate(obj:Object=null):void
		{
			GuildApplyListPanel.instance.update();
		}
		
	}
}