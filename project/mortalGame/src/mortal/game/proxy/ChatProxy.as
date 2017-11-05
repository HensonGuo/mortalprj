/**
 * @date 2011-3-14 下午06:40:22
 * @author  hexiaoming
 * 
 */ 
package mortal.game.proxy
{
	import Message.Game.AMI_IInter_chat;
	import Message.Game.SChatMsg;
	import Message.Public.SEntityId;
	import Message.Public.SMiniPlayer;
	
	import mortal.mvc.core.Proxy;
	
	public class ChatProxy extends Proxy
	{
		public function ChatProxy()
		{
			super();
		}
		
		public function SendMessage(chatType:int,content:String,textColor:int=0,playerItems:Array = null,petInfos:Array = null,chatTypeEx:Array = null):void
		{
			var sChatMsg:SChatMsg = new SChatMsg();
			sChatMsg.chatType = chatType;
//			sChatMsg.chatTypeEx = chatTypeEx;
			sChatMsg.content = content;
			sChatMsg.font = textColor;
			sChatMsg.toEntityId = new SEntityId();
			sChatMsg.chatDt = new Date();
			var miniPlayer:SMiniPlayer = new SMiniPlayer();
			miniPlayer.entityId = new SEntityId();
			sChatMsg.fromPlayer = miniPlayer;
			if(playerItems)
			{
				sChatMsg.items = playerItems;
			}
			if(petInfos)
			{
				sChatMsg.pets = petInfos;
			}
			rmi.iInterPrx.chat_async(new AMI_IInter_chat(),sChatMsg);
		}
		
		/**
		 * 发送聊天 
		 * @param sChatMsg
		 * 
		 */		
		public function SendMessageByStruct(sChatMsg:SChatMsg):void
		{
			rmi.iInterPrx.chat_async(new AMI_IInter_chat(),sChatMsg);
		}
	}
}