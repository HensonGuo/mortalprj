package chat.event
{
	import chat.textData.ChatData;
	
	import flash.events.Event;
	
	public class ChatMenuEvent extends Event
	{
		/**
		 * 禁言 
		 */		
		public static const ChatForbid:String = "chatForbit"; 
		/**
		 * 解除禁言 
		 */		
		public static const ChatUnForbid:String = "chatUnForbit";
		/**
		 * 踢人 
		 */		
		public static const ChatKickout:String = "ChatKickout";
		/**
		 * 封号
		 */		
		public static const ChatLock:String = "ChatLock";
		
		/**
		 * 解封封号
		 */		
		public static const UnChatLock:String = "UnChatLock";
		
		private var _chatData:ChatData; 
		
		public function ChatMenuEvent(type:String,chatDataParam:ChatData, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_chatData = chatDataParam;
			super(type, bubbles, cancelable);
		}

		public function get chatData():ChatData
		{
			return _chatData;
		}

		public function set chatData(value:ChatData):void
		{
			_chatData = value;
		}

	}
}