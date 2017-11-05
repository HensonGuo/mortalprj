package mortal.game.net
{
	import Framework.MQ.IMessageHandler;
	import Framework.MQ.MessageBlock;
	
	import Message.Command.ECmdBroadCast;
	import Message.Command.ECmdCoreCommand;
	import Message.Command.EGateCommand;
	import Message.Command.EPublicCommand;
	
	import mortal.game.net.broadCast.BroadCastManager;
	import mortal.game.net.command.*;
	import mortal.game.net.command.buff.BuffUpdateCommand;
	import mortal.game.net.command.chat.ChatMessageCommand;
	import mortal.game.net.command.forging.StrengthenValidateCommand;
	import mortal.game.net.command.friend.FriendApplyCommand;
	import mortal.game.net.command.friend.FriendInfoUpdateCommand;
	import mortal.game.net.command.friend.FriendOnlineOfflineCommand;
	import mortal.game.net.command.friend.FriendRemoveCommand;
	import mortal.game.net.command.friend.FriendReplyCommand;
	import mortal.game.net.command.friend.FriendUpdateCommand;
	import mortal.game.net.command.friend.GetAllFriendRecordCommand;
	import mortal.game.net.command.group.GetGroupInfosBackCommand;
	import mortal.game.net.command.group.GroupDisbandCommand;
	import mortal.game.net.command.group.GroupInfoCommand;
	import mortal.game.net.command.group.GroupKickOutCommand;
	import mortal.game.net.command.group.GroupLeftCommand;
	import mortal.game.net.command.group.GroupMemberUpdateCommand;
	import mortal.game.net.command.group.GroupOperCommand;
	import mortal.game.net.command.group.GroupSettingUpdateCommand;
	import mortal.game.net.command.guild.GuildCommand;
	import mortal.game.net.command.lottery.LotteryCommand;
	import mortal.game.net.command.mail.MailNoticeCommand;
	import mortal.game.net.command.market.MarketCancelSeekBuyCommand;
	import mortal.game.net.command.market.MarketCancelSellCommand;
	import mortal.game.net.command.market.MarketGetMyRecordsCommand;
	import mortal.game.net.command.market.MarketResultBuyItemCommand;
	import mortal.game.net.command.market.MarketResultSeekBuyCommand;
	import mortal.game.net.command.market.MarketResultSellItemCommand;
	import mortal.game.net.command.market.MarketSearchCommand;
	import mortal.game.net.command.mount.MountCommand;
	import mortal.game.net.command.mount.MountInfoCommand;
	import mortal.game.net.command.mount.MountInfoUpdateCommand;
	import mortal.game.net.command.mount.MountUpdateCommand;
	import mortal.game.net.command.pack.ItemCdCommand;
	import mortal.game.net.command.pack.PackInfoCommand;
	import mortal.game.net.command.pack.PackItemCommand;
	import mortal.game.net.command.pet.PetCommand;
	import mortal.game.net.command.player.FightAttributeBaseCommand;
	import mortal.game.net.command.player.FightAttributeCommand;
	import mortal.game.net.command.player.RoleUpdateCommand;
	import mortal.game.net.command.shop.BuyBackCommand;
	import mortal.game.net.command.shop.BuyBackUpdateCommand;
	import mortal.game.net.command.shop.PanicBuyItemCommand;
	import mortal.game.net.command.shop.PanicBuyPlayerCommand;
	import mortal.game.net.command.shop.PanicBuyRefreshCommand;
	import mortal.game.net.command.skill.SkillListCommand;
	import mortal.game.net.command.skill.SkillUpdateCommand;
	import mortal.game.net.command.task.TaskCanGetAddCommand;
	import mortal.game.net.command.task.TaskCanGetDelCommand;
	import mortal.game.net.command.task.TaskCanGetRecvCommand;
	import mortal.game.net.command.task.TaskDoingAddCommand;
	import mortal.game.net.command.task.TaskDoingDelCommand;
	import mortal.game.net.command.task.TaskDoingRecvCommand;
	import mortal.game.net.command.task.TaskShowHideCommand;
	import mortal.game.net.command.task.TaskUpdateCommand;
	import mortal.game.net.command.trade.TradeCommand;
	import mortal.game.net.command.wizard.PlayerSoulInfoCommand;
	import mortal.game.view.skill.command.RuneUpdateCommand;
	import mortal.game.view.systemSetting.command.SystemSettingCommand;
	import mortal.mvc.core.NetDispatcher;

	/**
	 * 服务端推送过来的数据的处理类
	 */
	public class MessageHandler implements IMessageHandler
	{
		protected var _broadCastManager:BroadCastManager;
		/**
		 * 
		 */
		public function MessageHandler()
		{
			_broadCastManager = BroadCastManager.instance;
			registerCall();
		}
		
		/**
		 * 注册command用于处理数据加工 
		 */
		protected function registerCall():void
		{
			//错误
			_broadCastManager.registerCall( new ErrorMsgCommand( EPublicCommand._ECmdPublicErrorMsg) ); //错误异常
			_broadCastManager.registerCall( new NoticeMsgCommand( EPublicCommand._ECmdPublicNoticeBroadcastMsg) ); //提示广播信息
			
			_broadCastManager.registerCall( new PositionUpdateCommand( EGateCommand._ECmdGatePositionUpdate) ); //位置更新
			
			//人物
//			_broadCastManager.registerCall( new AttributeUpdateCommand( EGateCommand._ECmdGateRoleUpdate)  );//角色更新
			_broadCastManager.registerCall( new MoneyUpdateCommand( EGateCommand._ECmdGateMoneyUpdate)  );//角色更新
			_broadCastManager.registerCall(new FightAttributeBaseCommand( EPublicCommand._ECmdPublicFightAttributeBase)); //战斗基础属性更新
			_broadCastManager.registerCall(new FightAttributeCommand( EPublicCommand._ECmdPublicFightAttributeExtra)); //扩展属性
			_broadCastManager.registerCall(new FightAttributeCommand( EPublicCommand._ECmdPublicFightAttribute)); // 战斗最终属性更新
			_broadCastManager.registerCall(new RoleUpdateCommand(EGateCommand._ECmdGateRoleUpdate)); // 人物属性更新
			
			//坐骑
			_broadCastManager.registerCall(new MountCommand(EGateCommand._ECmdGateMount));//(宝具,经验,等级等属性变化时)
			_broadCastManager.registerCall(new MountInfoCommand(EGateCommand._ECmdGateMountInfo));//(宝具,经验,等级等属性变化时)
			_broadCastManager.registerCall(new MountUpdateCommand(EGateCommand._ECmdGateMountUpdate));//玩家打开坐骑面板时获取所有坐骑信息
			_broadCastManager.registerCall(new MountInfoUpdateCommand(EGateCommand._ECmdGateMountInfoUpdate));//获得或者删除坐骑时
			
			
			//背包
			_broadCastManager.registerCall(new PackInfoCommand(EGateCommand._ECmdGateBag));//背包更新
			_broadCastManager.registerCall( new PackItemCommand(EGateCommand._ECmdGatePlayerItemUpdate));//包裹格子更新
			
			//邮件
			_broadCastManager.registerCall(new MailNoticeCommand(EGateCommand._ECmdGateMailNotice));//新邮件提醒
			
			//市场
			_broadCastManager.registerCall(new MarketSearchCommand(EGateCommand._ECmdGateMarketSearch)); //  市场搜索
			_broadCastManager.registerCall(new MarketResultSellItemCommand(EGateCommand._ECmdGateMarketResultSellItem)); //  市场寄售返回
			_broadCastManager.registerCall(new MarketResultSeekBuyCommand(EGateCommand._ECmdGateMarketResultSeekBuy)); //  市场求购返回
			_broadCastManager.registerCall(new MarketResultBuyItemCommand(EGateCommand._ECmdGateMarketResultBuyItem)); // 市场购买、出售求购返回
			_broadCastManager.registerCall(new MarketGetMyRecordsCommand(EGateCommand._ECmdGateMarketGetMyRecords)); //  获得我的挂售清单 返回
			_broadCastManager.registerCall(new MarketCancelSellCommand(EGateCommand._ECmdGateMarketResultCancelSell)); //  取消寄售 返回
			_broadCastManager.registerCall(new MarketCancelSeekBuyCommand(EGateCommand._ECmdGateMarketResultCancelSeekBuy)); //  取消求购返回
			
			//交易
			_broadCastManager.registerCall(new TradeCommand(EPublicCommand._ECmdPublicBusiness));
			_broadCastManager.registerCall(new TradeCommand(EPublicCommand._ECmdPublicBusinessApplySuccessful));
			
			//系统设置
			_broadCastManager.registerCall(new SystemSettingCommand(EGateCommand._ECmdGateClientSetting)); // 系统设置
			
			//技能
 			_broadCastManager.registerCall(new SkillListCommand(EGateCommand._ECmdGateSkill)); // 玩家技能
			_broadCastManager.registerCall(new SkillUpdateCommand(EGateCommand._ECmdGateSkillUpdate)); // 技能更新
			
			//cd
			_broadCastManager.registerCall(new ItemCdCommand(EGateCommand._ECmdGateDrugCanUseDt));  //物品cd信息
			
			//buff
			_broadCastManager.registerCall(new BuffUpdateCommand(EGateCommand._ECmdGateBuffUpdate));  //Buff信息
			
			//宠物相关信息整合一块处理
			_broadCastManager.registerCall(new PetCommand(EGateCommand._ECmdGatePetInfo));  //获得或者删除一个宠物
			_broadCastManager.registerCall(new PetCommand(EGateCommand._ECmdGatePetInfoUpdate));  //获得或者删除一个宠物
			_broadCastManager.registerCall(new PetCommand(EGateCommand._ECmdGateFightPetInfo));  //出战宠物信息
			_broadCastManager.registerCall(new PetCommand(EGateCommand._ECmdGatePetUpdate));  //出战宠物信息
			_broadCastManager.registerCall(new PetCommand(EGateCommand._ECmdGatePetSkillUpdate));  //宠物技能更新
			_broadCastManager.registerCall(new PetCommand(EGateCommand._ECmdGatePetSkillWarehouse));  //宠物技能仓库更新
			
			//组队
			_broadCastManager.registerCall(new GroupInfoCommand(EPublicCommand._ECmdPublicGroupInfo));  //获得队伍信息
			_broadCastManager.registerCall(new GroupOperCommand(EPublicCommand._ECmdPublicGroupOper));  //队伍操作
			_broadCastManager.registerCall(new GroupDisbandCommand(EPublicCommand._ECmdPublicGroupDisband));  //解散队伍
			_broadCastManager.registerCall(new GetGroupInfosBackCommand(EPublicCommand._ECmdPublicGetGroupInfosBack)); //获取附近队伍
			_broadCastManager.registerCall(new GroupLeftCommand(EPublicCommand._ECmdPublicGroupLeft));  //离开队伍
			_broadCastManager.registerCall(new GroupSettingUpdateCommand(EPublicCommand._ECmdPublicGroupSettingUpdate));  //队伍设置
			_broadCastManager.registerCall(new GroupKickOutCommand(EPublicCommand._ECmdPublicGroupKickOut)); //踢出队伍
			_broadCastManager.registerCall(new GroupMemberUpdateCommand(EPublicCommand._ECmdPublicGroupMemberUpdate)); //更新队员状态
			
			//精灵
			_broadCastManager.registerCall(new PlayerSoulInfoCommand(EGateCommand._ECmdGatePlayerSoulInfo));  //获取精灵信息
			
			//商店和商城
			_broadCastManager.registerCall(new PanicBuyRefreshCommand(EGateCommand._ECmdGatePanicBuyRefresh));  //更新抢购记录表
			_broadCastManager.registerCall(new PanicBuyPlayerCommand(EGateCommand._ECmdGatePanicBuyPlayer));  //更新本地抢购记录
			_broadCastManager.registerCall(new PanicBuyItemCommand(EGateCommand._ECmdGatePanicBuyItem));  //更新剩余抢购记录
			_broadCastManager.registerCall(new BuyBackCommand(EGateCommand._ECmdGateBuyBack));  //更新所有回购列表
			_broadCastManager.registerCall(new BuyBackUpdateCommand(EGateCommand._ECmdGateBuyBackUpdate));  //更新单个回购商品
			
			//			_broadCastManager.registerCall(new BroadcastEntityAttUpdateCommand(EGateCommand._ECmdBroadcastEntityAttributeUpdate));

			// 任务
			_broadCastManager.registerCall(new TaskCanGetRecvCommand(EGateCommand._ECmdGateTaskCanGet));
			_broadCastManager.registerCall(new TaskCanGetAddCommand(EGateCommand._ECmdGateTaskAddCanGet));
			_broadCastManager.registerCall(new TaskCanGetDelCommand(EGateCommand._ECmdGateTaskRemoveCanGet));
			_broadCastManager.registerCall(new TaskDoingRecvCommand(EGateCommand._ECmdGateTaskMy));
			_broadCastManager.registerCall(new TaskDoingDelCommand(EGateCommand._ECmdGateTaskRemoveMy));
			_broadCastManager.registerCall(new TaskDoingAddCommand(EGateCommand._ECmdGateTaskAddMy));
			_broadCastManager.registerCall(new TaskUpdateCommand(EGateCommand._ECmdGateTaskUpdate));
			
			// 好友
			_broadCastManager.registerCall(new FriendApplyCommand(EGateCommand._ECmdGateFriendApply));
			_broadCastManager.registerCall(new FriendReplyCommand(EGateCommand._ECmdGateFriendReply));
			_broadCastManager.registerCall(new FriendUpdateCommand(EGateCommand._ECmdGateFriendRecord));
			_broadCastManager.registerCall(new FriendOnlineOfflineCommand(EGateCommand._ECmdGateFriendOnlineStatus));
			_broadCastManager.registerCall(new FriendRemoveCommand(EGateCommand._ECmdGateFriendRemove));
			_broadCastManager.registerCall(new FriendInfoUpdateCommand(EGateCommand._ECmdGateFriendInfoUpdate));
			_broadCastManager.registerCall(new GetAllFriendRecordCommand(EGateCommand._ECmdGateFriendInfo));// 上线获取所有列表记录
			
			//聊天
			_broadCastManager.registerCall(new ChatMessageCommand( EGateCommand._ECmdGateChatMsg));//公共聊天
			
			// 锻造
			_broadCastManager.registerCall(new StrengthenValidateCommand( EGateCommand._ECmdGateStrength));//前四级强化信息
			
			// 符文
			_broadCastManager.registerCall(new RuneUpdateCommand(EGateCommand._ECmdGateRuneUpdate));
			
			//公会
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicGuildInvite));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicGuildImpeach));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicGuildLeaderImpeachEnd));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicGuildApplyNum));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicGuildNewMember));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicGuildAttributeUpdate));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicPlayerGuildInfoUpdate));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicGuildMemberInfoUpdate));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicGuildKickOut));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicPlayerExitGuild));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicJoinGuildResult));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicDisbandGuild));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicCreateBranchGuild));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicWarningMemberNum));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicExcellentMemberNum));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicInviteCreateGuild));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicInviteCreateSuccess));
			_broadCastManager.registerCall(new GuildCommand(EPublicCommand._ECmdPublicInviteCreateFail));
			
			_broadCastManager.registerCall(new TaskShowHideCommand(EGateCommand._ECmdGateTaskShow));
			
			_broadCastManager.registerCall(new LotteryCommand(EPublicCommand._ECmdPublicLotteryHistorys));
			_broadCastManager.registerCall(new LotteryCommand(EPublicCommand._ECmdPublicLotteryHistoryAdd));
		}
		
		/**
		 * 数据推过来时触发
		 * @param mb
		 */
		public function onMessage( mb : MessageBlock ):void
		{
			switch( mb.messageHead.command )
			{
				case ECmdBroadCast._ECmdBroadcastEntityInfo: // 单个实体信息
				case ECmdBroadCast._ECmdBroadcastEntityInfos: //批量实体信息
				case ECmdBroadCast._ECmdBroadcastEntityMoveInfo: // 实体移动信息
				case ECmdBroadCast._ECmdBroadcastEntityDiversion: // 实体转向移动信息
				case ECmdBroadCast._ECmdBroadcastEntityLeftInfo: // 实体离开信息
				case ECmdBroadCast._ECmdBroadcastEntityLeftInfos: // 批量实体离开信息
				case ECmdBroadCast._ECmdBroadcastEntityAttributeUpdate:  //实体更新信息
				case ECmdBroadCast._ECmdBroadcastEntityAttributeUpdates: //批量实体更新
				case ECmdBroadCast._ECmdBroadcastEntityGuildIdUpdate: //实体广播更新公会Id
				case ECmdBroadCast._ECmdBroadcastEntityGroupIdUpdate: //实体组队信息更新
				case ECmdBroadCast._ECmdBroadcastEntityDoFight:  //执行战斗操作
				case ECmdBroadCast._ECmdBroadcastEntityDoFights:  //执行战斗操作
				case ECmdBroadCast._ECmdBroadcastEntityBeginFight: //实体开始战斗
				case ECmdBroadCast._ECmdBroadcastEntitySkillCast: //实体引导技能开始
				case ECmdCoreCommand._ECmdCoreKillUser://踢掉玩家
				case ECmdBroadCast._ECmdBroadcastDropEntityInfos://多个物品掉落
				case ECmdBroadCast._ECmdBroadcastDropEntityInfo://单个物品掉落
//				case ECmdBroadCast._ECmdBroadcastEntityDropSimpleItem://单个物品掉落
//				case ECmdBroadCast._ECmdBroadcastEntityNpcShop://掉落NPC商店
				case ECmdBroadCast._ECmdBroadcastEntityBeginCollect://开始采集
				case ECmdBroadCast._ECmdBroadcastEntityFlashInfo: //实体移动
				case EPublicCommand._ECmdPublicRoleMoveTo: //自己混乱
//				case EPublicCommand._ECmdPublicResetRolePoint://自己移动
				case ECmdBroadCast._ECmdBroadcastEntityOwner://怪物归属
				case ECmdBroadCast._ECmdBroadcastMapEntity://实体进入地图
				case ECmdBroadCast._ECmdBroadcastMapEntityPoint://实体移动
				case EPublicCommand._ECmdPublicEntityKillerInfo: //  被杀死
				case ECmdBroadCast._ECmdBroadcastEntityJumpPoint://跳跃点跳跃
				case ECmdBroadCast._ECmdBroadcastEntityJump://技能跳跃
				case ECmdBroadCast._ECmdBroadcastEntitySomersault://翻滚
				case EPublicCommand._ECmdPublicRoleSomersault://角色自己翻滚
				case EPublicCommand._ECmdPublicRoleJumpPoint://角色自己跳跃点
				case EPublicCommand._ECmdPublicRoleJump://技能跳跃
				case ECmdBroadCast._ECmdBroadcastEntityStop://停止移动
					
				case EPublicCommand._ECmdPublicTestBossThreat: // boss仇恨
			    case EPublicCommand._ECmdPublicCollectBegin: // 采集开始
				case EPublicCommand._ECmdPublicCollectEnd: // 采集结束
				case EPublicCommand._ECmdPublicWaitingInfo:// 副本组队信息
				case EPublicCommand._ECmdPublicCopyRoomOper:// 副本组队操作
				case EGateCommand._ECmdGateRune:// 符文推送
				case EPublicCommand._ECmdPublicDramaStepMsg:// 剧情任务步骤
				case EPublicCommand._ECmdPublicPlayerCopyInfo: // 
				{
					NetDispatcher.dispatchCmd(mb.messageHead.command,mb);
					break;
				}
				default:
				{					
					_broadCastManager.call(mb.messageHead.command,mb);
					break;
				}
			}
		}
	}
}