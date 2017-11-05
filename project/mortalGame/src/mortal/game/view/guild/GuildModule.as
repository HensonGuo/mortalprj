package mortal.game.view.guild
{
	import com.mui.controls.GTabBar;
	
	import extend.language.Language;
	
	import flash.events.Event;
	
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.guild.tabpanel.GuildBasePanel;
	import mortal.game.view.guild.tabpanel.GuildBranchManagerPanel;
	import mortal.game.view.guild.tabpanel.GuildInfoPanel;
	import mortal.game.view.guild.tabpanel.GuildMembersPanel;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildModule extends BaseWindow
	{
		private var _tabBar:GTabBar = null;
		private var _tabData:Array = null;
		private var _curPanel:GuildBasePanel = null;
		private var _panelClassList:Vector.<Class> = null;
		
		public function GuildModule($layer:ILayer=null)
		{
			super($layer);
			setSize(732, 533);
			title = "公会";
			titleHeight = 60;
			titleIcon = ImagesConst.PackIcon;
			this.layer = LayerManager.windowLayer3D;
		}
		
		override protected function configUI():void
		{
			_tabData = Language.getArray(60002);
			_panelClassList = new Vector.<Class>();
			_panelClassList.push(GuildInfoPanel);
			_panelClassList.push(GuildMembersPanel);
			_panelClassList.push(GuildBranchManagerPanel);
			super.configUI();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_tabBar = UIFactory.gTabBar(16, 32, _tabData, 80, 26, this, onTabBarChange);
			
			_curPanel = new _panelClassList[0]();
			this.addChild(_curPanel);
		}
		
		protected function onTabBarChange(e:Event):void
		{
			if (_tabBar.selectedIndex >= _panelClassList.length)
				return;
			if (_curPanel is _panelClassList[_tabBar.selectedIndex])
				return;
			if (_panelClassList[_tabBar.selectedIndex] == GuildBranchManagerPanel)
			{
				if (!Cache.instance.guild.selfGuildInfo.hasCreatedBranch)
				{
					MsgManager.showRollTipsMsg("您还未创建分会");
					return;
				}
			}
			_curPanel.dispose();
			_curPanel = new _panelClassList[_tabBar.selectedIndex]();
			_curPanel.createDisposedChildren();
			this.addChild(_curPanel);
		}
		
		public function update():void
		{
			if (_curPanel == null)
				return;
			if (_curPanel.visible == false)
				return;
			if (_curPanel.isLoadComplete)
				_curPanel.update();
		}
		
		public function onCreateGuildBranch():void
		{
			_tabBar.selectedIndex = 2;
			onTabBarChange(null);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_tabBar.dispose();
			_tabBar = null;
			if (_curPanel)
				_curPanel.dispose();
			_curPanel = null;
		}
	}
}