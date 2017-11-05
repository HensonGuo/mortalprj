/**
 * @date 2011-3-9 下午08:33:17
 * @author  hexiaoming
 *
 */
package mortal.game.view.chat
{
	import Message.Game.EFriendFlag;
	import Message.Game.SChatMsg;
	import Message.Game.SPet;
	import Message.Public.EChatType;
	import Message.Public.EPlayerItemPosType;
	import Message.Public.SEntityId;
	import Message.Public.SMiniPlayer;
	import Message.Public.SPlayerItem;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.ChatFraudFilter;
	
	import extend.language.Language;
	
	import flash.utils.getTimer;
	
	import mortal.common.global.ParamsConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.msgTip.MsgTypeImpl;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.view.chat.chatPrivate.ChatData;
	import mortal.game.view.chat.chatPrivate.ChatManager;
	import mortal.game.view.chat.chatPrivate.ChatWindow;
	import mortal.game.view.chat.chatViewData.ChatCellData;
	import mortal.game.view.chat.chatViewData.ChatMessageWorking;
	import mortal.game.view.chat.chatViewData.ChatType;
	import mortal.game.view.chat.data.ChatShowPoint;
	import mortal.game.view.chat.data.FaceAuthority;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;

	public class ChatController extends Controller
	{
		private var _chatModule:ChatModule;
		private var _sendItemList:Array = new Array();
		private var _sendPetList:Array = new Array();
		private var _sendMapPoint:Array = new Array();
		
		public function ChatController()
		{
			super();
		}

		override protected function initView():IView
		{
			if (_chatModule == null)
			{
				_chatModule = new ChatModule();
				_chatModule.x = 0;
				_chatModule.layer = LayerManager.uiLayer;
			}
			return _chatModule;
		}

		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.ChatSend, sendChatHandler);
			Dispatcher.addEventListener(EventName.ChatPrivateSend, sendchatPrivateHandler);
			Dispatcher.addEventListener(EventName.ChatPrivate, chatPrivateHandler);
			Dispatcher.addEventListener(EventName.ChatShowItem, chatShowHandler);
			Dispatcher.addEventListener(EventName.ChatShowPet, chatShowPetHandler);
			Dispatcher.addEventListener(EventName.ChatShowPoint,chatShowPointHandler);
			Dispatcher.addEventListener(EventName.ChatShield,shieldHandler);
			Dispatcher.addEventListener(EventName.ChatCopyUpRecord,copyUpRecordHandler);

			Dispatcher.addEventListener(EventName.Scene_Update,onSceneUpdateHandler);
			
			NetDispatcher.addCmdListener(ServerCommand.ChatMessageUpdate, chatMessageHandler);
			NetDispatcher.addCmdListener(ServerCommand.GetRoleList,onMiniPlayerHandler);
			NetDispatcher.addCmdListener(ServerCommand.GroupPlayerInfoChange,onGroupChange);
		}
		
		//保存最后一次聊天的内容
		private var _lastChatContent:String;
		private var _lastChatRepeatTime:int = 0;
		private var _lastSendItemList:Array = new Array();
		private var _lastSendPetList:Array = new Array();
		private var _lastChatShowPointList:Array = new Array();
		
		private const chatShowItemMaxNum:int = 3;
		
		private function copyUpRecordHandler(e:DataEvent):void
		{
			if(_lastChatContent)
			{
				_chatModule.addInputText(_lastChatContent);
				(view as ChatModule).setChatInputFocus();
				_sendItemList.splice(0);
				_sendItemList = _sendItemList.concat(_lastSendItemList);
				_sendPetList.splice(0);
				_sendPetList = _sendPetList.concat(_lastSendPetList);
				_sendMapPoint.splice(0);
				_sendMapPoint = _sendMapPoint.concat(_lastChatShowPointList);
			}
		}
		
		private var haveQQInfoNum:int=0;//QQ信息次数 
		
		private function sendChatHandler(e:DataEvent):void
		{
			var obj:Object=e.data;
			var area:String=obj["area"];
			var content:String=obj["content"];
			var chatColor:uint = 0;
			var chatType:int=getChatTypeByArea(area);
			var chatTypeEx:Array = [];
//			content = content.replace(/ /g,"");
			
			if(obj.hasOwnProperty("color"))
			{
				chatColor = obj["color"];
			}
			if(area == ChatArea.World && Cache.instance.role.entityInfo.level < 10)
			{
				addTipMsg("未到10级不能在世界频道发言",ChatType.Tips);
				return;
			}
			if(area == ChatArea.Scene && Cache.instance.role.entityInfo.level < 20)
			{
				addTipMsg(Language.getString(40688),ChatType.Tips,ChatArea.Scene);
				return;
			}
			if(area == ChatArea.World || area == ChatArea.Country || area == ChatArea.Union
				|| area == ChatArea.Team || area == ChatArea.Scene
			)
			{
				if(_lastChatContent == content)
				{
					_lastChatRepeatTime++;
				}
				else
				{
					_lastChatRepeatTime = 0;
				}
				if(_lastChatRepeatTime >= 5)
				{
					//提示请勿重复发言
					addTipMsg("请勿重复发言",ChatType.Tips,area);
					(view as ChatModule).clearCD();
					return;
				}
				_lastChatContent = content;
				_lastSendItemList.splice(0);
				_lastSendItemList = _lastSendItemList.concat(_sendItemList);
				_lastSendPetList.splice(0);
				_lastSendPetList = _lastSendPetList.concat(_sendPetList);
				_lastChatShowPointList.splice(0);
				_lastChatShowPointList = _lastChatShowPointList.concat(_sendMapPoint);
			}
			var index:int;
			var isHaveQQInfo:Boolean = false;
			if( cache.role.entityInfo.level < ParamsConst.instance.chatLimitLevel )
			{
				if( hasUrl(content) )
				{
					isHaveQQInfo = true;
				}
				else
				{
					isHaveQQInfo =   (area == ChatArea.World || area == ChatArea.Country || area == ChatArea.Speaker) && hasQQInfo(content);
				}
			}
//			if( (isHaveQQInfo || ChatFraudFilter.isChatFraud(content)) && !(cache.title.isGM || cache.title.isGuide) )
//			{
//				var publicMiniInfo:SPublicMiniPlayer = new SPublicMiniPlayer();
//				publicMiniInfo.name = cache.role.entityInfo.name;
//				publicMiniInfo.sex = cache.role.entityInfo.sex;
//				publicMiniInfo.camp = cache.role.entityInfo.camp;
//				publicMiniInfo.level = cache.role.entityInfo.level;
//				publicMiniInfo.entityId = cache.role.entityInfo.entityId;
//				(view as ChatModule).updateChatMesssage(area,new PlayerMiniInfo(publicMiniInfo), "：" + content,[],[],-1,null);
//				(view as ChatModule).clearInput();
//				_sendItemList = new Array();
//				_sendPetList = new Array();
//				_sendMapPoint = new Array();
//				return;
//			}
			if(area == ChatArea.Team)
			{
				if(!cache.group.isInGroup)
				{
					MsgManager.showRollTipsMsg("你没有加入任何队伍");
					return;
				}
			}
			if(area == ChatArea.Union && !cache.guild.selfGuildInfo.selfHasJoinGuild)
			{
				MsgManager.showRollTipsMsg("你没有加入任何公会");
				return;
			}
			var iCurrentSHowNum:int = 0;
			if (content != "")
			{
				var playerItems:Array = new Array();
				var petInfos:Array = new Array();
				//判断content是否炫耀
				if(_sendItemList.length >0)
				{
					for each(var itemData:ItemData in _sendItemList)
					{
						if(iCurrentSHowNum >= chatShowItemMaxNum )
						{
							break;
						}
						var itemName:String = "[" + itemData.itemInfo.name + "]";
						index = content.indexOf(itemName);
						if(index >= 0)
						{
							var strItemPosUid:String = "[" + itemData.serverData.posType.toString() + "," + itemData.serverData.uid + "]";
//							chatTypeEx.push(EChatTypeEx._EChatTypeExShow);
							content = content.replace(itemName,strItemPosUid);
							playerItems.push(itemData.serverData);
							iCurrentSHowNum++;
						}
					}
				}
				//判断content是否炫耀宠物
				if(_sendPetList.length >0)
				{
					for each(var pet:SPet in _sendPetList)
					{
						if(iCurrentSHowNum >= chatShowItemMaxNum )
						{
							break;
						}
						var petName:String = pet.publicPet.name;//ChatMessageWorking.getPetName(sPetInfo);
						petName = "[" + petName + "]";
						index = content.indexOf(petName);
						if(index >= 0)
						{
							var strPetUid:String = "[" + EPlayerItemPosType._EPlayerItemPosTypePet + "," + pet.publicPet.uid + "]";
//							if(chatTypeEx.indexOf(EChatTypeEx._EChatTypeExShow) == -1)
//							{
//								chatTypeEx.push(EChatTypeEx._EChatTypeExShow);
//							}
							content = content.replace(petName,strPetUid);
							petInfos.push(pet);
							iCurrentSHowNum++;
						}
					}
				}
				var isHaveMapPoint:Boolean = false;
				//判断content是否发送坐标点
				if(_sendMapPoint.length > 0)
				{
					for each(var mapPoint:ChatShowPoint in _sendMapPoint)
					{
						var strMapPoint:String = mapPoint.mapNameString();
						if(strMapPoint)
						{
							index = content.indexOf(strMapPoint);
							if(index >= 0)
							{
								isHaveMapPoint = true;
//								chatType = EChatType._EChatTypeSendPos|chatType;
//								chatTypeEx.push(EChatTypeEx._EChatTypeExSendPos);
								content = content.replace(strMapPoint,mapPoint.mapIdString());
							}
						}
					}
				}
//				if(!isHaveMapPoint)// && !(area == ChatArea.Union || area == ChatArea.Team))
//				{
//					MsgManager.showRollTipsMsg(Language.getString(40681));
//					return;
//				}
				GameProxy.chat.SendMessage(chatType, content,chatColor,playerItems,petInfos,chatTypeEx);
				(view as ChatModule).clearInput();
				_sendItemList = new Array();
				_sendPetList = new Array();
				_sendMapPoint = new Array();
			}
		}
		
		private function chatShowHandler(e:DataEvent):void
		{
			//添加物品到聊天
			var itemData:ItemData=e.data as ItemData;
			_sendItemList.push(itemData);
			(view as ChatModule).addInputText("[" + itemData.itemInfo.name + "]");
			(view as ChatModule).setChatInputFocus();
		}

		private function chatShowPetHandler(e:DataEvent):void
		{
			//添加宠物到聊天
			var sPetInfo:SPet = e.data as SPet;
			_sendPetList.push(sPetInfo);
			var petName:String = sPetInfo.publicPet.name;//ChatMessageWorking.getPetName(sPetInfo);
			petName = "[" + petName + "]";
			(view as ChatModule).addInputText(petName);
			(view as ChatModule).setChatInputFocus();
		}
		
		/**
		 * 聊天炫耀坐标点 
		 * @param e
		 * 
		 */
		private function chatShowPointHandler(e:DataEvent):void
		{
			var chatShowPoint:ChatShowPoint = e.data as ChatShowPoint;
			_sendMapPoint.push(chatShowPoint);
		}
		
		private function shieldHandler(e:DataEvent):void
		{
			var isShield:Boolean = e.data["isShield"];
			var shieldLabel:String = e.data["label"];
			addTipMsg(shieldLabel + "信息已" + (isShield?"屏蔽":"开启"),ChatType.System,ChatMessageWorking.getNameByLabel(shieldLabel));
		}
		
		private function chatMessageHandler(obj:Object):void
		{
			var time:int = getTimer();
			var sChatMsg:SChatMsg = obj as SChatMsg;
			var chatType:int=sChatMsg.chatType;
//			var chatTypeEx:Array = sChatMsg.chatTypeEx;
			var content:String=sChatMsg.content;
			var chatColor:uint = sChatMsg.font;
			var fromPlayer:SMiniPlayer = sChatMsg.fromPlayer;
			var itemList:Array = new Array();
			var petList:Array = sChatMsg.pets;
			var date:Date=sChatMsg.chatDt;
			
			//不符合规则，直接屏蔽。。。骗子发的广告信息
//			//有物品信息不检测
//			if(fromPlayer.level < ParamsConst.instance.chatLimitLevel && sChatMsg.playerItems.length == 0 && sChatMsg.petInfos.length == 0)
//			{
//				var isHaveQQInfo:Boolean = (chatType == EChatType._EChatTypeWorld || chatType == EChatType._EChatTypePrivate || chatType == EChatType._EChatTypeCamp || chatType == EChatType._EChatTypeTrumpet) && hasQQInfo(content);
//				if((isHaveQQInfo || ChatFraudFilter.isChatFraud(content)) && !(sChatMsg.gmFlag || sChatMsg.guideFlag))
//				{
//					//大喇叭消息
//					if(chatType == EChatType._EChatTypeTrumpet && sChatMsg.fromPlayer.entityId.id == cache.role.entityInfo.entityId.id)
//					{
//						NetDispatcher.dispatchCmd(ServerCommand.ChatTrumpetMessageUpdate,obj);
//					}
//					return;
//				}
//			}
			
			//大喇叭消息
			if(chatType == EChatType._EChatTypeTrumpet)
			{
				var msgTypeImpl:MsgTypeImpl = new MsgTypeImpl(null,"0xFFCC00",15000);
				MsgManager.addSpeakerText(fromPlayer,sChatMsg.content,msgTypeImpl);
			}
			
//			if(sChatMsg.chatType == EChatType._EChatTypeGuild)
//			{
//				if(sChatMsg.extend.length > 0)
//				{
//					playerMiniInfo.post = sChatMsg.extend[0];
//				}
//				if(sChatMsg.extend.length > 1)
//				{
//					playerMiniInfo.worldPost = sChatMsg.extend[1];
//				}
//			}
//			else
//			{
//				if(sChatMsg.extend.length > 0)
//				{
//					playerMiniInfo.worldPost = sChatMsg.extend[0];
//				}
//			}
			
//			if(sChatMsg.gmFlag)
//			{
//				playerMiniInfo.isGM = true;
//			}
//			if(sChatMsg.guideFlag)
//			{
//				playerMiniInfo.isGuide = true;
//			}
			var selfName:String=cache.role.entityInfo.name;
			var isPlayerInBlackList:Boolean=cache.friend.findRecordByRoleId(fromPlayer.entityId.id, EFriendFlag._EFriendFlagBlackList) ? true : false;
			//私聊, 且不在黑名单之列
			if (chatType == EChatType._EChatTypePrivate && !isPlayerInBlackList)
			{
				if (selfName != fromPlayer.name && selfName != sChatMsg.toPlayer)
				{
					//收到不是自己的私聊消息  忽略
					return;
				}
				var chatPrivateData:ChatData = new ChatData();
				chatPrivateData.copyFromChatMsg(sChatMsg);
				//添加到最近联系人
//				cache.friend.addToRecent();
//				(GameController.friend.view as FriendsModule).updateRecentTalkList(cache.friend.recentTalkList);
				//别人发出的消息
				//if (selfName != playerMiniInfo.playerName) songsiting 2012.10.23
				if( !EntityUtil.equal(cache.role.entityInfo.entityId,fromPlayer.entityId))
				{
					if(!cache.friend.isRecent(fromPlayer.entityId.id))
					{
						cache.friend.addToRecent(fromPlayer);
					}
					
					//需要屏蔽黑名单  或者设置了陌生人的消息
//					var isRefusedToStranger:Boolean=cache.personalSetCache.isRefusedToStranger;
//					var isFriend:Boolean=cache.friend.getFriendInfoByPlayerName(playerMiniInfo.playerName, EFriendFlag._EFriendFlagFriend) ? true : false;
//					var isEnemy:Boolean=cache.friend.getFriendInfoByPlayerName(playerMiniInfo.playerName, EFriendFlag._EFriendFlagEnemy) ? true : false;

//					if (isPlayerInBlackList || isRefusedToStranger && !isFriend && !isEnemy)
//					{
//						//不做处理
//					}
//					else
//					{
						ChatManager.addWindow(fromPlayer);
						ChatManager.addMessage(chatPrivateData);
						// 记录最近联系人
//						Dispatcher.dispatchEvent(new DataEvent(EventName.FriendPrivateChatRecord, fromPlayer));
						//自动回复
//						var isAutoReply:Boolean=cache.personalSetCache.isAutoReply;
//						var autoReplyText:String=cache.personalSetCache.autoReplyText;
//						if (isAutoReply)
//						{
//							Dispatcher.dispatchEvent(new DataEvent(EventName.ChatPrivateSend, {content: autoReplyText, toPlayer: playerMiniInfo}));
//						}
//					}
				}
				//自己发出的消息
				else
				{
					if(!cache.friend.isRecent(sChatMsg.toEntityId.id))
					{
						GameProxy.player.findMiniPlayerById([sChatMsg.toEntityId.id],1);
					}
					ChatManager.addMessage(chatPrivateData);
//					// 记录最近联系人
//					var info:PlayerMiniInfo = (view as ChatModule).getChatPlayerInfoByName(sChatMsg.toPlayerName);
//					if(info != null)
//					{
//						Dispatcher.dispatchEvent(new DataEvent(EventName.FriendPrivateChatRecord, info));
//					}
				}
			}
			
				if(isPlayerInBlackList)
				{
					return;
				}
				
//				if(chatTypeEx.indexOf(EChatTypeEx._EChatTypeExShow) >= 0)
//				{	
				if(sChatMsg.items && sChatMsg.items.length >= 0)
				{	
					for(var j:int = 0;j< sChatMsg.items.length;j++)
					{
						itemList.push(new ItemData(sChatMsg.items[j] as SPlayerItem));
					}
//					chatType ^= EChatType._EChatTypeShow;
				}
//				if(chatTypeEx.indexOf(EChatTypeEx._EChatTypeExSendPos) >= 0)
//				{
////					chatType ^= EChatType._EChatTypeSendPos;
//				}
				var typeArea:String=getNameByChatType(chatType);
				if(typeArea == ChatArea.Scene || typeArea == ChatArea.Team)
				{
					var cellVector:Vector.<ChatCellData> = ChatMessageWorking.getCellDatas(content,itemList,petList,-1,12,FaceAuthority.getPlayerAuthority(fromPlayer));
					var contentAnalyze:String = "";
					for(var m:int = 0;m<cellVector.length;m++)
					{
						contentAnalyze+=cellVector[m].text;
					}
//					ThingUtil.entityUtil.entityTalk(playerMiniInfo.entityId,contentAnalyze);
//					if( typeArea == ChatArea.Team )
//					{
//						GameController.gameui.getGameui().teamAvatarSprite.teamTalk(playerMiniInfo.entityId,contentAnalyze);
//					}
				}
				
				//屏蔽其他国家
				if (!(typeArea == ChatArea.Country && fromPlayer.camp != cache.role.entityInfo.camp))
				{
					if(typeArea == ChatArea.Union)
					{
//						(view as ChatModule).addGuildChatWindow();
//						if(chatType == EChatType._EChatTypeGuildRoll)
//						{
//							var diceNumber:int = int(content);
//							content = ChatMessageWorking.getDiceText(playerMiniInfo.playerName,diceNumber);
//							(view as ChatModule).updateGuildChatMessage(playerMiniInfo, date, content,itemList,sChatMsg.petInfos,chatColor,true);
//							return;
//						}
//						(view as ChatModule).updateGuildChatMessage(playerMiniInfo, date, content,itemList,sChatMsg.petInfos,chatColor);
					}
					
//					if (typeArea == ChatArea.Scene && GameMapUtil.curMapState.isCrossMap) //
//					{
//						(view as ChatModule).addPublicCrossWindow();
//						(view as ChatModule).updatePublicCrossChatMessage(playerMiniInfo, date, content,itemList,sChatMsg.petInfos,chatColor);
//					}
					content="：" + content;
					(view as ChatModule).updateChatMesssage(typeArea, fromPlayer, content,itemList,petList,sChatMsg.force,sChatMsg);
				}
				Log.system(getTimer() - time);
//			}
		}
		
		private function hasQQInfo( value:String ):Boolean
		{
//			if( value.length >= 20)
//			{
				var str:String = ChatFraudFilter.delSpecialSymbols(value);
				if( str.length >= ParamsConst.instance.chatNumLimit )
				{
					return true;
				}
//			}
			return false;
		}
		
		private function hasUrl( value:String ):Boolean
		{
			value =  value.replace(/\s/g,"")
			if( value.length > 20 )
			{
				var reg:RegExp = /(http|https|ftp|file)?([:\/]*)([\w-]{2,}\.)+([A-Za-z]{2,6})+/ig;
				return reg.test(value);	
			}
			return false;
		}
		
		private function getChatTypeByArea(chatArea:String):int
		{
			var iType:int=EChatType._EChatTypeWorld;
			switch (chatArea)
			{
				case ChatArea.World:
					iType=EChatType._EChatTypeWorld;
					break;
				case ChatArea.Country:
					iType=EChatType._EChatTypeCamp;
					break;
				case ChatArea.Scene:
					iType=EChatType._EChatTypeSpace;
					break;
				case ChatArea.Union:
					iType=EChatType._EChatTypeGuild;
					break;
				case ChatArea.Team:
					iType=EChatType._EChatTypeTeam;
					break;
				case ChatArea.Secret:
					iType=EChatType._EChatTypePrivate;
					break;
				case ChatArea.Speaker:
					iType=EChatType._EChatTypeTrumpet;
					break;
				case ChatArea.Force:
					iType=EChatType._EChatTypeForce;
					break;
			}
			return iType;
		}

		private function getNameByChatType(iType:int):String
		{
			var typeName:String=ChatArea.World;
			switch (iType)
			{
				case EChatType._EChatTypeWorld:
					typeName=ChatArea.World;
					break;
				case EChatType._EChatTypeCamp:
					typeName=ChatArea.Country;
					break;
				case EChatType._EChatTypeTeam:
					typeName=ChatArea.Team;
					break;
				case EChatType._EChatTypeGuild:
					typeName=ChatArea.Union;
					break;
				case EChatType._EChatTypeSpace:
					typeName=ChatArea.Scene;
					break;
				case EChatType._EChatTypePrivate:
					typeName=ChatArea.Secret;
					break;
				case EChatType._EChatTypeTrumpet:
					typeName=ChatArea.Speaker;
					break;
				case EChatType._EChatTypeForce:
					typeName=ChatArea.Force;
					break;
			}
			return typeName;
		}
		
		/**
		 * 添加信息 给外部调用 
		 * @param obj
		 * @param type
		 * @param chatArea  显示区域
		 * @param analysisType  解析方式
		 * @param aryPlayer  当解析方式为2的时候需要填写
		 * @param baseColor  当解析方式为2的时候才有效
		 * 
		 */
		public function addTipMsg(obj:Object, type:String,chatArea:String = ChatArea.World,analysisType:int = 0,aryPlayer:Array = null,baseColor:int = 0xffffff):void
		{
			switch (type)
			{
				case ChatType.System:
				case ChatType.Tips:
				case ChatType.Union:
				case ChatType.State:
				case ChatType.Scene:
				case ChatType.Force:
				case ChatType.World:
				case ChatType.CrossServer:
						(view as ChatModule).updateTipMsg(type, obj as String,chatArea,analysisType,aryPlayer,baseColor);
					break;
			}
		}

		/**
		 * 添加系统信息 
		 * @param content
		 * 
		 */		
		public function addBackStageMsg(content:String,players:Array = null):void
		{
			if(!players)
			{
				players = [];
			}
			(view as ChatModule).updateTipMsg(ChatType.System, content,ChatArea.Complex,1,players);
		}
		
		public function addTypeRumorMsg(content:String,aryPlayer:Array,chatType:String = null):void
		{
			if(!chatType)
			{
				chatType = ChatType.Legent;
			}
			if(!SystemSetting.instance.isHideRumorTips.bValue || chatType != ChatType.Legent)
			{
				(view as ChatModule).addRumorMsg(content,aryPlayer,chatType);
			}
		}
		
		/**
		 * 添加副本消息 
		 * @param content
		 * @param aryPlayer
		 * @param chatType
		 * 
		 */
		public function addCopyMsg(content:String,aryPlayer:Array):void
		{
			if(!cache.group.players.length)
			{
				(view as ChatModule).addCopyMsg(content,aryPlayer);
			}
		}
		
		//发起私聊
		private function chatPrivateHandler(e:DataEvent):void
		{
			var miniPlayer:SMiniPlayer = e.data as SMiniPlayer;
			if(EntityUtil.equal(miniPlayer.entityId,cache.role.entityInfo.entityId))
			{
				return;
			}
			var objWindow:ChatWindow = ChatManager.addWindow(miniPlayer);
			objWindow.show();
			objWindow.inputText.setFocus();
			if(EntityUtil.isSameServerByRole(miniPlayer.entityId))
			{
				GameProxy.player.findMiniPlayerById([miniPlayer.entityId.id]);
			}
		}
		
		private function onMiniPlayerHandler(ary:Array):void
		{
			var miniPlayer:SMiniPlayer = ary[0];
			ChatManager.updateMiniPlayer(miniPlayer);
		}
		
		//私聊发送
		private function sendchatPrivateHandler(e:DataEvent):void
		{
			var obj:Object = e.data;
			var content:String = obj["content"];
			var toPlayer:SMiniPlayer = obj["toPlayer"];
			var color:int = obj["color"];
			
			var isHaveQQInfo:Boolean = false;
			if( cache.role.entityInfo.level < ParamsConst.instance.chatLimitLevel )
			{
				isHaveQQInfo = hasQQInfo(content);
			}
			//小于14级的玩家不能私聊，低于45级的玩家不能发带有qq信息和关键字信息的内容
//			if( ((isHaveQQInfo || ChatFraudFilter.isChatFraud(content)) && !(cache.title.isGM || cache.title.isGuide)) || cache.role.entityInfo.level < ParamsConst.instance.chatPrivateLevel)
//			{
//				var chatPrivateData:ChatPrivateData = new ChatPrivateData();
//				chatPrivateData.chatColor = color;
//				chatPrivateData.chatWindowName = toPlayer.name;
//				chatPrivateData.crossFlag = EntityUtil.isSameServerByRole(toPlayer.entityId);
//				chatPrivateData.chatWindowEntityId = toPlayer.entityId;
//				chatPrivateData.chatFromPlayerName = cache.role.entityInfo.name;
//				chatPrivateData.date = new Date();
//				chatPrivateData.content = content;
//				chatPrivateData.faceAuthority = Cache.instance.role.playerInfo.VIP > 0?3:1;
//				ChatManager.addMessage(chatPrivateData);
//				return;
//			}
			var chatMsg:SChatMsg = new SChatMsg();
			chatMsg.chatDt = new Date();
			chatMsg.toEntityId = toPlayer.entityId;
			chatMsg.content = content;
			chatMsg.font = color;
			chatMsg.toPlayer = toPlayer.name;
			chatMsg.chatType = EChatType._EChatTypePrivate;
			var miniPlayer:SMiniPlayer = new SMiniPlayer();
			miniPlayer.entityId = new SEntityId();
			chatMsg.fromPlayer = miniPlayer;
			GameProxy.chat.SendMessageByStruct(chatMsg);
		}
		
		/**
		 * 队伍改变 
		 * @param obj
		 * 
		 */
		private function onGroupChange(obj:Object):void
		{
			(view as ChatModule).changeTabBar();
		}
		
		/**
		 *进入跨服场景 / 离开跨服场景 
		 * 
		 */		
		private function onSceneUpdateHandler(evt:DataEvent):void
		{
			(view as ChatModule).changeTabBar();
		}
	}
}