/**
 * 2014-1-2
 * @author chenriji
 **/
package mortal.game.resource
{
	import com.gengine.debug.Log;
	import com.gengine.resource.ConfigManager;
	
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mortal.common.tools.DateParser;
	import mortal.game.resource.info.item.ItemEquipInfo;
	import mortal.game.resource.info.item.ItemGiftBagInfo;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.resource.info.item.ItemMountInfo;
	import mortal.game.resource.tableConfig.DescConfig;
	import mortal.game.view.common.ClassTypesUtil;
	
	public class ItemConfig
	{
		private var map:Dictionary = new Dictionary();
		private var _equipDic:Dictionary = new Dictionary();
		
		public var mountMap:Dictionary = new Dictionary();  //坐骑词典
		
		public function ItemConfig()
		{
			super();
			init();
		}
		
		protected function init():void
		{
			//物品表
			var time:int = getTimer();
			var memory:int = System.totalMemory;
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_item.json");
			write(object);
			Log.system("解析t_item耗时:",getTimer() - time);
			Log.system("解析t_item内存增加:",System.totalMemory,System.totalMemory - memory);
			//读取装备表
			object =  ConfigManager.instance.getJSONByFileName("t_item_equip.json");
			writeWeapon(object);
			Log.system("解析t_item_equip耗时:" , getTimer() - time);
			//读礼品表
			object =  ConfigManager.instance.getJSONByFileName("t_item_gift_bag.json");
			writeGiftBag(object);
			Log.system("解析t_item_gift_bag耗时:" , getTimer() - time);
			//坐骑表
			object = ConfigManager.instance.getJSONByFileName("t_item_mount.json");
			writeMount(object);
			Log.system("解析t_item_mount耗时:" , getTimer() - time);
		}
		
		protected function changeToDate(o:Object):void
		{
			if(o.hasOwnProperty("beginTime"))
			{
				o["beginTime"] = DateParser.strToDateNormal(o["beginTime"]);
			}
			if(o.hasOwnProperty("endTime"))
			{
				o["endTime"] = DateParser.strToDateNormal(o["endTime"]);
			}
		}
		
		protected function write(dic:Object):void
		{
			var item:ItemInfo;
			var i:int = 0;
			for each(var o:Object in dic)
			{
				item = new ItemInfo();
				changeToDate(o);
				ClassTypesUtil.copyValue(item, o);
				if(item.descStr)
				{
					var descId:int = int(item.descStr);
					if(descId > 0)
					{
						item.descStr = DescConfig.instance.getDescAlyzObj( descId,o);
					}
				}
				map[item.code] = item;
			}
		}
		
		protected function writeWeapon(dic:Object):void
		{
			var itemInfo:ItemEquipInfo;
			for each( var o:Object in dic  )
			{
				itemInfo = new ItemEquipInfo();
				changeToDate(o);
				ClassTypesUtil.copyValue(itemInfo, o);
				map[itemInfo.code] = itemInfo;
				if(itemInfo.descStr)
				{
					var descId:int = int(itemInfo.descStr);
					if(descId > 0)
					{
						itemInfo.descStr = DescConfig.instance.getDescAlyzObj( descId,o);
					}
				}
				_equipDic[itemInfo.code] = itemInfo;
			}
		}
		
		protected function writeGiftBag(dic:Object):void
		{
			var itemInfo:ItemGiftBagInfo;
			for each( var o:Object in dic  )
			{
				itemInfo = new ItemGiftBagInfo();
				changeToDate(o);
				ClassTypesUtil.copyValue(itemInfo, o);
				map[itemInfo.code] = itemInfo;
			}
		}
		
		protected function writeMount(dic:Object):void
		{
			var itemInfo:ItemMountInfo;
			for each( var o:Object in dic  )
			{
				itemInfo = new ItemMountInfo();
				changeToDate(o);
				ClassTypesUtil.copyValue(itemInfo, o);
				map[itemInfo.code] = itemInfo;
				mountMap[itemInfo.code] = itemInfo;
			}
		}
		
		private static var _instance:ItemConfig;
		
		public static function get instance():ItemConfig
		{
			if(_instance == null)
			{
				_instance = new ItemConfig();
			}
			return _instance;
		}
		
		public function getConfig(code:int):ItemInfo
		{
			return map[code];
		}
		
		public function getAllEquipBySuitGroup(suitGroup:int):Array
		{
			var res:Array = [];
			for each(var info:ItemEquipInfo in _equipDic)
			{
				if(info.suitGroup == suitGroup)
				{
					res.push(info);
				}
			}
			return res;
		}
		
		public function getAllMap():Dictionary
		{
			return map;
		}
		
		
		public function getItemNameByCode(name:String):ItemInfo
		{
			var itemInfo:ItemInfo;
			for each(var i:ItemInfo in map)
			{
				if(i.name == name)
				{
					itemInfo = i;
					break;
				}
			}
			return itemInfo;
		}
	}
}