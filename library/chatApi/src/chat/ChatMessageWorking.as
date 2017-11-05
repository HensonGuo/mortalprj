/**
 * @date 2011-3-15 下午03:24:09
 * @author  hexiaoming
 * 
 * 
 */ 
package chat
{
	import chat.display.item.ChatNotes;
	import chat.textData.CellDataType;
	import chat.textData.ChatCellData;
	import chat.textData.ChatData;
	import chat.textData.ChatItemData;
	import chat.textData.ChatStyle;
	
	import com.gengine.utils.pools.ObjectPool;

	public class ChatMessageWorking
	{
		/**
		 * 获取玩家的cellData 
		 * @param playerName
		 * @param playerId
		 * @return 
		 * 
		 */		
		public static function getPlayerCellData(playerName:String,chatData:ChatData):Vector.<ChatCellData>
		{
			var cellVector:Vector.<ChatCellData>= new Vector.<ChatCellData>();
			var nameColor:uint = 0xf0ea3f;
			var nameCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
			nameCellData.init(CellDataType.PLAYER,"[" + playerName + "]");
			nameCellData.elementFormat = ChatStyle.getPlayerNameFormat(nameColor);
			nameCellData.data = chatData;
			cellVector.push(nameCellData);
			return cellVector;
		}
		
		/**
		 * 获取内容的cellData 
		 * @param content
		 * @return 
		 * 
		 */
		public static function getContentCellData(content:String):Vector.<ChatCellData>
		{
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			var chatCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
			chatCellData = ObjectPool.getObject(ChatCellData);
			chatCellData.init(CellDataType.GENERAL,content);
			chatCellData.elementFormat = ChatStyle.getContentFormat();
			vcChatCellData.push(chatCellData);
			return vcChatCellData;
		}
		
		/**
		 * 获取一条聊天记录 
		 * @param chatData
		 * @param lineWidth
		 * @param lineHeight
		 * 
		 */		
		public static function getChatNotes(chatData:ChatData,lineWidth:Number = 255,lineHeight:Number = 21):ChatNotes
		{
			var chatItemData:ChatItemData = ObjectPool.getObject(ChatItemData);
			var cellVector:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			cellVector = cellVector.concat(ChatMessageWorking.getPlayerCellData(chatData.playerName,chatData));
			cellVector = cellVector.concat(ChatMessageWorking.getContentCellData(": " + chatData.content));
			chatItemData.cellVector = cellVector;
			var chatNotes:ChatNotes = ObjectPool.getObject(ChatNotes);
			chatNotes.init(chatItemData,lineWidth,lineHeight);
			return chatNotes;
		}
	}
}