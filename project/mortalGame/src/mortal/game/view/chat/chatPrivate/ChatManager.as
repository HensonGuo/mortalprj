/**
 * @date 2011-3-24 下午07:49:57
 * @author  hexiaoming
 * 管理所有的私人聊天框·
 */ 
package mortal.game.view.chat.chatPrivate
{
	import Message.Game.SChatMsg;
	import Message.Public.SEntityId;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.global.Global;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mortal.common.sound.SoundManager;
	import mortal.common.sound.SoundTypeConst;
	import mortal.component.window.BaseWindow;
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	
	public class ChatManager
	{
		//创建过得聊天窗口
		private static var _aryWindow:Vector.<ChatWindow> = new Vector.<ChatWindow>();
		
		//当前正在聊天的列表
		private static var _aryChatWindowMsg:Vector.<ChatWindowMsg> = new Vector.<ChatWindowMsg>();
		
		/**
		 * 添加一条消息 
		 * @param windowPlayerName
		 * @param playerName
		 * @param date
		 * @param content
		 * 
		 */
		public static function addMessage(chatPrivateData:ChatData):void
		{
			var objWindow:ChatWindow = getWindowBySEntityId(chatPrivateData.chatWindowEntityId);
			var sChatMsg:SChatMsg = chatPrivateData.sChatMsg;
			var windowPlayerName:String = chatPrivateData.chatWindowName;
			var date:Date = chatPrivateData.date;
			var content:String = chatPrivateData.content;
			var chatColor:int = chatPrivateData.chatColor;
			var playerName:String = chatPrivateData.chatFromPlayerName;
			
			//更新窗口玩家信息
			if(sChatMsg && objWindow && windowPlayerName == sChatMsg.fromPlayer.name && EntityUtil.equal(chatPrivateData.chatWindowEntityId,chatPrivateData.sChatMsg.fromPlayer.entityId))
			{
				objWindow.updatePlayerMsg(sChatMsg.fromPlayer);
			}
			if(objWindow)
			{
				objWindow.addChatItem(chatPrivateData);
				if(objWindow.isHide)
				{
					//未读消息数量 +1
					var chatWindowMsg:ChatWindowMsg = getWindowChatMsgByWindow(objWindow);
					chatWindowMsg.unReadMsgNum ++;
					
					//排序 最后的排最前
					var index:int = _aryChatWindowMsg.indexOf(chatWindowMsg);
					_aryChatWindowMsg.splice(index,1);
					_aryChatWindowMsg.unshift(chatWindowMsg);
					
					ChatIConView.instance.updateData(_aryChatWindowMsg);
					
					//控制图标闪烁
					
//					SoundManager.instance.soundPlay(SoundTypeConst.InformationPresentation);
				}
			}
		}
		
		/**
		 * 添加一个窗口 
		 * @param playerInfo
		 * 
		 */		
		public static function addWindow(player:SMiniPlayer):ChatWindow
		{
			var objWindow:ChatWindow = getWindowBySEntityId(player.entityId);
			if(!objWindow)
			{
				objWindow = new ChatWindow(player);
				objWindow.addEventListener(Event.ADDED_TO_STAGE,onWindowAddToStage);
				_aryWindow.push(objWindow);
			}
			
			var chatWindowMsg:ChatWindowMsg = getWindowChatMsgByWindow(objWindow);
			if(!chatWindowMsg)
			{
				chatWindowMsg = new ChatWindowMsg();
				chatWindowMsg.windowUid = EntityUtil.toString(player.entityId);
				chatWindowMsg.name = player.name;
				chatWindowMsg.unReadMsgNum = 0;
				_aryChatWindowMsg.push(chatWindowMsg);
				ChatIConView.instance.updateData(_aryChatWindowMsg);
			}
			
			return objWindow;
		}
		
		private static function onWindowAddToStage(e:Event):void
		{
			//清除未读消息数量
			var window:ChatWindow = e.currentTarget as ChatWindow;
			var chatWindowMsg:ChatWindowMsg = getWindowChatMsgByWindow(window);
			chatWindowMsg.unReadMsgNum = 0;
			ChatIConView.instance.updateData(_aryChatWindowMsg);
		}
		
		/**
		 * 删除一个正在聊天的窗口 
		 * @param objWindow
		 * 
		 */	
		public static function removeChatWindow(objWindow:ChatWindow):void
		{
			var chatWindowMsg:ChatWindowMsg = getWindowChatMsgByWindow(objWindow);
			
			//删除信息
			var index:int = _aryChatWindowMsg.indexOf(chatWindowMsg);
			_aryChatWindowMsg.splice(index,1);
		
			objWindow.hide();
			ChatIConView.instance.updateData(_aryChatWindowMsg);
		}
		
		/**
		 * 删除一个正在聊天的窗口 
		 * @param objWindow
		 * 
		 */	
		public static function removeChatWindowByMsg(chatWindowMsg:ChatWindowMsg):void
		{
			//删除信息
			var index:int = _aryChatWindowMsg.indexOf(chatWindowMsg);
			_aryChatWindowMsg.splice(index,1);
			
			var objWindow:ChatWindow = getWindowByWindowUId(chatWindowMsg.windowUid);
			objWindow.hide();
			ChatIConView.instance.updateData(_aryChatWindowMsg);
		}
		
		
		/**
		 * 根据玩家名取window 
		 * @param playerName
		 * @return 
		 * 
		 */		
		public static function getWindowByName(playerName:String):ChatWindow
		{
			for each(var chatWindow:ChatWindow in _aryWindow)
			{
				if(chatWindow.getChatPlayerName() == playerName)
				{
					return chatWindow;
				}
			}
			return null;
		}
		
		/**
		 * 根据entityId获取window 
		 * @param entityId
		 * @return 
		 * 
		 */		
		public static function getWindowBySEntityId(entityId:SEntityId):ChatWindow
		{
			if(!entityId)
			{
				return null;
			}
			for each(var chatWindow:ChatWindow in _aryWindow)
			{
				if(EntityUtil.equal(chatWindow.getChatPlayerEntityId(),entityId))
				{
					return chatWindow;
				}
			}
			return null;
		}
		
		/**
		 * 根据windowUid获取window 
		 * @param windowUid
		 * @return 
		 * 
		 */		
		public static function getWindowByWindowUId(windowUid:String):ChatWindow
		{
			for each(var chatWindow:ChatWindow in _aryWindow)
			{
				if(EntityUtil.toString(chatWindow.getChatPlayerEntityId()) == windowUid)
				{
					return chatWindow;
				}
			}
			return null;
		}
		
		/**
		 * 获取窗口聊天未读信息数量
		 * @param entityId
		 * @return 
		 * 
		 */		
		public static function getWindowChatMsgByWindow(chatWindow:ChatWindow):ChatWindowMsg
		{
			for each(var chatWindowMsg:ChatWindowMsg in _aryChatWindowMsg)
			{
				if(chatWindowMsg.windowUid == EntityUtil.toString(chatWindow.getChatPlayerEntityId()))
				{
					return chatWindowMsg;
				}
			}
			return null;
		}
		
		/**
		 * 更新玩家信息 
		 * @param miniPlayer
		 * 
		 */		
		public static function updateMiniPlayer(miniPlayer:SMiniPlayer):void
		{
			var window:ChatWindow = getWindowBySEntityId(miniPlayer.entityId);
			if(window)
			{
				window.updatePlayerMsg(miniPlayer);
			}
		}
	}
}