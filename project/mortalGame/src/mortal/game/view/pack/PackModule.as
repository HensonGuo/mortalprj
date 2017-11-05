
package mortal.game.view.pack
{
	import Message.Game.SMoney;
	import Message.Public.EPlayerItemPosType;
	
	import com.gengine.debug.Log;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.DragEvent;
	import com.mui.events.MuiEvent;
	import com.mui.manager.IDragDrop;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import modules.interfaces.IPackModule;
	
	import mortal.common.swfPlayer.SWFPlayer;
	import mortal.common.swfPlayer.data.ModelType;
	import mortal.component.window.BaseWindow;
	import mortal.component.window.BaseWindow2;
	import mortal.game.cache.Cache;
	import mortal.game.cache.packCache.BackPackCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.wizard.GTabarNew;
	import mortal.mvc.core.Dispatcher;
	
	public class PackModule extends BaseWindow2 implements IPackModule
	{
		//数据
		/**分组标题数据*/
		private var _packTabData:Array;
		/**分页标题数据*/
		private var _packPageData:Array;
		/**每页默认格子数*/
		private const _pageSize:int=49;
		/**背包位置*/
		private var _posType:int = 0;
		
		//显示对象
		/**分组导航*/
		private var _tabBar:GTabarNew;
		
		/**分页导航*/
		private var _pageTabBar:CanDropTabBar;
		
		/**背包格子背景数组*/
		private var _bgArray:Array;
		
		/**背包物品显示区域*/
		private var _packItemPanel:GTileList;
		
		/**底部区域*/
		private var _bottomPart:PackBottomPart;
		
		private var _showIconList:Vector.<ScaleBitmap>;
		
		
		public function PackModule()
		{
			_packTabData = Language.getArray(30057);
			_packPageData = [{name: "page1", label: "1", pageIndex: 0}, {name: "page2", label: "2", pageIndex: 1}, 
				{name: "page3", label: "3", pageIndex: 2}, {name: "page4", label: "4", pageIndex: 3}];
			super();
			init();
		}
		
		private function init():void
		{
			setSize(343,500);
//			title = Language.getString(20021);
//			titleIcon = ImagesConst.PackIcon;
		}
		
		override protected function setWindowCenter():void
		{
//			_windowCenter = ResouceConst.getScaleBitmap("WindowCenterA");
		}
		
		override protected function updateWindowCenterSize(  ):void
		{
			if( _windowCenter )
			{
				var w:Number = this.width - 4;
				var h:Number = this.height  - _titleHeight - paddingBottom - blurTop - blurBottom; ;
				_windowCenter.setSize(w,h);
				_windowCenter.x = 2;
				_windowCenter.y = _titleHeight + blurTop;
			}	
			
			if (_windowCenter2)
			{
				_windowCenter2.x = _windowCenter.x + 5;
				_windowCenter2.y = _windowCenter.y + 5;
				_windowCenter2.width = _windowCenter.width - 10;
				_windowCenter2.height = _windowCenter.height - 10;
			}
			
			if(_windowLine)
			{
				var k:Number = this.width - paddingLeft - paddingRight - blurLeft - blurRight;
				_windowLine.setSize(k,7);
				_windowLine.x = paddingLeft + blurLeft;
				_windowLine.y = _titleHeight + blurTop - 7;
			}
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec( UIFactory.bg(8,55,333,320,this,ImagesConst.PanelBg));
			
			//道具分组
//			_tabBar = UIFactory.gTabBar(17,33,_packTabData,72,25,this,tabBarChangeHandler);
			_tabBar = UIFactory.gTabBarNew(2,25, _packTabData,343,65,26,this,tabBarChangeHandler,"TabButtonNew");
			_tabBar.selectedIndex=0;
			
			//背包格子部分
			_packItemPanel = UIFactory.tileList(13,60,314,315,this);
			_packItemPanel.rowHeight = 40;
			_packItemPanel.columnWidth = 40;
			_packItemPanel.horizontalGap = 5;
			_packItemPanel.verticalGap = 5;
			_packItemPanel.setStyle("cellRenderer", PackCellRenderer);
			_packItemPanel.configEventListener(DragEvent.Event_Move_In, moveInBagHandler);
			_packItemPanel.isCanSelect = false;
			this.addChild(_packItemPanel);

			
			//底部1
			_bottomPart = UICompomentPool.getUICompoment(PackBottomPart);
			_bottomPart.createDisposedChildren();
			_bottomPart.x = 9;
			_bottomPart.y = 350;
			this.addChild(_bottomPart);
			
			//分页
			_pageTabBar = UICompomentPool.getUICompoment(CanDropTabBar);
			_pageTabBar.x = 16;
			_pageTabBar.y = 377;
			_pageTabBar.buttonHeight = 20;
			_pageTabBar.buttonWidth = 20;
			_pageTabBar.horizontalGap = 3;
			_pageTabBar.buttonStyleName = "PageBtn";
			_pageTabBar.dataProvider = _packPageData;
			_pageTabBar.checkDrag = checkPageTabBarDrag;
			_pageTabBar.configEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE, pageBarChangeHandler);
			_pageTabBar.drawNow();
			_pageTabBar.visible = false;
			this.addChild(_pageTabBar);
			
			_showIconList = new Vector.<ScaleBitmap>();
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			
			super.disposeImpl(isReuse);

			_tabBar.dispose(isReuse);
			_bottomPart.dispose(isReuse);
			_pageTabBar.dispose(isReuse);
			_packItemPanel.dispose(isReuse);
			
			_tabBar = null;
			_bottomPart = null;
			_pageTabBar = null;
			_packItemPanel = null;
		}
		
		private var _dragable:Boolean=true;
		private var _dropable:Boolean=true;
		
		private function moveInBagHandler(e:DragEvent):void
		{
			if (_dropable)
			{
				var dragItem:BaseItem=e.dragItem as BaseItem;
				var dropItem:BaseItem=e.dropItem as BaseItem;
				var dragSource:ItemData=e.dragSouce as ItemData;
				var dropSource:ItemData=dropItem.itemData;
				
				if(dragItem && dropItem && dragItem == dropItem || dragItem == null || _tabBar.selectedIndex != 0)
				{
					return;
				}
				
				if (dragSource && (_posType == EPlayerItemPosType._EPlayerItemPosTypeBag || _posType == dragSource.posType))
				{
					var dragDropData:DragDropData=new DragDropData(dragSource.serverData.posType, _posType, dragSource.serverData.uid, dragItem.pos, dropItem.pos, dragSource, dropSource);
					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_DragInItem, dragDropData));
				}
			}
			e.stopImmediatePropagation();
		}
		
		private function checkPageTabBarDrag(obj:IDragDrop):Boolean
		{
//			if (_tabBar.selectedIndex == 0 && (obj is PackItem || obj is PackExtendItem))
//			{
//				return true;
//			}
			return false;
		}
		
		private function tabBarChangeHandler(e:MuiEvent = null):void
		{
			_pageTabBar.selectedIndex = 0;
			updateAllItems();
		}
		
//		private var _tabDict:Dictionary=new Dictionary();
		
		private function pageBarChangeHandler(e:MuiEvent):void
		{
//			_tabDict[_tabBar.selectedIndex]=_pageTabBar.selectedIndex;
			updateAllItems();
			_packItemPanel.selectedIndex = -1;
		}
		
		/**从缓存中获取物品数据**/
		private function getDataProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var items:Array;
			var len:int;
			
			if (Cache.instance.pack.backPackCache && Cache.instance.pack.backPackCache.sbag)
			{
				switch (_tabBar.selectedIndex)
				{
					case 0:
						items=Cache.instance.pack.backPackCache.getItemsAtPage(_pageTabBar.selectedIndex + 1, _pageSize);
						break;
					case 1:
						items=Cache.instance.pack.backPackCache.getPropItemsAtPage(_pageTabBar.selectedIndex + 1, _pageSize);
						break;
					case 2:
						items=Cache.instance.pack.backPackCache.getStuffsItemsAtPage(_pageTabBar.selectedIndex + 1, _pageSize);
						break;
					case 3:
						items=Cache.instance.pack.backPackCache.getTaskItemsAtPage(_pageTabBar.selectedIndex + 1, _pageSize);
						break;
				}
			}
			
			if(items)
			{
				len = items.length;
				for (var j:int=0; j < len; j++)
				{
					var obj:Object=getDataObjectByItemData(items[j]);
					dataProvider.addItem(obj);
				}
			}
			return dataProvider;
		}
		
		private function getDataObjectByItemData(itemData:ItemData):Object
		{
			
			var obj:Object=new Object();
			if (itemData is ItemData)      //拥有物品
			{
				obj.itemData=itemData;
				obj.isOpened=true;
				

				if(itemData.itemInfo)
				{
//					if (Cache.instance.trade.isTrading)
					if (GameController.trade.isViewShow)
					{
						if (ItemsUtil.isBind(itemData))
						{
							obj.locked=true;
						}
						var Obj:Dictionary = Cache.instance.trade.usedItems;
						if (Cache.instance.trade.usedItems[itemData.uid])
						{
							obj.used=true;
						}
					}
				}
			}
			else       //已经解锁的空格子
			{
				obj.isOpened=true; 
			}
			return obj;
		}
		
		/**
		 * 设置BaseItemPanel的dataProvider，改变显示物品列表
		 *
		 * */
		public function updateAllItems():void
		{
			if(!_disposed)
			{
				_packItemPanel.dataProvider = getDataProvider();
			}
		}
		
		/**
		 * 更新物品列表 
		 * 
		 */		
		public function updateItems():void
		{
			if(!_disposed)
			{
				_packItemPanel.dataProvider = getDataProvider();
			}
		}
		
		/**
		 * 设置铜钱数量
		 * */
		public function setCoinAmount(value:int):void
		{
			if(_bottomPart)
			{
				_bottomPart.setCoinAmount(value);
			}
		}
		
		/**
		 * 设置绑定铜钱数量
		 * */
		public function setCoinBindAmount(value:int):void
		{
			if(_bottomPart)
			{
				_bottomPart.setCoinBindAmount(value);
			}
		}
		
		/**
		 * 设置元宝数量
		 * */
		public function setGoldAmount(value:int):void
		{
			if(_bottomPart)
			{
				_bottomPart.setGoldAmount(value);
			}
		}
		
		/**
		 * 设置绑定元宝数量
		 * */
		public function setGoldBindAmount(value:int):void
		{
			if(_bottomPart)
			{
				_bottomPart.setGoldBindAmount(value);
			}
		}
		
		/**
		 * 设置背包容量
		 * */
		public function updateCapacity():void
		{
			if(_bottomPart)
			{
				_bottomPart.setCapacity();
			}
		
		}
		
		/**
		 * 更新所有金钱
		 */		
		public function updateMoney():void
		{
			var smoney:SMoney=Cache.instance.role.money;
			setCoinAmount(smoney.coin);
			setCoinBindAmount(smoney.coinBind);
			setGoldAmount(smoney.gold);
			setGoldBindAmount(smoney.goldBind);
		}
		
		public function updataPackItemPanelSelectItem(index:int):void
		{
			if(_packItemPanel)
			{
				_packItemPanel.selectedIndex=index;
			}
		}
		
		/**
		 * 获取选择页数
		 * */
		public function get pageTabBarSelect():int
		{
			return _pageTabBar?_pageTabBar.selectedIndex:0;
		}
		
//		public function showUnLockItem(showIndex:int):void
//		{
//			var backPackCache:BackPackCache = Cache.instance.pack.backPackCache;
//			var amount:int = backPackCache.maxCanOpenGrid() - backPackCache.currentGrid + 1;  //显示数量
//			var starX:int = backPackCache.maxCanOpenGrid() == backPackCache.totalGride? 14.5 + (backPackCache.currentGrid%7 - 1)*43:14.5 + (7 - amount)*43;
//			var starY:int = 22 + Math.ceil((backPackCache.maxCanOpenGrid() - _pageTabBar.selectedIndex*49)/7) * 43;
//			var gatX:int = 1;  
//			var icon:ScaleBitmap;
//			var len:int;
//			
//			showIndex == 0? len = amount:len = showIndex;
//			
//			for(var i:int ; i < len ; i++)
//			{
//				icon = UIFactory.bg(0,0,45,45,this,ImagesConst.selectedBg);
//				icon.x = (42 + gatX)*i + starX;
//				icon.y = starY;
//				_showIconList.push(icon);
//			}
//			
//		}
		
		/**
		 * 可解锁格子点亮(新的格子显示规则 )
		 * @param data
		 * 
		 */		
		public function showUnLockItem(data:Object):void
		{
			var backPackCache:BackPackCache = Cache.instance.pack.backPackCache;
			var maxIndex:int = _packItemPanel.dataProvider.getItemIndex(data) + 1;
			var amount:int = maxIndex + _pageTabBar.selectedIndex*49 - (backPackCache.currentGrid - 1);
			var starX:int = backPackCache.currentGrid%7 == 0? 273:(backPackCache.currentGrid%7 - 1)*43 + 15;
			var starY:int = 21 + Math.ceil((backPackCache.maxCanOpenGrid() - _pageTabBar.selectedIndex*49)/7) * 43;
			var gatX:int = 1;  
			var icon:ScaleBitmap;
			var len:int = amount;
			
			for(var i:int ; i < len ; i++)
			{
				icon = UIFactory.bg(0,0,44,44,this,ImagesConst.selectedBg);
				icon.x = (42 + gatX)*i + starX;
				icon.y = starY;
				_showIconList.push(icon);
			}
			Dispatcher.dispatchEvent(new DataEvent(EventName.PackSelectIndex,maxIndex + _pageTabBar.selectedIndex*49));
		}
		
		public function hideUnLockItem():void
		{
			for each(var i:ScaleBitmap in _showIconList)
			{
				i.dispose(true);
				i = null;
			}
			_showIconList.length = 0;
			
		}
		
	}
}