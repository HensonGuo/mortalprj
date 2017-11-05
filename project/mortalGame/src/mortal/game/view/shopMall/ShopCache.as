package mortal.game.view.shopMall
{
	import Message.Game.SBuyBackItem;
	import Message.Game.SPanicBuyItemMsg;
	import Message.Game.SPanicBuyShopMsg;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.view.shopMall.data.ShopPanicData;

	public class ShopCache
	{
		//抢购缓存
		public var panicList:Array = new Array();    //抢购商品列表(ShopPropData)
		
		public var panicInfo:SPanicBuyShopMsg;  //抢购商店信息(包括剩余时间和描述等)
		
		public var panicBuyDict:Dictionary = new Dictionary();   //抢购记录表
		
		//商店缓存
		public var buyBackList:Array = new Array();  
		
		public function ShopCache()
		{
		}
		
		/**
		 *获取创建商城的标签信息
		 * @return Array
		 *
		 */
//		public function getShopMallTabData():Array
//		{
//			var rtnArray:Array=[];
//			var tshopArray:Array=ShopConfig.instance.getShopMallArray(Global.isDebugModle);
//			var isGradeCareer:Boolean = CareerUtil.isGradeCareer();
//			for (var i:int=0; i < tshopArray.length; i++)
//			{
//				var tshop:TShop=tshopArray[i] as TShop;
//				var dict:Dictionary=new Dictionary();
//				dict['name']=tshop.name;
//				dict['label']=tshop.name;
//				dict['code']=tshop.code;
//				if(i <= 8)//正式的序号<=8
//				{
//					dict['styleName'] = "ShopMallTab"+i;
//				}
//				if(tshop.code == ShopRule.ShopMallRune)
//				{
//					//65级并转完职
//					if(Cache.instance.role.entityInfo.level >= 65 && isGradeCareer) 
//					{
//						rtnArray.push(dict);
//					}
//				}
//				else
//				{
//					rtnArray.push(dict);
//				}
//			}
//			return rtnArray;
//		}
		
		//以下是抢购缓存
		
		public function updatePanicList(arr:Array):void
		{
			panicList = [];
			for each(var i:SPanicBuyItemMsg in arr)
			{
				var shopPropData:ShopPanicData = new ShopPanicData(i , panicInfo.code );
				panicList.push(shopPropData);
			}
		}
		
		
		/**
		 * 通过tiemCode修改抢购列表里面的剩余数量 
		 * @param itemCode
		 * @return 
		 * 
		 */		
		public function changePanicItemLeftNum(itemCode:int , num:int):void
		{
			for each(var i:ShopPanicData in panicList)
			{
				if(i.tShopPanic.itemCode == itemCode)
				{
					i.sPanicBuyItem.leftAmount = num;
					break;
				}
			}
		}
		
		/**
		 * 根据抢购物品的itemCode获取剩余限购的数量 
		 * @param itemCode
		 * @return 
		 * 
		 */		
		public function getLimitNumByKey(key:String):int
		{
			var num:int;
			for each(var i:ShopPanicData in panicList)
			{
				if(i.tShopPanic.code + "_" +  i.sPanicBuyItem.index == key)
				{
					if(panicBuyDict[key])
					{
						num = ShopConfig.instance.getPanicShopSellInfoByKey(i.tShopPanic.code + "_" + i.sPanicBuyItem.index).buyLimit - panicBuyDict[key]
					}
					else
					{
						num = ShopConfig.instance.getPanicShopSellInfoByKey(i.tShopPanic.code + "_" + i.sPanicBuyItem.index).buyLimit;
					}
					break;
				}
			}
			return num;
		}
		
		public function removeBuyBackItemByUid(uid:String):void
		{
			for(var i:int ; i < buyBackList.length ; i++)
			{
				if(buyBackList[i].uid == uid)
				{
					buyBackList.splice(i,1);
				}
			}
		}
	}
}