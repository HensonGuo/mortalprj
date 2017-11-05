/**
 * @date 2011-3-10 上午11:35:41
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat
{
	import Message.Game.SChatMsg;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GSprite;
	
	import extend.language.Language;
	
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.system.System;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.msgTip.MsgTypeImpl;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.info.ColorInfo;
	import mortal.game.utils.PlayerUtil;
	import mortal.game.view.chat.chatPanel.ChatBox;
	import mortal.game.view.chat.chatPanel.ChatMsgBox;
	import mortal.game.view.chat.chatPanel.ChatNotes;
	import mortal.game.view.chat.chatPanel.ChatStyle;
	import mortal.game.view.chat.chatPanel.HistoryMsg;
	import mortal.game.view.chat.chatViewData.ChatCellData;
	import mortal.game.view.chat.chatViewData.ChatItemData;
	import mortal.game.view.chat.chatViewData.ChatMessageWorking;
	import mortal.game.view.chat.chatViewData.ChatType;
	import mortal.game.view.chat.data.FaceAuthority;
	import mortal.game.view.common.drag.DragItem;
	import mortal.game.view.common.drag.DragItemEvent;
	import mortal.mvc.core.Dispatcher;
	
	public class ChatBody extends Sprite
	{
		private var _scrollPane:GScrollPane;
		private var _dataArray:Array;
		private var _currentChatBox:Sprite;
		
		private var _dicNameChatBox:Dictionary;
		public var msgBox:ChatMsgBox;
		public static const lineHeight:Number = 21;
		public static const lineWidth:Number = 300;
		
		//负责拖动的
		private var _dragItem:DragItem;
		private const MaxHeight:Number = 170;
		private const MinHeight:Number = 60;
		private var _currentHeight:Number = 170;
		
		public function ChatBody(dataArray:Array)
		{
			super();
			_dataArray = dataArray;
			this.mouseEnabled = false;
			init();
		}
		
		private function init():void
		{
			initBody();
			initScrollPane();
			addMessage();
//			addDragItem();
		}
		
		private function initBody():void
		{
			_dataArray = ChatMessageWorking.chatShowAllAreaData;
			_dicNameChatBox = new Dictionary();
			for(var i:int = 0;i<_dataArray.length;i++)
			{
				var obj:Object = _dataArray[i];
				if(i == _dataArray.length - 1)
				{
					var msgBox:ChatMsgBox = new ChatMsgBox();
					msgBox.name = obj["name"];
					msgBox.y = 0;
					_dicNameChatBox[obj["name"]] = msgBox;
					this.msgBox = msgBox;
				}
				else
				{
					var chatBox:ChatBox = new ChatBox(30);
					chatBox.name = obj["name"];
					chatBox.y = 0;
					_dicNameChatBox[obj["name"]] = chatBox;
				}
				if(i == 0)
				{
					_currentChatBox = chatBox;
					chatBox.visible = true;
				}
				else
				{
					chatBox.visible = false;
				}
			}
		}
		
		private function initScrollPane():void
		{
			_scrollPane = new GScrollPane();
			_scrollPane.verticalScrollBarPos = GScrollPane.SCROLLBARPOSITIONLEFT;
			_scrollPane.width = 313;
			_scrollPane.y = 0;
			_scrollPane.height = 192;
			_scrollPane.styleName = "chatScrollPane";
			_scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
			_scrollPane.verticalScrollPolicy = ScrollPolicy.ON;
			_scrollPane.source = _currentChatBox;
			_scrollPane.mouseEnabled = false;
			(_scrollPane.content as DisplayObjectContainer).mouseEnabled = false;
			this.addChild(_scrollPane);
			_currentChatBox.parent.mouseEnabled = false;
			_scrollPane.update();
		}

		public function addMessage(strMessage:String = ""):void
		{
			var sp:GSprite = new GSprite();
			var textField:TextField = new TextField();
			textField.y = 5;
			textField.x = 5;
			textField.width = 250;
			textField.multiline = true;
			textField.filters = [FilterConst.glowFilter];
			textField.defaultTextFormat = new GTextFormat(FontUtil.defaultName);
			textField.htmlText = "<textFormat leading='4'>" + HTMLUtil.addColor("卓粤净身房 切勿靠近\r","#ff5b5b")
								+ "</textFormat>";
			textField.selectable = false;
			sp.mouseEnabled = false;
			sp.mouseChildren = false;
			sp.addChild(textField);
			(_dicNameChatBox[ChatArea.Complex] as ChatBox).addChild(sp);
			
			textField.height = textField.textHeight + 10;
			sp.setSize(textField.width,textField.height);
		}
		
		private function addDragItem():void
		{
			_dragItem = new DragItem(ChatModule.ChatWidth - 20,5);
			_dragItem.x = 20;
			_dragItem.addEventListener(DragItemEvent.DragPositionChange,onDragPositionChange);
			_dragItem.addEventListener(DragItemEvent.StartDrag,onStartDrag);
			this.addChild(_dragItem);
		}
		
		private var _lastDragHeight:Number;
		
		private function onStartDrag(e:DragItemEvent):void
		{
			_lastDragHeight = _currentHeight;
		}
		
		private function onDragPositionChange(e:DragItemEvent):void
		{
			_currentHeight = _lastDragHeight - e.changeY;
			_currentHeight = _currentHeight > MaxHeight?MaxHeight:_currentHeight;
			_currentHeight = _currentHeight < MinHeight?MinHeight:_currentHeight;
			this.setSize(313,_currentHeight);
			this.y = -1 * (_currentHeight + 52);
			Dispatcher.dispatchEvent( new DataEvent(EventName.ChatResize));
		}
		
		/**
		 * 添加聊天信息 
		 * @param areaName
		 * @param player
		 * @param content
		 * @param notShieldNameList
		 * force 为-1显示天神战场的势力信息
		 * 
		 */
		public function addChatNotes(areaName:String,player:SMiniPlayer,content:String,itemList:Array = null,petList:Array = null,notShieldNameList:Array = null,force:int = -1,chatMsg:SChatMsg = null):void
		{
			if(notShieldNameList.indexOf(ChatArea.Force) == -1)
			{
				notShieldNameList.push(ChatArea.Force);
			}
			var faceAuthority:int = 3;
//			if(player && !PlayerUtil.isVIP(player))
//			{
//				faceAuthority = 1;
//			}
			var isAtMaxScrollPosition:Boolean = _scrollPane.verticalScrollPosition == _scrollPane.maxVerticalScrollPosition;
			var holdPosition:Number = _scrollPane.verticalScrollPosition;
			var isMaxLength:Boolean = false;
			var firstHeigth:Number = 0;
			isMaxLength = (_currentChatBox is ChatBox) && (_currentChatBox as ChatBox).isMaxLength();
			if(isMaxLength)
			{
				firstHeigth = (_currentChatBox as ChatBox).getChatNotesAtIndex(0).height;
				holdPosition -= firstHeigth;
			}
			
			var chatItemData:ChatItemData;
			var cellVector:Vector.<ChatCellData>;
			var chatNotes:ChatNotes;
			
			if(notShieldNameList.indexOf(areaName) < 0 && areaName!= ChatArea.Speaker)
			{
				return;
			}
//			if(areaName != ChatArea.World && notShieldNameList.indexOf(ChatArea.World)<0)
//			{
//				notShieldNameList.push(ChatArea.World);
//			}
			for each(var name:String in notShieldNameList)
			{
//				if(name == ChatArea.World)
//				{
//					chatItemData = ObjectPool.getObject(ChatItemData);
//					chatItemData.type = ChatMessageWorking.getChatTypeByAreaName(areaName);
//					cellVector = new Vector.<ChatCellData>();
//					cellVector = cellVector.concat(ChatMessageWorking.getCellDataByPlayerInfo(player,ChatStyle.getTitleColor(chatItemData.type)));
//					if(areaName == ChatArea.World)
//					{
//						cellVector = cellVector.concat(ChatMessageWorking.getCellDatas(content,itemList,petList));
//					}
//					else
//					{
//						cellVector = cellVector.concat(ChatMessageWorking.getCellDatas(content,itemList,petList,ChatStyle.getTitleColor(chatItemData.type)));
//					}
//					chatItemData.cellVector = cellVector;
//					chatNotes = ObjectPool.getObject(ChatNotes);
//					chatNotes.init(chatItemData,lineWidth,lineHeight);
//					(_dicNameChatBox[name] as ChatBox).addChatNotes(chatNotes);
//					continue;
//				}
				if(areaName == name || areaName == ChatArea.Speaker && name == ChatArea.World)
				{
					chatItemData = ObjectPool.getObject(ChatItemData);
					chatItemData.type = ChatMessageWorking.getChatTypeByAreaName(areaName);
					cellVector = new Vector.<ChatCellData>();
					
					var isNewBFMsg:Boolean = ChatMessageWorking.chatChannelsData.indexOf(ChatMessageWorking.forceObj) > -1 
						&& (areaName == ChatArea.Scene || areaName == ChatArea.Force);
					if(isNewBFMsg && force != -1)
					{
						cellVector = cellVector.concat(ChatMessageWorking.getForcePlayerCellData(player,force));
					}
					//公会需要显示职位
					else if(areaName == ChatArea.Union)
					{
						cellVector = cellVector.concat(ChatMessageWorking.getCellDataByPlayerInfo(player,ChatStyle.getTitleColor(chatItemData.type),true));
					}
					else
					{
						cellVector = cellVector.concat(ChatMessageWorking.getCellDataByPlayerInfo(player,ChatStyle.getTitleColor(chatItemData.type)));
					}
					cellVector = cellVector.concat(ChatMessageWorking.getCellDatas(content,itemList,petList,ChatStyle.getTitleColor(chatItemData.type),12,faceAuthority));
					chatItemData.cellVector = cellVector;
					chatNotes = ObjectPool.getObject(ChatNotes);
					chatNotes.init(chatItemData,lineWidth,lineHeight);
					(_dicNameChatBox[name] as ChatBox).addChatNotes(chatNotes);
					
					//天神战场的信息不添加到综合频道
					if(!isNewBFMsg)
					{
						//因为可能chatItemData被销毁导致下面那条消息显示null 所以重复一段
						chatItemData = ObjectPool.getObject(ChatItemData);
						chatItemData.type = ChatMessageWorking.getChatTypeByAreaName(areaName);
						cellVector = new Vector.<ChatCellData>();
						//公会需要显示职位
						if(areaName == ChatArea.Union)
						{
							cellVector = cellVector.concat(ChatMessageWorking.getCellDataByPlayerInfo(player,ChatStyle.getTitleColor(chatItemData.type),true));
						}
						else
						{
							cellVector = cellVector.concat(ChatMessageWorking.getCellDataByPlayerInfo(player,ChatStyle.getTitleColor(chatItemData.type)));
						}
						cellVector = cellVector.concat(ChatMessageWorking.getCellDatas(content,itemList,petList,ChatStyle.getTitleColor(chatItemData.type),12,faceAuthority));
						chatItemData.cellVector = cellVector;
						chatNotes = ObjectPool.getObject(ChatNotes);
						chatNotes.init(chatItemData,lineWidth,lineHeight);
						(_dicNameChatBox[ChatArea.Complex] as ChatBox).addChatNotes(chatNotes);
					}
				}
			}
			_scrollPane.validateNow();
			_scrollPane.update();
			holdPosition = holdPosition >= 0?holdPosition:0;
			if(isAtMaxScrollPosition)
			{
				_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
			}
			else
			{
				_scrollPane.verticalScrollPosition = holdPosition;
			}
		}
		
		/**
		 * 添加提示或者系统信息
		 * @param type
		 * @param content
		 * @param chatArea
		 * @param analysisType 0为普通聊天内容解析  1为含有html的系统信息解析 2为<MsgObj>标签解析
		 * 
		 */
		public function addTipNotes(type:String,content:String,chatArea:String = ChatArea.Complex,analysisType:int = 0,aryPlayer:Array = null,baseColor:int = 0xffffff):void
		{
			var isAtMaxScrollPosition:Boolean = _scrollPane.verticalScrollPosition == _scrollPane.maxVerticalScrollPosition;
			var holdPosition:Number = _scrollPane.verticalScrollPosition;
			var isMaxLength:Boolean = false;
			var firstHeigth:Number = 0;
			isMaxLength =  (_currentChatBox is ChatBox) && (_currentChatBox as ChatBox).isMaxLength();
			if(isMaxLength)
			{
				firstHeigth = (_currentChatBox as ChatBox).getChatNotesAtIndex(0).height;
				holdPosition -= firstHeigth;
			}
			
			var chatItemData:ChatItemData;
			var cellVector:Vector.<ChatCellData>;
			chatItemData = ObjectPool.getObject(ChatItemData);
			chatItemData.type = type;
			cellVector = new Vector.<ChatCellData>();
			if(analysisType == 0)
			{
				cellVector = cellVector.concat(ChatMessageWorking.getCellDataByContent(content,ChatStyle.getTitleColor(chatItemData.type)));
			}
			if(analysisType == 1)
			{
				cellVector = cellVector.concat(ChatMessageWorking.getCellDatasFilterHtml(content,ChatStyle.getTitleColor(chatItemData.type),aryPlayer));
			}
			if(analysisType == 2)
			{
				cellVector = cellVector.concat(ChatMessageWorking.getCellDatasByAnalyzeRumor(content,aryPlayer,baseColor));
			}
			//空消息。或者解析出错的消息
			if(!cellVector || cellVector.length == 0)
			{
				return;
			}
			chatItemData.cellVector = cellVector;
			
			var chatNotes:ChatNotes = ObjectPool.getObject(ChatNotes);
			chatNotes.init(chatItemData,lineWidth,lineHeight);
			(_dicNameChatBox[ChatArea.Complex] as ChatBox).addChatNotes(chatNotes);
			
			if(chatArea != ChatArea.Complex)
			{
				//避免消息被销毁。。重新赋值一下。
				chatItemData = ObjectPool.getObject(ChatItemData);
				chatItemData.type = type;
				cellVector = new Vector.<ChatCellData>();
				if(analysisType == 0)
				{
					cellVector = cellVector.concat(ChatMessageWorking.getCellDataByContent(content,ChatStyle.getTitleColor(chatItemData.type)));
				}
				if(analysisType == 1)
				{
					cellVector = cellVector.concat(ChatMessageWorking.getCellDatasFilterHtml(content,ChatStyle.getTitleColor(chatItemData.type)));
				}
				if(analysisType == 2)
				{
					cellVector = cellVector.concat(ChatMessageWorking.getCellDatasByAnalyzeRumor(content,aryPlayer,baseColor));
				}
				//空消息。或者解析出错的消息
				if(!cellVector || cellVector.length == 0)
				{
					return;
				}
				chatItemData.cellVector = cellVector;
				chatNotes = ObjectPool.getObject(ChatNotes);
				chatNotes.init(chatItemData,lineWidth,lineHeight);
				(_dicNameChatBox[chatArea] as ChatBox).addChatNotes(chatNotes);
			}
			_scrollPane.validateNow();
			_scrollPane.update();
			
			holdPosition = holdPosition >= 0?holdPosition:0;
			if(isAtMaxScrollPosition)
			{
				_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
			}
			else
			{
				_scrollPane.verticalScrollPosition = holdPosition;
			}
		}
		
		/**
		 * 添加传闻信息  战场信息等
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
			var isAtMaxScrollPosition:Boolean = _scrollPane.verticalScrollPosition == _scrollPane.maxVerticalScrollPosition;
			var holdPosition:Number = _scrollPane.verticalScrollPosition;
			var isMaxLength:Boolean = false;
			var firstHeigth:Number = 0;
			isMaxLength = (_currentChatBox is ChatBox) && (_currentChatBox as ChatBox).isMaxLength();
			if(isMaxLength)
			{
				firstHeigth = (_currentChatBox as ChatBox).getChatNotesAtIndex(0).height;
				holdPosition -= firstHeigth;
			}
			
			var chatItemData:ChatItemData;
			var cellVector:Vector.<ChatCellData>;
			chatItemData = ObjectPool.getObject(ChatItemData);
			chatItemData.type = chatType;
			cellVector = new Vector.<ChatCellData>();
			var color:int = 0xffffff;
			var colorInfo:ColorInfo = ColorConfig.instance.getChatColor("Rumor");
			if(colorInfo)
			{
				color = colorInfo.intColor;
			}
			cellVector = cellVector.concat(ChatMessageWorking.getCellDatasByAnalyzeRumor(content,aryPlayer,color));
			//空消息。或者解析出错的消息
			if(!cellVector || cellVector.length == 0)
			{
				return;
			}
			chatItemData.cellVector = cellVector;
			var chatNotes:ChatNotes = ObjectPool.getObject(ChatNotes);
			chatNotes.init(chatItemData,lineWidth,lineHeight);
			(_dicNameChatBox[ChatArea.Complex] as ChatBox).addChatNotes(chatNotes);
			_scrollPane.update();
			holdPosition = holdPosition >= 0?holdPosition:0;
			if(isAtMaxScrollPosition)
			{
				_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
			}
			else
			{
				_scrollPane.verticalScrollPosition = holdPosition;
			}
		}
		
		/**
		 * 在组队 或者 团队里面添加副本消息  可以添加返回ture 否则返回false
		 * isCross 为true 是团队
		 * @param content
		 * @param aryPlayer
		 * 
		 */
		public function addCopyMsg(content:String,aryPlayer:Array,isCross:Boolean = false):Boolean
		{
			var isAtMaxScrollPosition:Boolean = _scrollPane.verticalScrollPosition == _scrollPane.maxVerticalScrollPosition;
			var holdPosition:Number = _scrollPane.verticalScrollPosition;
			var isMaxLength:Boolean = false;
			var firstHeigth:Number = 0;
			isMaxLength = (_currentChatBox is ChatBox) && (_currentChatBox as ChatBox).isMaxLength();
			if(isMaxLength)
			{
				firstHeigth = (_currentChatBox as ChatBox).getChatNotesAtIndex(0).height;
				holdPosition -= firstHeigth;
			}
			
			var chatItemData:ChatItemData;
			var cellVector:Vector.<ChatCellData>;
			var chatNotes:ChatNotes;
			var color:int;
			var colorInfo:ColorInfo;
			chatItemData = ObjectPool.getObject(ChatItemData);
			chatItemData.type = ChatType.Copy;
			cellVector = new Vector.<ChatCellData>();
			color = 0xffffff;
			colorInfo = ColorConfig.instance.getChatColor("Rumor");
			if(colorInfo)
			{
				color = colorInfo.intColor;
			}
			cellVector = cellVector.concat(ChatMessageWorking.getCellDatasByAnalyzeRumor(content,aryPlayer,color));
			//空消息。或者解析出错的消息
			if(!cellVector || cellVector.length == 0)
			{
				return false;
			}
			chatItemData.cellVector = cellVector;
			chatNotes = ObjectPool.getObject(ChatNotes);
			chatNotes.init(chatItemData,lineWidth,lineHeight);
			var chatArea:String = isCross?ChatArea.CrossGrop:ChatArea.Team;
			(_dicNameChatBox[chatArea] as ChatBox).addChatNotes(chatNotes);
			
			_scrollPane.update();
			holdPosition = holdPosition >= 0?holdPosition:0;
			if(isAtMaxScrollPosition)
			{
				_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
			}
			else
			{
				_scrollPane.verticalScrollPosition = holdPosition;
			}
			return true;
		}
		
		public function changToChatItem(name:String):void
		{
			if(_currentChatBox.name == name)
			{
				return;
			}
			_currentChatBox.visible = false;
			_currentChatBox = _dicNameChatBox[name] as Sprite;
			_currentChatBox.visible = true;
			_scrollPane.source = _currentChatBox;
			_scrollPane.refreshPane();
			_scrollPane.validateNow();
			_scrollPane.update();
			_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
		}
		
		public function setSize(width:Number,height:Number):void
		{
			_scrollPane.setSize(width,height - 2);
			_scrollPane.source = _currentChatBox;
			_scrollPane.validateNow();
			_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
		}
		
		public function updateTabBarData():void
		{
			
		}

		public function get currentHeight():Number
		{
			return _currentHeight;
		}
		
		public function set scrollAplha(value:Number):void
		{
			_scrollPane.verticalScrollBar.alpha = value;
		}
		
		/**
		 * 添加历史记录 
		 * @param msg
		 * @param type
		 * 
		 */		
		public function addSystemMsg(msg:String,type:MsgTypeImpl):void
		{
			msgBox.addMsg(msg,type);
			if(_currentChatBox == msgBox)
			{
				var isAtMaxScrollPosition:Boolean = _scrollPane.verticalScrollPosition == _scrollPane.maxVerticalScrollPosition;
				var holdPosition:Number = _scrollPane.verticalScrollPosition;
				var firstHeigth:Number = 0;
				var isMaxLength:Boolean = msgBox.isMaxLength();
				if(isMaxLength)
				{
					firstHeigth = msgBox.getMsgAtIndex(0).height - msgBox.verticalGap;
					holdPosition -= firstHeigth;
				}
			}
			_scrollPane.validateNow();
			_scrollPane.update();
			
			holdPosition = holdPosition >= 0?holdPosition:0;
			if(isAtMaxScrollPosition)
			{
				_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
			}
			else
			{
				_scrollPane.verticalScrollPosition = holdPosition;
			}
		}
		
		/**
		 * 清理当前面板信息 
		 * 
		 */		
		public function clearCurrentMsg():void
		{
			if(_currentChatBox is ChatBox)
			{
				(_currentChatBox as ChatBox).reset();
			}
			else if(_currentChatBox is ChatMsgBox)
			{
				(_currentChatBox as ChatMsgBox).clear();
			}
			_scrollPane.validateNow();
			_scrollPane.update();
			_scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
		}
	}
}