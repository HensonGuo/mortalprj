/**
 * @date 2011-3-14 上午11:53:32
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.chatPanel
{
	import Message.Game.SMarketItem;
	import Message.Public.SMiniPlayer;
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.utils.BrowerUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.core.GlobalClass;
	
	import fl.events.ListEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextElement;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mortal.common.GTextFormat;
	import mortal.game.Game;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.model.TaskTargetInfo;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.rules.EntityType;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.view.chat.ChatBitmap;
	import mortal.game.view.chat.chatViewData.CellDataType;
	import mortal.game.view.chat.chatViewData.ChatCellData;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.ListMenu;
	import mortal.game.view.common.menu.PlayerMenuCellRenderer;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.tooltip.Tooltip;
	import mortal.mvc.core.Dispatcher;

	public class ChatCell
	{
		private var _cellData:ChatCellData;
		private var _cellContentElement:ContentElement;
		private var _elementFormat:ElementFormat;
		private var _dipatcher:EventDispatcher;
		
		private static var _playerOpList:ListMenu;
		private static var _currnetCell:ChatCell;
		private static var _toolTip:Tooltip;
		public function ChatCell()
		{
			
		}
		
		public function init(cellData:ChatCellData):void
		{
			_cellData = cellData;
			_elementFormat = cellData.elementFormat?cellData.elementFormat:new ElementFormat();
			_dipatcher = new EventDispatcher();
			if(!_playerOpList)
			{
				_playerOpList = new ListMenu();
				_playerOpList.width = 86;
				_playerOpList.visible = false;
				_playerOpList.list.setStyle("cellRenderer",PlayerMenuCellRenderer);
				_playerOpList.list.drawNow();
				_playerOpList.list.addEventListener(ListEvent.ITEM_CLICK,playerOpItemSelect);
			}
			create();
		}
		
		/**
		 *创建显示 
		 */
		private function create():void
		{
			
			switch(_cellData.type)
			{
				case CellDataType.IMAGE:
					var bmp:ChatBitmap = new ChatBitmap(GlobalClass.getBitmapData(_cellData.className));
					_cellContentElement = new GraphicElement(bmp,bmp.width,bmp.height,_elementFormat);
					break;
				case CellDataType.RumorFly:
//					_cellContentElement = new TextElement(_cellData.text,_elementFormat,null);
//					var btn:GLoadedButton = UIFactory.gLoadedButton(ImagesConst.MapBtnFlyBoot_upSkin, 0, 0, 16, 18);
//					Log.debug("按钮宽高：",btn.width,btn.height);
					var spFly:Sprite = new FlyFootBmp();
					_cellContentElement = new GraphicElement(spFly,spFly.width + 2,spFly.height,_elementFormat,_dipatcher);
//					_cellContentElement = new GraphicElement(btn,20,15,_elementFormat,_dipatcher);
					(_cellContentElement as GraphicElement).graphic.filters = [];
					setMouseCanClick();
					_dipatcher.addEventListener(MouseEvent.CLICK,flyToMapPositionHandler);
					break;
				case CellDataType.MovieClip:
					var mc:MovieClip = GlobalClass.getInstance(_cellData.className) as MovieClip;
					mc.mouseEnabled = false;
					mc.mouseChildren = false;
					mc.addEventListener(Event.ADDED_TO_STAGE,onMCAddToStage);
					mc.addEventListener(Event.REMOVED_FROM_STAGE,onMCRemoveFromStage);
					_cellContentElement = new GraphicElement(mc,mc.width,mc.height,_elementFormat);
					(_cellContentElement as GraphicElement).graphic.filters = [];
					break;
				case CellDataType.VIP:
					var vipBMP:ChatBitmap = new ChatBitmap(GlobalClass.getBitmapData(_cellData.className));
					var sp:Sprite = new Sprite();
					sp.addChild(vipBMP);
					_cellContentElement = new GraphicElement(sp,sp.width,sp.height,_elementFormat,_dipatcher);
					setMouseCanClick();
					_dipatcher.addEventListener(MouseEvent.CLICK,openVIPHandler);
					break;
				case CellDataType.GENERAL:
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,null);
					break;
				case CellDataType.EQUIPMENT:
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,_dipatcher);
					_dipatcher.addEventListener(MouseEvent.CLICK,showToolTipHandler);
					setMouseCanClick();
					break;
				case CellDataType.RumorItem:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,showToolTipHandler);
					break;
				case CellDataType.PET:
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,_dipatcher);
					_dipatcher.addEventListener(MouseEvent.CLICK,showPetHandler);
					setMouseCanClick();
					break;
				case CellDataType.PLAYER:
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,_dipatcher);
					_dipatcher.addEventListener(MouseEvent.CLICK,showPlayerOperate);
					setMouseCanClick();
					break;
				case CellDataType.RumorPlayer:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,showPlayerOperate);
					break;
				case CellDataType.Charge:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,onClickCharge);
					break;
				case CellDataType.RumorTran:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,gotoTran);
					break;
				case CellDataType.RumorTreasure:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,openTreasure);
					break;
				case CellDataType.RumorActive:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,openActive);
					break;
				case CellDataType.EnterGuildManor:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,enterMyGuildManor);
					break;
				case CellDataType.CAMP:
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,null);
					break;
				case CellDataType.LINK:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,linkToUrlHandler);
					break;
				case CellDataType.FastApplyToGUILD:
					_dipatcher.addEventListener(MouseEvent.CLICK,applyToGuildHandler);
					setLink();
					break;
				case CellDataType.RumorGuild:
					setLink();
////					_cellContentElement = new TextElement(_cellData.text,_elementFormat,_dipatcher);
//					var playerId:int = int(this.cellData.data["playerId"]);
//					var playerName:String = String(this.cellData.data["playerName"]);
//					var camp:int = int(this.cellData.data["camp"]);
//					var guildId:int = int(this.cellData.data["guildId"]);
//					var spublicMiniInfo:SPublicMiniPlayer = new SPublicMiniPlayer();
//					var entityId:SEntityId = new SEntityId();
//					entityId.id = playerId;
//					spublicMiniInfo.entityId = entityId;
//					spublicMiniInfo.online = 1;
//					spublicMiniInfo.name = playerName;
//					spublicMiniInfo.camp = camp;
//					var playerMiniInfo:PlayerMiniInfo = new PlayerMiniInfo(spublicMiniInfo);
//					playerMiniInfo.extendsObj["guildId"] = guildId;
//					this.cellData.data = playerMiniInfo;
//					_dipatcher.addEventListener(MouseEvent.CLICK,showGuildOperate);
					break;
				case CellDataType.RumorGuild1:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,showGuildMsg);
					break;
				case CellDataType.RumorCopy:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,gotoCopyHandler);
					break;
				case CellDataType.RumorMapPoint:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,gotoMapPositionHandler);
					break;
				case CellDataType.RumorNPC:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,gotNPCHandler);
					break;
				case CellDataType.RumorPet:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,showRumorPetHandler);
					break;
				case CellDataType.RumorApplyToTeam:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,applyToTeamHandler);
					break;
				case CellDataType.CornucopiaBless:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,cornucopiaBlessHandler);
					break;
				case CellDataType.RumorJewelAdvance:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,jewelAdvanceHandler);
					break;
				case CellDataType.GOTOGUILDSTRUGGLE:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,goToGuildStruggleHandler);
					break;
				case CellDataType.GOTOGUILDROBCITYONE:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,goToGuildRobCityOneCopyHandler);
					break;
				case CellDataType.GOTOGUILDELITE:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,goToGuildElite);
					break;
				case CellDataType.GUILDGROUP:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,enterGuildGroup);
					break;
				case CellDataType.EnterGuildAltar:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,enterGuildAltarHandler);
					break;
				case CellDataType.EnterGuildPasture:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,enterGuildPastureHandler);
					break;
				case CellDataType.EnterGuildDefense:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,enterGuildDefenseHandler);
					break;
				case CellDataType.RumorEXPDICE:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,showExpdiceHandler);
					break;
				case CellDataType.RumorOPENUI:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,openUIHandler);
					break;
				case CellDataType.MarketWantBuy:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,onClickMarketQickBuy);
					break;
				case CellDataType.MarketWantSell:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,onClickMarketQickBuy);
					break;
				case CellDataType.WatchVideo:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,onClickWatchVideo);
					break;
				case CellDataType.Islandpos:
					setLink();
					_dipatcher.addEventListener(MouseEvent.CLICK,onClicIslandpos );
				    break;
				default:
					_cellContentElement = new TextElement(_cellData.text,_elementFormat,null);
					break;
			}
		}
		
		private function setLink():void
		{
			var textField:TextField;
			var textFormat:TextFormat;
			textField = new  TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.multiline = true;
			textFormat = new GTextFormat();
			textFormat.color = _elementFormat.color;
			textFormat.underline = true;
			textFormat.size = _elementFormat.fontSize;
			textFormat.letterSpacing = _elementFormat.trackingLeft;
			textField.defaultTextFormat = textFormat;
			textField.text = _cellData.text;
//			if(textField.width > ChatBody.lineWidth - 10)
//			{
//				textField.wordWrap = true;
//				textField.width = ChatBody.lineWidth - 10;
//				textFormat.leading = ChatBody.lineHeight - 17;
//				textField.setTextFormat(textFormat);
//			}
			_cellContentElement = new GraphicElement(textField,textField.width,textField.height,_elementFormat,_dipatcher);
			setMouseCanClick();
		}
		
		private function setMouseCanClick():void
		{
			_dipatcher.addEventListener(MouseEvent.MOUSE_OVER,mouseStyleHandler);
			_dipatcher.addEventListener(MouseEvent.MOUSE_OUT,mouseStyleHandler);
		}
		
		private function mouseStyleHandler(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_OVER)
			{
				Mouse.cursor = MouseCursor.BUTTON;
			}
			if(e.type == MouseEvent.MOUSE_OUT)
			{
				Mouse.cursor = MouseCursor.AUTO;
			}
		}
		
		/**
		 * 添加到舞台 
		 * @param e
		 * 
		 */		
		private function onMCAddToStage(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.play();
		}
		
		/**
		 * 移除舞台 
		 * @param e
		 * 
		 */
		private function onMCRemoveFromStage(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.stop();
		}
		
		private function linkToUrlHandler(e:Event):void
		{
			BrowerUtil.getUrl(_cellData.linkUrl)
		}
		
		private function applyToGuildHandler(e:Event):void
		{
			var playerId:int = int(_cellData.data);
//			Dispatcher.dispatchEvent(new DataEvent(EventName.GuildApplyPlayersGuild,playerId));
		}
		
		private function gotoCopyHandler(e:MouseEvent):void
		{
//			var taskTargetInfo:TaskTargetInfo = Cache.instance.scene.getNearlyNpcByCopyId(int(_cellData.data));
//			AIManager.onAutoPathAIControl(taskTargetInfo);
		}
		
		private function gotoMapPositionHandler(e:MouseEvent):void
		{
			var mapId:int = _cellData.data["mapId"];
			var mapX:int = _cellData.data["mapX"];
			var mapY:int = _cellData.data["mapY"];
			var p:Point = new Point(mapX,mapY);
			AIManager.onAIControl(AIType.GoToOtherMap, Game.mapInfo.mapId, mapId, p);
		}
		
		private function openVIPHandler(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.ShowVIPBoonWindow,_cellData.data));
		}
		
		private function flyToMapPositionHandler(e:MouseEvent):void
		{
			var mapId:int = _cellData.data["mapId"];
			var mapX:int = _cellData.data["mapX"];
			var mapY:int = _cellData.data["mapY"];
			
			var pt:SPassTo = new SPassTo();
			pt.mapId = mapId;
			var sPoint:SPoint = new SPoint();
			sPoint.x = mapX;
			sPoint.y = mapY;
			pt.toPoint = sPoint;
			AIManager.onAIControl(AIType.FlyBoot, pt);
		}
		
		private function gotNPCHandler(e:MouseEvent):void
		{
//			var mapId:int = _cellData.data["mapId"];
//			var mapX:int = _cellData.data["mapX"];
//			var mapY:int = _cellData.data["mapY"];
//			var npcId:int = _cellData.data["npcId"];
//			var taskTargetInfo:TaskTargetInfo = new TaskTargetInfo();
//			taskTargetInfo.targetType = EntityType.NPC;
//			taskTargetInfo.mapId = mapId;
//			taskTargetInfo.id = npcId;
//			taskTargetInfo.x = mapX;
//			taskTargetInfo.y = mapY;
//			AIManager.onAutoPathAIControl(taskTargetInfo);
		}
		
		private function showPlayerOperate(e:MouseEvent):void
		{
			var obj:DisplayObject = e.target as DisplayObject;
			if(obj.parent)
			{
				_currnetCell = this;
				LayerManager.topLayer.addChild(_playerOpList);
				_playerOpList.dataProvider = PlayerMenuConst.getEnabeldAttri(PlayerMenuConst.ChatOpMenu,_currnetCell.cellData.data as SMiniPlayer);
				if(_playerOpList.dataProvider.length > 0)
				{
					_playerOpList.show(e.stageX,e.stageY - _playerOpList.height,LayerManager.topLayer);
					Global.stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
				}
				else
				{
					_playerOpList.hide();
				}
			}
			e.stopImmediatePropagation();
		}
		
		/**
		 * 前往充值 
		 * @param e
		 * 
		 */		
		private function onClickCharge(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent( new DataEvent(EventName.GotoPay));
		}
		
		/**
		 * 显示点击仙盟的操作菜单 
		 * @param e
		 * 
		 */		
		private function showGuildOperate(e:MouseEvent):void
		{
//			var obj:DisplayObject = e.target as DisplayObject;
//			if(obj.parent)
//			{
//				_currnetCell = this;
//				LayerManager.topLayer.addChild(_playerOpList);
//				_playerOpList.dataProvider = PlayerOpMenuConst.getEnabeldAttri(PlayerOpMenuConst.GuildOpMenu,_currnetCell.cellData.data as PlayerMiniInfo);
//				if(_playerOpList.dataProvider.length > 0)
//				{
//					_playerOpList.show(e.stageX,e.stageY - _playerOpList.height,LayerManager.topLayer);
//					Global.stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
//				}
//				else
//				{
//					_playerOpList.hide();
//				}
//			}
//			e.stopImmediatePropagation();
		}
		
		/**
		 * 显示仙盟信息 
		 * @param e
		 * 
		 */		
		private function showGuildMsg(e:MouseEvent):void
		{
//			var guildId:int = int(_cellData.data);
//			//发出仙盟事件
//			Dispatcher.dispatchEvent( new DataEvent(EventName.GuildInfoWindowOpen,guildId));
		}
		
		/**y
		 * 去 运镖 
		 * @param e
		 * 
		 */
		private function gotoTran(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.GoToTransportNPC));
		}
		
		/**
		 * 打开仙境 
		 * @param e
		 * 
		 */		
		private function openTreasure(e:MouseEvent):void
		{
//			var type:int = int(_cellData.data);
//			if(type == ELottertType._ELotterySeabed || type == ELottertType._ELotteryHeaven)
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.TreasureModuleOpen,_cellData.data));
//			}
//			else if(type == ELottertType._ELotteryChristmas || type == ELottertType._ELotterySpringFestival )
//			{
//				AIManager.onAutoPathAIControl(Cache.instance.scene.getNpcByEffect(ENpcEffect._ENpcEffectMoneyTree));
//			}
		}
		
		/**
		 * 打开活动界面 
		 * @param e
		 * 
		 */		
		private function openActive(e:MouseEvent):void
		{
//			var bagTab:String = _cellData.data["bagTab"];
//			var type:int = _cellData.data["type"];
//			if(bagTab == "FULIBAG")
//			{
////				if(type == 3)
////				{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.DailyGiftOpen,type));
////				}
//			}
		}
		
		/**
		 * 进入仙盟领地 
		 * @param e
		 * 
		 */		
		private function enterMyGuildManor(e:MouseEvent):void
		{
//			var guildId:int = int(_cellData.data);
//			Dispatcher.dispatchEvent(new DataEvent(EventName.GuildEnterManor,{guildId:guildId,useContribution:false}));
		}
		
		private function stageClickHandler(e:MouseEvent):void
		{
//			_playerOpList.hide();
//			Global.stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
		}
		
		private function playerOpItemSelect(e:ListEvent):void
		{
			PlayerMenuConst.Opearte(_playerOpList.list.dataProvider.getItemAt(e.index)["label"],_currnetCell.cellData.data as SMiniPlayer);
		}
		
		private static var _closeBtn:GButton;
		private static var _spTooltipContainer:Sprite = new Sprite();
		private function showToolTipHandler(e:MouseEvent):void
		{
//			var itemData:ItemData = _cellData.data as ItemData;
//			if(!_toolTip)
//			{
//				_toolTip = new Tooltip();
//				_closeBtn = UIFactory.gButton("",_toolTip.width - 24,4,20,18,null,"SmallCLoseBtn");
//				_spTooltipContainer.addChild(_toolTip);
//				_spTooltipContainer.addChild(_closeBtn);
//			}
//			if(itemData.category == ECategory._ECategoryMount)
//			{
//				_toolTip.data = itemData.getToolTipData(ItemData.ToolTipType_Mounts);
//			}
//			else if(itemData.category == ECategory._ECategoryPetEquip)
//			{
//				_toolTip.data = itemData.getToolTipData(ItemData.ToolTipType_PetEquip);
//			}
//			else if(itemData.category == ECategory._ECategoryPetLifeStyle)
//			{
//				_toolTip.data = itemData.getToolTipData(ItemData.ToolTipType_PetLifeStyle);
//			}
//			else
//			{
//				_toolTip.data = itemData.getToolTipData();
//			}
//			_spTooltipContainer.x = e.stageX;
//			_spTooltipContainer.y = e.stageY;
//			LayerManager.toolTipLayer.addChild(_spTooltipContainer);
//			_closeBtn.x = _toolTip.width - 24;
//			_closeBtn.addEventListener(MouseEvent.CLICK,closeTootipHandler);
//			resetToolTipPosition();
		}
		
		private function showPetHandler(e:MouseEvent):void
		{
//			var petInfo:SPetInfo = _cellData.data as SPetInfo;
//			Dispatcher.dispatchEvent(new DataEvent(EventName.PetShowInfo,petInfo));
		}
		
		private function showRumorPetHandler(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.ChatSearchPet,_cellData.data));
		}
		 
		private function applyToTeamHandler(e:MouseEvent):void
		{
			var copyCode:int = _cellData.data["copyCode"] as int;
			var miniPlayer:SMiniPlayer = _cellData.data["miniPlayer"] as SMiniPlayer;
		}
		
		/**
		 * 聚宝盆祝福 
		 * @param e
		 * 
		 */
		private function cornucopiaBlessHandler(e:MouseEvent):void
		{
//			var objData:Object = _cellData.data;
//			var playerId:int = int(objData["playerId"]);
//			var playerName:String = String(objData["playerName"]);
//			
//			if(playerId == Cache.instance.role.entityInfo.entityId.id)
//			{
//				MsgManager.showRollTipsMsg(Language.getString(40621));
//				return;
//			}
//			
//			if(Cache.instance.friend.isFriendByPlayerId(playerId))
//			{
//				Dispatcher.dispatchEvent( new DataEvent(EventName.CornucopiaBlessToFriend,playerId));
//			}
//			else
//			{
//				Alert.show(Language.getString(40622),null,Alert.OK|Alert.CANCEL,null,onClose);
//			}
//			
//			function onClose(index:int):void
//			{
//				if(index == Alert.OK)
//				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.FriendRequestAddFriend,{name:playerName}));
//				}
//			}
		}
		
		/**
		 * 宝石打磨 
		 * @param e
		 * 
		 */		
		private function jewelAdvanceHandler(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.Equipment_DoCast,EItemUpdateOper._EItemUpdateJewelAddance));
		}
		
		/**
		 * 前往仙盟副本
		 * @param e
		 * 
		 */		
		private function goToGuildStruggleHandler(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.CopyEnterGuildCopy));
		}
		
		/**
		 * 前往跨服抢城海选副本
		 * @param e
		 * 
		 */		
		private function goToGuildRobCityOneCopyHandler(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.RobCity_doEnterCopy,ECopyType._ECopyRobCityOne));
		}
		
		/**
		 * 前往参与仙盟精英团队副本 
		 * @param e
		 * 
		 */		
		private function goToGuildElite(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.GuildElite_ShowGuildEliteModule,0));
		}
		
		/**
		 * 我要加入仙盟团队 
		 * 
		 */		
		private function enterGuildGroup(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.GuildEliteGroup_ShowGroupModule,_cellData.data as int));
		}
		
		/**
		 * 前往仙盟神兽 
		 * @param e
		 * 
		 */
		private function enterGuildAltarHandler(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.GuildAnimalGotoNpc));
		}
		
		/**
		 * 前往仙盟牧场 
		 * @param e
		 * 
		 */		
		private function enterGuildPastureHandler(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.GuildPastureGotoNpc));
		}
		
		/**
		 * 前往仙盟防守 
		 * @param e
		 * 
		 */		
		private function enterGuildDefenseHandler(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.CopyEnterGuildDefense));
		}
		
		/**
		 * 我也要博 
		 * @param e
		 * 
		 */		
		private function showExpdiceHandler(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent(new DataEvent(EventName.ShowPlayDice));
		}
		
		/**
		 * 打开UI界面 
		 * @param e
		 * 
		 */		
		private function openUIHandler(e:MouseEvent):void
		{
//			var objData:Object = _cellData.data;
//			var strType:String = objData.toString();
//			switch(strType)
//			{
//				case "luckyBag":
//					Dispatcher.dispatchEvent(new DataEvent(EventName.LuckyBagBroadCastOpen));
//					break;
//				case "petBlood":
//					Dispatcher.dispatchEvent( new DataEvent( PetEventName.PetShowToTab, 8 ));
//					break;
//				case "robIsland":
//					Dispatcher.dispatchEvent( new DataEvent( EventName.PetIslandBtnClick ));
//					break;
//				default:
//					break;
//			}
		}
		
		/**
		 * 市场 ，快捷购买，快捷出售 
		 * @param e
		 * 
		 */		
		private function onClickMarketQickBuy(e:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.MarketClickQickBuy,_cellData.data));
		}
		
		/**
		 * g观看录像 
		 * @param e
		 * 
		 */		
		private function onClickWatchVideo(e:MouseEvent):void
		{
//			Dispatcher.dispatchEvent( new DataEvent(EventName.VideoWatchVideo,_cellData.data));
		}
		
		/**
		 * 点击宠物争夺前往 
		 * @param e
		 * 
		 */		
		private function onClicIslandpos( e:MouseEvent ):void
		{
//			var pos:SIslandPos = SIslandPos( _cellData.data );
//			Dispatcher.dispatchEvent( new DataEvent( EventName.PetIslandMapShowByPosition, pos ));
		}
		
		private function closeTootipHandler(e:MouseEvent):void
		{
			if(_spTooltipContainer && _spTooltipContainer.parent)
			{
				_spTooltipContainer.parent.removeChild(_spTooltipContainer);
			}
//			if(_toolTip && _toolTip.parent)
//			{
//				_toolTip.parent.removeChild(_toolTip);
//				_toolTip = null;
//			}
		}
		
		private function resetToolTipPosition():void 
		{
			if(_spTooltipContainer.x > (Global.stage.stageWidth - _spTooltipContainer.width - 6))
			{
				_spTooltipContainer.x = _spTooltipContainer.x  - _spTooltipContainer.width-6;	
			}
			
			var vYDir:int = 1;
			
			_spTooltipContainer.y = _spTooltipContainer.y - _spTooltipContainer.height - 6;	
			if(_spTooltipContainer.y < 0)
			{
				_spTooltipContainer.y = 0;
			}
		}
		
		public function get cellData():ChatCellData
		{
			return _cellData;
		}

		public function set cellData(value:ChatCellData):void
		{
			_cellData = value;
		}

		public function get cellContentElement():ContentElement
		{
			return this._cellContentElement;
		}
		
		public function dispose():void
		{
			_cellContentElement = null;
			_elementFormat = null;
			_dipatcher = null;
			_cellData.dispose();
			_cellData = null;
			ObjectPool.disposeObject(this);
		}
	}
}