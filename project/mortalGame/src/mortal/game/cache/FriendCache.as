/**
 * @heartspeak
 * 2014-2-8 
 */   	
package mortal.game.cache
{
	import Message.DB.Tables.TConst;
	import Message.Game.EFriendFlag;
	import Message.Game.SFriendInfoMsg;
	import Message.Game.SFriendRecord;
	import Message.Game.SFriendRecordMsg;
	import Message.Public.EEntityAttribute;
	import Message.Public.SEntityId;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.HashMap;
	
	import flash.utils.Dictionary;
	
	import mortal.game.mvc.GameProxy;
	import mortal.game.resource.ConstConfig;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.view.forging.data.ForgingConst;
	import mortal.game.view.friend.Test;

	/**
	 * 好友数据缓存
	 * @author dengwj
	 * 
	 */	
	public class FriendCache
	{
		/** 好友列表数据 */
		private var _friendList:Array = [];
		/** 密友列表数据 */
		private var _closeFriendList:Array = [];
		/** 仇人列表数据 */
		private var _foeList:Array = [];
		/** 黑名单列表数据 */
		private var _blackList:Array = [];
		/** 最近联系人列表数据 */
		private var _recentList:Array = [];
//		private var _recentList:HashMap = new HashMap();
		/** 最近联系中的陌生人数据 */
		private var _strangerList:Array = [];
		
		public function FriendCache()
		{
			
		}
		
		public function get friendList():Array
		{
			this.friendSort(1);
			return this._friendList;
		}
		
		public function get closeFriendList():Array
		{
			this.friendSort(0);
			return this._closeFriendList;
		}
		
		public function get foeList():Array
		{
			this.friendSort(2);
			return this._foeList;
		}
		
		public function get blackList():Array
		{
			return this._blackList;
		}
		
		public function get recentList():Array
		{
			this.friendSort(4);
			return this._recentList;
		}
		
		/**
		 * 更新缓存数据 
		 * @param type
		 */	
		public function updateList(type:int, data:Object):void
		{
			if(data != null)
			{
				if(data is Array)
				{
					var list:Array = data as Array;
					switch(type)
					{
						case EFriendFlag._EFriendFlagFriend : 
							this._friendList = list;
							break;
						case EFriendFlag._EFriendFlagEnemy : 
							this._foeList = list;
							break;
						case EFriendFlag._EFriendFlagBlackList : 
							this._blackList = list;
							break;
//						case EFriendFlag._EFriendFlagContacted :
//							this._recentList = list;
							break;
					}
				}
			}
		}
		
		/**
		 * 根据选中叶签组获取列表数据
		 * @param group 选中的某个叶签的叶签号
		 */
		public function getCacheDataByGroup(group:int):Array
		{
			switch(group)
			{
				case 0 : return this._friendList;
				case 1 : return this._foeList;
				case 2 : return this._blackList;
				case 3 : return this._recentList;
				default: return [];
			}
		}
		
		/**
		 * 获取最近联系列表数据 
		 * @return 
		 */		
		private function getRecentList():Array
		{
			var arr:Array = new Array();
			arr = this._friendList.concat(this._foeList);
			arr = arr.concat(this._strangerList);
			for(var i:int = 0; i < arr.length; i++)
			{
				if(arr[i].lastTalkDt.time == 0)
				{
					arr.splice(i,1);
					i--;
				}
			}
			arr.sort(sortOnLastTalkTime);
			this._recentList = arr.slice(0,ConstConfig.instance.getValueByName("MaxContactedAmount"));
			return this._recentList;
		}
		
		/**
		 * 添加最近联系人 
		 * @return 
		 */		
		public function addToRecent(player:SMiniPlayer):void
		{
			if(this._recentList.length == 0)
			{
				this._recentList.push(player);
			}
			else
			{
				this._recentList.unshift(player);
				var maxContactNum:int = ConstConfig.instance.getValueByName("MaxContactedAmount");
				if(this._recentList.length > maxContactNum)
				{
					_recentList.pop();
				}
			}
		}
		
		/**
		 * 判断是否已是最近联系人 
		 */		
		public function isRecent(playerId:int):Boolean
		{
			for each(var role:SMiniPlayer in _recentList)
			{
				if(playerId == role.entityId.id)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 根据列表类型获取列表数据
		 * @param type 列表类型(1:好友列表 ,2:黑名单列表,4:仇人列表)
		 * 
		 */		
		public function getCacheDataByType(type:int):Array
		{
			var list:Array = [];
			switch(type)
			{
				case EFriendFlag._EFriendFlagFriend : 
					list = this._friendList;
					break;
				case EFriendFlag._EFriendFlagBlackList : 
					list = this._blackList;
					break;
				case EFriendFlag._EFriendFlagEnemy : 
					list = this._foeList;
					break;
				default : return [];
			}

			return list;
		}
		
		/**
		 * 对某一列表排序
		 * @param type 列表类型 
		 */
		public function friendSort(type:int):void
		{
			var list:Array = [];
			switch(type)
			{
				case 0 :
					list = this._closeFriendList;
					break;
				case 1 :
					list = this._friendList;
					break;
				case 2 :
					list = this._foeList;
					break;
				case 3 :
					list = this._blackList;
					break;
				case 4 :
					list = this._recentList;
					break;
			}
			if(type == 0 || type == 1)
			{
				list.sort(friendListSort);	
			}
			if(type == 2)
			{
				list.sort(sortOnLastKillTime);
			}
			if(type == 4)
			{
				list.sort(sortOnLastTalkTime);
			}
		}
		
		/**
		 * 好友列表排序 
		 * @param a
		 * @param b
		 * @return 
		 */		
		private function friendListSort(a:SFriendRecord, b:SFriendRecord):Number
		{
			// 按是否在线排序
			if(!a.friendPlayer.online && b.friendPlayer.online)
			{
				return 1;
			}
			else if(!b.friendPlayer.online && a.friendPlayer.online)
			{
				return -1;
			}
			else 
			{
				return sortOnLevel(a,b);
			}
		}
		
		/**
		 * 按等级排序 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */				
		private function sortOnLevel(a:SFriendRecord, b:SFriendRecord):Number
		{
			if(a.friendPlayer.level < b.friendPlayer.level)
			{
				return 1;
			}
			else if(b.friendPlayer.level < a.friendPlayer.level)
			{
				return -1;
			}
			else 
			{
				return 0;
			}
		}
		
		/**
		 * 按亲密度排序 
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */
		private function sortOnClose(a:SFriendRecord, b:SFriendRecord):Number
		{
			// TODO =====================按亲密度排序
			return 0;
		}

		/**
		 * 按最後一次击杀时间排序(仇人列表) 
		 */		
		private function sortOnLastKillTime(a:SFriendRecord, b:SFriendRecord):Number
		{
			if(a.lastKilledDt.time < b.lastKilledDt.time)
			{
				return 1;
			}
			else if(a.lastKilledDt.time > b.lastKilledDt.time)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 按最后一次私聊时间排序 (最近联系列表)
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		private function sortOnLastTalkTime(a:SFriendRecord, b:SFriendRecord):Number
		{
			if(a.lastTalkDt.time < b.lastTalkDt.time)
			{
				return 1;
			}
			else if(a.lastTalkDt.time > b.lastTalkDt.time)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 新增好友记录
		 * @param 好友记录 
		 */		
		public function addFriend(record:SFriendRecord):void
		{
			if(record)
			{
				this._friendList.push(record);
				this.friendSort(1);
			}
		}
		
		/**
		 * 添加一条记录到某个列表
		 * @param data 新增的记录
		 * @return 
		 */
		public function addRecord(data:SFriendRecord):void
		{
			switch(data.flag)
			{
				case EFriendFlag._EFriendFlagFriend :
					this._friendList.push(data);
					this.friendSort(1);
					break;
				case EFriendFlag._EFriendFlagBlackList :
					this._blackList.push(data);
					break;
//				case EFriendFlag._EFriendFlagContacted :
//					this._strangerList.push(data);
					break;
				case EFriendFlag._EFriendFlagEnemy : 
					this._foeList.push(data);
					this.friendSort(2);
					break;
			}
		}
		
		/**
		 * 根据recordId删除好友
		 * @param id 数组 
		 */
		public function removeFriendByIds(recordIds:Array):Boolean
		{
			var closeFlag:Boolean = false;
			for each(var recordId:Number in recordIds)
			{
				for(var i:int = 0; i < this.friendList.length; i++)
				{
					var friendRecord:SFriendRecord = this.friendList[i] as SFriendRecord;
					if(recordId == friendRecord.recordId)
					{
						this.friendList.splice(i, 1);
						if(friendRecord.friendType == 1)
						{// 删除的好友是密友
							removeCloseFriend(recordId);
							closeFlag = true;
						}
						break;
					}
				}
			}
			return closeFlag;
		}
		
		/**
		 * 根据所在列表及recordId删除一条好友记录 
		 * @param type 该记录所在列表
		 * @param id   最近联系列表的为playerId 否则为recordId
		 */		
		public function removeRecordById(type:int, id:Number):void
		{
			var deleteList:Array = [];// 要删除的记录所在列表
			switch(type)
			{
				case 0 : 
					deleteList = this._friendList;
					break;
				case 1 : 
					deleteList = this._foeList;
					break;
				case 2 :
					deleteList = this._blackList;
					break;
				case 3 :
					deleteList = this._recentList;
			}
			
			if(type == 0)
			{
				removeCloseFriend(id);// 如果是密友则删除
			}
			if(type != 3)
			{
				for(var i:int = 0; i < deleteList.length; i++)
				{
					if(id == (deleteList[i] as SFriendRecord).recordId)
					{
						deleteList.splice(i, 1);
						return;
					}
				}
			}
			else
			{
				for(i = 0; i < deleteList.length; i++)
				{
					if(id == (deleteList[i] as SMiniPlayer).entityId.id)
					{
						deleteList.splice(i, 1);
						return;
					}
				}
			}
		}	
		
		
		/**
		 * 根据数组类型和记录ID删除记录 
		 * @param arrType
		 * @param recordId
		 * 
		 */		
		private function deleteRecord(arrType:int,recordId:Number):void
		{
			var deleteList:Array = [];
			switch(arrType)
			{
				case 0 :
					deleteList = this._friendList;
					break;
				case 1 :
					deleteList = this._closeFriendList;
					break;
				case 2 :
					deleteList = this._foeList;
					break;
				case 3 :
					deleteList = this._blackList;
					break;
				case 4 :
					deleteList = this._recentList;
					break;
				case 5 :
					deleteList = this._strangerList;
					break;
			}
			for(var i:int = 0; i < deleteList.length; i++)
			{
				if(deleteList[i].recordId == recordId)
				{
					deleteList.splice(i,1);
					return;
				}
			}
		}
		
		/**
		 * 根据所在列表及playerId删除一条记录 
		 * @param palyerId
		 * 
		 */		
		public function removeRecordByRoleId(type:int, palyerId:int):void
		{
			var deleteList:Array = [];// 要删除的记录所在列表
			switch(type)
			{
				case EFriendFlag._EFriendFlagFriend : 
					deleteList = this._friendList;
					break;
				case EFriendFlag._EFriendFlagBlackList :
					deleteList = this._blackList;
					break;
				case EFriendFlag._EFriendFlagEnemy : 
					deleteList = this._foeList;
					break;
//				case EFriendFlag._EFriendFlagContacted :
//					deleteList = this._recentList;
			}
			if(type == EFriendFlag._EFriendFlagFriend)
			{
				removeCloseFriendById(palyerId);// 如果是密友则删除
			}
			for(var i:int = 0; i < deleteList.length; i++)
			{
				if(palyerId == (deleteList[i] as SFriendRecord).friendPlayer.entityId.id)
				{
					deleteList.splice(i, 1);
					return;
				}
			}
		}
		
		/**
		 * 根据记录ID删除记录 
		 * @param recordId 
		 */		
		public function deleteRecordById(recordId:Number):void
		{
			var listArr:Array = [];
			listArr.push(this._friendList);
			listArr.push(this._foeList);
			listArr.push(this._blackList);
			listArr.push(this._recentList);
			for each(var targetList:Array in listArr)
			{
				for(var i:int = 0; i < targetList.length; i++)
				{
					if(targetList[i].recordId == recordId)
					{
						targetList.splice(i,1);
						return;
					}
				}
			}
		}
		
		/**
		 * 获取密友数据 
		 */		
		public function getCloseFriendList():Array
		{
			this._closeFriendList = [];
			for each(var record:SFriendRecord in this.friendList)
			{
				if(record.friendType == 1)
				{// 是密友
					this._closeFriendList.push(record);
				}
			}
			this.friendSort(0);
			return this._closeFriendList;
		}
		
		/**
		 * 根据角色ID判断是否为密友 
		 * @param roleId 角色ID
		 */		
		public function judgeCloseFriend(roleId:int):Boolean
		{
			for each(var record:SFriendRecord in this._closeFriendList)
			{
				if(record.friendPlayer.entityId.id == roleId)
				{
					return true;	
				}
			}
			return false;
		}
		
		/**
		 * 添加密友 
		 * @param record 好友记录
		 */		
		public function addCloseFriend(record:SFriendRecord):void
		{
			this._closeFriendList.push(record);
			this.friendSort(0);
		}
		
		/**
		 * 根据recordId移除密友 
		 */		
		public function removeCloseFriend(recordId:Number):void
		{
			for(var i:int = 0; i < this._closeFriendList.length; i++)
			{
				if(recordId == (_closeFriendList[i] as SFriendRecord).recordId)
				{
					this._closeFriendList.splice(i, 1);
					return;
				}
			}
		}
		
		/**
		 * 根据playerId移除移除密友 
		 */		
		public function removeCloseFriendById(playerId:int):void
		{
			for(var i:int = 0; i < this._closeFriendList.length; i++)
			{
				if(playerId == (_closeFriendList[i] as SFriendRecord).friendPlayer.entityId.id)
				{
					this._closeFriendList.splice(i, 1);
					return;
				}
			}
		}
		
		/**
		 * 获取当前在线好友数 
		 * @param type 好友类型 0--好友  1--密友
		 */		
		public function getCurrOnlineNum(type:int):int
		{
			var count:int = 0;
			var findList:Array;
			if(type == 0){
				findList = this._friendList;// 查找好友列表
			}
			else
			{
				findList = this._closeFriendList;// 查找密友列表
			}
			for each(var friend:SFriendRecord in findList)
			{
				if(friend.friendPlayer.online == 1){
					count++;	
				}
			}
			return count;
		}
		
		/**
		 * 更新列表中的一条记录的信息 
		 * @data 需要更新的数据
		 */
		public function updateRecordInfo(data:Object):void
		{
			var list:Array = [];
			if(data is SFriendInfoMsg)
			{
				var obj:SFriendInfoMsg = data as SFriendInfoMsg;
				switch(obj.flag)
				{// 记录所在列表
					case EFriendFlag._EFriendFlagFriend :
						list = this._friendList;
						break;
					case EFriendFlag._EFriendFlagBlackList :
						list = this._blackList;
						break;
					case EFriendFlag._EFriendFlagEnemy :
						list = this._foeList;
						break;
				}
				for each(var player:SMiniPlayer in this._recentList)
				{
					if(player.entityId.id == obj.entityId.id)
					{
						player.online = obj.online;
						break;
					}
				}
				for each(var record:SFriendRecord in list)
				{
					if(record.friendPlayer.entityId.id == obj.entityId.id)
					{
						record.friendPlayer.online = obj.online;
						record.friendPlayer.level = obj.fromPlayerLevel;
						// TOOD 其他信息的更新
						return;
					}
				}
			}
			else if(data is SFriendRecord)
			{
				var friendRecord:SFriendRecord = data as SFriendRecord;
				switch(friendRecord.flag)
				{
					case EFriendFlag._EFriendFlagFriend :
						list = this._friendList;
						break;
					case EFriendFlag._EFriendFlagBlackList :
						list = this._blackList;
						break;
					case EFriendFlag._EFriendFlagEnemy :
						list = this._foeList;
						break;
//					case EFriendFlag._EFriendFlagContacted :
//						list = this._recentList;
						break;
				}
				for(var i:int = 0; i < list.length; i++)
				{
					if(list[i].friendPlayer.entityId.id == friendRecord.friendPlayer.entityId.id)
					{
						list[i] = friendRecord;	
						return;
					}
				}
				moveInList(friendRecord);// 更新所在列表  flag字段
			}
		}
		
		/**
		 * 列表间移动 
		 * param record   要移动的记录
		 * param fromList 当前列表
		 * param toList   将要移动到的列表
		 */		
		public function moveInList(record:SFriendRecord, fromList:int = -1, toList:int = -1):void
		{
			if(fromList < 0 && toList < 0)
			{
				deleteRecordById(record.recordId);
				addRecord(record);
			}
			else
			{
				
			}
		}
		
		/**
		 * 根据playerId更新属性 
		 * @param playerId 角色ID
		 * @param data 需要更新的属性数据[attrId:value]
		 */
		public function updateRecordById(playerId:int,data:Object):void
		{
			for each(var record:SFriendRecord in this._friendList)
			{
				if(record.friendPlayer.entityId.id == playerId)
				{
					if(data.attrId == EEntityAttribute._EAttributePlayerSignature)
					{
						record.friendPlayer.signature = data.value;
						return;
					}
				}
			}
			
			for each(record in this._foeList)
			{
				if(record.friendPlayer.entityId.id == playerId)
				{
					if(data.attrId == EEntityAttribute._EAttributePlayerSignature)
					{
						record.friendPlayer.signature = data.value;
						return;
					}
				}
			}
		}
		
		/**
		 * 根据playerId和列表类型查找列表中的记录 
		 * @param playerId 待查找的角色ID
		 * @param type 所在列表类型(1:好友列表 ,2:黑名单列表,4:仇人列表)
		 */
		public function findRecordByRoleId(playerId:int,type:int = 1):SFriendRecord
		{
			var list:Array;
			switch(type)
			{
				case EFriendFlag._EFriendFlagFriend :
					list = this.friendList;
					break;
				case EFriendFlag._EFriendFlagEnemy :
					list = this.foeList;
					break;
				case EFriendFlag._EFriendFlagBlackList :
					list = this.blackList;
					break;
			}
			
			for each(var record:SFriendRecord in list)
			{
				if(playerId == record.friendPlayer.entityId.id)
				{
					return record;
				}
			}
			return null;
		}
		
		/**
		 * 是不是黑名单玩家  根据角色名来判断
		 * @param name
		 * @return 
		 */
		public function isBlackListByName(name:String):Boolean
		{
			var friend:SFriendRecord;
			for (var i:int = 0; i < _blackList.length; i++) 
			{
				friend = _blackList[i];
				if(friend.friendPlayer.name == name)
					return true;
			}
			return false;
		}
		
		/**
		 * 是不是黑名单玩家 
		 * @param entityId
		 * @return 
		 */
		public function isBlackList(entityId:SEntityId):Boolean
		{
			var friend:SFriendRecord;
			for (var i:int = 0; i < _blackList.length; i++) 
			{
				friend = _blackList[i];
				if(EntityUtil.equal(friend.friendPlayer.entityId,entityId))
					return true;
			}
			return false;
		}
		
		
		
	}
}