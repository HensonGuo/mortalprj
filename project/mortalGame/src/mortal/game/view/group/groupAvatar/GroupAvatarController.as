package mortal.game.view.group.groupAvatar
{
	import Message.Public.SEntityId;
	
	import flash.events.Event;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.GameManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.group.GroupCache;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class GroupAvatarController extends Controller
	{
		private var _groupAvatarView:GroupAvatarView;
		
		private var _groupCahce:GroupCache;
		
		public function GroupAvatarController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_groupCahce = Cache.instance.group;
		}
		
		override protected function initView():IView
		{
			if (_groupAvatarView == null)
			{
				_groupAvatarView=new GroupAvatarView();
				_groupAvatarView.addEventListener(WindowEvent.SHOW, onGroupShow);
				_groupAvatarView.addEventListener(WindowEvent.CLOSE, onGroupClose);
			}
			return _groupAvatarView;
		}
		
		override protected function initServer():void
		{
			NetDispatcher.addCmdListener(ServerCommand.GroupPlayerInfoChange,updateGroupAvatar);   //更新队伍信息
			NetDispatcher.addCmdListener(ServerCommand.TeamMateLeft,teamMateLeave);   //队员离开
			NetDispatcher.addCmdListener(ServerCommand.updateTeamMateState,updateTeamMateState);
			
			Dispatcher.addEventListener(EventName.SceneAddGroupmate,teamMateIn);
			Dispatcher.addEventListener(EventName.SceneRemoveGroupmate,teamMateOut);
		}
		
		private function onGroupShow(e:Event):void
		{
			
		}
		
		private function onGroupClose(e:Event):void
		{
		}
		
		/**
		 * 更新整个队伍 
		 * @param data
		 * 
		 */		
		private function updateGroupAvatar(data:Object = null):void
		{
			if(_groupCahce.isInGroup)
			{
				if(_groupAvatarView == null || _groupAvatarView.isHide)
				{
					GameManager.instance.popupWindow(ModuleType.GroupAvatar);
				}
				_groupAvatarView.updateTeamMate();
			}
			else
			{
				if(_groupAvatarView)
				{
					_groupAvatarView.hide();
				}
			}
		}
		
		/**
		 * 队员进入范围 
		 * @param data
		 * 
		 */		
		private function teamMateIn(data:DataEvent):void
		{
			var entityInfo:EntityInfo = data.data as EntityInfo;
			if(_groupAvatarView)
			{
				_groupAvatarView.teamMateIn(entityInfo);
			}
		
		}
		
		/**
		 * 队员离开范围 
		 * @param data
		 * 
		 */		
		private function teamMateOut(data:DataEvent):void
		{
			var entityId:SEntityId = data.data as SEntityId;
			if(_groupAvatarView)
			{
				_groupAvatarView.teamMateOut(entityId);
			}
		}
		
		/**
		 * 队员离开 
		 * @param obj
		 * 
		 */		
		private function teamMateLeave(obj:Object):void
		{
			var entityId:SEntityId = obj as SEntityId;
			if(_groupAvatarView)
			{
				_groupAvatarView.removeTeamMate(entityId);
			}
		}
		
		private function updateTeamMateState(obj:Object):void
		{
			if(_groupAvatarView)
			{
				_groupAvatarView.updateTeamMateState(obj);
			}
		}
	}
}