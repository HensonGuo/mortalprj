package mortal.game.utils
{
	import Message.Game.EGuildPosition;
	import Message.Game.SGuildMember;
	
	import com.mui.events.SortEvent;
	
	import mortal.game.manager.ClockManager;

	public class GuildUtil
	{
		public static const MemberOnlineColor:uint = 0xffffff;
		public static const MemberOfflineColor:uint = 0x999999;
		
		public function GuildUtil()
		{
		}
		
		/*
		* 成员状态
		*/
		public static function getMemberOfflineState(lastLogOutDate:Date):String
		{
			var offlineContinueTime:int = ClockManager.instance.nowDate.time - lastLogOutDate.time;
			if (offlineContinueTime >= 7 * 24 * 60 * 60 * 1000)
			{
				return "离线七天以上";
			}
			if (offlineContinueTime >= 5 * 24 * 60 * 60 * 1000)
			{
				return "离线五天";
			}
			if (offlineContinueTime >= 3 * 24 * 60 * 60 * 1000)
			{
				return "离线三天";
			}
			return "离线";
		}
		
		/*
		* 默认的成员排序方法
		*/
		public static function defaultMemberListSortFunc(memberData1:SGuildMember, memberData2:SGuildMember):Number
		{
			if (memberData1.position == EGuildPosition._EGuildLeader && memberData2.position != EGuildPosition._EGuildLeader)
				return -1;
			if (memberData1.position != EGuildPosition._EGuildLeader && memberData2.position == EGuildPosition._EGuildLeader)
				return 1;
			if (memberData1.position == EGuildPosition._EGuildDeputyLeader && memberData2.position != EGuildPosition._EGuildDeputyLeader)
				return -1;
			if (memberData1.position != EGuildPosition._EGuildDeputyLeader && memberData2.position == EGuildPosition._EGuildDeputyLeader)
				return 1;
			if (memberData1.position == EGuildPosition._EGuildPresbyter && memberData2.position != EGuildPosition._EGuildPresbyter)
				return -1;
			if (memberData1.position != EGuildPosition._EGuildPresbyter && memberData2.position == EGuildPosition._EGuildPresbyter)
				return 1;
			if (memberData1.position == EGuildPosition._EGuildLaw && memberData2.position != EGuildPosition._EGuildLaw)
				return -1;
			if (memberData1.position != EGuildPosition._EGuildLaw && memberData2.position == EGuildPosition._EGuildLaw)
				return 1;
			if (memberData1.position == EGuildPosition._EGuildElite && memberData2.position != EGuildPosition._EGuildElite)
				return -1;
			if (memberData1.position != EGuildPosition._EGuildElite && memberData2.position == EGuildPosition._EGuildElite)
				return 1;
			if (memberData1.miniPlayer.online && !memberData2.miniPlayer.online)
				return -1;
			if (!memberData1.miniPlayer.online && memberData2.miniPlayer.online)
				return 1;
			return 0;
		}
		
		/*
		* 构建自定义成员排序方法
		*/
		public static function constructMemberListSortFunc(sortByAttrib:String, sortType:String, isPlayerAttrib:Boolean = false):Function
		{
			var sortFunction:Function = function(member1:SGuildMember, member2:SGuildMember):Number
			{
				if (isPlayerAttrib)
				{
					if (!member1.miniPlayer.hasOwnProperty(sortByAttrib))
						return 0;
					switch(sortType)
					{
						case SortEvent.ASCENDING:
							if (member1.miniPlayer[sortByAttrib] > member2.miniPlayer[sortByAttrib])
								return 1;
							if (member1.miniPlayer[sortByAttrib] < member2.miniPlayer[sortByAttrib])
								return -1;
							return 0;
						case SortEvent.DESCENDING:
							if (member1.miniPlayer[sortByAttrib] > member2.miniPlayer[sortByAttrib])
								return -1;
							if (member1.miniPlayer[sortByAttrib] < member2.miniPlayer[sortByAttrib])
								return 1;
							return 0;
					}
				}
				else
				{
					if (!member1.hasOwnProperty(sortByAttrib))
						return 0;
					switch(sortType)
					{
						case SortEvent.ASCENDING:
							if (member1[sortByAttrib] > member2[sortByAttrib])
								return 1;
							if (member1[sortByAttrib] < member2[sortByAttrib])
								return -1;
							return 0;
						case SortEvent.DESCENDING:
							if (member1[sortByAttrib] > member2[sortByAttrib])
								return -1;
							if (member1[sortByAttrib] < member2[sortByAttrib])
								return 1;
							return 0;
					}
				}
				return 0;
			};
			return sortFunction;
		}
	}
}