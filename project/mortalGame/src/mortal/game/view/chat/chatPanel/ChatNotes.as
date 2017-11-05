/**
 * @date 2011-3-30 下午05:38:52
 * @author  hexiaoming
 * 
 */
package mortal.game.view.chat.chatPanel
{
	import com.gengine.core.IDispose;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.engine.ContentElement;
	
	import mortal.game.view.chat.chatViewData.ChatItemData;
	
	public class ChatNotes extends Sprite implements IDispose
	{
		private var _itemData:ChatItemData;
		private var _width:int;
		private var _lineHeight:Number;
		private var _groupVector:Vector.<ContentElement> = new Vector.<ContentElement>();
		
		private var _itemTitleBg:Bitmap;
		private var _chatItem:ChatItem;
		public function ChatNotes()
		{

		}

		public function init(chatItemData:ChatItemData,width:int = 260,lineHeight:Number = 21):void
		{
			_width = width;
			_lineHeight = lineHeight;
			_itemData = chatItemData;
			this.mouseEnabled = false;
			createChildren();
		}
		
		/**
		 * 显示
		 */
		private function createChildren():void
		{
//			_itemTitleBg = GlobalClass.getBitmap("Chat_Channel_Bg");
//			_itemTitleBg.y = 0;
//			_itemTitleBg.x = 6;
//			this.addChild(_itemTitleBg);
			
			_chatItem = ObjectPool.getObject(ChatItem);
			_chatItem.init(_itemData.getAllElements(),_width,_lineHeight);
			this.addChild(_chatItem);
			var firstH:Number = _chatItem.getFirstLineHeight();
//			if(firstH < 30)
//			{
//				_itemTitleBg.y = (_chatItem.getFirstLineHeight() - 16)/2;
//			}
//			else
//			{
//				_itemTitleBg.y = 29;
//			}
		}
		
		override public function get height():Number
		{
			return _chatItem.height;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			_itemData.dispose();
			_itemData = null;
			_width = 260;
			_lineHeight = 21;
			_groupVector = new Vector.<ContentElement>();
			_chatItem.dispose();
			_chatItem = null;
			for(var i:int = this.numChildren - 1; i >= 0; i--)
			{
				this.removeChildAt(i);
			}
			x = 0;
			y = 0;
			ObjectPool.disposeObject(this);
		}
	}
}