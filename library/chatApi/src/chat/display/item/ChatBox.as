/**
 * @date 2011-3-14 上午11:09:29
 * @author  hexiaoming
 * 
 */ 
package chat.display.item
{
	import chat.ChatMessageWorking;
	import chat.textData.ChatData;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	public class ChatBox extends GBox
	{
		private var _itemVector:Vector.<ChatNotes>;
		private var _maxItem:int;
		private var _lastChatNotes:ChatNotes = null;
		private var _defaultChatWidth:Number = 250;
		/**
		 * 聊天Box
		 * @param maxItem 最大消息条目数量
		 * 
		 */		
		public function ChatBox(maxItem:int = 30)
		{
			super();
			_maxItem = maxItem;
			_itemVector = new Vector.<ChatNotes>();
			this.mouseEnabled = false;
			super.direction = GBoxDirection.VERTICAL;
			super.verticalGap = 0;
		}
		
		/**
		 * 设置宽度 
		 * @param value
		 * 
		 */		
		public function set chatWidth(value:Number):void
		{
			_defaultChatWidth = value;
		}
		
		public function get chatWidth():Number
		{
			return _defaultChatWidth;
		}
		
		/**
		 * 通过数据添加一条记录 
		 * 
		 */		
		public function addChatNotesByData(chatData:ChatData,lineHeigh:Number = 21):void
		{
			var chatNotes:ChatNotes = ChatMessageWorking.getChatNotes(chatData,_defaultChatWidth,lineHeigh);
			addChatNotes(chatNotes);
		}
		
		public function addChatNotes(chatNotes:ChatNotes):void
		{
//			if(_lastChatNotes)
//			{
//				chatNotes.y = _lastChatNotes.col * _lastChatNotes.lineHeight - _lastChatNotes.height;
//			}
			this.addChild(chatNotes);
			this.validateNow();
			this.updateDisplayList();
			_itemVector.push(chatNotes);
			if(_itemVector.length > _maxItem)
			{
				var chatNotes:ChatNotes = _itemVector.shift();
				this.removeChild(chatNotes);
				chatNotes.dispose();
			}
			_lastChatNotes = chatNotes;
			this.validateNow();
			this.updateDisplayList();
		}
		
		public function get currentLength():int
		{
			return _itemVector.length;
		}
		
		public function isMaxLength():Boolean
		{
			return _itemVector.length == _maxItem;
		}
		
		public function getChatNotesAtIndex(index:int):ChatNotes
		{
			return _itemVector[index];
		}
		
		override public function get height():Number
		{
			var h:Number = 0;
			var index:int = 0;
			var length:int = numChildren;
			var item:DisplayObject;
			var i:int;
			while(index < length)
			{
				item = getChildAt(index) as DisplayObject;
				h += item.height;
				index++;
			}
			return h + verticalGap * (_itemVector.length - 1) + 5;
		}
		
		public function reset():void
		{
			_itemVector = new Vector.<ChatNotes>();
			for(var i:int = this.numChildren - 1;i>=0;i--)
			{
				this.removeChildAt(i);
			}
		}
	}
}