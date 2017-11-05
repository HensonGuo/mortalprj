/**
 * @date 2011-3-30 下午06:29:27
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.chatPrivate
{
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import mortal.game.view.chat.chatPanel.ChatItem;
	
	public class ChatPrivatePanel extends GBox
	{		
		private var _spMessageVector:Vector.<ChatTimeItem>;
		private var _maxItem:int;

		/**
		 * 聊天Box
		 * @param maxItem 最大消息条目数量
		 * @param isShowMsgHead 是否展示消息头部
		 * 
		 */
		public function ChatPrivatePanel(maxItem:int = 30)
		{
			super();
			_maxItem = maxItem;
			_spMessageVector = new Vector.<ChatTimeItem>();
			super.direction = GBoxDirection.VERTICAL;
			super.verticalGap = 6;
		}
		
		public function addChatItem(chatItem:ChatItem,chatData:ChatData):void
		{
			var spMessage:ChatTimeItem = new ChatTimeItem(chatItem,chatData);
			this.addChild(spMessage);
			_spMessageVector.push(spMessage);
			
			if(_spMessageVector.length > _maxItem)
			{
				spMessage = _spMessageVector.shift();
				this.removeChild(spMessage);
				spMessage.dispose();
			}
			
			validateNow();
		}
		
		override public function validateNow():void
		{
			updateDisplayList();
			super.validateNow();
		}
		
		override public function get height():Number
		{
			var h:Number = 0;
			var index:int = 0;
			var length:int = _spMessageVector.length;
			var item:DisplayObject;
			var i:int;
			while(index < length)
			{
				var spMessage:ChatTimeItem = _spMessageVector[index];
				h += spMessage.height;
				index++;
			}
			return h + 10 + verticalGap * (_spMessageVector.length - 1);
		}
		
		public function reset():void
		{
			_spMessageVector = new Vector.<ChatTimeItem>();
			for(var i:int = this.numChildren - 1;i>=0;i--)
			{
				this.removeChildAt(i);
			}
		}
	}
}