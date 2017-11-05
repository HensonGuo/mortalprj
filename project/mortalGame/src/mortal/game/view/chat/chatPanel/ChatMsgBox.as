/**
 * @heartspeak
 * 2014-4-17 
 */   	

package mortal.game.view.chat.chatPanel
{
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	
	import flash.display.DisplayObject;
	
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.manager.msgTip.MsgTypeImpl;
	import mortal.game.view.common.UIFactory;
	
	public class ChatMsgBox extends GBox
	{
		private const maxNum:int = 50;
		private var _hisVector:Vector.<HistoryMsg>;
		
		public function ChatMsgBox()
		{
			super();
			_hisVector = new Vector.<HistoryMsg>();
			this.mouseEnabled = false;
			super.direction = GBoxDirection.VERTICAL;
			super.verticalGap = 2;
		}
		
		/**
		 * 添加一条历史记录消息 
		 * @param msg
		 * 
		 */
		public function addMsg(msg:String,type:MsgTypeImpl):void
		{
			var historyMsg:HistoryMsg = UIFactory.getUICompoment(HistoryMsg);
			historyMsg.updateValue(msg,type);
			
			this.addChild(historyMsg);
			this.validateNow();
			this.updateDisplayList();
			_hisVector.push(historyMsg);
			if(_hisVector.length > maxNum)
			{
				historyMsg = _hisVector.shift();
				this.removeChild(historyMsg);
				historyMsg.dispose();
			}
			this.validateNow();
			this.updateDisplayList();
		}
		
		public function isMaxLength():Boolean
		{
			return _hisVector.length == maxNum;
		}
		
		public function getMsgAtIndex(index:int):HistoryMsg
		{
			return _hisVector[index];
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
			return h + verticalGap * (_hisVector.length - 1) + 5;
		}
		
		/**
		 * 清理 
		 * 
		 */		
		public function clear():void
		{
			var i:int = 0;
			var length:int = this.numChildren;
			for(i = length - 1;i>=0;i--)
			{
				this.removeChildAt(i);
			}
			for(i = 0;i < _hisVector.length;i++ )
			{
				_hisVector[i].dispose();
			}
			_hisVector = new Vector.<HistoryMsg>();
		}
		
	}
}