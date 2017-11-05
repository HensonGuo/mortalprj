package mortal.game.control
{
	import Message.Game.EFriendFlag;
	import Message.Game.EFriendReplyResult;
	import Message.Game.EFriendType;
	import Message.Game.SFriendInfoMsg;
	import Message.Game.SFriendRecord;
	import Message.Game.SFriendRecordMsg;
	import Message.Game.SFriendRemoveMsg;
	import Message.Game.SFriendReplyMsg;
	import Message.Public.EUpdateType;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SMiniPlayer;
	
	import flash.events.Event;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.FriendProxy;
	import mortal.game.view.friend.FriendIcon;
	import mortal.game.view.friend.FriendModule;
	import mortal.game.view.friend.SelectedCellRenderer;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class FriendController extends Controller
	{
		private var _friendProxy:FriendProxy;
		private var _friendModule:FriendModule;
		
		public function FriendController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_friendProxy = GameProxy.friend;
		}
		
		override protected function initView():IView
		{	
			if(_friendModule == null)
			{
				_friendModule = new FriendModule();
				_friendModule.addEventListener(WindowEvent.SHOW, onFriendShow);
				_friendModule.addEventListener(WindowEvent.CLOSE, onFriendClose);
				this._friendProxy.getFriendList(EFriendFlag._EFriendFlagFriend);// 第一次打开界面请求数据
				this._friendModule.updateSelfInfo(this.cache.role);
			}
			return _friendModule;
		}
		
		override protected function initServer():void
		{
			NetDispatcher.addCmdListener(ServerCommand.GetAllFriendRecords, getAllFriendRecordsHandler);// 获取所有列表数据
			NetDispatcher.addCmdListener(ServerCommand.FriendApplyRemind, friendApplyRemindHandler);// 申请好友提醒
			NetDispatcher.addCmdListener(ServerCommand.FriendApplyReply, replyApplyerHandler);// 对申请方的回执
			NetDispatcher.addCmdListener(ServerCommand.FriendUpdate, friendUpdateHandler);// 删除、添加、修改
			NetDispatcher.addCmdListener(ServerCommand.FriendInfoUpdate, friendInfoUpdateHandler);
			NetDispatcher.addCmdListener(ServerCommand.BatAddFriends, batAddFriendsHandler);// 批量添加好友
			NetDispatcher.addCmdListener(ServerCommand.FriendOnlineStatus, FriendOnLineUpdateHandler);// 好友、仇人、最近联系在线状态更新
			NetDispatcher.addCmdListener(ServerCommand.FriendDelete, friendDeleteHandler);// 删除好友
			NetDispatcher.addCmdListener(ServerCommand.AddToRecent, addToRecentHandler);// 添加最近联系人
			
			Dispatcher.addEventListener(EventName.FriendApply, friendApplyHandler);// 申请好友
			Dispatcher.addEventListener(EventName.FriendReply, friendReplyHandler);// 回复申请
		}
		
		private function onFriendShow(e:Event):void
		{
			NetDispatcher.addCmdListener(ServerCommand.GetFriendList, getFriendListHandler);// 获取好友列表数据
			NetDispatcher.addCmdListener(ServerCommand.GetOneKeyMakeFriendsInfo, oneKeyFriendHandler);// 一键征友
			NetDispatcher.addCmdListener(ServerCommand.GetRoleList, getRolesHandler);// 查找玩家
			
			Dispatcher.addEventListener(EventName.FriendListReq, friendListReqHandler);
			Dispatcher.addEventListener(EventName.FriendDeleteListReq, deleteListReqHandler);
			Dispatcher.addEventListener(EventName.FriendAddToDelete, addToDeleteListHandler);
			Dispatcher.addEventListener(EventName.FriendCancelDelete, cancelDeleteHandler);
			Dispatcher.addEventListener(EventName.FriendDelete, deleteFriendsHandler);
			Dispatcher.addEventListener(EventName.FriendSearch, searchFriendHandler);
			Dispatcher.addEventListener(EventName.AddToBlackList, addToBlackListHandler);
			Dispatcher.addEventListener(EventName.FriendDeleteRecord, deleteRecordHandler);
			Dispatcher.addEventListener(EventName.SignatureUpdate, signUpdateHandler);
			Dispatcher.addEventListener(EventName.ModifyFriendType, ModifyFriendTypeHandler);
			
			this._friendModule.updateSelfInfo(this.cache.role);
		}
		
		private function onFriendClose(e:Event):void
		{
			NetDispatcher.removeCmdListener(ServerCommand.GetFriendList, getFriendListHandler);
			NetDispatcher.removeCmdListener(ServerCommand.GetOneKeyMakeFriendsInfo, oneKeyFriendHandler);
			NetDispatcher.removeCmdListener(ServerCommand.GetRoleList, getRolesHandler);
			
			Dispatcher.removeEventListener(EventName.FriendListReq, friendListReqHandler);
			Dispatcher.removeEventListener(EventName.FriendDeleteListReq, deleteListReqHandler);
			Dispatcher.removeEventListener(EventName.FriendAddToDelete, addToDeleteListHandler);
			Dispatcher.removeEventListener(EventName.FriendCancelDelete, cancelDeleteHandler);
			Dispatcher.removeEventListener(EventName.FriendDelete, deleteFriendsHandler);
			Dispatcher.removeEventListener(EventName.FriendSearch, searchFriendHandler);
			Dispatcher.removeEventListener(EventName.AddToBlackList, addToBlackListHandler);
			Dispatcher.removeEventListener(EventName.FriendDeleteRecord, deleteRecordHandler);
			Dispatcher.removeEventListener(EventName.SignatureUpdate, signUpdateHandler);
			Dispatcher.removeEventListener(EventName.ModifyFriendType, ModifyFriendTypeHandler);
		}
		
		/**
		 * 申请好友 
		 * @param e
		 */		
		private function friendApplyHandler(e:DataEvent):void
		{
			this._friendProxy.apply(e.data as String);// 发送好友申请
		}
		
		/**
		 * 获取好友列表数据(服务端回调)
		 * @param obj
		 */
		private function getFriendListHandler(obj:Object=null):void
		{
			var list:Array = (obj as Array);
			var type:int   = -1;// 列表类型
			for each(var data:SFriendRecord in list)
			{
				type = type < 0 ? data.flag : type;
			}
			cache.friend.updateList(type, list);// 缓存数据
			if(this._friendModule == null) 
			{
				return;
			}
			if(list.length != 0)
			{
				this._friendModule.updateCurrList();
				if(type == EFriendFlag._EFriendFlagFriend)
				{
					var closeData:Array = cache.friend.getCloseFriendList();// 密友数据
					this._friendModule.updateCloseList(closeData);
					
					setFriendsListDisplay();
				}
				else if(type == EFriendFlag._EFriendFlagBlackList)
				{
					
				}
				else
				{
					this._friendModule.openList(2);
				}
				
			}
			else
			{
				this._friendModule.updateList(new Array());
				if(this._friendModule.currSelGroup == 0)
				{
					this._friendModule.updateCloseList();
					this._friendModule.updatePosition(1);
				}
			}
		}
		
		/**
		 * 好友申请提醒处理 
		 * @param obj
		 */
		private function friendApplyRemindHandler(obj:Object = null):void
		{
			if(obj)
			{
				var role:SMiniPlayer = obj as SMiniPlayer;
				if(ClientSetting.local.getIsDone(IsDoneType.RefuseOtherApply))// 是否设置了拒绝添加好友
				{
					var data:Object  = {};
					data["result"]   = EFriendReplyResult._EFriendReplyResultReject;
					data["playerId"] = role.entityId.id;
					Dispatcher.dispatchEvent(new DataEvent(EventName.FriendReply, data));					
				}
				else
				{
					FriendIcon.tabIndex = 3;
					FriendIcon.instance.show();
					FriendIcon.instance.addApplyer(role);
				}
			}
		}
		
		
		/**
		 * 回复申请方
		 * @param data[result] 回复结果 1--同意, 2--拒绝
		 * @param data[playerId] 角色ID/ID数组
		 */
		private function friendReplyHandler(e:DataEvent):void
		{
			if(e.data)
			{
				var result:int      = e.data.result;
				var playerIds:Array = e.data.playerId;
				this._friendProxy.reply(playerIds,result,1);
			}
		}

		/**
		 * 批量添加好友处理 
		 * @return 
		 */		
		private function batAddFriendsHandler(obj:Object):void
		{
			if(obj)
			{
				var result:int = obj.result as int;
				var ids:Array  = obj.ids as Array;
				if(result == 0)// 回复成功
				{
					for each(var id:int in ids)
					{
						FriendIcon.instance.removeApplyer(id);
					}
				}
				else
				{
					return;
				}
			}
		}
		
		/**
		 * 对好友申请的回复 
		 * @param obj
		 */			
		private function replyApplyerHandler(obj:Object = null):void
		{
			if(obj)
			{
				var reply:SFriendReplyMsg = obj as SFriendReplyMsg;
				var roleId:int            = Cache.instance.role.playerInfo.playerId;
				var name:String           = "";
				if(roleId == reply.apply.entityId.id)
				{
					name = reply.reply.name;
				}
				else
				{
					name = reply.apply.name;
				}
				switch(reply.result)
				{
					case EFriendReplyResult._EFriendReplyResultAccept : // 同意
						MsgManager.showRollTipsMsg("您已成功添加 " + name);
						break;
					case EFriendReplyResult._EFriendReplyResultReject : // 拒绝
						MsgManager.showRollTipsMsg("对方拒绝了您的申请");
						break;
					case EFriendReplyResult._EFriendReplyApplicantAmountLimit : //申请人好友人数达到上限
						MsgManager.showRollTipsMsg("您的好友人数已达上限");
						break;
					case EFriendReplyResult._EFriendReplyReplierAmountLimit : // 回复人好友人数达到上限
						MsgManager.showRollTipsMsg("对方好友人数已达上限");
						break;
				}
			}
		}
		
		/**
		 * 一键征友信息处理
		 * @param obj
		 */
		private function oneKeyFriendHandler(obj:Object=null):void
		{
			// TODO ==================一键征友
		}
		
		/**
		 * 请求好友列表数据
		 * @param obj
		 */
		private function friendListReqHandler(e:DataEvent):void
		{
			this._friendModule.updateCurrList();
			var type:int       = e.data as int;
			var flag:int       = 0;
			var roleList:Array = cache.friend.getCacheDataByGroup(type);
			if(roleList.length != 0)
			{
				if(this._friendModule == null) 
				{
					return;
				}
				this._friendModule.updateCurrList();
				if(type == 0)
				{
					var closeList:Array = cache.friend.getCloseFriendList();// 密友数据
					this._friendModule.updateCloseList(closeList);
					this._friendModule.updatePosition(1);
					setFriendsListDisplay();
				}
				else
				{
					this._friendModule.openList(2);
				}
			}
			else
			{
				switch(type)
				{
					case 0 : 
						flag = EFriendFlag._EFriendFlagFriend;
						setFriendsListDisplay();
						break;
					case 1 : 
						flag = EFriendFlag._EFriendFlagEnemy;
						break;
					case 2 : 
						flag = EFriendFlag._EFriendFlagBlackList;
						break;
				}
				if(flag != 0)
				{
					this._friendProxy.getFriendList(flag);
				}
			}
		}
		
		/**
		 * 设置好友和密友列表的显示方式 
		 * @param e
		 */		
		private function setFriendsListDisplay():void
		{
			this._friendModule.openList(0);
			this._friendModule.closeList(1);
			if(cache.friend.friendList.length == 0)
			{
				this._friendModule.updatePosition(0);
				this._friendModule.closeList(0);
			}
			else if(cache.friend.closeFriendList.length == 0)
			{
				this._friendModule.closeList(0);
				this._friendModule.openList(1);
			}
			this._friendModule.updatePosition(1);
			this._friendModule.updateRoleNum(0);
			this._friendModule.updateRoleNum(1);
		}
		
		/**
		 * 请求批量删除中的好友列表数据 
		 * @param e
		 */		
		private function deleteListReqHandler(e:DataEvent):void
		{
			var data:Array = cache.friend.friendList;// 从缓存中取数
			this._friendModule.friendDeletePanel.updateList(data);
		}
		
		/**
		 * 添加到删除列表 
		 * @param e
		 */		
		private function addToDeleteListHandler(e:DataEvent):void
		{
			var friend:SelectedCellRenderer = e.data as SelectedCellRenderer;
			this._friendModule.friendDeletePanel.updateList(friend);
		}
		
		/**
		 * 取消删除 
		 */		
		private function cancelDeleteHandler(e:DataEvent):void
		{
			this._friendModule.friendDeletePanel.cancelDelete(e.data);
		}
		
		/**
		 * 批量删除好友 
		 */		
		private function deleteFriendsHandler(e:DataEvent):void
		{
			var result:Boolean = cache.friend.removeFriendByIds(e.data.ids as Array);// 从缓存中删除
			// 更新显示列表
			if(e.data.type == 1)// 批量删除
			{
				this._friendModule.friendDeletePanel.updateList(cache.friend.friendList);
				this._friendModule.friendDeletePanel.clear();
			}
			this._friendModule.updateList(cache.friend.friendList);
			this._friendModule.updateRoleNum(1);
			if(result)
			{
				// 如果删除的是密友，则同时更新密友列表
				this._friendModule.updateCloseList();
				this._friendModule.updateRoleNum(0);
			}
			
			this._friendProxy.removeAll(EFriendFlag._EFriendFlagFriend, e.data.ids as Array);
		}
		
		/**
		 * 在当前列表中删除记录处理
		 * @param e
		 */
		private function deleteRecordHandler(e:DataEvent):void
		{
			var type:int = this._friendModule.currSelGroup;
			if(e.data is SFriendRecord)
			{
				var recordId:Number = (e.data as SFriendRecord).recordId;
				var flag:int = 0;
				deleteRecord(type, recordId);
				switch(type){
					case 0 :
						flag = EFriendFlag._EFriendFlagFriend;
						break;
					case 1 :
						flag = EFriendFlag._EFriendFlagEnemy;
						break;
					case 2 :
						flag = EFriendFlag._EFriendFlagBlackList;
						break;
				}
				this._friendProxy.removeAll(flag,[recordId]);
			}
			else if(e.data is SMiniPlayer)// 最近联系列表的删除
			{
				deleteRecord(type, (e.data as SMiniPlayer).entityId.id);
			}
		}
		
		/**
		 * 添加一条记录到某个列表中
		 * @param record 要添加的记录
		 * 
		 */		
		private function addRecord(record:SFriendRecord):void
		{
			if(this._friendModule == null)
			{
				return;
			}
			// 如果添加的记录已在黑名单中，则清除黑名单记录
			for each(var black:SFriendRecord in cache.friend.blackList)
			{
				if(record.friendPlayer.entityId.id == black.friendPlayer.entityId.id)
				{
					cache.friend.removeRecordById(EFriendFlag._EFriendFlagBlackList, black.recordId);
					if(this._friendModule.currSelGroup == EFriendFlag._EFriendFlagBlackList)
					{
						this._friendModule.updateList(cache.friend.blackList);
					}
					break;
				}
			}
			
			cache.friend.addRecord(record);
			this._friendModule.updateCurrList();
			if(record.flag == EFriendFlag._EFriendFlagFriend)
			{
				this._friendModule.updateRoleNum(1);
				if(this._friendModule.currSelGroup == 0)
				{
					setFriendsListDisplay();
				}
			}
		}
		
		/**
		 * 删除一条记录 
		 * @param type 记录所在列表
		 * @param recordId 记录ID
		 */
		private function deleteRecord(type:int, recordId:Number):void
		{
			cache.friend.removeRecordById(type,recordId);
			if(this._friendModule == null)
			{
				return;
			}
			if(type == this._friendModule.currSelGroup)
			{
				this._friendModule.updateCurrList();
			}
			if(this._friendModule.currSelGroup == 0)
			{
				this._friendModule.updateCloseList();
				this._friendModule.updateRoleNum(0);
				this._friendModule.updateRoleNum(1);
				this._friendModule.updatePosition(1);
			}
		}
		
		/**
		 * 搜索好友 
		 * @param e
		 */
		private function searchFriendHandler(e:DataEvent):void
		{
			var nameArr:Array = e.data as Array;
			GameProxy.player.findMiniPlayerByName(nameArr);// 请求数据
		}
		
		/**
		 * 返回一条记录(添加、删除、更新)
		 * @param obj
		 */
		private function friendUpdateHandler(obj:Object):void
		{
			if(obj)
			{
				var data:SFriendRecordMsg = obj as SFriendRecordMsg;
				switch(data.type)
				{
					case EUpdateType._EUpdateTypeAdd : // 添加记录
						this.addRecord(data.friendRecord);
						break;
					case EUpdateType._EUpdateTypeDel : // 删除记录
						var flag:int = data.friendRecord.flag;
						var type:int = 0;
						switch(flag){
							case EFriendFlag._EFriendFlagFriend : type    = 0; break;
							case EFriendFlag._EFriendFlagEnemy : type     = 1; break;
							case EFriendFlag._EFriendFlagBlackList : type = 3; break;
						}
						deleteRecord(type,data.friendRecord.recordId);
						break;
					case EUpdateType._EUpdateTypeUpdate : // 更新记录
						cache.friend.updateRecordInfo(data.friendRecord);
						if(this._friendModule)
						{
							this._friendModule.updateCurrList();
						}
						break;
				}
			}
		}
		
		/**
		 * 删除列表中的一条记录
		 * @param obj
		 * 
		 */		
		private function friendDeleteHandler(obj:Object):void
		{
			if(obj)
			{
				if(this._friendModule == null)
				{
					return;
				}
				var info:SFriendRemoveMsg = obj as SFriendRemoveMsg;
				var type:int;
				var data:Array = cache.friend.getCacheDataByType(info.flag);
				cache.friend.removeRecordByRoleId(info.flag,info.fromPlayerId);
				this._friendModule.updateList(data);
				if(info.flag == EFriendFlag._EFriendFlagFriend)
				{
					this._friendModule.updateCloseList();
					this._friendModule.updateRoleNum(0);
					this._friendModule.updateRoleNum(1);
					this._friendModule.updatePosition(1);
				}
			}
		}
		
		/**
		 * 好友在线状态更新 
		 */		
		private function FriendOnLineUpdateHandler(obj:Object):void
		{
			if(obj){
				var friendInfo:SFriendInfoMsg = obj as SFriendInfoMsg;
				
				// 添加好友上下线历史记录
				var record:SFriendRecord = cache.friend.findRecordByRoleId(friendInfo.fromPlayerId,friendInfo.flag);
				var msg:String;
				if(record)
				{
					if(record.flag == EFriendFlag._EFriendFlagFriend)
					{
						msg = "你的好友 " + record.friendPlayer.name;
						if(friendInfo.online)
						{
							msg += " 上线了";
						}
						else
						{
							msg += " 下线了";
						}
						MsgManager.addTipText(msg,MsgHistoryType.FriendMsg);
					}
				}
				
				if(this._friendModule == null)
				{
					return;
				}
				
				cache.friend.updateRecordInfo(friendInfo);// 更新记录信息
				
				this._friendModule.updateCurrList();//更新显示列表
				
				if(friendInfo.flag == EFriendFlag._EFriendFlagFriend)
				{
					if(cache.friend.judgeCloseFriend(friendInfo.entityId.id))// 是密友
					{
						this._friendModule.updateCloseList();
						this._friendModule.updateRoleNum(0);
					}
					this._friendModule.updateRoleNum(1);
				}
			}
		} 
		
		/**
		 * 更改个性签名处理 
		 * @param e
		 * 
		 */		
		private function signUpdateHandler(e:DataEvent):void
		{
			var sign:String = e.data as String;
			// 更新保存到缓存
			Cache.instance.role.playerInfo.signature = sign;
			GameProxy.player.sendSignature(sign);
		}
		
		/**
		 * 拉黑处理 (好友/非好友)
		 * @param e
		 */
		private function addToBlackListHandler(e:DataEvent):void
		{
			var obj:Object;
			if(e.data is SMiniPlayer)// 通过链接拉黑、最近联系拉黑
			{
				obj = e.data as SMiniPlayer;
				var record:SFriendRecord = cache.friend.findRecordByRoleId(obj.entityId.id);
				if(record)
				{// 好友拉黑
					addToBlackList(record);
				}
				else
				{// 非好友拉黑
					this._friendProxy.addToBlackList(obj.entityId.id);
				}
			}
			if(e.data is SFriendRecord)// 通过下拉菜单拉黑
			{
				obj = e.data as SFriendRecord;
				addToBlackList(obj as SFriendRecord);
			}
			this._friendProxy.getFriendList(EFriendFlag._EFriendFlagBlackList);// 更新黑名单列表缓存数据
		}
		
		
		/**
		 * 任一列表的拉黑处理 
		 * @param record 待拉黑的好友项
		 */
		private function addToBlackList(record:SFriendRecord):void
		{
			if(record.flag != EFriendFlag._EFriendFlagFriend)// 非好友拉黑
			{
				this._friendProxy.addToBlackList(record.friendPlayer.entityId.id);
				return;
			}
			
			this._friendProxy.moveIntoList(record.recordId,record.flag,EFriendFlag._EFriendFlagBlackList);
			var type:int = 0;
			if(record.flag == EFriendFlag._EFriendFlagFriend)
			{
				type = 0;
			}
			else if(record.flag == EFriendFlag._EFriendFlagEnemy)
			{
				type = 1;
			}
			cache.friend.removeRecordById(type,record.recordId);
			this._friendModule.updateCurrList();
			
			if(record.flag == EFriendFlag._EFriendFlagFriend)
			{
				this._friendModule.updateRoleNum(1);
				if(record.friendType == EFriendType._EFriendtypeIntimate)
				{
					this._friendModule.updateCloseList();
					this._friendModule.updateRoleNum(0);
				}
				this._friendModule.updatePosition(1);
			}

		}
		
		/**
		 * 搜索玩家结果处理 
		 */
		private function getRolesHandler(obj:Object):void
		{
			if(obj && (obj as Array).length != 0)
			{
				var result:Array = obj as Array;
				if(0 < result.length)
				{
					this._friendModule.friendSetPanel.searchRole = result[0];
					this._friendModule.friendSetPanel.updateData(result[0]);
				}		
			}
			else
			{
				this._friendModule.friendSetPanel.updateData(null);
			}
		}
		
		/**
		 * 好友信息更新处理 
		 */
		private function friendInfoUpdateHandler(obj:Object):void
		{
			if(obj)
			{
				var info:SAttributeUpdate = obj as SAttributeUpdate;
				var data:Object = {};
				data["attrId"] = info.attribute.value();// 属性类型
				data["value"] = info.valueStr;// 属性值
				cache.friend.updateRecordById(info.value, data);
				if(this._friendModule == null)
				{
					return;
				}
				// 更新显示列表
				this._friendModule.updateCurrList();	
				if(cache.friend.judgeCloseFriend(info.value))// 是密友则同时更新密友列表
				{
					this._friendModule.updateCloseList();
				}
			}
		}
		
		/**
		 * 修改好友类型(好友--密友)
		 */
		private function ModifyFriendTypeHandler(e:DataEvent):void
		{
			var record:SFriendRecord = e.data as SFriendRecord;
			var fromType:int;
			var toType:int;
			if(record.friendType == EFriendType._EFriendTypeNormal)// 设为密友
			{
				record.friendType = EFriendType._EFriendtypeIntimate;
				cache.friend.addCloseFriend(record);
				fromType = EFriendType._EFriendTypeNormal;
				toType = EFriendType._EFriendtypeIntimate;
			}
			else// 移除密友
			{
				record.friendType = EFriendType._EFriendTypeNormal;
				cache.friend.removeCloseFriend(record.recordId);
				fromType = EFriendType._EFriendtypeIntimate;
				toType = EFriendType._EFriendTypeNormal;
			}
			// 更新显示列表
			this._friendModule.updateCurrList();
			this._friendModule.updateCloseList();
			
			this._friendModule.updateRoleNum(0);
			this._friendModule.updatePosition(1);
			
			this._friendProxy.changeFriendType(record.recordId,fromType,toType);
		}
		
		/**
		 * 上线获取所有列表数据 
		 * @param data
		 */		
		private function getAllFriendRecordsHandler(data:Object):void
		{
			var recordList:Array = data as Array;
			if(recordList != null)
			{
				for each(var record:SFriendRecord in recordList)
				{
					cache.friend.addRecord(record);
				}
			}
		}
		
		/**
		 * 添加最近联系人 
		 */		
		private function addToRecentHandler(data:Object):void
		{
			var player:SMiniPlayer = (data as Array)[0];
			if(player)
			{
				cache.friend.addToRecent(player);
			}
		}
	}
}