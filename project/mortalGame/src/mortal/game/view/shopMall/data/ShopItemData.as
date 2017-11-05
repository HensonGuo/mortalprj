package mortal.game.view.shopMall.data
{
	import Message.DB.Tables.TShop;
	import Message.DB.Tables.TShopSell;
	import Message.Game.SPanicBuyItemMsg;
	
	import mortal.game.resource.ConfigCenter;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.configBase.ConfigConst;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.resource.tableConfig.ShopConfig;

	/**
	 * 商品结构 
	 * @author Administrator
	 * 
	 */	
	public class ShopItemData
	{
		private var _tShopSell:TShopSell;  //配置表数据
		
		private var _tShop:TShop; //商店配置表
		
		private var _itemInfo:ItemInfo;  //物品配置表
		
		/**
		 * 购买物品的数量(需要调用购买接口时才需赋值) 
		 */		
		public var num:int;
		
		public function ShopItemData(data:*)  //data可以是itemCode或者TshopSell
		{
			if(data is int)    
			{
				_tShopSell = ShopConfig.instance.getShopSellInfoById(data);
			}
			else if(data is TShopSell)
			{
				_tShopSell = data;
			}
		}
		
		public function get currentPrice():int
		{
			if(_tShopSell.activeOffer != 0)
			{
				return _tShopSell.activeOffer;
			}
			else if(_tShopSell.offer != 0)
			{
				return _tShopSell.offer;
			}
			else
			{
				return _tShopSell.price;
			}
		}
		
		public function set tShopSell(value:TShopSell):void
		{
			_tShopSell = value;
		}
		
		public function get tShopSell():TShopSell
		{
			return _tShopSell;
		}
		
	    public function get tShop():TShop
		{
			if(_tShop == null)
			{
				_tShop = ShopConfig.instance.getShopById(_tShopSell.shopCode) as TShop;
			}
			return _tShop;
		}
		
		public function get itemInfo():ItemInfo
		{
			if(_itemInfo == null)
			{
				_itemInfo =  ItemConfig.instance.getConfig(_tShopSell.itemCode);
			}
			return _itemInfo;
		}
	}
}