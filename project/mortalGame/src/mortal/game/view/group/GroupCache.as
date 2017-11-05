package mortal.game.view.group
{
	import Message.Public.SEntityId;
	import Message.Public.SGroup;
	import Message.Public.SGroupOper;
	import Message.Public.SGroupPlayer;
	import Message.Public.SPublicPlayer;
	
	import mortal.game.cache.Cache;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	
	
	public class GroupCache
	{
		private var _waitingPlayers:Array = [];//队列成员信息
		private var _players:Array = [];//队列成员
		private var _captain:SEntityId;//队长
//		private var _allocation:int;//分配方案
		private var _groupId:SEntityId;
		private var _nearTeamList:Array = []; //附近队伍列表
		private var _inviteList:Array = [];//邀请列表 
		private var _applyList:Array = [];//申请列表
		private var _selfInfo:SGroupPlayer;  //无队伍时自己的信息
		private var _groupName:String;
		
		/**
		 * 队伍设置 
		 */		
		public var memberInvite:Boolean = false;//是否允许队员邀请其他玩家
		public var autoEnter:Boolean = false;//是否允许申请者直接进入队伍
		
		public function GroupCache()
		{
		}
		
		/**
		 * 队伍排序(把自己排在第一位) 
		 * 
		 */		
		private function sortCaptain(a1:SGroupPlayer,a2:SGroupPlayer):int
		{
			var id:int = Cache.instance.role.entityInfo.entityId.id;
			if(a1.player.entityId.id == id)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		
		/**
		 * 是否在队伍中 （有队伍信息说明自己是在队伍中）
		 * @return 
		 * 
		 */		
		public function get isInGroup():Boolean
		{
			return _players.length > 0;
		}
		
		public function get selfInfo():SGroupPlayer    //没有组队时,先创建一个自己的SGroupPlayer
		{
			if(_selfInfo == null)
			{
				_selfInfo = new SGroupPlayer();
				_selfInfo.player = new SPublicPlayer();
			}
			_selfInfo.player.name = Cache.instance.role.playerInfo.name;
			_selfInfo.player.level = Cache.instance.role.entityInfo.level;
			_selfInfo.player.VIP = Cache.instance.role.playerInfo.VIP;
			_selfInfo.player.camp = Cache.instance.role.playerInfo.camp;
			_selfInfo.player.career = Cache.instance.role.entityInfo.career;
			_selfInfo.player.combat = Cache.instance.role.entityInfo.combat;
			return _selfInfo;
		}
		
		/**
		 * 是否队长 
		 * @return 
		 * 
		 */		
		public function get isCaptain():Boolean
		{
			if(!_captain || !Cache.instance.role.entityInfo.entityId)
			{
				return false;
			}
			
			if(isInGroup && _captain && EntityUtil.toString(Cache.instance.role.entityInfo.entityId) == EntityUtil.toString(_captain))
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 通过判断该id是否为队长
		 * @return 
		 * 
		 */		
		public function isCaptainById(id:int):Boolean
		{
			return id == captain.id;
		}
		
		/**
		 * 判断实体是否为队伍里的成员 
		 * @param entityId
		 * @return true是
		 * 
		 */		
		public function entityIsInGroup(entityId:SEntityId):Boolean
		{
			if(entityId == null)
			{
				return false;
			}
			for(var i:int=0;i<_players.length;i++)
			{
				var tEntityId:SEntityId = (players[i] as SGroupPlayer).player.entityId;
				if(entityId && tEntityId)
				{
					if( entityId.id ==tEntityId.id 
						&& entityId.typeEx ==tEntityId.typeEx 
						&& entityId.typeEx2 == tEntityId.typeEx2 )
					{
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 添加邀请列表(屏蔽掉已经出现的邀请) 
		 * @param sPublucPlayer
		 * 
		 */		
		public function addInviteList(sGroupOper:SGroupOper):void
		{
			
			for each(var groupOper:SGroupOper in _inviteList)
			{
				if(sGroupOper.fromEntityId.id == groupOper.fromEntityId.id)
				{
					return;
				}
			}
			
			_inviteList.push(sGroupOper);
		}
		
		/**
		 * 添加申请列表(屏蔽掉已经出现的申请) 
		 * @param sPublucPlayer
		 * 
		 */		
		public function addApplyList(sGroupOper:SGroupOper):void
		{
			
			for each(var groupOper:SGroupOper in _applyList)
			{
				if(sGroupOper.fromEntityId.id == groupOper.fromEntityId.id)
				{
					return;
				}
			}
			
			_applyList.push(sGroupOper);
		}
		
		/**
		 * 取消队伍 
		 * 
		 */		
		public function disbanGroup():void
		{
			_players = new Array();//队列成员
			_captain = null;//队长
			_groupId = null;
			_groupName = "";
		}
		
		public function get waitingPlayers():Array
		{
			return _waitingPlayers;
		}
		
		public function set waitingPlayers(arr:Array):void
		{
			_waitingPlayers = arr;
		}
		
		public function get players():Array
		{
			return _players;
		}
		
		public function set players(arr:Array):void
		{
			_players = arr;
			_players.sort(sortCaptain);
		}
		
		public function get captain():SEntityId
		{
			return _captain;
		}
		
		public function set captain(sEntityId:SEntityId):void
		{
			_captain = sEntityId;
		}
		
		public function get groupId():SEntityId
		{
			return _groupId;
		}
		
		public function set groupId(sEntityId:SEntityId):void
		{
			_groupId = sEntityId;
		}
		
		public function get inviteList():Array
		{
			return _inviteList;
		}
		
		public function set inviteList(arr:Array):void
		{
			_inviteList = arr;
		}
		
		public function get applyList():Array
		{
			return _applyList;
		}
		
		public function set applyList(arr:Array):void
		{
			_applyList = arr;
		}
		
		public function get nearTeamList():Array
		{
			return _nearTeamList;
		}
		
		public function set nearTeamList(arr:Array):void
		{
			if(isInGroup)  //屏蔽自己的队伍
			{
				for(var i:int ; i < arr.length ; i++)
				{
					if((arr[i] as SGroup).groupId.id == _groupId.id)
					{
						arr.splice(i,1);
					}
				}
			}
			_nearTeamList = arr;
		}
		
		public function get groupName():String
		{
			return _groupName;
		}
		
		public function set groupName(str:String):void
		{
			_groupName = str;
		}
	}
}