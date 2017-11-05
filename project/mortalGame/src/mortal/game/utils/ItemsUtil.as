/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.utils
{
	import Message.Public.EAdvanceType;
	import Message.Public.EGroup;
	import Message.Public.EItemUseType;
	import Message.Public.EProp;
	import Message.Public.EPropType;
	import Message.Public.ESell;
	import Message.Public.EStuff;
	import Message.Public.SPoint;
	
	import com.gengine.utils.HTMLUtil;
	
	import mortal.game.cache.Cache;
	import mortal.game.manager.ClockManager;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.view.mount.data.MountData;

	/**
	 *物品使用管理类
	 * @author cHao
	 *
	 */
	public class ItemsUtil
	{
		public var itemPoint:SPoint=new SPoint(); //发送物品使用位置

		public static var CoinIcoUrl:String = "CoinIco1.jpg";
		
		public static var MagicWeaponScoreTimes:Array = [
			1.00001,
			1.00001,
			1.00001,
			1.00001,
			1.50001,
			2.30001,
			3.50001
		];
		
		/**
		 * 获取对应的绑定code 
		 * @param code
		 * @return 
		 * 
		 */		
		public static function getBindCode(code:int):int
		{
			var item:ItemInfo = ItemConfig.instance.getConfig(code);
			if(item == null || item.bind == 1)
			{
				return code;
			}
			return item.codeUnbind;
		}
		
		/**
		 * 获取对应的非绑定code 
		 * @param code
		 * @return 
		 * 
		 */			
		public static function getUnbindCode(code:int):int
		{
			var item:ItemInfo = ItemConfig.instance.getConfig(code);
			if(item == null || item.bind == 0)
			{
				return code;
			}
			return item.codeUnbind;
		}

		/**
		 * 时候任务物品 
		 * @param itemData
		 * @return 
		 * 
		 */
		public static function isTaskItem(itemData:ItemData):Boolean
		{
			return itemData.itemInfo.group == EGroup._EGroupTask;
		}
		
		/**
		 * 是否可以摧毁 
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function isCanDestroy(itemData:ItemData):Boolean
		{
			return !isTaskItem(itemData);
		}

		/**
		 * 是否绑定 
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function isBind( itemData:ItemData):Boolean
		{
			if(itemData.extInfo != null)
			{
				if(itemData.extInfo.bd == 1)
				{
					return true;
				}
				else if (itemData.extInfo.bd == 2)
				{
					return false;
				}
				else
				{
					return false;
				}
			}
			else if(itemData.itemInfo.bind == 1 )
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 是否坐骑 
		 * @param itemData
		 * @return 
		 * 
		 */
		public static function isMount(itemData:ItemData):Boolean
		{
			return itemData.itemInfo.group == EGroup._EGroupProp && itemData.itemInfo.category == EProp._EPropMount;
//			return itemData.itemInfo.group == EGroup._EGroupStuff && itemData.itemInfo.category == EProp._EPropMount;
		}
		
		/**
		 * 是否坐骑培养
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function isMountCulturUse(itemData:ItemData):Boolean
		{
			return itemData.itemInfo.type == EAdvanceType._EAdvanceTypeMountUp;
		}
		
		public static function isPetSoul(itemData:ItemData):Boolean
		{
			return itemData.itemInfo.group == EGroup._EGroupProp && itemData.itemInfo.category == EProp._EPropProp && itemData.itemInfo.type == EPropType._EPropTypePetSkillRand

		}
		
		/**
		 *获取物品名称，包括颜色 
		 * @param itemData
		 * @param parse{0}代表原本名字
		 * @return 
		 * 
		 */		
		public static function getItemName(itemData:ItemData,parse:String = "{0}"):String
		{
			var rtnName:String = "";
			if(itemData)
			{
				rtnName = HTMLUtil.addColor(parse.replace("{0}",itemData.itemInfo.name),ColorConfig.instance.getItemColor(itemData.itemInfo.color).color);
			}
			return rtnName;
		}
		
		/**
		 *获取物品名称，包括颜色 
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function getItemNameAndAmount(itemData:ItemData):String
		{
			var rtnName:String = "";
			if(itemData)
			{
				rtnName = HTMLUtil.addColor(itemData.name+"×"+itemData.itemAmount,ColorConfig.instance.getItemColor(itemData.itemInfo.color).color);
			}
			return rtnName;
		}
		
		/**
		 *  是否是技能书
		 * @param itemData
		 * @return
		 *
		 */
		public static function isSkillBook(itemData:ItemData):Boolean
		{
			return itemData.itemInfo.group == EStuff._EStuffAdvance ;
		}
		
		/**
		 * 是否装备 
		 * @param itemData
		 * @return 
		 * 
		 */
		public static function isEquip(itemData:ItemData):Boolean
		{
			return itemData.itemInfo.group == EGroup._EGroupProp && itemData.itemInfo.category == EProp._EPropEquip;
		}
		
		
		/**
		 * 获取装备的强化等级 
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function getEquipStrengthen(itemData:ItemData):int
		{
			var strengthen:int = 0;
//			if(itemData.category == ECategory._ECategoryEquip || ECategory._ECategoryPetEquip )
//			{
//				var itemExInfo:Object = itemData.itemExInfo;
//				if (itemExInfo && itemExInfo.strengthen != undefined)
//				{
//					strengthen = itemExInfo.strengthen;
//				}
//			}
			return strengthen;
		}
		
		/**
		 * 是否同一个物品 
		 * @param itemData1
		 * @param itemData2
		 * 
		 */		
		public static function isSameItemData(itemData1:ItemData,itemData2:ItemData):Boolean
		{
			if(itemData1 && itemData2 && itemData1.itemCode == itemData2.itemCode)
			{
				return true;
			}
			return false;
		}
		
		/**
		 * 是否已过期
		 */
		public static function isOverdueItem(itemData:ItemData):Boolean
		{
			var isOverdue:Boolean = false;
			var itemExInfo:Object = itemData.extInfo;
			var day:int = -1;
			var date:Date = ClockManager.instance.nowDate;
			if(itemExInfo && itemExInfo.fashEffDay)
			{
				day = int(itemExInfo.fashEffDay);//自1970以来的天数
				if( date.time/(1000*60*60*24) > day )
				{
					isOverdue = true;
				}
			}
			return isOverdue;
		}
		
		/**
		 * 根据物品配置的时间判断是否过期 
		 * @param itemInfo
		 * @return 
		 * 
		 */		
		public static function isOverdueByConfig(itemInfo:ItemInfo):Boolean
		{
			var begin:int = itemInfo.beginTime.time;
			var end:int = itemInfo.endTime.time;
			if(begin == end) // 没有使用期限
			{
				return false;
			}
			else
			{
				var now:int = ClockManager.instance.nowDate.time;
				if(now >= begin && now < end)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 是否可出售
		 * @param itemData
		 * @return 
		 * 
		 */	
		public static function isCanSell(itemData:ItemData):Boolean
		{
			return itemData.itemInfo.sell == ESell._ESellYes;
		}
		
		/**
		 * 是否宝石
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function isJewel(itemData:ItemData):Boolean
		{
			return false;
		}
		
		/**
		 * 是否普通宝石
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function isNormalJewel(itemData:ItemData):Boolean
		{
			return false;
		}
		
		/**
		 * 是否特性宝石
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function isSpecialJewel(itemData:ItemData):Boolean
		{
			return false;
		}
		
		/**
		 * 法宝的评分 = 基础评分 * 倍率，  紫色：1.5 橙色2.3 暗金3.5 
		 * @param data
		 * @return 
		 * 
		 */		
//		public static function getMagicWeaponScore(data:ItemData):int
//		{
//			if(data == null)
//			{
//				return 0;
//			}
//			var basicScore:int = 0;
//			if(data.extInfo)
//			{
//				basicScore = data.extInfo.al_sc;
//			}
//			
//			return int((basicScore * MagicWeaponScoreTimes[data.itemInfo.color] *100)/100);
//		}
		
		/**
		 *  是否能使用
		 * @param itemData
		 * @return
		 *
		 */
		public static function isNotCanUse(itemData:ItemData):Boolean
		{
			return Boolean(itemData.itemInfo.useType == EItemUseType._EItemUseTypeCanNotUse);
		}
		
		/**
		 *  是否达到使用等级
		 * @param itemData
		 * @return
		 *
		 */
		public static function isEnoughLevel(itemData:ItemData):Boolean
		{
			return Boolean(itemData.itemInfo.level > Cache.instance.role.entityInfo.level);
		}
		
		/**
		 *  是否达到对应职业
		 * @param itemData
		 * @return
		 *
		 */
		public static function isFitCarrer(itemData:ItemData):Boolean
		{
			return Boolean(itemData.itemInfo.career == 0 || itemData.itemInfo.career == 256 || itemData.itemInfo.career == Cache.instance.role.entityInfo.career);
		}
		
		/**
		 *  是否能在背包使用
		 * @param itemData
		 * @return
		 *
		 */
		public static function isCanUseInBag(itemData:ItemData):Boolean
		{
			return Boolean(itemData.itemInfo.useType & EItemUseType._EItemUseTypeUseInBag);
		}
		
		/**
		 * 是否能够批量使用 
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function isCanBulkUse(itemData:ItemData):Boolean
		{
			return itemData.serverData.itemAmount > 1 && ((itemData.itemInfo.useType & EItemUseType._EItemUseTypeCanBatchUse));
		}
		
		/**
		 * 是否为宠物使用
		 * @param itemData
		 * @return
		 *
		 */
		public static function isPetUse(itemData:ItemData):Boolean
		{
			return Boolean(itemData.itemInfo.useType & EItemUseType._EItemUseTypePet);
		}
		
		/**
		 * 特殊物品处理
		 * @param itemData
		 * @return
		 *
		 */
		public static function isOpenFunc(itemData:ItemData):Boolean
		{
			return itemData.itemInfo.useType == EItemUseType._EItemUseTypeSpecial;
		}
		
		/**
		 * 是否获得后直接使用 
		 * @param itemData
		 * @return 
		 * 
		 */		
		public static function isGetUse(itemData:ItemData):Boolean
		{
			return itemData.itemInfo.useType == EItemUseType._EItemUseTypeGet;
		}
		
		/**
		 * 是否符文材料 
		 * @param info
		 * @return 
		 * 
		 */		
		public static function isRuneStuff(info:ItemInfo):Boolean
		{
			return info.group == EGroup._EGroupStuff && info.category == EStuff._EStuffAdvance 
				&& info.type == EAdvanceType._EAdvanceTypeRune;
		}
		
		public static function isPetEgg(info:ItemInfo):Boolean
		{
			return info.group == EGroup._EGroupProp && info.category == EProp._EPropProp 
				&& info.type == EPropType._EPropTypePetEgg;
		}
	}
}