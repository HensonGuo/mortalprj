package mortal.game.view.forging
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.core.GlobalClass;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import flash.utils.Dictionary;
	
	import mortal.common.display.LoaderHelp;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.forging.view.EquipDisplaySpr;
	import mortal.game.view.forging.view.EquipRefreshPanel;
	import mortal.game.view.forging.view.ForgingPanelBase;
	import mortal.game.view.forging.view.GemEmbedPanel;
	import mortal.game.view.forging.view.GemStrengthenPanel;
	import mortal.game.view.forging.view.StrengthenPanel;
	import mortal.game.view.palyer.PlayerEquipItem;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	/**
	 * 锻造
	 * @date   2014-3-12 下午4:45:07
	 * @author dengwj
	 */	 
	public class ForgingModule extends BaseWindow
	{
		/** 页签 */
		private var _tabBar:GTabBar;
		
		/** 右侧装备展示部分 */
		private var _equipDisplaySpr:EquipDisplaySpr;
		/** 装备强化面板 */
		private var _strengthenPanel:StrengthenPanel;
		/** 宝石强化面板 */
		private var _gemStrengthenPanel:GemStrengthenPanel;
		/** 宝石镶嵌面板 */
		private var _gemEmbedPanel:GemEmbedPanel;
		/** 装备洗练面板 */
		private var _equipRefreshPanel:EquipRefreshPanel;
		
		private var _dicIndexClass:Dictionary = new Dictionary();
		private var _dicIndexPanel:Dictionary = new Dictionary();
		
		/** 当前选中面板 */
		private var _currentPanel:ForgingPanelBase;
		/** 当前选中页签 */
		private var _currSelPage:int;
		
		/** 是否资源已加载完 */
		private var _isLoadCompl:Boolean = false; 
		
		/** 3D模型 */
		private var _rect3d:Rect3DObject;
		
		public function ForgingModule(layer:ILayer=null)
		{
			super(layer);
			
			setSize(664,494);
			title = "锻造";
			titleIcon = ImagesConst.PackIcon;
			this.layer = LayerManager.windowLayer3D;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_tabBar = UIFactory.gTabBar(14, 33, [{label: "装备强化", name: "equipStrenthen"}, 
				{label: "宝石强化", name: "gemStrengthen"}, {label: "宝石镶嵌", name: "gemEmbed"}],88, 28, this, onTabBarChange);
			
			// 角色装备展示部分
			this._equipDisplaySpr = UICompomentPool.getUICompoment(EquipDisplaySpr,this);
			this._equipDisplaySpr.createDisposedChildren();
			this._equipDisplaySpr.x = 365;
			this._equipDisplaySpr.y = 70-54;
			this.contentTopOf3DSprite.addChild(this._equipDisplaySpr);
			
			// 装备强化
			this._strengthenPanel = UICompomentPool.getUICompoment(StrengthenPanel,this);
			this._strengthenPanel.createDisposedChildren();
			this._strengthenPanel.x = 21;
			this._strengthenPanel.y = 72;
			this.contentTopOf3DSprite.addChild(this._strengthenPanel);
			this._currentPanel = _strengthenPanel;
			
			_dicIndexClass[0] = strengthenPanel;
			_dicIndexPanel[0] = _strengthenPanel;
			
			_dicIndexClass[1] = GemStrengthenPanel;
			_dicIndexPanel[1] = _gemStrengthenPanel;
			
			_dicIndexClass[2] = GemEmbedPanel;
			_dicIndexPanel[2] = _gemEmbedPanel;
			
			_dicIndexClass[3] = EquipRefreshPanel;
			_dicIndexPanel[3] = _equipRefreshPanel;
			
			LoaderHelp.addResCallBack(ResFileConst.forging,onResLoadCompl);
		}
		
		private function onResLoadCompl():void
		{
			this._isLoadCompl = true;
			if(!isDisposed)
			{
				initView();
			}
		}
		
		/**
		 * 资源加载完后初始化界面 
		 */		
		private function initView():void
		{
			this._equipDisplaySpr.updateUI();
			this._currentPanel.updateUI();
		}
		
		override protected function updateWindowCenterSize():void
		{
			if( _windowCenter )
			{
				_windowCenter.setSize(650, 424);
				_windowCenter.x = 11;
				_windowCenter.y = 63;
			}	
		}
		
		private function onTabBarChange(e:MuiEvent):void
		{
			this._currSelPage = _tabBar.selectedIndex;
			if(this.equipDisplaySpr.currSelEquip != null)
			{
				this.equipDisplaySpr.currSelEquip.setSelEffect(false);
				this.equipDisplaySpr.currSelEquip = null;
			}
			if(Cache.instance.forging.embedCallBackData != null)
			{
				Cache.instance.forging.embedCallBackData = null;
			}
			var panel:ForgingPanelBase = _dicIndexPanel[_tabBar.selectedIndex] as ForgingPanelBase;
			if (panel != _currentPanel)
			{
				_currentPanel.dispose();
				
				if (!panel)
				{
					panel = new _dicIndexClass[_tabBar.selectedIndex](this);
					_dicIndexPanel[_tabBar.selectedIndex] = panel;
				}
				panel.createDisposedChildren();
				this.contentTopOf3DSprite.addChild(panel);
				panel.updateUI();
				panel.x = 18;
				panel.y = 70;
				_currentPanel = panel;
			}
			if(_currentPanel is GemEmbedPanel)
			{
				this.equipDisplaySpr.updateEmbedState();
			}
			else
			{
				this.equipDisplaySpr.clear();
			}
		}	
		
		public function upDateEquipByType(type:int):void
		{
			var equip:PlayerEquipItem     = _equipDisplaySpr.getEquipByType(type);
			var currEquip:PlayerEquipItem = _equipDisplaySpr.currSelEquip;
			_equipDisplaySpr.upDateEquipByType(type);
			if(_currSelPage == 0)
			{
				var equipNew:PlayerEquipItem  = _equipDisplaySpr.getEquipByType(type);
				if(equip && currEquip && equip.itemData.uid == currEquip.itemData.uid)
				{
					_equipDisplaySpr.currSelEquip = equipNew;
					Dispatcher.dispatchEvent(new DataEvent(EventName.AddEquipStrengthen,equipNew));
				}
			}
			
			if(_currSelPage == 1)
			{
				
			}
			
			if(_currSelPage == 2)
			{
				
			}
		}
		
		public function upDateAllEquip():void
		{
			_equipDisplaySpr.upDateAllEquip();
		}
		
		public function get strengthenPanel():StrengthenPanel
		{
			return this._strengthenPanel;
		}
		
		public function get gemEmbedPanel():GemEmbedPanel
		{
			return this._gemEmbedPanel;
		}
		
		public function get gemStrengthenPanel():GemStrengthenPanel
		{
			return this._gemStrengthenPanel;
		}
		
		public function get currSelPage():int
		{
			return this._currSelPage;
		}
		
		public function set currSelPage(page:int):void
		{
			this._currSelPage = page;
		}
		
		public function get currentPanel():ForgingPanelBase
		{
			return this._currentPanel;
		}
		
		public function set currentPanel(panel:ForgingPanelBase):void
		{
			this._currentPanel = panel;	
		}
		
		public function get equipDisplaySpr():EquipDisplaySpr
		{
			return this._equipDisplaySpr;
		}
		
		public function get rect3d():Rect3DObject
		{
			return this._rect3d;
		}
		
		public function set rect3d(rect3d:Rect3DObject):void
		{
			this._rect3d = rect3d;
		}
		
		override protected function disposeImpl(isReuse:Boolean = true):void
		{
			super.disposeImpl(isReuse);
			
			this._tabBar.dispose(isReuse);
			this._equipDisplaySpr.dispose(isReuse);
			this._currentPanel.dispose(isReuse);
			
			this._tabBar = null;
			this._equipDisplaySpr = null;
			this._currentPanel = null;
			this._currSelPage = 0;
			if (_rect3d)
			{
				Rect3DManager.instance.disposeRect3d(_rect3d);
				_rect3d = null;
			}
		}
	}
}