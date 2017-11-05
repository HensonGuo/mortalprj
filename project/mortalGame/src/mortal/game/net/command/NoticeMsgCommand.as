package mortal.game.net.command
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.EChatType;
	import Message.Public.ECopyType;
	import Message.Public.EShowArea;
	import Message.Public.SBroadcast;
	
	import com.gengine.utils.HTMLUtil;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.info.ColorInfo;
	import mortal.game.view.chat.ChatArea;
	import mortal.game.view.chat.chatPanel.ChatStyle;
	import mortal.game.view.chat.chatViewData.CellDataType;
	import mortal.game.view.chat.chatViewData.ChatCellData;
	import mortal.game.view.chat.chatViewData.ChatMessageWorking;
	import mortal.game.view.chat.chatViewData.ChatType;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;

	public class NoticeMsgCommand extends BroadCastCall
	{
		public function NoticeMsgCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			var notice:SBroadcast = mb.messageBase as SBroadcast;
			notice.content = ChatMessageWorking.getNoticeContent(notice);
			var campType:int;
			var htmlText:String;
			NetDispatcher.dispatchCmd(ServerCommand.NoticeMsg, notice);
			if(notice.area & EShowArea._EShowAreaMiddle)
			{
				htmlText = getHtml(notice);
				if(htmlText)
				{
					MsgManager.showRollRadioMsg(htmlText);
				}
			}
			if(notice.area & EShowArea._EShowAreaMiddleTop)
			{
				if(!SystemSetting.instance.isHideSystemTips.bValue)//若系统设置了屏蔽系统提示广播信息，则不广播
				{
					htmlText = getHtml(notice);
					if(htmlText)
					{
						MsgManager.addBroadCast(htmlText);
					}
				}
			}
			if(notice.area & EShowArea._EShowAreaChat )
			{
				var type:String;
				//系统公告
				if(notice.type == EChatType._EChatTypeSystem)
				{
					var content:String = notice.content;
					GameController.chat.addBackStageMsg(content,notice.miniPlayers);
				}
				//传闻 
				if(notice.type == EChatType._EChatTypeRumor)
				{
					GameController.chat.addTypeRumorMsg(notice.content,notice.miniPlayers,ChatType.Legent);
				}
//				//战场
//				if(notice.type == EChatType._EChatTypeBattleFiled)
//				{
//					GameController.chat.addTypeRumorMsg(notice.content,notice.publicMiniplayers,ChatType.Battlefield);
//				}
//				//仙盟战
//				if(notice.type == EChatType._EChatTypeGuildWar)
//				{
//					GameController.chat.addTypeRumorMsg(notice.content,notice.publicMiniplayers,ChatType.GuildWar);
//				}
//				//竞技场
//				if(notice.type == EChatType._EChatTypeArena)
//				{
//					GameController.chat.addTypeRumorMsg(notice.content,notice.publicMiniplayers,ChatType.Arena);
//				}
				//市场
				if(notice.type == EChatType._EChatTypeMarket)
				{
					GameController.chat.addTypeRumorMsg(notice.content,notice.miniPlayers,ChatType.Market);
				}
				//副本
				if(notice.type == EChatType._EChatTypeCopy)
				{
					GameController.chat.addCopyMsg(notice.content,notice.miniPlayers);
				}
				if(notice.type == EChatType._EChatTypeForce)
				{
					type = ChatType.Force;
					GameController.chat.addTipMsg(notice.content,type,ChatArea.Force,2,notice.miniPlayers,ChatStyle.getTitleColor(ChatType.System));
				}
				if(notice.type == EChatType._EChatTypeSpace)
				{
					type = ChatType.Scene;
					if(ChatMessageWorking.chatShowAreaData.indexOf(ChatMessageWorking.crossObj) > -1)
					{
						type = ChatType.CrossServer;
					}
					GameController.chat.addTipMsg(notice.content,type,ChatArea.Scene,2,notice.miniPlayers,ChatStyle.getTitleColor(ChatType.System));
				}
				if(notice.type == EChatType._EChatTypeWorld)
				{
					GameController.chat.addTipMsg(notice.content,ChatType.World,ChatArea.World,2,notice.miniPlayers,ChatStyle.getTitleColor(ChatType.World));
				}
			}
//			//战斗信息
//			if(notice.area & EShowArea._EShowArenaFightInfo)
//			{
//				if(notice.type == EChatType._EChatTypeFightInfo)
//				{
//					if(!htmlText)
//					{
//						htmlText = getHtml(notice);
//					}
//					MsgManager.addTipText(htmlText,MsgType.FightMsg);
//				}
//			}
//			//仙境
//			if(notice.area & EShowArea._EShowAreaExplorer)
//			{
//				if(notice.type == EChatType._EChatTypeRumor)
//				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.TreasureExplorerRumorAdd, notice));
//				}
//			}
			
			//右下角区域
			if(notice.area & EShowArea._EShowAreaRightDown)
			{
				htmlText = getHtml(notice,EShowArea._EShowAreaRightDown);
				if(htmlText)
				{
					MsgManager.showRollTipsMsg(htmlText);
				}
			}
			//歌词秀区域
			if(notice.area & EShowArea._EShowAreaMiddleDown)
			{
				htmlText = getHtml(notice);
				if(htmlText)
				{
					MsgManager.showTaskTarget(htmlText);
				}
			}
		}
		
		private function getHtml(notice:SBroadcast,area:int = -1):String
		{
			var campType:int;
			var color:int = 0xffffff;
			var colorInfo:ColorInfo = ColorConfig.instance.getChatColor("Rumor");
			if(colorInfo)
			{
				color = colorInfo.intColor;
			}
			//广播
			var vcChatCellData:Vector.<ChatCellData> = ChatMessageWorking.getCellDatasFilterHtml(notice.content,color,notice.miniPlayers);
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
	}
}