package mortal.component.gconst
{
	import Message.Game.EGuildPosition;
	import Message.Game.SGuildMember;
	
	import mortal.game.cache.Cache;
	import mortal.game.cache.guild.SelfGuildInfo;
	import mortal.game.manager.ClockManager;

	public class GuildConst
	{
		
		/**
		 *这个没做读表处理，暂时写死成常量，比较蛋疼；
		 * 
		 */
		//创建公会等级限制
		public static const CreateGuildRequireLevel:int = 20;
		//创建公会需要花费的元宝
		public static const CreateGuildRequireCostGold:int = 188;
		//邀请创建公会的等级限制(免费创建公会)
		public static const inviteCreateGuildRequireTargetPlayerLevel:int = 25;
		//最大公会名字长度
		public static const MaxGuildNameLength:int = 7;
		//最大公会宗旨长度
		public static const MaxPurposeLength:int = 50;
		//公会人数少于10人可解散公会
		public static const CanDisbandGuildMembersLimit:int = 10;
		
		
		/**
		 *获取操作权限；
		 * 
		 */
		public static const OutgoingPositon:int = 1;		//卸任职位
		public static const TransferPositon:int = 2;		//转移职位
		public static const DisbandGuild:int = 3;			//解散公会
		public static const InviteIntoGuild:int = 4;		//邀请入会
		public static const ApproveIntoGuild:int = 5;		//批准入会
		public static const ManagerWareHouse:int = 6;		//管理仓库
		public static const UpgradeBuilding:int = 7;		//升级建筑
		public static const OpenCopyTask:int = 8;			//开启副本任务
		public static const DeliverWelfare:int = 9;			//发放福利
		public static const AbsorbBranchMembers:int = 10;	//吸纳外部成员
		public static const AppointDeputyLeader:int = 11;	//任命代理会长
		public static const AppointPrestyer:int = 12;		//任命长老
		public static const AppointLaw:int = 13;			//任命护法
		public static const AppointElite:int = 14;			//任命精英
		public static const KickOutMember:int = 15;			//踢出成员
		public static const CreateBranch:int = 16;			//创建分会
		public static const ChangePurpose:int = 17;			//更改公会宗旨
		public static const Recruit:int = 18;				//公会招募
		public static const UpgradeGuild:int = 19;			//升级公会
		public static const ManagerMembers:int = 20;		//成员管理
		public static const ImpeachLeader:int = 21;			//弹劾会长
		
		public static function hasPermissions(operation:int):Boolean
		{
			var selfPostion:int = Cache.instance.guild.selfGuildInfo.selfInfo.position;
			
			switch(operation)
			{
				case OutgoingPositon:
					return selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
				case TransferPositon:
					return selfPostion == EGuildPosition._EGuildLeader;
				case DisbandGuild:
					return selfPostion == EGuildPosition._EGuildLeader;
				case InviteIntoGuild:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
				case ApproveIntoGuild:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
 				case ManagerWareHouse:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
				case UpgradeBuilding:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader;
				case OpenCopyTask:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
				case DeliverWelfare:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
				case AbsorbBranchMembers:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
				case AppointDeputyLeader:
					return selfPostion == EGuildPosition._EGuildLeader;
				case AppointPrestyer:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader;
				case AppointLaw:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader;
				case AppointElite:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
				case KickOutMember:
					return  selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader;
				case CreateBranch:
					return selfPostion == EGuildPosition._EGuildLeader;
				case ChangePurpose:
					return selfPostion == EGuildPosition._EGuildLeader;
				case Recruit:
					return selfPostion == EGuildPosition._EGuildLeader;
				case UpgradeGuild:
					return selfPostion == EGuildPosition._EGuildLeader;
				case ManagerMembers:
					return selfPostion == EGuildPosition._EGuildLeader || selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
				case ImpeachLeader:
					return selfPostion == EGuildPosition._EGuildDeputyLeader || selfPostion == EGuildPosition._EGuildPresbyter;
			}
			return false;
		}
		
		
		/*
		* 检测会长是否达到弹劾条件
		*/
		public static function get CanImpeachLeader():Boolean
		{
			if (!hasPermissions(ImpeachLeader))
				return false;
			var guildInfo:SelfGuildInfo = Cache.instance.guild.selfGuildInfo;
			if (guildInfo.memberList.length == 0)
				return false;
			var leaderMemberInfo:SGuildMember = guildInfo.getMemberById(guildInfo.baseInfo.leader.entityId.id);
			var leaderLastLogoutDt:Date = leaderMemberInfo.lastLogoutDt;
			var curServerDt:Date = ClockManager.instance.nowDate;
			var maxAllowOfflineTime:int = 3 * 24 * 60 * 60 * 1000;//最长允许3天不在线
			var nowOfflineTime:int = curServerDt.time - leaderLastLogoutDt.time;
			return nowOfflineTime >= maxAllowOfflineTime;
		}
	}
}