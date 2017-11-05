package mortal.game.view.shopMall.view
{
	import Message.DB.Tables.TShopSell;
	
	import com.mui.controls.GSprite;
	import com.mui.controls.GTileList;
	
	import fl.data.DataProvider;
	
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.shopMall.data.ShopItemData;
	
	public class ShopCommonPanel extends GSprite
	{
		protected var _goodsList:GTileList;
		
		public function ShopCommonPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_goodsList = UIFactory.tileList(0,0,680,440,this);
			_goodsList.columnWidth = 220;
			_goodsList.rowHeight = 105;
			_goodsList.horizontalGap = 10;
			_goodsList.verticalGap = 2;
			_goodsList.setStyle("cellRenderer", GoodsCellRenderer);
			_goodsList.isCanSelect = false;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_goodsList.dispose(isReuse);
			
			_goodsList = null;
			
			super.disposeImpl(isReuse);
		}
		
		public function getShopItems(page:int = 1):void
		{
//			_goodsList.dataProvider = getBuyDataProvider(page);
		}
		
		public function getItemsByTabAndPage(tab:String , page:int = 1):void
		{
			_goodsList.dataProvider = getBuyDataProvider(tab,page);
		}
		
		private function getBuyDataProvider(tab:String , page:int):DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var items:Vector.<TShopSell> = getItemsList(tab);
			var showIndex:int;
			if(tab == "button1")
			{
				showIndex = 4;
			}
			else
			{
				showIndex = 12;
			}
			
			if(items)
			{
				var starIndex:int = showIndex * (page - 1);
				var endIndex:int;
				if(showIndex * page <= items.length)
				{
					endIndex = showIndex * page;
				}
				else
				{
					endIndex = items.length;
				}
				
				for(var i:int = starIndex ; i < endIndex ; i++)
				{
					var shopPropData:ShopItemData = new ShopItemData(items[i]);
					var obj:Object = {data:shopPropData};
					dataProvider.addItem(obj);
				}
			}
			
			return dataProvider;
		}
		
		private function getItemsList(tab:String):Vector.<TShopSell>
		{
			switch(tab)
			{
				case "button1":
					return ShopConfig.instance.hotBuyList;break;
				case "button2":
					return ShopConfig.instance.usuallyList;break;
				case "button3":
					return ShopConfig.instance.paterialList;break;
				case "button4":
					return ShopConfig.instance.petList;break;
				case "button5":
					return ShopConfig.instance.medList;break;
				case "button6":
					return ShopConfig.instance.vipList;break;
				case "button7":
					return ShopConfig.instance.preferentialList;break;
				default:
					return null;
			}
		}
	}
}