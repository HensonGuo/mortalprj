/**
 * @heartspeak
 * 2014-3-21 
 */   	

package mortal.game.view.chat.chatPrivate
{
	import com.gengine.utils.HTMLUtil;
	
	import mortal.common.global.GlobalStyle;

	public class ChatWindowMsg
	{
		public var windowUid:String;//唯一标示
		public var unReadMsgNum:int;//未读数量
		public var name:String;//窗体名字
		
		public function getHtml():String
		{
			if(unReadMsgNum == 0)
			{
				return name;
			}
			else
			{
				return name + HTMLUtil.addColor("(" + unReadMsgNum + ")",GlobalStyle.colorLv);
			}
		}
		
		public function ChatWindowMsg()
		{
		}
	}
}