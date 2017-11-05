package mortal.game.manager.msgTip
{
	import Message.Public.SMiniPlayer;
	
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.SWFInfo;
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TweenMax;
	import com.mui.controls.GImageBitmap;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.common.global.LoadSettings;
	import mortal.game.cache.Cache;
	import mortal.game.manager.msgTip.MsgTypeImpl;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.chat.ChatArea;
	import mortal.game.view.chat.chatPanel.ChatItem;
	import mortal.game.view.chat.chatViewData.ChatCellData;
	import mortal.game.view.chat.chatViewData.ChatItemData;
	import mortal.game.view.chat.chatViewData.ChatMessageWorking;
	import mortal.game.view.common.UIFactory;
	
	public class SpeakerItem extends Sprite
	{
		private var _maskSp:Sprite;
		private var _itemSprite:Sprite;
		private var _chatItem:ChatItem;
		private var _endFun:Function;
		private var _inTween:TweenMax;
		private var _outTween:TweenMax;
		private var _timerKey:uint;
		private var _delay:Number;
		private var _level:int;
		
		public function SpeakerItem()
		{
			super();
			_maskSp = new Sprite();
			_maskSp.graphics.beginFill(0x00FFFFFF,0.1);
			_maskSp.graphics.drawRect(0,0,300,102);
			_maskSp.graphics.endFill();
			_maskSp.y = -10;
			_maskSp.mouseChildren = false;
			_maskSp.mouseEnabled = false;
			this.addChild(_maskSp);
			
			_itemSprite = new Sprite();
			_itemSprite.x = 0;
			_itemSprite.mouseEnabled = false;
			_itemSprite.mask = _maskSp;
			this.addChild(_itemSprite);
			
			_bg = UIFactory.gImageBitmap(ImagesConst.ChatTrumpetBg,0,0,_itemSprite);
			
			mouseChildren = true;
			mouseEnabled = false;
		}
		
		/**
		 * 初始化大喇叭消息
		 */
		private var _bg:GImageBitmap;
//		private var _mc:MovieClip;
		public function init(miniPlayer:SMiniPlayer,content:String, type:MsgTypeImpl):void
		{
			_level = Cache.instance.role.entityInfo.level;
			_delay = type.delay;
			var _textColor:String = type.color;
			
			var chatItemData:ChatItemData = ObjectPool.getObject(ChatItemData);
			chatItemData.type = ChatMessageWorking.getChatTypeByAreaName(ChatArea.Speaker);
			var cellVector:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			var faceAuthority:int = 3;
//			if(playerMiniInfo.isVIP)
//			{
//				faceAuthority = 3;
//			}
//			else
//			{
//				faceAuthority = 1;
//			}
			cellVector = cellVector.concat(ChatMessageWorking.getPlayerCellData(miniPlayer));
			cellVector = cellVector.concat(ChatMessageWorking.getCellDataByContent(content,parseInt(_textColor),true,12,faceAuthority));
			chatItemData.cellVector = cellVector;
			_chatItem = ObjectPool.getObject(ChatItem);
			_chatItem.init(chatItemData.getContentElement(),240);
			_chatItem.x = 15;
			_chatItem.y = 10;
			_itemSprite.addChild(_chatItem);
//			if(_level>LoadSettings.Effectslevel)
//			{
//				if(_mc==null)
//				{
//					LoaderManager.instance.load(ImagesConst.ChatTrumpetBg,onLoaded);
//				}
//				else
//				{
//					_itemSprite.addChildAt(_mc,0);
//					_mc.play();
//				}
//			}
		}
		
//		private function onLoaded(info:SWFInfo):void
//		{
//			_mc = info.clip;
//			_mc.x = -10;
//			_mc.y = 0;
//			_itemSprite.addChildAt(_mc,0);
//			_mc.play();
//			_mc.mouseEnabled = false;
//			_mc.mouseChildren = false;
//		}
		
		/**
		 * 淡入缓动播放完 
		 * 
		 */
		private function onInEnd():void
		{
			_timerKey = setTimeout(timerOutHandler,_delay);
		}
		
		/**
		 * 淡出缓动播放完 
		 * 
		 */
		private function onOutEnd():void
		{
			if(_endFun != null)
			{
				_endFun.call(this,this);
			}
		}
		
		/**
		 * 停留时间到 
		 * 
		 */
		private function timerOutHandler():void
		{
			_outTween = TweenMax.to(_itemSprite,0.1,{alpha:0,onComplete:onOutEnd});
		}
		
		public function updateData(endFun:Function, easeIn:Boolean=true):void
		{
			_endFun = endFun;
			if(easeIn)
			{
				_itemSprite.alpha = 0;
				_itemSprite.y = 20;
				_inTween = TweenMax.to(_itemSprite,0.1,{alpha:1,y:0,onComplete:onInEnd});
			}
			else
			{
				_itemSprite.alpha = 1;
				_itemSprite.y = 0;
				onInEnd();
			}
		}
		
		
		/**
		 * 停止淡入缓动 
		 * 
		 */
		public function killInEase():void
		{
			if(_inTween && _inTween.active)
			{
				_itemSprite.y = 0;
				_itemSprite.alpha = 1;
				_inTween.kill();
				onInEnd();
			}
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			_endFun = null;
			clearTimeout(_timerKey);
			
			if(_inTween && _inTween.active)
			{
				_inTween.kill();
			}
			else if(_outTween && _outTween.active)
			{
				_outTween.kill();
			}
			if(_itemSprite)
			{
				_itemSprite.alpha = 1;
				_itemSprite.y = 0;
				if(_chatItem && _chatItem.parent)
				{
					_itemSprite.removeChild(_chatItem);
				}
//				if(_mc)
//				{
//					if(_mc.parent)_itemSprite.removeChild(_mc);
//					_mc.stop();
//				}
				
//				_bg.dispose();
			}
		}
		
		override public function get height():Number
		{
			return _itemSprite.height;
		}
		
		override public function get width():Number
		{
			return _itemSprite.width;
		}
	}
}