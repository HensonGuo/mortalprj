/**
 * 2014-3-21
 * @author chenriji
 **/
package mortal.game.view.copy.group
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EPublicCommand;
	import Message.DB.Tables.TCopy;
	import Message.Public.ECopyMode;
	import Message.Public.ECopyWaitingOperate;
	import Message.Public.SCopyRoomOper;
	import Message.Public.SCopyWaitingInfo;
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import com.mui.controls.Alert;
	
	import extend.language.Language;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mortal.game.Game;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.CopyConfig;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.npc.data.NpcFunctionData;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class CopyGroupController extends Controller
	{
		private var _module:CopyGroupModule;
		private var _curCopy:TCopy;
		
		public function CopyGroupController()
		{
			super();
		}
		
		protected override function initServer():void
		{
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicWaitingInfo, waittingInfoHandler);
			NetDispatcher.addCmdListener(EPublicCommand._ECmdPublicCopyRoomOper, copyGroupOperHandler);
			// 监听从npc计入副本
			Dispatcher.addEventListener(EventName.NPC_ClickNpcFunction, npcFunctionHandler);
			Dispatcher.addEventListener(EventName.CopyGroupTabChange, copyTabChangeHandler);
			Dispatcher.addEventListener(EventName.CopyGroupGatherReq, gatherReqHandler);
			Dispatcher.addEventListener(EventName.CopyGroupInviteReq, inviteReqHandler);
			Dispatcher.addEventListener(EventName.CopyGroupQuickReq, quickGroupHandler);
		}
		
		private function quickGroupHandler(evt:DataEvent):void
		{
			var info:TCopy = evt.data as TCopy;
			GameProxy.copy.copyGroupOperate(info.code, ECopyWaitingOperate._ECopyWaitingQuickGroup);
		}
		
		private function copyGroupOperHandler(mb:MessageBlock):void
		{
			var data:SCopyRoomOper = mb.messageBase as SCopyRoomOper;
			switch(data.oper)
			{
				case ECopyWaitingOperate._ECopyWaitingGather: // 队伍集合
					_gatherData = data;
					if(!cache.group.isCaptain && !isInRange(data.leaderX, data.leaderY))
					{
						Alert.show("你妈喊你回家吃饭哇，是否跟斗云回去？", "吃饭", Alert.OK|Alert.CANCEL, null, closeGatherHandler);
						Alert.okLabel = "跟斗云";
						Alert.calcelLabel = "蜗牛式";
					}
					break;
			}
		}
		
		private function isInRange(x:int, y:int):Boolean
		{
			var dis:int = GeomUtil.calcDistance(x, y, RolePlayer.instance.x2d, RolePlayer.instance.y2d);
			if(dis <= 400)
			{
				return true;
			}
			return false;
		}
		
		private var _gatherData:SCopyRoomOper;
		private function closeGatherHandler(index:int):void
		{
			if(_gatherData == null)
			{
				return;
			}
			if(index == Alert.OK)
			{
				var data:SPassTo = new SPassTo();
				data.mapId = _gatherData.leaderMapId;
				data.toPoint = new SPoint();
				data.toPoint.x = _gatherData.leaderX;
				data.toPoint.y = _gatherData.leaderY;
				AIManager.onAIControl(AIType.FlyBoot, data);
			}
			else if(index == Alert.CANCEL)
			{
				AIManager.onAIControl(AIType.GoToOtherMap, Game.mapInfo.mapId,
					_gatherData.leaderMapId, new Point(_gatherData.leaderX, _gatherData.leaderY));
			}
			else // 暂时不过去
			{
				// _ECopyWaitingRefuseGather
			}
		}
		
		private function gatherReqHandler(evt:DataEvent):void
		{
			var info:TCopy = evt.data as TCopy;
			if(!cache.group.isCaptain)
			{
				MsgManager.showRollTipsMsg(Language.getStringByParam(20198, Language.getString(20200)));
				return;
			}
			GameProxy.copy.copyGroupOperate(info.code, ECopyWaitingOperate._ECopyWaitingGather);
		}
		
		private function inviteReqHandler(evt:DataEvent):void
		{
			var info:TCopy = evt.data as TCopy;
			if(!cache.group.isCaptain)
			{
				MsgManager.showRollTipsMsg(Language.getStringByParam(20198, Language.getString(20201)));
				return;
			}
			GameProxy.copy.copyGroupOperate(info.code, ECopyWaitingOperate._ECopyWaitingInvite);
		}
		
		private function moduleAddHandler(evt:Event):void
		{
			// 队伍信息更改
			NetDispatcher.addCmdListener(ServerCommand.GroupPlayerInfoChange, groupInfoChangeHandler);   //更新队伍信息
			// 监听好友
			Dispatcher.addEventListener(EventName.SceneAddGroupmate, teammateInHandler);
			Dispatcher.addEventListener(EventName.SceneRemoveGroupmate, teammateOutHandler);
		}
		
		private function moduleRemoveHandler(evt:Event):void
		{
			// 队伍信息更改
			NetDispatcher.removeCmdListener(ServerCommand.GroupPlayerInfoChange, groupInfoChangeHandler);   //更新队伍信息
			// 监听好友
			Dispatcher.removeEventListener(EventName.SceneAddGroupmate, teammateInHandler);
			Dispatcher.removeEventListener(EventName.SceneRemoveGroupmate, teammateOutHandler);
			
			
			GameProxy.copy.copyGroupOperate(_curCopy.code, ECopyWaitingOperate._ECopyWaitingQuit);
		}
		
		private function groupInfoChangeHandler(obj:Object):void
		{
			if(_module == null || _module.isHide)
			{
				return;
			}
			if(cache.group.isInGroup)
			{
				_module.setInTeamMode(CopyGroupModule.Mode_Inteam);
			}
			else
			{
				_module.setInTeamMode(CopyGroupModule.Mode_NoTeam);
			}
			_module.updateMyTeamData(cache.copy.group.getMyTeamDatas(_curCopy));
		}
		
		private function teammateInHandler(evt:DataEvent):void
		{
			if(_module == null || _module.isHide)
			{
				return;
			}
			_module.updateMyTeamData(cache.copy.group.getMyTeamDatas(_curCopy));
		}
		
		private function teammateOutHandler(evt:DataEvent):void
		{
			if(_module == null || _module.isHide)
			{
				return;
			}
			_module.updateMyTeamData(cache.copy.group.getMyTeamDatas(_curCopy));
		}
		
		private function npcFunctionHandler(evt:DataEvent):void
		{
			var data:NpcFunctionData = evt.data as NpcFunctionData;
			if(data.type != NpcFunctionData.Copy)
			{
				return;
			}
			var info:TCopy = CopyConfig.instance.getCopyInfoByCode(data.value);
			_curCopy = info;
			if(info == null)
			{
				throw new Error("策划配置的npc中副本id找不到相应副本配置");
			}
			switch(info.mode)
			{
				case ECopyMode._ECopyModeSingle: // 单人副本
					GameProxy.copy.enterCopy(info.code);
//					showGroupModule(info.code);
					break;
				case ECopyMode._ECopyModeGroup: // 组队s
					showGroupModule(info.code);
					break;
			}
		}
		
		private function showGroupModule(copyCode:int):void
		{
			if(_module == null)
			{
				_module = new CopyGroupModule();
				_module.addEventListener(Event.ADDED_TO_STAGE, moduleAddHandler);
				_module.addEventListener(Event.REMOVED_FROM_STAGE, moduleRemoveHandler);
			}
			_curCopy = CopyConfig.instance.getCopyInfoByCode(copyCode);
			cache.copy.group.tCopy = _curCopy;
			_module.show();
			_module.updateCopyInfo(_curCopy);
			
			// 设置队伍模式
			if(cache.group.isInGroup)
			{
				_module.setInTeamMode(CopyGroupModule.Mode_Inteam);
			}
			else
			{
				_module.setInTeamMode(CopyGroupModule.Mode_NoTeam);
			}
			
			GameProxy.copy.copyGroupOperate(copyCode, ECopyWaitingOperate._ECopyWaitingEnter);
			GameProxy.copy.getGroupCopyTeamInfos(copyCode);
		}
		
		private function waittingInfoHandler(mb:MessageBlock):void
		{
			cache.copy.group.groupInfos = mb.messageBase as SCopyWaitingInfo;
			if(_module == null || _module.isHide)
			{
				return;
			}
			_module.updateTeamsData(cache.copy.group.getOutCopyTeamDatas());
			_module.updateMyTeamData(cache.copy.group.getMyTeamDatas(_curCopy));
			
		}
		
		private function copyTabChangeHandler(evt:DataEvent):void
		{
			var index:int = int(evt.data);
			if(_module != null && !_module.isHide)
			{
				if(index == 0)// 在外面的队伍
				{
					_module.updateTeamsData(cache.copy.group.getOutCopyTeamDatas());
				}
				else // 已经进入副本的队伍
				{
					_module.updateTeamsData(cache.copy.group.getInCopyTeamDatas());
				}
			}
		}
	}
}