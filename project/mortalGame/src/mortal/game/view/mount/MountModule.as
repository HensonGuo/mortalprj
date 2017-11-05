package mortal.game.view.mount
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTextFiled;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.BaseWindow;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mount.data.MountData;
	import mortal.game.view.mount.panel.MountAtrribuitePanel;
	import mortal.game.view.mount.panel.MountBasePanel;
	import mortal.game.view.mount.panel.MountInfoPanel;
	import mortal.game.view.mount.panel.MountLineagePanel;
	import mortal.game.view.mount.panel.MountListPanel;
	import mortal.game.view.mount.panel.MountUpgradePanel;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class MountModule extends BaseWindow
	{
		//数据
		/**分组标题数据*/
		private var _tabData:Array;
		
		private var _mountData:MountData;
		
		//显示对象
		/**分组导航*/
		private var _tabBar:GTabBar;
		
		private var _currentPanel:MountBasePanel; //当前显示的panel
		
		/**坐骑信息面板*/
		private var _mountInfoPanel:MountInfoPanel;
		
		/**坐骑培养面板*/
		private var _mountUpgradePanel:MountUpgradePanel;
		
		/**坐骑血统面板*/
		private var _mountLineagePanel:MountLineagePanel;
		
		//底部
		private var _mountListPanel:MountListPanel;
		
		
		public function MountModule($layer:ILayer=null)
		{
			_tabData = Language.getArray(30301);
			
			super($layer);
			this.layer = LayerManager.windowLayer3D;
			setSize(681,555);
			title = Language.getString(30300);
			titleIcon = ImagesConst.PackIcon;
			_titleHeight = 62;
		}
		
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_tabBar = UIFactory.gTabBar(12,33,_tabData,80,25,this,changeTabBar);
			_tabBar.selectedIndex = 0;
			
			LoaderHelp.addResCallBack(ResFileConst.mount, loadComplete);
		}
		
		private function loadComplete():void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.MountLoadComplete));
		}
		
		private function showCultureWin():void
		{
			changeTabBarByIndex(1);
		}
		
		public function showSkin():void
		{
			//上部部分
			changeTabBarByIndex(0);
			
			//底部
			_mountListPanel = UICompomentPool.getUICompoment(MountListPanel);
			_mountListPanel.x = 15;
			_mountListPanel.y = 373;
			this.addChild(_mountListPanel);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_mountListPanel.dispose(isReuse);
			_mountListPanel = null;
			
			_tabBar.dispose(isReuse);
			_tabBar = null;
			
			if(_mountInfoPanel)
			{
				_mountInfoPanel.dispose(isReuse);
				_mountInfoPanel = null;
			}
			
			if(_mountUpgradePanel)
			{
				_mountUpgradePanel.dispose(isReuse);
				_mountUpgradePanel = null;
			}
			
			if(_mountLineagePanel)
			{
				_mountLineagePanel.dispose(isReuse);
				_mountLineagePanel = null;
			}
			
			super.disposeImpl(isReuse);
		}
		
		private function addMountInfoPanel():MountInfoPanel
		{
			_mountInfoPanel = UICompomentPool.getUICompoment(MountInfoPanel,this);
			_mountInfoPanel.x = 19;
			_mountInfoPanel.y = 72;
			this.addChild(_mountInfoPanel);
			return _mountInfoPanel;
		}
		
		private function addMountUpgradePanel():MountUpgradePanel
		{
			_mountUpgradePanel = UICompomentPool.getUICompoment(MountUpgradePanel,this);
			_mountUpgradePanel.x = 19;
			_mountUpgradePanel.y = 72;
			this.addChild(_mountUpgradePanel);
			return _mountUpgradePanel;
		}
		
		private function addMountLineagePanel():MountLineagePanel
		{
			_mountLineagePanel = UICompomentPool.getUICompoment(MountLineagePanel);
			_mountLineagePanel.x = 19;
			_mountLineagePanel.y = 70;
			this.addChild(_mountLineagePanel);
			return _mountLineagePanel;
		}
		
		private function changeTabBarByIndex(index:int):void
		{
			_tabBar.selectedIndex = index;
			changeTabBar();
		}
			
		
		private function changeTabBar(e:MuiEvent = null):void
		{
			
			if(_currentPanel && _currentPanel.parent)
			{
				_currentPanel.dispose();
			}
			
			var index:int = _tabBar.selectedIndex;
			var changePanel:MountBasePanel;
			switch(index)
			{
				case 0:
					changePanel = addMountInfoPanel();
					break;
				case 1:
					changePanel = addMountUpgradePanel();
					break;
				case 2:
					changePanel = addMountLineagePanel();
					break;
			}
			
			if(changePanel)
			{
				_currentPanel = changePanel;
				
				if(_mountData && _mountData.isOwnMount)
				{
					_currentPanel.setMountInfo(_mountData);
				}
			}
		}
		
		/**
		 * 会自动选中坐骑 
		 * 
		 */		
		public function setListInfo():void
		{
			if(_mountListPanel)
			{
				_mountListPanel.setListInfo();
			}
		}
		
		
		public function setMountInfo(data:MountData):void
		{
			if(_mountData == data)  //再次点击自己,不执行更新
			{
				return;
			}
			_mountData = data;
			if(_currentPanel)
			{
				_currentPanel.setMountInfo(data);
			}
			
			if(_mountListPanel)
			{
				_mountListPanel.setMountInfo(data);
			}
			
		}
		
		public function setAllMountsAtrribuite():void
		{
			if(_mountInfoPanel && _mountInfoPanel.parent)
			{
				_mountInfoPanel.setAllMountsAtrribuite();
			}
			
		}
		
		public function setInfo():void
		{
			if(!_currentPanel)
			{
				return;
			}
			if(_mountData && _mountData.isOwnMount)
			{
				_currentPanel.setInfo();
			}
			else  //如果没有坐骑,清空数据
			{
				_currentPanel.clearWin();
				_mountListPanel.currentMountData = null;
				_mountData = null;
				setEquipBtn();
				setSelectMountBtn();
			}
		}
		
		public function setEquipBtn():void
		{
			if(_mountInfoPanel &&　_mountInfoPanel.parent)
			{
				_mountInfoPanel.setEquipBtn();
			}
		}
		
		public function setSelectMountBtn():void
		{
			if(_mountInfoPanel && _mountInfoPanel.parent)
			{
				_mountInfoPanel.setSelectMountBtn();
			}
		}
		
		public function setCurrentPage():void
		{
			if(_mountListPanel)
			{
				_mountListPanel.setCurrentPage();
			}
		}
		
		public function expUpdate():void
		{
			if(_mountUpgradePanel.parent)
			{
				_mountUpgradePanel.updateExp();
			}
		}
		
		public function levelUpdate():void
		{
			if(_mountUpgradePanel.parent)
			{
				_mountUpgradePanel.setInfo();
			}
		}
		
		/**
		 * 更新坐骑 (不会自动选中)
		 * 
		 */		
		public function refreshList():void
		{
			if(_mountListPanel)
			{
				_mountListPanel.onPageChange();
			}
		}
		
		public function openCultureTabWin():void
		{
			LoaderHelp.addResCallBack(ResFileConst.mount, showCultureWin);
		
		}
		
		public function startRuning(obj:Object):void
		{
			if(_mountLineagePanel.parent)
			{
				_mountLineagePanel.startRuning(obj);
			}
		
		}
		
		public function setSelectIndex(type:int):void
		{
			_mountListPanel.setSelectIndex(type);
		}
		
	}
}