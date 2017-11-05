
/**
 * @date 2011-3-15 下午03:24:09
 * @author  hexiaoming
 * 
 * 炫耀用 [内容]
 * 表情 用 /数字
 * 
 */ 
package mortal.game.view.chat.chatViewData
{
	import Message.DB.Tables.TSysMsg;
	import Message.Game.SMarketItem;
	import Message.Game.SPet;
	import Message.Public.EPlayerItemPosType;
	import Message.Public.ESex;
	import Message.Public.SBroadcast;
	import Message.Public.SEntityId;
	import Message.Public.SMiniPlayer;
	import Message.Public.SPlayerItem;
	
	import com.gengine.utils.FilterText;
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	
	import extend.language.Language;
	
	import mortal.common.ResManager;
	import mortal.game.cache.Cache;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.ColorInfo;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.SysMsgConfig;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.view.chat.ChatArea;
	import mortal.game.view.chat.chatPanel.ChatStyle;
	import mortal.game.view.chat.data.ChatShowPoint;
	import mortal.game.view.chat.data.FaceAuthority;
	
	import mx.utils.StringUtil;

	public class ChatMessageWorking
	{
		public static function getChatTypeByAreaName(strArea:String):String
		{
			switch(strArea)
			{
				case ChatArea.World:
					return ChatType.World;
				case ChatArea.Country:
					return ChatType.State;
				case ChatArea.Scene:
					if(chatChannelsData.indexOf(crossObj) > -1)
					{
						return ChatType.CrossServer;
					}
					else
					{
						return ChatType.Scene;
					}
				case ChatArea.Union:
					return ChatType.Union;
				case ChatArea.Team:
					return ChatType.Team;
				case ChatArea.Secret:
					return ChatType.Secret;
				case ChatArea.Speaker:
					return ChatType.Speaker;
				case ChatArea.Force:
					return ChatType.Force;
				case ChatArea.CrossGrop:
					return ChatType.CrossGroup;
				case ChatArea.Group:
					return ChatType.Group;
				case ChatArea.GuildUnion:
					return ChatType.GuildUnion;
				default:
					return ChatType.World;
			}
		}
		
		public static var complexObj:Object = {name:ChatArea.Complex,label:"综合"};
		public static var worldObj:Object = {name:ChatArea.World,label:"世界"};
		public static var countryObj:Object = {name:ChatArea.Country,label:"国家"};
		public static var unionObj:Object = {name:ChatArea.Union,label:"公会"};
		public static var teamObj:Object = {name:ChatArea.Team,label:"组队"};
		public static var noTeamObj:Object = {name:ChatArea.Team,label:"求组"};
		public static var sceneObj:Object = {name:ChatArea.Scene,label:"场景"};
		public static var msgObj:Object = {name:"systemMsg",label:"系统"};
		public static var crossObj:Object = {name:ChatArea.Scene,label:"跨服"};
		public static var forceObj:Object = {name:ChatArea.Force,label:"势力"};
		public static var crossGroupObj:Object = {name:ChatArea.CrossGrop,label:ChatType.CrossGroup};
		public static var crossGroupNoTeamObj:Object = {name:ChatArea.CrossGrop,label:"求组"};
		public static var groupObj:Object = {name:ChatArea.Group,label:"团队"};//仙盟团队
		public static var guildUnionObj:Object = {name:ChatArea.GuildUnion,label:"联盟"};//联盟
		
		private static var _chatChannelsData:Array;
		
		public static function get chatChannelsData():Array
		{
			if(!_chatChannelsData)
			{
				_chatChannelsData = [worldObj,countryObj,unionObj,teamObj,sceneObj];
			}
			return _chatChannelsData;
		}
		
		private static var _chatShowAreaData:Array;
		
		public static function get chatShowAreaData():Array
		{
			if(!_chatShowAreaData)
			{
				_chatShowAreaData = [complexObj,worldObj,countryObj,unionObj,teamObj,sceneObj,msgObj];
			}
			return _chatShowAreaData;
		}
		
		/**
		 * 切换到天神战场 
		 * 
		 */		
		public static function changeToNewBattleField():void
		{
			chatChannelsData[3] = forceObj;
			chatChannelsData[4] = crossObj;
			
			chatShowAreaData[4] = forceObj;
			chatShowAreaData[5] = crossObj;
		}
		
		/**
		 * 切换到仙盟副本
		 * 
		 */		
		public static function changeToGuildGroup():void
		{
			chatChannelsData[3] = groupObj;
			
			chatShowAreaData[4] = groupObj;
		}
		
		/**
		 * 切换到联盟模式
		 * 
		 */		
		public static function changeToGuildUnion(isInGuildUnion:Boolean = false):void
		{
			if(isInGuildUnion)
			{
				chatChannelsData[1] = guildUnionObj;
				
				chatShowAreaData[2] = guildUnionObj;
			}
			else
			{
				chatChannelsData[1] = countryObj;
				
				chatShowAreaData[2] = countryObj;
			}
		}
		
		/**
		 * 切换到跨服地图 
		 * 
		 */
		public static function changeMap(isCross:Boolean):void
		{	
			if(isCross)
			{
				chatChannelsData[4] = crossObj;
				chatShowAreaData[5] = crossObj;
			}
			else
			{
				chatChannelsData[4] = sceneObj;
				chatShowAreaData[5] = sceneObj;
			}
		}
		
		/**
		 * 切换队伍 
		 * @param isGroup
		 * 
		 */		
		public static function changeGroup(isCrossGroupMap:Boolean,isCrossGroup:Boolean,isGroup:Boolean):void
		{
			if(isCrossGroupMap)
			{
				if(isCrossGroup)
				{
					chatChannelsData[3] = crossGroupObj;
					chatShowAreaData[4] = crossGroupObj;
				}
				else
				{
					chatChannelsData[3] = crossGroupNoTeamObj;
					chatShowAreaData[4] = crossGroupNoTeamObj;
				}
			}
			else 
			{
				if(isGroup)
				{
					chatChannelsData[3] = teamObj;
					chatShowAreaData[4] = teamObj;
				}
				else
				{
					chatChannelsData[3] = noTeamObj;
					chatShowAreaData[4] = noTeamObj;
				}
			}
		}
		
		private static  var _chatShowAllAreaData:Array;
		
		/**
		 * 聊天所有的显示区域 
		 * @return 
		 * 
		 */		
		public static function get chatShowAllAreaData():Array
		{
			if(!_chatShowAllAreaData)
			{
				_chatShowAllAreaData = [complexObj,worldObj,countryObj,unionObj,teamObj,sceneObj,msgObj];
//					{name:ChatArea.Force,label:Language.getString(40685)},
//					{name:ChatArea.CrossGrop,label:ChatType.CrossGroup},
//					{name:ChatArea.Group,label:Language.getString(40700)},
//					{name:ChatArea.GuildUnion,label:Language.getString(40701)},
			}
			return _chatShowAllAreaData;
		}
		
		public static function getNameByLabel(strLabel:String):String
		{
			var name:String = ChatArea.World;
			var obj:Object;
			for each(obj in chatChannelsData)
			{
				if(obj["label"] == strLabel)
				{
					name = obj["name"];
					break;
				}
			}
			return name;
		}
		
		/**
		 * 得到势力的CellData 
		 * @param playerInfo
		 * @return 
		 * 
		 */		
		public static function getForcePlayerCellData(miniPlayer:SMiniPlayer,force:int,fontSize:int = 12):Vector.<ChatCellData>
		{
			var nameColor:uint = 0;
			var cellVector:Vector.<ChatCellData>= new Vector.<ChatCellData>();
			
//			var sexCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//			sexCellData.init(CellDataType.IMAGE);
//			sexCellData.className = miniPlayer.sexImageName;
//			sexCellData.elementFormat = ChatStyle.getImageFormat(2,fontSize);
//			cellVector.push(sexCellData);
//			
//			var info:DefInfo = GameDefConfig.instance.getForceShort(force);
//			if(GameMapUtil.curMapState.isRobFlag)
//			{
//				info = GameDefConfig.instance.getRobFlagForce(force);
//			}
//			var chatCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//			chatCellData.init(CellDataType.GENERAL,"[" + info.name + "][" + PlayerUtil.getProxyMsg(playerInfo.entityId) + "]");
//			chatCellData.elementFormat = ChatStyle.getContentFormat(parseInt(info.text1.slice(1),16),fontSize);
//			cellVector.push(chatCellData);
//			
//			var nameCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//			nameCellData.init(CellDataType.PLAYER,"[" + playerInfo.playerName + "]");
//			nameColor = ColorConfig.instance.getCampColor(playerInfo.camp).intColor;
//			nameCellData.elementFormat = ChatStyle.getPlayerNameFormat(nameColor,fontSize);
//			nameCellData.data = playerInfo;
//			cellVector.push(nameCellData);
			return cellVector;
		}
		
		public static function getPlayerCellData(miniPlayer:SMiniPlayer,fontSize:int = 12):Vector.<ChatCellData>
		{
			var nameColor:uint = 0;
			var cellVector:Vector.<ChatCellData>= new Vector.<ChatCellData>();
			
//			if(miniPlayer.isGM)
//			{
//				var gmCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//				gmCellData.init(CellDataType.GM,"[GM]");
//				gmCellData.elementFormat = ChatStyle.getGMFormat(fontSize);
//				cellVector.push(gmCellData);
//			}
//			
//			if(miniPlayer.isGuide)
//			{
//				var guideCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//				guideCellData.init(CellDataType.Guide,Language.getString(40641));
//				guideCellData.elementFormat = ChatStyle.getGMFormat(fontSize);
//				cellVector.push(guideCellData);
//			}
			
			var nameCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
			nameCellData.init(CellDataType.PLAYER,"[" + miniPlayer.name + "]");
			nameColor = ColorConfig.instance.getCampColor(miniPlayer.camp).intColor;
			nameCellData.elementFormat = ChatStyle.getPlayerNameFormat(nameColor,fontSize);
			nameCellData.data = miniPlayer;
			cellVector.push(nameCellData);
			return cellVector;
		}
		
		/**
		 *  
		 * @param playerInfo
		 * @param nameColor 名称的颜色
		 * @return 
		 * 
		 */		
		public static function getCellDataByPlayerInfo(miniPlayer:SMiniPlayer,nameColor:int = -1,isShowUnionPost:Boolean = false,fontSize:int = 12):Vector.<ChatCellData>
		{
			if(nameColor == -1)
			{
				nameColor = ChatStyle.getChatContentColor();
			}
			var cellVector:Vector.<ChatCellData>= new Vector.<ChatCellData>();
			
			var sexCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
			sexCellData.init(CellDataType.IMAGE);
			sexCellData.className = (miniPlayer.sex == ESex._ESexMan)?ImagesConst.Chat_Man:ImagesConst.Chat_Woman;
			sexCellData.elementFormat = ChatStyle.getImageFormat(4,fontSize);
			cellVector.push(sexCellData);
			
//			if(playerInfo.isVIP)
//			{
//				var vipCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//				vipCellData.init(CellDataType.VIP);
//				vipCellData.data = playerInfo.intVIP;
//				vipCellData.className = playerInfo.vipBitmapName;
//				vipCellData.elementFormat = ChatStyle.getImageFormat(5,fontSize);
//				cellVector.push(vipCellData);
//			}
//			
//			if(playerInfo.isGM)
//			{
//				var gmCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//				gmCellData.init(CellDataType.GM,"[GM]");
//				gmCellData.elementFormat = ChatStyle.getGMFormat(fontSize);
//				cellVector.push(gmCellData);
//			}
//			
//			if(playerInfo.isGuide)
//			{
//				var guideCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//				guideCellData.init(CellDataType.Guide,Language.getString(40641));
//				guideCellData.elementFormat = ChatStyle.getGMFormat(fontSize);
//				cellVector.push(guideCellData);
//			}
			
			var campCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
			var campName:String = GameDefConfig.instance.getECamp(miniPlayer.camp).text;
			campCellData.init(CellDataType.CAMP,"[" + campName + "]");//(playerInfo.isVIP?"[":" [") + playerInfo.campShortName + "]");
			campCellData.elementFormat = ChatStyle.getCampFormat(miniPlayer.camp,fontSize);
			cellVector.push(campCellData);
			
			var proxyServer:String = "";
			if(!EntityUtil.isSameServerByRole(miniPlayer.entityId))
			{
				proxyServer = "[" + EntityUtil.getProxyName(miniPlayer.entityId) + "]";
			}
			var nameCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
			nameCellData.init(CellDataType.PLAYER,proxyServer + "[" + miniPlayer.name + "]");
			nameColor = ColorConfig.instance.getCampColor(miniPlayer.camp).intColor;
			nameCellData.elementFormat = ChatStyle.getPlayerNameFormat(nameColor,fontSize);
			nameCellData.data = miniPlayer;
			cellVector.push(nameCellData);
			
//			if(playerInfo.worldPost)
//			{
//				var worldPostCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//				worldPostCellData.init(CellDataType.GENERAL,"[" + playerInfo.worldPost + "]");
//				worldPostCellData.elementFormat = ChatStyle.getContentFormat(0xf0ea3f,fontSize);
//				cellVector.push(worldPostCellData);
//			}
//			
//			if(isShowUnionPost && playerInfo.post && playerInfo.post != Language.getString(40642))
//			{
//				var postCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
//				postCellData.init(CellDataType.GENERAL,"[" + playerInfo.post + "]");
//				postCellData.elementFormat = ChatStyle.getContentFormat(0xFF62f2,fontSize);
//				cellVector.push(postCellData);
//			}
			
			return cellVector;
		}
		
		private static var _faceList:Array;
		private static function get faceList():Array
		{
			if(!_faceList)
			{
				_faceList = new Array();
				for(var i:int = 72;i>0;i--)
				{
					_faceList.push("/" + i.toString() + " ");
					_faceList.push("/" + i.toString());
				}
			}
			return _faceList;
		}
		
		private static var _vipFaceList:Array;
		private static function get vipFaceList():Array
		{
			if(!_vipFaceList)
			{
				_vipFaceList = new Array();
				for(var i:int = 14;i>0;i--)
				{
					_vipFaceList.push("/b" + i.toString() + " ");
					_vipFaceList.push("/b" + i.toString());
				}
			}
			return _vipFaceList;
		}
		
		private static const maxFaceNum:int = 5;
		private static const maxVIPFaceNum:int = 3;
		
		/**
		 * 从聊天内容中获取包含炫耀信息的data 
		 * @param content
		 * @param itemList
		 * @return 
		 * 
		 */		
		public static function getCellDatas(content:String,itemList:Array = null,petList:Array = null,contentColor:int = -1,fontSize:int = 12,faceAuthority:int = 3):Vector.<ChatCellData>
		{
			if(contentColor == -1)
			{
				contentColor = ChatStyle.getChatContentColor();
			}
			//解析炫耀装备后的
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			vcChatCellData = getCellDatasAnalyzeShowItem(content,itemList,contentColor,fontSize);
			
			var i:int;
			//再解析炫耀宠物后的
			var vcChatCellData1:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			for(i = 0;i<vcChatCellData.length;i++)
			{
				if(vcChatCellData[i].type == CellDataType.GENERAL)
				{
					vcChatCellData1 = vcChatCellData1.concat(getCellDatasAnalyzeShowPet(vcChatCellData[i].text,petList,contentColor,fontSize));
				}
				else
				{
					vcChatCellData1.push(vcChatCellData[i]);
				}
			}
			//再解析炫耀表情后的
			var vcChatCellData2:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			for(i = 0;i< vcChatCellData1.length;i++)
			{
				if(vcChatCellData1[i].type == CellDataType.GENERAL)
				{
					vcChatCellData2 = vcChatCellData2.concat(getCellDataByContent(vcChatCellData1[i].text,contentColor,true,fontSize,faceAuthority));
				}
				else
				{
					vcChatCellData2.push(vcChatCellData1[i]);
				}
			}
			//再解析发送坐标的
			var vcChatCellData3:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			for(i = 0;i< vcChatCellData2.length;i++)
			{
				if(vcChatCellData2[i].type == CellDataType.GENERAL)
				{
					vcChatCellData3 = vcChatCellData3.concat(getCellDatasAnalyzeMapPoint(vcChatCellData2[i].text,contentColor,fontSize));
				}
				else
				{
					vcChatCellData3.push(vcChatCellData2[i]);
				}
			}
			return vcChatCellData3;
		}
		
		private static function getCellDatasAnalyzeShowItem(content:String,itemList:Array = null,contentColor:int = -1,fontSize:int = 12):Vector.<ChatCellData>
		{
			if(contentColor == -1)
			{
				contentColor = ChatStyle.getChatContentColor();
			}
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			var index:int;
			var chatCellData:ChatCellData;
		
			if(itemList && itemList.length > 0)
			{
				for(var i:int = 0;i<itemList.length;i++)
				{
					var itemData:ItemData = itemList[i];
					var strItemCode:String = "[" + itemData.posType + "," + itemData.uid + "]";
					index = content.indexOf(strItemCode);
					if(index >= 0)
					{
						//添加普通文本
						chatCellData = ObjectPool.getObject(ChatCellData);
						chatCellData.init(CellDataType.GENERAL,content.slice(0,index));
						chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
						vcChatCellData.push(chatCellData);
						//添加装备
						var strItemName:String = "[" + itemData.itemInfo.name + "]"; //+ (itemData.itemAmount > 1?(" x " + itemData.itemAmount.toString()):"");
						chatCellData = ObjectPool.getObject(ChatCellData);
						chatCellData.init(CellDataType.EQUIPMENT,strItemName);
						chatCellData.data = itemData;
						chatCellData.elementFormat = ChatStyle.getEquipmentFormat(itemData,fontSize);
						vcChatCellData.push(chatCellData);
						
						content = " " + content.slice(index + strItemCode.length);
						if(content.length == 0)
						{
							break;
						}
					}
					else
					{
						continue;
					}
				}
			}
			if(content.length > 0)
			{
				//添加普通文本
				chatCellData = ObjectPool.getObject(ChatCellData);
				chatCellData.init(CellDataType.GENERAL,content);
				chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
				vcChatCellData.push(chatCellData);
			}
			return vcChatCellData;
		}
		
		private static function getCellDatasAnalyzeShowPet(content:String,petList:Array = null,contentColor:int = -1,fontSize:int = 12):Vector.<ChatCellData>
		{
			if(contentColor == -1)
			{
				contentColor = ChatStyle.getChatContentColor();
			}
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			var index:int;
			var chatCellData:ChatCellData;
			if(petList && petList.length > 0)
			{
				for(var i:int = 0;i<petList.length;i++)
				{
					var petInfo:SPet = petList[i];
					var strPetCode:String = "[" + EPlayerItemPosType._EPlayerItemPosTypePet + ","+ petInfo.publicPet.uid + "]";
					index = content.indexOf(strPetCode);
					
					if(index >= 0)
					{
						//添加普通文本
						chatCellData = ObjectPool.getObject(ChatCellData);
						chatCellData.init(CellDataType.GENERAL,content.slice(0,index));
						chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
						vcChatCellData.push(chatCellData);
						//添加宠物
						var strPetName:String;
//						if(!petInfo.isBorrow)
//						{
							strPetName = petInfo.publicPet.name;//getPetName(petInfo);
							strPetName = "[" + strPetName + "]";
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.PET,strPetName);
							chatCellData.data = petInfo;
							chatCellData.elementFormat = ChatStyle.getPetFormat(petInfo,fontSize);
							vcChatCellData.push(chatCellData);
//						}
//						else
//						{
//							strPetName = "[";
//							chatCellData = ObjectPool.getObject(ChatCellData);
//							chatCellData.init(CellDataType.PET,strPetName);
//							chatCellData.data = petInfo;
//							chatCellData.elementFormat = ChatStyle.getPetFormat(petInfo,fontSize);
//							vcChatCellData.push(chatCellData);
//							
//							strPetName = Language.getString(40643);
//							chatCellData = ObjectPool.getObject(ChatCellData);
//							chatCellData.init(CellDataType.PET,strPetName);
//							chatCellData.data = petInfo;
//							chatCellData.elementFormat = ChatStyle.getContentFormat(GlobalStyle.color6Uint,fontSize);
//							vcChatCellData.push(chatCellData);
//							
//							strPetName = getPetName(petInfo) + "]";
//							chatCellData = ObjectPool.getObject(ChatCellData);
//							chatCellData.init(CellDataType.PET,strPetName);
//							chatCellData.data = petInfo;
//							chatCellData.elementFormat = ChatStyle.getPetFormat(petInfo,fontSize);
//							vcChatCellData.push(chatCellData);
//						}
						
						content = " " + content.slice(index + strPetCode.length);
						if(content.length == 0)
						{
							break;
						}
					}
					else
					{
						continue;
					}
				}
			}
			if(content.length > 0)
			{
				//添加普通文本
				chatCellData = ObjectPool.getObject(ChatCellData);
				chatCellData.init(CellDataType.GENERAL,content);
				chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
				vcChatCellData.push(chatCellData);
			}
			return vcChatCellData;
		}
		
		/**
		 * 获取解析坐标点后的数据 
		 * @param content
		 * @return 
		 * 
		 */	
		private static function getCellDatasAnalyzeMapPoint(content:String,contentColor:int = -1,fontSize:int = 12):Vector.<ChatCellData>
		{
			if(contentColor == -1)
			{
				contentColor = ChatStyle.getChatContentColor();
			}
			if(!content)
			{
				return new Vector.<ChatCellData>();
			}
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			if(content.length == 0)
			{
				return vcChatCellData;
			}
			var startPos:int = 0;
			var currentPos:int = 0;
			var tempPos:int = 0;
			var tempPos2:int = 0;
			var chatCellData:ChatCellData;
			var chatCellData2:ChatCellData;
			var paramArray:Array;
			//解析
			while(currentPos < content.length - 7)
			{
				//查找标签
				currentPos = content.indexOf("[",currentPos);
				tempPos2 = currentPos + 1;
				if(currentPos < 0)
				{
					break;
				}
				
				paramArray = new Array();
				tempPos =  content.indexOf("]",tempPos2);
				if(tempPos < 0)
				{
					break;
				}
				var strValue:String = content.substring(tempPos2,tempPos);
				var tempIndex:int = strValue.indexOf("[");
				if(tempIndex >= 0)
				{
					currentPos += tempIndex + 1;
					continue;
				}
				if(strValue.length <= 0)
				{
					currentPos = tempPos + 1;
					continue;
				}
				
				paramArray = strValue.split(",");

				if(paramArray.length < 3)
				{
					currentPos = tempPos + 1;
					continue;
				}
				var mapId:int = int(paramArray[0]);
				var mapX:int = int(paramArray[1]);
				var mapY:int = int(paramArray[2]);
				var chatMapInfo:ChatShowPoint = new ChatShowPoint(mapId,mapX,mapY);
				
				if(!chatMapInfo.mapNameString())
				{
					currentPos = tempPos + 1;
					continue;
				}
				
				if(currentPos > startPos)
				{
					chatCellData = ObjectPool.getObject(ChatCellData);
					chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
					chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
					vcChatCellData.push(chatCellData);
				}
				
				chatCellData2 = ObjectPool.getObject(ChatCellData);
				chatCellData2.init(CellDataType.RumorMapPoint,chatMapInfo.mapNameString());
				chatCellData2.data = {mapId:chatMapInfo.mapId,mapX:chatMapInfo.x,mapY:chatMapInfo.y};
				chatCellData2.elementFormat = ChatStyle.getRumorLink(fontSize);
				vcChatCellData.push(chatCellData2);
				
				chatCellData2 = ObjectPool.getObject(ChatCellData);
				chatCellData2.init(CellDataType.RumorFly);
				chatCellData2.data = {mapId:chatMapInfo.mapId,mapX:chatMapInfo.x,mapY:chatMapInfo.y};
				chatCellData2.elementFormat = ChatStyle.getImageFormat(2,fontSize);
				vcChatCellData.push(chatCellData2);
				
				startPos = tempPos + 1;
				currentPos = startPos;
			}
			
			if(startPos < content.length)
			{
				chatCellData = ObjectPool.getObject(ChatCellData);
				chatCellData.init(CellDataType.GENERAL,content.substring(startPos));
				chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
				vcChatCellData.push(chatCellData);
			}
			return vcChatCellData;
		}
														   
		/**
		 * 解析表情  
		 * @param content
		 * @param contentColor
		 * @param faceAuthority 表情权限
		 * @return 
		 * 
		 */
		public static function getCellDataByContent(content:String,contentColor:int = -1,isFilter:Boolean = true,fontSize:int = 12,faceAuthority:int = 3 ):Vector.<ChatCellData>
		{
			if(contentColor == -1)
			{
				contentColor = ChatStyle.getChatContentColor();
			}
			if(isFilter)
			{
				content = FilterText.instance.getFilterStr(content);
			}
			if(content.length == 0)
			{
				return new Vector.<ChatCellData>();
			}
			var faceNum:int = 0;
			var vipFaceNum:int = 0;
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>;
			var startPos:int = 0;
			var currentPos:int = 0;
			if(ResManager.instance.isFaceLoaded || ResManager.instance.isFaceVIPLoaded)
			{
				while(currentPos < content.length - 1)
				{
					if(faceNum >= maxFaceNum)
					{
						break;
					}
					currentPos = content.indexOf("/",currentPos);
					var bCut:Boolean = false;
					if(currentPos < 0)
					{
						break;
					}
					//处理转义
					if(content.charAt(currentPos + 1) == "/")
					{
						currentPos += 2;
						continue;
					}
					var code:String;
					var chatCellData:ChatCellData;
					var chatCellData2:ChatCellData;
					if( ResManager.instance.isFaceLoaded && faceAuthority | FaceAuthority.NORMAL)
					{
						for each(code in faceList)	
						{
							if(content.indexOf(code,currentPos) == currentPos)
							{
								bCut = true;
								if(currentPos>startPos)
								{
									chatCellData = ObjectPool.getObject(ChatCellData);
									chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos).replace("//","/"));
									chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
									vcChatCellData.push(chatCellData);
								}
								chatCellData2 = ObjectPool.getObject(ChatCellData);
								chatCellData2.init(CellDataType.MovieClip);
								chatCellData2.className = "a" + (int(StringUtil.trim(code.substring(1))) - 1);
								chatCellData2.text = code;
								chatCellData2.elementFormat = ChatStyle.getFaceFormat(fontSize);
								vcChatCellData.push(chatCellData2);
								startPos = currentPos + code.length;
								currentPos = startPos;
								faceNum ++;
								vipFaceNum ++
								break;
							}
						}
					}
					if(vipFaceNum < maxVIPFaceNum && ResManager.instance.isFaceVIPLoaded && faceAuthority & FaceAuthority.VIP)
					{
						for each(code in vipFaceList)	
						{
							if(content.indexOf(code,currentPos) == currentPos)
							{
								bCut = true;
								if(currentPos>startPos)
								{
									chatCellData = ObjectPool.getObject(ChatCellData);
									chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos).replace("//","/"));
									chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
									vcChatCellData.push(chatCellData);
								}
								chatCellData2 = ObjectPool.getObject(ChatCellData);
								chatCellData2.init(CellDataType.MovieClip);
								chatCellData2.className = "b" + (int(StringUtil.trim(code.substring(2))) - 1);
								chatCellData2.text = code;
								chatCellData2.elementFormat = ChatStyle.getVIPFaceFormat(fontSize);
								vcChatCellData.push(chatCellData2);
								startPos = currentPos + code.length;
								currentPos = startPos;
								faceNum ++;
								vipFaceNum++;
								break;
							}
						}
					}
					if(!bCut)
					{
						currentPos++;
					}
				}
			}
			if(startPos < content.length)
			{
				chatCellData = ObjectPool.getObject(ChatCellData);
				chatCellData.init(CellDataType.GENERAL,content.substring(startPos).replace("//","/"));
				chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
				vcChatCellData.push(chatCellData);
			}
			
			return vcChatCellData;
		}
		
		/**
		 * 解析html 附带解析表情 
		 * @param content
		 * @param contentColor
		 * @return 
		 * 
		 */		
		public static function getCellDatasFilterHtml(content:String,contentColor:int = -1,players:Array = null,fontSize:int = 12):Vector.<ChatCellData>
		{
			if(!players)
			{
				players = [];
			}
			if(contentColor == -1)
			{
				contentColor = ChatStyle.getChatContentColor();
			}
			content = content.replace("\n","");
			content = content.replace("\r","");
			
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>;
			var vcChatCellDataTemp:Vector.<ChatCellData>;
			
			if(content.length == 0)
			{
				return vcChatCellData;
			}
			var startPos:int = 0;
			var currentPos:int = 0;
			var tempPos:int = 0;
			var tempPos2:int = 0;
			while(currentPos < content.length - 10)
			{
				currentPos = content.indexOf("<a href=\"",currentPos);
				if(currentPos < 0)
				{
					break;
				}
				tempPos = currentPos + 9;
				tempPos = content.indexOf("\"",tempPos);
				if(tempPos < 0)
				{
					currentPos += 9;
					continue;
				}
				var linkUrl:String = content.substring(currentPos + 9,tempPos);
				tempPos2 = tempPos;
				tempPos = content.indexOf(">",tempPos);
				if(tempPos < 0)
				{
					currentPos += 9;
					continue;
				}
				tempPos2 = content.indexOf("</a>",tempPos);
				if(tempPos2 < 0)
				{
					currentPos += 9;
					continue;
				}
				
				var text:String = content.substring(tempPos + 1,tempPos2);
				
				if(currentPos > startPos)
				{
//					var chatCellData:ChatCellData = new ChatCellData(CellDataType.GENERAL,content.substring(startPos,currentPos));
//					chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor);
//					vcChatCellData.push(chatCellData);
					
					vcChatCellDataTemp = getCellDataByContent(content.substring(startPos,currentPos),contentColor,false,fontSize);
					vcChatCellData = vcChatCellData.concat(vcChatCellDataTemp);
				}
				
				var chatCellData2:ChatCellData = ObjectPool.getObject(ChatCellData);
				chatCellData2.elementFormat = ChatStyle.getLinkFormat(fontSize);
				chatCellData2.init(CellDataType.LINK);
				chatCellData2.text = text;
				chatCellData2.linkUrl = linkUrl;
				vcChatCellData.push(chatCellData2);
				startPos = tempPos2 + 4;
				currentPos = startPos;
			}
			if(startPos < content.length)
			{
//				chatCellData = new ChatCellData(CellDataType.GENERAL,content.substring(startPos));
//				chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor);
//				vcChatCellData.push(chatCellData);
				
				vcChatCellDataTemp = getCellDataByContent(content.substring(startPos),contentColor,false,fontSize);
				vcChatCellData = vcChatCellData.concat(vcChatCellDataTemp);
			}
			var vcChatCellDataLast:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			for(var i:int = 0;i<vcChatCellData.length;i++)
			{
				if(vcChatCellData[i].type == CellDataType.GENERAL)
				{
					vcChatCellDataLast = vcChatCellDataLast.concat(getCellDatasByAnalyzeRumor(vcChatCellData[i].text,players,vcChatCellData[i].elementFormat.color,false,-1,fontSize));
				}
				else
				{
					vcChatCellDataLast.push(vcChatCellData[i]);
				}
			}
			var vcChatCellDataLast2:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			for(var j:int = 0;j<vcChatCellDataLast.length;j++)
			{
				if(vcChatCellDataLast[j].type == CellDataType.GENERAL)
				{
					vcChatCellDataLast2 = vcChatCellDataLast2.concat(getCellDatasFilterFont(vcChatCellDataLast[j].text,vcChatCellDataLast[j].elementFormat.color,fontSize));
				}
				else
				{
					vcChatCellDataLast2.push(vcChatCellDataLast[j]);
				}
			}
			return vcChatCellDataLast2;
		}
		
		/**
		 * 解析font color
		 * @param content
		 * @param contentColor
		 * @return 
		 * 
		 */		
		public static function getCellDatasFilterFont(content:String,contentColor:int = -1,fontSize:int = 12):Vector.<ChatCellData>
		{
			if(contentColor == -1)
			{
				var contentColor:int = ChatStyle.getChatContentColor();
			}
			content = content.replace("\n","");
			content = content.replace("\r","");
			
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>;
			var chatCellData:ChatCellData;
			var vcChatCellDataTemp:Vector.<ChatCellData>;
			
			if(content.length == 0)
			{
				return vcChatCellData;
			}
			var startPos:int = 0;
			var currentPos:int = 0;
			var tempPos:int = 0;
			var tempPos2:int = 0;
			while(currentPos < content.length - 15)
			{
				currentPos = content.indexOf("<font color=\"",currentPos);
				if(currentPos < 0)
				{
					break;
				}
				tempPos = currentPos + 13;
				tempPos = content.indexOf("\"",tempPos);
				if(tempPos < 0)
				{
					currentPos += 13;
					continue;
				}
				var textColor:String = content.substring(currentPos + 13,tempPos);
				tempPos2 = tempPos;
				tempPos = content.indexOf(">",tempPos);
				if(tempPos < 0)
				{
					currentPos += 13;
					continue;
				}
				tempPos2 = content.indexOf("</font>",tempPos);
				if(tempPos2 < 0)
				{
					currentPos += 13;
					continue;
				}
				
				var text:String = content.substring(tempPos + 1,tempPos2);
				
				if(currentPos > startPos)
				{
					chatCellData = ObjectPool.getObject(ChatCellData);
					chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
					chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
					vcChatCellData.push(chatCellData);
				}
				
				var chatCellData2:ChatCellData = ObjectPool.getObject(ChatCellData);
				chatCellData2.elementFormat = ChatStyle.getContentFormat(parseInt(textColor.substr(1)),fontSize);
				chatCellData2.init(CellDataType.GENERAL,text);
				vcChatCellData.push(chatCellData2);
				startPos = tempPos2 + 7;
				currentPos = startPos;
			}
			if(startPos < content.length)
			{
				chatCellData = ObjectPool.getObject(ChatCellData);
				chatCellData.init(CellDataType.GENERAL,content.substring(startPos));
				chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
				vcChatCellData.push(chatCellData);
			}
			return vcChatCellData;
		}
		
		/**
		 * 解析传闻  内部标签格式：比如<MsgObj>PLAYER,1</MsgObj>
		 * @param content
		 * @param aryPlayer
		 * @param contentColor
		 * @return 
		 * 
		 */		
		public static function getCellDatasByAnalyzeRumor(content:String,aryPlayer:Array,contentColor:int = -1,isForArena:Boolean = false,area:int = -1,fontSize:int = 12):Vector.<ChatCellData>		{
			if(contentColor == -1)
			{
				contentColor = ChatStyle.getChatContentColor();
			}
			if(!content)
			{
				return new Vector.<ChatCellData>();
			}
			content = content.replace("\n","");
			content = content.replace("\r","");
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			if(content.length == 0)
			{
				return vcChatCellData;
			}
			var startPos:int = 0;
			var currentPos:int = 0;
			var tempPos:int = 0;
			var tempPos2:int = 0;
			var chatCellData:ChatCellData;
			var chatCellData2:ChatCellData;
			var paramArray:Array;
			//解析
			while(currentPos < content.length - 17)
			{
				//查找标签
				currentPos = content.indexOf("<MsgObj>",currentPos);
				tempPos2 = currentPos + 8;
				if(currentPos < 0)
				{
					break;
				}
				
				paramArray = new Array();
				tempPos =  content.indexOf("</MsgObj>",tempPos2);
				if(tempPos < 0)
				{
					break;
				}
				var strValue:String = content.substring(tempPos2,tempPos);
				if(strValue.length < 0)
				{
					currentPos = tempPos + 9;
					continue;
				}
				
				paramArray = strValue.split(",");
				var strLabelName:String = paramArray.shift();
				var playerId:int;
				var mapId:int;
				var mapX:int;
				var mapY:int;
				var npcId:int;
				var playerName:String;
				var camp:int;
				var playerNum:int;
				var miniPlayer:SMiniPlayer;
				var levelLimit:int;
				var guildId:int;
				var colorInfo:ColorInfo;
				var text:String;
				var intColor:int;
				var colorValue:String;
				switch(strLabelName)
				{
					case "LEVELLIMIT":
						if(paramArray.length < 1)
						{
							currentPos = tempPos + 9;
							break;
						}
						levelLimit = int(paramArray[0]);
						
						//如果等级不满足要求就直接返回空
						if(Cache.instance.role.entityInfo.level < levelLimit)
						{
							return new Vector.<ChatCellData>();
						}
						
						if(currentPos > startPos)
						{
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
							chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
							vcChatCellData.push(chatCellData);
						}
						
						startPos = tempPos + 9;
						currentPos = startPos;
						break;
					case "PLAYER":
						if(paramArray.length < 1)
						{
							currentPos = tempPos + 9;
							break;
						}
						var isShowCross:Boolean = false;
						if(paramArray.length >= 2)
						{
							isShowCross = true;
						}
						if(!isForArena)
						{
							playerNum = int(paramArray[0]);
							//服务器数据错误
							if(aryPlayer.length <= playerNum)
							{
								return new Vector.<ChatCellData>();
							}
						}
						miniPlayer = aryPlayer[playerNum] as SMiniPlayer;
						if(currentPos > startPos)
						{
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
							chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
							vcChatCellData.push(chatCellData);
						}
						if(!isForArena)
						{
							chatCellData2 = ObjectPool.getObject(ChatCellData);
							chatCellData2.init(CellDataType.RumorPlayer);
//							if(!isShowCross)
//							{
								chatCellData2.text = miniPlayer.name;
//							}
//							else
//							{
//								chatCellData2.text = PlayerUtil.getProxyAndName(playerMiniInfo.miniPlayer);
//							}
							chatCellData2.data = miniPlayer;
							chatCellData2.elementFormat = ChatStyle.getRumorPlayerNameFormat(ColorConfig.instance.getCampColor(miniPlayer.camp).intColor,fontSize);
							vcChatCellData.push(chatCellData2);
						}
						else
						{
							playerName = paramArray[0];
							chatCellData2 = ObjectPool.getObject(ChatCellData);
							chatCellData2.init(CellDataType.GENERAL,playerName);
							chatCellData2.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
							vcChatCellData.push(chatCellData2);
						}
						startPos = tempPos + 9;
						currentPos = startPos;
						break;
					case "ITEM":
						if(paramArray.length < 1)
						{
							currentPos = tempPos + 9;
							break;
						}
						var itemCode:int = int(paramArray.shift());
						var jsStr:String = "";
						if(paramArray.length > 0)
						{
							jsStr = paramArray.join(",");
						}
						
						var splayerItem:SPlayerItem = new SPlayerItem();
						splayerItem.itemAmount = 1;
						splayerItem.itemCode = itemCode;
						splayerItem.jsStr = jsStr;
						splayerItem.playerId = 0;
						splayerItem.posType = 0;
						splayerItem.uid = "";
						var itemData:ItemData = new ItemData(splayerItem);
						if(currentPos > startPos)
						{
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
							chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
							vcChatCellData.push(chatCellData);
						}
						
						var strItemName:String = itemData.itemInfo.name;
						chatCellData2 = ObjectPool.getObject(ChatCellData);
						chatCellData2.init(CellDataType.RumorItem,strItemName);
						chatCellData2.data = itemData;
						chatCellData2.elementFormat = ChatStyle.getRumorEquipmentFormat(itemData,fontSize);
						vcChatCellData.push(chatCellData2);
						startPos = tempPos + 9;
						currentPos = startPos;
						break;
					case "COPY":
						if(paramArray.length < 2)
						{
							currentPos = tempPos + 9;
							break;
						}
						var copyCode:int = int(paramArray[0]);
						var copyText:String = "申请入队";
						if(paramArray.length > 1)
						{
							copyText = paramArray[1];
						}
						
						if(currentPos > startPos)
						{
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
							chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
							vcChatCellData.push(chatCellData);
						}
						chatCellData2 = ObjectPool.getObject(ChatCellData);
						chatCellData2.init(CellDataType.RumorCopy,copyText);
						chatCellData2.data = copyCode;
						chatCellData2.elementFormat = ChatStyle.getRumorLink(fontSize);
						vcChatCellData.push(chatCellData2);
						
						startPos = tempPos + 9;
						currentPos = startPos;
						break;
					case "APPLYTOTEAM":
						if(paramArray.length < 1)
						{
							currentPos = tempPos + 9;
							break;
						}
						var applyText:String = "申请入队";
						playerNum = int(paramArray[0]);
						if(paramArray.length > 1)
						{
							copyCode = paramArray[1];
						}
						//服务器数据错误
						if(aryPlayer.length <= playerNum)
						{
							return new Vector.<ChatCellData>();
						}
						miniPlayer = aryPlayer[playerNum] as SMiniPlayer;
						
						if(currentPos > startPos)
						{
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
							chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
							vcChatCellData.push(chatCellData);
						}
						
						chatCellData2 = ObjectPool.getObject(ChatCellData);
						chatCellData2.init(CellDataType.RumorApplyToTeam,applyText);
						chatCellData2.data = {copyCode:copyCode,miniPlayer:miniPlayer}; //申请入队
						chatCellData2.elementFormat = ChatStyle.getRumorLink(fontSize);
						vcChatCellData.push(chatCellData2);
						
						startPos = tempPos + 9;
						currentPos = startPos;
						break;
					case "COLOR":
						if(paramArray.length < 2)
						{
							currentPos = tempPos + 9;
							break;
						}
						var color:int = int(paramArray[0]);
						colorValue = paramArray[1];//内容
						colorInfo = ColorConfig.instance.getRumorColor(color);//颜色
						
						if(currentPos > startPos)
						{
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
							chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
							vcChatCellData.push(chatCellData);
						}
						
						chatCellData2 = ObjectPool.getObject(ChatCellData);
						chatCellData2.init(CellDataType.GENERAL,colorValue);
						chatCellData2.elementFormat = ChatStyle.getContentFormat(colorInfo?colorInfo.intColor:0x00ff00,fontSize);
						vcChatCellData.push(chatCellData2);
						startPos = tempPos + 9;
						currentPos = startPos;
						break;
					case "CAMPCOLOR":
						if(paramArray.length < 2)
						{
							currentPos = tempPos + 9;
							break;
						}
						camp = int(paramArray[0]);
						colorValue = paramArray[1];//内容
						var campColor:String = GameDefConfig.instance.getECamp(camp).text1;//颜色
						var campIntColor:int = parseInt(campColor.substr(1), 16);
						
						if(currentPos > startPos)
						{
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
							chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
							vcChatCellData.push(chatCellData);
						}
						
						chatCellData2 = ObjectPool.getObject(ChatCellData);
						chatCellData2.init(CellDataType.GENERAL,colorValue);
						chatCellData2.elementFormat = ChatStyle.getContentFormat(campIntColor,fontSize);
						vcChatCellData.push(chatCellData2);
						startPos = tempPos + 9;
						currentPos = startPos;
						break;
					case "MARKET":
						if(paramArray.length < 2)
						{
							currentPos = tempPos + 9;
							break;
						}
						if(currentPos > startPos)
						{
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
							chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor);
							vcChatCellData.push(chatCellData);
						}
						
						var marketText:String = "我要购买";
						
						var marketType:int = int(paramArray[0]);
						var recordId:Number = Number(paramArray[1]);
						
						var cellType:String;
						
						if(marketType == 0)
						{
							marketText = "我要购买";
							cellType = CellDataType.MarketWantBuy;
						}
						else if(marketType == 1)
						{
							marketText = "我要寄售";
							cellType = CellDataType.MarketWantSell;
						}
						
						chatCellData2 = ObjectPool.getObject(ChatCellData);
						chatCellData2.init(cellType,marketText);
						chatCellData2.data = recordId;
						chatCellData2.elementFormat = ChatStyle.getRumorLink();
						vcChatCellData.push(chatCellData2);
						
						startPos = tempPos + 9;
						currentPos = startPos;
						break;
					case "FASTAPPLYTOGUILD":
						if(paramArray.length < 3)
						{
							currentPos = tempPos + 9;
							break;
						}
						playerId = paramArray[0];
						playerName =  paramArray[1];
						camp =  paramArray[2];
						var strFastApplyToGuild:String = ">>申请入会<<";
						if(paramArray.length > 3)
						{
							strFastApplyToGuild = paramArray[3];
						}
						
						if(currentPos > startPos)
						{
							chatCellData = ObjectPool.getObject(ChatCellData);
							chatCellData.init(CellDataType.GENERAL,content.substring(startPos,currentPos));
							chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
							vcChatCellData.push(chatCellData);
						}
						
						miniPlayer = new SMiniPlayer();
						var entityId:SEntityId = new SEntityId();
						entityId.id = playerId;
						miniPlayer.entityId = entityId;
						miniPlayer.online = true;
						miniPlayer.name = playerName;
						miniPlayer.camp = camp;
//						if(Cache.instance.guild.canApply(playerMiniInfoGuildBoss))
//						{
							chatCellData2 = ObjectPool.getObject(ChatCellData);
							chatCellData2.init(CellDataType.FastApplyToGUILD,strFastApplyToGuild);
							chatCellData2.data = playerId;
							chatCellData2.elementFormat = ChatStyle.getRumorLink(fontSize);
							vcChatCellData.push(chatCellData2);
//						}
						startPos = tempPos + 9;
						currentPos = startPos;
						break;
					default:
						currentPos = tempPos + 9;
						break;
				}
			}
			if(startPos < content.length)
			{
				chatCellData = ObjectPool.getObject(ChatCellData);
				chatCellData.init(CellDataType.GENERAL,content.substring(startPos));
				chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
				vcChatCellData.push(chatCellData);
			}
			return vcChatCellData;
		}
		
		public static function randomDiceText(strName:String):String
		{
			return getDiceText(strName,Math.ceil(Math.random() * 100));
		}
		
		public static function getDiceText(strName:String,diceNumber:int):String
		{
			return "<MsgObjDice>" + Language.getStringByParam(40651,strName,diceNumber.toString()) + "</MsgObjDice>";
		}
		
		public static function isDiceText(strText:String):Boolean
		{
			return strText.indexOf("<MsgObjDice>") == 0 && strText.indexOf("</MsgObjDice>") > 0;
		}
		
		public static function getDiceCellData(diceText:String,contentColor:int = -1,fontSize:int = 12):Vector.<ChatCellData>
		{
			var vcChatCellData:Vector.<ChatCellData> = new Vector.<ChatCellData>();
			
			var chatCellData:ChatCellData = ObjectPool.getObject(ChatCellData);
			chatCellData.init(CellDataType.GENERAL,Language.getString(40652));
			chatCellData.elementFormat = ChatStyle.getContentFormat(ChatStyle.getDiceColor(),fontSize);
			vcChatCellData.push(chatCellData);
			
			if(contentColor == -1)
			{
				contentColor = ChatStyle.getChatContentColor();
			}
			
			diceText = diceText.replace("<MsgObjDice>","");
			diceText = diceText.replace("</MsgObjDice>","");
			
			chatCellData = ObjectPool.getObject(ChatCellData);
			chatCellData.init(CellDataType.GENERAL,diceText);
			chatCellData.elementFormat = ChatStyle.getContentFormat(contentColor,fontSize);
			vcChatCellData.push(chatCellData);
			
			return vcChatCellData;
		}
		
		/**
		 * 得到Html 
		 * @param vcChatCellData
		 * 
		 */		
		public static function getHtmlByCellDatas(vcChatCellData:Vector.<ChatCellData>):String
		{
			var strHtml:String = "";
			var strSingle:String;
			for(var i:int = 0;i<vcChatCellData.length;i++)
			{
				if(vcChatCellData[i].type == CellDataType.RumorTran || vcChatCellData[i].type == CellDataType.RumorCopy )
				{
					continue;
				}
				strSingle = HTMLUtil.addColor(vcChatCellData[i].text, "#" + vcChatCellData[i].elementFormat.color.toString(16));
				strHtml +=  strSingle;
			}
			
			return strHtml;
		}
		
		/**
		 * 得到消息内容 
		 * @return 
		 * 
		 */
		public static function getNoticeContent(msg:SBroadcast):String
		{
			if(!msg.msgKey)
			{
				return msg.content;
			}
			
			return getMsgKeyContent(msg.msgKey,msg.params);
		}
		
		/**
		 * 通过MsgKey和参数来获取内容 
		 * @param msgKey
		 * @param params
		 * @return 
		 * 
		 */		
		public static function getMsgKeyContent(msgKey:String,params:Array):String
		{
			var sysMsg:TSysMsg = SysMsgConfig.instance.getInfoByKey(msgKey);
			var content:String;
			if(sysMsg)
			{
				content = sysMsg.msgValue;
			}
			else
			{
				return "";
			}
			var noticeContent:String = "";
			
			var startPos:int = 0;
			var currentPos:int = 0;
			var tempPos:int = 0;
			var tempPos2:int = 0;
			
			//解析
			while(currentPos < content.length - 4)
			{
				//查找标签
				currentPos = content.indexOf("{$",currentPos);
				tempPos2 = currentPos + 2;
				if(currentPos < 0)
				{
					break;
				}
				
				tempPos =  content.indexOf("}",tempPos2);
				if(tempPos < 0)
				{
					break;
				}
				var strValue:String = content.substring(tempPos2,tempPos);
				if(strValue.length < 0)
				{
					currentPos = tempPos + 1;
					continue;
				}
				else
				{
					var intValue:int = int(strValue);
					if(intValue < 1 || intValue > params.length)
					{
						currentPos = tempPos + 1;
						continue;
					}
					noticeContent += content.substring(startPos,currentPos);
					noticeContent += params[intValue - 1];
					
					currentPos = tempPos + 1;
					startPos = currentPos;
				}
			}
			
			noticeContent += content.substring(startPos);
			return noticeContent;
		}
	}
}