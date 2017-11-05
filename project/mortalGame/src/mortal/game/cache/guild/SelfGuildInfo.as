package mortal.game.cache.guild
{
	import Message.DB.Tables.TGuildBranchTarget;
	import Message.DB.Tables.TGuildLevelTarget;
	import Message.Game.EGuildPosition;
	import Message.Game.SBranchGuildInfo;
	import Message.Game.SGuildInfo;
	import Message.Game.SGuildMember;
	import Message.Game.SPlayerGuildInfo;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.debug.Log;
	
	import mortal.game.cache.Cache;
	import mortal.game.cache.RoleCache;
	import mortal.game.cache.guild.module.GuildBuilding;
	import mortal.game.cache.guild.module.GuildShop;
	import mortal.game.cache.guild.module.GuildSkill;
	import mortal.game.cache.guild.module.GuildWareHouse;
	import mortal.game.resource.tableConfig.GuildBranchLevelUpTargetConfig;
	import mortal.game.resource.tableConfig.GuildLevelTargetConfig;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;

	public class SelfGuildInfo
	{
		private var _guildID:int;
		//自身信息
		public var selfInfo:SPlayerGuildInfo;
		//公会信息
		public var baseInfo:SGuildInfo;
		//分会信息
		public var branchInfo:SBranchGuildInfo;
		//公会成员列表
		public var memberList:Array = new Array();
		//分会成员列表
		public var branchMemberList:Array = new Array();
		//申请人数
		public var applyNum:int;
		//申请列表
		public var applyMemberList:Array;
		//警告成员数
		public var warnMemberNum:int;
		//警告成员列表
		public var warnMemberList:Array = new Array();
		//优秀成员数
		public var goodMemberNum:int;
		//优秀成员列表
		public var goodMemberList:Array = new Array();
		
		//护法人数
		public var lawNums:int;
		//精英人数
		public var eliteNums:int;
		//代理会长数
		public var deputyLeaderNum:int;
		//长老数
		public var presbyterNum:int;
		//普通成员
		public var normalMemberNum:int;
		
		
		//仓库
		public var wareHouse:GuildWareHouse = new GuildWareHouse();
		//商店
		public var shop:GuildShop = new GuildShop;
		//建筑
		public var buildingData:GuildBuilding = new GuildBuilding();
		//技能
		public var skillData:GuildSkill = new GuildSkill();
		
		
		private static var _instanceCount:int;//调试代码，查到问题后删除
		
		public function SelfGuildInfo()
		{
			_instanceCount ++;
			if (_instanceCount > 1)
			{
				throw new Error("SelfGuildInfo 单例 ");
			}
		}
		
		
		
		/*
		* 是否加入公会
		*/
		public function get selfHasJoinGuild():Boolean
		{
			return _guildID != 0;
		}
		
		public function setGuildID(id:int):void
		{
			_guildID = id;
			Cache.instance.role.roleEntityInfo.updateGuildId(id);
			ThingUtil.isNameChange = true;
		}
		
		public function get guildID():int
		{
			return _guildID;
		}
		
		/*
		* 是否创建分会
		*/
		public function get hasCreatedBranch():Boolean
		{
			return branchInfo != null && branchInfo.level > 0;
		}
		
		public function onCreateBranch():void
		{
			branchInfo = new SBranchGuildInfo();
			branchInfo.guildId = _guildID;
			branchInfo.playerNum = 0;
			branchInfo.level = 1;
			var config:TGuildBranchTarget = GuildBranchLevelUpTargetConfig.instance.getInfoByTarget(1);
			branchInfo.maxPlayerNum = config.amount;
		}
		
		/*
		*同步基本信息
		*/
		public function syncBaseInfo(info:SGuildInfo):void
		{
			baseInfo = info;
			branchInfo = info.branch.length > 0 ? info.branch[0] : null;
		}
		
		/*
		*获取公会等级配置
		*/
		public function getLevelConfig():TGuildLevelTarget
		{
			var config:TGuildLevelTarget = GuildLevelTargetConfig.instance.getInfoByLevel(baseInfo.level);
			return config;
		}
		
		
		/*
		* 同步公会成员
		*/
		public function syncMemberList(list:Array):void
		{
			memberList.length = 0;
			branchMemberList.length = 0;
			for (var i:int = 0; i < list.length; i++)
			{
				var data:SGuildMember = list[i];
				switch(data.position)
				{
					case EGuildPosition._EGuildBranchMember:
						branchMemberList.push(data);
						break;
					case EGuildPosition._EGuildNotMember:
						Log.assert(false, "非公会成员");
						break;
					default:
						memberList.push(data);
						break;
				}
				updatePositionNum(data.position, true);
			}
		}
		
		/*
		* 添加公会成员
		*/
		public function addMember(member:SGuildMember):void
		{
			var hasMember:Boolean = getMemberById(member.miniPlayer.entityId.id) != null;
			if (hasMember)
				return;
			if (member.position == EGuildPosition._EGuildBranchMember)
			{
				branchMemberList.push(member);
			}
			else
			{
				memberList.push(member);
			}
			updatePositionNum(member.position, true);
		}
		
		/*
		* 移除公会成员
		*/
		public function removeMember(playerID:int):void
		{
			for (var i:int = 0; i < memberList.length; i++)
			{
				var memberInfo:SGuildMember = memberList[i];
				if (memberInfo.miniPlayer.entityId.id == playerID)
				{
					memberList.splice(i, 1);
					updatePositionNum(memberInfo.position, false);
					return;
				}
			}
			for (var j:int = 0; j < branchMemberList.length; j++)
			{
				var branchMemberInfo:SGuildMember = branchMemberList[j];
				if (branchMemberInfo.miniPlayer.entityId.id == playerID)
				{
					branchMemberList.splice(i, 1);
					updatePositionNum(branchMemberInfo.position, false);
					return;
				}
			}
		}
		
		/*
		* 更新公会成员
		*/
		public function updateMember(member:SGuildMember):void
		{
			var orgMemberInfo:SGuildMember = getMemberById(member.miniPlayer.entityId.id);
			if (member.position != orgMemberInfo.position)
			{
				changeMemberPosition(member.miniPlayer.entityId.id, member.position);
			}
			
			var nowMemberInfo:SGuildMember = getMemberById(member.miniPlayer.entityId.id);
			
			if (nowMemberInfo.position == EGuildPosition._EGuildBranchMember)
			{
				var index:int = branchMemberList.indexOf(nowMemberInfo);
				branchMemberList[index] = member;
			}
			else
			{
				index = memberList.indexOf(nowMemberInfo);
				memberList[index] = member;
			}
		}
		
		
		/*
		* 改变成员职位
		*/
		public function changeMemberPosition(playerID:int, postion:int):void
		{
			var orgMemberInfo:SGuildMember = getMemberById(playerID);
			if (orgMemberInfo.position == postion)
				return;
			updatePositionNum(orgMemberInfo.position, false);
			switch(postion)
			{
				case EGuildPosition._EGuildNotMember:
					if (orgMemberInfo.position == EGuildPosition._EGuildBranchMember)
					{
						var index:int = branchMemberList.indexOf(orgMemberInfo);
						branchMemberList.splice(index, 1);
					}
					else
					{
						index = memberList.indexOf(orgMemberInfo);
						memberList.splice(index, 1);
					}
					break;
				case EGuildPosition._EGuildBranchMember:
					index = memberList.indexOf(orgMemberInfo);
					memberList.splice(index, 1);
					orgMemberInfo.position = postion;
					branchMemberList.push(orgMemberInfo);
					break;
				default:
					if (orgMemberInfo.position == EGuildPosition._EGuildBranchMember)
					{
						index = branchMemberList.indexOf(orgMemberInfo);
						branchMemberList.splice(index, 1);
						orgMemberInfo.position = postion;
						memberList.push(orgMemberInfo);
					}
					else
					{
						orgMemberInfo.position = postion;
					}
					break;
			}
			updatePositionNum(postion, true);
		}
		
		/*
		* 通过玩家ID获取成员信息
		*/
		public function getMemberById(playerId:int):SGuildMember
		{
			for (var i:int = 0; i < memberList.length; i++)
			{
				var memberInfo:SGuildMember = memberList[i];
				if (memberInfo.miniPlayer.entityId.id == playerId)
				{
					return memberInfo;
				}
			}
			for (var j:int = 0; j < branchMemberList.length; j++)
			{
				var branchMemberInfo:SGuildMember = branchMemberList[j];
				if (branchMemberInfo.miniPlayer.entityId.id == playerId)
				{
					return branchMemberInfo;
				}
			}
			return null;
		}
		
		
		/*
		* 是否满员
		*/
		public function get memberListIsFull():Boolean
		{
			return baseInfo.playerNum == baseInfo.maxPlayerNum;
		}
		
		/*
		* 计算对应职位的人数
		*/
		private function updatePositionNum(positon:int, isAdd:Boolean):void
		{
			switch(positon)
			{
				case EGuildPosition._EGuildDeputyLeader:
					if (isAdd)
						deputyLeaderNum ++;
					else
						deputyLeaderNum --;
					break;
				case EGuildPosition._EGuildElite:
					if (isAdd)
						eliteNums ++;
					else
						eliteNums --;
					break;
				case EGuildPosition._EGuildLaw:
					if (isAdd)
						lawNums ++;
					else
						lawNums --;
					break;
				case EGuildPosition._EGuildPresbyter:
					if (isAdd)
						presbyterNum ++;
					else
						presbyterNum --;
					break;
				case EGuildPosition._EGuildMember:
					if (isAdd)
						normalMemberNum ++;
					else
						normalMemberNum --;
					break;
			}
			if (baseInfo != null)
				baseInfo.playerNum = memberList.length;
			if (branchInfo != null)
				branchInfo.playerNum = branchMemberList.length;
		}
		
		/*
		* 移除申请成员
		*/
		public function removeApplyMember(playerId:int):void
		{
			for (var i:int = 0; i < applyMemberList.length; i++)
			{
				var applyInfo:SMiniPlayer = applyMemberList[i];
				if (applyInfo.entityId.id == playerId)
				{
					applyMemberList.splice(i, 1);
					return;
				}
			}
		}
		
		/*
		* 退出工会
		*/
		public function exitGuild():void
		{
			clear();
		}
		
		/*
		* 解散工会
		*/
		public function disbandGuild():void
		{
			clear();
		}
		
		private function clear():void
		{
			_guildID = 0;
			selfInfo = null;
			baseInfo = null;
			branchInfo = null;
			memberList.length = 0;
			branchMemberList.length = 0;
			applyNum = 0;
			applyMemberList = null;
			warnMemberNum = 0;
			warnMemberList = null;
			goodMemberNum = 0;
			goodMemberList = null;
			lawNums = 0;
			eliteNums = 0;
			deputyLeaderNum = 0;
			presbyterNum = 0;
			normalMemberNum = 0;
			
			wareHouse.clear();
			shop.clear();
			buildingData.clear();
			skillData.clear();
			
			Cache.instance.role.roleEntityInfo.updateGuildId(0);
			ThingUtil.isNameChange = true;
		}
		
	}
}