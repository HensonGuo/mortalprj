/**
 * @date	2011-3-5 下午02:52:10
 * @author  jianglang
 *
 */

package mortal.game.mvc
{
	

	/**
	 * 定义服务器事件类型
	 */
	public class ServerCommand
	{
		
		// 人物战斗属性
		public static const RoleFightAttributeBaseChange:String = "RoleFightAttributeBaseChange";//人物基本战斗属性修改
		public static const RoleFightAttributeChange:String = "RoleFightAttributeChange";//人物战斗属性修改
		public static const RoleFightAttributeAddChange:String = "RoleFightAttributeAddChange";//人物附加战斗属性修改
		public static const RoleFightAttributeExChange:String = "RoleFightAttributeExChange";//基本战斗属性修改
		public static const RoleFightCombatCapabilities:String = "RoleFightCombatCapabilities";//人物综合战斗力
		public static const RoleFightRuneFight:String = "RoleFightRuneFight";//RoleFightRuneFight//人物符文战力
		public static const FightSetModeSuccess:String = "FightSetModeSuccess"; //设置战斗模式成功

		// 人物
		public static const MoneyUpdate:String = "MoneyUpdate";//金钱更新
		public static const CoinUpdate:String = "CoinUpdate"; // 铜币更新
		public static const GoldUpdate:String = "GoldUpdate"; // 元宝更新
		public static const SkillPointUpdate:String = "SkillPointUpdate"; // 技能点
		public static const LifeUpdate:String = "LifeUpdate";//生命更新
		public static const ManaUpdate:String = "ManaUpdate";//魔法更新
		public static const ExpUpdate:String = "ExpUpdate"; // 经验更新
		public static const updateEquipMent:String = "updateEquipMent"; //装备更新
		public static const RoleLevelUpdate:String = "RoleLevelUpdate";//人物等级更新
		public static const RunePowerUpdate:String = "RunePowerUpdate"; // 符能更新
		
		// 地图 	
		public static const MapPointUpdate:String = "MapPointUpdate";//地图位置更新
		
		// 地图系统
		public static const MapPass:String = "MapPass";//地图传送
		
		// npc对话 
		public static const DialogTaskListRes:String = "DialogTaskListRes";//npc任务列表返回
		public static const DialogTaskInfoRes:String = "DialogTaskInfoRes";//npc任务详细信息返回
		
		//坐骑
		public static const MountUpdateList:String = "MountUpdateList";//更新坐骑信息
		public static const MountStateChange:String = "MountStateChange"; //坐骑状态更新
		public static const MountSetEquipBtn:String = "MountSetEquipBtn"; // 装备坐骑按钮
		public static const MountExpUpdate:String = "MountExpUpdate";  //坐骑经验更新
		public static const MountLevelUpdate:String = "MountLevelUpdate";  //等级更新
		public static const MountUpdateExpNum:String = "MountUpdateExpNum";  //更新元宝升级数量
		public static const Mount_777Runing:String = "Mount_777Runing"; //777转动
		
		 // 背包
		public static const BackpackDataChange:String = "BackpackDataChange";//背包整个数据修改
		public static const BackPackItemsChange:String = "BackPackItemsChange";//背包物品更新
		public static const ItemCDTime:String = "ItemCDTime";  //物品cd更新
		public static const BackPackItemAdd:String = "BackPackItemAdd"; // 添加物品
		public static const BackPackItemDel:String = "BackPackItemDel"; // 添加物品 
		public static const BackPackUseItemSuccess:String = "BackPackUseItemSuccess"; // 使用物品成功
		public static const UpdateCapacity:String = "UpdateCapacity";//更新背包容量
		
		//物品
		public static const UpdateItemCdData:String = "UpdateItemCdData";//推送服务器物品冷却数据
		public static const DrugBagInfoUpdate:String = "DrugBagInfoUpdate";//人物药包更新
		
		//精灵
		public static const WizardInfoUpde:String = "WizardInfoUpde";//精灵信息更新
		
		// 邮件提醒
		public static const MailNotice:String = "MailNotice"; // 邮件提醒
		public static const MailListUpdate:String = "MailListUpdate"; // 邮件列表更新
		public static const MailUpdate:String = "MailUpdate"; // 邮件更新
		
		// 市场
		public static const MarketSearchBack:String = "MarketSearchBack";  //市场搜索返回
		public static const MarketGetMySellsBack:String = "MarketGetMySellsBack";  //获得我的挂售清单 返回
		public static const MarketGetMySeekBuysBack:String = "MarketGetMySeekBuysBack";  //获得我的求购清单 返回
		public static const MarketResultBuyItem:String = "MarketResultBuyItem";  //市场购买、出售求购返回
		public static const MarketResultSellItem:String = "MarketResultSellItem";  //市场寄售返回
		public static const MarketResultSeekBuy:String = "MarketResultSeekBuy";  //市场求购返回
		public static const MarketSearchCancelSell:String = "MarketSearchCancelSell";  //市场取消寄售返回
		public static const MarketCancelSeekBuy:String = "MarketCancelSeekBuy";  //市场取消求购返回
		public static const MarketItemRecordUpdate:String = "MarketItemRecordUpdate";  //市场快捷购买物品更新
		
		//交易
		public static const TradeUpdate:String = "TradeUpdate";  //交易信息更新
		
		// 快捷键内容更新
		public static const ShortcutBarDataUpdate:String = "ShortcutBarDataUpdate"; // 快捷栏更新
		
		// 技能
		public static const SkillListUpdate:String = "SkillListUpdate"; // 已经学习的技能列表更新
		public static const SkillUpdate:String = "SkillUpdate"; // 技能更新
		public static const SkillAdd:String = "SkillAdd"; // 学习新技能
		public static const SkillRemove:String = "SkillRemove"; // 删除技能
		public static const SkillUpgrade:String = "SkillUpgrade"; // 升级技能
		public static const RuneAdd:String = "RuneAdd"; // 获得符文
		public static const RuneRemove:String = "RuneRemove"; // 失去符文
		public static const RuneLevelUp:String = "RuneLevelUp"; // 符文升级
		
		//Buff
		public static const BufferUpdate:String = "BufferUpdate";//Buff更新
		
		// 地图
		public static const SmallMapCustomMapPointGot:String = "SmallMapCustomMapPointGot"; //小地图获得了用户自定义坐标点数据
		
		// 传送失败
		public static const AI_FlyBootFail:String = "AI_FlyBootFail";
		
		//商城和商店
		public static const PanicUndate:String = "PanicUndate";   //更新团购信息
		public static const updateBuyBackList:String = "updateBuyBackList"; //更新回购数据
		
		//组队
		public static const GroupPlayerInfoChange:String = "GroupPlayerInfoChange";   //队伍信息改变
		public static const GetNearTeam:String = "GetNearTeam";   //获取附近队伍信息
		public static const GroupInvite:String = "GroupInvite";  //组队邀请
		public static const GroupApply:String = "GroupApply";  //组队申请
		public static const GetNearPlayer:String = "GetNearPlayer";  //更新附近玩家
		public static const GroupSettingUpdate:String = "GroupSettingUpdate";   //队伍设置改变
		public static const TeamMateLeft:String = "TeamMateLeft";   //队员离开
		public static const updateTeamMateState:String = "updateTeamMateState";  //更新队员的状态(是否在线和地图位置)
		public static const CaptainChange:String = "CaptainChange";  //在自己头像添加队长图标
		
		public static const TaskCanGetRecv:String = "TaskCanGetRecv"; // 可接任务列表
		public static const TaskCanGetDel:String = "TaskCanGetDel";// 删除可接任务
		public static const TaskCanGetAdd:String = "TaskCanGetAdd";// 添加可接任务
		public static const TaskDoingRecv:String = "TaskDoingRecv"; // 正在进行任务列表
		public static const TaskUpdate:String = "TaskUpdate"; // 任务更新
		public static const TaskDoingAdd:String = "TaskDoingAdd"; // 添加进行中的任务
		public static const TaskDoingDel:String = "TaskDoingDel"; // 完成任务后删除进行中的任务
		public static const TaskNpcShowHideUpdate:String = "TaskNpcShowHideUpdate"; // 任务控制的npc、boss、副本隐藏显示
		public static const TaskGetSucess:String = "TaskGetSucess"; // 成功接取了任务
	
		
		// 好友
		public static const GetFriendList:String = "GetFriendList"; // 获取好友列表
		public static const GetOneKeyMakeFriendsInfo:String = "GetOneKeyMakeFriendsInfo"; // 得到一键征友信息
		public static const FriendApplyRemind:String = "FriendApplyRemind"// 好友申请提醒
		public static const FriendApplyReply:String = "FriendApplyReply"// 回复好友申请
		public static const FriendUpdate:String = "FriendUpdate"// 更新好友
		public static const FriendOnlineStatus:String = "FriendOnlineStatus";// 好友在线状态更新
		public static const FriendDelete:String = "FriendDelete";// 删除好友
		public static const FriendInfoUpdate:String = "FriendInfoUpdate";// 好友信息更新
		public static const BatAddFriends:String = "BatAddFriends";// 批量添加好友
		public static const GetAllFriendRecords:String = "GetAllFriendRecords";// 上线获取所有列表记录
		public static const AddToRecent:String = "AddToRecent";// 添加最近联系人
		
		//宠物相关
		public static const PetInfoUpdate:String = "PetInfoUpdate";//宠物信息更新
		public static const PetAddOrRemove:String = "PetAddOrRemove";//增加或者删除宠物
		public static const PetAttributeUpdate:String = "PetAttributeUpdate";//宠物属性更新
		public static const PetFightPetUpdate:String = "PetFightPetUpdate";//出战宠物更新
		public static const PetStateUpdate:String = "PetStateUpdate";//宠物状态更新
		public static const PetModeUpdate:String = "PetModeUpdate";//宠物战斗模式更新
		public static const PetDead:String = "FightPetDead";//宠物死亡
		public static const PetFreshSkillBook:String = "PetFreshSkillBook";//刷新宠物技能书
		public static const PetGetSkillBook:String = "PetGetSkillBook";//获取宠物技能书
		public static const PetSkillUpdate:String = "PetSkillUpdate";//宠物技能更新
		
		// 角色相关
		public static const GetRoleList:String = "GetRoleList";// 获取玩家列表
		
		//聊天
		public static const ChatMessageUpdate:String = "ChatMessageUpdate";//聊天信息更新
		
		//公告
		public static const NoticeMsg:String = "NoticeMsg";//公告广播信息
		
		// 装备锻造
		public static const StrengthenInfoUpdate:String = "StrengthenInfoUpdate";// 强化信息更新
		public static const FirstFourStrengthenInfo:String = "FirstFourStrengthenInfo";// 前四次强化信息
		public static const UpdateStrengthenEquip:String = "UpdateStrengthenEquip";// 同步更新强化界面上的角色装备
		public static const EmbedInfoUpdate:String = "EmbedInfoUpdate";// 镶嵌信息更新
		public static const GemUpgradeInfoUpdate:String = "GemUpgradeInfoUpdate";// 宝石升级信息更新
		public static const BackPackGemUpdate:String = "BackPackGemUpdate";// 宝石包更新
		public static const RefreshInfoUpdate:String = "RefreshInfoUpdate";// 洗练信息更新
		
		//公会
		public static const GUILD_CREATE:String = "GUILD_CREATE_SUCCESS";//创建工会
		public static const GUILD_CREATE_INVITE:String = "GUILD_CREATE_INVITE";//邀请创建公会
		public static const GUILD_BRANCH_CREATE:String = "GUILD_BRANCH_CREATE_SUCCESS";//创建分会
		public static const GUILD_DISBAND:String = "GUILD_DISBAND";//解散工会
		public static const GUILD_EXIT:String = "GUILD_EXIT";//退出工会
		public static const GUILD_INFO_UPDATE:String = "GUILD_INFO_UPDATE";//工会信息更新
		public static const GUILD_LIST_UPDATE:String = "GUILD_List_UPDATE";//工会列表更新
		public static const GUILD_WARN_OR_GOOD_LIST_UPDATE:String = "GUILD_WARN_OR_GOOD_LIST_UPDATE";//公会优秀警告成员列表
		public static const GUILD_APPLY_LIST_UPDATE:String = "GUILD_APPLY_LIST_UPDATE";//工会申请列表更新
		public static const GUILD_MEMBERS_UPDATE:String = "GUILD_MEMBERS_UPDATE";//更新成员列表
		public static const GUILD_INVITE:String = "GUILD_INVITE";//公会邀请
		public static const GUILD_IMPEACH:String = "GUILD_IMPEACH";//公会弹劾
		public static const GUILD_IMPEACH_END:String = "GUILD_IMPEACH_END";//公会弹劾结束
		public static const GUILD_NEW_MEMBER_ADD:String = "GUILD_NEW_MEMBER_ADD";//公会新成员加入
		public static const GUILD_SELF_JION_SUCCESS:String = "GUILD_SELF_JION_SUCCESS";//加入公会成功
		
		public static const Lottery_Record_Update:String = "Lottery_Record_Update";//抽奖记录更新
		
		// 系统设置
		public static const SystemSettingDataGot:String = "SystemSettingDataGot";// 获取到系统更新的设置
		
		public function ServerCommand()
		{
			
		}
	}
}
