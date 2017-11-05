package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TShop;
	import Message.DB.Tables.TShopPanicBuyItem;
	import Message.DB.Tables.TShopSell;
	
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.common.tools.DateParser;
	import mortal.game.cache.Cache;
	import mortal.game.manager.ClockManager;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.ClassTypesUtil;

	public class ShopConfig
	{
		private static var _instance:ShopConfig;
		
		//商店配置
		private var _shopMap:Dictionary = new Dictionary();
		
		private var _shopList:Vector.<TShop> = new Vector.<TShop>;
		
		//以下是抢购商品
		private var _shopPanicMap:Dictionary = new Dictionary();
		
		private var _shopPanicItems:Vector.<TShopPanicBuyItem> = new Vector.<TShopPanicBuyItem>;
		
		
		//以下是商城商品
		private var _shopSellMap:Dictionary = new Dictionary();
		
		private var _ShopSellitems:Vector.<TShopSell> = new Vector.<TShopSell>;    //所有商品列表
		
		private var _hotBuyList:Vector.<TShopSell> = new Vector.<TShopSell>;   //热卖商品列表
		
		private var _usuallyList:Vector.<TShopSell> = new Vector.<TShopSell>;   //常用商店列表
		
		private var _paterialList:Vector.<TShopSell> = new Vector.<TShopSell>;   //材料商店列表
		
		private var _petList:Vector.<TShopSell> = new Vector.<TShopSell>;   //宠物商店列表
		
		private var _medList:Vector.<TShopSell> = new Vector.<TShopSell>;   //药品商店列表
		
		private var _vipList:Vector.<TShopSell> = new Vector.<TShopSell>;   //vip商店列表
		
		private var _preferentialList:Vector.<TShopSell> = new Vector.<TShopSell>;   //优惠商店列表
		
		
		public function ShopConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ShopConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():ShopConfig
		{
			if( _instance == null )
			{
				_instance = new ShopConfig();
			}
			return _instance;
		}
		
		private function write( dic:Object ):void
		{
			var info:TShopSell;
			
			for each( var o:Object in dic )
			{
				info = new TShopSell();
				changeToDate(o);
				ClassTypesUtil.copyValue(info,o);
				_shopSellMap[ info.itemCode ] = info;
				_ShopSellitems.push(info);
				
				switch(info.shopCode)
				{
					case 1001: //热卖商品
						_hotBuyList.push(info);break;
					case 1002:  //常用商店
						_usuallyList.push(info);break;
					case 1003:
						_paterialList.push(info);break;
					case 1004:
						_petList.push(info);break;
					case 1005:
						_medList.push(info);break;
					case 1006:
						_vipList.push(info);break;
					case 1007:
						_preferentialList.push(info);break;
					default:
						break;
						
				}
			}
		}
		
		private function writePanic( dic:Object ):void
		{
			var info:TShopPanicBuyItem;
			
			for each( var o:Object in dic )
			{
				info = new TShopPanicBuyItem();
				changeToDate(o);
				ClassTypesUtil.copyValue(info,o);
				_shopPanicMap[ info.code + "_" + info.index ] = info;
				_shopPanicItems.push(info);
			}
				
		}
		
		private function writeShop( dic:Object ):void
		{
			var info:TShop;
			for each(var o:Object in dic )
			{
				info = new TShop();
				changeToDate(o);
				ClassTypesUtil.copyValue(info,o);
				_shopMap[ info.code ] = info;
				_shopList.push(info);
			}
		}
		
		/**
		 * 根据条件筛选数组里面的物品 
		 * @param list
		 * @return 
		 * 
		 */		
		private function getArr(list:Vector.<TShopSell>):Vector.<TShopSell>
		{
			var vec:Vector.<TShopSell> = new Vector.<TShopSell>;
			var level:int = Cache.instance.role.entityInfo.level;
			var time:Number = ClockManager.instance.nowDate.time;
			for each(var i:TShopSell in list)
			{
				if((level <= i.maxLevelLimit && level >= i.minLevelLimit) || i.maxLevelLimit == 0)  //是否等级足够
				{
					
					if(time <= i.endDt.time && time >= i.startDt.time)  //是否过期
					{
						vec.push(i);
					}
				}
			}
			return vec;
		}
		
		private function init():void
		{
			var object:Object = ConfigManager.instance.getJSONByFileName("t_shop_sell.json");
			write( object );
			object =  ConfigManager.instance.getJSONByFileName("t_shop_panic_buy_item.json");
			writePanic( object );
			object =  ConfigManager.instance.getJSONByFileName("t_shop.json");
			writeShop( object );
			
		}
		
		protected function changeToDate(o:Object):void
		{
			if(o.hasOwnProperty("endDt"))
			{
				o["endDt"] = DateParser.strToDateNormal(o["endDt"]);
			}
			if(o.hasOwnProperty("startDt"))
			{
				o["startDt"] = DateParser.strToDateNormal(o["startDt"]);
			}
		}
		
		//以下是普通商品的配置==============================================================
		/**
		 * 根据itemCode获取商品配置
		 * @param value
		 * @return 
		 * 
		 */		
		public function getShopSellInfoById( itemCode:int ):TShopSell
		{
			return _shopSellMap[itemCode];
		}
		
		/**
		 *  获取所有商品列表
		 * @return 
		 * 
		 */		
		public function get shopSellitems():Vector.<TShopSell>
		{
			return _ShopSellitems;
		}
		
		public function get hotBuyList():Vector.<TShopSell>
		{
			return  getArr(_hotBuyList);
		}
		
		public function get usuallyList():Vector.<TShopSell>
		{
			return  getArr(_usuallyList);
		}
		
		public function get paterialList():Vector.<TShopSell>
		{
			return getArr(_paterialList);
		}
		
		public function get petList():Vector.<TShopSell>
		{
			return getArr(_petList);
		}
		
		public function get medList():Vector.<TShopSell>
		{
			return getArr(_medList);
		}
		
		public function get vipList():Vector.<TShopSell>
		{
			return getArr(_vipList);
		}
		
		public function get preferentialList():Vector.<TShopSell>
		{
			return getArr(_preferentialList);
		}
		
		
		//以下是抢购的配置==============================================================
		/**
		 * 根据itemCode和index获取抢购商品配置 
		 * @param key格式(itemCode + "_" + index)
		 * @return 
		 * 
		 */		
		public function getPanicShopSellInfoByKey( key:String ):TShopPanicBuyItem
		{
			return _shopPanicMap[key];
		}
		
		/**
		 * 获取所有抢购商品列表 
		 * @return 
		 * 
		 */		
		public function get shopPanicItems():Vector.<TShopPanicBuyItem>
		{
			return _shopPanicItems;
		}
		
		
		//以下是商店的配置==============================================================
		/**
		 * 根据itemCode获取商店配置 
		 * @param shopCode
		 * @return 
		 * 
		 */		
		public function getShopById( shopCode:int ):TShop
		{
			return _shopMap[shopCode];
		}
		
		/**
		 * 根据shopCode来找到该商店对应的tab标签 
		 * @param shopCode
		 * @return 
		 * 
		 */		
		public function getShopTabByCode( shopCode:int ):Array
		{
			var retArr:Array = new Array();
			var isMall:int = getShopById(shopCode).isMall;
			var obj:Object;
			for each(var i:TShop in _shopList)
			{
				if(i.isMall == isMall)
				{
					obj = {"name":i.code , "label":i.name};
					retArr.push(obj);
				}
			}
			return retArr;
		}
		
		/**
		 * 根据商店code获取对应的商品 
		 * @param shopCode
		 * @return 
		 * 
		 */		
		public function getShopItemByCode( shopCode:int ):Vector.<TShopSell>
		{
			var vec:Vector.<TShopSell> = new Vector.<TShopSell>;
			for each(var i:TShopSell in _ShopSellitems)
			{
				if(i.shopCode == shopCode)
				{
					vec.push(i);
				}
			}
			return vec;
		}
		
		/**
		 * 根据商品code获取商店位置 
		 * @param code
		 * @return 
		 * 
		 */		
		public function getShopByItemCode(code:int):TShop
		{
			return getShopById(getShopSellInfoById(code).shopCode);
		}
		
		/**
		 * 根据分组,大类和小类获得商店中对应物品的数组 
		 * @param group
		 * @param category
		 * @param type
		 * @return 
		 * 
		 */		
		public function getShopItemByType(group:int,category:int,type:int):Vector.<ItemData>
		{
			var itemData:ItemData;
			var itemVec:Vector.<ItemData> = new Vector.<ItemData>();
			for each(var i:TShopSell in _ShopSellitems)
			{
				itemData = new ItemData(i.itemCode);
				if(getShopByItemCode(itemData.itemCode).isMall == 1000 && itemData.itemInfo.group == group && itemData.itemInfo.category == category && itemData.itemInfo.type == type)
				{
					itemVec.push(itemData);
				}
			}
			return itemVec;
		}
	}
}