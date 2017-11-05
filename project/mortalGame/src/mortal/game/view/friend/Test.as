package mortal.game.view.friend
{
	import Message.Game.SFriendRecord;
	import Message.Game.SFriendRecordMsg;
	import Message.Public.SEntityId;
	import Message.Public.SMiniPlayer;

	/**
	 * 测试数据
	 * @date   2014-2-28 下午3:41:59
	 * @author dengwj
	 */	 
	public class Test
	{
		public static var globalFriendCount:int = 1;
		public static var globalFoeCount:int = 1;
		public static var globalBlackCount:int = 1;
		public static var globalRecentCount:int = 1;
		
		public function Test()
		{
			
		}
		
		/**
		 * 创建一条角色列表中的记录
		 * @param recordId
		 * @param friendPlayer
		 * @param flag
		 * @param friendType
		 * @return 
		 * 
		 */		
		public static function getFriendRecord(recordId:Number,friendPlayer:SMiniPlayer,flag:int,friendType:int):SFriendRecord{
			var friend:SFriendRecord = new SFriendRecord();		
			friend.recordId = recordId;
			friend.friendPlayer = friendPlayer;
			friend.flag = flag;
			friend.friendType = friendType;
			return friend;
		}
		
		/**
		 * 获取一个SMiniplayer 
		 * @param id
		 * @param name
		 * @param sex
		 * @param career
		 * @param camp
		 * @param level
		 * @param online
		 * @param signature
		 * @return 
		 * 
		 */		
		public static function getMiniPlayer(id:int, name:String, sex:int, career:int, 
				camp:int, level:int, online:int, signature:String):SMiniPlayer{
			var player:SMiniPlayer = new SMiniPlayer();
			player.entityId = new SEntityId();
			player.entityId.id = id;
			player.name = name;
			player.sex = sex;
			player.career = career;
			player.camp = camp;
			player.level = level;
			player.online = online;
			player.signature = signature;
			return player;
		}
		
		/**
		 * 根据好友/密友类型获取一条好友/密友记录 
		 * @param friendType
		 * @return 
		 * 
		 */		
		public static function getRecord(friendType:int):SFriendRecord{
			var record:SFriendRecord;
			var player:SMiniPlayer;
			var id:int = 1000 + globalFriendCount;
			var recordId:Number = 10000 + globalFriendCount;
			var name:String = "测试账号" + globalFriendCount;
			player = getMiniPlayer(id,name,1,1,1,99,1,"个性签名个性签名");
			record = getFriendRecord(recordId,player,1,friendType);
			globalFriendCount++;
			return record;
		}
		
		/**
		 * 根据好友/密友类型获取一条好友/密友msg
		 * @param friendType
		 * @return 
		 * 
		 */		
		public static function getRecordMsg(friendType:int):SFriendRecordMsg{
			var recordMsg:SFriendRecordMsg = new SFriendRecordMsg();
			recordMsg.friendRecord = getRecord(friendType);
			return recordMsg;
		}
		
		/**
		 * 获取一条仇人记录 
		 * @return 
		 * 
		 */		
		public static function getFoeRecord():SFriendRecord{
			var record:SFriendRecord;
			var player:SMiniPlayer;
			var id:int = 2000 + globalFoeCount;
			var recordId:Number = 20000 + globalFoeCount;
			var name:String = "仇人" + globalFoeCount + "号";
			player = getMiniPlayer(id,name,1,1,1,99,1,"个性签名个性签名");
			record = getFriendRecord(recordId,player,4,0);
			globalFoeCount++;
			return record;
		}
		
		/**
		 * 获取一条黑名单记录 
		 * @return 
		 * 
		 */		
		public static function getBlackRecord():SFriendRecord{
			var record:SFriendRecord;
			var player:SMiniPlayer;
			var id:int = 3000 + globalBlackCount;
			var recordId:Number = 30000 + globalBlackCount;
			var name:String = "黑人" + globalBlackCount + "号";
			player = getMiniPlayer(id,name,1,1,1,99,1,"个性签名个性签名");
			record = getFriendRecord(recordId,player,2,0);
			globalBlackCount++;
			return record;
		}

		/**
		 * 获取一条最近联系人记录 
		 * @return 
		 * 
		 */		
		public static function getRecentRecord():SFriendRecord{
			var record:SFriendRecord;
			var player:SMiniPlayer;
			var id:int = 4000 + globalRecentCount;
			var recordId:Number = 40000 + globalRecentCount;
			var name:String = "最近联系人" + globalRecentCount + "号";
			player = getMiniPlayer(id,name,1,1,1,99,1,"个性签名个性签名");
			record = getFriendRecord(recordId,player,1,0);
			globalRecentCount++;
			return record;
		}
	}
}