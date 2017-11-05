package chat.display.item
{
	import chat.ChatRes;
	import chat.event.ChatDispatcher;
	import chat.event.ChatPanelEvent;
	import chat.style.ScrollPaneStyle;
	import chat.textData.ChatData;
	
	import com.mui.containers.GHBox;
	import com.mui.controls.GScrollPane;
	
	import fl.controls.Label;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class ChatPanel extends Sprite
	{
		public var serverId:int;
		
		private var _maxItem:int = 30;
		private var _bg:Bitmap;
		private var _tfChatTitle:TextField;
		private var _chatBox:ChatBox;
		private var _scrollPane:GScrollPane;
		
		private var _chatWidth:Number = 280;
		private var _chatHeight:Number = 150;
		private var titleHeight:Number = 20;
		
		private var _closeText:Label;
		private var _clearText:Label;
		private var _lockText:Label;
		
		private var _titleBox:GHBox;
		
		private var _titleBoxY:Number = 0;
		private var _isLockScroll:Boolean = false;
		
		private const TxtLock:String = "锁屏";
		private const TxtUnLock:String = "解锁";
		
		
		public function ChatPanel(maxItem:int = 30)
		{
			super();
			_maxItem = maxItem;
			this.mouseEnabled = false;
			init();
		}
		
		/**
		 * 获取标题的textField 
		 * @return 
		 * 
		 */		
		public function get chatTitle():TextField
		{
			return _tfChatTitle;
		}
		
		/**
		 * 设置标题 
		 * @param text
		 * 
		 */		
		public function set titleText(text:String):void
		{
			_tfChatTitle.htmlText = text;
		}
		
		public function get chatBox():ChatBox
		{
			return _chatBox;
		}
		
		public function set chatBox(value:ChatBox):void
		{
			_chatBox = value;
		}
		
		/**
		 * 初始化 
		 * 
		 */
		private function init():void
		{
			_bg = ChatRes.getScaleBitmap(WindowCenterB,new Rectangle(10,10,21,23));
			_bg.y = 0;
			drawBg();
			this.addChild(_bg);
			
			var titleTextFormat:TextFormat = new TextFormat("宋体",12,0xf0ea3f);
			titleTextFormat.align = TextFormatAlign.CENTER;
			_tfChatTitle = new TextField();
			_tfChatTitle.defaultTextFormat = titleTextFormat;
			_tfChatTitle.text = "";
			_tfChatTitle.height = titleHeight;
			_tfChatTitle.width = _chatWidth > 150?150:_chatWidth;
			_tfChatTitle.selectable = false;
			_tfChatTitle.filters = [new GlowFilter(0x000000,1,2,2,10)];
			this.addChild(_tfChatTitle);
			
			_chatBox = new ChatBox(_maxItem);
			_chatBox.y = titleHeight;
			
			_scrollPane = new GScrollPane();
			_scrollPane.verticalScrollBarPos = GScrollPane.SCROLLBARPOSITIONLEFT;
			_scrollPane.width = _chatWidth;
			_scrollPane.y = titleHeight;
			_scrollPane.height = _chatHeight-titleHeight;
			new ScrollPaneStyle().setStyle(_scrollPane);
			_scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
			_scrollPane.verticalScrollPolicy = ScrollPolicy.ON;
			_scrollPane.source = _chatBox;
			_scrollPane.mouseEnabled = false;
			this.addChild(_scrollPane);
			_scrollPane.update();
			
			_titleBox = new GHBox();
			_titleBox.horizontalGap = 0;
			this.addChild(_titleBox);
			
			// 锁屏、解锁
			_lockText = new Label();
			_lockText.addEventListener(MouseEvent.CLICK, onLockHandler);
			_lockText.setStyle("textFormat",titleTextFormat);
			_lockText.text = TxtLock;
			_lockText.width = 30;
			_titleBoxY += 30;
			_lockText.mouseChildren = false;
			_lockText.mouseEnabled = true;
			_lockText.filters = [new GlowFilter(0x000000,1,2,2,10)];
			_titleBox.addChild(_lockText);
			
			_clearText = new Label();
			_clearText.addEventListener(MouseEvent.CLICK,onClearHandler);
			_clearText.setStyle("textFormat",titleTextFormat);
			_clearText.text = "清屏";
			_clearText.width = 30;
			_titleBoxY += 30;
			//			_clearText.x = _chatWidth - 90;
			_clearText.mouseChildren = false;
			_clearText.mouseEnabled = true;
			//			_clearText.buttonMode = true;
			//			_closeText.selectable = false;
			_clearText.filters = [new GlowFilter(0x000000,1,2,2,10)];
			_titleBox.addChild(_clearText);
			
			_closeText = new Label();
			_closeText.addEventListener(MouseEvent.CLICK,onCloseHandler);
			_closeText.setStyle("textFormat",titleTextFormat);
			_closeText.text = "关闭";
			_closeText.width = 30;
			_titleBoxY += 30;
			//			_closeText.x = _chatWidth - 50;
			_closeText.mouseChildren = false;
			_closeText.mouseEnabled = true;
			//			_closeText.buttonMode = true;
			//			_closeText.selectable = false;
			_closeText.filters = [new GlowFilter(0x000000,1,2,2,10)];
			_titleBox.addChild(_closeText);
			
			_titleBox.move(_chatWidth-_titleBox.width,0);
			
			
		}
		
		private function onLockHandler(e:MouseEvent):void
		{
			if(isLockScroll)
			{
				this.unLockScroll();
			}
			else
			{
				this.lockScroll();
			}
		}
		
		private function onCloseHandler( e:MouseEvent ):void
		{
			if( this.parent )
			{
				this.parent.removeChild(this);
				dispatchEvent( new ChatPanelEvent( ChatPanelEvent.CloseEvent ) );
			}
		}
		
		private function onClearHandler(e:MouseEvent):void
		{
			clear();
		}
		
		public function clear():void
		{
			if( _chatBox )
			{
				_chatBox.reset();
				_scrollPane.update();
			}
		}
		
		public function set chatWidth(value:Number):void
		{
			_chatWidth = value;
			_chatBox.chatWidth = _chatWidth - 16;
			_scrollPane.width = _chatWidth;
			_tfChatTitle.width = _chatWidth > 150?150:_chatWidth;
			
			//			_closeText.x = _chatWidth - 50;
			//			_clearText.x = _chatWidth - 90;
			_titleBox.move(_chatWidth-_titleBoxY,0);
			
			drawBg();
		}
		public function get chatWidth():Number
		{
			return _chatWidth;
		}
		public function get chatHeight():Number
		{
			return _chatHeight+titleHeight;
		}
		
		public function set chatHeight(value:Number):void
		{
			_chatHeight = value - titleHeight;
			_scrollPane.height = _chatHeight;
			drawBg();
		}
		
		public function setSize( w:Number,h:Number ):void
		{
			_chatWidth = w;
			_chatBox.chatWidth = w - 16;
			_scrollPane.width = _chatWidth;
			_tfChatTitle.width = _chatWidth > 150?150:_chatWidth;
			
			//			_closeText.x = _chatWidth - 50;
			//			_clearText.x = _chatWidth - 90;
			_titleBox.move(_chatWidth-_titleBoxY,0);
			
			_chatHeight = h-titleHeight;
			_scrollPane.height = _chatHeight;
			
			drawBg();
		}
		
		/**
		 * 设置背景 
		 * 
		 */		
		private function drawBg():void
		{
			_bg.width = _chatWidth;
			_bg.height = _chatHeight + titleHeight;
		}
		
		private function lockScroll():void
		{
			_lockText.text = TxtUnLock;
			isLockScroll = true;
		}
		
		private function unLockScroll():void
		{
			_lockText.text = TxtLock;
			isLockScroll = false;
		}
		
		/**
		 * 通过数据添加一条记录 
		 * 
		 */
		public function addChatNotesByData(chatData:ChatData,lineHeigh:Number = 21):void
		{
			var isAtMaxScrollPosition:Boolean = _scrollPane.verticalScrollPosition == _scrollPane.maxVerticalScrollPosition;
			var holdPosition:Number = _scrollPane.verticalScrollPosition;
			var isMaxLength:Boolean = false;
			var firstHeigth:Number = 0;
			isMaxLength = _chatBox.isMaxLength();
			if(isMaxLength)
			{
				firstHeigth = _chatBox.getChatNotesAtIndex(0).height;
				holdPosition -= firstHeigth;
			}
			
			_chatBox.addChatNotesByData(chatData,lineHeigh);
			
			_scrollPane.validateNow();
			_scrollPane.update();
			_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
			
			holdPosition = holdPosition >= 0?holdPosition:0;
			if(!_isLockScroll && isAtMaxScrollPosition)
			{
				_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
			}
			else
			{
				_scrollPane.verticalScrollPosition = holdPosition;
			}
		}
		
		/**
		 * 设置是否锁定滚动条
		 * @param value
		 * 
		 */		
		public function set isLockScroll(value:Boolean):void
		{
			_isLockScroll = value;
		}
		
		public function get isLockScroll():Boolean
		{
			return _isLockScroll;
		}
	}
}