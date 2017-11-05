package mortal.game.view.chat.chatPrivate
{
	import Message.Game.SChatMsg;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GImageBitmap;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.common.tools.DateParser;
	import mortal.component.gconst.FilterConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.AvatarUtil;
	import mortal.game.view.chat.chatPanel.ChatItem;
	import mortal.game.view.common.UIFactory;
	
	public class ChatTimeItem extends Sprite
	{
		//头像
		private var _headImage:GImageBitmap;
		//名字 + 时间
		private var _textFieldTime:TextField;
		//背景
		private var _talkBg:ScaleBitmap;
		//聊天内容
		private var _chatItem:ChatItem;
		
		public function ChatTimeItem(chatItem:ChatItem,chatData:ChatData)
		{
			super();
			_chatItem = chatItem;
			init(chatItem,chatData);
		}
		
		private function init(chatItem:ChatItem,chatData:ChatData):void
		{
			//日期时间 头像以及是否在左边显示
			var date:Date = chatData.date;
			var name:String = chatData.fromMiniPlayer.name;
			var headUrl:String = AvatarUtil.getPlayerAvatarUrl(chatData.fromMiniPlayer.camp,chatData.fromMiniPlayer.sex,AvatarUtil.Small);
			var isRight:Boolean = chatData.isSelfMsg();
			
			//计算总高度
			var bgHeight:Number = chatItem.height + 6;
			var totalHeight:Number = bgHeight + 20;
			var headImageX:Number = 5;
			var headImageY:Number = totalHeight - 38;
			var bgX:Number = 53;
			var bgY:Number = 0;
			var bgWidth:Number = chatItem.width + 30;
			if(bgWidth < 55)
			{
				bgWidth = 55;
			}
			var nameX:Number = 66;
			var nameY:Number = bgHeight + 3;
			var chatItemX:Number = 71;
			var chatItemY:Number = 1;
			var talkBgName:String = ImagesConst.ChatOtherTalkBg;
			if(isRight)
			{
				bgX = 293 - bgWidth;
				headImageX = 293;
				nameX = 224;
				chatItemX = bgX + 10;
				talkBgName = ImagesConst.ChatSelfTalkBg;
			}
			
			UIFactory.gBitmap("FriendHeadBg",headImageX - 2,headImageY - 2,this);
			_headImage = UIFactory.gImageBitmap(headUrl,headImageX,headImageY,this);
			
			var _textFieldTime:TextField = new TextField();
			_textFieldTime.height = 22;
			_textFieldTime.autoSize = TextFieldAutoSize.LEFT;
			_textFieldTime.selectable = false;
			_textFieldTime.filters = [FilterConst.glowFilter];
			_textFieldTime.defaultTextFormat = new GTextFormat(FontUtil.songtiName);
			var nameStr:String = HTMLUtil.addColor(DateParser.parse(date,"hh:mm:ss"),GlobalStyle.colorHui);
			if(!isRight)
			{
				nameStr = HTMLUtil.addColor(name,GlobalStyle.colorHuang) + "&nbsp;" + nameStr;
			}
			_textFieldTime.htmlText = nameStr;
			_textFieldTime.y = nameY;
			_textFieldTime.x = nameX;
			this.addChild(_textFieldTime);
			
			_talkBg = UIFactory.bg(bgX,bgY,bgWidth,bgHeight,this,talkBgName);
			
			chatItem.y = chatItemY;
			chatItem.x = chatItemX;
			this.addChild(chatItem);
		}
		
		override public function get height():Number
		{
			return 26 + _chatItem.height;
		}
		
		public function dispose():void
		{
			_chatItem.dispose();
		}
	}
}