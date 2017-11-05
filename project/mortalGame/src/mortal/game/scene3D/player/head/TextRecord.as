package mortal.game.scene3D.player.head
{
	import Message.Game.SChatMsg;
	
	import com.gengine.core.IDispose;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.Sprite;
	
	import mortal.game.view.chat.chatPanel.ChatItem;
	import mortal.game.view.chat.chatViewData.ChatAnalysisType;
	import mortal.game.view.chat.chatViewData.ChatItemData;
	import mortal.game.view.chat.chatViewData.ChatMessageWorking;
	import mortal.game.view.chat.data.FaceAuthority;
	
	public class TextRecord extends Sprite implements IDispose
	{
		private var _lineHeight:Number;
		private var _lineWidth:Number;
		private var _content:String;//普通文本
		private var _chatMsg:SChatMsg;//普通的聊天文字
		private var _analysisType:int = 1;//解析方式，在ChatAnalysisType类定义
		private var _defaultColor:int = 0xFFFFFF;//默认文字颜色
		private var _aryPlayer:Array;//在解析传闻信息的时候需要用到
		private var _isFilter:Boolean = true;//是否屏蔽关键字
		private var _isShowTitle:Boolean = false;
		private var _faceAuthortiy:int = 1;
		
		private var _chatItem:ChatItem;
		private var _chatItemData:ChatItemData;
		
		public function TextRecord()
		{
			super();
		}
		
		public function get faceAuthortiy():int
		{
			return _faceAuthortiy;
		}

		public function set faceAuthortiy(value:int):void
		{
			_faceAuthortiy = value;
		}

		public function init(lineWidth:Number = 260,lineHeight:Number = 21):void
		{
			_lineWidth = lineWidth;
			_lineHeight = lineHeight;
		}
		
		public function draw():void
		{
			if(!_chatItem)
			{
				_chatItemData = ObjectPool.getObject(ChatItemData);
				_chatItem = new ChatItem();
				this.addChild(_chatItem);
			}
			_chatItem.lineWidth = _lineWidth;
			_chatItem.lineHeight = _lineHeight;
			switch(_analysisType)
			{
				case ChatAnalysisType.AnalysisTypeFace:
					_chatItemData.cellVector = ChatMessageWorking.getCellDataByContent(_content,_defaultColor,false,12,_faceAuthortiy);
					_chatItem.groupVector = _chatItemData.getContentElement();
					break;
				case ChatAnalysisType.AnalysisTypeChat:
					_chatItemData.cellVector = ChatMessageWorking.getCellDataByPlayerInfo(_chatMsg.fromPlayer);
					_chatItemData.cellVector = _chatItemData.cellVector.concat(ChatMessageWorking.getCellDatas(_chatMsg.content,_chatMsg.items,_chatMsg.pets,-1,12,FaceAuthority.getMiniPlayerAuthority(_chatMsg.fromPlayer)));
					_chatItem.groupVector = _chatItemData.getAllElements();
					break;
				case ChatAnalysisType.AnalysisTypeHtml:
					_chatItemData.cellVector = ChatMessageWorking.getCellDatasFilterHtml(_content);
					_chatItem.groupVector = _chatItemData.getContentElement();
					break;
				case ChatAnalysisType.AnalysisTypeRumor:
					_chatItemData.cellVector = ChatMessageWorking.getCellDatasByAnalyzeRumor(_content,_aryPlayer?_aryPlayer:new Array());
					_chatItem.groupVector = _chatItemData.getContentElement();
					break;
			}
			_chatItemData.dispose();
		}
		
		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			_content = value;
		}

		public function get analysisType():int
		{
			return _analysisType;
		}

		public function set analysisType(value:int):void
		{
			_analysisType = value;
		}

		public function get defaultColor():int
		{
			return _defaultColor;
		}

		public function set defaultColor(value:int):void
		{
			_defaultColor = value;
		}

		public function get aryPlayer():Array
		{
			return _aryPlayer;
		}

		public function set aryPlayer(value:Array):void
		{
			_aryPlayer = value;
		}

		public function get chatMsg():SChatMsg
		{
			return _chatMsg;
		}

		public function set chatMsg(value:SChatMsg):void
		{
			_chatMsg = value;
		}

		public function get isFilter():Boolean
		{
			return _isFilter;
		}

		public function set isFilter(value:Boolean):void
		{
			_isFilter = value;
		}

		public function get isShowTitle():Boolean
		{
			return _isShowTitle;
		}

		public function set isShowTitle(value:Boolean):void
		{
			_isShowTitle = value;
		}

		public function get lineHeight():Number
		{
			return _lineHeight;
		}

		public function set lineHeight(value:Number):void
		{
			_lineHeight = value;
		}

		public function get lineWidth():Number
		{
			return _lineWidth;
		}

		public function set lineWidth(value:Number):void
		{
			_lineWidth = value;
		}

		override public function get height():Number
		{
			if(_chatItem)
			{
				return _chatItem.height;
			}
			return 0;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			_lineHeight = 260;
			_lineWidth = 21;
			_content = null;
			_chatMsg = null;
			_analysisType = 1;
			_defaultColor = 0xffffff;
			_aryPlayer = null;
			_isFilter = true;
			_isShowTitle = false;
			ObjectPool.disposeObject(this);
		}
	}
}