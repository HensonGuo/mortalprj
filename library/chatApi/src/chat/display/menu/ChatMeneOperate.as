package chat.display.menu
{
	import chat.event.ChatDispatcher;
	import chat.event.ChatMenuEvent;
	import chat.textData.ChatData;
	
	import fl.data.DataProvider;
	
	public class ChatMeneOperate
	{
		//所有操作列表
		public static const ChatForbid:String = 	"   禁    言";
		public static const ChatUnForbid:String = "   解除禁言";
		public static const ChatKickout:String = 	"   踢人下线";
		public static const ChatLock:String = 	"   封    号";
		public static const UnChatLock:String = 	"   解除封号";
		
		public static var playerProvider:DataProvider = new DataProvider([
			{label:ChatForbid,enabled:true,eventType:ChatMenuEvent.ChatForbid},
			{label:ChatUnForbid,enabled:true,eventType:ChatMenuEvent.ChatUnForbid},
			{label:ChatKickout,enabled:true,eventType:ChatMenuEvent.ChatKickout},
			{label:ChatLock,enabled:true,eventType:ChatMenuEvent.ChatLock},
			{label:UnChatLock,enabled:true,eventType:ChatMenuEvent.UnChatLock}
		]);
		
		/**
		 * 人物菜单数据 
		 * 
		 */		
		public static function getPlayerDataProvider():DataProvider
		{
			return playerProvider;
		}
		
			
		/**
		 * 对菜单进行操作 
		 * @return 
		 * 
		 */		
		public static function Opearte(opName:String,chatData:ChatData):void
		{
			
			ChatDispatcher.dispatchEvent( new ChatMenuEvent(opName,chatData));
//			var tipText:String = "";
//			switch(opName)
//			{
//				case ChatForbid:
//					ChatDispatcher.dispatchEvent( new ChatMenuEvent(ChatMenuEvent.ChatForbid,chatData));
//					break;
//				case ChatUnForbid:
//					ChatDispatcher.dispatchEvent( new ChatMenuEvent(ChatMenuEvent.ChatUnForbid,chatData));
//					break;
//				case ChatUnForbid:
//					ChatDispatcher.dispatchEvent( new ChatMenuEvent(ChatMenuEvent.ChatUnForbid,chatData));
//					break;
//				case ChatUnForbid:
//					ChatDispatcher.dispatchEvent( new ChatMenuEvent(ChatMenuEvent.ChatUnForbid,chatData));
//					break;
//				case ChatUnForbid:
//					ChatDispatcher.dispatchEvent( new ChatMenuEvent(ChatMenuEvent.ChatUnForbid,chatData));
//					break;
//				default:
//					break;
//			}
		}
	}
}