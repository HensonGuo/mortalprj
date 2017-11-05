package mortal.game.view.shopMall.data
{
	import Message.DB.Tables.TShopPanicBuyItem;
	import Message.Game.SPanicBuyItemMsg;
	
	import mortal.game.resource.tableConfig.ShopConfig;

	public class ShopPanicData
	{
		private var _sPanicBuyItem:SPanicBuyItemMsg;  //接受服务器的数据(抢购的物品才有)
		
		private var _tShopPanicSell:TShopPanicBuyItem;  //配置表数据
		
		private var _shopCode:int;  //商店code
		
		public var limitNum:int;
		
		public function ShopPanicData(data:* , shopCode:int = 0)
		{
			if(data is SPanicBuyItemMsg)
			{
				_shopCode = shopCode;
				this.sPanicBuyItem = data;
			}
			else if(data is int)
			{
				_shopCode = shopCode;
				_tShopPanicSell = ShopConfig.instance.getPanicShopSellInfoByKey(_shopCode + "_" + data);
			
			}
			else if(data is TShopPanicBuyItem)
			{
				_tShopPanicSell = data;
				_shopCode = _tShopPanicSell.code;
			}
		}
		
		public function set sPanicBuyItem(data:SPanicBuyItemMsg):void
		{
			_sPanicBuyItem = data;
			_tShopPanicSell = ShopConfig.instance.getPanicShopSellInfoByKey(_shopCode + "_" + _sPanicBuyItem.index);
			//			limitNum = _sPanicBuyItem.buyLimit;
		}
		
		public function get sPanicBuyItem():SPanicBuyItemMsg
		{
			return _sPanicBuyItem;
		}
		
		
		public function get tShopPanic():TShopPanicBuyItem
		{
			return _tShopPanicSell;
		}
		
		public function set tShopPanic(value:TShopPanicBuyItem):void
		{
			_tShopPanicSell = value;
		}
	}
}