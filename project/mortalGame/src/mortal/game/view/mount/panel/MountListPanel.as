package mortal.game.view.mount.panel
{
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.mount.data.MountData;
	import mortal.mvc.core.Dispatcher;
	
	public class MountListPanel extends GSprite
	{
		private var _totalPage:int ; //坐骑图鉴总页数
		
		private var _mountList:GTileList;
		
//		private var _leftBtn:GLoadedButton;
//		
//		private var _rightBtn:GLoadedButton;
		
//		private var _currentPage:int;
		
		private var _pageSelecter:PageSelecter;
		
		private var _currentMountNum:GTextFiled;;
		
		public var currentMountData:MountData;
		
//		private var isSelectMount:Boolean;//是否含有以选择的坐骑
		
		public function MountListPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			pushUIToDisposeVec(UIFactory.bg(0, 0, 654, 169, this));
			
			_mountList = UIFactory.tileList(12,1,650,150,this);
			_mountList.columnWidth = 130;
			_mountList.rowHeight = 146;
			_mountList.horizontalGap = -5;
			_mountList.verticalGap = -1;
			_mountList.selectable = true;
			_mountList.setStyle("cellRenderer", MountCellRenderer);
			
//			_leftBtn = UIFactory.gLoadedButton(ImagesConst.MountLeft_upSkin,-14,55,33,37,this);
//			_leftBtn.configEventListener(MouseEvent.CLICK,changPage);
//			
//			_rightBtn = UIFactory.gLoadedButton(ImagesConst.MountRight_upSkin,635,55,33,37,this);
//			_rightBtn.drawNow();
//			_rightBtn.configEventListener(MouseEvent.CLICK,changPage);
			
//			_currentPage = 1;
//			_totalPage = Math.ceil(Cache.instance.mount.mountList.length/5);
			
			var fm:GTextFormat = GlobalStyle.textFormatBai;
			fm.align = AlignMode.CENTER;
			_pageSelecter = UIFactory.pageSelecter(266,146,this,PageSelecter.CompleteMode);
			_pageSelecter.currentPage = 1;
			_pageSelecter.setbgStlye(ImagesConst.ComboBg,fm);
			_pageSelecter.pageTextBoxSize = 50;
			_pageSelecter.maxPage = Math.ceil(Cache.instance.mount.mountList.length/5);
			_pageSelecter.configEventListener(Event.CHANGE,onPageChange);
			
			_currentMountNum = UIFactory.gTextField("",540,142,100,20,this,GlobalStyle.textFormatItemGreen);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_mountList.dispose(isReuse);
			_pageSelecter.dispose(isReuse);
			_currentMountNum.dispose(isReuse);
			
			_mountList = null;
			_pageSelecter = null;
			_currentMountNum = null;
			
			if(Cache.instance.mount.newMountData)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.MountClearNewMount,null));
			}
			
			super.disposeImpl(isReuse);
		}
		
//		private function changPage(e:MouseEvent):void
//		{
//			if(e.target == _leftBtn && _currentPage > 1)
//			{
//				_currentPage--;
//			}
//			else if(e.target == _rightBtn && _currentPage < _totalPage)
//			{
//				_currentPage++;
//			}
//			_mountList.selectedIndex = -1;
//			setListInfo();
//		}
		
		/**
		 * 自动打开新坐骑的页面
		 * @return 
		 * 
		 */		
		private function getCurrentPage():int
		{
//			if(Cache.instance.mount.currentMount == null)
//			{
//				return 1;
//			}
			
			var index:int;
			var arr:Vector.<MountData> = Cache.instance.mount.mountList;
			for (var i:int ; i < arr.length ;  i++)
			{
//				if(arr[i].itemMountInfo.code == Cache.instance.mount.currentMount.itemMountInfo.code)  //自动打开选择骑乘的页面
//				{
//					index = i + 1;
//					break;
//				}
				if(Cache.instance.mount.isNewMount( arr[i].itemMountInfo.code))
				{
					index = i + 1;
					return Math.ceil(index/5);
				}
			}
			_totalPage = Math.ceil(arr.length/5);
			return _pageSelecter.currentPage;
		}
		
		/**
		 * 自动选中之前选中的坐骑 
		 * @return 
		 * 
		 */		
		private function getMountsDataProvider():DataProvider
		{
			var showNum:int = 5;
			var dataProvider:DataProvider = new DataProvider();
			var mounts:Vector.<MountData> = Cache.instance.mount.mountList;
			var endIndex:int = showNum * _pageSelecter.currentPage > mounts.length? mounts.length:showNum * _pageSelecter.currentPage;
			_mountList.selectedIndex = -1;//初始化选择状态
			for(var i:int = (_pageSelecter.currentPage - 1)*showNum; i < endIndex ; i++)
			{
				var mountData:MountData = mounts[i];
				var obj:Object = {data:mountData};
				dataProvider.addItem(obj);
				
				if(currentMountData && currentMountData.itemMountInfo.code == mountData.itemMountInfo.code)  //选中上次选中的坐骑
				{
					_mountList.selectedIndex = i - (_pageSelecter.currentPage - 1)*showNum;
				}
				
			}
			return dataProvider;
		}
		
		/**
		 * 能自动选择已经选择骑乘的坐骑 或者第一个或者新的坐骑
		 * @return 
		 * 
		 */		
		private function getMountsDataProvider2():DataProvider
		{
			var showNum:int = 5;
			var dataProvider:DataProvider = new DataProvider();
			var mounts:Vector.<MountData> = Cache.instance.mount.mountList;
			var endIndex:int = showNum * _pageSelecter.currentPage > mounts.length? mounts.length:showNum * _pageSelecter.currentPage;
			
			_mountList.selectedIndex = -1;//初始化选择状态
			
			for(var i:int = (_pageSelecter.currentPage - 1)*showNum; i < endIndex ; i++)
			{
				var mountData:MountData = mounts[i];
				var obj:Object = {data:mountData};
				dataProvider.addItem(obj);
				
				if(_mountList.selectedIndex < 0) 
				{
					if(Cache.instance.mount.isNewMount( mountData.itemMountInfo.code)) //查看是否有新的坐骑,有的话选中,没有的话默认选择第一个
					{
						_mountList.selectedIndex = i - (_pageSelecter.currentPage - 1)*showNum;
					}
				}
				
//				else
//				{
//					_mountList.selectedIndex = 0;
//				}
//				else if(Cache.instance.mount.currentMount == null && mountData.isOwnMount)  //没幻化的坐骑,默认选择第一个
//				{
//					_mountList.selectedIndex = 0;
//				}
//				else if(Cache.instance.mount.isCurrentMount( mountData.itemMountInfo.code))  //有的话则选择幻化坐骑的那个
//				{
//					_mountList.selectedIndex = i - (_pageSelecter.currentPage - 1)*showNum;
//				}
				
			}
			
			if((dataProvider.getItemAt(0).data as MountData).isOwnMount &&　_mountList.selectedIndex < 0) //如果有坐骑而且没有新增加的坐骑,则默认选择第一个
			{
				_mountList.selectedIndex = 0;
			}
			
			return dataProvider;
		}
		
		public function onPageChange(e:Event = null):void
		{
			_mountList.dataProvider = getMountsDataProvider();
			
//			if(_mountList.selectedItem)
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.MountSelseced,_mountList.selectedItem.data));
//			}
		}
		
		/**
		 * 能够自动选中坐骑 
		 * 
		 */		
		private function autoSelectMount():void   
		{
			_mountList.dataProvider = getMountsDataProvider2();
			
			if(_mountList.selectedItem)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.MountSelseced,_mountList.selectedItem.data));
			}
		}
		
		
		/**
		 * 重新载入整个列表面板数据 
		 * 
		 */		
		public function setListInfo():void
		{
			setCurrentPage();
			autoSelectMount();
			_currentMountNum.htmlText = Language.getStringByParam(30309,Cache.instance.mount.mountNum);
		}
		
		/**
		 * 控制当前选择的坐骑  
		 * @param type 左为-1,右为1
		 * 
		 */		
		public function setSelectIndex(type:int):void
		{
			var index:int;
			var arr:Vector.<MountData> = Cache.instance.mount.mountList;
			var mountData:MountData;
			for (var i:int ; i < arr.length ;  i++)
			{
				if(currentMountData ==  arr[i])
				{
					index = i + type;
					if(index >= 0 && index < arr.length)
					{
						mountData = arr[i + type];
						if(mountData.isOwnMount)
						{
							currentMountData = mountData;
							setSelectPage();
							onPageChange();
							break;
						}
						else
						{
							return;
						}
					}
					else
					{
						return;
					}
					
				}
			}
			
			if(_mountList.selectedItem)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.MountSelseced,_mountList.selectedItem.data));
			}
			
		}
		
//		/**
//		 * 控制当前选择的坐骑 
//		 * @param type  1为向左,2为向右
//		 * 
//		 */		
//		public function setSelectIndex(type:int):void
//		{
//			if(type == 1)  //向左选择
//			{
//				if(_mountList.selectedIndex == -1)  //如果该页没有选中的东西则自动找到本来选中的那页
//				{
//					setSelectPage();
//					onPageChange();
//					setSelectIndex(1);
//				}
//				else if(_pageSelecter.currentPage == 1)  //是否第一页
//				{
//					if(_mountList.selectedIndex == 0 )  //是否第一个
//					{
//						return;
//					}
//					else
//					{
//						_mountList.selectedIndex -= 1; 
//					}
//				}
//				else  //不是第一页则换页且选中最后一个
//				{
//					if(_mountList.selectedIndex == 0)
//					{
//						_pageSelecter.currentPage --;
//						_mountList.dataProvider = getMountsDataProvider();
//						_mountList.selectedIndex = 4; 
//					}
//					else
//					{
//						_mountList.selectedIndex -= 1;
//					}
//					
//					
//				}
//				
//			}
//			else if(type == 2) //向右选择
//			{
//				var endIndex:int = _mountList.dataProvider.length - 1;
//				
//				if(_mountList.selectedIndex == -1)  //如果该页没有选中的东西则自动找到本来选中的那页
//				{
//					setSelectPage();
//					onPageChange();
//					setSelectIndex(2);
//				}
//				else if(_pageSelecter.currentPage == _totalPage)  //是否最后一页
//				{
//					if(_mountList.selectedIndex == endIndex )  //是否最后一个
//					{
//						return;
//					}
//					else if(_mountList.dataProvider.getItemAt(_mountList.selectedIndex + 1) && (_mountList.dataProvider.getItemAt(_mountList.selectedIndex + 1).data as MountData).isOwnMount)
//					{
//						_mountList.selectedIndex += 1;  
//					}
//					else
//					{
////						_mountList.selectedIndex = -1; 
//					}
//					
//				}
//				else  //不是最后一页页则换页且选中第一个一个
//				{
//					if(_mountList.selectedIndex == endIndex )  //是否最后一个
//					{
//						_pageSelecter.currentPage ++;
//						_mountList.dataProvider = getMountsDataProvider();
//						
//						if(_mountList.dataProvider.getItemAt(0) && (_mountList.dataProvider.getItemAt(0).data as MountData).isOwnMount)
//						{
//							_mountList.selectedIndex = 0; 
//						}
//						else
//						{
//							_mountList.selectedIndex = -1; 
//						}
//					}
//					else
//					{
//						if(_mountList.dataProvider.getItemAt(_mountList.selectedIndex + 1) && (_mountList.dataProvider.getItemAt(_mountList.selectedIndex + 1).data as MountData).isOwnMount)
//						{
//							_mountList.selectedIndex += 1;  
//						}
//						else
//						{
////							_mountList.selectedIndex = -1; 
//						}
//					}
//				}
//			}
//			
//			
//			if(_mountList.selectedItem && (_mountList.selectedItem.data as MountData).isOwnMount)
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.MountSelseced,_mountList.selectedItem.data));
//			}
//		}
		
		/**
		 * 储存上次选择的坐骑 
		 * @param data
		 * 
		 */		
		public function setMountInfo(data:MountData):void
		{
			currentMountData = data;
		}
		
		/**
		 * 自动切换到新增加坐骑的页面 
		 * 
		 */		
		public function setCurrentPage():void
		{
			_pageSelecter.currentPage = getCurrentPage();
		}
		
		/**
		 * 切换到上次选中的坐骑的页面 
		 * 
		 */		
		private function setSelectPage():void
		{
			_pageSelecter.currentPage = getSelectPage();
		}
		
		private function getSelectPage():int
		{
			var index:int;
			var arr:Vector.<MountData> = Cache.instance.mount.mountList;
			for (var i:int ; i < arr.length ;  i++)
			{
				if(currentMountData ==  arr[i])
				{
					index = i + 1;
					return Math.ceil(index/5);
				}
			}
			_totalPage = Math.ceil(arr.length/5);
			return _pageSelecter.currentPage;
		}
		
	}
}