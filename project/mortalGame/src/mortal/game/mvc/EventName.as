package mortal.game.mvc
{
	
	
	/**
	 * MVC 之间通信的事件 
	 * @author jianglang
	 * 
	 */	
	public class EventName
	{
		public function EventName(){}
		
		public static const SocketClose:String = "SocketClose";//SocketClose
		
		public static const SecViewTimeChange:String = "SecViewTimeChange";//秒表倒计时文本时间变化
		
		/**
		 * 登陆游戏 
		 */		
		public static const LoginSuccess:String = "LoginSuccess";//LoginSuccess//登陆成功
		public static const CreateRole:String = "CreateRole";//创建角色
		public static const LoginGameSuccess:String = "LoginGameSuccess";//登陆游戏成功
		public static const LoginGameException:String = "LoginGameException";//登陆游戏异常
		public static const FavoriteUpdate:String = "FavoriteUpdate";//游戏收藏更新
		public static const AddFavorite:String = "AddFavorite";//游戏加入收藏
		public static const StageResize:String = "StageResize";//场景大小重设
		public static const StageResizeF8:String = "StageResizeF8";//场景大小F8
		public static const StageMouseMove:String = "StageMouseMove";//舞台鼠标移动
		public static const StageMouseClick:String = "StageMouseClick";//舞台鼠标点击
		
		//坐骑
		public static const SetMountState:String = "SetMountState"; //设置坐骑状态
		public static const MountSelseced:String = "MountSelseced"; //选择坐骑后显示属性
		public static const RideMount:String = "RideMount"; //骑乘坐骑
		public static const ChangeRideMount:String = "ChangeRideMount"; //更换骑乘的坐骑
		public static const MountLoadComplete:String = "MountLoadComplete";//模块资源加载完成
		public static const CultureMount:String = "CultureMount"; //培养坐骑
		public static const MountOpenCulturWin:String = "MountOpenCulturWin"; //打开培养面板
		public static const CultureLinageMount:String = "CultureLinageMount";  //坐骑血统提升
		public static const Mount777End:String = "Mount777End"; //777结束
		public static const MountClearNewMount:String = "MountClearNewMount";//清除新坐骑缓存
		public static const	MountChangeSelceted:String = "MountChangeSelceted";
		
		//精灵
		public static const	WizardItemUse:String = "WizardItemUse";//使用道具激活精灵
		public static const UpgradeSoul:String = "UpgradeSoul";//提升穴位
		
		/**
		 * 角色 
		 */		
		public static const Role_Dead:String = "Role_Dead";//角色死亡
		public static const Role_Relived:String = "Role_Relived";//角色复活
		
		public static const Role_Relive_Local:String = "Role_Relive_Local";//角色原地复活
		public static const Role_Relive_Coin:String = "Role_Relive_Coin";//角色原地复活元宝模式
		public static const Role_Relive_CoinBind:String = "Role_Relive_CoinBind";//角色原地复活绑定元宝模式
		public static const Role_Relive_City:String = "Role_Relive_City";//角色回城复活
		public static const Role_Relive_Time:String = "Role_Relive_Time";//角色回城继续倒计时
		public static const Role_Relive_PropLocal:String = "Role_Relive_PropLocal";//角色使用道具原地复活
		public static const Role_Relive_CancelBuyProp:String = "Role_Relive_CancelBuyProp";//取消购买生死轮回道具
		public static const Role_Relive_SureBuyProp:String = "Role_Relive_SureBuyProp";//确定购买生死轮回道具
		public static const PlayerWindowShow:String = "PlayerWindowShow";//打开人物界面
		public static const PlayerTabBarChangeToExchange:String = "PlayerTabBarChangeToExchange";//人物界面切换到兑换标签
		public static const PlayerSuitLockedChange:String = "PlayerSuitLockedChange";//锁定套装发生变化
		public static const CurWorldLevelUpdate:String = "CurWorldLevelUpdate";//当前世界等级更新
		public static const Role_FlyStart:String = "Role_FlyStart";//角色开始飞行
		public static const Role_FlyEnd:String = "Role_FlyEnd";//角色结束飞行
		public static const Role_MountDataChange:String = "Role_MountDataChange";//人物背包坐骑数据改变
		public static const Role_LookupRune:String = "Role_LookupRune";//人物面板查看符文
		public static const Role_AvatarUploadOpen:String = "Role_AvatarUploadOpen";//头像上传提示界面
		
		public static const Role_Relive_HideRelivePanel:String = "Role_Relive_HideRelivePanel";//隐藏角色复活框
		public static const CreateNewBackCountClock:String = "CreateNewBackCountClock";//重塑120复活点复活倒计时
		public static const CDMapTimerComplete:String = "CDMapTimerComplete";//原地复活有CD地图倒计时结束
		
		// 公共cd
		public static const CDPublicCDEnd:String = "CDPublicCDEnd";
		
		
		//掉落系统
		public static const KeyPickDropItem:String = "KeyPickDropItem";//键盘失去掉落物品
		public static const PickDropItem:String = "PickDropItem";//拾取掉落物品
		
		//飘物品效果显示系统
		public static const FlyItemToPack:String = "FlyItemToPack";//掉落物品飞往背包
		
		/**
		 * 自动寻路
		 */
		public static const AI_NpcInDestance:String = "AI_NpcInDestance";//AI_进入npc有效范围
		public static const AI_NpcOutDestance:String = "AI_NpcOutDestance";//AI_离开npc有效范围
		public static const AutoPathOpenDropItem:String = "AutoPathOpenDropItem";//自动寻路打开掉落框
		public static const AutoPathBegin:String = "AutoPathBegin";//开始自动寻路
		public static const AutoPathEnd:String = "AutoPathEnd";//结束自动寻路
		public static const AI_FightInDistance:String = "AI_FightInDistance";//AI_进入战斗有效范围
		public static const AI_FlyBootCalled:String = "AI_FlyBootCalled"; // 调用了小飞鞋接口
		public static const AI_MoveStart:String = "AI_MoveStart"; // 开始移动
		public static const AI_MoveEnd:String = "AI_MoveEnd"; // 开始移动
		
		/**
		 * 路径引导 
		 */
		public static const GuidePathBegin:String = "GuidePathBegin";//开始路径引导
		
		/**
		 * 场景 
		 */		
		public static const Scene_AddEntity:String = "Scene_AddEntity";//场景_增加实体
		public static const SceneAddSelfPet:String = "SceneAddSelfPet";//场景_增加自己的宠物
		public static const SceneAddGroupmate:String = "SceneAddGroupmate";//场景添加队友
		public static const SceneRemoveGroupmate:String = "SceneRemoveGroupmate";//场景移除队友
		
		/**
		 * 地图
		 */		
		public static const ScreenOrShowPlayer:String = "ScreenOrShowPlayer";//屏蔽或显示附近玩家和宠物
		public static const Scene_Entity_Move:String = "Scene_Entity_Move";//实体移动 
		
		// 小地图
		public static const SmallMapShowHide:String = "SmallMapShowHide"; // 请求显示、隐藏小地图
		public static const SmallMapClick:String = "SmallMapClick"; // 小地图移动到某一点
		public static const SmallMapDoubleClick:String = "SmallMapDoubleClick"; // 小地图移动到某一点
		public static const SmallMapShowCurPoint:String = "SmallMapShowCurPoint";// 小地图显示当前的坐标
		public static const SmallMapShowTypeChange:String = "SmallMapShowTypeChange";
		public static const SMallMapImgLoaded:String = "SMallMapImgLoaded"; // 小地图加载完成
		public static const SmallMapShowCustomMapPoinWin:String = "SmallMapShowCustomMapPoinWin"; // 显示坐标修改窗口
		public static const SmallMapSaveCustomPoint:String = "SmallMapSaveCustomPoint"; // 小地图保存自定义点
		public static const SmallMapFlybootReq:String = "SmallMapFlybootReq"; // 小飞鞋
		public static const SmallMapChangeTab:String = "SmallMapChangeTab"; // 世界地图、区域地图、当前地图切换
		public static const SmallMapClickWorldRegion:String = "SmallMapClickWorldRegion";
		
		public static const MapUpdateRolePosition:String = "MapUpdateRolePosition";//小地图更新玩家位置
		
		public static const LeaveScene:String = "LeaveScene";//离开场景
		public static const ChangeScene:String = "ChangeScene";//切换场景
		public static const ChangePosition:String = "ChangePosition";//场景内传送
		
		public static const Scene_Update:String = "Scene_Update";//场景更新
		public static const Scene_Pet_Update:String = "Scene_Pet_Update";//场景内的宠物更新
		
		public static const SceneSomersault:String = "SceneJump";//场景跳跃
		public static const SpaceDropItem:String = "SpaceDropItem";//空格拾取物品
		
		//		public static const MiniMapFindPath:String = "MiniMapFindPath";//小地图寻路
		public static const MapFindPath:String = "MapFindPath";//地图寻路
		public static const MapSwitchToNewMap:String = "MapSwitchToNewMap"; // 切换地图
		
		public static const RoleMoveEnd:String = "RoleMoveEnd";//角色移动完成 
		
		public static const RoleDressSuccess:String = "RoleDressSuccess";//人物着装成功
		public static const RoleUnDressSuccess:String = "RoleUnDressSuccess";//人物卸装成功
		
		public static const EscortIsAttacked:String = "EscortIsAttacked";//护送目标正被攻击
		
		public static const Player_Selected:String = "Player_Selected";//人物选择事件
		
		public static const Role_Collect_Begin:String = "Role_Collect_Begin";//角色开始采集
		public static const Role_Collect_End:String = "Role_Collect_End";//角色采集完成
		public static const Convey_Res:String = "Convey_Res";//小飞鞋瞬移成功返回
		public static const Fight_Process_Begin:String = "Fight_Process_Begin";//战斗_开始技能读条
		public static const FightSetMode:String = "FightSetMode";//设置战斗模式
		public static const FightSetModeSuccess:String = "FightSetModeSuccess";//设置战斗模式成功
		public static const CollectHasOwner:String = "CollectHasOwner";//目标正在采集中
		public static const FightEntityNotOnLine:String = "FightEntityNotOnLine";//目标不存在
		public static const FightTargetIsTooFar:String = "FightTargetIsTooFar";//距离太远不可攻击
		public static const CollectTargetIsTooFar:String = "CollectTargetIsTooFar";//距离太远不可采集
		public static const ColloectTargetNotOnLine:String = "ColloectTargetNotOnLine";//采集目标不存在
		public static const InputPointError:String = "InputPointError";//输入坐标错误
		public static const FightCopySkill:String = "FightCopySkill";//释放副本道具技能
		public static const FightProcessBreak:String = "FightProcessBreak";//打断技能读条
		public static const FightServerRes:String = "FightServerRes";//战斗请求返回
		public static const ScenePlaySkill:String = "ScenePlaySkill";//场景播放技能
		
		// npc相关
		public static const NPC_Task_StatusUpdata:String = "NPC_Task_StatusUpdata";//npc任务状态更新
		public static const NPC_ClickedHandler:String = "NPC_ClickedHandler";
		public static const NPC_ClickNpcFunction:String = "NPC_ClickNpcFunction"; // 点击npc功能列表
		public static const NPC_OpenNpcShop:String = "NPC_OpenNpcShop";
		
		//指引
		public static const WindowShowed:String = "WindowShowed";//自动指引窗口显示了
		public static const WindowClosed:String = "WindowClosed";//显示中的窗口关闭了
		public static const AutoGuideStepEnd:String = "AutoGuideStepEnd";//自动显示窗口指引步骤执行完毕
		public static const AutoGuideShowNavbarArrow:String = "AutoGuideShowNavbarArrow";//自动指引显示右下角一排的指引箭头
		public static const AutoGuideItemUsed:String = "AutoGuideItemUsed";//自动指引使用了物品
		public static const AutoGuideGuidePackIndex:String = "AutoGuideGuidePackIndex";//自动指引指引背包格子
		public static const AutoGuideCancelGuidePackIndex:String = "AutoGuideCancelGuidePackIndex";//自动指引取消指引背包格子
		public static const AutoGuideActiveByEvent:String = "AutoGuideActiveByEvent";//自动指引事件激活类型
		public static const AutoGuideBreakGuide:String = "AutoGuideBreakGuide";//自动指引中断指引
		public static const AutoGuideDelDoingRecord:String = "AutoGuideDelDoingRecord";//自动指引删除正在进行的记录
	
		//buff
		public static const BuffRemainTimeUpdate:String = "BuffRemainTimeUpdate";//BUFF剩余时间更新
		
		//组队
		public static const CreateGroup:String = "CreateGroup";//创建队伍
		public static const DisbanGroup:String = "DisbanGroup";//解散队伍
		public static const GetNearPlayer:String = "GetNearPlayer";//获取附近玩家
		public static const GetNearTeam:String = "GetNearTeam";//获取附近玩家
		public static const GroupInviteOper:String = "GroupInviteOper";//队伍邀请操作
		public static const GroupApplyOper:String = "GroupApplyOper";//队伍申请操作
		public static const KickOut:String = "KickOut";//踢出玩家
		public static const LeaveGroup:String = "LeftGroup";//离开队伍
		public static const ModifyCaptain:String = "ModifyCaptain";//切换队长
		public static const GroupTabIndexChange:String = "GroupTabIndexChange";//切换组队模块的tab
		public static const GroupPanel_ViewInited:String = "GroupPanel_ViewInited"; //组队面板视图初始化完毕
		public static const GroupSetting:String = "GroupSetting";//队伍设置
		
		//商店
		public static const ShopMallInit:String = "ShopMallInit";//商店资源初始化完成
		public static const BuyBack:String = "BuyBack"; //回购
		
		//背包
		public static const BackPack_Destroy:String = "BackPack_Destroy";//背包_摧毁
		public static const BackPack_Use:String = "BackPack_Use";//背包_使用
		public static const BackPack_BulkUse:String = "BackPack_BulkUse";//背包_批量使用
		public static const BackPack_Split:String = "BackPack_Split";//背包_拆分
		public static const ButtomBtn_BackPack_Splite:String = "ButtomBtn_BackPack_Splite";//背包_下导航_拆分
		public static const BackPack_Show:String = "BackPack_Show";//背包_展示
		public static const BackPack_To_Sale:String = "BackPack_To_Sale";//背包_寄售
		public static const ButtomBtn_BackPack_Sale:String = "ButtomBtn_BackPack_Sale";//背包_下导航_寄售
		public static const ButtomBtn_BackPack_Merge:String = "ButtomBtn_BackPack_Merge";//背包_下导航_合并
		public static const BackPack_Equip:String = "BackPack_Equip";//背包_装备
		public static const BackPack_Tity:String = "BackPack_Tity";//背包_整理
		public static const BackPackDrugItem_Throw:String = "BackPackDrugItem_Throw";//背包药品_丢弃
		public static const BackPack_DragInItem:String = "BackPack_DragInItem";//背包_拖动到背包格子上
		public static const BackPack_DragInBack:String = "BackPack_DragInBack";//背包_拖动到背景上
		public static const BackPackReqData:String = "BackPackReqData";//返回背包中请求物品的数据
		public static const BackpackUpData:String = "BackpackUpData";//背包更新
		public static const Fast_USE_BackPackExtend:String = "Fast_USE_BackPackExtend";//快速使用背包的包裹
		public static const OpenGrid:String = "OpenGrid"; //开启背包格子
		public static const GetTime:String = "GetTime";  //更新格子时间
		public static const UseSkillBook:String = "UseSkillBook";    //使用技能书
		public static const ShowUnLock:String = "ShowUnLock"; //显示待开启格子
		public static const HideUnLock:String = "HideUnLock"; //隐藏待开启格子
		public static const PackSelectIndex:String = "PackSelectIndex";//当前选择的开格子位置
		
		//抢购
		public static const BuyItem:String = "BuyItem"; //购买物品
		public static const BuyPanicItem:String = "BuyPanicItem"; //抢购物品
		public static const BuyPanicOpen:String = "BuyPanicOpen"; //抢购面板打开
		public static const BuyPanicClose:String = "BuyPanicClose"; //抢购面板关闭
		
		//自动恢复	
		public static const RoleAutoResume:String = "RoleAutoResume";//人物自动恢复血量法力
		
		//人物
		public static const GetOffEquip:String = "GetOffEquip";  //脱掉装备
		
		/**
		 *商店 
		 */
		public static const ShopSellItem:String = "ShopSellItem";
		public static const ShopShowCour:String = "ShopShowCour";
		
		// 系统设置
		public static const SystemSettingSava:String = "SystemSettingSava"; // 保存系统设置
		public static const SystemSettingSaved:String = "SystemSettingSaved";// 向服务器申请了保存系统设置
		public static const ShortcutKeyUpdate:String = "ShortcutKeyUpdate"; // 系统设置更新
		public static const ShortcutsUpdate:String = "ShortcutsUpdate";//快捷键改变
		
		// 快捷栏
		public static const ShortcutBarKeyDown:String = "ShortcutBarKeyDown"; // 按下快捷栏的快捷键
		public static const ShortcutBarClicked:String = "ShortcutBarClicked"; // 鼠标点击快捷栏
		public static const ShortcutBarKeyUp:String = "ShortcutBarKeyUp"; // 按下快捷栏的快捷键
		public static const ShortcutBarCDFinished:String = "ShortcutBarCDFinished"; // 快捷栏CD完成
		public static const ShortcutBarDataChange:String = "ShortcutBarDataChange"; // 快捷键数据更改
		public static const ShortcutBarMoveIn:String = "ShortcutBarMoveIn"; //  拖进快捷栏
		public static const ShortcutBarThrow:String = "ShortcutBarThrow"; // 丢弃快捷栏
		public static const TabKeyChangeTarget:String = "TabKeyChangeTarget"; // tab键切换目标
		public static const ShortcutBarShowHide:String = "ShortcutBarShowHide"; // 显示、隐藏快捷栏
		
		// 技能面板
		public static const SkillShowHideModule:String = "SkillShowHideModule"; // 显示技能面板
		public static const SkillPanel_ViewInited:String = "SkillPanel_ViewInited"; //技能面板视图初始化完毕
		public static const SkillUpgradeReq:String = "SkillUpgradeReq"; // 升级技能
		public static const SkillCheckAndSkillAI:String = "SkillCheckAndSkillAI";// 客户端检查并且调用技能AI
		public static const SkillAskServerUseSkill:String = "SkillAskServerUseSkill"; // 向服务器请求使用技能
		public static const SkillShowSkillInfo:String = "SkillShowSkillInfo"; // 显示技能描述
		public static const Skill_RuneUpgrade:String = "Skill_RuneUpgrade"; // 升级符文
		public static const Skill_SelectPos:String = "Skill_SelectPos"; // 选中选中某个位置的技能
		
		// 小飞鞋
		public static const FlyBoot:String = "FlyBoot"; // 请求小飞鞋
		public static const FlyBoot_GLinkText:String = "FlyBoot_GLinkText"; // 任务连接的小飞鞋
		
		// 好友
		public static const FriendApply:String = "FriendApply";// 申请加为好友
		public static const FriendReply:String = "FriendReply";// 回复申请方 
		public static const FriendListReq:String = "FriendListReq";// 请求好友列表数据
		public static const FriendDeleteListReq:String = "FriendDeleteListReq"// 请求批量删除中的好友列表数据
		public static const FriendAddToDelete:String = "FriendAddToDelete";// 选中的好友添加到删除列表中
		public static const FriendCancelDelete:String = "FriendCancelDelete";// 取消删除列表中的好友项
		public static const FriendDelete:String = "FriendDelete";// 删除一个好友
		public static const FriendSearch:String = "FriendSearch";// 搜索好友
		public static const AddToBlackList:String = "AddToBlackList";// 添加至黑名单
		public static const FriendDeleteRecord:String = "FriendDeleteRecord";// 删除一条记录
		public static const SignatureUpdate:String = "SignatureUpdate";// 修改个性签名
		public static const ModifyFriendType:String = "ModifyFriendType";// 修改好友类型
		
		//邮件
		public static const MailQueryAll:String = "MailQueryAll";//  查询所有邮件
		public static const MailQueryUnread:String = "MailQueryUnread";//  查询未读邮件
		public static const MailQueryRead:String = "MailQueryRead";//  查询已读邮件
		public static const MailQuerySys:String = "MailQuerySys";//  查询系统邮件
		public static const MailQueryPers:String = "MailQueryPers";//  查询个人邮件
		public static const MailSend:String = "MailSend";//  发送邮件
		public static const MailGetAttachment:String = "MailGetAttachment";// 获取附件
		public static const MailGetAttachments:String = "MailGetAttachments";// 一键获取附件
		public static const MailDelete:String = "MailDelete";//  删除邮件
		public static const MailSeleteAll:String = "MailSeleteAll";// 全选
		public static const MailRead:String = "MailRead";// 阅读邮件
		public static const MailSendSucced:String = "MailSendSucced"; // 邮件发送成功
		public static const MailGASucced:String = "MailGASucced";// 一键提取成功
		public static const MailDelteSucced:String = "MailDelteSucced";// 删除邮件成功
		public static const MailMenuSend:String = "MailMenuSend";// 人物头像菜单发送邮件
		
		//市场
		public static const MarketPushSeekItem:String = "MarketPushSeekItem";// 市场，放置求购物品
		public static const MarketRemoveSeekItem:String = "MarketRemoveSeekItem";// 市场，放回求购物品
		public static const MarketPushSaleItem:String = "MarketPushSaleItem";// 市场，放置寄售物品
		public static const MarketRemoveSaleItem:String = "MarketRemoveSaleItem";// 市场，放回寄售物品
		public static const MarketClickType:String = "MarketClickType";// 市场，点击左边道具分类列表的小分类
		public static const MarketClickSortUp:String = "MarketClickSortUp";// 市场，向上排序
		public static const MarketClickSortDown:String = "MarketClickSortDown";// 市场，向下排序
		public static const MarketSearchClickName:String = "MarketSearchClickName";// 市场点击名字搜索
		public static const MarketSearch:String = "MarketSearch";// 市场，搜索
		public static const MarketBroadcast:String = "MarketBroadcast";// 市场，点击宣传
		public static const MarketCancelSell:String = "MarketCancelSell";// 取消寄售
		public static const MarketCancelSeekBuy:String = "MarketCancelSeekBuy";// 取消求购
		public static const MarketSale:String = "MarketSale";// 寄售
		public static const MarketQiugou:String = "MarketQiugou";// 求购
		public static const MarketBuyMarketItem:String = "MarketBuyMarketItem";// 购买
		public static const MarketSellItem2SeekBuy:String = "MarketSellItem2SeekBuy";// 出售求购
		public static const MarketGetMyRecords:String = "MarketGetMyRecords";// 获得我的挂售清单
		public static const MarketClickQickBuy:String = "MarketClickQickBuy";//聊天框快捷购买/快捷出售
		public static const MarketError:String = "Alert.OK";//市场报错
		
		//交易
		public static const TradeApplyToTarget:String = "TradeApply";   //发起交易
		public static const TradeAcceptTrade:String = "TradeAcceptTrade";  //接受交易
		public static const TradeRejectTrade:String = "TradeRejectTrade";  //拒绝交易
		public static const TradeClickLock:String = "TradeClickLock";   //点击锁定
		public static const TradeClickTradeBtn:String = "TradeClickTrade";  //点击交易 面板的交易按钮
		public static const TradeCancel:String = "TradeCancel";  //取消交易
		public static const TradeClickPackItem:String = "TradeClickPackItem";  //交易过程中点击背包物品
		public static const TradeClickItem:String = "TradeClickItem";  //点击已经放入的物品
		public static const TradeMyItemsChange:String = "TradeMyItemsChange";  //交易我的物品改变
		public static const TradeMyMoneysChange:String = "TradeMyMoneysChange";  //交易我的金钱改变
		public static const TradeSelectNumOver:String = "TradeSelectNumOver";  //交易物品选择数量完毕
		public static const Trade_StatusChange:String = "Trade_StatusChange";//交易_交易状态改变
		
		
		// 任务指引事件
		public static const TaskTrackClickEvent:String = "TaskTrackClickEvent";
		public static const TaskTraceTargetEvent:String = "TaskTraceTargetEvent";
		public static const Task_DramaNextStep:String = "Task_DramaNextStep"; // 剧情任务，下一步
		
		// 任务
		public static const TaskShowHideModule:String = "TaskShowHideModule";
		public static const TaskModuleTabChange:String = "TaskModuleTabChange";
		public static const TaskMoudleViewTaskInfo:String = "TaskMoudleViewTaskInfo";
		public static const TaskAskNextStep:String = "TaskAskNextStep";// 任务请求下一步（领取，下一步、完成领取奖励）
		public static const TaskGiveupTask:String = "TaskGiveupTask"; // 放弃任务
		public static const TaskQuickComplete:String = "TaskQuickComplete"; // 快速完成
		public static const TaskQuickFinish:String = "TaskQuickFinish"; // 快速提交
		public static const TaskQuickCompleteFinish:String = "TaskQuickCompleteFinish"; // 快速完成并且提交
		public static const TaskTraceItemExpand:String = "TaskTraceItemExpand";
		public static const TaskTrackShowOrHide:String = "TaskTrackShowOrHide"; // 显示或者隐藏任务追踪
		
		// 
		public static const NpcDialogShowTaskInfo:String = "NpcDialogShowTaskInfo"; // 点击npc列表中的任务， 请求显示任务
		public static const NpcChooseAnswer:String = "NpcChooseAnswer"; // 选择npc答案
		
		//宠物
		public static const PetSkillBookOpen:String = "PetSkillBookOpen"; //打开宠物技能界面
		public static const PetOutOrIn:String = "PetOutOrIn";//宠物出战或者回收
		public static const PetChangeMode:String = "PetChangeMode";//宠物修改状态
		public static const PetDeletePet:String = "PetDeletePet";//宠物删除
		public static const PetChangeName:String = "PetChangeName";//宠物修改名字
		public static const PetUpdateGrowth:String = "PetUpdateGrowth";//宠物提升成长
		public static const PetUpdateBlood:String = "PetUpdateBlood";//宠物提升血脉
		public static const PetOutOrInByShortCut:String = "PetOutOrInByShortCut";//宠物出战或收回by快捷键
		public static const PetLearnSkill:String = "PetLearnSkill";//学习技能
		public static const PetSealSkill:String = "PetSealSkill";//封印技能
		public static const PetUnsealSkill:String = "PetUnsealSkill";//解封技能
		public static const PetFreshSkillBook:String = "PetFreshSkillBook";//刷新技能书
		public static const PetGetSkillBook:String = "PetGetSkillBook";//获取技能书
		public static const PetChangeSkillPos:String = "PetChangeSkillPos";//更改技能位置
		
		// 副本
		public static const CopyClickQuickBtn:String = "CopyClickQuickBtn";// 点击离开副本按钮
		public static const CopyClickCopyLink:String = "CopyClickCopyLink";// 点击副本功能连接
		public static const CopyGroupEnterCopyReq:String = "CopyGroupEnterCopyReq"; // 进入组副本
		public static const CopyGroupTabChange:String = "CopyGroupTabChange";// 组队副本，tab改变了
		public static const CopyGroupGatherReq:String = "CopyGroupGatherReq"; // 队伍集合
		public static const CopyGroupInviteReq:String = "CopyGroupInviteReq"; // 快速邀请
		public static const CopyGroupQuickReq:String = "CopyGroupQuickReq"; //  快速组队
		
		// 显示、隐藏mainUI
		public static const ShowHideMainUI:String = "ShowHideMainUI";  
		
		//聊天
		public static const ChatSend:String = "ChatSend";//发送聊天
		public static const ChatShowItem:String = "ChatShowItem";//聊天炫耀物品
		public static const ChatShowPet:String = "ChatShowPet";//聊天炫耀宠物
		public static const ChatShowPoint:String = "ChatShowPoint";//聊天炫耀坐标点
		public static const ChatShield:String = "ChatShield";//聊天屏蔽
		public static const ChatShowSpeaker:String = "ChatShowSpeaker";//显示千里传音界面
		public static const ChatCopyUpRecord:String = "ChatCopyUpRecord";//聊天复制上一条消息
		public static const ChatColorSelect:String = "ChatColorSelect";//选择颜色
		public static const ChatResize:String = "ChatResize";//聊天界面尺寸改变
		public static const ChatPrivateSend:String = "ChatPrivateSend";//私聊发送数据
		public static const ChatPrivate:String = "ChatPrivat";//发起私聊
		
		// 自动挂机
		public static const AutoFight_ShowHide:String = "AutoFight_ShowHide"; // 显示自动挂机面板
		public static const AutoFight_A:String = "AutoFight_A"; // 普通挂机
		public static const AutoFight_Round:String = "AutoFight_Round"; // 范围挂机
		public static const AutoFight_BossNotSelect:String = "AutoFight_BossNotSelect";
		public static const AutoFight_PlanChange:String = "AutoFight_PlanChange";
		public static const AutoFight_MainSkillActive:String = "AutoFight_MainSkillActive";
		public static const AutoFight_AssistSkillActive:String = "AutoFight_AssistSkillActive";
		public static const AutoFight_LoadDefault:String = "AutoFight_LoadDefault"; // 加载默认配置
		public static const AutoFight_Save:String = "AutoFight_Save"; // 保存配置
		
		// 锻造
		public static const EquipStrengthen:String = "EquipStrengthen"; // 装备强化(普通强化、一键强化)
		public static const AddEquipStrengthen:String = "AddEquipStrengthen"; // 添加待强化的装备
		public static const AddEquipEmbedGem:String = "AddEquipEmbedGem";// 添加装备上镶嵌的宝石
		public static const AddEquipRefresh:String = "AddEquipRefresh";// 添加待洗练的装备
		public static const EquipRefresh:String = "EquipRefresh";// 装备洗练
		public static const EquipRefreshReplace:String = "EquipRefreshReplace";// 装备洗练替换
		
		public static const EmbeGem:String = "EmbeGem";// 镶嵌宝石
		public static const RemoveGem:String = "RemoveGem";// 摘除宝石
		public static const UpgradeGem:String = "UpgradeGem";// 宝石升级
		public static const GemPage:String = "GemPage";// 宝石翻页
		
		//公会
		public static const GUILD_CREATE:String = "GUILD_CREATE";//公会创建
		public static const GUILD_DISBAND:String = "GUILD_DISBAND";//解散公会
		public static const GUILD_EXIT:String = "GUILD_EXIT";//退出公会
		public static const GUILD_SEARCH:String = "GUILD_SEARCH";//公会搜索
		public static const GUILD_LIST_GET:String = "GUILD_LIST_GET";//获取公会列表
		public static const GUILD_APPLY_LIST_GET:String = "GUILD_APPLY_LIST_GET";//公会列表申请
		public static const GUILD_CREATE_BRANCH:String = "GUILD_CREATE_BRANCH";//创建分会
		public static const GUILD_BRANCH_LEVEL_UP:String = "GUILD_BRANCH_LEVEL_UP";//分会升级
		public static const GUILD_INVITE:String = "GUILD_INVITE";//公会邀请
		public static const GUILD_DEAL_INVITE:String = "GUILD_DEAL_INVITE";//处理公会邀请
		public static const GUILD_APPLY:String = "GUILD_APPLY";//公会申请
		public static const GUILD_APPLY_BY_ROLE:String = "GUILD_APPLY_BY_ROLE";//申请玩家公会
		public static const GUILD_DEAL_APPLY:String = "GUILD_DEAL_APPLY";//处理公会申请
		public static const GUILD_PURPOSE_CHANGE:String = "GUILD_NAME_CHANGE";//公会名称修改
		public static const GUILD_POSITION_OPRATE:String = "GUILD_POSITION_OPRATE";//公会职位操作
		public static const GUILD_RECRUIT:String = "GUILD_RECRUIT";//公会招募
		public static const GUILD_IMPEACH_LEADER:String = "GUILD_IMPEACH_LEADER";//弹劾会长
		public static const GUILD_LEVEL_UP:String = "GUILD_LEVEL_UP";//工会升级
		public static const GUILD_KICK_OUT_MEMEBER:String = "GUILD_KICK_OUT_MEMEBER";//公会踢人
	}
}