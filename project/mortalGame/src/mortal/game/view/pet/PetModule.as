/**
 * @heartspeak
 * 2014-2-24
 */

package mortal.game.view.pet
{
	import Message.Game.SPet;
	
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTabBar2;
	import com.mui.core.GlobalClass;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mortal.common.display.LoaderHelp;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.pet.view.PetBloodPanel;
	import mortal.game.view.pet.view.PetGrowingPanel;
	import mortal.game.view.pet.view.PetListCellRenderer;
	import mortal.game.view.pet.view.PetMainPanel;
	import mortal.game.view.pet.view.PetPanelBase;
	import mortal.game.view.pet.view.PetSkillPanel;
	import mortal.game.view.pet.view.PetSkillSealPanel;
	import mortal.mvc.interfaces.ILayer;

	public class PetModule extends BaseWindow
	{
		private var _tabBar:GTabBar;
		protected var _petListText:GBitmap;
		protected var _petTabBar:GTabBar2;

		private var _dicIndexClass:Dictionary = new Dictionary();
		private var _dicIndexPanel:Dictionary = new Dictionary();
		private var _petMainPanel:PetMainPanel;
		private var _petGrowingPanel:PetGrowingPanel;
		private var _petBloodPanel:PetBloodPanel;
		private var _currentPanel:PetPanelBase;
		private var _petSkillPanel:PetSkillPanel;
		private var _petSkillSealPanel:PetSkillSealPanel;

		public function PetModule($layer:ILayer = null)
		{
			super($layer);
			setSize(764, 499);
			title = "宠物";
			titleHeight = 60;
			this.layer = LayerManager.windowLayer3D;
		}

		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			var tabData:Array = Language.getArray(70000);
			_tabBar = UIFactory.gTabBar(16, 32, tabData, 80, 26, this, onTabBarChange);


			//左边部分
			pushUIToDisposeVec(UIFactory.bg(15, 66, 167, 419, this));
			pushUIToDisposeVec(UIFactory.bg(17, 68, 163, 26, this, ImagesConst.RegionTitleBg));
			_petListText = UIFactory.gBitmap("", 25, 74, this);
			_petTabBar = UICompomentPool.getUICompoment(GTabBar2);
			_petTabBar.cellRenderer = PetListCellRenderer;
			_petTabBar.gap = 6;
			_petTabBar.cellWidth = 158;
			_petTabBar.cellHeight = 71;
			_petTabBar.direction = GBoxDirection.VERTICAL;
			_petTabBar.x = 20;
			_petTabBar.y = 98;
			_petTabBar.configEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE, onSelectChange);
			this.addChild(_petTabBar);

			_petMainPanel = new PetMainPanel(this);
			this.addChild(_petMainPanel);
			_currentPanel = _petMainPanel;

			_dicIndexClass[0] = PetMainPanel;
			_dicIndexPanel[0] = _petMainPanel;

			_dicIndexClass[1] = PetGrowingPanel;
			_dicIndexPanel[1] = _petGrowingPanel;
			
			_dicIndexClass[2] = PetBloodPanel;
			_dicIndexPanel[2] = _petBloodPanel;
			
			_dicIndexClass[3] = PetSkillPanel;
			_dicIndexPanel[3] = _petSkillPanel;
			
			_dicIndexClass[4] = PetSkillSealPanel;
			_dicIndexPanel[4] = _petSkillSealPanel;

			updatePets(Cache.instance.pet.pets);
			LoaderHelp.addResCallBack(ResFileConst.petMainPanel, onResCompl);
		}
		
		/**
		 * 资源加载完毕
		 *
		 */
		protected function onResCompl():void
		{
			_petListText.bitmapData = GlobalClass.getBitmapData(ImagesConst.PetListText);
//			add3DPet();
		}

		/**
		 * 切换tabbar
		 * @param e
		 */
		protected function onTabBarChange(e:Event):void
		{
			var panel:PetPanelBase = _dicIndexPanel[_tabBar.selectedIndex] as PetPanelBase;
			if (panel != _currentPanel)
			{
				_currentPanel.dispose(false);

				if (!panel)
				{
					panel = new _dicIndexClass[_tabBar.selectedIndex](this);
				}
				panel.createDisposedChildren();
				this.addChild(panel);

				_currentPanel = panel;
				onSelectChange();
			}
		}

		protected function onSelectChange(e:MuiEvent = null):void
		{
			var pet:SPet = _petTabBar.dataProvider[_petTabBar.selectIndex];
			(_currentPanel as PetPanelBase).updateMsg(pet);
		}
	
		/**
		 * 更新宠物列表
		 * @param pet
		 *
		 */
		public function updatePets(pets:Array):void
		{
			updatePetsTabbar(pets);
			onSelectChange();
		}

		private function updatePetsTabbar(pets:Array):void
		{
			var petArray:Array = [];
			for (var i:int = 0; i < 5; i++)
			{
				if (pets.length > i)
				{
					petArray.push(pets[i]);
				}
				else
				{
					petArray.push(null);
				}
			}
			_petTabBar.dataProvider = petArray;
		}
		
		/**
		 * 更新宠物属性
		 * @param uid
		 *
		 */
		public function updatePetAttribute(uid:String):void
		{
			if (_currentPanel is PetBloodPanel)
			{
				(_currentPanel as PetBloodPanel).flyChars();
			}
			(_currentPanel as PetPanelBase).updatePetAttribute(uid);
			var pet:SPet = Cache.instance.pet.getSpetByUid(uid);
			var cell:PetListCellRenderer = _petTabBar.itemToCell(pet) as PetListCellRenderer;
			if(cell)
			{
				cell.data = pet;
			}
		}

		override protected function disposeImpl(isReuse:Boolean = true):void
		{
			super.disposeImpl(isReuse);
			_petListText.dispose(isReuse);
			_petTabBar.dispose(isReuse);

			_petListText = null;
			_petTabBar = null;

			_tabBar.dispose();
			_currentPanel.dispose();

			_currentPanel = null;
			_tabBar = null;
		}
	}
}
