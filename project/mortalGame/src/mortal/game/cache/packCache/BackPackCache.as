package mortal.game.cache.packCache
{
	import Message.DB.Tables.TOpenBagGrid;
	import Message.Public.EBind;
	import Message.Public.EGroup;
	import Message.Public.EProp;
	import Message.Public.EStuff;
	import Message.Public.SPlayerItem;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.ConfigCenter;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.configBase.ConfigConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.pack.data.PackItemData;

	public class BackPackCache extends PackPosTypeCache
	{
		//物品数据
		/**道具**/
		protected var _propItems:Array = new Array();    
		/**材料**/
		protected var _stuffsItems:Array = new Array();    
		/**任务**/
		protected var _taskItems:Array = new Array();    
		/**装备**/
		protected var _equipItems:Array=new Array();   
		
		//其他数据
		/**获取目前累计的总开锁时间**/
		private var _unLockTime:int;
		
		/**当前正在倒计时的格子**/
		private var _currentGrid:int;
		
		/**当前正在倒计时的时间**/
		private var _CountdownTime:int;
		
		/**当前已经倒计时完成的格子**/
		private var _canOpenGridNum:int;
		
		/**开格子时间配置数据**/
		private var _gridVec:Vector.<TOpenBagGrid>;
		
		/**总的格子数**/
		private var _totalGride:int = 0;
		
		/**当前选择的花钱打开的格子位置**/
		public var maxSelsecIndex:int;
		
		public function BackPackCache(posType:int)
		{
			super(posType);
			getTimeConfig();
		}
		
		/**
		 * 获取开启格子的配置数据 
		 * 
		 */		
		private function getTimeConfig():void
		{
			var data:Dictionary = ConfigCenter.getConfigBase(ConfigConst.bagGrid).data;
			_gridVec = new Vector.<TOpenBagGrid>();
			for each(var i:TOpenBagGrid in data)
			{
				i.needTime = i.needTime * 60;
				_gridVec.push(i);
			}
			_gridVec.sort(sortGrid);
		}
		
		private function sortGrid(a1:TOpenBagGrid,a2:TOpenBagGrid):int
		{
			if(a1.needTime > a2.needTime)
			{
				return 1;
			}
			else
			{
				return -1;
			}
		}
		
		/**
		 * 获取当前正在倒计时的格子 
		 * @param time
		 * @return 
		 * 
		 */		
		public function getCurrentGrid(time:int):int
		{
			var len:int = _gridVec.length;
			for(var i:int ; i < len ; i++)
			{
				if(time < _gridVec[i].needTime)
				{
					_currentGrid = i + 36;
					if(i > 0)
					{
						_CountdownTime = time - _gridVec[i - 1].needTime;
					}
					else
					{
						_CountdownTime = time;
					}
					
					break;
				}
			}
			return _currentGrid;
		}
		
		/**
		 * 已经倒计时的时间 
		 * @return 
		 * 
		 */		
		public function get countdownTime():int
		{
			getCurrentGrid(unLockTime);
			return this._CountdownTime;
		}
		
		public function get gridVec():Vector.<TOpenBagGrid>
		{
			return _gridVec;
		}
		
		/**
		 * 当前已经倒数完,但没开启的格子数 
		 * @return 
		 * 
		 */		
		public function get canOpenGridNum():int
		{
			return this._canOpenGridNum = this.currentGrid - this.capacity - 1;
		}
		
		/**
		 * 获取目前累计的开锁时间(在线时间 + 用元宝开锁节省的时间) 
		 * 
		 */		
		public function get unLockTime():int
		{
			return _unLockTime;
		}
		
		/**
		 * 当前正在倒计时的格子 
		 * @return 
		 * 
		 */		
		public function get currentGrid():int
		{
			getCurrentGrid(unLockTime);
			return _currentGrid;
		}
		
		/**
		 * 背包重新排序 
		 * 
		 */		
		override public function sortItems():void
		{
			_allItems.sort(itemSort);
			_stuffsItems.sort(itemSort);
			_taskItems.sort(itemSort);
			_equipItems.sort(itemSort);
			_propItems.sort(itemSort);
		}
		
		/**
		 * 当前可允许开启最大的格子数 
		 * @return 
		 * 
		 */		
		public function maxCanOpenGrid():int
		{
			var index:int = int((_currentGrid - 1)/7)*7 + 7;
			if(index > totalGride)
			{
				index = totalGride;
			}
			return index;
		}
		
//		/**
//		 * 计算开启多个格子所需要的元宝
//		 * @return 
//		 * 
//		 */		
//		public function openGridMoney():int
//		{
//			var index:int = maxCanOpenGrid() - 36;
//			if(index >= 75)
//			{
//				index = 74;
//			}
//			var money:int = Math.ceil((_gridVec[index].needTime - _gridVec[_currentGrid - 36].needTime)/60);
//			return money;
//		}
		
		/**
		 * 计算开启多个格子所需要的元宝(新的规则)
		 * @return 
		 * 
		 */		
		public function openGridMoney():int
		{
			var index:int = maxSelsecIndex - 36;
			if(index >= 75)
			{
				index = 74;
			}
			var money:int = Math.ceil((_gridVec[index].needTime - _gridVec[_currentGrid - 36].needTime)/60);
			return money;
		}
		
		/**
		 * 获取目前累计的总开锁时间
		 * @param time
		 * 
		 */		
		public function set unLockTime(time:int):void
		{
			_unLockTime = time;
		}
		
		override protected function resetAllItems():void
		{
			_itemLength = 0;
			var len:int=sbag.playerItems.length;
			var splayerItem:SPlayerItem;
			_taskItems=new Array();
			for (var i:int=0; i < len; i++)
			{
				splayerItem=sbag.playerItems[i] as SPlayerItem;
				var itemData:ItemData = new ItemData(splayerItem);
				if (itemData.itemInfo.group == EGroup._EGroupTask)   //任务道具不放入全部道具里面
				{
					_taskItems.push(itemData);
				}
				else
				{
					_itemLength += 1;
					_dictIndexSplayerItem[_itemLength] = splayerItem;
				}
			}
			
			_allItems = new Array();
			for (var j:int=0; j < sbag.capacity; j++)
			{
				_allItems[j] = getItemDataBySPlayerItem(_dictIndexSplayerItem[j + 1] as SPlayerItem);
			}
		}
		
		
		override protected function resetTypeItems():void
		{
			this._propItems = []   //道具
			this._stuffsItems = []    //材料
			this._taskItems = []    //任务
			this._equipItems = []    //装备
			
			var len:int = _allItems.length;
			
			var itemData:ItemData;
			for (var i:int=0; i < len; i++)
			{
				itemData=_allItems[i] is ItemData ? _allItems[i] : null;
				if (itemData)
				{
					switch (itemData.itemInfo.group)
					{
						case EGroup._EGroupProp:
							_propItems.push(itemData);
							if(itemData.itemInfo.category == EProp._EPropEquip)
							{
								_equipItems.push(itemData);
							}
							break;
						case EGroup._EGroupStuff:
							_stuffsItems.push(itemData);
							break;
						case EGroup._EGroupTask:
							_taskItems.push(itemData);
							break;
					}
				}
			}
		}
		
		/**
		 * 获取 非冷却 药品数量 根据大类小类 和 效果区分
		 * @param itemData
		 * @return
		 *
		 */
		public function getDrugsCountByType(itemData:ItemData):int
		{
			var num:int=0;
			for each (var item:ItemData in _allItems)
			{
				if (item && isSameItem(item,itemData) && itemData.itemInfo.effect == item.itemInfo.effect)
				{
					num += item.serverData.itemAmount;
				}
			}
			return num;
		}
		
		/**
		 * 将一个物体移出背包
		 */
		override public function moveBagOut(uid:String):Boolean
		{
			if (!uid)
			{
				return false;
			}
			var index:int = getIndexByUid(uid);
			if (index != -1)
			{
				//				this._allItems.splice(index - 1, 1);
				_allItems[index - 1] = null;
				_itemLength--;
				resetTypeItems();
//				if(isTidy)
//				{
//					this.sortItems();
//					isTidy = false;
//				}
				return true;
			}
			else
			{
				return false;
			}
		}
		
		
		/**
		 * 通过大类 小类获取所有数量
		 * @param itemData
		 * @return
		 *
		 */
		public function getItemCountByCategoryAndType(group:int,category:int,type:int,effect:int=-1,color:int=-1,bind:int=-1):int
		{
			var num:int=0;
			for each (var item:ItemData in _allItems)
			{
				if (item && item.itemInfo.group == group && item.itemInfo.category == category && item.itemInfo.type == type 
					&& (effect == -1 || effect == item.itemInfo.effect) 
					&& (color == -1 || color == item.itemInfo.color)
					&& (bind == -1 || bind == item.itemInfo.bind))
				{
					num += item.serverData.itemAmount;
				}
			}
			return num;
		}
		
		/**
		 * 通过大类 小类获取相关物品
		 * @param array
		 * @return
		 *
		 */
		public function getItemsByCategoryAndType(group:int,category:int,type:int,effect:int=-1,color:int=-1,bind:int=-1):Array
		{
			var arr:Array=new Array();
			for each (var item:ItemData in _allItems)
			{
				if (item && item.itemInfo.group == group && item.itemInfo.category == category && item.itemInfo.type == type 
					&& (effect == -1 || effect == item.itemInfo.effect) 
					&& (color == -1 || color == item.itemInfo.color)
					&& (bind == -1 || bind == item.itemInfo.bind))
				{
					arr.push(item);
				}
			}
			return arr;
		}
		
		
		/**
		 * 根据大类小类 获取物品数量
		 * @param category
		 * @param type
		 * @return 
		 * 
		 */		
		public function getTaskItemCountByCategoryAndType(category:int,type:int):int
		{
			var num:int=0;
			for each (var item:ItemData in _taskItems)
			{
				if (item && item.itemInfo.category == category && item.itemInfo.type == type)
				{
					num+=item.itemAmount;
				}
			}
			return num;
		}
		
		/**
		 * 根据itemData获取物品数量 
		 * @param itemData
		 * @return 
		 * 
		 */		
		public function getItemCountByCode(itemData:ItemData,isContainBind:Boolean = true):int
		{
			var num:int=0;
			for each (var item:ItemData in _allItems)
			{
				if (item && (item.itemInfo.code == itemData.itemInfo.code || (isContainBind && item.itemCode == itemData.itemInfo.codeUnbind)))
				{
					num+=item.itemAmount;
				}
			}
			return num;
		}
		
		/**
		 *获取指定itemCode道具的数量 
		 * @param codeArray
		 * @return 
		 * 
		 */		
		public function getItemCountByCodeArray(codeArray:Array):int
		{
			var num:int=0;
			for each (var item:ItemData in _allItems)
			{
				for each (var itemCode:int in codeArray)
				{
					if (item && item.itemInfo.code == itemCode)
					{
						num+=item.itemAmount;
					}
				}
			}
			return num;
		}
		
		/**
		 *将一个任务物品移到任务物品栏
		 * @param posIndex
		 * @param item
		 *
		 */
		public function moveInTaskBag(item:ItemData):Boolean
		{
			for (var i:int=0; i < _taskItems.length; i++)
			{
				var itemData:ItemData=_taskItems[i] as ItemData;
				if (itemData)
				{
					if (itemData.uid == item.uid)
					{
						this._taskItems[i]=item;
						resetTypeItems();
						return true;
					}
				}
			}
			this._taskItems.push(item);
			return true;
		}
		
		/**
		 * 根据uid移除任务背包的物品,并返回布尔值
		 * @param uid
		 * @param splayerItem
		 * @return 
		 * 
		 */		
		public function moveOutTaskBag(uid:String, splayerItem:SPlayerItem=null):Boolean
		{
			if (!uid)
			{
				return false;
			}
			var item:ItemData=this.getTaskItemDataByUid(uid);
			if (item && (!splayerItem || splayerItem && splayerItem.uid == item.uid))
			{
				for (var i:int=0; i < _taskItems.length; i++)
				{
					var itemData:ItemData=_taskItems[i] as ItemData;
					if (itemData.uid == item.uid)
					{
						//this._taskItems[i] = null;
						this._taskItems.splice(i, 1);
						break;
					}
				}
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 根据splayerItem更新任务道具状态
		 * @param sitem
		 * @return 
		 * 
		 */
		public function updateTastSPlayerItem(sitem:SPlayerItem):ItemData
		{
			var item:ItemData = getTaskItemDataByUid(sitem.uid);
			if(item)
			{
				item.data = sitem;
			}
			return item;
		}
		
		/**根据uid获取任务物品**/
		private function getTaskItemDataByUid(uid:String):ItemData
		{
			if (!uid)
			{
				return null;
			}
			for (var i:int=0; i < _taskItems.length; i++)
			{
				var itemData:ItemData=_taskItems[i] as ItemData;
				if (itemData && itemData.serverData)
				{
					if (itemData.uid == uid)
					{
						return _taskItems[i];
					}
				}
			}
			return null;
		}
		

		
		/**
		 *
		 * @return 返回任务物品
		 *
		 */
		public function getTaskItems():Array
		{
			return _taskItems;
		}
		
		
		/**
		 * 根据当前背包的页码和该背包的单页容量获取物品数据(包括空格子和超出容量的格子) 
		 * @param iPage
		 * @param pageSize
		 * @return 
		 * 
		 */		
		override public function getItemsAtPage(iPage:int, pageSize:int=30):Array
		{
			
			var currentPageItems:Array = new Array();
			var start:int = (iPage - 1) * pageSize;   //前面页面的格指数
			var end:int = Math.min(iPage * pageSize, _capacity);
			var currentGrid:int = getCurrentGrid(unLockTime) - 1;   //正在倒计时的格子
			var maxGrid:int = maxCanOpenGrid();
			for (var i:int=0; i < pageSize; i++)
			{
				if (i + start < end)  //容量内的
				{
					currentPageItems[i] = _allItems[i + start];
				}
				else
				{
					if((i + start) < currentGrid)  //已经倒计时完成,但没开启的格子
					{
						currentPageItems[i] = PackItemData.unLockItemData;
					}
					else if((i + start) >= maxGrid)
					{
						currentPageItems[i] = PackItemData.lockingItemData;
					}
					else if((i + start) >  currentGrid)   //锁定但可用元宝开启的格子
					{
						
						currentPageItems[i] = PackItemData.lockItemData;
					}
					else
					{
						currentPageItems[i] = PackItemData.unLockingItemData;
					}
//					currentPageItems[i] = PackItemData.lockItemData;
				}
			}
			return currentPageItems;
		}
		
		/**
		 * 根据当前背包的页码和该背包的单页容量获取材料物品数据
		 * @param iPage
		 * @param pageSize
		 * @return 
		 * 
		 */		
		public function getStuffsItemsAtPage(iPage:int, pageSize:int = 49):Array
		{
			var stuffItems:Array=new Array();
			var start:int = (iPage - 1) * pageSize;
			//	var end:int = Math.min(iPage * pageSize,_capacity);
			var end:int = Math.min(iPage * pageSize, 6 * pageSize);
			
			for (var i:int=0; i < pageSize; i++)
			{
				if (i + start < _stuffsItems.length)
				{
					stuffItems[i] = _stuffsItems[i + start];
				}
				else if (i + start < end)
				{
					stuffItems[i] = null;
				}
				else
				{
					stuffItems[i] = PackItemData.lockItemData;
				}
			}
			return stuffItems; 
		}
		
		/**
		 * 根据当前背包的页码和该背包的单页容量获取材料物品数据
		 * @param iPage
		 * @param pageSize
		 * @return 
		 * 
		 */		
		public function getTaskItemsAtPage(iPage:int, pageSize:int = 49):Array
		{
			var taskItems:Array=new Array();
			var start:int = (iPage - 1) * pageSize;
			//	var end:int = Math.min(iPage * pageSize,_capacity);
			var end:int = Math.min(iPage * pageSize, 6 * pageSize);
			
			for (var i:int=0; i < pageSize; i++)
			{
				if (i + start < _taskItems.length)
				{
					taskItems[i] = _taskItems[i + start];
				}
				else if (i + start < end)
				{
					taskItems[i] = null;
				}
				else
				{
					taskItems[i] = PackItemData.lockItemData;
				}
			}
			return taskItems; 
		}
		
		/**
		 * 根据当前背包的页码和该背包的单页容量获取装备物品数据
		 * @param iPage
		 * @param pageSize
		 * @return 
		 * 
		 */		
		public function getEquipItemsAtPage(iPage:int, pageSize:int = 49):Array
		{
			var equipItems:Array=new Array();
			var start:int = (iPage - 1) * pageSize;
			//	var end:int = Math.min(iPage * pageSize,_capacity);
			var end:int = Math.min(iPage * pageSize, 6 * pageSize);
			
			for (var i:int=0; i < pageSize; i++)
			{
				if (i + start < _equipItems.length)
				{
					equipItems[i] = _equipItems[i + start];
				}
				else if (i + start < end)
				{
					equipItems[i] = null;
				}
				else
				{
					equipItems[i] = PackItemData.lockItemData;
				}
			}
			return equipItems;
		}
		
		/**
		 * 取得装备列表
		 *
		 * */
		public function getEquipItems():Array
		{
			return this._equipItems;
		}
		
		/**
		 * 根据uid获取装备位置
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getIndexInEquip(uid:String):int
		{
			for (var i:int=0; i < _equipItems.length; i++)
			{
				if (_equipItems[i] && (_equipItems[i] as ItemData) && (_equipItems[i] as ItemData).serverData.uid == uid)
				{
					return i + 1;
				}
			}
			return -1;
		}
		
		
		/**
		 * 根据当前背包的页码和该背包的单页容量获取道具物品数据
		 * @param iPage
		 * @param pageSize
		 * @return 
		 * 
		 */		
		public function getPropItemsAtPage(iPage:int, pageSize:int=30):Array
		{
			var propItems:Array = new Array();
			var start:int = (iPage - 1) * pageSize;
			var end:int=Math.min(iPage * pageSize, 6 * pageSize);
			
			for (var i:int = 0; i < pageSize; i++)
			{
				if (i + start < _propItems.length)
				{
					propItems[i] = _propItems[i + start];
				}
				else if (i + start < end)
				{
					propItems[i] = null;
				}
				else
				{
					propItems[i] = PackItemData.lockItemData;
				}
			}
			return propItems;
		}
		
		/**
		 * 取得道具列表
		 *
		 * */
		public function getPropItems():Array
		{
			return this._propItems;
		}
		
		/**
		 * 根据小类型返回道具列表
		 * @param type 参考 EProp.as
		 * @return
		 *
		 */
		public function getPropByType(type:int):Array
		{
			var index:int;
			var length:int=_propItems.length;
			var item:ItemData;
			var result:Array=[];
			while (index < length)
			{
				item=_propItems[index];
				if (item.itemInfo.type == type)
				{
					result.push(item);
				}
				index++;
			}
			return result;
		}
		
		public function getStuffsByTpey(type:int):Array
		{
			var index:int;
			var length:int=_stuffsItems.length;
			var item:ItemData;
			var result:Array=[];
			while (index < length)
			{
				item=_stuffsItems[index];
				if (item.itemInfo.type == type)
				{
					result.push(item);
				}
				index++;
			}
			return result;
		}
		
		/**
		 * 根据uid获取道具位置 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getIndexInProp(uid:String):int
		{
			for (var i:int=0; i < _propItems.length; i++)
			{
				if (_propItems[i] && (_propItems[i] as ItemData) && (_propItems[i] as ItemData).serverData.uid == uid)
				{
					return i + 1;
				}
			}
			return -1;
		}
		
		/**
		 *获取道具 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getPropItemDataByUid(uid:String):ItemData
		{
			var itemData:ItemData;
			for (var i:int=0; i < _propItems.length; i++)
			{
				itemData = _propItems[i];
				if (itemData && itemData.serverData.uid == uid)
				{
					return itemData;
				}
			}
			return null;
		}
		
		/**
		 * 返回某种类型的某种等级的物品
		 * @param category
		 * @param type
		 * @param level
		 * @return
		 *
		 */
		public function getTypeLevelItems(category:int, type:int=int.MAX_VALUE, level:int=0):Array
		{
			var result:Array = [];
			var types:Array=getTypeItems(category, type);
			var index:int;
			var length:int = types.length;
			var item:ItemData;
			while (index < length)
			{
				item = types[index];
				if (item.itemInfo.level == level)
				{
					result.push(item);
				}
				index++;
			}
			return result;
		}
		
		/**
		 * 返回背包中剩余的容量
		 * @return int
		 *
		 */
		public function getSpareCapacity():int
		{
			return _capacity - _itemLength;
		}
		
		/**
		 * 背包是否满了 
		 * @return 
		 * 
		 */		
		public function isPackFull():Boolean
		{
			return _capacity == _itemLength;
		}
		
		/**
		 * 根据ItemData获取同种物品
		 * @param code
		 *
		 */
		public function getSameItemByItemData(inItemData:ItemData):ItemData
		{
			var len:int=_allItems.length;
			for (var i:int=0; i < len; i++)
			{
				var itemData:ItemData=_allItems[i] as ItemData;
				var itemInfo:ItemInfo;
				if (itemData && inItemData)
				{
					itemInfo = itemData.itemInfo;
					if(inItemData.itemInfo.bind == EBind._EBindNo)//非绑定
					{
						if(itemInfo.code == inItemData.serverData.itemCode || itemInfo.codeUnbind == inItemData.serverData.itemCode)
						{
							return itemData;
						}
					}
					else//绑定
					{
						if (itemInfo.code == inItemData.serverData.itemCode || itemInfo.code == inItemData.itemInfo.codeUnbind)
						{
							return itemData;
						}
					}
				}
			}
			return null;
		}
		
		
		/**
		 * 从code里面去获取索引
		 * @param code
		 * @return
		 */
		public function getIndexByCode(code:int):int
		{
			var len:int = _allItems.length;
			for (var i:int=0; i < len; i++)
			{
				var itemData:ItemData = _allItems[i] as ItemData;
				if (itemData)
				{
					if (itemData.serverData.itemCode == code)
					{
						return i + 1;
					}
				}
			}
			return -1;
		}

		
		/**
		 * 开启物品，数目为n
		 * @param n
		 *
		 */
		public function addNullToItem(n:int):void
		{
			for (var i:int = 0; i < n; i++)
			{
				this._allItems.push(null);
			}
			this._capacity += i;
			_sbag.capacity = _capacity + i;
		}
		
		
		/**
		 * 获取同名背包物品的总数量 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getAllAoumtOfSameNameItem(name:String):int
		{
			var allAoumt:int=0;
			for (var i:int=0; i < _allItems.length; i++)
			{
				var itemData:ItemData = _allItems[i] as ItemData;
				if (itemData != null && itemData.itemInfo)
				{
					if (itemData.itemInfo.name == name)
					{
						allAoumt += itemData.serverData.itemAmount;
					}
				}
			}
			return allAoumt;
		}
		
		
		/**
		 * 获取第一个同名物品进行使用
		 * @param name
		 * @return 
		 * 
		 */		
		public function getFirstItemUid(name:String):String
		{
			for (var i:int=0; i < _allItems.length; i++)
			{
				var itemData:ItemData=_allItems[i] as ItemData;
				if (itemData != null)
				{
					if (itemData.itemInfo.name == name)
					{
						return itemData.uid;
					}
				}
			}
			
			return null;
		}
		
		/**
		 *获得背包中最高同类装备（颜色字段区分）
		 * @param category
		 * @param type
		 * @return
		 *
		 */
		public function getHeightLevelSortEquip(category:int, type:int):ItemData
		{
			var len:int=_equipItems.length;
			var heightLevelItem:ItemData;
			for (var i:int=0; i < len; i++)
			{
				var itemData:ItemData=_equipItems[i] as ItemData;
				if (itemData)
				{
					if (itemData.itemInfo.category == category && itemData.itemInfo.type == type)
					{
						if (heightLevelItem)
						{
							if (itemData.itemInfo.color > heightLevelItem.itemInfo.color)
							{
								heightLevelItem=itemData;
							}
						}
						else
						{
							heightLevelItem=itemData;
						}
					}
				}
			}
			return heightLevelItem;
		}
		
		/**
		 * 根据类型、effect返回UID 绑定放前面 非绑定放后面 
		 * isPriorBind == true 绑定放前面 非绑定放后面, false则相反
		 * @return 
		 * 
		 */
		public function getUidListByType(category:int,type:int,effect:int = int.MAX_VALUE, isPriorBind:Boolean = true ):Array
		{
			var items:Array = this.getTypeItems(category,type,effect);
			if( isPriorBind )
			{
				items.sortOn(["bind"],Array.DESCENDING|Array.NUMERIC);//绑定放前面 非绑定放后面
			}
			else
			{
				items.sortOn(["bind"],Array.NUMERIC );//非绑定放前面 绑定放后面
			}
			var result:Array = [];
			var item:ItemData;
			for(var i:int=0;i<items.length;i++)
			{
				item = items[i];
				result.push(item.uid);
			}
			return result;
		}
		
		/**
		 * 根据外部接口、effect返回UID 绑定放前面 非绑定放后面  
		 * @param judge
		 * @param effect
		 * @return 
		 * 
		 */		
		public function getUidByJudgeAndEffect( judge:Function, effect:int = int.MAX_VALUE ):Array
		{
			var items:Array = this.getItemsByJudge( judge, true );
			var result:Array = [];
			var item:ItemData;
			for(var i:int=0;i<items.length;i++)
			{
				item = items[i];
				if( item.itemInfo.effect == effect )
				{
					result.push(item.uid);
				}
			}
			return result;
		}
		
		/**
		 * 获取装备某小类下的所有数据
		 * type:装备的小类
		 */
		public function getEquipItemDatasByType(type:int):Array
		{
			var itemsArr:Array = [];
			var itemData:ItemData;
			for(var i:int=0; i<_equipItems.length; i++)
			{
				itemData = _equipItems[i];
				if(itemData.itemInfo.type==type)
				{
					itemsArr.push(itemData);
				}
			}
			return itemsArr;
		}
		
		/**
		 * 根据物品的code返回背包内含有相同code的itemData数组 
		 * @param code
		 * 
		 */		
		public function getItemsByCode(code:int):Array
		{
			var len:int = _allItems.length;
			var info:ItemInfo = ItemConfig.instance.getConfig(code);
			var code2:int = info.codeUnbind;
			var itemArr:Array = [];
			var item:ItemData;
			for(var i:int ; i < len ; i++)
			{
				if(_allItems[i])
				{
					item = _allItems[i];
					if(item.itemInfo.code == code || item.itemInfo.code == code2 )
					{
						itemArr.push(_allItems[i]);
					}
				}
			}
			
			return itemArr;
		}
		
		public function getItemsCanSaleByCode(code:int):Array
		{
			var arr:Array = [];
			var item:ItemData;
			for (var i:int = 0; i < _allItems.length; i++) 
			{
				item = _allItems[i] as ItemData;
				if(item && item.itemInfo.code == code && item.itemInfo.bind != 1)
				{
					arr.push(item);
				}
			}
			return arr;
		}
		
		/**
		 * 总格子数 
		 * @return 
		 * 
		 */		
		public function get totalGride():int
		{
			if(_totalGride == 0)
			{
				var num:int;
			    var dic:Dictionary = ConfigCenter.getConfigBase(ConfigConst.bagGrid).data;
				for each(var i:Object in dic)
				{
					if(i.grid > num)
					{
						num = i.grid;
					}
				}
				_totalGride = num;
			}
			return _totalGride;
		}
		
		/**
		 *根据uid获取装备 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getEquipByUid(uid:String):ItemData
		{
			var len:int = _equipItems.length;
			for(var i:int ; i < len ; i++)
			{
				if(_equipItems[i] && (_equipItems[i] as ItemData).serverData.uid == uid)
				{
					return _equipItems[i];
				}
			}
			return null
			
		}
		
		/**
		 * 获取背包中所有物品,不包括空格子
		 * @return 
		 * 
		 */		
		public function getAllItems():Array
		{
			var arr:Array = new Array();
			var len:int = _allItems.length;
			for(var i:int; i < len ; i++)
			{
				if(_allItems[i])
				{
					arr.push(_allItems[i]);
				}
			}
			return arr;
		}
		
		/**
		 * 获取背包中所有可以寄售的物品
		 * @return 
		 */		
		public function getAllItemsCanSaleMarket():Array
		{
			var arr:Array = getAllItems();
			var itemData:ItemData;
			for(var i:int = arr.length -1 ; i > -1 ; i--)
			{
				itemData = arr[i];
				if(itemData.itemInfo.market != 1 ||
					(itemData.extInfo && itemData.extInfo.bd == EBind._EBindYes) ||
					(itemData.extInfo == null && itemData.itemInfo.bind == EBind._EBindYes) ||
					ItemsUtil.isOverdueByConfig(itemData.itemInfo))
				{
					arr.splice(i,1);
				}
			}
			return arr;
		}
		
		/**
		 * 获取背包中itemCode相同的所有物品 (uid不同)
		 * @param code
		 * @return 
		 * 
		 */		
		public function getSameCodeItem(code:int):Array
		{
			var arr:Array = new Array();
			var len:int = _allItems.length;
			for(var i:int; i < len ; i++)
			{
				if(_allItems[i] && (_allItems[i] as ItemData).itemCode == code)
				{
					arr.push(_allItems[i]);
				}
			}
			return arr;
		}
		
		/**
		 * 根据宝石类型获得宝石 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getGemByType(type:int = 0):Array
		{
			var arr:Array = new Array();
			if(type != 0)// 获取所有某类型宝石
			{
				for each(var i:ItemData in _stuffsItems)
				{
					if(i.itemInfo.category == EStuff._EStuffJewel && i.itemInfo.type == type)
					{
						arr.push(i);
					}
				}
			}
			else// 获取所有宝石
			{
				for each(i in _stuffsItems)
				{
					if(i.itemInfo.category == EStuff._EStuffJewel)
					{
						arr.push(i);
					}
				}
			}
			return arr;
		}

	}
}