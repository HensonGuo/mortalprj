/**
 * @date 2011-3-9 下午08:02:33
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat
{	
	import Message.Game.SChatMsg;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.global.Global;
	import com.gengine.keyBoard.KeyBoardManager;
	import com.gengine.keyBoard.KeyCode;
	import com.gengine.utils.BrowerUtil;
	import com.greensock.TweenMax;
	import com.mui.controls.Alert;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.MuiEvent;
	
	import extend.language.Language;
	
	import fl.controls.TextInput;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.common.GTextFormat;
	import mortal.common.PulseSharedObject;
	import mortal.common.ResManager;
	import mortal.common.font.FontUtil;
	import mortal.common.global.ParamsConst;
	import mortal.common.net.CallLater;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.EffectManager;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.StageMouseManager;
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.manager.msgTip.MsgTypeImpl;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.map3D.util.MapFileUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.chat.chatTrumpet.ChatTrumpetSendWindow;
	import mortal.game.view.chat.chatViewData.ChatMessageWorking;
	import mortal.game.view.chat.chatViewData.ChatType;
	import mortal.game.view.chat.data.ChatShowPoint;
	import mortal.game.view.chat.selectPanel.FacePanel;
	import mortal.game.view.chat.selectPanel.SelectTypePanel;
	import mortal.game.view.chat.selectPanel.ShieldTypePanel;
	import mortal.game.view.chat.selectPanel.TransSelectPanel;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.alertwins.CheckBoxWin;
	import mortal.game.view.common.button.TimeButton;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.View;
	
	public class ChatModule extends View
	{
		private var _bg:ScaleBitmap;
		private var _chatBody:ChatBody;
		private var _bottomLine:Bitmap;
		private var _channelsTabBar:GTabBar;
		private var _spChannelsContainner:Sprite;
		private var _bmpInputBg:ScaleBitmap;
		private var _selectTypeButton:GButton;
		private var _inputPartContarner:Sprite;
		private var _enterButton:TimeButton;
		private var _expression:GLoadedButton;
		private var _textInput:TextInput;
		private var _shieldButton:GLoadedButton;
		private var _speakerButton:GLoadedButton;
		private var _clearButton:GLoadedButton;
		private var _setButton:GLoadedButton;
		private var _transButton:GLoadedButton;
		private var _PointBtn:GLoadedButton;
		
		//默认隐藏的
		private var _selectTypePanel:SelectTypePanel;
		private var _shieldTypePanel:ShieldTypePanel;
		private var _transPanel:TransSelectPanel;
		
		public var chatChannelsData:Array;
		public static const ChatWidth:Number = 313;
		public var judgeRec:Rectangle = new Rectangle(0,0,313,260);
		
		
		public function ChatModule()
		{
			super();
			chatChannelsData = ChatMessageWorking.chatShowAreaData;
			this.mouseEnabled = false;
			init();
		}
		
		private function init():void
		{
			setSize(313,260);
			layer = LayerManager.uiLayer;
			initBg();
			initChatBody();
			initChannelsContainner();
			initInputPart();
			initFeaturesButton();
			initPanels();
			addEventListeners();
			StageMouseManager.instance.addRecEvent(judgeRec,overCallBack,outCallBack);
		}
		
		private var tween:TweenMax;
		private var callTime:int = 0;
		
		protected function overCallBack():void
		{
			clearTimeout(callTime);
			killTween();
			tween = TweenMax.to(this,0.3,{chatAlpha:1});
		}
		
		protected function outCallBack():void
		{
			clearTimeout(callTime);
			callTime = setTimeout(tweenOut,5000);
		}
		
		protected function tweenOut():void
		{
			killTween();
			tween = TweenMax.to(this,1,{chatAlpha:0});
		}
		
		protected function killTween():void
		{
			if(tween)
			{
				tween.kill();
			}
		}
		
		private function initBg():void
		{
			_bg = ResourceConst.getScaleBitmap("ChatPanelBg");
			_bg.width = _width + 1;
			_bg.height = _height - 39;
			_bg.y = -_height;
			_bg.x = -2;
			this.addChild(_bg);
			
			_bmpInputBg = UIFactory.bg(-1,-41,_width,42,this,"ChatSendBg");
		}
		
		private function initChatBody():void
		{
			_chatBody = new ChatBody(chatChannelsData);
			_chatBody.y = -_height +25;
			this.addChild(_chatBody);
		}
		
		private function initChannelsContainner():void
		{
			_spChannelsContainner = new Sprite();
			_spChannelsContainner.y = -_height;
			this.addChild(_spChannelsContainner);
			
			_channelsTabBar = new GTabBar();
			_channelsTabBar.x = 1;
			_channelsTabBar.y = 4;
			_channelsTabBar.buttonWidth = 36;
			_channelsTabBar.buttonHeight = 23;
			_channelsTabBar.horizontalGap = 0;
			_channelsTabBar.buttonFilters = [FilterConst.nameGlowFilter];
			_channelsTabBar.dataProvider = ChatMessageWorking.chatShowAreaData;
			//_channelsTabBar.addEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE,tabBarChangeHandler);
			_spChannelsContainner.addChild(_channelsTabBar);
			_channelsTabBar.buttonStyleName = "ChatTabBtn";
			
			_speakerButton = UIFactory.gLoadedButton(ImagesConst.Speaker_upSkin,256,5,16,17,_spChannelsContainner);
			_clearButton = UIFactory.gLoadedButton(ImagesConst.ChatClearButton_upSkin,273,5,16,17,_spChannelsContainner);
			_setButton = UIFactory.gLoadedButton(ImagesConst.ChatSet_upSkin,290,5,16,17,_spChannelsContainner);
		}
		
		private function initInputPart():void
		{
			_inputPartContarner = new Sprite();
			_inputPartContarner.y = -37;
			this.addChild(_inputPartContarner);
			
			_PointBtn = UIFactory.gLoadedButton(ImagesConst.Point_upSkin,2,0,18,18,_inputPartContarner);
//			_PointBtn.toolTipData = Language.getString(40682);
			
			_expression = UIFactory.gLoadedButton(ImagesConst.ExpressionButton_upSkin,20,0,18,18,_inputPartContarner);
			
			_selectTypeButton = UIFactory.gButton(ChatMessageWorking.chatChannelsData[0]["label"],2,17,36,18,_inputPartContarner,"ChatBtn");
			_selectTypeButton.paddingTop = 2;
			_selectTypeButton.textFieldHeight = 18;
//			_transButton = UIFactory.gLoadedButton(ImagesConst.Trans_upSkin,1,0,18,17,_inputPartContarner);
//			_shieldButton = UIFactory.gLoadedButton(ImagesConst.Shield_upSkin,19,0,18,17,_inputPartContarner);
			
			_enterButton = new TimeButton(3000,TimeButton.CD,Cache.instance.cd.CHAT);
			_enterButton.width = 45;
			_enterButton.height = 31;
			_enterButton.textField.filters = [FilterConst.glowFilter];
			_enterButton.x = _width - 49;
			_enterButton.y = 1;
			_enterButton.label = "";
			_enterButton.isByClick = false;
			_enterButton.styleName = "EnterButton";
			_inputPartContarner.addChild(_enterButton);
			
			_textInput = new GTextInput();
			_textInput.width = 217;
			_textInput.textField.wordWrap = true;
			_textInput.height = 40;
			_textInput.x = 42;
			_textInput.y = 0;
			_textInput.maxChars = 50;
			_textInput.restrict = "\u4E00-\u9FA5\u0020-\u007E·-=【】；‘、，。、.~！@#￥%……&*（）——+{}：’“”|《》？/*.‘’";
			_textInput.textField.filters = [FilterConst.glowFilter];
			_textInput.setStyle("upSkin","");
			_textInput.setStyle("focusRectSkin","");
			_inputPartContarner.addChild(_textInput);
			var textFormat:TextFormat = new GTextFormat(FontUtil.songtiName,12,0xfefecc);
			textFormat.leading = 0;
			_textInput.setStyle("textFormat",textFormat);
			
//			var bmp:Bitmap = GlobalClass.getBitmap("dashed");
//			bmp.x = 50;
//			bmp.y = 20;
//			_inputPartContarner.addChild(bmp);
		}
		
		private function initFeaturesButton():void
		{
//			_shrinkButton = ObjCreate.createGButton("",255,-54,26,24,this,"ShrinkButton");
		}
		
		private function initPanels():void
		{
			_selectTypePanel = new SelectTypePanel(ChatMessageWorking.chatChannelsData);
			_selectTypePanel.x = _selectTypeButton.x + 3;
			_selectTypePanel.y = -146;
			
//			_shieldTypePanel = new ShieldTypePanel(ChatMessageWorking.chatChannelsData);
//			_shieldTypePanel.x = _shieldButton.x + 3;
//			_shieldTypePanel.y = -170;
//			
//			_transPanel = new TransSelectPanel();
//			_transPanel.x = _transButton.x + 3;
//			_transPanel.y = -147;
		}
		
		private function addEventListeners():void
		{
			_channelsTabBar.addEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE,changeTabBarChannelHandler);
			_selectTypeButton.addEventListener(MouseEvent.CLICK,showSelectTypePanelHandler);
//			_shieldButton.addEventListener(MouseEvent.CLICK,showShieldTypePanelHandler);
			_enterButton.addEventListener(MouseEvent.CLICK,enterHandler);
			FacePanel.registBtn(_expression,selectFace);
			_selectTypePanel.addCall(changeSpeakChannel);
			_textInput.addEventListener(KeyboardEvent.KEY_DOWN,downHandler);
//			_transButton.addEventListener(MouseEvent.CLICK,showTransHandler);
//			_transPanel.addCall(selectTrans);
			_speakerButton.addEventListener(MouseEvent.CLICK, showSpeakerPanelHandler);
			_PointBtn.addEventListener(MouseEvent.CLICK,onPointBtnClickHandle);
			_clearButton.addEventListener(MouseEvent.CLICK,onClickClearHandler);
			
			Dispatcher.addEventListener(EventName.ChatResize,onResize);
		}
		
		private function changeTabBarChannelHandler(e:MuiEvent = null):void
		{
			changeSpeakChannel(chatChannelsData[_channelsTabBar.selectedIndex]["name"]);
			_chatBody.changToChatItem(chatChannelsData[_channelsTabBar.selectedIndex]["name"]);
			if(_channelsTabBar.selectedIndex == 3 || _channelsTabBar.selectedIndex == 4)
			{
				EffectManager.glowFilterUnReg(_channelsTabBar.getButtonAt(_channelsTabBar.selectedIndex));
			}
		}
		
		private function showSelectTypePanelHandler(e:MouseEvent):void
		{
			if(_selectTypePanel.parent)
			{
				_selectTypePanel.parent.removeChild(_selectTypePanel);
				removeStateCancelPanelEvent();
			}
			else
			{
				this.addChild(_selectTypePanel);
				addStageCancelPanelEvent();
			}
		}
		
		private function showShieldTypePanelHandler(e:MouseEvent):void
		{
			if(_shieldTypePanel.parent)
			{
				_shieldTypePanel.parent.removeChild(_shieldTypePanel);
				removeStateCancelPanelEvent();
			}
			else
			{
				this.addChild(_shieldTypePanel);
				addStageCancelPanelEvent();
			}
		}
		
		private function showTransHandler(e:MouseEvent):void
		{
			if(_transPanel.parent)
			{
				_transPanel.parent.removeChild(_transPanel);
				removeStateCancelPanelEvent();
			}
			else
			{
				this.addChild(_transPanel);
				addStageCancelPanelEvent();
			}
		}
		
		private function addStageCancelPanelEvent():void
		{
			Global.stage.addEventListener(MouseEvent.CLICK,canselPanelsHandler);
		}
		
		private function removeStateCancelPanelEvent():void
		{
			if(!( _selectTypePanel.parent))// || _transPanel.parent || _shieldTypePanel.parent))
			{
				Global.stage.removeEventListener(MouseEvent.CLICK,canselPanelsHandler);
			}
		}
		
		private function canselPanelsHandler(e:MouseEvent):void
		{
			var target:DisplayObject = e.target as DisplayObject;
			if(target != _selectTypeButton && target!= _selectTypePanel)
			{
				if(_selectTypePanel.parent)
				{
					_selectTypePanel.parent.removeChild(_selectTypePanel);
				}
			}
//			if(target != _shieldButton && target != _shieldTypePanel && (!target.parent || target.parent != _shieldTypePanel))
//			{
//				if(_shieldTypePanel.parent)
//				{
//					_shieldTypePanel.parent.removeChild(_shieldTypePanel);
//				}
//			}
//			if(target != _transButton && target != _transPanel && (!target.parent || target.parent != _transPanel))
//			{
//				if(_transPanel.parent)
//				{
//					_transPanel.parent.removeChild(_transPanel);
//				}
//			}
		}
		
		private function changeSpeakChannel(strName:String):void
		{
			_selectTypeButton.label = getLabelByName(strName);
		}
		
		private function getLabelByName(strName:String):String
		{
			var label:String = _selectTypeButton.label;
			
			var data:Array = ChatMessageWorking.chatShowAreaData;
			
			var length:int = data.length - 2;
			for(var i:int = 0; i <= length;i++)
			{
				var obj:Object = data[i];
				if(obj["name"] == strName)
				{
					label = obj["label"];
					break;
				}
			}
			return label;
		}
		
		private function selectFace(face:Object):void
		{
			_textInput.appendText("/" + face.toString() + " ");
			_textInput.setFocus();
			_textInput.setSelection(_textInput.text.length,_textInput.text.length);
		}
		
		private function selectTrans(strName:String):void
		{
			var oldWidth:Number = _bg.width;
			var oldHeight:Number = _bg.height;
			switch(strName)
			{
				case TransSelectPanel.allTrans:
					_bg.visible = false;
					break;
				case TransSelectPanel.partTrans:
					_bg.visible = true;
					_bg.bitmapData = GlobalClass.getBitmapData("ChatPanelBg");
					_bg.width = oldWidth;
					_bg.height = oldHeight;
					break;
				case TransSelectPanel.littleTrans:
					_bg.visible = true;
					_bg.bitmapData = GlobalClass.getBitmapData("ChatPanelBg");
					_bg.width = oldWidth;
					_bg.height = oldHeight;
					break;
				case TransSelectPanel.showPanel:
					_chatBody.visible = true;
					_bg.visible = true;
					_spChannelsContainner.visible = true;
					break;
				case TransSelectPanel.hidePanel:
					_chatBody.visible = false;
					_bg.visible = false;
					_spChannelsContainner.visible = false;
					break;
			}
		}
		
		private function enterHandler(e:MouseEvent = null):void
		{
			if(_textInput.text != "" && _enterButton.enabled)
			{
				_enterButton.startCoolDown();
				Dispatcher.dispatchEvent(new DataEvent(EventName.ChatSend,{content:_textInput.text,area:ChatMessageWorking.getNameByLabel(_selectTypeButton.label)}));
			}
			else if(_textInput.text == "")
			{
				Global.stage.focus = Global.stage;
				KeyBoardManager.instance.changeImeEnable(false);
			}
		}
		
		public function setDefaultCountryChannel():void
		{
			_selectTypeButton.label = getLabelByName(ChatArea.Country);
		}
		
		public function clearInput():void
		{
			_textInput.text = "";
		}
		
		/**
		 * 清除Btn CD 
		 * 
		 */		
		public function clearCD():void
		{
//			if(_enterButton)
//			{
//				_enterButton.clearCD();
//			}
		}
		
		private function downHandler(e:KeyboardEvent):void
		{
			if(_textInput.text == "" && e.keyCode == KeyCode.UP)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.ChatCopyUpRecord));
			}
			if(e.keyCode == KeyCode.ENTER)
			{
				enterHandler();
			}
			e.stopImmediatePropagation();
		}
		
		private var _arySize:Array = [188,126,63];
		private var _iCurrentSize:int = 0;
		private function shrinkHandler(e:MouseEvent):void
		{
			_iCurrentSize = ++_iCurrentSize>=_arySize.length?0:_iCurrentSize;
			_chatBody.setSize(_width,_arySize[_iCurrentSize]);
			_chatBody.y = -1 * (_arySize[_iCurrentSize] + 52);
			Dispatcher.dispatchEvent( new DataEvent(EventName.ChatResize));
		}
		
		//liuxuejiao 2011-3-23 添加
		private function showSpeakerPanelHandler(e:MouseEvent):void
		{
			var btn:GButton = e.target as GButton;
			ChatTrumpetSendWindow.instance.show();
		}
		
		/**
		 * 点击坐标按钮 
		 * @param e
		 * 
		 */		
		private function onPointBtnClickHandle(e:MouseEvent):void
		{
//			if(GameMapUtil.isUniqueMap() || Cache.instance.guild.isInSelfManorMap())
//			{
//				var isNeedAlert:Boolean = !PulseSharedObject.isTodayNotTips("SelfMapPoint");
//				if (isNeedAlert) 
//				{
//					Alert.alertWinRenderer = CheckBoxWin;
//					Alert.show(Language.getString(40683),null,Alert.OK|Alert.CANCEL,null,onChoosePoint);
//				}
//				else
//				{
					addMapPoint();
//				}
//			}
//			else
//			{
//				MsgManager.showRollTipsMsg(Language.getString(40684));
//			}
		}
		
		/**
		 * 点击清理 
		 * @param e
		 * 
		 */		
		private function onClickClearHandler(e:MouseEvent):void
		{
			_chatBody.clearCurrentMsg();
		}
		
		/**
		 * 选择是否确定移动 
		 * @param index
		 * 
		 */		
		private function onChoosePoint(index:int,selected:Boolean):void
		{
			if(index == Alert.OK)
			{
				addMapPoint();
			}
			if(selected)
			{
				PulseSharedObject.save("SelfMapPoint",true);
			} 
		}
		
		private function addMapPoint():void
		{
//			var roleTilePoint:Point = GameMapUtil.getTilePoint(RolePlayer.instance.x2d,RolePlayer.instance.y2d);
			var chatShowPoint:ChatShowPoint = new ChatShowPoint(MapFileUtil.mapID,RolePlayer.instance.x2d,RolePlayer.instance.y2d);
			
			addInputText(chatShowPoint.mapNameString());
			setChatInputFocus();
			
			Dispatcher.dispatchEvent( new DataEvent(EventName.ChatShowPoint,chatShowPoint));
		}
		
		private function onGMClickHandler(e:MouseEvent):void
		{
			var gmUrl:String = ParamsConst.instance.gmUrl;
			if(gmUrl != null && gmUrl != "")
			{
				BrowerUtil.getUrl(gmUrl);
			}
			else
			{
				GameManager.instance.popupWindow(ModuleType.GM);
			}
		}
		
		private function onResize(e:DataEvent):void
		{
			_bg.height = 18 + _chatBody.currentHeight;
			_bg.y = -1 * _bg.height - 34;
		}
		
		public function get notShieldNameList():Array
		{
			return [ChatArea.World,ChatArea.Country,ChatArea.Union,ChatArea.Team,ChatArea.Scene];
		}
		
		/**
		 * 添加聊天信息 
		 * @param typeName
		 * @param player
		 * @param content
		 * 
		 */
		public function updateChatMesssage(typeName:String,player:SMiniPlayer,content:String,itemList:Array,petList:Array,force:int,chatMsg:SChatMsg):void
		{
//			var notShieldNameList:Array = _shieldTypePanel.getNotShieldNameList();
			_chatBody.addChatNotes(typeName,player,content,itemList,petList,notShieldNameList,force,chatMsg);
			//仙盟聊天频道闪烁
			if(typeName == ChatArea.Union && _channelsTabBar.selectedIndex != 3 && notShieldNameList.indexOf(typeName) >= 0)
			{
				EffectManager.glowFilterReg(_channelsTabBar.getButtonAt(3),[FilterConst.chatTipsFilter],0.6,10,1);
			}
			//队伍 和 跨服组队频道 闪烁
			if(typeName == ChatArea.Team && chatChannelsData.indexOf(ChatMessageWorking.teamObj) > -1
			|| typeName == ChatArea.CrossGrop && chatChannelsData.indexOf(ChatMessageWorking.crossGroupObj) > -1
			|| typeName == ChatArea.Force)
			{
				if(_channelsTabBar.selectedIndex != 4 && notShieldNameList.indexOf(typeName) >= 0)
				{
					EffectManager.glowFilterReg(_channelsTabBar.getButtonAt(4),[FilterConst.chatTipsFilter],0.6,10,1);
				}
			}
		}
		
//		/**
//		 * 炫耀物品
//		 * @return 
//		 * 
//		 */		
//		public function UpdateShowMessage(typeName,player,itemData:ItemData,_shieldTypePanel.getNotShieldNameList()):void
//		{
//			
//		}
		
		public function updateTipMsg(type:String,content:String,chatArea:String = "complex",analysisType:int = 0,aryPlayer:Array = null,baseColor:int = 0xffffff):void
		{
			_chatBody.addTipNotes(type,content,chatArea,analysisType,aryPlayer,baseColor);
		}
		
		/**
		 * 添加传闻信息 
		 * @param content
		 * @param aryPlayer
		 * 
		 */		
		public function addRumorMsg(content:String,aryPlayer:Array,chatType:String = null):void
		{
			if(!chatType)
			{
				chatType = ChatType.Legent;
			}
			_chatBody.addRumorMsg(content,aryPlayer,chatType);
		}
		
		public function addCopyMsg(content:String,aryPlayer:Array):void
		{
			var isAdd:Boolean = _chatBody.addCopyMsg(content,aryPlayer);
			if(_channelsTabBar.selectedIndex != 4 && isAdd && ChatMessageWorking.chatChannelsData.indexOf(ChatMessageWorking.noTeamObj) > -1)
			{
				EffectManager.glowFilterReg(_channelsTabBar.getButtonAt(4),[FilterConst.chatTipsFilter],0.6,10,1);
			}
		}
		
		/**
		 * 添加跨服副本信息 
		 * @param content
		 * @param aryPlayer
		 * 
		 */
		public function addCrossCopyMsg(content:String,aryPlayer:Array):void
		{
			var isAdd:Boolean = _chatBody.addCopyMsg(content,aryPlayer,true);
			if(_channelsTabBar.selectedIndex != 4 && isAdd)
			{
				EffectManager.glowFilterReg(_channelsTabBar.getButtonAt(4),[FilterConst.chatTipsFilter],0.6,10,1);
			}
		}
			
		/**
		 * 添加文字
		 * @return 
		 * 
		 */
		public function addInputText(strText:String):void
		{
			_textInput.appendText(strText);
		}
		
		public function setChatInputFocus():void
		{
			_textInput.setFocus();
			Global.instance.callLater(selectLastChat);
		}
		
		public function selectLastChat():void
		{
			_textInput.setSelection(_textInput.text.length,_textInput.text.length);
		}
		
		/**
		 * 切换聊天标签状态 
		 * 
		 */		
		public function changeTabBar():void
		{
//			//联盟频道判断
//			var isInGuildUnion:Boolean = Cache.instance.guildUnion.isInGuildUnionActive;
//			ChatMessageWorking.changeToGuildUnion(isInGuildUnion);
//			
//			//天神战场 或者 夺旗战
//			var isNewBattlefield:Boolean = GameMapUtil.curMapState.isNewBattlefield || GameMapUtil.curMapState.isRobFlag;
//			if(isNewBattlefield)
//			{
//				ChatMessageWorking.changeToNewBattleField();
//				_channelsTabBar.selectedIndex = 5;
//			}
//			else
//			{
//				var isCrossServer:Boolean = GameMapUtil.curMapState.isCrossMap;
//				
				var isHasGroup:Boolean = Cache.instance.group.isInGroup;
				var isCrossGroupMap:Boolean = false;
				var isCrossGroup:Boolean = false;
//				ChatMessageWorking.changeMap(isCrossServer);
//				var isInGuildGroupCopy:Boolean = GameMapUtil.curMapState.isGuildElite;
//				if(isInGuildGroupCopy)
//				{
//					ChatMessageWorking.changeToGuildGroup();
//				}
//				else
//				{
					ChatMessageWorking.changeGroup(isCrossGroupMap,isCrossGroup,isHasGroup);
//				}
//			}
//			
			_selectTypePanel.updateData(ChatMessageWorking.chatChannelsData);
			_channelsTabBar.dataProvider = ChatMessageWorking.chatShowAreaData;
			_channelsTabBar.invalidate();
			_channelsTabBar.drawNow();
//			chatChannelsData = ChatMessageWorking.chatShowAreaData;
//			
//			if(isNewBattlefield)
//			{
//				changeSpeakChannel(ChatArea.Scene);
//				_channelsTabBar.selectedIndex = 5;
//			}
			
			changeTabBarChannelHandler();
		}
		
		/**
		 * 更新表情面板 
		 * 
		 */		
		public function updateVIPState():void
		{
//			if(_facePanel)
//			{
//				_facePanel.layOut();
//			}
		}
		
		override public function setSize(width:Number, height:Number):void
		{
			super.setSize(width,height);
			judgeRec.width = width;
			judgeRec.height = height;
		}
		
		override public function stageResize():void
		{
			this.x = 0;
			this.y = SceneRange.display.height;
			judgeRec.y = SceneRange.display.height - judgeRec.height;
		}
		
		override protected function updateView():void
		{
			
		}
		
		/**
		 * 设置聊天的alpha 
		 * @param value
		 * 
		 */
		public function set chatAlpha(value:Number):void
		{
			_bg.alpha = value;
			_spChannelsContainner.alpha = value;
			_chatBody.scrollAplha = value;
		}
		
		public function get chatAlpha():Number
		{
			return _spChannelsContainner.alpha;
		}
		
		public function addSystemMsg(msg:String,msgType:MsgTypeImpl):void
		{
			_chatBody.addSystemMsg(msg,msgType);
		}
	}
}