package mortal.game.view.group
{
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import mortal.common.display.LoaderHelp;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.group.panel.GroupApplyPanel;
	import mortal.game.view.group.panel.GroupInvitePanel;
	import mortal.game.view.group.panel.NearPlayerPanel;
	import mortal.game.view.group.panel.NearTeamsPanel;
	import mortal.game.view.group.panel.TeamInfoPanel;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class GroupMoudle extends BaseWindow
	{
		//数据
		/**分组标题数据*/
		private var _tabData:Array;
		
		
		//显示对象
		/**分组导航*/
		private var _tabBar:GTabBar;
		
		/**队伍信息*/
		private var _teamInfoPanel:TeamInfoPanel;
		
		private var _nearTeamsPanel:NearTeamsPanel;
		
		private var _nearPlayerPanel:NearPlayerPanel;
		
		private var _applyPanel:GroupApplyPanel;
		
		private var _invitePanel:GroupInvitePanel;
		
		private var _currentPanel:GSprite;  //当前显示的panel
		
		
		public function GroupMoudle($layer:ILayer=null)
		{
			_tabData = Language.getArray(30200);
			
			super($layer);
			init();
			this.layer = LayerManager.windowLayer3D;
		}
		
		private function init():void
		{
			setSize(795,451);
			title = Language.getString(30201);
			titleIcon = ImagesConst.PackIcon;
//			this.isHideDispose = false;
			_titleHeight = 62;
		}
		
//		override protected function updateWindowCenterSize():void
//		{
//			if( _windowCenter )
//			{
//				var w:Number = this.width - paddingLeft-paddingRight;
//				var h:Number = this.height -paddingBottom-_titleHeight - 30;
//				_windowCenter.setSize(w,h);
//				_windowCenter.x = paddingLeft;
//				_windowCenter.y = _titleHeight + 30;
//			}
//			
//			if (_windowCenter2)
//			{
//				_windowCenter2.x = _windowCenter.x + 4;
//				_windowCenter2.y = _windowCenter.y + 5;
//				_windowCenter2.width = _windowCenter.width - 10;
//				_windowCenter2.height = _windowCenter.height - 10;
//			}
//		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_tabBar = UIFactory.gTabBar(12,33,_tabData,80,25,this,onTabBarSelectedChange);
			_tabBar.selectedIndex = 0;
			
			LoaderHelp.addResCallBack(ResFileConst.groupPanel, onGetRes);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_tabBar.dispose(isReuse);
			if(_teamInfoPanel)
			{
				_teamInfoPanel.dispose(isReuse);
			}
			
			if(_nearPlayerPanel)
			{
				_nearPlayerPanel.dispose(isReuse);
			}
			
			if(_nearTeamsPanel)
			{
				_nearTeamsPanel.dispose(isReuse);
			}
		
			if(_invitePanel)
			{
				_invitePanel.dispose(isReuse);
			}
			
			if(_applyPanel)
			{
				_applyPanel.dispose(isReuse);
			}
			
			_tabBar = null;
			_teamInfoPanel = null;
			_nearPlayerPanel = null;
			_nearTeamsPanel = null;
			_invitePanel = null;
			_applyPanel = null;
			
			super.disposeImpl(isReuse);
		}
		
		private function onGetRes():void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.GroupPanel_ViewInited));
		}
		
		private function addTeamInfoPanel():TeamInfoPanel
		{
			_teamInfoPanel = UICompomentPool.getUICompoment(TeamInfoPanel,this);
			_teamInfoPanel.x = -3;
			addChild(_teamInfoPanel);
			return _teamInfoPanel;
		}
		
		private function addNearPlayerPanel():NearPlayerPanel
		{
			_nearPlayerPanel = UICompomentPool.getUICompoment(NearPlayerPanel);
			_nearPlayerPanel.createDisposedChildren();
			_nearPlayerPanel.x = -3;
			addChild(_nearPlayerPanel);
			return _nearPlayerPanel;
		}
		
		private function addNearTeamPanel():NearTeamsPanel
		{
			_nearTeamsPanel = UICompomentPool.getUICompoment(NearTeamsPanel);
			_nearTeamsPanel.createDisposedChildren();
			_nearTeamsPanel.x = -3;
			addChild(_nearTeamsPanel);
			return _nearTeamsPanel;
		}
		
		private function addInvitePanel():GroupInvitePanel
		{
			_invitePanel = UICompomentPool.getUICompoment(GroupInvitePanel);
			_invitePanel.createDisposedChildren();
			_invitePanel.x = -3;
			addChild(_invitePanel);
			return _invitePanel;
		}
		
		private function addApplyPanel():GroupApplyPanel
		{
			_applyPanel = UICompomentPool.getUICompoment(GroupApplyPanel);
			_applyPanel.createDisposedChildren();
			_applyPanel.x = -3;
			addChild(_applyPanel);
			return _applyPanel;
		}
		
		private function onTabBarSelectedChange(e:MuiEvent):void
		{
			changeTabBarByIndex(_tabBar.selectedIndex);
		}
		
		public function changeTabBarByIndex(index:int):void
		{
			var changePanel:GSprite;
			switch(index)
			{
				case 0:
					changePanel = addTeamInfoPanel();
					updateTeamMate();
					break;
				case 1:
					changePanel = addNearTeamPanel();
					Dispatcher.dispatchEvent(new DataEvent(EventName.GetNearTeam));
					break;
				case 2:
					changePanel = addNearPlayerPanel();
					Dispatcher.dispatchEvent(new DataEvent(EventName.GetNearPlayer));
					break;
				case 3:
					changePanel = addApplyPanel();
					updateApplyList();
					break;
				case 4:
					changePanel = addInvitePanel();
					updateInviteList();
					break;
					
			}
			
			if(changePanel)
			{
				if(_currentPanel && _currentPanel != changePanel && _currentPanel.parent)
				{
					_currentPanel.dispose();
				}
				_currentPanel = changePanel;
			}
		}
		
		private function getNearGroupIdArr():void
		{
//			var groupIdArr:Array = new Array();
//			var entityArr:Array = Cache.instance.entity.getAllEntityInfo();
//			
//			for each(var i:EntityInfo in entityArr)
//			{
//				if(i.entityInfo.groupId.id != 0)
//				{
//					if(!groupIdArr.indexOf(i.entityInfo.groupId))
//					{
//						groupIdArr.push(i.entityInfo.groupId);
//					}
//				}
//			}
			
//			Dispatcher.dispatchEvent(new DataEvent(EventName.GetNearTeam));
		}
		
		public function showSkin():void
		{
			if(_tabBar.selectedIndex != 0)  //当打开的是其他标签的话,就不需要执行默认打开第一个标签
			{
				return;
			}
			changeTabBarByIndex(0);
		}
		
		public function updateTeamMate():void
		{
			if(_teamInfoPanel && _teamInfoPanel.parent)
			{
				_teamInfoPanel.updateTeamMate();
			}
		}
		
		public function updateNearPlayer():void
		{
			if(_nearPlayerPanel && _nearPlayerPanel.parent)
			{
				_nearPlayerPanel.updatePlayerList();
			}
		}
		
		public function updateNearTeam():void
		{
			if(_nearTeamsPanel && _nearTeamsPanel.parent)
			{
				_nearTeamsPanel.updateTeamList();
			}
		}
		
		public function updateInviteList():void
		{
			if(_invitePanel && _invitePanel.parent)
			{
				_invitePanel.updateInviteList();
			}
		}
		
		public function updateApplyList():void
		{
			if(_applyPanel && _applyPanel.parent)
			{
				_applyPanel.updateApplyList();
			}
		}
		
		public function changeTabIndex(value:int):void
		{
			_tabBar.selectedIndex = value;
			changeTabBarByIndex(value);
		}
		
		public function updateSetting():void
		{
			if(_teamInfoPanel && _teamInfoPanel.parent)
			{
				_teamInfoPanel.updateSetting();
			}
		}
	}
}