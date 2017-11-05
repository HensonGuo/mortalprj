package mortal.game.cache.packCache
{
	import Message.DB.Tables.TItem;
	import Message.Game.SBag;
	import Message.Public.EBind;
	import Message.Public.SPlayerItem;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.pack.DragDropData;
	import mortal.game.view.pack.data.PackItemData;

	/**
	 * 背包基类,其他类型的背包继承此类
	 * @author Administrator
	 * 
	 */	
	public class PackPosTypeCache
	{

		/**
		 * 背包数据
		 *
		 * */
		protected var _sbag:SBag;
		protected var _posType:int;
		protected var _capacity:int;
		

		/**储存物品的位置,key为位置,键值为物品,值为null代表没物品**/
		protected var _dictIndexSplayerItem:Dictionary;
		
		/**储存物品的位置,长度为容量大小,值为物品,值为null代表没物品**/
		protected var _allItems:Array = new Array();   //所有物品(包括空的)

		/** 物品总数量**/
		protected var _itemLength:int;

		
		public function PackPosTypeCache(posType:int)
		{
			_posType=posType;
			_dictIndexSplayerItem = new Dictionary();
		}
		
		public function set sbag(value:SBag):void
		{
			_sbag=value;
			reSetBag();
			sortItems();
		}

		public function get sbag():SBag
		{
			return _sbag;
		}

		
		
		private function reSetBag():void
		{
			_capacity=_sbag.capacity;
			resetItems();
		}

		private function resetItems():void
		{
			resetAllItems();
			resetTypeItems();
		}

		/**set SBag后重新写入物品数据 **/
		protected function resetAllItems():void
		{
			_itemLength = 0;
			var len:int=sbag.playerItems.length;
			var splayerItem:SPlayerItem;
			var itemData:ItemData;
			for (var i:int=0; i < len; i++)
			{
				splayerItem=sbag.playerItems[i] as SPlayerItem;
				itemData = new ItemData(splayerItem);
				_itemLength += 1;
				_dictIndexSplayerItem[_itemLength] = splayerItem;
			}
			
			_allItems=new Array();
			for (var j:int=0; j < sbag.capacity; j++)
			{
				_allItems[j] = getItemDataBySPlayerItem(_dictIndexSplayerItem[j + 1] as SPlayerItem);
			}
		}
		
		/**排序算法 **/
		protected function itemSort(a1:ItemData,a2:ItemData):int     
		{
//			var i:int = int(Math.random()*3)-1;
//			return i;
			if(a2 == null)
			{
				return -1;
			}
			
			if(a1 == null)
			{
				return 1;
			}
			else if(ItemsUtil.isBind(a1))
			{
				if(ItemsUtil.isBind(a2))
				{
					if(a1.serverData.itemCode > a2.serverData.itemCode)
					{
						return -1;
					}
					else
					{
						return 1;
					}
				}
				else
				{
					return -1;
				}
			}
			else if(ItemsUtil.isBind(a2))
			{
				return 1;
			}
			else if(a1.serverData.itemCode > a2.serverData.itemCode)
			{
				return -1;
			}
			else
			{
				return 1;
			}
			
		}
		
		/**将该背包所有物品重新分类(提供复写)**/
		protected function resetTypeItems():void
		{

		}
		
		/**判断两种物品是否同类**/
		protected function isSameItem(item1:ItemData,item2:ItemData):Boolean
		{
			return item1.itemInfo.category == item2.itemInfo.category && item1.itemInfo.type == item2.itemInfo.type;
		}
		
		protected function getItemDataBySPlayerItem(splayerItem:SPlayerItem):ItemData
		{
			if (splayerItem)
			{
				return new ItemData(splayerItem);
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 背包重新排序 
		 * 
		 */		
		public function sortItems():void
		{
//			_allItems.sort(itemSort);
		}

		/**
		 * 当前物品数量 
		 * @return 
		 * 
		 */		
		public function get itemLength():int
		{
			return this._itemLength;
		}

		/**
		 * 获取某个位置的itemData
		 */
		public function getItemDataByIndex(index:int):ItemData
		{
			if (index < 1 || index > _allItems.length)
			{
				return null;
			}
			return _allItems[index - 1] as ItemData;
		}
		
		/**
		 * 通过大类 小类获取所有数量
		 * @param itemData
		 * @return
		 *
		 */
		public function getItemCountByJudge(judge:Function):int
		{
			var num:int=0;
			for each (var item:ItemData in _allItems)
			{
				if(item)
				{
					if (judge.call(null,item))
					{
						num+=item.itemAmount;
					}
				}
			}
			return num;
		}
		
		/**
		 *将一个物体移入背包(放到第一个空格子里面)
		 */
		public function moveBagIn(item:ItemData):Boolean
		{
			if (!item)
			{
				return false;
			}
			var len:int = _allItems.length;
			var itemData:ItemData
			for(var i:int ; i < len ; i++)
			{
				itemData = _allItems[i];
				if (itemData && itemData.serverData.uid == item.serverData.uid)   //可能出现同种物品分占多个格子,所以除了物品相同,物品的uid也要相同
				{
					_allItems[i] = item;
					resetTypeItems();
					return true;
				}
			}
			
			for(var n:int ; n < len ; n++)
			{
				itemData = _allItems[n];
				if(!itemData)
				{
					_allItems[n] = item;
					break;
				}
			}
			_itemLength++;
			//修改其他数组
			resetTypeItems();
			return true;
		}
		

		/**
		 * 替换掉某个位置的物品 (可以用空物品替换)
		 * @param posIndex
		 * @param item
		 * @return 
		 * 
		 */		
		public function changeBag(posIndex:int, item:SPlayerItem):Boolean
		{
			if (posIndex < 1 || posIndex > _allItems.length)
			{
				return false;
			}
			var itemData:ItemData = getItemDataByIndex(posIndex);
			//if(!Equel(item,itemData))
			{
				if (!itemData && item)
				{
					this._itemLength+=1;
				}
				if (itemData && !item)
				{
					this._itemLength-=1;
				}
				if (item)
				{
					item.posType=this._posType;
				}
				itemData = new ItemData(item);
				this._allItems[posIndex - 1] = itemData;
				resetTypeItems();
				return true;
			}
			return false;
		}
		
		/**
		 * 包内移动物品 
		 * @param posInfo  
		 * 
		 */		
		public function changeItemPos(posInfo:DragDropData):Boolean
		{
			if (posInfo.toIndex < 1 || posInfo.toIndex > _capacity)   //超出容量范围
			{
				return false;
			}
			var itemData:ItemData = getItemDataByIndex(posInfo.toIndex);
			var item:ItemData = getItemDataByIndex(posInfo.fromIndex)
			_allItems[posInfo.toIndex - 1] = item;
			_allItems[posInfo.fromIndex - 1] = itemData;
			return true
		}


		/**
		 * 将一个物体移出背包
		 */
		public function moveBagOut(uid:String):Boolean
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
				return true;
			}
			else
			{
				return false;
			}
		}

		/**
		 * 根据当前背包的页码和该背包的单页容量获取物品数据(包括空格子和超出容量的格子) 
		 * @param iPage
		 * @param pageSize
		 * @return 
		 * 
		 */		
		public function getItemsAtPage(iPage:int, pageSize:int=30):Array
		{

			var currentPageItems:Array = new Array();
			var start:int = (iPage - 1) * pageSize;
			var end:int = Math.min(iPage * pageSize, _capacity);
			for (var i:int=0; i < pageSize; i++)
			{
				if (i + start < end)
				{
					currentPageItems[i] = _allItems[i + start];
				}
				else
				{
//					if((i + start) <  ParamsConst.instance.totalOnlineTime)
//					{
//						currentPageItems[i] = PackItemData.unLockItemData;
//					}
//					else if((i + start) >  ParamsConst.instance.totalOnlineTime)
//					{
//						currentPageItems[i] = PackItemData.unLockingItemData;
//					}
//					else
//					{
//						currentPageItems[i] = PackItemData.lockItemData;
//					}
					currentPageItems[i] = PackItemData.lockItemData;
				}
			}
			return currentPageItems;
		}

		
		/**
		 * 
		 * @return 该背包所有物品(包括空格子)
		 * 
		 */
		public function get allItems():Array
		{
			return this._allItems;
		}
		
		
		/**
		 * 获取某一类型的所有物品列表 type = int.MAX_VALUE为所有小类  effect是指物品的使用效果 effect = int.MAX_VALUE是所有效果。
		 * @param category
		 * @param type
		 * @param effect
		 * @return
		 *
		 */
		public function getTypeItems(category:int, type:int=int.MAX_VALUE ,effect:int = int.MAX_VALUE):Array
		{
			var aryTypeItems:Array=new Array();
			var len:int=_allItems.length;
			var itemData:ItemData, itemInfo:ItemInfo;
			for (var i:int=0; i < len; i++)
			{
				itemData=_allItems[i] is ItemData ? _allItems[i] : null;
				if (itemData && !(itemData is PackItemData))
				{
					itemInfo = ItemConfig.instance.getConfig(itemData.itemCode);
					if (itemInfo.category == category)
					{
						if ((type == int.MAX_VALUE || itemInfo.type == type) && (effect == int.MAX_VALUE || itemInfo.effect == effect))
						{
							aryTypeItems.push(itemData);
						}
					}
				}
			}
			return aryTypeItems;
			return null;
		}
		
		/**
		 * 外部提供一个判断的函数。获取所有返回成功的列表 
		 * @param judge
		 * 
		 */		
		public function getItemsByJudge(judge:Function = null,isBindFirst:Boolean = false):Array
		{
			var aryTypeItems:Array=new Array();
			var len:int=_allItems.length;
			var itemData:ItemData;
			for (var i:int=0; i < len; i++)
			{
				itemData=_allItems[i] is ItemData ? _allItems[i] : null;
				if (itemData && itemData != PackItemData.lockItemData)
				{
					if(judge == null || judge.call(null,itemData) == true)
					{
						aryTypeItems.push(itemData);
					}
				}
			}
			if(isBindFirst)
			{
				aryTypeItems.sort(sortBindFirst);
			}
			return aryTypeItems;
		}
		
		/**设置绑定优先顺序**/
		private function sortBindFirst(itemData1:ItemData,itemData2:ItemData):int
		{
//			var isFirstBind:Boolean = ItemsUtil.isBind(itemData1);
//			var isSecondBind:Boolean = ItemsUtil.isBind(itemData2);
//			if(isFirstBind && !isSecondBind)
//			{
//				return -1;
//			}
//			else if(!isFirstBind && isSecondBind)
//			{
//				return 1;
//			}
			return 0;
		}
		
		
		/**
		 * 根据uid获取物品在背包中的位置 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getIndexByUid(uid:String):int
		{
			for (var i:int=0; i < _allItems.length; i++)
			{
				if (_allItems[i] && (_allItems[i] as ItemData) && (_allItems[i] as ItemData).serverData.uid == uid)
				{
					return i + 1;
				}
			}
			return -1;
		}

		/**
		 * 根据uid获取物品 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getItemDataByUid(uid:String):ItemData
		{
			if (!uid)
			{
				return null;
			}
			var itemData:ItemData;
			for (var i:int=0; i < _allItems.length; i++)
			{
				itemData=_allItems[i] as ItemData;
				if (itemData && itemData.serverData.uid == uid)
				{
					return _allItems[i];
				}
			}
			return null;
		}


		/**
		 * 设置背包容量 
		 * @param value
		 * 
		 */		
		public function set capacity(value:int):void
		{
			this._capacity=value;
			if(_allItems.length != 0 && _allItems.length < _capacity)
			{
				var len:int = _allItems.length;
				for(var i:int ; i < ( _capacity - len) ; i++)
				{
					_allItems.push(null);
				}
			}
		}

		public function get capacity():int
		{
			return this._capacity;
		}


		/**
		 * 从Code中去获取itemData
		 * @param _code
		 *
		 */
		public function getItemByCode(code:int):ItemData
		{
			var len:int=_allItems.length;
			for (var i:int=0; i < len; i++)
			{
				var itemData:ItemData=_allItems[i] as ItemData;
				if (itemData)
				{
					if (itemData.itemInfo.code == code)
					{
						return itemData;
					}
				}
			}
			return null;
		}
		

		/**
		 * 通过uid移除物品 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function removeItemByUid(uid:String):Boolean
		{
			var index:int = this.getIndexByUid(uid);
			if (index < 1 || index > _allItems.length)
			{
				return false;
			}
			_allItems[index - 1] = null;
			this._itemLength-=1;
			resetTypeItems();
			return true;
		}
		
		/**
		 * 根据splayerItem更新物品状态
		 * @param sitem
		 * @return 
		 * 
		 */
		public function updateSPlayerItem(sitem:SPlayerItem):ItemData
		{
			var item:ItemData = getItemDataByUid(sitem.uid);
			if(item)
			{
				item.data = sitem;
			}
			return item;
		}
		
		/**
		 * 获取背包里面的 物品Code列表
		 * @return 
		 * 
		 */
		public function get itemCodes():Array
		{
			var aryItemCodes:Array = new Array();
			for each (var item:ItemData in _allItems)
			{
				if(item && item.itemCode != 0)
				{
					aryItemCodes.push(item.itemCode);
				}
			}
			return aryItemCodes;
		}
	}
}
