/**
 * @date 2011-3-22 下午06:40:05
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.chatPrivate
{
	import Message.Public.SEntityId;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.global.Global;
	import com.gengine.keyBoard.KeyCode;
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GImageBitmap;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.setTimeout;
	
	import mortal.common.GTextFormat;
	import mortal.common.display.LoaderHelp;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.utils.AvatarUtil;
	import mortal.game.view.chat.ChatArea;
	import mortal.game.view.chat.chatPanel.ChatItem;
	import mortal.game.view.chat.chatViewData.ChatCellData;
	import mortal.game.view.chat.chatViewData.ChatItemData;
	import mortal.game.view.chat.chatViewData.ChatMessageWorking;
	import mortal.game.view.chat.selectPanel.ColorSelector;
	import mortal.game.view.chat.selectPanel.FacePanel;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.TimeButton;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.menu.PlayerMenuRegister;
	import mortal.mvc.core.Dispatcher;
	
	public class ChatWindow extends BaseWindow
	{
		private var _playerInfo:SMiniPlayer;
		
		private var _btnMinimize1:GLoadedButton;
		
		private var _titleTextFiled:TextField;
		private var _contentBitmap:ScaleBitmap;
		private var _scrollPane:GScrollPane;
		private var _chatBox:ChatPrivatePanel;
//		private var _spriteMark:Sprite;
		private var _inputText:GTextInput;
		private var _rightSprite:Sprite;
		
		//中间功能区域
		private var _spMiddle:Sprite;
		private var _areaFuns:GBox;
		private var _btnFace:GLoadingButton;
		private var _btnColorSelector:GLoadingButton;
		private var _btnBrush:GLoadingButton;
		private var _colorSelector:ColorSelector;
		private var _tfTips:TextField;
		
		//下面按钮
		private var _btnTips:TextField;
		private var _btnClose:GButton;
		private var _btnSend:TimeButton;
		
		//右边
//		private var _friendHead:Sprite;
		private var _btnLookInfo:GButton;
		private var _btnAddFriend:GButton;
		private var _btnInviteTeam:GButton;
		private var _btnApplyTeam:GButton;
		private var _sendFlower:GButton;
		private var _textPlayerMsg:GTextFiled;
		private var _tfCrossTip:GTextFiled;
		
		public function ChatWindow(playerInfo:SMiniPlayer)
		{
			super();
			_playerInfo = playerInfo;
			init();
		}
		
		override protected function configParams():void
		{
			_contentX = blurLeft;
			_contentY = blurTop;
			paddingBottom = 6;
			paddingLeft = 6;
			paddingRight = 5;
//			protected var paddingBottom:int=11;
//			protected var paddingLeft:int=9;
//			protected var paddingRight:int=7;
		}
		
		override protected function setWindowBgName():void
		{
			_windowBgName = ImagesConst.ChatWindowBg;
		}
		
		override protected function setWindowCenter():void
		{
			_windowCenter = ResourceConst.getScaleBitmap("WindowBgC");
		}
		
		private function init():void
		{
			this.setSize(555,464);
			this.titleHeight = 30;
			create();
			//邀请入队 和 申请入队 按钮的显示
			updateGroupBtn();
			addEventListeners();
		}
		
		private var _textTitle:TextField;
		
		private function create():void
		{
			//标题
			_textTitle = UIFactory.titleTextField("");
			this.title = _textTitle;
			_textTitle.y = 5;
			
			_btnMinimize1 = UIFactory.gLoadedButton(ImagesConst.MinimizeButton_upSkin,508,16,16,7,this);
			
			//记录框背景
			_contentBitmap = ResourceConst.getScaleBitmap("WindowCenterB");
			_contentBitmap.x = 14;
			_contentBitmap.y = 38;
			_contentBitmap.setSize(356,288);
			this.addChild(_contentBitmap);
			
			UIFactory.gBitmap(ImagesConst.ChatAnquan,34,46,this);
			UIFactory.gTextField("交谈中请勿轻信中奖、汇款等信息，切勿拨打陌生电话！",47,42,320,20,this);
			
			_chatBox = new ChatPrivatePanel(40);
			_chatBox.x = 20;
			_chatBox.y = 60;
			this.addChild(_chatBox);
			
			_scrollPane = new GScrollPane();
			_scrollPane.x = 20;
			_scrollPane.y = 60;
			_scrollPane.width = 348;
			_scrollPane.height = 263;
			_scrollPane.styleName = "GScrollPane";
			_scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
			_scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
			_scrollPane.source = _chatBox;
//			_scrollPane.scrollDrag = false;
			this.addChild(_scrollPane);
			_scrollPane.update();
			
			_spMiddle = new Sprite();
			UIFactory.setObjAttri(_spMiddle,12,326,-1,-1,this);
			
//			_btnFace = UIFactory.gLoadingButton(ResFileConst.ChatTrumpetFaceBtn,0,3,18,17,_spMiddle);
			
			//功能按钮区域  表情，颜色，刷子
			_areaFuns = new GBox();
			_areaFuns.x = 3;
			_areaFuns.horizontalGap = -2;
			_areaFuns.direction = GBoxDirection.HORIZONTAL;
			_spMiddle.addChild(_areaFuns);
			
			_btnFace = UIFactory.gLoadingButton(ResFileConst.ChatTrumpetFaceBtn,0,0,24,24,_areaFuns);
			_btnColorSelector = UIFactory.gLoadingButton(ResFileConst.ChatTrumpetColorBtn,0,0,24,24,_areaFuns);
			_btnBrush = UIFactory.gLoadingButton(ResFileConst.ChatClearBtn,0,0,24,24,_areaFuns);
			
//			_btnFace.toolTipData = "<font color='#ffffff'>" + Language.getString(40609) + "</font>";
//			_btnColorSelector.toolTipData = "<font color='#ffffff'>" + Language.getString(40610) + "</font>";
//			_btnBrush.toolTipData = "<font color='#ffffff'>" + Language.getString(40613) + "</font>";
			
			//输入框
			_inputText = new GTextInput();
			_inputText.x = 14;
			_inputText.y = 350;
			_inputText.setSize(356,69);
			_inputText.styleName = "GTextInput";
			_inputText.maxChars = 50;
			_inputText.mouseFocusEnabled = false;
			_inputText.textField.wordWrap = true;
			this.addChild(_inputText);
			_inputText.drawNow();
			var textFormat:TextFormat = new GTextFormat(FontUtil.defaultName,12,0xB1efff);
			textFormat.leading = 3;
			textFormat.align = TextFormatAlign.LEFT;
			_inputText.setStyle("textPadding",5);
			_inputText.setStyle("textFormat",textFormat);
			
			createBottom();
			createRightPart();
		}
		
		private function createBottom():void
		{
//			_btnTips = new TextField();
//			_btnTips.defaultTextFormat = GlobalStyle.textFormat1;
//			_btnTips.text = Language.getString(40624);
//			_btnTips.filters = [FilterConst.nameGlowFilter];
//			_btnTips.x = 23;
//			_btnTips.y = 375;
//			_btnTips.height = 20;
//			_btnTips.width = 100;
//			this.addChild(_btnTips);
			
//			_btnFace = new GButton();
//			_btnFace.width = 16;
//			_btnFace.height = 16;
//			_btnFace.styleName = "ExpressionButton";
//			_btnFace.x = 217;
//			_btnFace.label = "";
//			_btnFace.y = 376;
//			_btnFace.textField.filters = [FilterConst.nameGlowFilter];
//			this.addChild(_btnFace);
			
			_btnClose = new GButton();
			_btnClose.width = 65;
			_btnClose.height = 22;
			_btnClose.styleName = "Button";
			_btnClose.x = 225;
			_btnClose.label = "关闭";
			_btnClose.y = 428;
			_btnClose.textField.filters = [FilterConst.nameGlowFilter];
			this.addChild(_btnClose);
			
			_btnSend = UIFactory.timeButton("发送", 298, 428, 65, 22, this, Cache.instance.cd.CHAT);//new TimeButton(3000,TimeButton.COUNTDOWN,);
			_btnSend.isByClick = false;
			_btnSend.cdTime = 3000;
//			_btnSend.textField.filters = [FilterConst.nameGlowFilter];
//			this.addChild(_btnSend);
		}
		
		//对方信息
		private var _rightTitileText:GBitmap;
		private var _headBg:GBitmap;
		private var _headImageContainer:Sprite;
		private var _headImage:GImageBitmap;
		
//		private var _uploadImageContainer:Sprite;
//		private var _upLoadImage:Bitmap;
		
		private function createRightPart():void
		{
			_rightSprite = new Sprite();
			_rightSprite.x = 372;
			_rightSprite.y = 38;
			this.addChild(_rightSprite);
			
			var rightbg:ScaleBitmap = ResourceConst.getScaleBitmap("WindowCenterB");
			rightbg.x = 0;
			rightbg.y = 0;
			rightbg.setSize(174,415);
			_rightSprite.addChild(rightbg);
			
			UIFactory.bg(2, 2, 170, 26, _rightSprite, ImagesConst.RegionTitleBg);
			
			_rightTitileText = UIFactory.gBitmap("",12,8,_rightSprite);
			_headBg = UIFactory.gBitmap("",35,50,_rightSprite);
			
			_headImageContainer = new Sprite();
			_headImageContainer.buttonMode = true;
			_headImageContainer.x = 48;
			_headImageContainer.y = 39;
			_rightSprite.addChild(_headImageContainer);
			
			_headImage = UIFactory.gImageBitmap("",1,6,_headImageContainer);
			
			PlayerMenuRegister.Register(_headImageContainer,_playerInfo,PlayerMenuConst.ChatPrivateOpMenu);
			
			var proxy:String = EntityUtil.getProxyName(_playerInfo.entityId);
			_textPlayerMsg = UIFactory.gTextField("",12,140,157,185,_rightSprite);
			_textPlayerMsg.multiline = true;
			_textPlayerMsg.wordWrap = true;
			
			_btnLookInfo = UIFactory.gButton("查看资料",20,330,64,22,_rightSprite);
			_btnAddFriend = UIFactory.gButton("添加好友",93,330,64,22,_rightSprite);
			
			_btnInviteTeam = UIFactory.gButton("邀请入队",20,360,64,22,_rightSprite);
			_btnApplyTeam = UIFactory.gButton("申请入队",20,360,64,22,_rightSprite);
			_btnApplyTeam.visible = false;
			
			_sendFlower = UIFactory.gButton("赠送鲜花",93,360,64,22,_rightSprite);
			
			updateInfo();
			LoaderHelp.addResCallBack(ResFileConst.chatPrivate,onResCompl);
		}
		
		private function onResCompl():void
		{
			_headBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.ChatRoleHeadBg);
			_rightTitileText.bitmapData = GlobalClass.getBitmapData(ImagesConst.ChatDuifangXingxi);
		}
		
		private function addEventListeners():void
		{
			_inputText.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
			_btnSend.addEventListener(MouseEvent.CLICK,sendHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeHandler);
			_btnAddFriend.addEventListener(MouseEvent.CLICK,addFriendHandler);
			_btnMinimize1.addEventListener(MouseEvent.CLICK,minimizehandler);
			_btnLookInfo.addEventListener(MouseEvent.CLICK,lookInfohandler);
			_btnInviteTeam.addEventListener(MouseEvent.CLICK,inviteTeamHandler);
			_btnApplyTeam.addEventListener(MouseEvent.CLICK,applyTeamHandler);
			_sendFlower.addEventListener(MouseEvent.CLICK,onClickSendFlower);
			_btnBrush.addEventListener(MouseEvent.CLICK,onBtnBrushClick);
			
			FacePanel.registBtn(_btnFace,selectFace);
			ColorSelector.registBtn(_btnColorSelector,selectColor);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		private function keyHandler(e:KeyboardEvent):void
		{
			if(e.keyCode == KeyCode.ENTER)
			{
				SendMsg();
			}
		}
		
		private function sendHandler(e:MouseEvent):void
		{
			SendMsg();
		}
		
		private function SendMsg():void
		{
			if(_inputText.text && _btnSend.enabled)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.ChatPrivateSend,{content:_inputText.text,toPlayer:_playerInfo,color:_color}));
				_inputText.text = "";
				_btnSend.startCoolDown();
			}
		}
		
		private var _color:uint = 0xfdfdfd;
		private function selectColor(color:uint):void
		{
			_color = color;
			setInputTextFormat();
		}
		
		private function setInputTextFormat():void
		{
			var tf:TextFormat = new GTextFormat(FontUtil.songtiName,12,_color);
			tf.leading = 3;
			_inputText.setStyle("textFormat",tf);
			_inputText.setStyle("textPadding",5);
		}
		
		private function onBtnBrushClick(e:MouseEvent):void
		{
			_chatBox.reset();
			if(!this.isHide)
			{
				timeOutUpdate();
			}
		}
		
		private function selectFace(number:Object):void
		{
			_inputText.appendText("/" + number.toString() + " ");
			_inputText.setFocus();
			_inputText.setSelection(_inputText.text.length,_inputText.text.length);
		}
		
		private function closeHandler(e:MouseEvent):void
		{
			this.hide();
			ChatManager.removeChatWindow(this);
		}
		
		private function addFriendHandler(e:MouseEvent):void
		{
			PlayerMenuConst.Opearte(PlayerMenuConst.AddFriend,_playerInfo);
		}
		
		/**
		 * 邀请入队 
		 * @param e
		 * 
		 */		
		private function inviteTeamHandler(e:MouseEvent):void
		{
			PlayerMenuConst.Opearte(PlayerMenuConst.InvitedToTeam,_playerInfo);
		}
		
		/**
		 * 申请入队 
		 * @param e
		 * 
		 */		
		private function applyTeamHandler(e:MouseEvent):void
		{
			PlayerMenuConst.Opearte(PlayerMenuConst.ApplyToTeam,_playerInfo);
		}
		
		/**
		 * 赠送鲜花 
		 * @param e
		 * 
		 */		
		private function onClickSendFlower(e:MouseEvent):void
		{
			//Dispatcher.dispatchEvent(new DataEvent(EventName.FlowerOpenHandselFlower,_playerInfo));
		}
		
		private function lookInfohandler(e:MouseEvent):void
		{
			PlayerMenuConst.Opearte(PlayerMenuConst.LookInfo,_playerInfo);
		}
		
		public function addChatItem(chatData:ChatData):void
		{
			var playerName:String = chatData.chatFromPlayerName;
			var time:Date = chatData.date;
			var content:String = chatData.content;
			var chatColor:int = chatData.chatColor;
			var faceAuthority:int = chatData.faceAuthority;
			
			var chatItemData:ChatItemData = ObjectPool.getObject(ChatItemData);
			chatItemData.type = ChatMessageWorking.getChatTypeByAreaName(ChatArea.Secret);
			var cellVector:Vector.<ChatCellData>= new Vector.<ChatCellData>();
			if(chatColor == 0)
			{
				chatColor = 0xfdfdfd;
			}
//			cellVector = cellVector.concat(ChatMessageWorking.GetCellDataByPlayerInfo(player));
			cellVector = cellVector.concat(ChatMessageWorking.getCellDataByContent(content,chatColor,true,12,faceAuthority));
			chatItemData.cellVector = cellVector;
			var chatItem:ChatItem = ObjectPool.getObject(ChatItem);
			chatItem.init(chatItemData.getContentElement(),240,22);
			_chatBox.addChatItem(chatItem,chatData);
			chatItemData.dispose();
			if(!this.isHide)
			{
				timeOutUpdate();
			}
		}
		
		public function getChatPlayerName():String
		{
			return _playerInfo.name;
		}
		
		public function getChatPlayerEntityId():SEntityId
		{
			return _playerInfo.entityId;
		}
		
		public function getChatPlayerInfo():SMiniPlayer
		{
			return this._playerInfo;
		}

		public function minimizehandler(e:MouseEvent):void
		{
			this.hide();
		}
		
		public function get inputText():GTextInput
		{
			return _inputText;
		}
		
		public function updatePlayerMsg(miniPlayer:SMiniPlayer):void
		{
			_playerInfo = miniPlayer;
			updateInfo();
		}
		
		/**
		 * 更新头像  按钮 
		 * 
		 */
		private function updateInfo():void
		{
			var isCross:Boolean = !EntityUtil.isSameServerByRole(_playerInfo.entityId);
//			var isHavePhoto:Boolean = Boolean(_playerInfo.photo) && !isCross;
//			_headImageContainer.visible = !isHavePhoto;
//			_headBg.visible = !isHavePhoto;
//			_uploadImageContainer.visible = isHavePhoto;
//			_btnRequestTrade.visible = !isCross;
//			_btnInviteTeam.visible = !isCross;
//			_btnApplyTeam.visible = !isCross;
//			_btnAddFriend.visible = !isCross;
//			_sendFlower.visible = isCross;
//			_tfCrossTip.visible = isCross;
//			if(isCross)
//			{
//				_btnLookInfo.y = 205;
//			}
//			else
//			{
//				_btnLookInfo.y = 320;
//			}
			
//			if(isHavePhoto)
//			{
//				AvatarInfo.getUpdateAvatar(_playerInfo.entityId,AvatarType.UPLOADBIG,function(info:ImageInfo):void
//				{
//					_upLoadImage.bitmapData = info.bitmapData;
//					_upLoadImage.width = 95;
//					_upLoadImage.height = 95;
//					ToolTipsManager.register(_uploadImageContainer,BitmapTooltip,info.bitmapData);
//				});
//				PlayerOpRegister.Register(_uploadImageContainer,_playerInfo,PlayerOpMenuConst.ChatPrivateOpMenu);
//			}
//			else
//			{
//				AvatarInfo.getAvatar(_playerInfo.camp,_playerInfo.sex,AvatarType.BIG,function(info:ImageInfo):void
//				{
//					_headImage.bitmapData = info.bitmapData;
//				},_playerInfo.avatarId);
//				PlayerOpRegister.Register(_headImageContainer,_playerInfo,PlayerOpMenuConst.ChatPrivateOpMenu);
//			}
			//更新标题
			_textTitle.text = "与" + _playerInfo.name + "聊天中";
			
			//头像
			_headImage.imgUrl = AvatarUtil.getPlayerAvatarUrl(_playerInfo.career,_playerInfo.sex,AvatarUtil.Big);
			
			var proxy:String = EntityUtil.getProxyName(_playerInfo.entityId);
			
			//文本
			_textPlayerMsg.htmlText = "<textformat leading='6'>" +
				HTMLUtil.addColor("玩家名字: ","#FFFFFF") + _playerInfo.name + "<br/>"
				+ HTMLUtil.addColor("等      级: ","#FFFFFF") + _playerInfo.level + "<br/>"
				+ HTMLUtil.addColor("阵      营: ","#FFFFFF") + GameDefConfig.instance.getCampHtml(_playerInfo.camp) + "<br/>"
				+ HTMLUtil.addColor("职      业: ","#FFFFFF") + GameDefConfig.instance.getCarrer(_playerInfo.career) + "<br/>"
//				+ HTMLUtil.addColor("VIP 开通: ","#FFFFFF") + "无" + "<br/>"
				+ HTMLUtil.addColor("战 斗  力: ","#FFFFFF") +  HTMLUtil.addColor(_playerInfo.combat.toString(),GlobalStyle.colorAnjin) + "<br/>"
//				+ HTMLUtil.addColor("性      别: ","#FFFFFF") + GameDefConfig.instance.getSex(_playerInfo.sex).name + "<br/>"
//				+ HTMLUtil.addColor("状      态: ","#FFFFFF") + (_playerInfo.online?"在线":"离线") + "<br/>"
				+ HTMLUtil.addColor("宣      言: ","#FFFFFF") +  HTMLUtil.addColor(_playerInfo.signature?_playerInfo.signature:"这家伙很懒！啥都没写！",GlobalStyle.colorHuang)
				+ "</textformat>"
				;
		}
		
		/**
		 * 更新组队按钮相关 
		 * 
		 */		
		public function updateGroupBtn():void
		{
			var isCross:Boolean = !EntityUtil.isSameServerByRole(_playerInfo.entityId);
			if(!isCross)
			{
				//如果自己有队伍，而且有权限邀请队员的时候就是邀请，否则申请
				if(Cache.instance.group.isInGroup && (Cache.instance.group.isCaptain || Cache.instance.group.memberInvite))
				{
					_btnInviteTeam.visible = true;
					_btnApplyTeam.visible = false;
				}
				else
				{
					_btnInviteTeam.visible = false;
					_btnApplyTeam.visible = true;
				}
			}
		}
		
		override public function set visible(arg0:Boolean):void
		{
			super.visible = arg0;
			updateGroupBtn();
			if(arg0)
			{
				timeOutUpdate();
			}
		}
		
		private function onAddToStage(e:Event):void
		{
			reSetScrollPanePosition();
		}
		
		private function timeOutUpdate():void
		{
			setTimeout(reSetScrollPanePosition,100);
		}
		
		public function reSetScrollPanePosition():void
		{
			if(_scrollPane && Global.stage.contains(_scrollPane))
			{
				_chatBox.validateNow();
				setTimeout(validatePos,50);
			}
		}
		
		private function validatePos():void
		{
			_scrollPane.validateNow();
			_scrollPane.update();
			_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
		}
		
		override protected function addCloseButton():void
		{
			_closeBtn = UIFactory.gLoadedButton(ImagesConst.ChatCloseBtn_upSkin,0,0,18,16,null);
			_closeBtn.focusEnabled = true;
			_closeBtn.name = "Window_Btn_Close";
			_closeBtn.configEventListener(MouseEvent.CLICK,closeBtnClickHandler);
			$addChild(_closeBtn);
		}
		
		override protected function closeBtnClickHandler(e:MouseEvent):void
		{
			super.closeBtnClickHandler(e);
			ChatManager.removeChatWindow(this);
		}
		
		override protected function updateBtnSize():void
		{
			if( _closeBtn )
			{
				_closeBtn.x = this.width - _closeBtn.width - 11;
				_closeBtn.y = 13;
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			paddingBottom = 6;
			paddingLeft = 6;
			paddingRight = 5;
		}
	}
}