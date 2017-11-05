package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IBag_destroy;
	import Message.Game.AMI_IBag_get;
	import Message.Game.AMI_IBag_open;
	import Message.Game.AMI_IBag_openTime;
	import Message.Game.AMI_IBag_sell;
	import Message.Game.AMI_IBag_split;
	import Message.Game.AMI_IBag_tidy;
	import Message.Game.AMI_IBag_use;
	import Message.Game.AMI_IFriend_addToBlackList;
	import Message.Game.AMI_IFriend_apply;
	import Message.Game.AMI_IFriend_changeFriendType;
	import Message.Game.AMI_IFriend_changeRemark;
	import Message.Game.AMI_IFriend_getFriendList;
	import Message.Game.AMI_IFriend_getOneKeyMakeFriendsInfo;
	import Message.Game.AMI_IFriend_moveIntoList;
	import Message.Game.AMI_IFriend_oneKeyMakeFriends;
	import Message.Game.AMI_IFriend_removeAll;
	import Message.Game.AMI_IFriend_reply;
	import Message.Game.SFriendRecord;
	import Message.Public.EPlayerItemPosType;
	import Message.Public.SErrorMsg;
	
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import frEngine.loaders.resource.info.ABCInfo;
	
	import mortal.common.error.ErrorCode;
	import mortal.common.sound.SoundManager;
	import mortal.common.sound.SoundTypeConst;
	import mortal.game.cache.Cache;
	import mortal.game.cache.FriendCache;
	import mortal.game.cache.packCache.BackPackCache;
	import mortal.game.cache.packCache.PackPosTypeCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.rmi.GameRMI;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;

	public class FriendProxy extends Proxy
	{
		private var _friendCache:FriendCache;
		
		private var _replyId:Array;
		
		public function FriendProxy()
		{
			super();
			init();
		}
		
		private function init():void
		{
			this._friendCache = this.cache.friend;
		}
		
		/**
		 * 申请好友 
		 * @param roleName 被申请方角色名
		 */		
		public function apply(roleName:String):void
		{
			rmi.iFriendPrx.apply_async(new AMI_IFriend_apply(applySucc,applyFail), roleName);
		}
		
		private function applySucc(e:AMI_IFriend_apply):void
		{
			MsgManager.showRollTipsMsg("好友申请已发出");
		}
		
		private function applyFail(e:Exception):void
		{
			Log.debug(e.code,ErrorCode.getErrorStringByCode(e.code),e.message);
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
		}
		
		/**
		 * 回复好友申请 
		 * @param ids 申请方角色ID数组
		 * @param result 对申请方的回复  1--同意  2--拒绝  3--申请方好友人数达到上限  4--被申请方好友人数达到上限
		 * @param type 申请类型(暂不用)
 		 */
		public function reply(ids:Array, result:int, type:int):void
		{
			this._replyId = ids;
			rmi.iFriendPrx.reply_async(new AMI_IFriend_reply(replySuccess,replyFail), ids, result, type);
		}
		
		private function replySuccess(e:AMI_IFriend_reply):void
		{
			var data:Object = {};
			data.result = 0;
			data.ids = this._replyId;
			NetDispatcher.dispatchCmd(ServerCommand.BatAddFriends, data);
		}
		
		private function replyFail(e:Exception):void
		{
			var data:Object = {};
			data.result = 1;
			data.ids = this._replyId;
			Log.debug(e.code,ErrorCode.getErrorStringByCode(e.code),e.message);
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
			NetDispatcher.dispatchCmd(ServerCommand.BatAddFriends, data);
		}
		
		/**
		 * 批量删除好友 
		 * @param flag 好友所在列表
		 * @param values 好友记录ID集合
		 */		
		public function removeAll(flag:int, values:Array = null):void
		{
			if(values == null)
			{
				values = [];
			}
			rmi.iFriendPrx.removeAll_async(new AMI_IFriend_removeAll(), values, flag);
		}
		
		/**
		 * 好友表间移动 
		 * @param recordId 好友记录ID
		 * @param fromList 记录当前所在列表
		 * @param toList 将要移动到的列表
		 */		
		public function moveIntoList(recordId:Number, fromList:int, toList:int):void
		{
			rmi.iFriendPrx.moveIntoList_async(new AMI_IFriend_moveIntoList(), recordId, fromList, toList);
		}
		
		/**
		 * 修改好友备注 
		 * @param recordId 记录ID
		 * @param flag 记录所在列表
		 * @param remark 新备注
		 */		
		public function changeRemark(recordId:Number, flag:int, remark:String):void
		{
			rmi.iFriendPrx.changeRemark_async(new AMI_IFriend_changeRemark(), recordId, flag, remark);
		}
		
		/**
		 * 获取好友列表
		 * @param flag 请求数据的列表
		 */		
		public function getFriendList(flag:int):void
		{
			rmi.iFriendPrx.getFriendList_async(new AMI_IFriend_getFriendList(getFriendsSuccess, getFriendsFail), flag);
		}
		
		private function getFriendsSuccess(e:AMI_IFriend_getFriendList, friendRecords:Array):void
		{
			NetDispatcher.dispatchCmd(ServerCommand.GetFriendList, friendRecords);
		}
		
		private function getFriendsFail(e:Exception):void
		{
			Log.debug("获取好友列表数据失败");
			NetDispatcher.dispatchCmd(ServerCommand.GetFriendList, []);
		}
			
		/**
		 * 将指定玩家拉到黑名单
		 * @param roleId 玩家角色ID
		 */		
		public function addToBlackList(roleId:int):void
		{
			rmi.iFriendPrx.addToBlackList_async(new AMI_IFriend_addToBlackList(), roleId);
		}
		
		/**
		 * 得到一键征友信息
		 */		
		public function getOneKeyMakeFriendsInfo():void
		{
			rmi.iFriendPrx.getOneKeyMakeFriendsInfo_async(new AMI_IFriend_getOneKeyMakeFriendsInfo(getSuccess));
		}
		
		private function getSuccess(e:AMI_IFriend_getOneKeyMakeFriendsInfo, friendsInfo:Array):void
		{
			NetDispatcher.dispatchCmd(ServerCommand.GetOneKeyMakeFriendsInfo, friendsInfo);
		}
		
		/**
		 * 一键征友
		 */		
		public function oneKeyMakeFriends(playerIds:Array):void
		{
			rmi.iFriendPrx.oneKeyMakeFriends_async(new AMI_IFriend_oneKeyMakeFriends(), playerIds);
		}
		
		/**
		 * 修改好友类型(只能是好友和密友之间互相修改)
		 * @param recordId 记录ID
		 * @param fromType 原始类型
		 * @param toType 修改后的类型
		 */		
		public function changeFriendType(recordId:Number, fromType:int, toType:int):void
		{
			rmi.iFriendPrx.changeFriendType_async(new AMI_IFriend_changeFriendType(), recordId, fromType, toType);
		}
		
	}
}