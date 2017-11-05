package mortal.game.manager.msgTip
{
	import Message.Public.SMiniPlayer;
	
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.Sprite;
	
	import mortal.game.mvc.GameController;
	import mortal.game.view.chat.ChatModule;
	
	/**
	 * 
	 * @author Administrator
	 */
	public class MsgSpeakerImpl extends Sprite
	{
		private var _noticesArr:Array = [];
		private var _itemShowing:Boolean = false;
		private var _infoArr:Array = [];
		
		/**
		 * 
		 */
		public function MsgSpeakerImpl()
		{
			super();
			this.mouseEnabled = false;
//			this.mouseChildren = false;
		}
		
		/**
		 * 淡出完成 
		 * @param item
		 * 
		 */
		private function onNoticeHide(item:SpeakerItem):void
		{
			_noticesArr.shift();
			_infoArr.shift();
			removeChild(item);
			item.dispose();
			ObjectPool.disposeObject(item,SpeakerItem);
			_itemShowing = false;
			
			if(_noticesArr.length > 0)
			{
				_itemShowing = true;
				var easeIn:Boolean = true;
				addChild(_noticesArr[0]);
				_noticesArr[0].init(_infoArr[0].miniPlayer,_infoArr[0].content,_infoArr[0].type);
				_noticesArr[0].updateData(onNoticeHide,easeIn);
				setPxy();
			}
		}
		
		/**
		 * 显示消息 
		 * @param data, type
		 * 
		 */
		public function showSpeakerNotice(miniPlayer:SMiniPlayer,content:String, type:MsgTypeImpl):void
		{
			var easeIn:Boolean;
			var speakerItem:SpeakerItem;
			
			/*if(_noticesArr.length > 0)
			{
				var lastItem:SpeakerItem;
				if(_noticesArr.length >= 3)
				{
					lastItem = _noticesArr.shift();
					removeChild(lastItem);
					lastItem.dispose();
					ObjectPool.disposeObject(lastItem, SpeakerItem);
				}
				lastItem = _noticesArr[_noticesArr.length - 1];
				lastItem.killInEase();
				easeIn = false;
			}
			else
			{
				easeIn = true;
			}*/
			
			speakerItem = ObjectPool.getObject(SpeakerItem);
			_noticesArr.push(speakerItem);
			_infoArr.push({miniPlayer:miniPlayer,content:content, type:type});
			if(!_itemShowing)
			{
				_itemShowing = true;
				easeIn = true;
				addChild(speakerItem);
//				updatePxy();
				speakerItem.init(miniPlayer,content, type);
				speakerItem.updateData(onNoticeHide,easeIn);
				setPxy();
			}
			
		}
		
		/**
		 * 设置xy坐标
		 */
		public function setPxy():void
		{
			var item:SpeakerItem = _noticesArr[0];
			if(item)
			{
				item.x = 0;
				item.y = (GameController.chat.view as ChatModule).y -  (GameController.chat.view as ChatModule).height - 90;//聊天窗口上方
			}
		}
		
	}
}