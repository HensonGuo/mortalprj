package mortal.game.utils
{
	import Message.Public.EAdvanceType;
	
	import com.gengine.utils.HTMLUtil;
	
	import mortal.game.cache.Cache;
	import mortal.game.manager.ClockManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.MountConfig;
	import mortal.game.view.mount.data.MountData;
	import mortal.game.view.mount.data.MountToolData;

	public class MountUtil
	{
		public function MountUtil()
		{
		}
		
		/**
		 * 获取等级限制 
		 * @param color
		 * @return 
		 * 
		 */		
		public static function getMaxLevelByColor(color:int):int
		{
			var level:int;
			switch(color)
			{
				case 1:level = 20;break;
				case 2:level = 40;break;
				case 3:level = 60;break;
				case 4:level = 80;break;
			}
			return level;
		}
		
		
		
		/**
		 *获取坐骑名称，包括颜色 
		 * @param itemData
		 * @param parse{0}代表原本名字
		 * @return 
		 * 
		 */		
		public static function getItemName(mountData:MountData,parse:String = "{0}"):String
		{
			var rtnName:String = "";
			if(mountData)
			{
				rtnName = HTMLUtil.addColor(parse.replace("{0}",mountData.itemMountInfo.name),ColorConfig.instance.getItemColor(mountData.itemMountInfo.color).color);
			}
			return rtnName;
		}
		
		/**
		 * 能否培养坐骑(次数已满或者等级已经满了的时候不能培养坐骑) 
		 * @return 
		 * 
		 */		
		public static function isCanCultur(mountData:MountData):Boolean
		{
			if(mountData.sPublicMount.level >= getMaxLevelByColor(mountData.itemMountInfo.color))
			{
				MsgManager.showRollTipsMsg("坐骑已经满级");
				return false;
			}
			
			if(Cache.instance.mount.currentIndex >= 10)
			{
				MsgManager.showRollTipsMsg("今日元宝升级次数已满");
				return false;
			}
			
			return true;
		}
		
		public static function isMaxLevel(mountData:MountData):Boolean
		{
			if(mountData.sPublicMount.level >= getMaxLevelByColor(mountData.itemMountInfo.color))
			{
				MsgManager.showRollTipsMsg("坐骑已经满级");
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 是否有足够金钱培养坐骑 
		 * @return 
		 * 
		 */		
		public static function isEnougthCulturMoney():Boolean
		{
			var index:int = Cache.instance.mount.currentIndex + 1 > 10? 10:Cache.instance.mount.currentIndex + 1;
			var gold:int = MountConfig.instance.getMountGoldUpByNum(index).gold;
			return Cache.instance.role.money.gold >= gold;
		}
		
		/**
		 * 背包中是否含有该类物品 
		 * @return 
		 * 
		 */		
		public static function hasCurltureItemInPack():Boolean
		{
			var arr:Array = Cache.instance.pack.backPackCache.getStuffsByTpey(EAdvanceType._EAdvanceTypeMountUp);
			if(arr.length)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 是否有足够金钱或者道具提高血统 
		 * @param type  1为普通提升  10为10倍提升
		 * @return 
		 * 
		 */		
		public static function isEnougthToLineage(type:int):Boolean
		{
			var arr:Array = Cache.instance.pack.backPackCache.getStuffsByTpey(EAdvanceType._EAdvanceTypeMountTool);
		    var num:int;
			
			for each(var i:ItemData in arr)
			{
				num += i.itemAmount;
			}
			
			if((num + Cache.instance.role.money.gold) >= type)
			{
				return true;
			}
			else
			{
				MsgManager.showRollTipsMsg("道具和元宝不足");
				return false;
			}
		}
		
		/**
		 * 是否有血统提升的道具 
		 * @return 
		 * 
		 */		
		public static function isHasLineageItem():Boolean
		{
			return Cache.instance.pack.backPackCache.getStuffsByTpey(EAdvanceType._EAdvanceTypeMountTool).length > 0;
		}
		
		/**
		 * 是否超过使用时间
		 * @param mountData
		 * @return 
		 * 
		 */		
		public static function isOverTime(mountData:MountData):Boolean
		{
			var time:Number = ClockManager.instance.nowDate.time;
			if(mountData.itemMountInfo.existTime != 0)
			{
				return false;
			}
			else
			{
				if(mountData.itemMountInfo.beginTime.time == mountData.itemMountInfo.endTime.time)
				{
					return false;
				}
				else
				{
					return time < mountData.itemMountInfo.beginTime.time || time >= mountData.itemMountInfo.endTime.time;
				}
			}
		}
		
		/**
		 * 是否时效坐骑 
		 * @param mountData
		 * @return 
		 * 
		 */		
		public static function isExistMount(mountData:MountData):Boolean
		{
			return mountData.itemMountInfo.existTime != 0;
		}
		
		/**
		 * 坐骑宝具是否满级 
		 * @param mountData
		 * @return 
		 * 
		 */		
		public static function isToolMaxLevel(mountData:MountData):Boolean
		{
			var pd:Boolean = true;
			for each(var i:MountToolData in mountData.toolList)
			{
				if(i.level < 50)
				{
					pd = false;
					break;
				}
			}
			return pd;
		}
	}
}