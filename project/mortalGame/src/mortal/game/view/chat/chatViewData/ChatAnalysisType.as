package mortal.game.view.chat.chatViewData
{
	public class ChatAnalysisType
	{
		public function ChatAnalysisType()
		{
		}
		
		public static const AnalysisTypeFace:int = 1;//解析表情
		public static const AnalysisTypeHtml:int = 2;//解析Html、表情
		public static const AnalysisTypeRumor:int = 3;//解析传闻
		public static const AnalysisTypeChat:int = 4;//解析聊天 带人物信息 物品、宠物、表情
	}
}