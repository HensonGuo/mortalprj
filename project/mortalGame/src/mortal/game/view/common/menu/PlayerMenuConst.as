/**
 * @date 2011-3-24 上午10:32:41
 * @author  hexiaoming
 * 在聊天中点击人物名称 或者 在 好友里面点击好友 对玩家进行的操作处理类
 */ 
package mortal.game.view.common.menu
{
	import Message.Game.SFriendRecord;
	import Message.Public.EGroupOperType;
	import Message.Public.SEntityId;
	import Message.Public.SGroupOper;
	import Message.Public.SGroupPlayer;
	import Message.Public.SMiniPlayer;
	import Message.Public.SPublicPlayer;
	
	import com.mui.controls.Alert;
	
	import fl.data.DataProvider;
	
	import flash.system.System;
	
	import mortal.component.gconst.GuildConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.utils.PlayerUtil;
	import mortal.mvc.core.Dispatcher;

	public class PlayerMenuConst
	{
		//所有操作列表
		public static const ChatForbid:String = 		"禁    言";
		public static const ChatUnForbid:String = 		"取消禁言";
		
		public static const ChatPirvate:String = 		"发起私聊";
		public static const LookInfo:String =    		"查看资料";
		public static const AddFriend:String =   		"添加好友";
		public static const AddIntimateFriend:String = 	"设为密友";
		public static const LowerToFriend:String = 		"移除密友";
		public static const Trade:String =   	   		"发起交易";
		public static const SendLetter:String =  		"发送信件";
		public static const CopyName:String =   		"复制名称";
		public static const InvitedToTeam:String =		"邀请入队";
		public static const ApplyToTeam:String =  		"申请入队";
		public static const GuildInvite:String =	    "邀请入会";
		public static const GuildApply:String =  	    "申请入会";
		public static const MoveToBlackList:String =  	"拉黑名单";
		public static const LeaveGroup:String =  		"离开队伍";
		public static const KickOutGroup:String =  		"提出队伍";
		public static const AppointCaptain:String =  	"任命队长";
		public static const HandselFlower:String =		"赠送鲜花";
		public static const LookMember:String =			"查看队友";
		public static const Battle:String = 			"发起切磋";
		public static const ChristmasCard:String = 		"赠送贺卡";
		public static const CreateGroup:String = 		"创建队伍";
		public static const DisBandGroup:String =       "解散队伍";
		
		//好友模块里面需要
		public static const Delete:String = 			"删除好友";
		public static const Delete2:String =            "删      除";
		public static const Remove:String =				"移      除";
		
		private static const cache:Cache = Cache.instance;
		
		public static function getEnabeldAttri(dataProvider:DataProvider,playerData:*):DataProvider
		{
			var newDataProvider:DataProvider = new DataProvider();
			for(var i:int = 0;i<dataProvider.length;i++)
			{
				var objOld:Object = dataProvider.getItemAt(i);
				var enabled:Boolean = getOpEnabled(objOld["label"],playerData);
				if(enabled)
				{
					var objNew:Object = {label:objOld["label"],enabled:enabled};
					newDataProvider.addItem(objNew);
				}
			}
			return newDataProvider;
		}
		
		/**
		 *聊天模块中的操作列表 
		 */		
		public static var ChatOpMenu:DataProvider = new DataProvider([
			{label:ChatForbid},
			{label:ChatUnForbid},
			{label:ChatPirvate},
			{label:AddFriend},
			{label:LookInfo},
			{label:Trade},
			{label:SendLetter},
			{label:CopyName},
			{label:InvitedToTeam},
			{label:ApplyToTeam},
			{label:GuildInvite},
			{label:GuildApply},
			{label:MoveToBlackList},
			{label:Battle},
			{label:HandselFlower},
			{label:ChristmasCard}
			]);
		
		/**
		 * 私聊点击头像出来的操作列表
		 */
		public static var ChatPrivateOpMenu:DataProvider = new DataProvider([
			{label:ChatForbid},
			{label:ChatUnForbid},
			{label:AddFriend},
			{label:LookInfo},
			{label:Trade},
			{label:SendLetter},
			{label:CopyName},
			{label:InvitedToTeam},
			{label:ApplyToTeam},
			{label:GuildInvite},
			{label:GuildApply},
			{label:MoveToBlackList},
			{label:Battle},
			{label:HandselFlower},
			{label:ChristmasCard}
		]); 
		
		/**
		 * 好友中的操作列表 
		 */		
		public static var FriendOpMenu:DataProvider = new DataProvider(
			[{label:ChatPirvate},
			{label:LookInfo},
			{label:Trade},
			{label:SendLetter},
			{label:CopyName},
			{label:InvitedToTeam},
			{label:ApplyToTeam},
			{label:GuildInvite},
			{label:GuildApply},
			{label:Delete},
			{label:MoveToBlackList},
			{label:HandselFlower},
			{label:ChristmasCard},
			{label:AddIntimateFriend},
			]
		);
		
		/**
		 * 密友中的操作列表 
		 */		
		public static var IntimateFriendOpMenu:DataProvider = new DataProvider(
			[{label:ChatPirvate},
				{label:LookInfo},
				{label:Trade},
				{label:SendLetter},
				{label:CopyName},
				{label:InvitedToTeam},
				{label:ApplyToTeam},
				{label:GuildInvite},
				{label:GuildApply},
				{label:Delete},
				{label:MoveToBlackList},
				{label:HandselFlower},
				{label:ChristmasCard},
				{label:LowerToFriend}
			]
		);
		
		/**
		 * 仇人中的操作列表 
		 */	
		public static var EnemyOpMenu:DataProvider = new DataProvider(
			[{label:ChatPirvate},
			{label:LookInfo},
			{label:Trade},
			{label:SendLetter},
			{label:CopyName},
			{label:InvitedToTeam},
			{label:ApplyToTeam},
			{label:Delete2},
			{label:MoveToBlackList}
			]
		);
		
		/**
		 * 黑名单的操作列表 
		 */	
		public static var BlackListOpMenu:DataProvider = new DataProvider(
			[{label:AddFriend},
			{label:LookInfo},
			{label:CopyName},
			{label:Delete2}]
		);
		
		/**
		 * 最近联系人的操作列表 
		 */	
		public static var RecentListOpMenu:DataProvider = new DataProvider(
			[{label:ChatPirvate},
				{label:LookInfo},
				{label:Trade},
				{label:SendLetter},
				{label:CopyName},
				{label:InvitedToTeam},
				{label:ApplyToTeam},
				{label:GuildInvite},
				{label:GuildApply},
				{label:Remove},
				{label:MoveToBlackList},
				{label:HandselFlower},
				{label:ChristmasCard},
			]
		);
		
		/**
		 * 主角头像操作列表 
		 */	
		public static var GroupSelfOpMenu:DataProvider = new DataProvider(
			[
				{label:LeaveGroup},
				{label:DisBandGroup},
				{label:CreateGroup},
			]
		);
		
		/**
		 * 队员操作列表 
		 */	
		public static var GroupMemberOpMenu:DataProvider = new DataProvider(
			[
			    {label:CopyName},
				{label:ChatPirvate},
				{label:LookInfo},
				{label:Trade},
				{label:SendLetter},
				{label:KickOutGroup},
				{label:AppointCaptain},
				{label:AddFriend},
				{label:Delete},
				{label:MoveToBlackList},
			]
		);
		
		/**
		 * 点击附近队伍操作列表 
		 */	
		public static var NearbyTeamOpMenu:DataProvider = new DataProvider(
			[
			{label:ApplyToTeam},
			{label:HandselFlower},
			{label:ChristmasCard}
			]
		);
		
		
		/**
		 * 点击附近玩家操作列表 
		 */	
		public static var NearbyPlayerOpMenu:DataProvider = new DataProvider(
			[{label:CopyName},
			{label:InvitedToTeam},
			{label:AddFriend},
			{label:ChatPirvate},
			{label:LookInfo},
			{label:SendLetter},
			{label:Trade},
			{label:HandselFlower},
			{label:ChristmasCard},
			{label:GuildInvite},
			{label:GuildApply}]
		);
		
		/**
		 * 公会成员在线
		 */	
		public static var GuildMemberOnlineOpMenu:DataProvider = new DataProvider(
			[{label:ChatPirvate},
				{label:LookInfo},
				{label:Trade},
				{label:SendLetter},
				{label:CopyName},
				{label:InvitedToTeam},
				{label:ApplyToTeam},
				{label:MoveToBlackList},
				{label:Battle},
				{label:HandselFlower}]
		);
		
		/**
		 * 公会成员离线
		 */	
		public static var GuildMemberOfflineOpMenu:DataProvider = new DataProvider(
			[{label:SendLetter},
				{label:CopyName},
				{label:MoveToBlackList}]
		);
		
		
		private static function getMiniPlayerByData(playerData:*):SMiniPlayer
		{
			var miniPlayer:SMiniPlayer;
			if(playerData is SMiniPlayer){
				miniPlayer = playerData as SMiniPlayer;
			}
			if(playerData is SFriendRecord){
				var friendRecord:SFriendRecord = playerData as SFriendRecord;
				miniPlayer = friendRecord.friendPlayer;
			}
			else if(playerData is SPublicPlayer)
			{
				var sPublicPlayer:SPublicPlayer = playerData as SPublicPlayer;
				miniPlayer = PlayerUtil.copyPubicToMiniPlayer(sPublicPlayer);
			}
			else if(playerData is SGroupPlayer)
			{
				var sgroupPlayer:SGroupPlayer = playerData as SGroupPlayer;
				miniPlayer = PlayerUtil.copyPubicToMiniPlayer(sgroupPlayer.player);
			}
			else if(playerData is EntityInfo)
			{
				var entityInfo:EntityInfo = playerData as EntityInfo;
				miniPlayer = PlayerUtil.copyEntityInfoToMiniPlayer(entityInfo.entityInfo);
			}
			return miniPlayer;
		}
		
		/**
		 * 对具体一项操作的处理函数 
		 * @param opName 
		 * @param playerMiniInfo 
		 * @param friendInfo 删除项时需要
		 * 
		 */		
		public static function Opearte(opName:String,playerData:*):void
		{
			var miniPlayer:SMiniPlayer = getMiniPlayerByData(playerData);
			var tipText:String = "";
			
			switch(opName)
			{
				case ChatForbid:
					break;
				case ChatUnForbid:
					break;
				case ChatPirvate:
					Dispatcher.dispatchEvent(new DataEvent(EventName.ChatPrivate,miniPlayer));
					break;
				case LookInfo:
					break;
				case AddFriend:
					Dispatcher.dispatchEvent(new DataEvent(EventName.FriendApply,miniPlayer.name));
					break;
				case AddIntimateFriend:
					Dispatcher.dispatchEvent(new DataEvent(EventName.ModifyFriendType,playerData));
					break;
				case LowerToFriend:
					Dispatcher.dispatchEvent(new DataEvent(EventName.ModifyFriendType,playerData));
					break;
				case Trade:
					Dispatcher.dispatchEvent(new DataEvent(EventName.TradeApplyToTarget,miniPlayer.entityId));
					break;
				case SendLetter:
					Dispatcher.dispatchEvent(new DataEvent(EventName.MailMenuSend,miniPlayer.name));
					break;
				case CopyName:
					System.setClipboard(miniPlayer.name);
					break;
				case InvitedToTeam:
					var arr:Array = new Array();
					var sGroupOper:SGroupOper = new SGroupOper();
					sGroupOper.fromEntityId = Cache.instance.role.entityInfo.entityId;
					sGroupOper.toEntityId = miniPlayer.entityId;
					sGroupOper.fromPlayer = new SPublicPlayer();
					sGroupOper.fromPlayer.entityId = Cache.instance.role.entityInfo.entityId;
					sGroupOper.type = EGroupOperType._EGroupOperTypeInvite;
					arr.push(sGroupOper);
					Dispatcher.dispatchEvent(new DataEvent(EventName.GroupInviteOper,arr));
					break;
				case ApplyToTeam:
					break;
				case GuildInvite:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_INVITE, miniPlayer.entityId.id));
					break;
				case GuildApply:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GUILD_APPLY_BY_ROLE, miniPlayer.entityId.id));
					break;
				case MoveToBlackList:
					Dispatcher.dispatchEvent(new DataEvent(EventName.AddToBlackList,playerData));
					break;
				case Delete:
				case Delete2:
				case Remove:
					Alert.show("确认删除  " + miniPlayer.name + " ?", null, Alert.OK | Alert.CANCEL, null, onClickHandler);
					break;
				case LeaveGroup:
					Dispatcher.dispatchEvent(new DataEvent(EventName.LeaveGroup));
					break;
				case KickOutGroup:
					Dispatcher.dispatchEvent(new DataEvent(EventName.KickOut,miniPlayer.entityId));
					break;
				case CreateGroup:
					Dispatcher.dispatchEvent(new DataEvent(EventName.CreateGroup));
					break;
				case AppointCaptain:
					Dispatcher.dispatchEvent(new DataEvent(EventName.ModifyCaptain,miniPlayer.entityId));
					break;
				case HandselFlower:
					break;
				case ChristmasCard:
					break;
				case LookMember:
					break;
				case Battle:
					break;
				case DisBandGroup:
					break;
				case CopyName:
					System.setClipboard(miniPlayer.name);
					break;
			}
			
			function onClickHandler(index:int):void
			{
				if(index == Alert.OK)
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.FriendDeleteRecord,playerData));
				}
				else
				{
					return;
				}
			}
		}
		
		/**
		 * 某一项是否可以进行操作 
		 * @param opName
		 * @return 
		 * 
		 */
		public static function getOpEnabled(opName:String,playerData:*):Boolean
		{
			var miniPlayer:SMiniPlayer = getMiniPlayerByData(playerData);
			switch(opName)
			{
				case ChatForbid:
					return true;
					break;
				case ChatUnForbid:
					return true;
					break;
				case ChatPirvate:
					return !EntityUtil.equal(miniPlayer.entityId,cache.role.entityInfo.entityId);
					break;
				case LookInfo:
					return true;
					break;
				case AddFriend:
					return true;
					break;
				case AddIntimateFriend:
					return true;
					break;
				case LowerToFriend:
					return true;
					break;
				case Trade:
					return !isBlackList(miniPlayer) && !isSelf(miniPlayer);
					break;
				case SendLetter:
					return !isBlackList(miniPlayer) && !isSelf(miniPlayer);
					break;
				case CopyName:
					return true;
					break;
				case InvitedToTeam:
					return isCanInvitedToTeam(miniPlayer);
					break;
				case ApplyToTeam:
					return isCanApplyToTeam(miniPlayer);
					break;
				case GuildInvite:
					if (miniPlayer.camp != cache.role.playerInfo.camp)
						return false;
					if (miniPlayer.level < GuildConst.CreateGuildRequireLevel)
						return false;
					return true;
					break;
				case GuildApply:
					if (cache.guild.selfGuildInfo.selfHasJoinGuild)
						return false;
					if (cache.role.roleInfo.level < GuildConst.CreateGuildRequireLevel)
						return false;
					if (miniPlayer.camp != cache.role.playerInfo.camp)
						return false;
					//暂时无法判断对方是否加入过公会
					return true;
					break;
				case MoveToBlackList:
					return true;
					break;
				case Delete:
					return true;
					break;
				case Delete2:
					return true;
					break;
				case HandselFlower:
					return true;
				case ChristmasCard:
					return true;
				case LookMember:
					return true;
				case Battle:
					return true;
				case LeaveGroup:
					return cache.group.isInGroup;
				case CreateGroup:
					return !cache.group.isInGroup;
				case DisBandGroup:
					return cache.group.isCaptain;
				case KickOutGroup:
					return cache.group.isCaptain;
				case AppointCaptain:
					return cache.group.isCaptain;
				default:
					return true;
			}
		}
		
		private static function isCanInvitedToTeam(playerMiniInfo:SMiniPlayer):Boolean
		{
			if( isSelf(playerMiniInfo) || !playerMiniInfo.online )
			{
				return false;
			}
			
//			var isCrossGroupMap:Boolean = GameMapUtil.isCrossGroupMap();
//			if(isCrossGroupMap)
//			{
//				return (cache.crossGroup.isInGroup && !cache.crossGroup.isCaptain && !cache.crossGroup.memberInvite) ? false:true;
//			}
//			else
//			{
//				return (!isAtSameServer(playerMiniInfo) || 
//					(cache.group.isInGroup && !cache.group.isCaptain && !cache.group.memberInvite)) ? false:true;
//			}
			
			return (!isAtSameServer(playerMiniInfo) || 
				(cache.group.isInGroup && !cache.group.isCaptain && !cache.group.memberInvite)) ? false:true;
		}
		
		private static function isCanApplyToTeam(playerMiniInfo:SMiniPlayer):Boolean
		{
			if( isSelf(playerMiniInfo) || !playerMiniInfo.online )
			{
				return false;
			}
			
//			var isCrossGroupMap:Boolean = GameMapUtil.isCrossGroupMap();
//			if(isCrossGroupMap)
//			{
//				return cache.crossGroup.players.length > 0 ? false:true;
//			}
//			else
//			{
//				return (!isAtSameServer(playerMiniInfo) || cache.group.players.length > 0) ? false:true;
//			}
			return (!isAtSameServer(playerMiniInfo) || cache.group.players.length > 0) ? false:true;
		}
		
		/**
		 * 是否是自己 
		 * @param playerMiniInfo
		 * @return 
		 * 
		 */		
		private static function isSelf(playerMiniInfo:SMiniPlayer):Boolean
		{
			return EntityUtil.equal(playerMiniInfo.entityId, cache.role.entityInfo.entityId) ? true:false;
		}
		
		/**
		 * 是否是黑名单玩家 
		 * @return 
		 */
		private static function isBlackList(playerMiniInfo:SMiniPlayer):Boolean
		{
			return Cache.instance.friend.isBlackList(playerMiniInfo.entityId);
		}
		
		/**
		 * 是否在同一个服 
		 * @param playerMiniInfo
		 * @return 
		 * 
		 */
		private static function isAtSameServer(playerMiniInfo:SMiniPlayer):Boolean
		{
			return playerMiniInfo.entityId.typeEx2 == cache.role.entityInfo.entityId.typeEx2 && playerMiniInfo.entityId.typeEx == cache.role.entityInfo.entityId.typeEx; 
		}
	}
}