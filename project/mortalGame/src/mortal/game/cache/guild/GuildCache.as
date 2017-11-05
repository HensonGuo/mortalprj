package mortal.game.cache.guild
{
	import Message.Game.SGuildInfo;
	import Message.Game.SMiniGuildInfo;

	public class GuildCache
	{
		//公会列表
		private var _guildListStartIndex:int = 0;
		private var _guildTotalCount:int = 0;
		private var _guildList:Array;
		public var guildListWaitForSync:Boolean = false;//等待列表的同步
		
		//发出邀请的公会列表
		private var _invitList:Array = new Array();
		
		//其他工会信息
		public var otherGuildInfo:SGuildInfo;
		//自身工会信息
		public var selfGuildInfo:SelfGuildInfo = new SelfGuildInfo();
		
		public function GuildCache()
		{
			
		}
		
		
		
		public function syncList(startIndex:int, totalCount:int, list:Array):void
		{
			this._guildListStartIndex = startIndex;
			this._guildTotalCount = totalCount;
			this._guildList = list;
			guildListWaitForSync = false;
		}
		
		public function get list():Array
		{
			return _guildList;
		}
		
		public function get startIndex():int
		{
			return _guildListStartIndex;
		}
		
		public function get totalCount():int
		{
			return _guildTotalCount;
		}
		
		
		
		/**
		 * 缓存邀请信息,服务端不做数据保存
		 */
		public function cacheInviteInfo(inviteInfo:SMiniGuildInfo):void
		{
			_invitList.push(inviteInfo);
		}
		
		public function removeInviteInfo(guildID:int, isRemoveAll:Boolean = false):void
		{
			if (isRemoveAll)
			{
				_invitList.length = 0;
				return;
			}
			for (var i:int = 0; i < _invitList.length; i++)
			{
				var inviteInfo:SMiniGuildInfo = _invitList[i];
				if (inviteInfo.guildId == guildID)
				{
					_invitList.splice(i, 1);
					return;
				}
			}
		}
		
		public function get inviteList():Array
		{
			return _invitList;
		}
	}
}