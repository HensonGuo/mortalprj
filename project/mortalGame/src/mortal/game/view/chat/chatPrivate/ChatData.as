package mortal.game.view.chat.chatPrivate
{
	import Message.Game.SChatMsg;
	import Message.Public.SEntityId;
	import Message.Public.SMiniPlayer;
	
	import mortal.game.cache.Cache;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.view.chat.data.FaceAuthority;

	/**
	 * 私聊数据 
	 * @author heartspeak
	 * 
	 */	
	public class ChatData
	{
		public var chatFromPlayerName:String;
		
		public var fromMiniPlayer:SMiniPlayer;
		
		public var chatWindowName:String;
		
		public var chatWindowEntityId:SEntityId;
		
		public var crossFlag:Boolean = false;
		
		public var date:Date;
		
		public var content:String;
		
		public var sChatMsg:SChatMsg;
		
		public var chatColor:int;
		
		public var faceAuthority:int = 1;
		
		public function ChatData()
		{
		}
		
		/**
		 * 从服务器发的聊天消息里面拷贝过来 
		 * @param sChatMsg
		 * 
		 */		
		public function copyFromChatMsg(sChatMsg:SChatMsg):void
		{
			this.chatFromPlayerName = sChatMsg.fromPlayer.name;
			this.fromMiniPlayer = sChatMsg.fromPlayer;
			this.sChatMsg = sChatMsg;
			this.date = sChatMsg.chatDt;
			this.content = sChatMsg.content;
			this.chatColor = sChatMsg.font;
			this.sChatMsg = sChatMsg;
			this.faceAuthority = FaceAuthority.getMiniPlayerAuthority(sChatMsg.fromPlayer);
			if( !EntityUtil.equal(Cache.instance.role.entityInfo.entityId,sChatMsg.fromPlayer.entityId))
			{
				this.chatWindowName = sChatMsg.fromPlayer.name;
				this.chatWindowEntityId = sChatMsg.fromPlayer.entityId;
			}
			else
			{
				this.chatWindowName = sChatMsg.toPlayer;
				this.chatWindowEntityId = sChatMsg.toEntityId;
			}
//			this.crossFlag = sChatMsg.crossFlag;
		}
		
		public function isSelfMsg():Boolean
		{
			return EntityUtil.equal(Cache.instance.role.entityInfo.entityId,fromMiniPlayer.entityId);
		}
	}
}