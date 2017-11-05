package mortal.game.mvc
{
	/**
	 * 模块通信事件 
	 * @author jianglang
	 * 
	 */	
	public class GModuleEvent
	{
		// 模块事件
		public static var PetAutoFeedPet:String="自动给喂食宠物";
		
		
		//交易模块事件
		public static const Event_MoneyInputChange_gold:String = "元宝输入改变";
		public static const Event_MoneyInputChange_coin:String = "铜钱输入改变";
		public static const Event_ItemChange:String = "选定物品的更新";
		public static const Event_ConfirmTrade:String = "确定交易";
		//public static const Event_CancelTrade:String = "取消交易";
		public static const Event_LockTrade:String = "锁定交易";
		public static const Event_DeleteItem:String = "删除物品";
		public static const Event_SellNum:String = "出售物品的数量";
		public static const Event_AcceptTrade:String = "接受交易申请";
		public static const Event_RejectTrade:String = "拒绝交易申请";
		public static const Event_PetMountListDoubleClick:String = "拒绝交易申请";
		
		/**
		 * 炼器模块事件在类 EquipmentModuleConst.as，
		 * 陈炯栩
		 * 
		 */		
		public static const ComposeJewelModeChange:String = "ComposeJewelModeChange"; //宝石合成模式改变
		public static const ComposeJewelSelecterChange:String = "ComposeJewelSelecterChange"; //宝石合成过滤类型改变
		
		/**
		 * 组队模块
		 * 陈炯栩
		 */		
		public static const Event_LeaveGroup:String = "离开队伍";
		public static const Event_KickOut:String = "踢出队伍";
		
		/**
		 * 跨服组队模块
		 * 陈炯栩
		 */		
		public static const Event_CrossLeaveGroup:String = "跨服团队_离开队伍";
		public static const Event_CrossKickOut:String = "跨服团队_踢出队伍";
		
		/**
		 * 副本组队模块
		 * 陈炯栩
		 */		
		public static const Event_DoEnterCopy:String = "副本组队_进入副本";
		public static const Event_QuickApply:String = "副本组队_快速申请入队";
		public static const Event_QuickInvite:String = "副本组队_快速邀请"; 
		
		/**
		 * 炼器 
		 */		
		public static const Event_OpenBatchRecastWin:String = "打开批量洗练面板";
		public static const Event_UpdateBatchRecastEquip:String = "更新批量洗练面板装备";
		
		/**
		 * 诛邪令
		 * cjx
		 */		
		public static const KillEvilTaskGetTask:String = "领取诛邪任务";
		public static const KillEvilTaskQuickCommit:String = "快速完成诛邪任务";
		public static const KillEvilTaskChangeCurrentPanel:String = "切换诛邪令面板";
		public static const KillEvilTaskCommit:String = "提交诛邪任务";
		
		/**
		 * 委托任务
		 */		
		public static const StartDelegateTaskCoin:String = "开始委托铜钱任务";
		public static const StartDelegateTaskGold:String = "开始委托元宝任务";
		public static const StartDelegateTaskFree:String = "开始扫荡委托任务";
		
		public static const OpenDelegateWarehouse:String = "打开委托仓库";
		public static const ShowNextDelegateTask:String = "显示下一个副本委托";
		public static const DelegateWarehouse_Get:String = "取出委托仓库物品";
		public static const DelegateWarehouse_GetAll:String = "全部取出委托仓库物品";
		public static const DelegateWarehouse_destroyAll:String = "全部摧毁委托仓库物品";
		public static const DelegateWarehouse_FeedMount:String = "全部喂养委托仓库物品";
		public static const DelegateWarehouse_FeedSuitSkill:String = "全部喂养仓库物品_喂养套装技能";
		
		public static const DelegateTaskShowExpDrugWindow:String = "打开经验药使用面板";
		
		/**
		 * 副本 
		 */		
		public static const CopyTowerWarehouse_Get:String = "取出爬塔仓库物品";
		public static const CopyTowerWarehouse_GetAll:String = "提取爬塔仓库全部物品";
		public static const CopyTowerWarehouse_destroyAll:String = "全部摧毁爬塔仓库物品";
		public static const CopyTowerWarehouse_feedAll:String = "全部喂养爬塔仓库物品";
		//仙盟精英团队副本
		public static const GuildElite_FloorSelectedChange:String = "GuildElite_FloorSelectedChange";
		//仙盟副本团队
		public static const GuildGroup_FloorSelectedChange:String = "GuildGroup_FloorSelectedChange";
		public static const GuildGroup_MemberOptBtnClick:String = "GuildGroup_MemberOptBtnClick";
		public static const GuildGroup_OpenGroupBtnClick:String = "GuildGroup_OpenGroupBtnClick";
		public static const GuildGroup_DoEnterGroup:String = "GuildGroup_DoEnterGroup";
		public static const GuildGroup_MemberSelectedChange:String = "GuildGroup_MemberSelectedChange";
		public static const GuildGroup_ModifyTeamLeader:String = "GuildGroup_ModifyTeamLeader";
		public static const GuildGroup_GroupPanelSizeChange:String = "GuildGroup_GroupPanelSizeChange";
		
		
		/**
		 * 人物模块
		 */
		public static const Mode_Self:String="自己";
		public static const Mode_Other:String="别人";
		public static const Mode_ArenaCross:String = "查看资料跨服天下第一";
		public static const Mode_Wrestle:String = "查看资料跨服1v1";
		public static const Mode_PreSecondCareer:String = "预览第二职业装备";
		public static const Event_Dress:String = "玩家着装";
		public static const Event_unDress:String = "玩家卸装";
		public static const GuildExchangType:int = 100;//人物界面仙盟兑换标记
		
		/**
		 * 交材料 
		 */		
		public static const HandinMaterial:String = "上交材料";
		
		//邮件事件MailEventName
		
		//商城事件ShopMallEventName
		
		//商店事件ShopEventName
		
		//仙盟事件GuildEventName
		public static const Guild_CallTogetherIconClick:String = "召集令icon点击";
		public static const Guild_CallTogetherFly:String = "召集令免费传送";
		
		//宠物事件PetEventName
		
		//宠物图鉴事件PetIlluEventName
		
		//宠物训练事件PetPracticeEventName
		/**
		 * 消费，充值界面
		 */		
		public static const Type_ConsumeCount:String = "累计消费";
		public static const Type_MergeRecharge:String = "合服充值";
		public static const Type_ConsumeDay:String = "每日累计充值";
		
		public function GModuleEvent()
		{
			
		}
		
		
	}
}