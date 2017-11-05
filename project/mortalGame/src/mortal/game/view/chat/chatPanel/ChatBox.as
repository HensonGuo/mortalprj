/**
 * @date 2011-3-14 上午11:09:29
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.chatPanel
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	
	import flash.display.DisplayObject;
	import flash.text.TextField;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	
	public class ChatBox extends GBox
	{
		private var _itemVector:Vector.<ChatNotes>;
		private var _maxItem:int;
		private var _lastChatNotes:ChatNotes = null;
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
			var i:int = 0;
			for(i = 0;i < _itemVector.length;i++ )
			{
				this.removeChild(_itemVector[i]);
				_itemVector[i].dispose();
			}
			_itemVector = new Vector.<ChatNotes>();
		}
	}
}