package mortal.game.view.group
{
	import Message.Public.EGroupOperType;
	import Message.Public.SEntityId;
	import Message.Public.SGroupOper;
	import Message.Public.SGroupSetting;
	
	import flash.events.Event;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.GroupProxy;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.scene3D.player.info.EntityInfoEventName;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class GroupController extends Controller
	{
		private var _groupModel:GroupMoudle;
		
		private var _groupCache:GroupCache;
		
		private var _groupProxy:GroupProxy;
		
		public function GroupController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_groupCache = cache.group;
			_groupProxy = GameProxy.group;
		}
		
		override protected function initView():IView
		{
			if(_groupModel == null)
			{
				_groupModel = new GroupMoudle();
				_groupModel.addEventListener(WindowEvent.SHOW, onGroupModelShow);
				_groupModel.addEventListener(WindowEvent.CLOSE, onGroupModelClose);
			}
			return _groupModel;
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.GroupPanel_ViewInited,viewInitedHandler);
			Dispatcher.addEventListener(EventName.LeaveGroup,leaveGroup);
			Dispatcher.addEventListener(EventName.KickOut,kickOutPlayer);
			Dispatcher.addEventListener(EventName.ModifyCaptain,modifyCaptain);
			Dispatcher.addEventListener(EventName.GroupApplyOper, groupApplyOper);
			Dispatcher.addEventListener(EventName.GroupInviteOper, groupInviteOper);
			Dispatcher.addEventListener(EventName.CreateGroup, createGroupHandler);
			Dispatcher.addEventListener(EventName.DisbanGroup, disbanGroup);
		}
		
		private function onGroupModelShow(e:Event):void
		{
//			updateTeamMate();
	
		    if(!Cache.instance.group.isInGroup)
			{
				Cache.instance.role.roleEntityInfo.addEventListener(EntityInfoEventName.UpdateLevel,updateLevel);
			}
			
			NetDispatcher.addCmdListener(ServerCommand.GroupPlayerInfoChange,updateTeamMate);
			NetDispatcher.addCmdListener(ServerCommand.GetNearTeam,updateNearTeam);
			NetDispatcher.addCmdListener(ServerCommand.GroupInvite,updateInviteList);
			NetDispatcher.addCmdListener(ServerCommand.GroupApply,updeteApplyList);
			NetDispatcher.addCmdListener(ServerCommand.GetNearPlayer,updateNearPlayer);
			NetDispatcher.addCmdListener(ServerCommand.GroupSettingUpdate,updateSetting);
			

			Dispatcher.addEventListener(EventName.GetNearPlayer, updateNearPlayer);
			Dispatcher.addEventListener(EventName.GetNearTeam,getNearTeam);
			Dispatcher.addEventListener(EventName.GroupTabIndexChange,changeTabIndex);
			Dispatcher.addEventListener(EventName.GroupSetting,changeSetting);
		}
		
		private function onGroupModelClose(e:Event):void
		{
			Cache.instance.role.roleEntityInfo.removeEventListener(EntityInfoEventName.UpdateLevel,updateLevel);
		    
			NetDispatcher.removeCmdListener(ServerCommand.GroupPlayerInfoChange,updateTeamMate);
			NetDispatcher.removeCmdListener(ServerCommand.GetNearTeam,updateNearTeam);
			NetDispatcher.removeCmdListener(ServerCommand.GroupInvite,updateInviteList);
			NetDispatcher.removeCmdListener(ServerCommand.GroupApply,updeteApplyList);
			NetDispatcher.removeCmdListener(ServerCommand.GetNearPlayer,updateNearPlayer);
			NetDispatcher.removeCmdListener(ServerCommand.GroupSettingUpdate,updateSetting);
			
			Dispatcher.removeEventListener(EventName.GetNearPlayer, updateNearPlayer);
			Dispatcher.removeEventListener(EventName.GetNearTeam,getNearTeam);
			Dispatcher.removeEventListener(EventName.GroupTabIndexChange,changeTabIndex);
			Dispatcher.removeEventListener(EventName.GroupSetting,changeSetting);
		}
		
		/**
		 * 更新队伍状态 
		 * 
		 */		
		private function updateTeamMate(obj:Object=null):void
		{
			if(_groupModel)
			{
				_groupModel.updateTeamMate();
			}
		}
		
		private function viewInitedHandler(evt:DataEvent):void
		{
			_groupModel.showSkin();
		}
		
		/**
		 * 更新自己等级(无队伍的时候) 
		 * 
		 */		
		private function updateLevel(e:Event = null):void
		{
			_groupModel.updateTeamMate();
		}
		
		private function disbanGroup(e:DataEvent = null):void
		{
			_groupProxy.disbandGroup();
		}
		
		/**
		 * 创建队伍 
		 * 
		 */		
		private function createGroupHandler(e:DataEvent):void
		{
			_groupProxy.createGroup();
		}
		
		/**
		 * 更新附近玩家 
		 * @param e
		 * 
		 */		
		private function updateNearPlayer(e:DataEvent = null):void
		{
			_groupModel.updateNearPlayer();
		}
		
		/**
		 * 队伍邀请操作
		 * @param e
		 * 
		 */		
		private function groupInviteOper(e:DataEvent):void
		{
			var arr:Array = e.data as Array;
			_groupProxy.groupOper(arr);
			
//			_groupCache.inviteList = [];
//			updateInviteList();
			
			//拒绝或同意
			if((arr[0] as SGroupOper).type == EGroupOperType._EGroupOperTypeAgree || (arr[0] as SGroupOper).type == EGroupOperType._EGroupOperTypeReject)
			{
				_groupCache.inviteList = [];
				updateInviteList();
			}
		}
		
		/**
		 * 队伍申请操作
		 * @param e
		 * 
		 */		
		private function groupApplyOper(e:DataEvent):void
		{
			var arr:Array = e.data as Array;
			_groupProxy.groupOper(arr);
			
			if(arr.length == 1)
			{
				for(var i:int ; i < _groupCache.applyList.length ; i++)
				{
					if((_groupCache.applyList[i] as SGroupOper).uid == (arr[0] as SGroupOper).uid)
					{
						_groupCache.applyList.splice(i,1);
					}
				}
			}
			else   //批量处理
			{
				_groupCache.applyList = [];
			}
			
			updeteApplyList();
		}
		
		/**
		 * 请求附近队伍 信息
		 * @param e
		 * 
		 */		
		private function getNearTeam(e:DataEvent):void
		{
//			var arr:Array = e.data as Array;
			var groupIdArr:Array = new Array();
			var entityArr:Array = Cache.instance.entity.getAllEntityInfo();
			
			for each(var i:EntityInfo in entityArr)
			{
				var isExit:Boolean;
				if(i.entityInfo.groupId.id != 0)
				{
					for each(var n:SEntityId in groupIdArr)
					{
						if(n.id == i.entityInfo.groupId.id)
						{
							isExit = true;
							break;
						}
					}
					if(!isExit)
					{
						groupIdArr.push(i.entityInfo.groupId);
					}
				}
			}
			
			_groupProxy.getGroupInfos(groupIdArr);
		}
		
		
		/**
		 * 更新附近队伍 
		 * @param obj
		 * 
		 */		
		private function updateNearTeam(obj:Object=null):void
		{
			_groupModel.updateNearTeam();
		}
			
		/**
		 * 更新邀请列表 
		 * @param obj
		 * 
		 */		
		private function updateInviteList(obj:Object=null):void
		{
			_groupModel.updateInviteList();
		}
		
		/**
		 * 踢出队伍 
		 * @param data
		 * 
		 */		
		private function kickOutPlayer(data:DataEvent):void
		{
			var sEntityId:SEntityId = data.data as SEntityId;
			_groupProxy.kickOut(sEntityId);
		}
		
		/**
		 * 离开队伍 
		 * @param data
		 * 
		 */		
		private function leaveGroup(data:DataEvent = null):void
		{
			_groupProxy.leftGroup();
		}
		
		/**
		 * 更新申请列表 
		 * @param obj
		 * 
		 */		
		private function updeteApplyList(obj:Object=null):void
		{
			_groupModel.updateApplyList();
		}
		
		/**
		 * 切换队长 
		 * @param data
		 * 
		 */		
		private function modifyCaptain(data:DataEvent = null):void
		{
			_groupProxy.modifyCaptain(data.data as SEntityId);
		}
		
		/**
		 * 改变设置 
		 * @param data
		 * 
		 */		
		private function changeSetting(data:DataEvent):void
		{
			var setting:SGroupSetting = data.data as SGroupSetting;
			_groupProxy.updateGroupSetting(setting);
		}
		
		/**
		 * 更新队伍设置 
		 * @param obj
		 * 
		 */		
		private function updateSetting(obj:Object = null):void
		{
			_groupModel.updateSetting();
		}
		
		private function changeTabIndex(data:DataEvent = null):void
		{
			var index:int = data.data as int;
			_groupModel.changeTabIndex(index);
		}
	}
}