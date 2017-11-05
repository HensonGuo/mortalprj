package mortal.game.cache
{
	import Message.Game.SMarketItem;
	import Message.Game.SSeqMarketItem;
	import Message.Public.ECareer;
	
	import flash.utils.Dictionary;
	
	import mortal.component.gconst.GameConst;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.utils.ItemsUtil;

	/**
	 * 市场数据缓存
	 * @author lizhaoning
	 */
	public class MarketCache
	{
		/** 所有寄售(求购)物品 */
		public var marketItemObj:SSeqMarketItem;
		/** 我的寄售物品 */
		public var mySaleMarketItemObj:SSeqMarketItem;
		/** 我的求购物品 */
		public var mySeekBuyMarketItemObj:SSeqMarketItem;
		
		/** 市场快捷购买记录 */
		public var marketItemRecord:SMarketItem;
		
		public function MarketCache()
		{
			marketItemObj = new SSeqMarketItem();
			mySaleMarketItemObj = new SSeqMarketItem();
			mySeekBuyMarketItemObj = new SSeqMarketItem();
		}
		
		/** 
		 * 更新  所有寄售(求购)物品
		 * @param arr
		 */
		public function updateMarketItemVec(obj:Object):void
		{
			marketItemObj  = obj as SSeqMarketItem;
		}
		
		/**
		 * 更新我的寄售物品 
		 * @param arr
		 */
		public function updateMySaleMarketItemVec(obj:Object):void
		{
			mySaleMarketItemObj  = obj as SSeqMarketItem;
		}
		
		/**
		 * 更新我的求购物品 
		 * @param arr
		 */
		public function updateMySeekBuyMarketItemVec(obj:Object):void
		{
			mySeekBuyMarketItemObj  = obj as SSeqMarketItem;
		}
		
		private function writeArrToMarketVec(arr:Array, vec:Vector.<SMarketItem>):void
		{
			if(vec)
			{
				vec.splice(0,vec.length);
			}
			for (var i:int = 0; i < arr.length; i++) 
			{
				vec.push(arr[i]);
			}
		}
		
		
		/** 移出绑定、过期物品 */
		public static function removeBindAndOverDue(arr:Array):Array{
			var itemInfo:ItemInfo;
			for (var i:int = arr.length-1; i > -1; i--) 
			{
				itemInfo = arr[i];
				if(itemInfo.bind == 1 || ItemsUtil.isOverdueByConfig(itemInfo))
//				if(itemInfo.bind == 1)
				{
					arr.splice(i,1);
				}
			}
			return arr;
		}
		
		public static function searchByName(_name:String):Array
		{
			var itemArr:Array = [];
			var allItem:Dictionary = ItemConfig.instance.getAllMap();
			//遍历物品
			for each (var item:* in allItem) 
			{
				//只搜索可寄售物品
				if(item.market == 1)
				{
					//物品名字不需要全匹配
					if(String(item.name).indexOf(_name) == -1)
					{		
						continue ;
					}
					itemArr.push(item);
				}
			}
			
			return removeBindAndOverDue(itemArr);
		}
		
		public static function searchByCondition(conditions:Object):Array
		{
			var itemArr:Array = [];
			
			//只搜索可寄售物品
			conditions.market = 1;
			
			//自定义条件
			var minLevel:int = 0;
			var maxLevel:int = GameConst.PlayerMaxLevel;
			var typeArr:Array;
			var career:int;
			if(conditions.hasOwnProperty("minLevel"))
			{
				minLevel = conditions["minLevel"];
				delete conditions["minLevel"];
			}
			if(conditions.hasOwnProperty("maxLevel"))
			{
				maxLevel = conditions["maxLevel"];
				delete conditions["maxLevel"];
			}
			if(conditions.hasOwnProperty("typeArr"))
			{
				typeArr = conditions["typeArr"];
				delete conditions["typeArr"];
			}
			if(conditions.hasOwnProperty("career"))
			{
				career = conditions["career"];
				delete conditions["career"];
			}
			//过滤掉没有的属性
			var itemInfo:ItemInfo = new ItemInfo;
			for each (var key1:int in conditions) 
			{
				if(!itemInfo.hasOwnProperty(key1))
					delete conditions[key1];
			}
			
			
			var allItem:Dictionary = ItemConfig.instance.getAllMap();
			//遍历物品
			parent:
			//遍历物品
			for each (var item:* in allItem) 
			{
				for(var key:String in conditions)
				{
					
					if(item[key] != conditions[key])
					{
						continue parent;
					}
					
					//自定义条件判断
					if(item.level < minLevel || item.level > maxLevel)
					{
						continue parent;
					}
					//职业需要匹配当前职业和无职业
					if(item.career != career && item.career != ECareer._ECareerNo)
					{
						continue parent;
					}
					if(typeArr && typeArr.length)
					{
						for (var i:int = 0; i < typeArr.length; i++) 
						{
							var str:String = typeArr[i];
							trace(item.category == str.split("#")[0])
							trace(str.indexOf("#"+item.type+"#") != -1)
							if(item.category == str.split("#")[0]  && str.indexOf("#"+item.type+"#") != -1)
							{
								trace("-------------找到");
								break;
							}
						}
						if(i >= typeArr.length)
						{
							continue parent;
						}
					}
					
				}
				itemArr.push(item);
			}
			
			return removeBindAndOverDue(itemArr);
		}
	}
}