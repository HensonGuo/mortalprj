package chat.textData
{
	public class ChatData
	{
		public var content:String;
		public var playerName:String;
		public var playerId:int;
		public var serverId:int;
		public function ChatData($content:String,$playerName:String,$playerId:int,$serverId:int)
		{
			content = $content;
			playerName = $playerName;
			playerId = $playerId;
			serverId = $serverId;
		}
	}
}