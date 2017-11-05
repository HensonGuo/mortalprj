/**
 * @heartspeak
 * 2014-4-24 
 */   	

package mortal.game.view.systemSetting
{
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import mortal.component.window.BaseWindow;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.interfaces.ILayer;
	import mortal.game.view.systemSetting.view.ShortcutsPanel;
	import mortal.game.view.systemSetting.view.SystemSetPanel;
	
	public class SystemSettingModule extends BaseWindow
	{
		protected var _tabBar:GTabBar;
		protected var _systemSetPanel:SystemSetPanel;
		protected var _shortcutsPanel:ShortcutsPanel;
		protected var _lastIndex:int;
		
		public function SystemSettingModule($layer:ILayer=null)
		{
			super($layer);
			setSize(495,440);
			title = "系统";
			titleHeight = 60;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			var tabBarData:Array = new Array({label:"系统设置",name:"systemSet"},{label:"快捷键",name:"shortCuts"});
			_tabBar = UIFactory.gTabBar(17,30,tabBarData,76,28,this,onTabBarChange);
			
			_systemSetPanel = UICompomentPool.getUICompoment(SystemSetPanel);
			this.addChild(_systemSetPanel);
			_lastIndex = 0;
		}
		
		/**
		 * tabBarChange事件 
		 * @param e
		 * 
		 */		
		protected function onTabBarChange(e:MuiEvent):void
		{
			disposeLastPanel();
			switch(_tabBar.selectedIndex)
			{
				case 0:
					if(!_systemSetPanel)
					{
						_systemSetPanel = UICompomentPool.getUICompoment(SystemSetPanel);
						this.addChild(_systemSetPanel);
					}
					_lastIndex = 0;
					break;
				case 1:
					if(!_shortcutsPanel)
					{
						_shortcutsPanel = UICompomentPool.getUICompoment(ShortcutsPanel);
						this.addChild(_shortcutsPanel);
					}
					_lastIndex = 1;
					break;
			}
		}
		
		protected function disposeLastPanel():void
		{
			switch(_lastIndex)
			{
				case 0:
					_systemSetPanel.dispose();
					_systemSetPanel = null;
					break;
				case 1:
					_shortcutsPanel.dispose();
					_shortcutsPanel = null;
					break;
			}
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_tabBar.dispose(isReuse);
			_tabBar = null; 
			if(_systemSetPanel)
			{
				_systemSetPanel.dispose(isReuse);
				_systemSetPanel = null;
			}
			if(_shortcutsPanel)
			{
				_shortcutsPanel.dispose(isReuse);
				_shortcutsPanel = null;
			}
			_lastIndex = 0;
		}
	}
}