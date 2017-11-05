package mortal.game.view.mount
{
	import Message.Public.EMountState;
	import Message.Public.EUpdateType;
	import Message.Public.SPublicMount;
	
	import flash.utils.Dictionary;
	
	import mortal.common.net.CallLater;
	import mortal.game.cache.Cache;
	import mortal.game.resource.tableConfig.MountConfig;
	import mortal.game.view.mount.data.MountData;

	public class MountCache
	{
		public var state:int;  //状态
		
		private var _mountList:Vector.<MountData>;   //坐骑列表(所有坐骑的总和,包括没获得的)
		
	    private var _ownMountList:Vector.<MountData> = new Vector.<MountData> ; //拥有的坐骑
		
		private var _currentMount:MountData;//当前选择的坐骑
		
		public var totalNum:int; //坐骑图鉴总数
		
		public var currentIndex:int; //今天已经更新的次数
		
		public var newMountData:MountData;  //记录最新的那个坐骑
		
		public function MountCache()
		{
			
		}
		
		private function sort(a1:MountData , a2:MountData):int
		{
			if(a1.isOwnMount && _currentMount && a1.itemMountInfo.code == _currentMount.itemMountInfo.code)
			{
				return -1;
			}
			else if(a2.isOwnMount && _currentMount && a2.itemMountInfo.code == _currentMount.itemMountInfo.code)
			{
				return 1;
			}
			else if(a1.isOwnMount && !a2.isOwnMount)
			{
				return -1;
			}
			else if(!a1.isOwnMount && a2.isOwnMount)
			{
				return 1;
			}
			else if(a1.itemMountInfo.code < a2.itemMountInfo.code)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		/**
		 *是否有坐骑 
		 * @return 
		 * 
		 */		
		public function get isHasMount():Boolean
		{
			var bd:Boolean = false;
			for each(var i:MountData in mountList)
			{
				if(i.isOwnMount)
				{
					bd = true;
					break;
				}
			}
			return bd;
		}
		
		/**
		 * 增加坐骑 
		 * @param mount
		 * 
		 */		
		public function addMount(mount:SPublicMount):void
		{
			var mountData:MountData = new MountData(mount.code);
			for each(var i:MountData in mountList)
			{
				if(mountData.itemMountInfo.species == i.itemMountInfo.species)
				{
					i.sPublicMount = mount;
					i.itemMountInfo = mountData.itemMountInfo;
					break;
				}
			}
		}
		
		/**
		 * 删除坐骑 
		 * @param uid
		 * 
		 */		
		public function delMount(uid:String):void
		{
			for each(var i:MountData in mountList)
			{
				if(i.sPublicMount.uid == uid)
				{
					i.sPublicMount = null;
					break;
				}
			}
		}
		
		/**
		 * 根据uid获取坐骑 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getMountDataByUid(uid:String):MountData
		{
			if(uid == "")
			{
				return null;
			}
			var mountData:MountData;
			for each(var i:MountData in mountList)
			{
				if(i.isOwnMount && i.sPublicMount.uid == uid)
				{
					mountData = i;
					break;
				}
			}
			return mountData;
		}
		
		/**
		 * 排序 
		 * 
		 */		
		public function sortList():void
		{
			mountList.sort(sort);
		}
		
		/**
		 * 获取坐骑列表(配置表内的) 
		 * @return 
		 * 
		 */		
		public function get mountList():Vector.<MountData>
		{
			if(_mountList == null)
			{
				_mountList = MountConfig.instance.mountList;
				totalNum = _mountList.length;
			}
			return _mountList;
		}
		
		public function set mountList(value:Vector.<MountData>):void
		{
			_mountList = value;
		}
		
		/**
		 * 当前幻化的坐骑 
		 * @return 
		 * 
		 */		
		public function get currentMount():MountData
		{
			return _currentMount;
		}
		
		public function set currentMount(value:MountData):void
		{
			_currentMount = value;
		}
		
		/**
		 * 是否是骑乘状态 
		 * @return 
		 * 
		 */		
		public function get isRide():Boolean
		{
			if(_currentMount)
			{
				return Cache.instance.role.roleEntityInfo.entityInfo.mountCode? true:false;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 根据code判断是否为当前选择乘骑的坐骑 
		 * @param code
		 * @return 
		 * 
		 */		
		public function isCurrentMount(code:int):Boolean
		{
			return currentMount && code == currentMount.itemMountInfo.code;
		}
		
		public function isNewMount(code:int):Boolean
		{
			var pd:Boolean = newMountData && code == newMountData.itemMountInfo.code;
//			if(pd)
//			{
//				newMountData = null;  //判断是新坐骑后,清空新坐骑
//			}
			return pd;
		}
		
		/**
		 * 当前坐骑的数量 
		 * @return 
		 * 
		 */
		public function get mountNum():int
		{
			var num:int;
			for each(var i:MountData in _mountList)
			{
				if(i.isOwnMount)
				{
					num++;
				}
			}
			return num;
		}
		
		/**
		 * 自己拥有的坐骑列表 
		 * @return 
		 * 
		 */		
		public function get ownMountList():Vector.<MountData>
		{
			_ownMountList.length = 0;
			for each(var i:MountData in mountList)
			{
				if(i.isOwnMount)
				{
					_ownMountList.push(i);
				}
			}
			return _ownMountList;
		}
	}
}