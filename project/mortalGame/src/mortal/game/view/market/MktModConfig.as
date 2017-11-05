package mortal.game.view.market
{
	import Message.Game.EMarketRecordType;
	import Message.Game.EMarketTimeType;
	import Message.Game.SMarketItem;
	import Message.Public.ECareer;
	import Message.Public.EColor;
	import Message.Public.EPrictUnit;
	
	import fl.data.DataProvider;
	
	import flash.utils.Dictionary;
	
	import mortal.component.gconst.GameConst;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.tableConfig.MarketConfig;

	/**
	 * 市场配置
	 * @author lizhaoning
	 */
	public class MktModConfig
	{
		public static var hasData:Boolean = false;
		
		/**物品大类型*/
		public static var dpItemType1:DataProvider;
		/** 全部等级  */
		public static var dpLevel:DataProvider;
		/** 全部颜色  */
		public static var dpColor:DataProvider;
		/** 职业选择  无"全部职业"标签*/
		public static var dpCareer:DataProvider;
		/** 时间类型 */
		public static var dpTimeType:DataProvider;
		/** 货币类型 */
		public static var dpMoneyType:DataProvider;
		
		/**物品大类型*/
		public static var arrItemType:Array;
		
		public function MktModConfig()
		{
		}
		
		public static  function createData():void
		{
			if(hasData)
			{
				return;
			}
			else
			{
				hasData = true;
			}
			
			
			arrItemType = [];
			dpItemType1 = new DataProvider();
			var index:int = 1;
			for each (var i:Dictionary in MarketConfig.instance.map) 
			{
				var obj:Object = {label:i[1].name1,type:index};
				arrItemType.push(obj);
				
				index++;
			}
			dpItemType1.addItems(arrItemType);
			
			dpTimeType = new DataProvider([
					{label:EMarketTimeType._EMarketTimeTypeEight+"小时",type:0,timeType:EMarketTimeType._EMarketTimeTypeEight},
					{label:EMarketTimeType._EMarketTimeTypeTwentyFour+"小时",type:0,timeType:EMarketTimeType._EMarketTimeTypeTwentyFour},
					{label:EMarketTimeType._EMarketTimeTypeFortyEight+"小时",type:0,timeType:EMarketTimeType._EMarketTimeTypeFortyEight}
				]);
			
			dpMoneyType = new DataProvider([
				{label:GameDefConfig.instance.getEPrictUnitName(EPrictUnit._EPriceUnitCoin),type:0,moneyType:EPrictUnit._EPriceUnitCoin},
				{label:GameDefConfig.instance.getEPrictUnitName(EPrictUnit._EPriceUnitGold),type:1,moneyType:EPrictUnit._EPriceUnitGold}
				]);
			
			
			var arrLevel:Array = [
				{label:"全部等级",type:0,min:0,max:GameConst.PlayerMaxLevel},
				{label:"1-9级",type:1,min:1,max:9},
				{label:"10-19级",type:2,min:10,max:19},
				{label:"20-29级",type:3,min:20,max:29},
				{label:"30-39级",type:4,min:30,max:39},
				{label:"40-49级",type:5,min:40,max:49},
				{label:"50-59级",type:6,min:50,max:59},
				{label:"60级以上",type:7,min:60,max:GameConst.PlayerMaxLevel}
			];
			dpLevel = new DataProvider(arrLevel);
			
			var arrColor:Array=  [
				{label:"全部颜色",type:0,color:-1},
				{label:"白色",type:1,color:EColor._EColorWhite},
				{label:"绿色",type:2,color:EColor._EColorGreen},
				{label:"蓝色",type:3,color:EColor._EColorBlue},
				{label:"紫色",type:4,color:EColor._EColorPurple},
				{label:"橙色",type:5,color:EColor._EColorOrange},
				{label:"金色",type:6,color:EColor._EColorGold},
			];
			dpColor = new DataProvider(arrColor);
			
			var arrProfession:Array = [
				{label:"全部职业",type:0,career:-1},
				{label:GameDefConfig.instance.getCarrer(ECareer._ECareerWarrior),type:1,career:ECareer._ECareerWarrior},
				{label:GameDefConfig.instance.getCarrer(ECareer._ECareerArcher),type:2,career:ECareer._ECareerArcher},
				{label:GameDefConfig.instance.getCarrer(ECareer._ECareerMage),type:3,career:ECareer._ECareerMage},
				{label:GameDefConfig.instance.getCarrer(ECareer._ECareerPriest),type:4,career:ECareer._ECareerPriest},
			];
			dpCareer = new DataProvider();
			dpCareer.addItems(arrProfession);
		}
		
		/**物品小类型*/
		public static function getdpItemType2(index:int):DataProvider
		{
			var dpItemType2:DataProvider = new DataProvider();
			var arr:Array = [];
			var indexxx:int = 1;
			for each (var j:* in MarketConfig.instance.map[index]) 
			{
				var obj:Object = {label:j.name2,type:indexxx,tMarket:j};
				arr.push(obj);
				
				indexxx++;
			}
			dpItemType2.addItems(arr);
			return dpItemType2;
		}
		
		/**
		 * 获取单价 
		 * @param marketItem
		 * @return 
		 */
		public static function getUnitPrice(marketItem:SMarketItem):String
		{
			var price:Number;
			
			var coinRate:int = 10000;
			var goldRate:int = 1;
			var param:int = 10;
			var param2:Number = 0.01;
			
			if(marketItem.code == EPrictUnit._EPriceUnitCoin )  //铜币
			{
				if(marketItem.recordType == EMarketRecordType._EMarketRecordSell)
				{
					price = marketItem.sellPrice / (marketItem.amount/coinRate);
//					price = (int(marketItem.sellPrice/(marketItem.amount/CoinRate)*100))/100;
					
					return dealPrice(price)+":"+coinRate.toString();
				}
				else if(marketItem.recordType == EMarketRecordType._EMarketRecordSeekBuy)
				{
					return marketItem.sellPrice.toString() +":"+ coinRate.toString();
				}
			}
			else if(marketItem.code == EPrictUnit._EPriceUnitGold )  //元宝
			{
				
				if(marketItem.recordType == EMarketRecordType._EMarketRecordSell)
				{
//					price = (int(marketItem.sellPrice*1.0/marketItem.amount*100))/100;
					price = marketItem.sellPrice/marketItem.amount;
					return dealPrice(price)+":"+goldRate.toString();
				}
				else if(marketItem.recordType == EMarketRecordType._EMarketRecordSeekBuy)
				{
					return marketItem.sellPrice.toString()+":"+goldRate.toString();
				}
			}
			else
			{
//				price = marketItem.sellPrice/marketItem.amount;
//				return price.toString();
				if(marketItem.recordType == EMarketRecordType._EMarketRecordSell)
				{
					price = marketItem.sellPrice/marketItem.amount;
					return dealPrice(price);
				}
				else if(marketItem.recordType == EMarketRecordType._EMarketRecordSeekBuy)
				{
					return marketItem.sellPrice.toString();
				}
			}
			return "";
			
			function dealPrice(num:Number):String
			{
				if(num > param)  //大于 param就取整
				{
					num = int(num);
				}
				else if(num < param2) //小于 param2就 直接显示 0.01
				{
					num = param2;
				}
				else  //保留两位小数
				{
					num = int(num * 100)/100;
				}
				return num.toString();
			}
		}
		
		/**
		 * 获取总价 
		 * @param marketItem
		 * @return 
		 */
		public static function getTotalPrice(marketItem:SMarketItem):String
		{
			if(marketItem.recordType == EMarketRecordType._EMarketRecordSell)
			{
				return marketItem.sellPrice.toString();
			}
			
			
			if(marketItem.code == EPrictUnit._EPriceUnitCoin )  //铜币
			{
				return (marketItem.sellPrice * marketItem.amount/10000).toString();
			}
			else
			{
				return (marketItem.sellPrice * marketItem.amount).toString();
			}
		}
		
		/** 广播消耗的铜币数量 */
		public static function get BroadcastCost():int
		{
			return GameConst.MarketBroadcastCost;
		}
		
		/**
		 * 获得寄售(求购)所收手续费 
		 * @param time  寄售(求购)选择的时间
		 * @param moneyType  货币类型
		 * @param price  价格
		 * @return 
		 */
		public static function getTax(time:int,moneyType:int,price:Number):int
		{
			var num:int;
			if(moneyType == EPrictUnit._EPriceUnitCoin)
			{
				num = Math.ceil(price/100.0) * getRate(time);
			}
			else if(moneyType == EPrictUnit._EPriceUnitGold)
			{
				num = price*10 * getRate(time);
			}
			
			return Math.max(num , GameConst.MarketMinFee);
			//ratio
			function getRate(time:int):int
			{
				if(time == EMarketTimeType._EMarketTimeTypeEight)
					return 1;
				if(time == EMarketTimeType._EMarketTimeTypeTwentyFour)
					return 2;
				if(time == EMarketTimeType._EMarketTimeTypeFortyEight)
					return 3;
				return 1;
			}
		}
	}
}